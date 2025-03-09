using TSUAttendanceSystem.Models.Enums;

namespace TSUAttendanceSystem.Models;

public class Request
{
    public Guid Id { get; set; }
    public Guid StudentId { get; set; }
    public User Student { get; set; }
    public string Reason { get; set; }
    public DateTime AbsenceDateStart { get; set; }
    public DateTime AbsenceDateEnd { get; set; }
    public RequestStatus Status { get; set; } = RequestStatus.Pending;
    public Guid? ReviewedById { get; set; }
    public User? ReviewedBy { get; set; }
    public List<FileDocument> Files { get; set; } = new();
}