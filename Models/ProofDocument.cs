namespace AttendanceTracker.Models;

public class ProofDocument
{
    public int Id { get; set; }
    public int AbsenceRequestId { get; set; }
    public AbsenceRequest AbsenceRequest { get; set; }
    public string FilePath { get; set; }
}