use MuOnlineS6

CREATE TABLE dbo.NPC_RESCUE_ITENS (
    ID INT IDENTITY(0,1) PRIMARY KEY,
    Account VARCHAR(10),
    ItemIndex INT,
    [Level] INT,
    Option1 INT,
    Option2 INT,
    Option3 INT,
    Exc INT,
    Ancient INT,
    JoH INT,
    SockBonus INT,
    Sock1 INT,
    Sock2 INT,
    Sock3 INT,
    Sock4 INT,
    Sock5 INT,
    Delivered INT,
    ItemTimeExpire INT,
    TimeExpire DATETIME,
    TimeDelivered DATETIME NULL
);