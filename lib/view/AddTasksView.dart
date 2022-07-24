import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo/library/globals.dart' as globals;
import 'package:todo/model/Task.dart';
import 'package:todo/provider/TaskModel.dart';
class AddTasksView extends StatefulWidget {
  const AddTasksView({Key? key}) : super(key: key);

  @override
  State<AddTasksView> createState() => _AddTasksViewState();
}

class _AddTasksViewState extends State<AddTasksView> {
  DateTime _selectedDay = DateTime.now();

  DateTime _focusedDay = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
     return Consumer<TaskModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Add new Task"),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(children: <Widget>[
                    TableCalendar(
                      calendarFormat: CalendarFormat.week,
                      firstDay: DateTime.utc(2022, 1, 1),
                      lastDay: DateTime.utc(2050, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay =
                              focusedDay; // update `_focusedDay` here as well
                        });
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, datetime, events) {
                            return model.countTasksByDate(datetime) >0 ?Container(
                              width: 20,
                              height: 15,
                              decoration: BoxDecoration(
                                  color: globals.primaries[model.countTasksByDate(datetime)],
                                  borderRadius: BorderRadius.circular(4.0)
                              ),
                              child: Center(
                                child: Text(model.countTasksByDate(datetime).toString(),
                                style: TextStyle(color: Colors.white)),
                              ),
                            ): Container();
                          },
                          selectedBuilder: (context, _datetime, focusedDay) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(4.0)
                              ),
                              margin: EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 10.0),
                              child: Center(
                                child: Text(_datetime.day.toString(),
                                  style: TextStyle(color: Colors.white),),
                              ),
                            );
                          }
                      ),

                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: TextFormField(
                        controller: _titleController,
                        maxLength: 100,
                        decoration: InputDecoration(
                          hintText: "Enter Task Title",
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2.0
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2.0
                              )
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2.0
                              )
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2.0
                              )
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextFormField(
                        controller: _descriptionController,
                        maxLength: 500,
                        minLines: 3,
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText: "Enter Task Description (optional)",
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2.0
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2.0
                              )
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2.0
                              )
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2.0
                              )
                          ),
                        ),

                      ),
                    ),
                  ]),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.done),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Task _newTask = Task(
                      _titleController.text, false, _descriptionController.text,
                      _focusedDay);
                  model.add(_newTask);
                  model.addTaskToCache(_newTask);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task saved...')),
                  );
                  Navigator.pushReplacementNamed(context, 'listTasks');
                }
              },
            ),
          );
        }
    );
  }
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
