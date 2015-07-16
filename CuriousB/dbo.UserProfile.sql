CREATE TABLE [dbo].[UserProfile] (
    [UserId]   INT            IDENTITY (1, 1) NOT NULL,
    [UserName] NVARCHAR (50) NULL,
    [Password] NVARCHAR(50) NULL, 
    [Fullname] NVARCHAR(100) NULL, 
    PRIMARY KEY CLUSTERED ([UserId] ASC)
);

