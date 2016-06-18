CREATE PROC AddUsersToGroup
	@groupId int,
	@userIds varchar(1000)
AS
DECLARE
	@idString varchar(10),
	@userId int,
	@stringIndex int
WHILE LEN(@userIds) > 0
BEGIN
	SET @stringIndex = CHARINDEX('|', @userIds)
	SET @idString = SUBSTRING(@userIds, 0, @stringIndex)
	SET @userId = CAST(@idString AS int)
	SET @userIds = SUBSTRING(@userIds, @stringIndex + 1, LEN(@userIds) - @stringIndex)
	IF NOT EXISTS (SELECT ID FROM Groups_Users WHERE GroupID = @groupId AND UserID = @userId)
	BEGIN
		INSERT INTO Groups_Users
		(
			GroupID,
			UserID
		)
		VALUES
		(
			@groupId,
			@userId
		)
	END
END
SELECT * FROM Groups WHERE ID = @groupId
GO

CREATE PROC ChangePassword
@userId int,
@password varchar(30)
AS
UPDATE Users
SET Password = @password
WHERE ID = @userId
SELECT * FROM Users WHERE ID = @userId
GO

CREATE PROC CompleteCommonGood
  @csgid int,
  @price float
  AS
    DECLARE @rot int;
    DECLARE @next int;
    DECLARE @userid int;
    SELECT @userid = CommonGoods.PurchaserID FROM CommonGoods
      WHERE ID = @csgid
    SELECT @rot = Users_CommonGoods.Rotation FROM Users_CommonGoods
      WHERE UserID = @userid AND CommonGoodID = @csgid;
    IF NOT EXISTS(SELECT Users_CommonGoods.UserID FROM Users_CommonGoods
      WHERE CommonGoodID = @csgid AND Rotation = @rot + 1
    ) BEGIN
      SELECT @next = Users_CommonGoods.UserID FROM Users_CommonGoods
        WHERE CommonGoodID = @csgid AND Rotation = 1;
    END
    ELSE BEGIN
      SELECT @next = Users_CommonGoods.UserID FROM Users_CommonGoods
        WHERE CommonGoodID = @csgid AND Rotation = @rot + 1;    
    END
    UPDATE CommonGoods
      SET PurchaserID = @next
      WHERE ID = @csgid;
    INSERT INTO CommonGoodLog(Name, Description, PurchaseDate, CommonGoodID, PurchaserID, Price, GroupID)
      SELECT CommonGoods.name, CommonGoods.Description, GETDATE(), @csgid, @userid, @price, CommonGoods.GroupID
      FROM CommonGoods WHERE ID = @csgid;
  SELECT CommonGoods.ID AS GoodID, Name, Description, GroupID, Users.* FROM CommonGoods, Users
  WHERE CommonGoods.ID = @csgid AND Users.ID = CommonGoods.PurchaserID
GO

CREATE PROC CompleteDuty
  @dutyid int
  AS
    DECLARE @rot int;
    DECLARE @next int;
    DECLARE @userid int;
    SELECT @userid = Duties.CurrentAssigneeID FROM Duties
      WHERE ID = @dutyid
    SELECT @rot = Users_Duties.Rotation FROM Users_Duties
      WHERE UserID = @userid AND DutyID = @dutyid;
    IF NOT EXISTS(SELECT Users_Duties.UserID FROM Users_Duties
      WHERE DutyID = @dutyid AND Rotation = @rot + 1
    ) BEGIN
      SELECT @next = Users_Duties.UserID FROM Users_Duties
        WHERE DutyID = @dutyid AND Rotation = 1;
    END
    ELSE BEGIN
      SELECT @next = Users_Duties.UserID FROM Users_Duties
        WHERE DutyID = @dutyid AND Rotation = @rot + 1;    
    END
    UPDATE Duties
      SET CurrentAssigneeID = @next
      WHERE ID = @dutyid;
    INSERT INTO DutyLog(Name, Description, DutyGroupID, CompletionDate, DutyID, AssigneeID)
      SELECT Duties.name, Duties.Description, Duties.DutyGroupID, GETDATE(), @dutyid, @userid
      FROM Duties WHERE ID = @dutyid;
  SELECT Duties.ID AS DutyID, Name, Description, DutyGroupID, Users.* FROM Duties, Users
  WHERE Duties.ID = @dutyid AND Duties.CurrentAssigneeID = Users.ID
GO

CREATE PROC CreateBill
@owner_id int,
@name varchar(30),
@description varchar(100),
@amount float (53),
@owee_id int
AS
	INSERT INTO Bills(
		OwnerID,
		Name,
		Description,
		Amount,
		OweeID
	)
	VALUES(
		@owner_id,
		@name,
		@description,
		@amount,
		@owee_id
	)
	SELECT * FROM Bills WHERE ID = SCOPE_IDENTITY()
GO

CREATE PROC CreateBulletin
@groupid int,
@content varchar(250)
AS
	INSERT INTO Bulletin(
		GroupID,
		Content
	)
	VALUES(
		@groupid,
		@content
	)
	SELECT * FROM Bulletin WHERE ID = SCOPE_IDENTITY()
GO

CREATE PROC CreateCommonGood
  @name varchar(30),
  @desc varchar(300),
  @groupId int,
  @userIds varchar(1000)
  AS
    DECLARE
   @idString varchar(10),
   @userId int,
   @stringIndex int,
   @index int,
   @csgid int
    SET @index = 0
    WHILE LEN(@userIds) > 0
    BEGIN
      SET @index = @index + 1
      SET @stringIndex = CHARINDEX('|', @userIds)
      SET @idString = SUBSTRING(@userIds, 0, @stringIndex)
      SET @userId = CAST(@idString AS int)
      SET @userIds = SUBSTRING(@userIds, @stringIndex + 1, LEN(@userIds) - @stringIndex)
      IF @index = 1
      BEGIN
        INSERT INTO CommonGoods(Name, Description, PurchaserID, GroupID)
          VALUES (@name, @desc, @userID, @groupId)
        SET @csgid = SCOPE_IDENTITY()
      END
      INSERT INTO Users_CommonGoods(UserID, CommonGoodID, Rotation)
        VALUES(@userId, @csgid, @index);
    END
  SELECT CommonGoods.ID AS GoodID, Name, Description, GroupID, Users.* FROM CommonGoods, Users
  WHERE CommonGoods.ID = @csgid AND Users.ID = CommonGoods.PurchaserID
GO

CREATE PROC CreateDuty
  @name varchar(30),
  @desc varchar(300),
  @group int,
  @userIds varchar(1000)
  AS
    DECLARE
	 @idString varchar(10),
	 @userId int,
	 @stringIndex int,
	 @index int,
	 @dutyid int
    SET @index = 0
    WHILE LEN(@userIds) > 0
    BEGIN
      SET @index = @index + 1
      SET @stringIndex = CHARINDEX('|', @userIds)
      SET @idString = SUBSTRING(@userIds, 0, @stringIndex)
      SET @userId = CAST(@idString AS int)
      SET @userIds = SUBSTRING(@userIds, @stringIndex + 1, LEN(@userIds) - @stringIndex)
      IF @index = 1
      BEGIN
        INSERT INTO Duties(Name, Description, DutyGroupID, CurrentAssigneeID)
          VALUES (@name, @desc, @group, @userID)          
        SET @dutyid = SCOPE_IDENTITY()
      END
      INSERT INTO Users_Duties(UserID, DutyID, Rotation)
        VALUES(@userId, @dutyid, @index);
    END
  SELECT Duties.ID AS DutyID, Name, Description, DutyGroupID, Users.*
  FROM Duties, Users WHERE Duties.ID = @dutyid AND Duties.CurrentAssigneeID = Users.ID
GO

CREATE PROCEDURE CreateGroup
@name varchar(30),
@description varchar(100),
@userId int
AS
DECLARE
	@groupId int,
	@userString varchar(11)
INSERT INTO Groups
(
	Name,
	Description
)
VALUES
(
	@name,
	@description
)
SET @groupId = SCOPE_IDENTITY()
SET @userString = CONCAT(CAST(@userId AS varchar(10)), '|')
EXEC AddUsersToGroup @groupId = @groupId, @userIds = @userString
GO

CREATE PROCEDURE CreateUser
@firstName varchar(30),
@lastName varchar(30),
@username varchar(30),
@email varchar(30),
@password varchar(30)
AS
	INSERT INTO Users(
  	FirstName,
    LastName,
    Username,
    Email,
    Password,
    KarmaScore,
    GeoVisibility
  )
  VALUES (
  	@firstName,
    @lastName,
    @username,
    @email,
    @password,
    0,
    0
	)
    SELECT * FROM Users WHERE ID = SCOPE_IDENTITY()
GO

CREATE PROC DeleteBill
@id int
AS
	SELECT * FROM Bills where ID = @id
	DELETE FROM Bills where ID = @id
GO

CREATE PROC FindBills
@owner_id int
AS
	SELECT * FROM Bills WHERE OwnerID = @owner_id OR OweeID = @owner_id
GO

CREATE PROC FindBulletins
@groupid int
AS
	SELECT * FROM Bulletin WHERE GroupID = @groupid
GO

CREATE PROCEDURE FindGroup
@id int,
@name varchar(30)
AS
SELECT * FROM Groups WHERE ID = @id OR Name = @name
GO

CREATE PROC FindUser
@id int,
@username varchar(30),
@email varchar(30)
AS
  IF NOT EXISTS (SELECT Users.*, Groups_Users.GroupID from Users, Groups_Users WHERE (Users.ID=@id OR Users.Email=@email OR Users.Username=@username) AND Users.ID = Groups_Users.UserID)
  BEGIN
    SELECT *, NULL AS GroupID from Users WHERE ID=@id OR Email=@email OR Username=@username
  END
  ELSE
  BEGIN
    SELECT Users.*, Groups_Users.GroupID from Users, Groups_Users WHERE (Users.ID=@id OR Users.Email=@email OR Users.Username=@username) AND Users.ID = Groups_Users.UserID
  END
GO

CREATE PROC FindUserFromGroup
@groupid int,
@userid int
As
SELECT Users.Token
  FROM Users JOIN Groups_Users
    ON Users.ID = Groups_Users.UserID
WHERE Groups_Users.GroupID = @groupid AND NOT Users.ID  = @userid
GO

CREATE PROC GetBillTimeDiff
  @id int
  AS
    DECLARE @timeStr varchar(25);
    SELECT @timeStr = TimeReminded FROM Bills WHERE ID = @id;
    SELECT DATEDIFF(hh, @timeStr, GETDATE());
GO

CREATE PROC GetCommonGoodUsers
@goodId int
AS
	SELECT Users.*  FROM Users, Users_CommonGoods WHERE Users_CommonGoods.CommonGoodID = @goodId AND Users.ID = Users_CommonGoods.UserID
GO

CREATE PROC GetCSGTimeDiff
  @id int
  AS
    DECLARE @timeStr varchar(25);
    SELECT @timeStr = TimeReminded FROM CommonGoods WHERE ID = @id;
    SELECT DATEDIFF(hh, @timeStr, GETDATE());
GO

CREATE PROC GetDutyTimeDiff
  @id int
  AS
    DECLARE @timeStr varchar(25);
    SELECT @timeStr = TimeReminded FROM Duties WHERE ID = @id;
    SELECT DATEDIFF(hh, @timeStr, GETDATE());
GO

CREATE PROC GetDutyUsers
@dutyId int
AS
	SELECT Users.* FROM Users, Users_Duties WHERE Users_Duties.DutyID = @dutyId AND Users.ID = Users_Duties.UserID
GO

CREATE PROC GetGroupCommonGoodLogs
	@groupID int
AS
SELECT CommonGoodLog.* FROM CommonGoodLog, CommonGoods WHERE CommonGoods.GroupID = @groupID AND CommonGoods.ID = CommonGoodLog.CommonGoodID
ORDER BY PurchaseDate DESC
GO

CREATE PROC GetGroupCommonGoods
	@groupID int
AS
SELECT CommonGoods.ID AS GoodID, Name, Description, GroupID, Users.*, TimeReminded
FROM CommonGoods, Users WHERE CommonGoods.GroupID = @groupID AND CommonGoods.PurchaserID = Users.ID
GO

CREATE PROC GetGroupDuties
	@groupID int
AS
SELECT Duties.ID AS DutyID, Name, Description, DutyGroupID, Users.*, TimeReminded
FROM Duties, Users WHERE Duties.DutyGroupID = @groupID AND Duties.CurrentAssigneeID = Users.ID
GO

CREATE PROC GetGroupDutyLogs
	@groupID int
AS
SELECT * FROM DutyLog WHERE DutyGroupID = @groupID ORDER BY CompletionDate DESC
GO

CREATE PROC GetGroups
@userId int
AS
SELECT Groups.* FROM Groups, Groups_Users WHERE Groups_Users.UserID = @userId AND Groups.ID = Groups_Users.GroupID
GO

CREATE PROC GetGroupUsers
@groupId int
AS
	SELECT Users.* FROM Users, Groups_Users WHERE Groups_Users.GroupID = @groupId AND Users.ID = Groups_Users.UserID
GO

CREATE PROC GetUserById
	@userId int
AS
SELECT * FROM Users WHERE ID = @userId
GO

CREATE PROC GetUserTasks
	@groupID int,
	@userID int
AS
SELECT Type = 1, ID, Name, Description, DutyGroupID AS GroupID, CurrentAssigneeID AS UserID
FROM Duties WHERE DutyGroupID = @groupID AND CurrentAssigneeID = @userID
UNION
SELECT Type = 2, ID, Name, Description, GroupID, PurchaserID AS UserID
FROM CommonGoods WHERE GroupID = @groupID AND PurchaserID = @userID
GO

CREATE PROC LeaveGroup
	@groupId int,
	@userId int
AS
BEGIN
	DELETE FROM Groups_Users WHERE GroupID = @groupID AND UserID = @userId
	SELECT * FROM Users WHERE ID = @userID
END
GO

CREATE PROCEDURE Login
@username varchar(30),
@password varchar(30)
AS
SELECT * FROM Users WHERE Username= @username AND Password = @password
GO

CREATE PROC ModifyBill
@id int,
@name varchar(30),
@description varchar(100),
@amount float
As
	UPDATE Bills
	SET Name = @name,
	    Description = @description,
	    Amount = @amount
	WHERE ID = @id;
	SELECT * FROM Bills WHERE ID = @id
GO

CREATE PROC ModifyBulletin
@id int,
@content varchar(250)
As
	UPDATE Bulletin
	SET Content = @content
	WHERE ID = @id;
	SELECT * FROM Bulletin WHERE ID = @id
GO

CREATE PROC ModifyCommonGood
  @csgid int,
  @name varchar(30),
  @desc varchar(300),
  @userIds varchar(1000)
  AS
    DECLARE
   @idString varchar(10),
   @userId int,
   @stringIndex int,
   @index int,
   @current int
    DELETE FROM Users_CommonGoods WHERE CommonGoodID = @csgid
    UPDATE CommonGoods SET Name = @name, Description = @desc WHERE ID = @csgid
    SET @index = 0
    WHILE LEN(@userIds) > 0
    BEGIN
      SET @index = @index + 1
      SET @stringIndex = CHARINDEX('|', @userIds)
      SET @idString = SUBSTRING(@userIds, 0, @stringIndex)
      SET @userId = CAST(@idString AS int)
      SET @userIds = SUBSTRING(@userIds, @stringIndex + 1, LEN(@userIds) - @stringIndex)
      INSERT INTO Users_CommonGoods(UserID, CommonGoodID, Rotation)
        VALUES(@userId, @csgid, @index);
    END
    SELECT @current = PurchaserID FROM CommonGoods WHERE ID = @csgid
    IF NOT EXISTS(SELECT ID FROM Users_CommonGoods WHERE CommonGoodID = @csgid AND UserID = @current)
    BEGIN
      SELECT @current = UserID FROM Users_CommonGoods WHERE CommonGoodID = @csgid AND Rotation = 1
      UPDATE CommonGoods SET PurchaserID = @current WHERE ID = @csgid
    END
  SELECT CommonGoods.ID AS GoodID, Name, Description, GroupID, Users.* FROM CommonGoods, Users
  WHERE CommonGoods.ID = @csgid AND Users.ID = CommonGoods.PurchaserID
GO

CREATE PROC ModifyDuty
  @dutyid int,
  @name varchar(30),
  @desc varchar(300),
  @userIds varchar(1000)
  AS
    DECLARE
	 @idString varchar(10),
	 @userId int,
	 @stringIndex int,
	 @index int,
	 @current int
    DELETE FROM Users_Duties WHERE DutyID = @dutyid
    UPDATE Duties SET Name = @name, Description = @desc WHERE ID = @dutyid
    SET @index = 0
    WHILE LEN(@userIds) > 0
    BEGIN
      SET @index = @index + 1
      SET @stringIndex = CHARINDEX('|', @userIds)
      SET @idString = SUBSTRING(@userIds, 0, @stringIndex)
      SET @userId = CAST(@idString AS int)
      SET @userIds = SUBSTRING(@userIds, @stringIndex + 1, LEN(@userIds) - @stringIndex)
      INSERT INTO Users_Duties(UserID, DutyID, Rotation)
        VALUES(@userId, @dutyid, @index);
    END
    SELECT @current = CurrentAssigneeID FROM Duties WHERE ID = @dutyid
    IF NOT EXISTS(SELECT ID FROM Users_Duties WHERE DutyID = @dutyid AND UserID = @current)
    BEGIN
      SELECT @current = UserID FROM Users_Duties WHERE DutyID = @dutyid AND Rotation = 1
      UPDATE Duties SET CurrentAssigneeID = @current WHERE ID = @dutyid
    END
  SELECT Duties.ID AS DutyID, Name, Description, DutyGroupID, Users.*
  FROM Duties, Users WHERE Duties.ID = @dutyid AND Duties.CurrentAssigneeID = Users.ID
GO

CREATE PROC ProfileUpdate
@id int,
@firstName varchar(30),
@lastName varchar(30),
@email varchar(30),
@groupid int,
@groupDescription varchar(30)
AS
	UPDATE Users
	SET FirstName = @firstName,
	    LastName = @lastName,
	    Email = @email
	WHERE ID = @id;
    Update Groups
    SET Description = @groupDescription
    WHERE ID = @groupid;
    SELECT * FROM Users WHERE ID = @id
GO

CREATE PROC RefreshBillTime
@id int
AS
UPDATE Bills
SET TimeReminded = '2010-01-22 15:29:55.090'
WHERE ID = @id;
GO

CREATE PROC RefreshCSGTime
@id int
AS
UPDATE CommonGoods
SET TimeReminded = '2010-01-22 15:29:55.090'
WHERE ID = @id;
GO

CREATE PROC RefreshDutyTime
@id int
AS
UPDATE Duties
SET TimeReminded = '2010-01-22 15:29:55.090'
WHERE ID = @id;
GO

CREATE PROC RefreshToken
  @userid int,
  @token varchar(200)
  AS
    UPDATE Users SET Token = @token WHERE ID = @userid
GO

CREATE PROC RemoveBulletin
@id int
AS
	SELECT * FROM Bulletin where ID = @id
	DELETE FROM Bulletin where ID = @id
GO

CREATE PROC RemoveCommonGood
	@csgID int
AS
BEGIN
	SELECT CommonGoods.ID AS GoodID, Name, Description, GroupID, Users.* FROM CommonGoods, Users
     WHERE CommonGoods.ID = @csgid AND Users.ID = CommonGoods.PurchaserID
	DELETE FROM CommonGoodLog WHERE CommonGoodID = @csgID
	DELETE FROM Users_CommonGoods WHERE CommonGoodID = @csgID
	DELETE FROM CommonGoods WHERE ID = @csgID
END
GO

CREATE PROC RemoveDuty
	@dutyID int
AS
BEGIN
	SELECT Duties.ID AS DutyID, Name, Description, DutyGroupID, Users.*
	FROM Duties, Users WHERE Duties.ID = @dutyID AND Duties.CurrentAssigneeID = Users.ID
	DELETE FROM DutyLog WHERE DutyID = @dutyID
	DELETE FROM Users_Duties WHERE DutyID = @dutyID
	DELETE FROM Duties WHERE ID = @dutyID
END
GO

CREATE PROC SetProfileIcon
@userId int,
@profileIcon varbinary(8000)
AS
UPDATE Users SET ProfileIcon = @profileIcon WHERE ID = @userId
SELECT * FROM Users WHERE ID = @userId
GO

CREATE PROC UpdateBillTime
@id int
AS
UPDATE Bills
SET TimeReminded=GETDATE()
WHERE ID = @id
GO

CREATE PROC UpdateCSGTime
@id int
AS
UPDATE CommonGoods
SET TimeReminded=GETDATE()
WHERE ID = @id
GO

CREATE PROC UpdateDutyTime
@id int
AS
UPDATE Duties
SET TimeReminded = GETDATE()
WHERE ID = @id
GO

