using System;
using System.Collections.Generic;

namespace Project_2_API.Models;

public partial class Reward
{
    public int RewardId { get; set; }

    public string RewardName { get; set; } = null!;

    public string? RewardImg { get; set; }
}
