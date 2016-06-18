CREATE TABLE "dbo"."Bills"
(
   ID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
   OwnerID int NOT NULL,
   Name varchar(30) NOT NULL,
   Description varchar(100),
   Amount float(53) NOT NULL,
   OweeID int,
   TimeReminded datetime DEFAULT ('2010-01-22 15:29:55.090') NOT NULL
)
GO
ALTER TABLE "dbo"."Bills"
ADD CONSTRAINT fk_Bills
FOREIGN KEY (OwnerID)
REFERENCES "dbo"."Users"(ID)
GO
CREATE UNIQUE INDEX Pk_IOU ON "dbo"."Bills"(ID)
GO
CREATE INDEX idx_Bills ON "dbo"."Bills"(OwnerID)
GO
CREATE UNIQUE INDEX PK__Bills__3214EC273C5C72C8 ON "dbo"."Bills"(ID)
GO
CREATE UNIQUE INDEX PK__Bills__3214EC276CA416DC ON "dbo"."Bills"(ID)
GO




CREATE TABLE "dbo"."Bulletin"
(
   ID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
   GroupID int NOT NULL,
   Content varchar(250) NOT NULL
)
GO
CREATE UNIQUE INDEX Pk_Bulletin ON "dbo"."Bulletin"(ID)
GO
CREATE TABLE "dbo"."CommonGoodLog"
(
   ID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
   Name varchar(30) NOT NULL,
   Description varchar(100),
   Price float(53),
   PurchaseDate datetime,
   CommonGoodID int,
   PurchaserID int NOT NULL,
   GroupID int
)
GO
ALTER TABLE "dbo"."CommonGoodLog"
ADD CONSTRAINT fk_CommonGoodLog_0
FOREIGN KEY (CommonGoodID)
REFERENCES "dbo"."CommonGoods"(ID)
GO
ALTER TABLE "dbo"."CommonGoodLog"
ADD CONSTRAINT fk_CommonGoodLog
FOREIGN KEY (PurchaserID)
REFERENCES "dbo"."Users"(ID)
GO
CREATE INDEX idx_CommonGoodLog ON "dbo"."CommonGoodLog"(PurchaserID)
GO
CREATE INDEX idx_CommonGoodLog_0 ON "dbo"."CommonGoodLog"(CommonGoodID)
GO
CREATE UNIQUE INDEX Pk_CommonGoodLog ON "dbo"."CommonGoodLog"(ID)
GO
CREATE TABLE "dbo"."CommonGoods"
(
   ID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
   Name varchar(30) NOT NULL,
   Description varchar(100),
   PurchaserID int NOT NULL,
   GroupID int NOT NULL,
   TimeReminded datetime DEFAULT ('2010-01-22 15:29:55.090') NOT NULL
)
GO
ALTER TABLE "dbo"."CommonGoods"
ADD CONSTRAINT fk_CommonGoodRoomID
FOREIGN KEY (GroupID)
REFERENCES "dbo"."Groups"(ID)
GO
ALTER TABLE "dbo"."CommonGoods"
ADD CONSTRAINT fk_PurchaserID
FOREIGN KEY (PurchaserID)
REFERENCES "dbo"."Users"(ID)
GO
CREATE UNIQUE INDEX Pk_CommonGoods ON "dbo"."CommonGoods"(ID)
GO
CREATE INDEX idx_CommonGoods_0 ON "dbo"."CommonGoods"(GroupID)
GO
CREATE INDEX idx_CommonGoods ON "dbo"."CommonGoods"(PurchaserID)
GO
CREATE TABLE "dbo"."Duties"
(
   ID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
   Name varchar(30) NOT NULL,
   Description varchar(100),
   DutyGroupID int NOT NULL,
   CurrentAssigneeID int NOT NULL,
   TimeReminded datetime DEFAULT ('2010-01-22 12:29:55.090') NOT NULL
)
GO
ALTER TABLE "dbo"."Duties"
ADD CONSTRAINT fk_Duties
FOREIGN KEY (CurrentAssigneeID)
REFERENCES "dbo"."Users"(ID)
GO
ALTER TABLE "dbo"."Duties"
ADD CONSTRAINT fk_DutyGroupID
FOREIGN KEY (DutyGroupID)
REFERENCES "dbo"."Groups"(ID)
GO
CREATE INDEX Pk_Duties_2 ON "dbo"."Duties"(DutyGroupID)
GO
CREATE UNIQUE INDEX Pk_Duties_1 ON "dbo"."Duties"(ID)
GO
CREATE INDEX idx_Duties ON "dbo"."Duties"(CurrentAssigneeID)
GO
CREATE TABLE "dbo"."DutyLog"
(
   ID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
   Name varchar(30) NOT NULL,
   Description varchar(100),
   DutyGroupID int NOT NULL,
   CompletionDate datetime NOT NULL,
   DutyID int NOT NULL,
   AssigneeID int DEFAULT ((0))
)
GO
ALTER TABLE "dbo"."DutyLog"
ADD CONSTRAINT fk_DutyLog_0
FOREIGN KEY (DutyID)
REFERENCES "dbo"."Duties"(ID)
GO
ALTER TABLE "dbo"."DutyLog"
ADD CONSTRAINT fk_DutyLog_1
FOREIGN KEY (DutyGroupID)
REFERENCES "dbo"."Groups"(ID)
GO
ALTER TABLE "dbo"."DutyLog"
ADD CONSTRAINT fk_DutyLog
FOREIGN KEY (AssigneeID)
REFERENCES "dbo"."Users"(ID)
GO
CREATE INDEX idx_DutyLog_1 ON "dbo"."DutyLog"(DutyGroupID)
GO
CREATE INDEX idx_DutyLog_0 ON "dbo"."DutyLog"(DutyID)
GO
CREATE UNIQUE INDEX PK__DutyLog__3214EC2773E43124 ON "dbo"."DutyLog"(ID)
GO
CREATE UNIQUE INDEX Pk_DutyLog ON "dbo"."DutyLog"(ID)
GO
CREATE UNIQUE INDEX PK__DutyLog__3214EC27D54F3DC9 ON "dbo"."DutyLog"(ID)
GO
CREATE UNIQUE INDEX PK__DutyLog__3214EC27CB1EB4CC ON "dbo"."DutyLog"(ID)
GO
CREATE INDEX idx_DutyLog ON "dbo"."DutyLog"(AssigneeID)
GO
CREATE TABLE "dbo"."Geolocations"
(
   ID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
   Latitude float(53) NOT NULL,
   Longitude float(53) NOT NULL
)
GO
CREATE UNIQUE INDEX Pk_Geolocation ON "dbo"."Geolocations"(ID)
GO
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
CREATE TABLE "dbo"."RoomPost"
(
   ID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
   RoomPostGroupID int NOT NULL,
   LocationID int NOT NULL,
   RoomieNeed int NOT NULL,
   Rent float(53) NOT NULL,
   RoomIcon image
)
GO
ALTER TABLE "dbo"."RoomPost"
ADD CONSTRAINT fk_RoomPost_0
FOREIGN KEY (LocationID)
REFERENCES "dbo"."Geolocations"(ID)
GO
ALTER TABLE "dbo"."RoomPost"
ADD CONSTRAINT fk_RoomPost
FOREIGN KEY (RoomPostGroupID)
REFERENCES "dbo"."Groups_Users"(ID)
GO
CREATE INDEX idx_RoomPost_0 ON "dbo"."RoomPost"(LocationID)
GO
CREATE UNIQUE INDEX Pk_RoomPost ON "dbo"."RoomPost"(ID)
GO
CREATE INDEX idx_RoomPost ON "dbo"."RoomPost"(RoomPostGroupID)
GO
CREATE TABLE "dbo"."Rules"
(
   ID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
   GroupID int NOT NULL,
   Category varchar(30) NOT NULL,
   Detail varchar(100) NOT NULL,
   Priority int NOT NULL
)
GO
ALTER TABLE "dbo"."Rules"
ADD CONSTRAINT fk_RulesGroupID
FOREIGN KEY (GroupID)
REFERENCES "dbo"."Groups"(ID)
GO
CREATE UNIQUE INDEX Pk_Rules ON "dbo"."Rules"(ID)
GO
CREATE INDEX idx_Rules ON "dbo"."Rules"(GroupID)
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
CREATE TABLE "dbo"."Users_CommonGoods"
(
   ID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
   UserID int NOT NULL,
   CommonGoodID int NOT NULL,
   Rotation int NOT NULL
)
GO
ALTER TABLE "dbo"."Users_CommonGoods"
ADD CONSTRAINT fk_Users_CommonGoods
FOREIGN KEY (UserID)
REFERENCES "dbo"."Users"(ID)
GO
ALTER TABLE "dbo"."Users_CommonGoods"
ADD CONSTRAINT fk_Users_CommonGoods_0
FOREIGN KEY (CommonGoodID)
REFERENCES "dbo"."CommonGoods"(ID)
GO
CREATE UNIQUE INDEX Pk_Users_CommonGoods ON "dbo"."Users_CommonGoods"(ID)
GO
CREATE INDEX idx_Users_CommonGoods ON "dbo"."Users_CommonGoods"(UserID)
GO
CREATE INDEX idx_Users_CommonGoods_0 ON "dbo"."Users_CommonGoods"(CommonGoodID)
GO
CREATE TABLE "dbo"."Users_Duties"
(
   ID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
   UserID int NOT NULL,
   DutyID int NOT NULL,
   Rotation int NOT NULL
)
GO
ALTER TABLE "dbo"."Users_Duties"
ADD CONSTRAINT fk_UserDuties_0
FOREIGN KEY (DutyID)
REFERENCES "dbo"."Duties"(ID)
GO
ALTER TABLE "dbo"."Users_Duties"
ADD CONSTRAINT fk_UserDuties
FOREIGN KEY (UserID)
REFERENCES "dbo"."Users"(ID)
GO
CREATE INDEX idx_UserDuties ON "dbo"."Users_Duties"(UserID)
GO
CREATE INDEX idx_UserDuties_0 ON "dbo"."Users_Duties"(DutyID)
GO
CREATE UNIQUE INDEX Pk_UserDuties ON "dbo"."Users_Duties"(ID)
GO
