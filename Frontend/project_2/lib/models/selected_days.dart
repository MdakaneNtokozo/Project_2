import 'dart:convert';

SelectedDays selectedDaysFromJson(String str) => SelectedDays.fromJson(json.decode(str));

String selectedDaysToJson(SelectedDays data) => json.encode(data.toJson());

class SelectedDays {
    int selectedDaysId;
    DateTime monday;
    DateTime tuesday;
    DateTime wednesday;
    DateTime thursday;
    DateTime friday;
    DateTime saturday;
    DateTime sunday;

    SelectedDays({
        required this.selectedDaysId,
        required this.monday,
        required this.tuesday,
        required this.wednesday,
        required this.thursday,
        required this.friday,
        required this.saturday,
        required this.sunday,
    });

    factory SelectedDays.fromJson(Map<String, dynamic> json) => SelectedDays(
        selectedDaysId: json["selectedDaysId"],
        monday: DateTime.parse(json["monday"]),
        tuesday: DateTime.parse(json["tuesday"]),
        wednesday: DateTime.parse(json["wednesday"]),
        thursday: DateTime.parse(json["thursday"]),
        friday: DateTime.parse(json["friday"]),
        saturday: DateTime.parse(json["saturday"]),
        sunday: DateTime.parse(json["sunday"]),
    );

    Map<String, dynamic> toJson() => {
        "selectedDaysId": selectedDaysId,
        "monday": monday.toIso8601String(),
        "tuesday": tuesday.toIso8601String(),
        "wednesday": wednesday.toIso8601String(),
        "thursday": thursday.toIso8601String(),
        "friday": friday.toIso8601String(),
        "saturday": saturday.toIso8601String(),
        "sunday": sunday.toIso8601String(),
    };
}
