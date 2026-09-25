using CallingBell.Api.Contracts;
using CallingBell.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CallingBell.Api.Controllers;

[ApiController,Route("api/v1/media")]
public sealed class MediaController(IFileStorageService storage):ControllerBase
{
    [Authorize,RequestSizeLimit(10_000_000),HttpPost("upload")]
    public async Task<ActionResult<ApiResponse<PresignedUploadDto>>> Upload(IFormFile file,CancellationToken ct)
    {
        if(file.Length==0)return BadRequest(ApiResponse<PresignedUploadDto>.Fail("EMPTY_FILE","Select a file."));
        var allowed=new[]{"image/jpeg","image/png","image/webp"};
        if(!allowed.Contains(file.ContentType,StringComparer.OrdinalIgnoreCase))return BadRequest(ApiResponse<PresignedUploadDto>.Fail("INVALID_FILE_TYPE","Only JPEG, PNG and WebP images are allowed."));
        await using var stream=file.OpenReadStream();
        var result=await storage.UploadAsync(stream,file.FileName,file.ContentType,ct);
        return Ok(ApiResponse<PresignedUploadDto>.Ok(new PresignedUploadDto(result.BlobName,string.Empty,result.PublicUrl),"Image uploaded"));
    }
}