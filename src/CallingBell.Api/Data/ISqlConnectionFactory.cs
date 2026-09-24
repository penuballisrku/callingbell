using System.Data.Common;

namespace CallingBell.Api.Data;

public interface ISqlConnectionFactory
{
    DbConnection CreateConnection();
}

public sealed class DatabaseConfigurationException(string message) : InvalidOperationException(message);
