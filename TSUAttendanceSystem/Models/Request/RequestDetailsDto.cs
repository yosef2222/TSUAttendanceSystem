using TSUAttendanceSystem.Models.Enums;

namespace TSUAttendanceSystem.Models;

public class RequestDetailsDto
{
    public Guid Id { get; set; }
    public string Reason { get; set; }
    public DateTime AbsenceDateStart { get; set; }
    public DateTime AbsenceDateEnd { get; set; }
    public RequestStatus Status { get; set; }
    public string StudentFullName { get; set; } 
    public string GroupNumber { get; set; }
    public string ReviewedByFullName { get; set; } 
    public List<Guid> FileIds { get; set; } 
}