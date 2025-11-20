using Project_2_API.Models;
using Task = Project_2_API.Models.Task;

namespace Project_2_API.Helper_classes
{
    public class Leaderboard
    {
        public required FamilyMember member { get; set; }
        public required List<Task> tasksCompleted { get; set; }
        public required int totalPoints { get; set; }
    }
}
