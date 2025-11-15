using System;
using System.Collections.Generic;

namespace Project_2_API.Models;

public partial class Task
{
    public int TaskId { get; set; }

    public string TaskName { get; set; } = null!;

    public string TaskDesc { get; set; } = null!;

    public int TaskPoints { get; set; }

    public int WeekId { get; set; }

    public int SelectedDaysId { get; set; }    
}
