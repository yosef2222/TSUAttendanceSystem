using AttendanceTracker.Models;
using Microsoft.EntityFrameworkCore;

namespace AttendanceTracker.Data;

public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options) { }

    public DbSet<User> Users { get; set; }
    public DbSet<AbsenceRequest> AbsenceRequests { get; set; }
    public DbSet<ProofDocument> ProofDocuments { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<AbsenceRequest>()
            .HasKey(a => a.Id); // Explicitly set primary key
    }
}
