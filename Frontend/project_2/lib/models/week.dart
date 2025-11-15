import 'dart:convert';

Week weekFromJson(String str) => Week.fromJson(json.decode(str));

String weekToJson(Week data) => json.encode(data.toJson());

class Week {
    int weekId;
    int weekNo;
    DateTime monday;
    DateTime tuesday;
    DateTime wednesday;
    DateTime thursday;
    DateTime friday;
    DateTime saturday;
    DateTime sunday;
    int rewardId;

    Week({
        required this.weekId,
        required this.weekNo,
        required this.monday,
        required this.tuesday,
        required this.wednesday,
        required this.thursday,
        required this.friday,
        required this.saturday,
        required this.sunday,
        required this.rewardId,
    });

    factory Week.fromJson(Map<String, dynamic> json) => Week(
        weekId: json["weekId"],
        weekNo: json["weekNo"],
        monday: DateTime.parse(json["monday"]),
        tuesday: DateTime.parse(json["tuesday"]),
        wednesday: DateTime.parse(json["wednesday"]),
        thursday: DateTime.parse(json["thursday"]),
        friday: DateTime.parse(json["friday"]),
        saturday: DateTime.parse(json["saturday"]),
        sunday: DateTime.parse(json["sunday"]),
        rewardId: json["rewardId"],
    );

    Map<String, dynamic> toJson() => {
        "weekId": weekId,
        "weekNo": weekNo,
        "monday": monday.toIso8601String(),
        "tuesday": tuesday.toIso8601String(),
        "wednesday": wednesday.toIso8601String(),
        "thursday": thursday.toIso8601String(),
        "friday": friday.toIso8601String(),
        "saturday": saturday.toIso8601String(),
        "sunday": sunday.toIso8601String(),
        "rewardId": rewardId,
    };
}
