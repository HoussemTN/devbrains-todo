import 'package:flutter/material.dart';
import 'package:todo/model/Task.dart';

class TaskModel extends ChangeNotifier {

  final List<Task> _todoTasks = [
    Task("Task 1",false,"Create Provider",DateTime.now().add(Duration(days: 1))),
    Task("Task 2",false,"Create Provider",DateTime.now().subtract(Duration(days: 1))),
    Task("Task 3",false,"Create Provider",DateTime.now().add(Duration(days: 7))),
    Task("Task 4",false,"Create Provider",DateTime.now().add(Duration(days: 2))),
  ];

  List<Task> get todoTasks => _todoTasks;
  void add(Task _task){
    _todoTasks.add(_task);
    notifyListeners();
  }
  int countTasksByDate(DateTime _datetime) => _todoTasks.where((task) =>
  task.deadline.day== _datetime.day &&
  task.deadline.month== _datetime.month &&
  task.deadline.year== _datetime.year
  ).length;
  void markAsDone(int index){
    _todoTasks[index].status=true;
    notifyListeners();
  }

}
