using Project_2_API.Models;
using Task = Project_2_API.Models.Task;

namespace Project_2_API.Helper_classes
{
    public class WeeklyTasks
    {
        public List<Week>? weeks { get; set; }
        public List<Task>? tasks { get; set; }
        public List<List<DateTime>>? dates { get; set; }
        public List<SelectedDay>? selectedDays { get; set; }
        public List<Reward>? rewards { get; set; }
        public DateTime? monday { get; set; }
        public DateTime? sunday { get; set; }
        public List< WonReward>? rewardsWon {get; set; }
    }
}
