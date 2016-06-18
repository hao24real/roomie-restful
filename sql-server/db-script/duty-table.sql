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