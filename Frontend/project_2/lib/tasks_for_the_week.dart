import 'package:project_2/models/reward.dart';
import 'package:project_2/models/selected_days.dart';
import 'package:project_2/models/task.dart';
import 'package:project_2/models/week.dart';
import 'dart:convert';

TasksForTheWeek tasksForTheWeekFromJson(String str) => TasksForTheWeek.fromJson(json.decode(str));

String tasksForTheWeekToJson(TasksForTheWeek data) => json.encode(TasksForTheWeek.toJson(data));

class TasksForTheWeek {
    List<Week>? weeks;
    List<Task>? tasks;
    List<List<DateTime>>? dates;
    List<SelectedDays>? selectedDays;
    List<Reward>? rewards;
    DateTime? monday;
    DateTime? sunday;

    TasksForTheWeek({
        this.weeks,
        this.tasks,
        this.dates,
        this.selectedDays,
        this.rewards,
        this.monday,
        this.sunday,
    });

    factory TasksForTheWeek.fromJson(Map<String, dynamic> json) => TasksForTheWeek(
        weeks: json["weeks"] == null? null : List<Week>.from(json["weeks"].map((x) => Week.fromJson(x))),
        tasks: json["tasks"] == null? null : List<Task>.from(json["tasks"].map((x) => Task.fromJson(x))),
        dates: json["dates"] == null? null : List<List<DateTime>>.from(json["dates"].map((x) => List<DateTime>.from(x.map((x) => DateTime.parse(x))))),
        selectedDays: json["selectedDays"] == null? null : List<SelectedDays>.from(json["selectedDays"].map((x) => SelectedDays.fromJson(x))),
        rewards: json["rewards"] == null? null : List<Reward>.from(json["rewards"].map((x) => Reward.fromJson(x))),
        monday: json["monday"] == null? null : DateTime.parse(json["monday"]),
        sunday: json["sunday"] == null? null : DateTime.parse(json["sunday"]),
    );

    static List<List<String>> getDatesAsStrings(List<List<DateTime>>? dates){
    List<List<String>> datesAsStrings = [];

    for(int i = 0; i < dates!.length; i++){
      List<String> das = [];
      List<DateTime> convertDates = dates.elementAt(i);
      for(int j = 0; j < convertDates.length; j++){
        var date = convertDates.elementAt((j));
        das.add(date.toIso8601String());
      }

      datesAsStrings.add(das);
    }

    return datesAsStrings;
  }

  static List<dynamic> getSelectedDaysInJson(List<SelectedDays>? list){
    List<dynamic> convertedSelectedDays = [];

    for(int i = 0; i < list!.length; i++){
      var converted = selectedDaysToJson(list[i]);
      convertedSelectedDays.add((converted));
    }

    return convertedSelectedDays;
  }

    static Map<String, dynamic> toJson(TasksForTheWeek wt) => {
    'weeks': wt.weeks,
    'tasks': wt.tasks,
    'dates': wt.dates == null ? null : getDatesAsStrings(wt.dates) ,
    'selectedDays': wt.selectedDays == null ? null : List<dynamic>.from(wt.selectedDays!.map((x) => x.toJson())),
    'rewards': wt.rewards,
    'monday': wt.monday?.toIso8601String(),
    'sunday': wt.sunday?.toIso8601String()
  };

  
}