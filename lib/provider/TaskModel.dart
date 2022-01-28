import 'package:flutter/material.dart';
import 'package:todo/model/Task.dart';

class CartModel extends ChangeNotifier {

  final List<Task> _todoTasks = [
    Task("Task 1",false,"Create Provider",DateTime.now().add(Duration(days: 1))),
    Task("Task 1",false,"Create Provider",DateTime.now().subtract(Duration(days: 1))),
    Task("Task 1",false,"Create Provider",DateTime.now().add(Duration(days: 7))),
    Task("Task 1",false,"Create Provider",DateTime.now().add(Duration(days: 2))),
  ];

  List<Task> get todoTasks => _todoTasks;


}
