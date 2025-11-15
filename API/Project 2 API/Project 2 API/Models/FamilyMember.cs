using System;
using System.Collections.Generic;

namespace Project_2_API.Models;

public partial class FamilyMember
{
    public int FamilyMemberId { get; set; }

    public string? FamilyMemberName { get; set; }

    public string? FamilyMemberSurname { get; set; }

    public string FamilyMemberEmail { get; set; } = null!;

    public string? FamilyMemberPassword { get; set; }

    public int FamilyMemberRole { get; set; }

    public string FamilyGroupId { get; set; } = null!;
}
