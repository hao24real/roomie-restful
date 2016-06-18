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