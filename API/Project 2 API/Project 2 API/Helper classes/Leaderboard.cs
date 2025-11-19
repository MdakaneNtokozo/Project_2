using Project_2_API.Models;

namespace Project_2_API.Helper_classes
{
    public class Leaderboard
    {
        public required FamilyMember member { get; set; }
        public required int numTasksCompleted { get; set; }
        public required int totalPoints { get; set; }
    }
}
