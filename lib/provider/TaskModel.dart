import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todo/model/Task.dart';
import 'package:todo/library/globals.dart' as globals;
import 'package:dart_date/dart_date.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskModel extends ChangeNotifier {
  TaskModel() {
    initSate();
  }
  void initSate() {
    loadTasksFromCache();
  }

  final List<Task> _doneTasks = [];
  final Map<String, List<Task>> _todoTasks = {
    globals.late: [],
    globals.today: [],
    globals.tomorrow: [],
    globals.thisWeek: [],
    globals.nextWeek: [],
    globals.thisMonth: [],
    globals.later: [],
  };

  Map<String, List<Task>> get todoTasks => _todoTasks;
  List<Task> get doneTasks => _doneTasks;

  void add(Task _task) {
    print("id: " + _task.id);
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

  void markAsDone(String key, Task _task) {
    _doneTasks.add(_task);
    syncDoneTaskToCache(_task);
    _todoTasks[key]!.removeWhere((element) => element.id == _task.id);

    print("Done Tasks:" + _doneTasks.map((task) => task.title).toString());
    notifyListeners();
  }

  void markAsChecked(String key, int index) {
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
    List<Task> _tasksList = [];
    if (prefs.containsKey(globals.todoTasksKey)) {
      final String? data = prefs.getString(globals.todoTasksKey);
      List<dynamic> _oldTasks = json.decode(data!);
      _tasksList =
          List<Task>.from(_oldTasks.map((element) => Task.fromJson(element)));
      print(_tasksList);
    }
    _tasksList.add(_task);
    await prefs.setString(globals.todoTasksKey, json.encode(_tasksList));
  }

  void loadTasksFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(globals.todoTasksKey)) {
      final String? data = prefs.getString(globals.todoTasksKey);
      List<dynamic> _oldTasks = json.decode(data!);
      List<Task> _tasksList =
          List<Task>.from(_oldTasks.map((element) => Task.fromJson(element)));
      for (int i = 0; i < _tasksList.length; i++) {
        add(_tasksList[i]);
      }
    }
  }

  void syncDoneTaskToCache(Task _task) async {
    final prefs = await SharedPreferences.getInstance();
    List<Task> _tasksList = [];
    List<Task> _doneList = [];
    // Retrieve all todoTasks from cache
    _tasksList = await getCacheValuesByKey(globals.todoTasksKey);
    // remove todoTask from prefs
    _tasksList.removeWhere((element) => element.id == _task.id);
    // update todoTask cache
    await prefs.setString(globals.todoTasksKey, json.encode(_tasksList));

    // Retrieve all doneTasks from cache
    _doneList = await getCacheValuesByKey(globals.doneTasksKey);
    // add doneTask from prefs
    _doneList.add(_task);
    // update doneTask cache
    await prefs.setString(globals.doneTasksKey, json.encode(_doneList));
    final String? testData = prefs.getString(globals.doneTasksKey);
    print(testData!);

  }

  Future<List<Task>> getCacheValuesByKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      final String? data = prefs.getString(key);
      List<dynamic> _oldTasks = json.decode(data!);
      return List<Task>.from(
          _oldTasks.map((element) => Task.fromJson(element)));
    }
    return [];
  }
}
