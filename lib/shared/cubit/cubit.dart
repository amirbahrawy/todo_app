import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archive_tasks.dart';
import 'package:todo_app/modules/done_tasks.dart';
import 'package:todo_app/modules/new_tasks.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  int currentIndex = 0;
  Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchiveTasksScreen()
  ];
  List<String> titles = ['New Tasks', 'Done Tasks', 'Archive Taks'];

  void changeIndex(index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (Database db, version) async {
      print('Database is created');
      await db
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) => ('table created'))
          .catchError(
              (error) => ('error when creating table is ${error.toString()}'));
    }, onOpen: (db) {
      getDataFromDatabase(db);

      print('database is opened');
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({@required title, @required date, @required time}) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value Inserted Successfully');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) => ('error is ${error.toString()}'));
      return null;
    });
  }

  void getDataFromDatabase(Database db)  {
    newTasks=[];
    doneTasks=[];
    archiveTasks=[];
      db.rawQuery('SELECT * FROM tasks').then((value) {
        value.forEach((element) {
          if(element['status']=='new')
            newTasks.add(element);
          else if(element['status']=='done')
            doneTasks.add(element);
          else if(element['status']=='archive')
            archiveTasks.add(element);
        });
        emit(AppGetDatabaseState());
      });
  }

  void updateData(String status, int id) {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }
  void deleteData(int id) {
    database.rawDelete('DELETE FROM tasks WHERE id= ?',[id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }
  void changeBottomSheetState(
      {@required bool isShown, @required IconData icon}) {
    isBottomSheetShown = isShown;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
