using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Project_2_API.Helper_classes;
using Project_2_API.Models;
using System.Globalization;
using Task = Project_2_API.Models.Task;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace Project_2_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TasksController : ControllerBase
    {
        Project2DatabaseContext context;
        public TasksController(Project2DatabaseContext _context)
        {
            context = _context;
        }

        [HttpGet]
        [Route("getWeeklyTasks")]
        public async Task<Object> GetWeeklyTasks(int weekId)
        {
            var weeks = await context.Weeks.ToListAsync();
            var week = weeks.Find(w => w.WeekId == weekId);

            if (week != null) {
                var tasks = await context.Tasks.ToListAsync();
                tasks = tasks.FindAll(t => t.WeekId == week.WeekId);

                var selectedDays = await context.SelectedDays.ToListAsync();
                List<SelectedDay> selectedDaysForTasks = [];
                tasks.ForEach(t =>
                {
                    var sd = selectedDays.Find(sday => sday.SelectedDaysId == t.SelectedDaysId);
                    if (sd != null)
                    {
                        selectedDaysForTasks.Add(sd);
                    }
                });

                var rewards = await context.Rewards.ToListAsync();
                var reward = rewards.Find(r => r.RewardId == week.RewardId);

                var weeklyTasks = new Weekly_Tasks()
                {
                    tasks = tasks,
                    selectedDays = selectedDaysForTasks,
                    reward = reward
                };

                return Ok(weeklyTasks);
            }
            else
            {
                return NotFound("The week with id " + weekId + " does does exist");
            }
        }

        [HttpPost]
        [Route("createWeeklyTasks")]
        public Object CreateWeeklyTasks(DateTime monday, DateTime sunday, Weekly_Tasks wt)
        {
            //create a reward entry
            var rewards = context.Rewards.ToList();
            var lastIdx = 0;

            if (rewards.Count > 0)
            {
                lastIdx = rewards.ElementAt(rewards.Count - 1).RewardId + 1;
            }

            var reward = wt.reward;
            var newReward = new Reward();

            if (reward != null)
            {
                newReward.RewardId = lastIdx;
                newReward.RewardName = reward.RewardName;
                newReward.RewardDesc = reward.RewardDesc;
                newReward.RewardImg = reward.RewardImg;

                context.Rewards.Add(newReward);
                context.SaveChanges();
            }
            
            //create the week entry
            var weeks = context.Weeks.ToList();
            if (weeks.Count > 0)
            {
                lastIdx = weeks.ElementAt(weeks.Count - 1).WeekId + 1;
            }

            //Get the week number and dates from Monday to Sunday
            CultureInfo cultrueInfo = CultureInfo.InvariantCulture;
            Calendar calendar = cultrueInfo.Calendar;
            var weekNo = calendar.GetWeekOfYear(monday, CalendarWeekRule.FirstDay, DayOfWeek.Monday);

            List<DateTime> days = [];
            for (DateTime date = monday; date <= sunday; date = date.AddDays(1))
            {
                days.Add(date);
            }

            Week week = new()
            {
                WeekNo = weekNo,
                Monday = days[0],
                Tuesday = days[1],
                Wednesday = days[2],
                Thursday = days[3],
                Friday = days[4],
                Saturday = days[5],
                Sunday = days[6],
                RewardId = newReward.RewardId
            };

            context.Weeks.Add(week);
            context.SaveChanges();

            //create the tasks and their selected dates
            if (wt.tasks != null && wt.dates != null)
            {
                List<Task> tasksSelected = wt.tasks;
                List<List<DateTime>> daysSelected = wt.dates;

                if (tasksSelected != null && daysSelected != null)
                {
                    for (int i = 0; i < tasksSelected.Count; i++)
                    {
                        //Create the selected dates first
                        int selectedDaysId = CreateSelectedDays(daysSelected.ElementAt(i));

                        //Create the tasks 
                        CreateNewTask(tasksSelected.ElementAt(i), week.WeekId, selectedDaysId);
                    }
                }
            }

            return Ok("Weekly tasks have been added");
        }

        private void CreateNewTask(Task taskInfo, int weekId, int selectedDaysId)
        {
            var tasks = context.Tasks.ToList();
            int lastIdx = 0;

            if (tasks.Count > 0)
            {
                lastIdx = tasks.ElementAt(tasks.Count - 1).TaskId;
            }

            var newTask = new Task();
            newTask.TaskId = lastIdx;
            newTask.TaskName = taskInfo.TaskName;
            newTask.TaskDesc = taskInfo.TaskDesc;
            newTask.TaskPoints = taskInfo.TaskPoints;
            newTask.WeekId = weekId;
            newTask.SelectedDaysId = selectedDaysId;

            context.Tasks.Add(newTask);
            context.SaveChanges();
        }

        private int CreateSelectedDays(List<DateTime> selectedDaysForTask)
        {
            var selectedDays = context.SelectedDays.ToList();
            int lastIdx = 0;

            if (selectedDays.Count > 0)
            {
                lastIdx = selectedDays.ElementAt(selectedDays.Count - 1).SelectedDaysId;
            }

            var newSelectedDays = new SelectedDay();
            newSelectedDays.SelectedDaysId = lastIdx;
            newSelectedDays.Monday = selectedDaysForTask.ElementAt(0);
            newSelectedDays.Tuesday = selectedDaysForTask.ElementAt(1);
            newSelectedDays.Wednesday = selectedDaysForTask.ElementAt(2);
            newSelectedDays.Thursday = selectedDaysForTask.ElementAt(3);
            newSelectedDays.Friday = selectedDaysForTask.ElementAt(4);
            newSelectedDays.Saturday = selectedDaysForTask.ElementAt(5);
            newSelectedDays.Sunday = selectedDaysForTask.ElementAt(6);

            context.SelectedDays.Add(newSelectedDays);
            context.SaveChanges();

            return newSelectedDays.SelectedDaysId;
        }

        [HttpPut]
        [Route("updateWeeklyTasks")]
        public Object UpdateWeeklyTasks(int weekId, Weekly_Tasks wt)
        {
            //Get the tasks for the following week id
            var weeks = context.Weeks.ToList();
            var week = weeks.Find(w => w.WeekId == weekId);

            if (week != null)
            {
                //Check if tasks need to be updated
                var tasks = context.Tasks.ToList();
                tasks = tasks.FindAll(t => t.WeekId == week.WeekId);
                int count = tasks.Count;

                var tasksToUpdate = wt.tasks;
                tasksToUpdate?.ForEach(t =>
                    {
                        //Update the tasks
                        var updateTask = tasks.Find(task => task.TaskId == t.TaskId);
                        int currentIdx = tasksToUpdate.IndexOf(t);

                        if (updateTask != null)
                        {
                            //Update the current task
                            UpdateTask(updateTask, t, wt, currentIdx);

                            //remove the current task
                            tasks.Remove(updateTask);
                        }
                        else
                        {
                            //Current task is new. 
                            if (wt.dates != null)
                            {
                                //Create a new entry for the selected days and task
                                var selectedDaysForTask = wt.dates.ElementAt(currentIdx);
                                int selectedDaysId = CreateSelectedDays(selectedDaysForTask);

                                CreateNewTask(t, week.WeekId, selectedDaysId);
                            }
                        }
                    });

                if(tasks.Count > 0)
                {
                    //The following tasks have been removed from the update
                    var completedTasks = context.CompletedTasks.ToList();
                    List<CompletedTask> completedTasksToDelete = [];
                    tasks.ForEach(t =>
                    {
                        var ctToDelete = completedTasks.Find(ct => ct.TaskId == t.TaskId);
                        if (ctToDelete != null)
                        {
                            completedTasksToDelete.Add(ctToDelete);
                        }
                    });

                    context.CompletedTasks.RemoveRange(completedTasksToDelete);
                    context.SaveChanges();

                    context.Tasks.RemoveRange(tasks);
                    context.SaveChanges();
                }
                
                //Check if rewards need to be updated
                var rewards = context.Rewards.ToList();
                var rewardToBeUpdated = wt.reward;

                if(rewardToBeUpdated != null)
                {
                    UpdateReward(rewards, rewardToBeUpdated);
                }

                return Ok("Weekly tasks have been updated");
            }
            else
            {
                return NotFound("The week with id " + weekId + " does does exist");
            }
        }

        private void UpdateTask(Task updateTask, Task t, Weekly_Tasks wt, int currentIdx)
        {
            updateTask.TaskName = t.TaskName;
            updateTask.TaskDesc = t.TaskDesc;
            updateTask.TaskPoints = t.TaskPoints;

            context.Tasks.Update(updateTask);
            context.SaveChanges();

            //Update the selected days
            if (wt.dates != null)
            {
                var selectedDaysToUpdate = context.SelectedDays.ToList().Find(sd => sd.SelectedDaysId == updateTask.SelectedDaysId);
                var selectedDays = wt.dates.ElementAt(currentIdx);

                if (selectedDaysToUpdate != null)
                {
                    selectedDaysToUpdate.Monday = selectedDays.ElementAt(0);
                    selectedDaysToUpdate.Tuesday = selectedDays.ElementAt(1);
                    selectedDaysToUpdate.Wednesday = selectedDays.ElementAt(2);
                    selectedDaysToUpdate.Thursday = selectedDays.ElementAt(3);
                    selectedDaysToUpdate.Friday = selectedDays.ElementAt(4);
                    selectedDaysToUpdate.Saturday = selectedDays.ElementAt(5);
                    selectedDaysToUpdate.Sunday = selectedDays.ElementAt(6);

                    context.SelectedDays.Update(selectedDaysToUpdate);
                    context.SaveChanges();
                }
            }
        }

        private void UpdateReward(List<Reward> rewards, Reward rewardToBeUpdated)
        {
            var updateReward = rewards.Find(r => r.RewardId == rewardToBeUpdated.RewardId);
            if (updateReward != null)
            {
                updateReward.RewardName = rewardToBeUpdated.RewardName;
                updateReward.RewardDesc = rewardToBeUpdated.RewardDesc;
                updateReward.RewardImg = rewardToBeUpdated.RewardImg;

                context.Rewards.Update(updateReward);
                context.SaveChanges();
            }
        }

        [HttpDelete]
        [Route("deleteWeeklyTasks")]
        public Object DeleteWeeklyTasks(int weekId)
        {
            var weeks = context.Weeks.ToList();
            var weekToDelete = weeks.Find(w => w.WeekId == weekId);

            if (weekToDelete != null)
            {
                //Get all the tasks performed for the specified week
                var tasksToDelete = context.Tasks.ToList();
                tasksToDelete = tasksToDelete.FindAll(t => t.WeekId == weekToDelete.WeekId);

                //Get all the selected days for the tasks performed for the specified week
                var selectedDays = context.SelectedDays.ToList();
                List<SelectedDay> selectedDaysToDelete = [];
                tasksToDelete.ForEach(t =>
                {
                    var selectedDaysForTask = selectedDays.Find(sd => sd.SelectedDaysId == t.SelectedDaysId);
                    if (selectedDaysForTask != null)
                    {
                        selectedDaysToDelete.Add(selectedDaysForTask);
                    }
                });

                //Get all the completed tasks for the specified week
                var completedTasks = context.CompletedTasks.ToList();
                List<CompletedTask> completedTasksToDelete = [];
                tasksToDelete.ForEach(t =>
                {
                    var ctToDelete = completedTasks.Find(ct => ct.TaskId == t.TaskId);
                    if (ctToDelete != null)
                    {
                        completedTasksToDelete.Add(ctToDelete);
                    }
                });

                //Get the reward for the specified week
                var rewards = context.Rewards.ToList();
                var rewardToDelete = rewards.Find(r => r.RewardId == weekToDelete.RewardId);

                if (rewardToDelete != null)
                {
                    var rewardsWon = context.WonRewards.ToList();
                    var rwToDelete = rewardsWon.Find(rw => rw.RewardId == rewardToDelete.RewardId);

                    if (rwToDelete != null)
                    {
                        context.WonRewards.Remove(rwToDelete);
                        context.SaveChanges();
                    }
                }

                context.CompletedTasks.RemoveRange(completedTasksToDelete);
                context.SaveChanges();

                context.Tasks.RemoveRange(tasksToDelete);
                context.SaveChanges();

                context.SelectedDays.RemoveRange(selectedDaysToDelete);
                context.SaveChanges();

                context.Weeks.Remove(weekToDelete);
                context.SaveChanges();

                if (rewardToDelete != null)
                {
                    context.Rewards.Remove(rewardToDelete);
                    context.SaveChanges();
                }

                return Ok("Weekly tasks have been removed");
            }
            else
            {
                return NotFound("The week with id " + weekId + " does does exist");
            }
        }
    }
}
