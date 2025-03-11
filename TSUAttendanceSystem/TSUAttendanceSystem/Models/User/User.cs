namespace TSUAttendanceSystem.Models;

public class User
{
    public Guid Id { get; set; }
    public string FullName { get; set; }
    public DateTime Birthday { get; set; }
    public string Email { get; set; }
    public string PasswordHash { get; set; }
    public Role Role { get; set; }
    public List<Request> Requests { get; set; } = new();
    public List<Request> ReviewedRequests { get; set; } = new();

}