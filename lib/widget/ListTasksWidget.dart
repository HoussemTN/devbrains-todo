
import 'package:provider/provider.dart';
import 'package:todo/provider/TaskModel.dart';
import 'package:flutter/material.dart';
import 'package:todo/library/globals.dart' as globals;

class ListTasksWidget extends StatelessWidget {
  const ListTasksWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(
        builder: (context, model, child) {
          return ListView.builder(
        itemCount:model.todoTasks[globals.later]!.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xFFE2E2E2),
                  border: Border.all(
                    color: Color(0xFFE2E2E2),
                  ),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: CheckboxListTile(
                title: Text(model.todoTasks[globals.later]![index].title),
                subtitle: Text(model.todoTasks[globals.later]![index].deadline.toString()),
                value: model.todoTasks[globals.later]![index].status,
                onChanged: (bool? value) {
                  model.markAsDone(globals.later,index);
                  print(model.todoTasks[globals.later]![index].status);
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
          );
        },

      );
    }
    );
  }
}
