import 'dart:convert';

CompletedTask completedTaskFromJson(String str) => CompletedTask.fromJson(json.decode(str));

String completedTaskToJson(CompletedTask data) => json.encode(data.toJson());

class CompletedTask {
    int taskId;
    int familyMemberId;
    DateTime timeCompleted;

    CompletedTask({
        required this.taskId,
        required this.familyMemberId,
        required this.timeCompleted,
    });

    factory CompletedTask.fromJson(Map<String, dynamic> json) => CompletedTask(
        taskId: json["taskId"],
        familyMemberId: json["familyMemberId"],
        timeCompleted: DateTime.parse(json["timeCompleted"]),
    );

    Map<String, dynamic> toJson() => {
        "taskId": taskId,
        "familyMemberId": familyMemberId,
        "timeCompleted": timeCompleted.toIso8601String(),
    };
}
