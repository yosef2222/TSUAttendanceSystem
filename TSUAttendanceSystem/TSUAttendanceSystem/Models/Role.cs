namespace TSUAttendanceSystem.Models;

public class Role
{
        public Guid Id { get; set; }
        public Guid UserId { get; set; }
        public User User { get; set; }
        public bool IsTeacher { get; set; } = false;
        public bool IsStudent { get; set; } = false;
        public bool IsAdmin { get; set; } = false;
        public bool IsDean { get; set; } = false;

}