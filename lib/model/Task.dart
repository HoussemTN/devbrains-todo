import 'package:uuid/uuid.dart';

class Task{
  String id = Uuid().v1();
  String title;
  bool status;
  String description;
  DateTime deadline;
  Task(this.title,this.status,this.description,this.deadline);


  Map<String,dynamic> toJson(){
    return {
      "id":id,
      "title":title,
      "status":status,
      "description":description,
      "deadline":deadline.toIso8601String(),
    };
  }

  Task.fromJson(Map<String,dynamic> json):
        id=json['id'],
        title=json['title'],
        status=json['status'],
        description=json['description'],
        deadline=DateTime.tryParse(json['deadline'])!;



}