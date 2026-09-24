SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.Categories', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Categories
    (
        CategoryId BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Categories PRIMARY KEY,
        ParentCategoryId BIGINT NULL,
        Name NVARCHAR(160) NOT NULL,
        Slug NVARCHAR(160) NOT NULL,
        Description NVARCHAR(1000) NULL,
        ImageUrl NVARCHAR(1000) NULL,
        ThumbnailUrl NVARCHAR(1000) NULL,
        MobileImageUrl NVARCHAR(1000) NULL,
        Icon NVARCHAR(100) NULL,
        AltText NVARCHAR(300) NULL,
        DisplayOrder INT NOT NULL CONSTRAINT DF_Categories_DisplayOrder DEFAULT 0,
        IsActive BIT NOT NULL CONSTRAINT DF_Categories_IsActive DEFAULT 1,
        CreatedDate DATETIME2(3) NOT NULL CONSTRAINT DF_Categories_CreatedDate DEFAULT SYSUTCDATETIME(),
        UpdatedDate DATETIME2(3) NOT NULL CONSTRAINT DF_Categories_UpdatedDate DEFAULT SYSUTCDATETIME(),
        CONSTRAINT UQ_Categories_Slug UNIQUE (Slug),
        CONSTRAINT FK_Categories_Parent FOREIGN KEY (ParentCategoryId) REFERENCES dbo.Categories(CategoryId)
    );
END;
GO

IF OBJECT_ID(N'dbo.Cities', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Cities
    (
        CityId BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Cities PRIMARY KEY,
        Name NVARCHAR(160) NOT NULL,
        Slug NVARCHAR(160) NOT NULL,
        IsActive BIT NOT NULL CONSTRAINT DF_Cities_IsActive DEFAULT 1,
        CreatedDate DATETIME2(3) NOT NULL CONSTRAINT DF_Cities_CreatedDate DEFAULT SYSUTCDATETIME(),
        UpdatedDate DATETIME2(3) NOT NULL CONSTRAINT DF_Cities_UpdatedDate DEFAULT SYSUTCDATETIME(),
        CONSTRAINT UQ_Cities_Slug UNIQUE (Slug)
    );
END;
GO

IF OBJECT_ID(N'dbo.Areas', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Areas
    (
        AreaId BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Areas PRIMARY KEY,
        CityId BIGINT NOT NULL,
        Name NVARCHAR(160) NOT NULL,
        Slug NVARCHAR(160) NOT NULL,
        IsActive BIT NOT NULL CONSTRAINT DF_Areas_IsActive DEFAULT 1,
        CreatedDate DATETIME2(3) NOT NULL CONSTRAINT DF_Areas_CreatedDate DEFAULT SYSUTCDATETIME(),
        UpdatedDate DATETIME2(3) NOT NULL CONSTRAINT DF_Areas_UpdatedDate DEFAULT SYSUTCDATETIME(),
        CONSTRAINT UQ_Areas_City_Slug UNIQUE (CityId, Slug),
        CONSTRAINT FK_Areas_City FOREIGN KEY (CityId) REFERENCES dbo.Cities(CityId)
    );
END;
GO

IF OBJECT_ID(N'dbo.Businesses', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Businesses
    (
        BusinessId BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Businesses PRIMARY KEY,
        BusinessName NVARCHAR(160) NOT NULL,
        Slug NVARCHAR(160) NOT NULL,
        OwnerName NVARCHAR(120) NOT NULL,
        CategoryId BIGINT NOT NULL,
        Description NVARCHAR(4000) NULL,
        Phone NVARCHAR(30) NOT NULL,
        WhatsApp NVARCHAR(30) NULL,
        Email NVARCHAR(254) NULL,
        Website NVARCHAR(500) NULL,
        Address NVARCHAR(500) NOT NULL,
        CityId BIGINT NULL,
        AreaId BIGINT NULL,
        Pincode NVARCHAR(12) NULL,
        Latitude DECIMAL(9,6) NULL,
        Longitude DECIMAL(9,6) NULL,
        LogoUrl NVARCHAR(1000) NULL,
        CoverImageUrl NVARCHAR(1000) NULL,
        Rating DECIMAL(3,2) NOT NULL CONSTRAINT DF_Businesses_Rating DEFAULT 0,
        ReviewCount INT NOT NULL CONSTRAINT DF_Businesses_ReviewCount DEFAULT 0,
        IsVerified BIT NOT NULL CONSTRAINT DF_Businesses_IsVerified DEFAULT 0,
        IsSponsored BIT NOT NULL CONSTRAINT DF_Businesses_IsSponsored DEFAULT 0,
        IsActive BIT NOT NULL CONSTRAINT DF_Businesses_IsActive DEFAULT 0,
        CreatedDate DATETIME2(3) NOT NULL CONSTRAINT DF_Businesses_CreatedDate DEFAULT SYSUTCDATETIME(),
        UpdatedDate DATETIME2(3) NOT NULL CONSTRAINT DF_Businesses_UpdatedDate DEFAULT SYSUTCDATETIME(),
        CONSTRAINT UQ_Businesses_Slug UNIQUE (Slug),
        CONSTRAINT CK_Businesses_Rating CHECK (Rating >= 0 AND Rating <= 5),
        CONSTRAINT FK_Businesses_Category FOREIGN KEY (CategoryId) REFERENCES dbo.Categories(CategoryId),
        CONSTRAINT FK_Businesses_City FOREIGN KEY (CityId) REFERENCES dbo.Cities(CityId),
        CONSTRAINT FK_Businesses_Area FOREIGN KEY (AreaId) REFERENCES dbo.Areas(AreaId)
    );
END;
GO

IF OBJECT_ID(N'dbo.BusinessImages', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.BusinessImages
    (
        BusinessImageId BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_BusinessImages PRIMARY KEY,
        BusinessId BIGINT NOT NULL,
        ImageUrl NVARCHAR(1000) NOT NULL,
        ThumbnailUrl NVARCHAR(1000) NULL,
        MobileImageUrl NVARCHAR(1000) NULL,
        AltText NVARCHAR(300) NULL,
        ImageType NVARCHAR(40) NOT NULL,
        DisplayOrder INT NOT NULL CONSTRAINT DF_BusinessImages_DisplayOrder DEFAULT 0,
        IsPrimary BIT NOT NULL CONSTRAINT DF_BusinessImages_IsPrimary DEFAULT 0,
        IsActive BIT NOT NULL CONSTRAINT DF_BusinessImages_IsActive DEFAULT 1,
        CreatedDate DATETIME2(3) NOT NULL CONSTRAINT DF_BusinessImages_CreatedDate DEFAULT SYSUTCDATETIME(),
        UpdatedDate DATETIME2(3) NOT NULL CONSTRAINT DF_BusinessImages_UpdatedDate DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_BusinessImages_Business FOREIGN KEY (BusinessId) REFERENCES dbo.Businesses(BusinessId)
    );
END;
GO

IF OBJECT_ID(N'dbo.Banners', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Banners
    (
        BannerId BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Banners PRIMARY KEY,
        Title NVARCHAR(200) NOT NULL,
        Subtitle NVARCHAR(500) NULL,
        ImageUrl NVARCHAR(1000) NULL,
        ThumbnailUrl NVARCHAR(1000) NULL,
        MobileImageUrl NVARCHAR(1000) NULL,
        AltText NVARCHAR(300) NULL,
        TargetUrl NVARCHAR(1000) NULL,
        DisplayOrder INT NOT NULL CONSTRAINT DF_Banners_DisplayOrder DEFAULT 0,
        StartDate DATETIME2(3) NULL,
        EndDate DATETIME2(3) NULL,
        IsActive BIT NOT NULL CONSTRAINT DF_Banners_IsActive DEFAULT 1,
        CreatedDate DATETIME2(3) NOT NULL CONSTRAINT DF_Banners_CreatedDate DEFAULT SYSUTCDATETIME(),
        UpdatedDate DATETIME2(3) NOT NULL CONSTRAINT DF_Banners_UpdatedDate DEFAULT SYSUTCDATETIME(),
        CONSTRAINT CK_Banners_DateRange CHECK (EndDate IS NULL OR StartDate IS NULL OR EndDate >= StartDate)
    );
END;
GO

IF OBJECT_ID(N'dbo.HomeSections', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.HomeSections
    (
        HomeSectionId BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_HomeSections PRIMARY KEY,
        SectionType NVARCHAR(50) NOT NULL,
        Title NVARCHAR(200) NOT NULL,
        Subtitle NVARCHAR(500) NULL,
        Theme NVARCHAR(50) NOT NULL CONSTRAINT DF_HomeSections_Theme DEFAULT N'default',
        DisplayOrder INT NOT NULL,
        MaxItems INT NOT NULL CONSTRAINT DF_HomeSections_MaxItems DEFAULT 8,
        IsActive BIT NOT NULL CONSTRAINT DF_HomeSections_IsActive DEFAULT 1,
        StartDate DATETIME2(3) NULL,
        EndDate DATETIME2(3) NULL,
        CreatedDate DATETIME2(3) NOT NULL CONSTRAINT DF_HomeSections_CreatedDate DEFAULT SYSUTCDATETIME(),
        UpdatedDate DATETIME2(3) NOT NULL CONSTRAINT DF_HomeSections_UpdatedDate DEFAULT SYSUTCDATETIME(),
        CONSTRAINT UQ_HomeSections_DisplayOrder UNIQUE (DisplayOrder),
        CONSTRAINT CK_HomeSections_MaxItems CHECK (MaxItems BETWEEN 1 AND 50),
        CONSTRAINT CK_HomeSections_DateRange CHECK (EndDate IS NULL OR StartDate IS NULL OR EndDate >= StartDate)
    );
END;
GO

IF OBJECT_ID(N'dbo.HomeSectionItems', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.HomeSectionItems
    (
        HomeSectionItemId BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_HomeSectionItems PRIMARY KEY,
        HomeSectionId BIGINT NOT NULL,
        CategoryId BIGINT NULL,
        BusinessId BIGINT NULL,
        BannerId BIGINT NULL,
        DisplayOrder INT NOT NULL,
        IsActive BIT NOT NULL CONSTRAINT DF_HomeSectionItems_IsActive DEFAULT 1,
        CreatedDate DATETIME2(3) NOT NULL CONSTRAINT DF_HomeSectionItems_CreatedDate DEFAULT SYSUTCDATETIME(),
        UpdatedDate DATETIME2(3) NOT NULL CONSTRAINT DF_HomeSectionItems_UpdatedDate DEFAULT SYSUTCDATETIME(),
        CONSTRAINT UQ_HomeSectionItems_DisplayOrder UNIQUE (HomeSectionId, DisplayOrder),
        CONSTRAINT CK_HomeSectionItems_OneSource CHECK
        (
            (CASE WHEN CategoryId IS NULL THEN 0 ELSE 1 END) +
            (CASE WHEN BusinessId IS NULL THEN 0 ELSE 1 END) +
            (CASE WHEN BannerId IS NULL THEN 0 ELSE 1 END) = 1
        ),
        CONSTRAINT FK_HomeSectionItems_Section FOREIGN KEY (HomeSectionId) REFERENCES dbo.HomeSections(HomeSectionId),
        CONSTRAINT FK_HomeSectionItems_Category FOREIGN KEY (CategoryId) REFERENCES dbo.Categories(CategoryId),
        CONSTRAINT FK_HomeSectionItems_Business FOREIGN KEY (BusinessId) REFERENCES dbo.Businesses(BusinessId),
        CONSTRAINT FK_HomeSectionItems_Banner FOREIGN KEY (BannerId) REFERENCES dbo.Banners(BannerId)
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Businesses_Search' AND object_id = OBJECT_ID(N'dbo.Businesses'))
    CREATE INDEX IX_Businesses_Search ON dbo.Businesses(IsActive, CategoryId, BusinessName) INCLUDE (Slug, Rating, IsSponsored, IsVerified);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Businesses_Location' AND object_id = OBJECT_ID(N'dbo.Businesses'))
    CREATE INDEX IX_Businesses_Location ON dbo.Businesses(CityId, AreaId, IsActive) INCLUDE (CategoryId, Rating, Slug);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_BusinessImages_Business' AND object_id = OBJECT_ID(N'dbo.BusinessImages'))
    CREATE INDEX IX_BusinessImages_Business ON dbo.BusinessImages(BusinessId, IsActive, IsPrimary, DisplayOrder);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_HomeSections_ActiveOrder' AND object_id = OBJECT_ID(N'dbo.HomeSections'))
    CREATE INDEX IX_HomeSections_ActiveOrder ON dbo.HomeSections(IsActive, DisplayOrder, StartDate, EndDate);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_HomeSectionItems_Section' AND object_id = OBJECT_ID(N'dbo.HomeSectionItems'))
    CREATE INDEX IX_HomeSectionItems_Section ON dbo.HomeSectionItems(HomeSectionId, IsActive, DisplayOrder);
GO
