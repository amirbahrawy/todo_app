import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class ArchiveTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
return BlocConsumer<AppCubit, AppStates>(
  listener: (context, state) {},
  builder: (context, state) {
    var tasks = AppCubit.get(context).archiveTasks;
    return ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index],context),
        separatorBuilder: (context, index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          width: double.infinity,
          height: 1.0,
          color: Colors.grey,
        ),
        itemCount: tasks.length);
  },
);  }
}
