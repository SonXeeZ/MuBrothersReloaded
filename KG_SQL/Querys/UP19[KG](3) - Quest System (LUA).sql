/****** Object:  Table [dbo].[QUEST_SYSTEM]    Script Date: 04/06/2021 16:10:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[QUEST_SYSTEM](
	[AccountID] [varchar](10) NOT NULL,
	[Name] [varchar](10) NULL,
	[QuestIdentification] [int] NOT NULL,
	[Kills] [int] NOT NULL,
	[KillsMonster1] [int] NOT NULL,
	[KillsMonster2] [int] NOT NULL,
	[KillsMonster3] [int] NOT NULL,
	[KillsMonster4] [int] NOT NULL,
	[KillsMonster5] [int] NOT NULL,
	[KillsMonster6] [int] NOT NULL,
	[KillsMonster7] [int] NOT NULL,
	[KillsMonster8] [int] NOT NULL,
	[KillsMonster9] [int] NOT NULL,
	[Finished] [int] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[QUEST_SYSTEM] ADD  CONSTRAINT [DF_QUEST_SYSTEM_QuestIdentification]  DEFAULT ((0)) FOR [QuestIdentification]
GO

ALTER TABLE [dbo].[QUEST_SYSTEM] ADD  CONSTRAINT [DF_QUEST_SYSTEM_Register1]  DEFAULT ((0)) FOR [Kills]
GO

ALTER TABLE [dbo].[QUEST_SYSTEM] ADD  CONSTRAINT [DF_Table_1_Register11]  DEFAULT ((0)) FOR [KillsMonster1]
GO

ALTER TABLE [dbo].[QUEST_SYSTEM] ADD  CONSTRAINT [DF_Table_1_Register11_1]  DEFAULT ((0)) FOR [KillsMonster2]
GO

ALTER TABLE [dbo].[QUEST_SYSTEM] ADD  CONSTRAINT [DF_Table_1_Register11_2]  DEFAULT ((0)) FOR [KillsMonster3]
GO

ALTER TABLE [dbo].[QUEST_SYSTEM] ADD  CONSTRAINT [DF_Table_1_Register11_3]  DEFAULT ((0)) FOR [KillsMonster4]
GO

ALTER TABLE [dbo].[QUEST_SYSTEM] ADD  CONSTRAINT [DF_Table_1_Register11_4]  DEFAULT ((0)) FOR [KillsMonster5]
GO

ALTER TABLE [dbo].[QUEST_SYSTEM] ADD  CONSTRAINT [DF_Table_1_Register11_5]  DEFAULT ((0)) FOR [KillsMonster6]
GO

ALTER TABLE [dbo].[QUEST_SYSTEM] ADD  CONSTRAINT [DF_Table_1_Register11_6]  DEFAULT ((0)) FOR [KillsMonster7]
GO

ALTER TABLE [dbo].[QUEST_SYSTEM] ADD  CONSTRAINT [DF_Table_1_Register11_7]  DEFAULT ((0)) FOR [KillsMonster8]
GO

ALTER TABLE [dbo].[QUEST_SYSTEM] ADD  CONSTRAINT [DF_Table_1_Register11_8]  DEFAULT ((0)) FOR [KillsMonster9]
GO

ALTER TABLE [dbo].[QUEST_SYSTEM] ADD  CONSTRAINT [DF_QUEST_SYSTEM_Finished]  DEFAULT ((0)) FOR [Finished]
GO


