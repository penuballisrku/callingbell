using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;

namespace CallingBell.Api.Services;

public interface IFileStorageService
{
    Task<(string BlobName,string PublicUrl)> UploadAsync(Stream content,string fileName,string contentType,CancellationToken ct);
}

public sealed class AzureBlobFileStorageService(IConfiguration configuration):IFileStorageService
{
    public async Task<(string BlobName,string PublicUrl)> UploadAsync(Stream content,string fileName,string contentType,CancellationToken ct)
    {
        var connection=configuration["AzureBlob:ConnectionString"];
        if(string.IsNullOrWhiteSpace(connection)) throw new InvalidOperationException("Azure Blob Storage is not configured.");
        var container=new BlobContainerClient(connection,configuration["AzureBlob:Container"]??"callingbell");
        await container.CreateIfNotExistsAsync(PublicAccessType.None,cancellationToken:ct);
        var blobName=$"{DateTime.UtcNow:yyyy/MM}/{Guid.NewGuid():N}-{Path.GetFileName(fileName)}";
        var blob=container.GetBlobClient(blobName);
        await blob.UploadAsync(content,new BlobUploadOptions{HttpHeaders=new BlobHttpHeaders{ContentType=contentType}},ct);
        return(blobName,blob.Uri.ToString());
    }
}