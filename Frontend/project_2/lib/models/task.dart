import 'dart:convert';

Task taskFromJson(String str) => Task.fromJson(json.decode(str));

String taskToJson(Task data) => json.encode(data.toJson());

class Task {
    int taskId;
    String taskName;
    String taskDesc;
    int taskPoints;
    int weekId;
    int selectedDaysId;

    Task({
        required this.taskId,
        required this.taskName,
        required this.taskDesc,
        required this.taskPoints,
        required this.weekId,
        required this.selectedDaysId,
    });

    factory Task.fromJson(Map<String, dynamic> json) => Task(
        taskId: json["taskId"],
        taskName: json["taskName"],
        taskDesc: json["taskDesc"],
        taskPoints: json["taskPoints"],
        weekId: json["weekId"],
        selectedDaysId: json["selectedDaysId"],
    );

    Map<String, dynamic> toJson() => {
        "taskId": taskId,
        "taskName": taskName,
        "taskDesc": taskDesc,
        "taskPoints": taskPoints,
        "weekId": weekId,
        "selectedDaysId": selectedDaysId,
    };
}
