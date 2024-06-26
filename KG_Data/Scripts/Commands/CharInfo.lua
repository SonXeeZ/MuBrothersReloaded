--[[ Char Info System ]]--
CharInfo = {}

function CharInfo.Command(aIndex, Arguments)
	if CHARINFO_SWITCH == 0
	then
		return
	end
	
	local player = User.new(aIndex)
	local Language = player:getLanguage()
	
	if player:getVip() < CHARINFO_VIP
	then
		SendMessage(string.format(CHAR_INFO_MESSAGES[Language][1]), aIndex, 1)
		return
	end
	
	local Name = command:getString(Arguments, 1, 0)
	
	if #Name <= 0
	then
		Name = player:getName()
	end
	
	local TargetIndex = GetIndex(Name)
	
	if TargetIndex == -1
	then
		SendMessage(string.format(CHAR_INFO_MESSAGES[Language][2], Name), aIndex, 1)
		return
	end
	
	local target_player = User.new(TargetIndex)
	
	SendMessage(string.format(CHAR_INFO_MESSAGES[Language][3], Name, target_player:getReset(), target_player:getMasterReset(), target_player:getLevel()), aIndex, 1)
	
	if player:getClass() == CLASS_DL
	then
		SendMessage(string.format(CHAR_INFO_MESSAGES[Language][5], target_player:getStrength(), target_player:getDexterity(), target_player:getVitality(), target_player:getEnergy(), target_player:getLeaderShip()), aIndex, 1)
	else
		SendMessage(string.format(CHAR_INFO_MESSAGES[Language][4], target_player:getStrength(), target_player:getDexterity(), target_player:getVitality(), target_player:getEnergy()), aIndex, 1)
	end
	
	
end

Commands.Register(CHARINFO_COMMAND, CharInfo.Command)

return CharInfo