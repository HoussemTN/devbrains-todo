import 'package:flutter/material.dart';
import 'package:todo/model/Task.dart';
import 'package:todo/library/globals.dart' as globals;
import 'package:dart_date/dart_date.dart';

class TaskModel extends ChangeNotifier {

  final Map<String,List<Task>> _todoTasks = {
    globals.late:[Task("Task 1",false,"Create Provider",DateTime.now().add(Duration(days: 1)))],
    globals.today:[Task("Today Task 1",false,"Create Provider",DateTime.now().add(Duration(days: 1))),Task("Today Task 2 ",false,"Create Provider",DateTime.now().add(Duration(days: 1)))],
    globals.tomorrow:[Task("Tomorrow Task 1",false,"Create Provider",DateTime.now().add(Duration(days: 1)))],
    globals.thisWeek:[Task(" thisWeek Task 1",false,"Create Provider",DateTime.now().add(Duration(days: 1)))],
    globals.nextWeek:[Task("nextWeek Task 1",false,"Create Provider",DateTime.now().add(Duration(days: 1)))],
    globals.thisMonth:[Task("Task 1",false,"Create Provider",DateTime.now().add(Duration(days: 1)))],
    globals.later:[Task("Task 1",false,"Create Provider",DateTime.now().add(Duration(days: 1)))],
  };

  Map<String, List<Task>> get todoTasks => _todoTasks;

  void add(Task _task) {
    String _key = guessTodoKeyFromDate(_task.deadline);
    if (_todoTasks.containsKey(_key)) {
      _todoTasks[_key]!.add(_task);
      notifyListeners();
    }
  }

  int countTasksByDate(DateTime _datetime) {
    String _key = guessTodoKeyFromDate(_datetime);
    if (_todoTasks.containsKey(_key)) {
      _todoTasks[_key]!
          .where((task) =>
              task.deadline.day == _datetime.day &&
              task.deadline.month == _datetime.month &&
              task.deadline.year == _datetime.year)
          .length;
    }
    return 0;
  }

  void markAsDone(String key, int index) {
    _todoTasks[key]![index].status = true;
    notifyListeners();
  }

  String guessTodoKeyFromDate(DateTime deadline) {
    if (deadline.isPast && !deadline.isToday) {
      return globals.late;
    } else if (deadline.isToday) {
      return globals.today;
    } else if (deadline.isTomorrow) {
      return globals.tomorrow;
    } else if (deadline.getWeek == DateTime.now().getWeek &&
        deadline.year == DateTime.now().year) {
      return globals.thisWeek;
    } else if (deadline.getWeek == DateTime.now().getWeek + 1 &&
        deadline.year == DateTime.now().year) {
      return globals.nextWeek;
    } else if (deadline.isThisMonth) {
      return globals.thisMonth;
    } else {
      return globals.later;
    }
  }

}
