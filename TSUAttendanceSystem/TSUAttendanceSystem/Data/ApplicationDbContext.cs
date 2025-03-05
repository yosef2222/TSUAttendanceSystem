using Microsoft.EntityFrameworkCore;
using TSUAttendanceSystem.Models;

namespace TSUAttendanceSystem.Data;

public class ApplicationDbContext : DbContext
{
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
        }
        
        public DbSet<User> Users { get; set; }
        public DbSet<Role> Roles { get; set; }
        public DbSet<Request> Requests { get; set; }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // User-Role Relationship
            modelBuilder.Entity<User>()
                .HasOne(u => u.Role)
                .WithOne(r => r.User)
                .HasForeignKey<Role>(r => r.UserId);

            // User-Requests Relationship
            modelBuilder.Entity<Request>()
                .HasOne(r => r.Student)
                .WithMany(u => u.Requests)
                .HasForeignKey(r => r.StudentId)
                .OnDelete(DeleteBehavior.Restrict);

            // Admins/Deans reviewing requests
            modelBuilder.Entity<Request>()
                .HasOne(r => r.ReviewedBy)
                .WithMany(u => u.ReviewedRequests)
                .HasForeignKey(r => r.ReviewedById)
                .OnDelete(DeleteBehavior.SetNull);
        }
}