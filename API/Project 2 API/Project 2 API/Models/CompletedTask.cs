using System;
using System.Collections.Generic;

namespace Project_2_API.Models;

public partial class CompletedTask
{
    public int TaskId { get; set; }

    public int FamilyMemberId { get; set; }

    public DateTime TimeCompleted { get; set; }
}
