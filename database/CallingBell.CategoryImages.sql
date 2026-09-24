SET XACT_ABORT ON;
GO

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @CategoryStyles TABLE
    (
        Slug NVARCHAR(160) NOT NULL PRIMARY KEY,
        PrimaryColor CHAR(6) NOT NULL,
        SecondaryColor CHAR(6) NOT NULL,
        AccentColor CHAR(6) NOT NULL,
        Symbol CHAR(1) NOT NULL
    );

    INSERT INTO @CategoryStyles (Slug, PrimaryColor, SecondaryColor, AccentColor, Symbol)
    VALUES
        (N'home-services', '123B5D', '0EA5E9', 'E0F2FE', 'H'),
        (N'main-home-services', '123B5D', '0EA5E9', 'E0F2FE', 'H'),
        (N'health-wellness', '065F46', '10B981', 'D1FAE5', '+'),
        (N'doctors-healthcare', '065F46', '10B981', 'D1FAE5', '+'),
        (N'beauty-spa', '831843', 'EC4899', 'FCE7F3', 'B'),
        (N'main-beauty-wellness', '831843', 'EC4899', 'FCE7F3', 'B'),
        (N'events-celebrations', '7C2D12', 'F97316', 'FFEDD5', 'E'),
        (N'weddings-events', '7C2D12', 'F97316', 'FFEDD5', 'E'),
        (N'repairs', '334155', '64748B', 'F1F5F9', 'R'),
        (N'repair-maintenance', '334155', '64748B', 'F1F5F9', 'R'),
        (N'daily-needs', '3F6212', '84CC16', 'ECFCCB', 'S'),
        (N'daily-needs-shopping', '3F6212', '84CC16', 'ECFCCB', 'S'),
        (N'education', '3730A3', '818CF8', 'E0E7FF', 'E'),
        (N'main-education', '3730A3', '818CF8', 'E0E7FF', 'E'),
        (N'professional-services', '1E3A8A', '3B82F6', 'DBEAFE', 'P'),
        (N'business-professional-services', '1E3A8A', '3B82F6', 'DBEAFE', 'P'),
        (N'food-dining', '7C2D12', 'FB923C', 'FFF7ED', 'F'),
        (N'food-restaurants', '7C2D12', 'FB923C', 'FFF7ED', 'F'),
        (N'travel-transport', '0C4A6E', '38BDF8', 'E0F2FE', 'T'),
        (N'main-travel-transport', '0C4A6E', '38BDF8', 'E0F2FE', 'T'),
        (N'automotive', '3F3F46', 'A1A1AA', 'F4F4F5', 'A'),
        (N'automobiles', '3F3F46', 'A1A1AA', 'F4F4F5', 'A'),
        (N'real-estate', '1E3A8A', '60A5FA', 'EFF6FF', 'R'),
        (N'finance-insurance', '14532D', '22C55E', 'DCFCE7', '$'),
        (N'electronics-technology', '312E81', '818CF8', 'EEF2FF', 'T'),
        (N'fashion-lifestyle', '9F1239', 'FB7185', 'FFF1F2', 'L'),
        (N'main-fashion-lifestyle', '9F1239', 'FB7185', 'FFF1F2', 'L'),
        (N'pet-services', '701A75', 'E879F9', 'FDF4FF', 'P'),
        (N'main-pets-animals', '701A75', 'E879F9', 'FDF4FF', 'P'),
        (N'sports-fitness', '9A3412', 'F97316', 'FFF7ED', 'S'),
        (N'personal-care', '9D174D', 'F472B6', 'FDF2F8', 'C'),
        (N'industrial-manufacturing', '334155', '94A3B8', 'F8FAFC', 'I'),
        (N'local-shopping', '3F6212', '84CC16', 'F7FEE7', 'L'),
        (N'media-creative', '5B2140', 'F472B6', 'FDF2F8', 'M'),
        (N'legal-services', '1E3A8A', '3B82F6', 'EFF6FF', 'L'),
        (N'logistics-delivery', '0C4A6E', '0EA5E9', 'E0F2FE', 'D'),
        (N'agriculture-farming', '3F6212', '65A30D', 'ECFCCB', 'A'),
        (N'trending-featured-services', '7C2D12', 'F59E0B', 'FFFBEB', '*');

    DECLARE @ImageTemplate NVARCHAR(1000) =
        N'data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%201200%20800%22%3E%3Crect%20width%3D%221200%22%20height%3D%22800%22%20rx%3D%2240%22%20fill%3D%22%23{PRIMARY}%22%2F%3E%3Ccircle%20cx%3D%22950%22%20cy%3D%22120%22%20r%3D%22310%22%20fill%3D%22%23{SECONDARY}%22%20opacity%3D%22.35%22%2F%3E%3Ccircle%20cx%3D%22260%22%20cy%3D%22400%22%20r%3D%22135%22%20fill%3D%22%23{ACCENT}%22%2F%3E%3Ctext%20x%3D%22260%22%20y%3D%22465%22%20text-anchor%3D%22middle%22%20font-family%3D%22Arial%22%20font-size%3D%22170%22%20font-weight%3D%22700%22%20fill%3D%22%23{PRIMARY}%22%3E{SYMBOL}%3C%2Ftext%3E%3Ctext%20x%3D%22470%22%20y%3D%22430%22%20font-family%3D%22Arial%22%20font-size%3D%2258%22%20font-weight%3D%22700%22%20fill%3D%22%23{ACCENT}%22%3E{NAME}%3C%2Ftext%3E%3C%2Fsvg%3E';

    UPDATE category
    SET ImageUrl = image.ImageUrl,
        ThumbnailUrl = image.ImageUrl,
        MobileImageUrl = image.ImageUrl,
        UpdatedDate = SYSUTCDATETIME()
    FROM dbo.Categories category
    INNER JOIN @CategoryStyles style ON style.Slug = category.Slug
    CROSS APPLY
    (
        SELECT REPLACE(REPLACE(REPLACE(REPLACE(@ImageTemplate,
            N'{PRIMARY}', style.PrimaryColor),
            N'{SECONDARY}', style.SecondaryColor),
            N'{ACCENT}', style.AccentColor),
            N'{SYMBOL}', style.Symbol) AS ImageUrl
    ) imageBase
    CROSS APPLY
    (
        SELECT REPLACE(imageBase.ImageUrl, N'{NAME}',
            REPLACE(REPLACE(REPLACE(category.Name, N'&', N'&amp;'), N'<', N'&lt;'), N'>', N'&gt;')) AS ImageUrl
    ) image;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO

SELECT
    COUNT_BIG(*) AS TotalCategories,
    COUNT_BIG(CASE WHEN ImageUrl LIKE N'data:image/svg+xml,%3Csvg%' THEN 1 END) AS ProfessionalSvgImages
FROM dbo.Categories;
GO
