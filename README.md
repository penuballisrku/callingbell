# Calling Bell

Calling Bell is a local-services marketplace built with an ASP.NET Core API, SQL Server, Dapper, and a React + TypeScript web app.

## Prerequisites

- .NET 10 SDK
- Node.js 24 or later
- SQL Server
- `sqlcmd` (optional, for command-line database setup)

## 1. Create the database and run the schema script

Create an empty `CallingBell` database, then run [`database/CallingBell.sql`](database/CallingBell.sql).

### With `sqlcmd`

From the repository root, using Windows authentication:

```bash
sqlcmd -S localhost -E -Q "IF DB_ID(N'CallingBell') IS NULL CREATE DATABASE CallingBell"
sqlcmd -S localhost -E -d CallingBell -i database/CallingBell.sql
```

### With SQL Server Management Studio or Azure Data Studio

1. Create a database named `CallingBell`.
2. Open `database/CallingBell.sql`.
3. Select the `CallingBell` database.
4. Execute the script.

The schema script creates tables and indexes only.

## 2. Seed sample marketplace content

Run the idempotent [`database/CallingBell.Seed.sql`](database/CallingBell.Seed.sql) script after the schema to add active categories, cities, areas, homepage sections, section items, businesses, images, and banners:

```bash
sqlcmd -S localhost -E -d CallingBell -i database/CallingBell.Seed.sql
```

The script can be run again safely; it prints a row-count summary and does not duplicate its seed records.

## 3. Run the API

The API reads its connection string from `ConnectionStrings__CallingBell`. Set it in the terminal session rather than adding credentials to `appsettings.json`.

### Git Bash

```bash
export ConnectionStrings__CallingBell='Server=localhost;Database=CallingBell;Integrated Security=True;TrustServerCertificate=True'
dotnet restore CallingBell.slnx
dotnet run --project src/CallingBell.Api --launch-profile http
```

### PowerShell

```powershell
$env:ConnectionStrings__CallingBell = 'Server=localhost;Database=CallingBell;Integrated Security=True;TrustServerCertificate=True'
dotnet restore CallingBell.slnx
dotnet run --project src/CallingBell.Api --launch-profile http
```

Replace the example with the secured connection string for your SQL Server instance. The HTTP launch profile serves the API at `http://localhost:5152`.

Useful endpoints:

- Health check: `http://localhost:5152/health`
- OpenAPI document (Development): `http://localhost:5152/openapi/v1.json`

## 4. Run the web app

Open a second terminal from the repository root:

```bash
cd src/calling-bell-web
npm install
npm run dev
```

Vite prints the local web address, normally `http://localhost:5173`. During local development, frontend requests use Vite's `/api` proxy to reach the API at `http://localhost:5152`; do not set `VITE_API_BASE_URL` unless the API is hosted separately.

## Build and lint

```bash
dotnet build CallingBell.slnx

cd src/calling-bell-web
npm run lint
npm run build
```

## Troubleshooting

- **`DATABASE_UNAVAILABLE` or HTTP 503:** Start SQL Server, confirm the connection string is valid, create the `CallingBell` database, and run `database/CallingBell.sql`.
- **The homepage has no sections:** Add active records to `HomeSections` and `HomeSectionItems`, along with their referenced categories, businesses, or banners.
- **Vite uses another port:** This is normal when port 5173 is occupied. The relative `/api` proxy continues to work without a CORS change.
