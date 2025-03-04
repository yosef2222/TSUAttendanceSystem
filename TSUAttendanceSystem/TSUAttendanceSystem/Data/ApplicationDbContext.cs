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

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<User>()
                .HasOne(u => u.Role)
                .WithOne(r => r.User)
                .HasForeignKey<Role>(r => r.UserId);
        }
}