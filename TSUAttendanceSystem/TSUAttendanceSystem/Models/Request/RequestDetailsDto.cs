using TSUAttendanceSystem.Models.Enums;

namespace TSUAttendanceSystem.Models;

public class RequestDetailsDto
{
    public Guid Id { get; set; }
    public string Reason { get; set; }
    public DateTime AbsenceDateStart { get; set; }
    public DateTime AbsenceDateEnd { get; set; }
    public RequestStatus Status { get; set; }
    public string StudentFullName { get; set; } // Полное имя студента
    public string ReviewedByFullName { get; set; } // Полное имя администратора, рассмотревшего заявку
    public List<Guid> FileIds { get; set; } // Add this field to return related file IDs

}