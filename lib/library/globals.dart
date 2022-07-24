
import 'package:flutter/material.dart';

const List<MaterialColor> primaries = <MaterialColor>[

  Colors.cyan,
  Colors.green,
  Colors.lightGreen,
  Colors.teal,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.pink,
  Colors.red,
];

const late='late';
const today='today';
const tomorrow='tomorrow';
const thisWeek='thisWeek';
const nextWeek='nextWeek';
const thisMonth='thisMonth';
const later='later';
const Map<String,String>taskCategoryNames = {late:'Late',today:'Today',tomorrow:'Tomorrow',thisWeek:'This week',nextWeek:'Next Week',thisMonth:'This month',later:'Later'};

// Shared Preferences Keys
const todoTasksKey ="todo_tasks";