


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/TaskModel.dart';

class ListTasksView extends StatefulWidget {
  const ListTasksView({Key? key}) : super(key: key);

  @override
  _ListTasksViewState createState() => _ListTasksViewState();
}

class _ListTasksViewState extends State<ListTasksView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("List Tasks"),
            ),
            body: ListView.builder(
              itemCount:model.todoTasks.length,
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
                        title: Text(model.todoTasks[index].title),
                        subtitle: Text(model.todoTasks[index].deadline.toString()),
                        value: model.todoTasks[index].status,
                        onChanged: (bool? value) {
                          model.markAsDone(index);
                          print(model.todoTasks[index].status);
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  );
              },

            ),
          );
        }
    );
  }
}
