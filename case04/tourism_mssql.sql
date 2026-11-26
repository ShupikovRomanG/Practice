IF DB_ID(N'TourismWeb') IS NULL
    CREATE DATABASE TourismWeb;
GO
USE TourismWeb;
GO
CREATE TABLE dbo.Tours (
    TourId int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Tours PRIMARY KEY,
    Title nvarchar(120) NOT NULL CONSTRAINT UQ_Tours_Title UNIQUE,
    Destination nvarchar(100) NOT NULL,
    DurationDays smallint NOT NULL CONSTRAINT CK_Tours_Duration CHECK (DurationDays > 0),
    Price decimal(12,2) NOT NULL CONSTRAINT CK_Tours_Price CHECK (Price >= 0),
    IsPublished bit NOT NULL CONSTRAINT DF_Tours_IsPublished DEFAULT (0)
);
GO
CREATE VIEW dbo.PublishedTours
AS
SELECT TourId, Title, Destination, DurationDays, Price
FROM dbo.Tours
WHERE IsPublished = 1;
GO
INSERT INTO dbo.Tours (Title, Destination, DurationDays, Price, IsPublished)
VALUES (N'Выходные в Казани', N'Казань', 3, 15000, 1),
       (N'Карелия <Ладога>', N'Сортавала', 5, 27000, 1),
       (N'Черновик тура', N'Тула', 2, 10000, 0);
GO
