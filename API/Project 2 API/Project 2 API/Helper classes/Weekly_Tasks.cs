using Project_2_API.Models;
using Task = Project_2_API.Models.Task;

namespace Project_2_API.Helper_classes
{
    public class Weekly_Tasks
    {
        public List<Task>? tasks;
        public List<List<DateTime>>? dates;
        public List<SelectedDay>? selectedDays;
        public Reward? reward;
    }
}
