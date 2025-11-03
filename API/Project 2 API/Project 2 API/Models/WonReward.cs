using System;
using System.Collections.Generic;

namespace Project_2_API.Models;

public partial class WonReward
{
    public int RewardId { get; set; }

    public int FamilyMemberId { get; set; }

    public DateTime DateRewarded { get; set; }
}
