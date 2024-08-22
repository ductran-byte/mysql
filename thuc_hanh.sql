
CREATE DATABASE XgameBattle;
USE XgameBattle;
-- PlayerTable
CREATE TABLE PlayerTable (
    PlayerId VARCHAR(36) PRIMARY KEY,
    PlayerName NVARCHAR(100) NOT NULL,
    PlayerNatinal NVARCHAR(100)
);
-- ItemTable
CREATE TABLE ItemTable (
    ItemId VARCHAR(36) PRIMARY KEY,
    ItemName NVARCHAR(120) NOT NULL,
    ItemTypeId INT NOT NULL,
    Price INT NOT NULL
);
-- ItemTypeTable
CREATE TABLE ItemTypeTable (
    ItemTypeId INT PRIMARY KEY,
    ItemTypeName NVARCHAR(50) NOT NULL
);
-- PlayerItem
CREATE TABLE PlayerItem (
    ItemId VARCHAR(36),
    PlayerId VARCHAR(36),
    PRIMARY KEY (ItemId, PlayerId),
    FOREIGN KEY (ItemId) REFERENCES ItemTable(ItemId),
    FOREIGN KEY (PlayerId) REFERENCES PlayerTable(PlayerId)
);
INSERT INTO PlayerTable (PlayerId, PlayerName, PlayerNatinal)
VALUES 
('2C16E515-83AF-4D37-8A21-58AFD900E3F6', N'Player 1', N'Viet Nam'),
('D401EA60-7A83-4C7E-BF6E-707CF1F3E57E', N'Player 2', N'US');

-- ItemTable
INSERT INTO ItemTable (ItemId, ItemName, ItemTypeId, Price)
VALUES 
('72B83972-051D-4B96-B229-05DE585DF1EE', N'Gun', 1, 5),
('83B931C2-AC84-4080-9852-5734C4E05082', N'Bullet', 1, 10),
('97E25C9F-FA12-4D9A-AB32-D62EBC2107BF', N'Shield', 2, 20);

--  ItemTypeTable
INSERT INTO ItemTypeTable (ItemTypeId, ItemTypeName)
VALUES 
(1, N'Attack'),
(2, N'Defense');

-- PlayerItem
INSERT INTO PlayerItem (ItemId, PlayerId)
VALUES 
('72B83972-051D-4B96-B229-05DE585DF1EE', '2C16E515-83AF-4D37-8A21-58AFD900E3F6'),
('72B83972-051D-4B96-B229-05DE585DF1EE', 'D401EA60-7A83-4C7E-BF6E-707CF1F3E57E'),
('83B931C2-AC84-4080-9852-5734C4E05082', '2C16E515-83AF-4D37-8A21-58AFD900E3F6'),
('83B931C2-AC84-4080-9852-5734C4E05082', 'D401EA60-7A83-4C7E-BF6E-707CF1F3E57E'),
('97E25C9F-FA12-4D9A-AB32-D62EBC2107BF', '2C16E515-83AF-4D37-8A21-58AFD900E3F6'),
('97E25C9F-FA12-4D9A-AB32-D62EBC2107BF', 'D401EA60-7A83-4C7E-BF6E-707CF1F3E57E');

DELIMITER //

CREATE PROCEDURE CalculateMaxPriceForPlayer1()
BEGIN
    SELECT MAX(I.Price) AS MaxPrice
    FROM PlayerItem PI
    JOIN ItemTable I ON PI.ItemId = I.ItemId
    JOIN PlayerTable P ON PI.PlayerId = P.PlayerId
    WHERE P.PlayerName = N'Player 1';
END //

DELIMITER ;
CALL CalculateMaxPriceForPlayer1();

DELIMITER //

CREATE PROCEDURE RetrieveDataOrderByPlayerName_Subquery()
BEGIN
    SELECT 
        P.PlayerName, 
        I.ItemName, 
        IT.ItemTypeName, 
        I.Price
    FROM PlayerTable P
    JOIN PlayerItem PI ON P.PlayerId = PI.PlayerId
    JOIN ItemTable I ON PI.ItemId = I.ItemId
    JOIN ItemTypeTable IT ON I.ItemTypeId = IT.ItemTypeId
    WHERE P.PlayerId IN (
        SELECT DISTINCT PlayerId
        FROM PlayerItem
    )
    ORDER BY P.PlayerName;
END //

DELIMITER ;
CALL RetrieveDataOrderByPlayerName_Subquery();
