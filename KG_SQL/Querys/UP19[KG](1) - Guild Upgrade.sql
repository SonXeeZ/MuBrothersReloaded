USE [MuOnlineS6]

alter table Guild add TotalDevote int default(0);
alter table Guild add LevelDevote int default(0);
alter table GuildMemBer add Devote int default(0);