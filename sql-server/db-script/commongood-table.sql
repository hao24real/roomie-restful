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
