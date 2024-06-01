--[[
System
]]--
NpcRescueItem = {}

NpcRescueItemPlayers = {}

function NpcRescueItem.NpcTalk(NpcIndex, PlayerIndex)
	local npc = User.new(NpcIndex)
	local player = User.new(PlayerIndex)
	
	if (npc:getClass() == NPC_RESCUE_MONSTER_ID)
	then
		NpcRescueItem.Open(player, npc)
	end
	
	npc = nil
	player = nil
end

function NpcRescueItem.InsertItem(Account, Item, Itemlevel, iOp1, iOp2, iOp3, iExc, iAncient, iJoH, iSockCount, iSock1, iSock2, iSock3, iSock4, iSock5, DaysExpire, ItemTimeExpire)
	if ItemTimeExpire == nil
	then
		ItemTimeExpire = 0
	end

	local query = string.format("INSERT INTO [dbo].[NPC_RESCUE_ITENS] ([Account],[ItemIndex],[Level],[Option1],[Option2],[Option3],[Exc],[Ancient],[JoH],[SockBonus],[Sock1],[Sock2],[Sock3],[Sock4],[Sock5],[Delivered],[ItemTimeExpire],[TimeExpire]) VALUES ('%s',%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,0,%d,DATEADD(day,%d,GETDATE()))", Account, Item, Itemlevel, iOp1, iOp2, iOp3, iExc, iAncient, iJoH, iSockCount, iSock1, iSock2, iSock3, iSock4, iSock5, ItemTimeExpire, DaysExpire)
	
	CreateAsyncQuery('NpcRescueInsertItem', query, -1, 0)
end

function NpcRescueItem.Open(player, npc)
	local Language = player:getLanguage()
	
	if player:getInterfaceUse() ~= 0 or player:getInterfaceType() ~= 0 or player:getState() == 32 or player:getDieRegen() ~= 0 or player:getTeleport() ~= 0
	then
		SendMessage(string.format(NPC_RESCUE_MESSAGES[Language][1]), player:getIndex(), 1)
		return
	end
	
	if NpcRescueItemPlayers[player:getIndex()] ~= nil
	then
		local lastTime = math.floor((GetTick() - NpcRescueItemPlayers[player:getIndex()]) / 1000) 
		
		if lastTime <= 5
		then
			SendMessage(string.format(NPC_RESCUE_MESSAGES[Language][2]), player:getIndex(), 1)
			ChatTargetSend(npc:getIndex(), string.format(NPC_RESCUE_MESSAGES[Language][3]), player:getIndex())
			return
		end
	end

	local query = string.format("SELECT top 31 ID,ItemIndex,Level,Option1,Option2,Option3,Exc,Ancient,JoH,SockBonus,Sock1,Sock2,Sock3,Sock4,Sock5,TimeExpire FROM NPC_RESCUE_ITENS WHERE Account='%s' and Delivered=0 and TimeExpire >= GETDATE()", player:getAccountID())
	CreateAsyncQuery('PlayerOpenNpcRescue', query, player:getIndex(), 1)

	NpcRescueItemPlayers[player:getIndex()] = GetTick()

	player = nil
end

function NpcRescueItem.QueryAsyncProcess(queryName, identification, aIndex)
	if queryName == 'PlayerOpenNpcRescue'
	then
		if gObjIsConnectedGP(aIndex) ~= 0
		then
			local count = 0
			
			local ItensList = {}

			for n = 1, 31 do 
				local getItemID = tonumber(QueryAsyncGetValue(identification, 'ID'))
				local getItemIndex = tonumber(QueryAsyncGetValue(identification, 'ItemIndex'))
				local getLevel = tonumber(QueryAsyncGetValue(identification, 'Level'))
				local getOp1 = tonumber(QueryAsyncGetValue(identification, 'Option1'))
				local getOp2 = tonumber(QueryAsyncGetValue(identification, 'Option2'))
				local getOp3 = tonumber(QueryAsyncGetValue(identification, 'Option3'))
				local getExc = tonumber(QueryAsyncGetValue(identification, 'Exc'))
				local getAncient = tonumber(QueryAsyncGetValue(identification, 'Ancient'))
				local getJoH = tonumber(QueryAsyncGetValue(identification, 'JoH'))
				local getSockBonus = tonumber(QueryAsyncGetValue(identification, 'SockBonus'))
				local getSock1 = tonumber(QueryAsyncGetValue(identification, 'Sock1'))
				local getSock2 = tonumber(QueryAsyncGetValue(identification, 'Sock2'))
				local getSock3 = tonumber(QueryAsyncGetValue(identification, 'Sock3'))
				local getSock4 = tonumber(QueryAsyncGetValue(identification, 'Sock4'))
				local getSock5 = tonumber(QueryAsyncGetValue(identification, 'Sock5'))
				local getTimeExpire = tostring(QueryAsyncGetValue(identification, 'TimeExpire'))
				
				if getItemID == nil or getItemIndex == nil or getLevel == nil or getTimeExpire == nil
				then
					break
				end

				ItensList[count] = { ItemID = getItemID, ItemIndex = getItemIndex, Level = getLevel
				, Op1 = getOp1, Op2 = getOp2, Op3 = getOp3
				, Exc = getExc, Ancient = getAncient, JoH = getJoH
				, SockBonus = getSockBonus, Sock1 = getSock1, Sock2 = getSock2
				, Sock3 = getSock3, Sock4 = getSock4, Sock5 = getSock5
				, TimeExpire = getTimeExpire }
				
				count = count + 1
			end

			local packetIdentification = string.format('%s-%s', NPC_RESCUE_PACKET_NAME_GET, GetNameObject(aIndex))
			
			CreatePacket(packetIdentification, NPC_RESCUE_PACKET)
			
			SetDwordPacket(packetIdentification, count)
			
			for i = 0, count do
				if ItensList[i] ~= nil
				then
					SetDwordPacket(packetIdentification, ItensList[i].ItemID)
					SetWordPacket(packetIdentification, ItensList[i].ItemIndex)
					SetBytePacket(packetIdentification, ItensList[i].Level)
					SetBytePacket(packetIdentification, ItensList[i].Op1)
					SetBytePacket(packetIdentification, ItensList[i].Op2)
					SetBytePacket(packetIdentification, ItensList[i].Op3)
					SetBytePacket(packetIdentification, ItensList[i].Exc)
					SetBytePacket(packetIdentification, ItensList[i].Ancient)
					SetBytePacket(packetIdentification, ItensList[i].JoH)
					SetBytePacket(packetIdentification, ItensList[i].SockBonus)
					SetBytePacket(packetIdentification, ItensList[i].Sock1)
					SetBytePacket(packetIdentification, ItensList[i].Sock2)
					SetBytePacket(packetIdentification, ItensList[i].Sock3)
					SetBytePacket(packetIdentification, ItensList[i].Sock4)
					SetBytePacket(packetIdentification, ItensList[i].Sock5)
					SetCharPacketLength(packetIdentification, ItensList[i].TimeExpire, 16)
				end
			end
			
			SendPacket(packetIdentification, aIndex)
			
			ClearPacket(packetIdentification)
		end

		--clear async
		QueryAsyncDelete(identification)
		return 1
	elseif queryName == 'PlayerGetItemNpcRescue'
	then
		if gObjIsConnectedGP(aIndex) ~= 0
		then
			local getItemID = tonumber(QueryAsyncGetValue(identification, 'ID'))
			local getItemIndex = tonumber(QueryAsyncGetValue(identification, 'ItemIndex'))
			local getLevel = tonumber(QueryAsyncGetValue(identification, 'Level'))
			local getOp1 = tonumber(QueryAsyncGetValue(identification, 'Option1'))
			local getOp2 = tonumber(QueryAsyncGetValue(identification, 'Option2'))
			local getOp3 = tonumber(QueryAsyncGetValue(identification, 'Option3'))
			local getExc = tonumber(QueryAsyncGetValue(identification, 'Exc'))
			local getAncient = tonumber(QueryAsyncGetValue(identification, 'Ancient'))
			local getJoH = tonumber(QueryAsyncGetValue(identification, 'JoH'))
			local getSockBonus = tonumber(QueryAsyncGetValue(identification, 'SockBonus'))
			local getSock1 = tonumber(QueryAsyncGetValue(identification, 'Sock1'))
			local getSock2 = tonumber(QueryAsyncGetValue(identification, 'Sock2'))
			local getSock3 = tonumber(QueryAsyncGetValue(identification, 'Sock3'))
			local getSock4 = tonumber(QueryAsyncGetValue(identification, 'Sock4'))
			local getSock5 = tonumber(QueryAsyncGetValue(identification, 'Sock5'))
			local getItemTimeExpire = QueryAsyncGetValue(identification, 'ItemTimeExpire')

			local Language = GetLanguageObject(aIndex)

			if getItemID == nil or getItemIndex  == nil or getLevel == nil or getOp1 == nil or getSock3 == nil
			then
				SendMessage(string.format(NPC_RESCUE_MESSAGES[Language][4]), aIndex, 1)
				QueryAsyncDelete(identification)
				return 1
			end

			if InventoryCheckSpaceByItem(aIndex, getItemIndex) == 0
			then
				SendMessage(string.format(NPC_RESCUE_MESSAGES[Language][5]), aIndex, 1)
				QueryAsyncDelete(identification)
				return 1
			end

			local query = string.format("UPDATE NPC_RESCUE_ITENS SET Delivered=1,TimeDelivered=GetDate() WHERE Account='%s' and ID='%d'", GetAccountObject(aIndex), getItemID)
			CreateAsyncQuery('UpdateItemGetNpcRescue', query, -1, 0)

			CreateItemInventory(aIndex, getItemIndex, getLevel, getOp1, getOp2, getOp3, getExc, getAncient, getJoH, getSockBonus, getSock1, getSock2, getSock3, getSock4, getSock5, getItemTimeExpire)
	
			local packetIdentification = string.format('%s-%s', NPC_RESCUE_PACKET_GET_ITEM_RECV, GetNameObject(aIndex))
			
			CreatePacket(packetIdentification, NPC_RESCUE_PACKET)
			
			SetDwordPacket(packetIdentification, getItemID)
			
			SendPacket(packetIdentification, aIndex)
			
			ClearPacket(packetIdentification)
		end

		QueryAsyncDelete(identification)
		return 1
	end

	return 0
end

function NpcRescueItem.GetItem(player, PacketName)
	local Language = player:getLanguage()
	
	if player:getInterfaceUse() ~= 0 or player:getInterfaceType() ~= 0 or player:getState() == 32 or player:getDieRegen() ~= 0 or player:getTeleport() ~= 0
	then
		SendMessage(string.format(NPC_RESCUE_MESSAGES[Language][1]), player:getIndex(), 1)
		return
	end
	
	if NpcRescueItemPlayers[player:getIndex()] ~= nil
	then
		local lastTime = math.floor((GetTick() - NpcRescueItemPlayers[player:getIndex()]) / 1000) 
		
		if lastTime <= 2
		then
			return
		end
	end
	
	local ItemID = GetDwordPacket(PacketName, -1)

	ClearPacket(PacketName)

	local query = string.format("SELECT top 1 ID,ItemIndex,Level,Option1,Option2,Option3,Exc,Ancient,JoH,SockBonus,Sock1,Sock2,Sock3,Sock4,Sock5,ItemTimeExpire FROM NPC_RESCUE_ITENS WHERE Account='%s' and Delivered=0 and ID='%d' and TimeExpire >= GETDATE()", player:getAccountID(), ItemID)
	CreateAsyncQuery('PlayerGetItemNpcRescue', query, player:getIndex(), 1)
	
	NpcRescueItemPlayers[player:getIndex()] = GetTick()
	
	player = nil
end

function NpcRescueItem.Protocol(aIndex, Packet, PacketName)
	if Packet == NPC_RESCUE_PACKET
	then
		local player = User.new(aIndex)
		
		if string.format('%s-%s', NPC_RESCUE_PACKET_GET_ITEM_RECV, player:getName()) == PacketName
		then
			NpcRescueItem.GetItem(player, PacketName)
		end
	end
end

function NpcRescueItem.RunSQL()
	local query = string.format("IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NPC_RESCUE_ITENS]') AND type in (N'U')) BEGIN CREATE TABLE [dbo].[NPC_RESCUE_ITENS] ([ID] [int] IDENTITY(1,1) NOT NULL,[Account] [varchar](10) NOT NULL,[ItemIndex] [int] NOT NULL CONSTRAINT [DF_NPC_RESCUE_ITENS_ItemIndex]  DEFAULT ((0)),[Level] [int] NOT NULL CONSTRAINT [DF_NPC_RESCUE_ITENS_Level]  DEFAULT ((0)),[Option1] [int] NOT NULL CONSTRAINT [DF_NPC_RESCUE_ITENS_Option1]  DEFAULT ((0)),[Option2] [int] NOT NULL CONSTRAINT [DF_NPC_RESCUE_ITENS_Option2]  DEFAULT ((0)),[Option3] [int] NOT NULL CONSTRAINT [DF_NPC_RESCUE_ITENS_Option3]  DEFAULT ((0)),[Exc] [int] NOT NULL CONSTRAINT [DF_NPC_RESCUE_ITENS_Exc]  DEFAULT ((0)),[Ancient] [int] NOT NULL CONSTRAINT [DF_NPC_RESCUE_ITENS_Ancient]  DEFAULT ((0)),[JoH] [int] NOT NULL CONSTRAINT [DF_NPC_RESCUE_ITENS_JoH]  DEFAULT ((0)),[SockBonus] [int] NOT NULL CONSTRAINT [DF_NPC_RESCUE_ITENS_SockBonus]  DEFAULT ((0)),[Sock1] [int] NOT NULL CONSTRAINT [DF_NPC_RESCUE_ITENS_Sock1]  DEFAULT ((0)),[Sock2] [int] NOT NULL CONSTRAINT [DF_NPC_RESCUE_ITENS_Sock2]  DEFAULT ((0)),[Sock3] [int] NOT NULL CONSTRAINT [DF_NPC_RESCUE_ITENS_Sock3]  DEFAULT ((0)),[Sock4] [int] NOT NULL CONSTRAINT [DF_NPC_RESCUE_ITENS_Sock4]  DEFAULT ((0)),[Sock5] [int] NOT NULL CONSTRAINT [DF_NPC_RESCUE_ITENS_Sock5]  DEFAULT ((0)), [Delivered] [int] NOT NULL CONSTRAINT [DF_NPC_RESCUE_ITENS_Delivered]  DEFAULT ((0)), [ItemTimeExpire] [int] NOT NULL CONSTRAINT [DF_NPC_RESCUE_ITENS_ItemTimeExpire]  DEFAULT ((0)), [TimeExpire] [datetime] NOT NULL, [TimeDelivered] [datetime] NULL ) ON [PRIMARY] END")
	
	db = DataBase.getDb()
	db:exec(query)
	
	db:clear()

	DataBase.CreateColumn('NPC_RESCUE_ITENS', 'ItemTimeExpire', "INT NOT NULL DEFAULT 0")
end

function NpcRescueItem.SetNpc()
	for n = OBJECT_START_MONSTER, MAX_OBJECT_MONSTER do 
		local monster = User.new(n)

		if monster:getConnected() > 0
		then
			if monster:getClass() == NPC_RESCUE_MONSTER_ID
			then
				monster:setType(3)
			end
		end
	end
end

function NpcRescueItem.Init()
	if NPC_RESCUE_ITEM_SWITCH == 0
	then
		return
	end
	
	GameServerFunctions.NpcTalk(NpcRescueItem.NpcTalk)
	GameServerFunctions.GameServerProtocol(NpcRescueItem.Protocol)
	GameServerFunctions.QueryAsyncProcess(NpcRescueItem.QueryAsyncProcess)
	
	Timer.TimeOut(5, NpcRescueItem.RunSQL)

	NpcRescueItem.SetNpc()
end

NpcRescueItem.Init()

return NpcRescueItem