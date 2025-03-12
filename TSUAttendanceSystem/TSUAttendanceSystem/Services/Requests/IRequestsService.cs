using TSUAttendanceSystem.Models;

namespace TSUAttendanceSystem.Services.Requests;

public interface IRequestsService
{
    Task<Request> CreateRequestAsync(Guid userId, CreateRequestDto requestDto, List<IFormFile> files);
    Task<List<RequestDetailsDto>> GetMyRequestsAsync(Guid userId);
    Task<List<RequestDetailsDto>> GetPendingRequestsAsync();
    Task<Request> EditRequestEndDateAsync(Guid userId, Guid requestId, EditRequestEndDateDto requestDto, List<IFormFile> files);
    Task<RequestDetailsDto> ReviewRequestAsync(Guid userId, Guid requestId, ReviewRequestDto reviewDto);
    Task<FileDocument> GetFileAsync(Guid requestId, Guid fileId);
}