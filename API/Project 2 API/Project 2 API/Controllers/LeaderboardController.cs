using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Project_2_API.Helper_classes;
using Project_2_API.Models;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace Project_2_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LeaderboardController : ControllerBase
    {
        Project2DatabaseContext context;
        public LeaderboardController(Project2DatabaseContext _context) {
            context = _context;
        }

        [HttpGet]
        public async Task<Object> GetLeaderboard(String groupid)
        {
            var today = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day);
            var weeks = await context.Weeks.ToListAsync();
            var week = weeks.Find((w) => w.Monday == today || w.Tuesday == today || w.Wednesday == today ||
                       w.Thursday == today || w.Friday == today || w.Saturday == today || w.Sunday == today);

            var tasks = await context.Tasks.ToListAsync();
            tasks = tasks.FindAll(t => t.FamilyGroupId == groupid && t.WeekId == week.WeekId);

            var completedTasks = await context.CompletedTasks.ToListAsync();
            List<CompletedTask>  completedTasksForCurrentGroup = [];
            tasks.ForEach((t) =>
            {
                var ctForCurrentTask = completedTasks.FindAll(ct => ct.TaskId == t.TaskId);

                completedTasksForCurrentGroup.AddRange(ctForCurrentTask);
            });

            completedTasksForCurrentGroup.Sort((t1, t2) => { 
                return t1.FamilyMemberId - t2.FamilyMemberId;
            });

            var members = await context.FamilyMembers.ToListAsync();
            members = members.FindAll(m => m.FamilyGroupId == groupid);
            List<Leaderboard> leaderboard = [];
            int index = 0;

            for(int i = 0; i < completedTasksForCurrentGroup.Count; i++)
            {
                var ct = completedTasksForCurrentGroup[i];
                var task = tasks.Find(t => t.TaskId == ct.TaskId);

                if (i == 0)
                {
                    //The first entry of the list
                    var memberFound = members.Find(m => m.FamilyMemberId == ct.FamilyMemberId);

                    Leaderboard entry = new Leaderboard{
                        member = memberFound,
                        tasksCompleted = [task],
                        totalPoints = task.TaskPoints
                    };

                    leaderboard.Add(entry);
                }
                else
                {
                    int prevMemberId = completedTasksForCurrentGroup[i - 1].FamilyMemberId;
                    int currentMemberId = completedTasksForCurrentGroup[i].FamilyMemberId;
                    
                    if (currentMemberId == prevMemberId)
                    {
                        var updateEntry = leaderboard[index];
                        updateEntry.totalPoints += task.TaskPoints;
                        if (!updateEntry.tasksCompleted.Contains(task))
                        {
                            updateEntry.tasksCompleted.Add(task);
                        }

                        leaderboard.RemoveAt(index);
                        leaderboard.Add(updateEntry);
                    }
                    else
                    {
                        //new member found
                        var memberFound = members.Find(m => m.FamilyMemberId == ct.FamilyMemberId);

                        Leaderboard entry = new Leaderboard
                        {
                            member = memberFound,
                            tasksCompleted = [task],
                            totalPoints = task.TaskPoints
                        };

                        leaderboard.Add(entry);
                        index++;
                    }
                }
            }

            leaderboard.Sort((t1, t2) =>
            {
                if (t1.totalPoints != t2.totalPoints)
                {
                    return t2.totalPoints - t1.totalPoints;
                }
                else
                {
                    
                    return String.Compare(t1.member.FamilyMemberName, t2.member.FamilyMemberName);
                }
            });

            return Ok(leaderboard);
        }

        [HttpPost]
        [Route("rewardWinnerOfTheWeek")]
        public async Task<Object> RewardWinnerOfTheWeek(int familyMemberId)
        {
            var today = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day);
            var weeks = await context.Weeks.ToListAsync();
            var week = weeks.Find((w) => w.Monday == today || w.Tuesday == today || w.Wednesday == today ||
                       w.Thursday == today || w.Friday == today || w.Saturday == today || w.Sunday == today);

            var members = await context.FamilyMembers.ToListAsync();
            var member = members.Find((m) => m.FamilyMemberId == familyMemberId);

            if (week != null && member != null)
            {
                var rewardToMember = new WonReward()
                {
                    RewardId = week.RewardId,
                    FamilyMemberId = member.FamilyMemberId,
                    DateRewarded = DateTime.Now,
                };

                context.WonRewards.Add(rewardToMember);
                await context.SaveChangesAsync();

                return Ok("Family member has been rewarded");
            }
            else
            {
                return NotFound("The current week or family member was not found.");
            }

        }
    }
}
