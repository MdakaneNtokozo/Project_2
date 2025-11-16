import 'package:project_2/models/reward.dart';
import 'package:project_2/models/selected_days.dart';
import 'package:project_2/models/task.dart';
import 'package:project_2/models/week.dart';

class TasksForTheWeek {
  List<Week>? weeks;
  List<Task>? tasks;
  List<List<DateTime>>? dates;
  List<SelectedDays>? selectedDays;
  List<Reward>? rewards;
  DateTime? monday;
  DateTime? sunday;

  TasksForTheWeek({
    required this.weeks,
    required this.tasks,
    required this.dates,
    required this.selectedDays,
    required this.rewards,
    required this.monday,
    required this.sunday,
  });

  static List<List<String>> getDatesAsStrings(List<List<DateTime>>? dates){
    List<List<String>> datesAsStrings = [];

    for(int i = 0; i < dates!.length; i++){
      List<String> das = [];
      List<DateTime> convertDates = dates.elementAt(i);
      for(int j = 0; j < convertDates.length; j++){
        das.add(convertDates.elementAt(j).toIso8601String());
      }

      datesAsStrings.add(das);
    }

    return datesAsStrings;
  }

  static Map<String, dynamic> toJson(TasksForTheWeek wt) => {
    'weeks': wt.weeks ?? [Week(weekId: -11, weekNo: -11, monday: DateTime(0), tuesday: DateTime(0), wednesday: DateTime(0), thursday: DateTime(0), friday: DateTime(0), saturday: DateTime(0), sunday: DateTime(0), rewardId: -11)],
    'tasks': wt.tasks ?? [Task(taskId: -11, taskName: "", taskDesc: "", taskPoints: -11, weekId: -11, selectedDaysId: -11)],
    'dates': wt.dates == null ? [[DateTime(0).toIso8601String()]]: getDatesAsStrings(wt.dates) ,
    'selectedDays': wt.selectedDays ?? [SelectedDays(selectedDaysId: -11, monday: DateTime(0), tuesday: DateTime(0), wednesday: DateTime(0), thursday: DateTime(0), friday: DateTime(0), saturday: DateTime(0), sunday: DateTime(0))],
    'rewards': wt.rewards ?? [Reward(rewardId: -11, rewardName: "", rewardDesc: "", rewardImg: "")],
    'monday': wt.monday == null ? DateTime(0) : wt.monday!.toIso8601String(),
    'sunday': wt.sunday == null ? DateTime(0) : wt.sunday!.toIso8601String()
  };
}
