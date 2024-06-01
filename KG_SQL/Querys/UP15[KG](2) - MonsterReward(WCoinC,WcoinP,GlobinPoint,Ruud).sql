USE [MuOnline]
GO
/****** Object:  StoredProcedure [dbo].[WZ_CustomMonsterReward]    Script Date: 09/24/2020 23:43:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[WZ_CustomMonsterReward] 
@Account varchar(10),
@Name varchar(10),
@MonsterClass int,
@MapNumber int,
@RewardValue1 int,
@RewardValue2 int,
@RewardValue3 int,
@RewardValue4 int
AS
BEGIN

SET NOCOUNT ON
SET XACT_ABORT ON

UPDATE CashShopData SET WCoinC=WCoinC+@RewardValue1,
WCoinP=WCoinP+@RewardValue2,
GoblinPoint=GoblinPoint+@RewardValue3,
Ruud=Ruud+@RewardValue4 WHERE AccountID=@Account

SET NOCOUNT OFF
SET XACT_ABORT OFF

END
