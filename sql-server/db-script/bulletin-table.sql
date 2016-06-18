CREATE TABLE "dbo"."Bulletin"
(
   ID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
   GroupID int NOT NULL,
   Content varchar(250) NOT NULL
)
GO
CREATE UNIQUE INDEX Pk_Bulletin ON "dbo"."Bulletin"(ID)
GO