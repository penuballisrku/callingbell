using System.Data.Common;
using Microsoft.Data.SqlClient;

namespace CallingBell.Api.Data;

public sealed class SqlConnectionFactory(IConfiguration configuration) : ISqlConnectionFactory
{
    public DbConnection CreateConnection()
    {
        var connectionString = configuration.GetConnectionString("CallingBell");
        if (string.IsNullOrWhiteSpace(connectionString))
        {
            throw new DatabaseConfigurationException("The Calling Bell database is not configured.");
        }

        return new SqlConnection(connectionString);
    }
}
