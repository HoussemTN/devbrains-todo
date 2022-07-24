import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todo/model/Task.dart';
import 'package:todo/library/globals.dart' as globals;
import 'package:dart_date/dart_date.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskModel extends ChangeNotifier {

  final Map<String,List<Task>> _todoTasks = {
    globals.late:[],
    globals.today:[],
    globals.tomorrow:[],
    globals.thisWeek:[],
    globals.nextWeek:[],
    globals.thisMonth:[],
    globals.later:[],
  };

  Map<String, List<Task>> get todoTasks => _todoTasks;

  void add(Task _task) {
    String _key = guessTodoKeyFromDate(_task.deadline);
    if (_todoTasks.containsKey(_key)) {
      _todoTasks[_key]!.add(_task);
      addTaskToCache(_task);
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

  void addTaskToCache(Task _task) async {
    final prefs = await SharedPreferences.getInstance();
    List<Task> _tasksList=[];
    if(prefs.containsKey(globals.todoTasksKey)){
      final String? data = prefs.getString(globals.todoTasksKey);
      List<dynamic> _oldTasks= json.decode(data!);
      _tasksList = List<Task>.from(_oldTasks.map((element)=>Task.fromJson(element)));
      print(_tasksList);
    }
    _tasksList.add(_task);
    await prefs.setString(globals.todoTasksKey, json.encode(_tasksList));


  }

}
