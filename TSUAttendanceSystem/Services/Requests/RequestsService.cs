using Microsoft.EntityFrameworkCore;
using TSUAttendanceSystem.Data;
using TSUAttendanceSystem.Models;
using TSUAttendanceSystem.Models.Enums;

namespace TSUAttendanceSystem.Services.Requests;

public class RequestsService : IRequestsService
{
    private readonly ApplicationDbContext _context;

    public RequestsService(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<Request> CreateRequestAsync(Guid userId, CreateRequestDto requestDto, List<IFormFile> files)
    {
        if (requestDto.AbsenceDateStart > requestDto.AbsenceDateEnd)
        {
            throw new ArgumentException("AbsenceDateStart cannot be later than AbsenceDateEnd.");
        }

        var request = new Request
        {
            Id = Guid.NewGuid(),
            StudentId = userId,
            Reason = requestDto.Reason,
            AbsenceDateStart = requestDto.AbsenceDateStart,
            AbsenceDateEnd = requestDto.AbsenceDateEnd,
            Status = RequestStatus.Pending
        };

        _context.Requests.Add(request);
        await _context.SaveChangesAsync();

        if (files != null && files.Any())
        {
            foreach (var file in files)
            {
                if (file.Length > 0)
                {
                    using var memoryStream = new MemoryStream();
                    await file.CopyToAsync(memoryStream);

                    var uploadedFile = new FileDocument
                    {
                        Id = Guid.NewGuid(),
                        FileName = file.FileName,
                        ContentType = file.ContentType,
                        Data = memoryStream.ToArray(),
                        RequestId = request.Id
                    };

                    _context.Files.Add(uploadedFile);
                }
            }
            await _context.SaveChangesAsync();
        }

        return request;
    }

    public async Task<List<RequestDetailsDto>> GetMyRequestsAsync(Guid userId)
    {
        var requests = await _context.Requests
            .Where(r => r.StudentId == userId)
            .Include(r => r.Files)
            .Select(r => new RequestDetailsDto
            {
                Id = r.Id,
                GroupNumber = r.Student.GroupNumber,
                Reason = r.Reason,
                AbsenceDateStart = r.AbsenceDateStart,
                AbsenceDateEnd = r.AbsenceDateEnd,
                Status = r.Status,
                StudentFullName = r.Student.FullName,
                ReviewedByFullName = r.ReviewedBy != null ? r.ReviewedBy.FullName : null,
                FileIds = r.Files.Select(f => f.Id).ToList()
            })
            .ToListAsync();

        return requests;
    }

    public async Task<List<RequestDetailsDto>> GetPendingRequestsAsync()
    {
        var requests = await _context.Requests
            .Where(r => r.Status == RequestStatus.Pending)
            .Include(r => r.Student)
            .Include(r => r.ReviewedBy)
            .Include(r => r.Files)
            .Select(r => new RequestDetailsDto
            {
                Id = r.Id,
                GroupNumber = r.Student.GroupNumber,
                Reason = r.Reason,
                AbsenceDateStart = r.AbsenceDateStart,
                AbsenceDateEnd = r.AbsenceDateEnd,
                Status = r.Status,
                StudentFullName = r.Student.FullName,
                ReviewedByFullName = r.ReviewedBy != null ? r.ReviewedBy.FullName : null,
                FileIds = r.Files.Select(f => f.Id).ToList()
            })
            .ToListAsync();

        return requests;
    }

    public async Task<Request> EditRequestEndDateAsync(Guid userId, Guid requestId, EditRequestEndDateDto requestDto, List<IFormFile> files)
    {
        var request = await _context.Requests.FindAsync(requestId);
        if (request == null)
        {
            throw new KeyNotFoundException("Request not found.");
        }

        if (request.StudentId != userId)
        {
            throw new UnauthorizedAccessException("You can only edit your own requests.");
        }

        if (request.AbsenceDateStart > requestDto.AbsenceDateEnd)
        {
            throw new ArgumentException("AbsenceDateStart cannot be later than AbsenceDateEnd.");
        }

        request.AbsenceDateEnd = requestDto.AbsenceDateEnd;
        request.Status = RequestStatus.Pending;

        _context.Requests.Update(request);

        if (files != null && files.Any())
        {
            foreach (var file in files)
            {
                if (file.Length > 0)
                {
                    using var memoryStream = new MemoryStream();
                    await file.CopyToAsync(memoryStream);

                    var uploadedFile = new FileDocument
                    {
                        Id = Guid.NewGuid(),
                        FileName = file.FileName,
                        ContentType = file.ContentType,
                        Data = memoryStream.ToArray(),
                        RequestId = request.Id
                    };

                    _context.Files.Add(uploadedFile);
                }
            }
        }

        await _context.SaveChangesAsync();

        return request;
    }

    public async Task<RequestDetailsDto> ReviewRequestAsync(Guid userId, Guid requestId, ReviewRequestDto reviewDto)
    {
        var request = await _context.Requests
            .Include(r => r.Student)
            .Include(r => r.ReviewedBy)
            .FirstOrDefaultAsync(r => r.Id == requestId);

        if (request == null)
        {
            throw new KeyNotFoundException("Request not found.");
        }

        if (request.Status != RequestStatus.Pending)
        {
            throw new InvalidOperationException("This request has already been reviewed.");
        }

        request.Status = reviewDto.Approve ? RequestStatus.Approved : RequestStatus.Rejected;
        request.ReviewedById = userId;

        await _context.SaveChangesAsync();

        return new RequestDetailsDto
        {
            Id = request.Id,
            Reason = request.Reason,
            AbsenceDateStart = request.AbsenceDateStart,
            AbsenceDateEnd = request.AbsenceDateEnd,
            Status = request.Status,
            StudentFullName = request.Student.FullName,
            ReviewedByFullName = request.ReviewedBy?.FullName
        };
    }

    public async Task<FileDocument> GetFileAsync(Guid requestId, Guid fileId)
    {
        var file = await _context.Files
            .Where(f => f.RequestId == requestId && f.Id == fileId)
            .FirstOrDefaultAsync();

        if (file == null)
        {
            throw new KeyNotFoundException("File not found.");
        }

        return file;
    }
    
    public async Task<List<RequestDetailsDto>> GetApprovedRequestsAsync()
    {
        var requests = await _context.Requests
            .Where(r => r.Status == RequestStatus.Approved)
            .Include(r => r.Student)
            .Include(r => r.ReviewedBy)
            .Include(r => r.Files)
            .Select(r => new RequestDetailsDto
            {
                Id = r.Id,
                GroupNumber = r.Student.GroupNumber,
                Reason = r.Reason,
                AbsenceDateStart = r.AbsenceDateStart,
                AbsenceDateEnd = r.AbsenceDateEnd,
                Status = r.Status,
                StudentFullName = r.Student.FullName,
                ReviewedByFullName = r.ReviewedBy != null ? r.ReviewedBy.FullName : null,
                FileIds = r.Files.Select(f => f.Id).ToList()
            })
            .ToListAsync();

        return requests;
    }
    
}