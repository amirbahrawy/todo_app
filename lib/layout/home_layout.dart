import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AppCubit()..createDatabase(),
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            if (state is AppInsertDatabaseState) {
              Navigator.pop(context);
              titleController.clear();
              timeController.clear();
              dateController.clear();
            }
          },
          builder: (context, state) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
                key: scaffoldKey,
                appBar: AppBar(
                  title: Text(cubit.titles[cubit.currentIndex]),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    if (cubit.isBottomSheetShown) {
                      if (formKey.currentState.validate()) {
                        cubit.insertToDatabase(
                            title: titleController.text,
                            date: dateController.text,
                            time: timeController.text);
                      }
                    } else {
                      scaffoldKey.currentState
                          .showBottomSheet(
                              (context) => Container(
                                    padding: EdgeInsets.all(20.0),
                                    color: Colors.white,
                                    child: Form(
                                      key: formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          defaultFormField(
                                              controller: titleController,
                                              type: TextInputType.text,
                                              validate: (String value) {
                                                if (value.isEmpty) {
                                                  return 'title must not be empty';
                                                }
                                                return null;
                                              },
                                              label: ' Task Title',
                                              prefix: Icons.title),
                                          SizedBox(height: 15.0),
                                          defaultFormField(
                                              controller: timeController,
                                              type: TextInputType.datetime,
                                              onTap: () {
                                                showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now())
                                                    .then((value) =>
                                                        timeController.text =
                                                            value.format(
                                                                context));
                                              },
                                              validate: (String value) {
                                                if (value.isEmpty) {
                                                  return 'time must not be empty';
                                                }
                                                return null;
                                              },
                                              label: ' Task Time',
                                              prefix:
                                                  Icons.watch_later_outlined),
                                          SizedBox(height: 15.0),
                                          defaultFormField(
                                              controller: dateController,
                                              type: TextInputType.datetime,
                                              onTap: () {
                                                showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime.now(),
                                                        lastDate:
                                                            DateTime.parse(
                                                                '2022-12-01'))
                                                    .then((value) =>
                                                        dateController
                                                                .text =
                                                            DateFormat.yMMMd()
                                                                .format(value));
                                              },
                                              validate: (String value) {
                                                if (value.isEmpty) {
                                                  return 'date must not be empty';
                                                }
                                                return null;
                                              },
                                              label: 'Task Date',
                                              prefix: Icons.calendar_today)
                                        ],
                                      ),
                                    ),
                                  ),
                              elevation: 20.0)
                          .closed
                          .then((value) {
                        cubit.changeBottomSheetState(
                            isShown: false, icon: Icons.edit);
                      });
                      cubit.changeBottomSheetState(
                          isShown: true, icon: Icons.add);
                    }
                  },
                  child: Icon(cubit.fabIcon),
                ),
                body: cubit.screens[cubit.currentIndex],
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: cubit.currentIndex,
                  onTap: (index) {
                    cubit.changeIndex(index);
                  },
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.menu), label: 'Tasks'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.check_circle_outline), label: 'Done'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.archive_outlined), label: 'Archived'),
                  ],
                ));
          },
        ));
  }
}
