using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Pomelo.EntityFrameworkCore.MySql.Scaffolding.Internal;

namespace Project_2_API.Models;

public partial class Project2DatabaseContext : DbContext
{
    public Project2DatabaseContext()
    {
    }

    public Project2DatabaseContext(DbContextOptions<Project2DatabaseContext> options)
        : base(options)
    {
    }

    public virtual DbSet<CompletedTask> CompletedTasks { get; set; }

    public virtual DbSet<FamilyMember> FamilyMembers { get; set; }

    public virtual DbSet<Reward> Rewards { get; set; }

    public virtual DbSet<SelectedDay> SelectedDays { get; set; }

    public virtual DbSet<Task> Tasks { get; set; }

    public virtual DbSet<Week> Weeks { get; set; }

    public virtual DbSet<WonReward> WonRewards { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseMySql("server=localhost;database=project_2_database;uid=root;pwd=juniorDevHere.53", Microsoft.EntityFrameworkCore.ServerVersion.Parse("8.0.43-mysql"));

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder
            .UseCollation("utf8mb4_0900_ai_ci")
            .HasCharSet("utf8mb4");

        modelBuilder.Entity<CompletedTask>(entity =>
        {
            entity.HasKey(e => new { e.TaskId, e.FamilyMemberId, e.DayNeededToBeCompleted })
                .HasName("PRIMARY")
                .HasAnnotation("MySql:IndexPrefixLength", new[] { 0, 0, 0 });

            entity.ToTable("completed_task");

            entity.HasIndex(e => e.FamilyMemberId, "family_member_id");

            entity.Property(e => e.TaskId).HasColumnName("task_id");
            entity.Property(e => e.FamilyMemberId).HasColumnName("family_member_id");
            entity.Property(e => e.DayNeededToBeCompleted)
                .HasColumnType("datetime")
                .HasColumnName("day_needed_to_be_completed");
            entity.Property(e => e.DayActuallyCompleted)
                .HasColumnType("datetime")
                .HasColumnName("day_actually_completed");

            

            
        });

        modelBuilder.Entity<FamilyMember>(entity =>
        {
            entity.HasKey(e => e.FamilyMemberId).HasName("PRIMARY");

            entity.ToTable("family_member");

            entity.Property(e => e.FamilyMemberId)
                .ValueGeneratedNever()
                .HasColumnName("family_member_id");
            entity.Property(e => e.FamilyGroupId)
                .HasMaxLength(30)
                .IsFixedLength()
                .HasColumnName("family_group_id");
            entity.Property(e => e.FamilyMemberEmail)
                .HasMaxLength(100)
                .IsFixedLength()
                .HasColumnName("family_member_email");
            entity.Property(e => e.FamilyMemberName)
                .HasMaxLength(100)
                .IsFixedLength()
                .HasColumnName("family_member_name");
            entity.Property(e => e.FamilyMemberPassword)
                .HasMaxLength(100)
                .IsFixedLength()
                .HasColumnName("family_member_password");
            entity.Property(e => e.FamilyMemberRole).HasColumnName("family_member_role");
            entity.Property(e => e.FamilyMemberSurname)
                .HasMaxLength(100)
                .IsFixedLength()
                .HasColumnName("family_member_surname");
        });

        modelBuilder.Entity<Reward>(entity =>
        {
            entity.HasKey(e => e.RewardId).HasName("PRIMARY");

            entity.ToTable("reward");

            entity.Property(e => e.RewardId)
                .ValueGeneratedNever()
                .HasColumnName("reward_id");
            entity.Property(e => e.RewardDesc)
                .HasMaxLength(100)
                .IsFixedLength()
                .HasColumnName("reward_desc");
            entity.Property(e => e.RewardImg)
                .HasMaxLength(100)
                .IsFixedLength()
                .HasColumnName("reward_img");
            entity.Property(e => e.RewardName)
                .HasMaxLength(100)
                .IsFixedLength()
                .HasColumnName("reward_name");
        });

        modelBuilder.Entity<SelectedDay>(entity =>
        {
            entity.HasKey(e => e.SelectedDaysId).HasName("PRIMARY");

            entity.ToTable("selected_days");

            entity.Property(e => e.SelectedDaysId)
                .ValueGeneratedNever()
                .HasColumnName("selected_days_id");
            entity.Property(e => e.Friday)
                .HasColumnType("datetime")
                .HasColumnName("friday");
            entity.Property(e => e.Monday)
                .HasColumnType("datetime")
                .HasColumnName("monday");
            entity.Property(e => e.Saturday)
                .HasColumnType("datetime")
                .HasColumnName("saturday");
            entity.Property(e => e.Sunday)
                .HasColumnType("datetime")
                .HasColumnName("sunday");
            entity.Property(e => e.Thursday)
                .HasColumnType("datetime")
                .HasColumnName("thursday");
            entity.Property(e => e.Tuesday)
                .HasColumnType("datetime")
                .HasColumnName("tuesday");
            entity.Property(e => e.Wednesday)
                .HasColumnType("datetime")
                .HasColumnName("wednesday");
        });

        modelBuilder.Entity<Task>(entity =>
        {
            entity.HasKey(e => e.TaskId).HasName("PRIMARY");

            entity.ToTable("task");

            entity.HasIndex(e => e.SelectedDaysId, "selected_days_id");

            entity.HasIndex(e => e.WeekId, "week_id");

            entity.Property(e => e.TaskId)
                .ValueGeneratedNever()
                .HasColumnName("task_id");
            entity.Property(e => e.FamilyGroupId)
                .HasMaxLength(30)
                .IsFixedLength()
                .HasColumnName("family_group_id");
            entity.Property(e => e.SelectedDaysId).HasColumnName("selected_days_id");
            entity.Property(e => e.TaskDesc)
                .HasMaxLength(150)
                .IsFixedLength()
                .HasColumnName("task_desc");
            entity.Property(e => e.TaskName)
                .HasMaxLength(100)
                .IsFixedLength()
                .HasColumnName("task_name");
            entity.Property(e => e.TaskPoints).HasColumnName("task_points");
            entity.Property(e => e.WeekId).HasColumnName("week_id");

            

            
        });

        modelBuilder.Entity<Week>(entity =>
        {
            entity.HasKey(e => e.WeekId).HasName("PRIMARY");

            entity.ToTable("week");

            entity.HasIndex(e => e.RewardId, "reward_id");

            entity.Property(e => e.WeekId)
                .ValueGeneratedNever()
                .HasColumnName("week_id");
            entity.Property(e => e.Friday)
                .HasColumnType("datetime")
                .HasColumnName("friday");
            entity.Property(e => e.Monday)
                .HasColumnType("datetime")
                .HasColumnName("monday");
            entity.Property(e => e.RewardId).HasColumnName("reward_id");
            entity.Property(e => e.Saturday)
                .HasColumnType("datetime")
                .HasColumnName("saturday");
            entity.Property(e => e.Sunday)
                .HasColumnType("datetime")
                .HasColumnName("sunday");
            entity.Property(e => e.Thursday)
                .HasColumnType("datetime")
                .HasColumnName("thursday");
            entity.Property(e => e.Tuesday)
                .HasColumnType("datetime")
                .HasColumnName("tuesday");
            entity.Property(e => e.Wednesday)
                .HasColumnType("datetime")
                .HasColumnName("wednesday");
            entity.Property(e => e.WeekNo).HasColumnName("week_no");

            
        });

        modelBuilder.Entity<WonReward>(entity =>
        {
            entity.HasKey(e => new { e.RewardId, e.FamilyMemberId })
                .HasName("PRIMARY")
                .HasAnnotation("MySql:IndexPrefixLength", new[] { 0, 0 });

            entity.ToTable("won_reward");

            entity.HasIndex(e => e.FamilyMemberId, "family_member_id");

            entity.Property(e => e.RewardId).HasColumnName("reward_id");
            entity.Property(e => e.FamilyMemberId).HasColumnName("family_member_id");
            entity.Property(e => e.DateRewarded)
                .HasColumnType("datetime")
                .HasColumnName("date_rewarded");

            

            
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
