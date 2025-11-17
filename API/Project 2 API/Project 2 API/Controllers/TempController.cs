using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Project_2_API.Models;
using Task = Project_2_API.Models.Task;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace Project_2_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TempController : ControllerBase
    {
        Project2DatabaseContext context;
        public TempController(Project2DatabaseContext _context)
        {
            context = _context;
        }

        [HttpPost]
        [Route("PostCompletedTasks")]
        public Object PostCompletedTasks(CompletedTask temp)
        {
            return Ok();
        }

        [HttpPost]
        [Route("PostMembers")]
        public Object PostMembers(FamilyMember temp)
        {
            return Ok();
        }

        [HttpPost]
        [Route("PostRewards")]
        public Object PostRewards(Reward temp)
        {
            context.Rewards.Add(temp);
            context.SaveChanges();

            return Ok();
        }

        [HttpPost]
        [Route("PostSelectedDays")]
        public Object PostSelectedDays(SelectedDay temp)
        {
            context.SelectedDays.Add(temp);
            context.SaveChanges();
            return Ok();
        }

        [HttpPost]
        [Route("PostTasks")]
        public Object PostTasks(Task temp)
        {
            context.Tasks.Add(temp);
            context.SaveChanges();
            return Ok();
        }

        [HttpPost]
        [Route("PostWeeks")]
        public Object PostWeeks(Week temp)
        {
            context.Weeks.Add(temp);
            context.SaveChanges();
            return Ok();
        }

        [HttpPost]
        [Route("PostRewardsWon")]
        public Object PostRewardsWon(WonReward temp)
        {
            return Ok();
        }
    }
}
