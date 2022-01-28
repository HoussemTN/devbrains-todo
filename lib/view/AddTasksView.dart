
import 'package:flutter/material.dart';

class AddTasksView extends StatelessWidget {
  const AddTasksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new Task"),
      ),
    );
  }
}
