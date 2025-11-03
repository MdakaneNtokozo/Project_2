using System;
using System.Collections.Generic;

namespace Project_2_API.Models;

public partial class Week
{
    public int WeekId { get; set; }

    public int WeekNo { get; set; }

    public DateTime Monday { get; set; }

    public DateTime Tuesday { get; set; }

    public DateTime Wednesday { get; set; }

    public DateTime Thursday { get; set; }

    public DateTime Friday { get; set; }

    public DateTime Saturday { get; set; }

    public DateTime Sunday { get; set; }

    public int RewardId { get; set; }
}
