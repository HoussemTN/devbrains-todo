import 'package:provider/provider.dart';
import 'package:todo/provider/TaskModel.dart';
import 'package:flutter/material.dart';
import 'package:todo/library/globals.dart' as globals;

class ListAllTasksWidget extends StatelessWidget {
  const ListAllTasksWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(builder: (context, model, child) {
      return ListView.builder(
        itemCount: model.todoTasks.length,
        itemBuilder: (BuildContext context, int index) {
          String key = model.todoTasks.keys.elementAt(index);
          if(model.todoTasks[key]!.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(globals.taskCategoryNames[key]!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: model.todoTasks[key]!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFE2E2E2),
                            border: Border.all(
                              color: Color(0xFFE2E2E2),
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: CheckboxListTile(
                          title:
                          Text(model.todoTasks[key]![index].title),
                          subtitle: Text(model
                              .todoTasks[key]![index].deadline
                              .toString()),
                          value: model.todoTasks[key]![index].status,
                          onChanged: (bool? value) {
                            model.markAsDone(key, index);
                            print(model.todoTasks[key]![index].status);
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                    );
                  },
                )
              ],
            );
          }else{
            return Container();
          }
        },
      );
    });
  }
}
