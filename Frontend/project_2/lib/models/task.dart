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
    String familyGroupId;

    Task({
        required this.taskId,
        required this.taskName,
        required this.taskDesc,
        required this.taskPoints,
        required this.weekId,
        required this.selectedDaysId,
        required this.familyGroupId,
    });

    factory Task.fromJson(Map<String, dynamic> json) => Task(
        taskId: json["taskId"],
        taskName: json["taskName"],
        taskDesc: json["taskDesc"],
        taskPoints: json["taskPoints"],
        weekId: json["weekId"],
        selectedDaysId: json["selectedDaysId"],
        familyGroupId: json["familyGroupId"],
    );

    Map<String, dynamic> toJson() => {
        "taskId": taskId,
        "taskName": taskName,
        "taskDesc": taskDesc,
        "taskPoints": taskPoints,
        "weekId": weekId,
        "selectedDaysId": selectedDaysId,
        "familyGroupId": familyGroupId,
    };
}
