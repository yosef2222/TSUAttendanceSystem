namespace TSUAttendanceSystem.Models;

public class FileDocument
{
    public Guid Id { get; set; }
    public string FileName { get; set; }
    public string ContentType { get; set; }
    public byte[] Data { get; set; }

    public Guid RequestId { get; set; }
    public Request Request { get; set; }
}