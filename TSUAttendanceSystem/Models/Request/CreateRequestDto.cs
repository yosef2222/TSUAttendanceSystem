namespace TSUAttendanceSystem.Models;

public class CreateRequestDto
{
    public string Reason { get; set; } = string.Empty;
    public DateTime AbsenceDateStart { get; set; }
    public DateTime AbsenceDateEnd { get; set; }
}