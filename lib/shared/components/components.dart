import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget defaultFormField({
  @required TextEditingController controller,
  @required TextInputType type,
  Function onChange,
  Function onTap,
  Function onSubmit,
  @required Function validate,
  @required String label,
  @required IconData prefix,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        border: OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model, context) {
  return Dismissible(
    direction: DismissDirection.endToStart,
    background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete,
          size: 40.0,
          color: Colors.white,
        ),
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20),
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    ),
    key: Key(model['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            child: Text('${model['time']}'),
          ),
          SizedBox(
            width: 15.0,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model['title']}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18.0),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  '${model['date']}',
                  style: TextStyle(color: Colors.grey[500]),
                )
              ],
            ),
          ),
          SizedBox(
            width: 15,
          ),
          IconButton(
              icon: Icon(
                Icons.check_box,
                color: Colors.green,
              ),
              onPressed: () {
                AppCubit.get(context).updateData('done', model['id']);
              }),
          IconButton(
              icon: Icon(
                Icons.archive,
                color: Colors.black45,
              ),
              onPressed: () {
                AppCubit.get(context).updateData('archive', model['id']);
              }),
        ],
      ),
    ),
    onDismissed: (direction) {
      AppCubit.get(context).deleteData(model['id']);
    },
  );
}

Widget taskBuilder(List<Map> tasks) {
  if (tasks.isEmpty)
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            size: 100.0,
            color: Colors.grey,
          ),
          Text(
            'No Tasks Yet, Please Add Some Tasks',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 16.0),
          )
        ],
      ),
    );
  else
    return ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              width: double.infinity,
              height: 1.0,
              color: Colors.grey,
            ),
        itemCount: tasks.length);
}
