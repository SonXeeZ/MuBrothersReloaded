--[[ BootSystem ]]--

BootSystem = {}

BOOT_SYSTEM_SWITCH = 0

--[[

About the system:

This system simply logs characters into the game. They will be logged in at the location where the account is registered in the Character database, and if they have items, those items will appear, etc.

It's a "Boot" system where you need to add existing accounts to the "InjectPlayers" list. You can configure these accounts with items, etc., and have them log in automatically.

The number of accounts is limited to the online user license limit.

The system accepts /move commands, so if you're using the character with the STAFF role and use the /move command, it will work.

--]]

-- Note: Only add characters that exist in the Character and AccountCharacter databases here.

InjectPlayers = {
	{Account = "kosh", Password = "1212", Character = "Kosh"},
}

local BotHandles = {}

function BootSystem.Add(index, account, password, name)
	gObjAdd(0, "127.0.0.1", index)
	
	local player = User.new(index)
	
	player:setLoginMessageSend(1)

	player:setLoginMessageCount(1)

	player:setCheckSumTime(GetTick())
	
	player:setConnectCheckTime(GetTick())

	AccountInfoSend(index, account, password)

	Timer.TimeOut(2, BootSystem.AddCharacter, index, account, password, name)

	BotHandles[index] = {aIndex = index}
end

function BootSystem.AddCharacter(index, account, password, name)
	local player = User.new(index)

	if player:getConnected() ~= 2
	then
		gObjDel(index)
		BotHandles[index] = nil
		LogAddC(2, string.format("It was not possible to create the Boot [%s]", name))
		return
	end

	CharacterInfoSend(index, name, account)
end

function BootSystem.GetSlot()
	return SearchIndex(0, "127.0.0.1")
end

function BootSystem.Checking()
	for i in pairs(BotHandles) do
		local boot = BotHandles[i]

		if gObjIsConnectedGP(boot.aIndex) ~= 0
		then
			local player = User.new(boot.aIndex)

			player:setCheckSumTime(GetTick())
			player:setConnectCheckTime(GetTick())

			player = nil
		end
	end
end

function BootSystem.CharacterMove(aIndex, map, x, y)
	if BotHandles[aIndex]
	then
		local player = User.new(aIndex)
		
		player:setX(x)
		
		player:setTX(x)
		
		player:setY(y)
		
		player:setTY(y)
		
		player:setMapNumber(map)
		
		player:setTeleport(0)
		
		player:setPathCount(0)
		
		player:setRegenMapNumber(map)
		
		player:setRegenMapX(x)
		
		player:setRegenMapY(y)
		
		player:setRegenTime(0)
		
		ViewportCreate(aIndex)

		player = nil
		return 1
	end
	
	return
end

function BootSystem.ClearBoot()
	for i = OBJECT_START_USER, MAX_OBJECT do
		local player = User.new(i)
		if player:getConnected() ~= 0
		then
			for n in ipairs(InjectPlayers) do
				if InjectPlayers[n].Account == player:getAccountID()
				then
					gObjDel(i)
				end
			end
		end
	end
end

function BootSystem.CreateBoot()
	Timer.Interval(1, BootSystem.Checking)

	for i in ipairs(InjectPlayers) do
		local index = BootSystem.GetSlot()
	
		if index ~= -1
		then
			BootSystem.Add(index, InjectPlayers[i].Account, InjectPlayers[i].Password, InjectPlayers[i].Character)
		end
	end
end

function BootSystem.IsBoot(aIndex)
	if BotHandles[aIndex] ~= nil
	then
		return 1
	end
	
	return -1
end

function BootSystem.Start()
	if BOOT_SYSTEM_SWITCH == 0
	then
		return
	end

	BootSystem.ClearBoot()
	BootSystem.CreateBoot()
end

Timer.TimeOut(2, BootSystem.Start)
GameServerFunctions.CharacterMove(BootSystem.CharacterMove)

return BootSystem