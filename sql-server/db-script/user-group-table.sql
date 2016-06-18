CREATE TABLE "dbo"."Groups"
(
   ID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
   Name varchar(30) NOT NULL,
   Description varchar(100),
   GroupIcon image
)
GO
CREATE UNIQUE INDEX Pk_Groups ON "dbo"."Groups"(ID)
GO
CREATE UNIQUE INDEX Pk_Groups_Name ON "dbo"."Groups"(Name)
GO
CREATE TABLE "dbo"."Groups_Users"
(
   ID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
   GroupID int NOT NULL,
   UserID int NOT NULL
)
GO
ALTER TABLE "dbo"."Groups_Users"
ADD CONSTRAINT fk_RoomID
FOREIGN KEY (GroupID)
REFERENCES "dbo"."Groups"(ID)
GO
ALTER TABLE "dbo"."Groups_Users"
ADD CONSTRAINT fk_RoomieID
FOREIGN KEY (UserID)
REFERENCES "dbo"."Users"(ID)
GO
CREATE INDEX Pk_Group_Users ON "dbo"."Groups_Users"(UserID)
GO
CREATE INDEX Pk_Group_Users_0 ON "dbo"."Groups_Users"(GroupID)
GO
CREATE UNIQUE INDEX Pk_Group_User ON "dbo"."Groups_Users"(ID)
GO

CREATE TABLE "dbo"."Users"
(
   ID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
   LastName varchar(30) NOT NULL,
   FirstName varchar(30) NOT NULL,
   Username varchar(30) NOT NULL,
   Email varchar(30) NOT NULL,
   Password varchar(30) NOT NULL,
   KarmaScore int NOT NULL,
   GeolocationID int,
   GeoVisibility tinyint DEFAULT ((0)) NOT NULL,
   ProfileIcon image,
   Token varchar(200)
)
GO
ALTER TABLE "dbo"."Users"
ADD CONSTRAINT fk_GeolocationID
FOREIGN KEY (GeolocationID)
REFERENCES "dbo"."Geolocations"(ID)
GO
CREATE UNIQUE INDEX Idx_Email ON "dbo"."Users"(Email)
GO
CREATE UNIQUE INDEX Pk_Users_0 ON "dbo"."Users"(Username)
GO
CREATE UNIQUE INDEX Pk_Users ON "dbo"."Users"(ID)
GO
CREATE INDEX idx_Users ON "dbo"."Users"(GeolocationID)
GO