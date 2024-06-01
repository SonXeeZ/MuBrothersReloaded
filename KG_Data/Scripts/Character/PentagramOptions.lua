--[[
Configs pentagram add streng
]]--

Pentagram_Options = 0
Pentagram_Options_Info = {
	{ItemIndex = GET_ITEM(12, 150), Defense = 10, DefensePvP = 200, BlockSucess = 50, BlockSucessPvP = 30, AddLife = 0, AddMana = 0, MinDmgLeft = 100, MaxDmgLeft = 150, MinDmgRight = 100, MaxDmgRight = 150, MagicMinDmg = 100, MagicMaxDmg = 150, AttackSpeed = 0, MagicSpeed = 0},
	{ItemIndex = GET_ITEM(12, 151), Defense = 10, DefensePvP = 200, BlockSucess = 50, BlockSucessPvP = 30, AddLife = 0, AddMana = 15, MinDmgLeft = 100, MaxDmgLeft = 150, MinDmgRight = 100, MaxDmgRight = 150, MagicMinDmg = 100, MagicMaxDmg = 150, AttackSpeed = 0, MagicSpeed = 0},
	{ItemIndex = GET_ITEM(12, 152), Defense = 10, DefensePvP = 200, BlockSucess = 50, BlockSucessPvP = 30, AddLife = 0, AddMana = 0, MinDmgLeft = 100, MaxDmgLeft = 150, MinDmgRight = 100, MaxDmgRight = 150, MagicMinDmg = 100, MagicMaxDmg = 150, AttackSpeed = 0, MagicSpeed = 0},
	{ItemIndex = GET_ITEM(12, 153), Defense = 10, DefensePvP = 200, BlockSucess = 50, BlockSucessPvP = 30, AddLife = 0, AddMana = 54, MinDmgLeft = 100, MaxDmgLeft = 150, MinDmgRight = 100, MaxDmgRight = 150, MagicMinDmg = 100, MagicMaxDmg = 150, AttackSpeed = 0, MagicSpeed = 0},
	{ItemIndex = GET_ITEM(12, 154), Defense = 10, DefensePvP = 200, BlockSucess = 50, BlockSucessPvP = 30, AddLife = 0, AddMana = 0, MinDmgLeft = 100, MaxDmgLeft = 150, MinDmgRight = 100, MaxDmgRight = 150, MagicMinDmg = 100, MagicMaxDmg = 150, AttackSpeed = 0, MagicSpeed = 0},
	{ItemIndex = GET_ITEM(12, 155), Defense = 10, DefensePvP = 200, BlockSucess = 50, BlockSucessPvP = 30, AddLife = 0, AddMana = 0, MinDmgLeft = 100, MaxDmgLeft = 150, MinDmgRight = 100, MaxDmgRight = 150, MagicMinDmg = 100, MagicMaxDmg = 150, AttackSpeed = 0, MagicSpeed = 0},
	{ItemIndex = GET_ITEM(12, 156), Defense = 10, DefensePvP = 200, BlockSucess = 50, BlockSucessPvP = 30, AddLife = 0, AddMana = 0, MinDmgLeft = 100, MaxDmgLeft = 150, MinDmgRight = 100, MaxDmgRight = 150, MagicMinDmg = 100, MagicMaxDmg = 150, AttackSpeed = 0, MagicSpeed = 0},
}

PentagramOptions = {}

function PentagramOptions.ApplyDefenseSet(aIndex)
	if Pentagram_Options == 0
	then
		return
	end
	
	local player = User.new(aIndex)
	local pInv = Inventory.new(aIndex)
	
		if pInv:isItem(236) ~= 0
		then
			for i = 1, #Pentagram_Options_Info do
				local pentagram = Pentagram_Options_Info[i]
				
				if pentagram.ItemIndex == pInv:getIndex(236)
				then
				if pentagram.Defense > 0
				then
					player:setDefense((math.floor(player:getDefense() + pentagram.Defense)))
				end
				
				if pentagram.DefensePvP > 0
				then
					player:setDefensePvP((math.floor(player:getDefensePvP() + pentagram.DefensePvP)))
				end
				
				if pentagram.BlockSucess > 0
				then
					player:setSuccessBlock(math.floor(player:getSuccessBlock() + pentagram.BlockSucess))
				end
				
				if pentagram.BlockSucessPvP > 0
				then
					player:setSuccessBlockPvP(math.floor(player:getSuccessBlockPvP() + pentagram.BlockSucessPvP))
				end
				
				if pentagram.AddLife > 0
				then
					player:setAddLife((math.floor(player:getAddLife() + pentagram.AddLife)))
				end
				
				if pentagram.AddMana > 0
				then
					player:setAddMana((math.floor(player:getAddMana() + pentagram.AddMana)))
				end
				
				if pentagram.MinDmgLeft > 0
				then
					player:setAttackDamageMinLeft((math.floor(player:getAttackDamageMinLeft() + pentagram.MinDmgLeft)))
				end
				
				if pentagram.MaxDmgLeft > 0
				then
					player:setAttackDamageMaxLeft((math.floor(player:getAttackDamageMaxLeft() + pentagram.MaxDmgLeft)))
				end
				
				if pentagram.MinDmgRight > 0
				then
					player:setAttackDamageMinRight((math.floor(player:getAttackDamageMinRight() + pentagram.MinDmgRight)))
				end
				
				if pentagram.MaxDmgRight > 0
				then
					player:setAttackDamageMaxRight((math.floor(player:getAttackDamageMaxRight() + pentagram.MaxDmgRight)))
				end
				
				if pentagram.MagicMinDmg > 0
				then
					player:setMagicDamageMin((math.floor(player:getMagicDamageMin() + pentagram.MagicMinDmg)))
				end
				
				if pentagram.MagicMaxDmg > 0
				then
					player:setMagicDamageMax((math.floor(player:getMagicDamageMax() + pentagram.MagicMaxDmg)))
				end
				
				if pentagram.AttackSpeed > 0
				then
					player:setAttackSpeed((math.floor(player:getAttackSpeed() + pentagram.AttackSpeed)))
				end
				
				if pentagram.MagicSpeed > 0
				then
					player:setMagicSpeed((math.floor(player:getMagicSpeed() + pentagram.MagicSpeed)))
				end
			end
		end
	end
	
	pInv = nil
	player = nil
end

GameServerFunctions.CharacterSet(PentagramOptions.ApplyDefenseSet)

return PentagramOptions