import 'dart:convert';

CompletedTask completedTaskFromJson(String str) => CompletedTask.fromJson(json.decode(str));

String completedTaskToJson(CompletedTask data) => json.encode(data.toJson());

class CompletedTask {
    int taskId;
    int familyMemberId;
    DateTime dayNeededToBeCompleted;
    DateTime dayActuallyCompleted;

    CompletedTask({
        required this.taskId,
        required this.familyMemberId,
        required this.dayNeededToBeCompleted,
        required this.dayActuallyCompleted,
    });

    factory CompletedTask.fromJson(Map<String, dynamic> json) => CompletedTask(
        taskId: json["taskId"],
        familyMemberId: json["familyMemberId"],
        dayNeededToBeCompleted: DateTime.parse(json["dayNeededToBeCompleted"]),
        dayActuallyCompleted: DateTime.parse(json["dayActuallyCompleted"]),
    );

    Map<String, dynamic> toJson() => {
        "taskId": taskId,
        "familyMemberId": familyMemberId,
        "dayNeededToBeCompleted": dayNeededToBeCompleted.toIso8601String(),
        "dayActuallyCompleted": dayActuallyCompleted.toIso8601String(),
    };
}
