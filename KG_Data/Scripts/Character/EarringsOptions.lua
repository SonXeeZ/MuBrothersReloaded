--[[
Configs earring add streng
]]--

Earring_Options = 0
Earring_Options_Info = {
	{ItemIndex = GET_ITEM(15, 40), Defense = 200, DefensePvP = 200, BlockSucess = 50, BlockSucessPvP = 30, AddLife = 0, AddMana = 0, MinDmgLeft = 100, MaxDmgLeft = 150, MinDmgRight = 100, MaxDmgRight = 150, MagicMinDmg = 100, MagicMaxDmg = 150, AttackSpeed = 0, MagicSpeed = 0},
}

EarringOptions = {}

function EarringOptions.ApplyDefenseSet(aIndex)
	if Earring_Options == 0
	then
		return
	end
	
	local player = User.new(aIndex)
	local pInv = Inventory.new(aIndex)
	
	if pInv:isItem(237) ~= 0 or pInv:isItem(239) ~= 0 then
		for i = 1, #Earring_Options_Info do
			local earring = Earring_Options_Info[i]
			
			if earring.ItemIndex == pInv:getIndex(237) or earring.ItemIndex == pInv:getIndex(239) then
				if earring.Defense > 0
				then
					player:setDefense((math.floor(player:getDefense() + earring.Defense)))
				end
				
				if earring.DefensePvP > 0
				then
					player:setDefensePvP((math.floor(player:getDefensePvP() + earring.DefensePvP)))
				end
				
				if earring.BlockSucess > 0
				then
					player:setSuccessBlock(math.floor(player:getSuccessBlock() + earring.BlockSucess))
				end
				
				if earring.BlockSucessPvP > 0
				then
					player:setSuccessBlockPvP(math.floor(player:getSuccessBlockPvP() + earring.BlockSucessPvP))
				end
				
				if earring.AddLife > 0
				then
					player:setAddLife((math.floor(player:getAddLife() + earring.AddLife)))
				end
				
				if earring.AddMana > 0
				then
					player:setAddMana((math.floor(player:getAddMana() + earring.AddMana)))
				end
				
				if earring.MinDmgLeft > 0
				then
					player:setAttackDamageMinLeft((math.floor(player:getAttackDamageMinLeft() + earring.MinDmgLeft)))
				end
				
				if earring.MaxDmgLeft > 0
				then
					player:setAttackDamageMaxLeft((math.floor(player:getAttackDamageMaxLeft() + earring.MaxDmgLeft)))
				end
				
				if earring.MinDmgRight > 0
				then
					player:setAttackDamageMinRight((math.floor(player:getAttackDamageMinRight() + earring.MinDmgRight)))
				end
				
				if earring.MaxDmgRight > 0
				then
					player:setAttackDamageMaxRight((math.floor(player:getAttackDamageMaxRight() + earring.MaxDmgRight)))
				end
				
				if earring.MagicMinDmg > 0
				then
					player:setMagicDamageMin((math.floor(player:getMagicDamageMin() + earring.MagicMinDmg)))
				end
				
				if earring.MagicMaxDmg > 0
				then
					player:setMagicDamageMax((math.floor(player:getMagicDamageMax() + earring.MagicMaxDmg)))
				end
				
				if earring.AttackSpeed > 0
				then
					player:setAttackSpeed((math.floor(player:getAttackSpeed() + earring.AttackSpeed)))
				end
				
				if earring.MagicSpeed > 0
				then
					player:setMagicSpeed((math.floor(player:getMagicSpeed() + earring.MagicSpeed)))
				end
			end
		end
	end
	
	pInv = nil
	player = nil
end

GameServerFunctions.CharacterSet(EarringOptions.ApplyDefenseSet)

return EarringOptions