namespace AttendanceTracker.Models;

public class AbsenceRequest
{
    public int Id { get; set; }
    public string StudentId { get; set; }
    public User Student { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
    public string Status { get; set; } = "Pending"; // Pending, Approved, Rejected
    public List<ProofDocument> Documents { get; set; }
}