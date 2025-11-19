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
        public async Task<Object> GetWeeklyTasks(String groupId)
        {
            var weeks = await context.Weeks.ToListAsync();
            var tasks = await context.Tasks.ToListAsync();
            tasks = tasks.FindAll(t => t.FamilyGroupId == groupId);

            var selectedDays = await context.SelectedDays.ToListAsync();
            List<SelectedDay> tasksSelectedDays = [];
            for (int i = 0; i < tasks.Count; i++)
            {
                var task = tasks[i];
                var selectedDaysForCurrentTask = selectedDays.Find(sd => sd.SelectedDaysId == task.SelectedDaysId);

                if(selectedDaysForCurrentTask != null)
                {
                    tasksSelectedDays.Add(selectedDaysForCurrentTask);
                }
            }

            var rewards = await context.Rewards.ToListAsync();

            WeeklyTasks wt = new()
            {
                weeks = weeks,
                tasks = tasks,
                dates = null,
                selectedDays = tasksSelectedDays,
                rewards = rewards,
                monday = null,
                sunday = null
            };

            return Ok(wt);
        }

        [HttpPost]
        [Route("createWeeklyTasks")]
        public Object CreateWeeklyTasks(WeeklyTasks wt)
        {
            //create a reward entry
            var rewards = context.Rewards.ToList();
            var lastIdx = 0;

            if (rewards.Count > 0)
            {
                lastIdx = rewards.ElementAt(rewards.Count - 1).RewardId + 1;
            }

            
            var newReward = new Reward();
            if (wt.rewards != null)
            {
                var reward = wt.rewards.ElementAt(0);
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
            DateTime? monday = wt.monday;
            DateTime? sunday = wt.sunday;

            CultureInfo cultrueInfo = CultureInfo.InvariantCulture;
            Calendar calendar = cultrueInfo.Calendar;
            var weekNo = calendar.GetWeekOfYear((DateTime)monday, CalendarWeekRule.FirstDay, DayOfWeek.Monday);

            List<DateTime> days = [];
            for (DateTime date = (DateTime)monday; date <= sunday?.AddDays(1) ; date = date.AddDays(1))
            {
                var newDate = new DateTime(date.Year, date.Month, date.Day);
                days.Add(newDate);
            }

            Week week = new()
            {
                WeekId = lastIdx,
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
                for (int i = 0; i < wt.tasks.Count; i++)
                {
                    //Create the selected dates first
                    var dates = wt.dates.ElementAt(i);
                    int selectedDaysId = CreateSelectedDays(dates, week);

                    //Create the tasks 
                    CreateNewTask(wt.tasks.ElementAt(i), week.WeekId, selectedDaysId);
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
                lastIdx = tasks.ElementAt(tasks.Count - 1).TaskId + 1;
            }

            var newTask = new Task
            {
                TaskId = lastIdx,
                TaskName = taskInfo.TaskName,
                TaskDesc = taskInfo.TaskDesc,
                TaskPoints = taskInfo.TaskPoints,
                WeekId = weekId,
                SelectedDaysId = selectedDaysId,
                FamilyGroupId = taskInfo.FamilyGroupId
            };

            context.Tasks.Add(newTask);
            context.SaveChanges();
        }

        private int CreateSelectedDays(List<DateTime> selectedDaysForTask, Week week)
        {
            var selectedDays = context.SelectedDays.ToList();
            int lastIdx = 0;

            if (selectedDays.Count > 0)
            {
                lastIdx = selectedDays.ElementAt(selectedDays.Count - 1).SelectedDaysId + 1;
            }

            var newSelectedDays = new SelectedDay();
            newSelectedDays.SelectedDaysId = lastIdx;

            for(int i = 0; i < selectedDaysForTask.Count; i++) {
                var day = selectedDaysForTask.ElementAt(i);

                if(day == week.Monday)
                {
                    newSelectedDays.Monday = week.Monday;
                }
                else if (day == week.Tuesday)
                {
                    newSelectedDays.Tuesday = week.Tuesday;
                }
                else if (day == week.Wednesday)
                {
                    newSelectedDays.Wednesday = week.Wednesday;
                }
                else if (day == week.Thursday)
                {
                    newSelectedDays.Thursday = week.Thursday;
                }
                else if (day == week.Friday)
                {
                    newSelectedDays.Friday = week.Friday;
                }
                else if (day == week.Saturday)
                {
                    newSelectedDays.Saturday = week.Saturday;
                }
                else if (day == week.Sunday)
                {
                    newSelectedDays.Sunday = week.Sunday;
                }
            }

            context.SelectedDays.Add(newSelectedDays);
            context.SaveChanges();

            return newSelectedDays.SelectedDaysId;
        }

        [HttpPut]
        [Route("updateWeeklyTasks")]
        public Object UpdateWeeklyTasks(WeeklyTasks wt)
        {
            //Get the tasks for the following wee
            if (wt.weeks != null)
            {
                var week = wt.weeks.ElementAt(0);

                //Check if tasks need to be updated
                var tasks = context.Tasks.ToList();
                tasks = tasks.FindAll(t => t.WeekId == week.WeekId);

                var tasksToUpdate = wt.tasks;
                int newTaskCount = 0;
                tasksToUpdate?.ForEach(t =>
                    {
                        //Update the tasks
                        var updateTask = tasks.Find(task => task.TaskId == t.TaskId);
                        
                        if (updateTask != null)
                        {
                            int currentIdx = tasksToUpdate.IndexOf(t);

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
                                var selectedDaysForTask = wt.dates.ElementAt(newTaskCount);
                                int selectedDaysId = CreateSelectedDays(selectedDaysForTask, week);

                                CreateNewTask(t, week.WeekId, selectedDaysId);
                                newTaskCount++;
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
                var rewardsToBeUpdated = wt.rewards;

                if(rewardsToBeUpdated != null)
                {
                    rewardsToBeUpdated.ForEach(r =>
                    {
                        UpdateReward(rewards, r);
                    });
                }

                return Ok("Weekly tasks have been updated");
            }
            else
            {
                return NotFound("The week being sent to be updated does not exist");
            }
        }

        private void UpdateTask(Task updateTask, Task t, WeeklyTasks wt, int currentIdx)
        {
            updateTask.TaskName = t.TaskName;
            updateTask.TaskDesc = t.TaskDesc;
            updateTask.TaskPoints = t.TaskPoints;
            
            context.Tasks.Update(updateTask);
            context.SaveChanges();

            //Update the selected days
            if (wt.selectedDays != null)
            {
                var selectedDays = wt.selectedDays.Find((s) => s.SelectedDaysId == t.SelectedDaysId);
                var allSelectedDays = context.SelectedDays.ToList();
                var selectedDaysToUpdate = allSelectedDays.Find((s) => s.SelectedDaysId == selectedDays.SelectedDaysId);

                if (selectedDaysToUpdate != null)
                {
                    selectedDaysToUpdate.Monday = selectedDays.Monday;
                    selectedDaysToUpdate.Tuesday = selectedDays.Tuesday;
                    selectedDaysToUpdate.Wednesday = selectedDays.Wednesday;
                    selectedDaysToUpdate.Thursday = selectedDays.Thursday;
                    selectedDaysToUpdate.Friday = selectedDays.Friday;
                    selectedDaysToUpdate.Saturday = selectedDays.Saturday;
                    selectedDaysToUpdate.Sunday = selectedDays.Sunday;

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

        [HttpGet]
        [Route("getCompletedTasks")]
        public async Task<Object> GetCompletedTasks()
        {
            return Ok(await context.CompletedTasks.ToListAsync());
        }

        [HttpPost]
        [Route("addCompletedTask")]
        public async Task<Object> AddCompletedTask(CompletedTask ct){
            context.CompletedTasks.Add(ct);
            await context.SaveChangesAsync();

            return Ok("The completed task has been recorded");
        }

        [HttpDelete]
        [Route("deleteCompletedTask")]
        public async Task<Object> DeleteCompletedTask(CompletedTask ct)
        {
            context.CompletedTasks.Remove(ct);
            await context.SaveChangesAsync();

            return Ok("The completed task has been removed");
        }
    }
}
