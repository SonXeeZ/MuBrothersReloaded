--[[
Configs flag add streng
]]--

Flag_Options = 0
Flag_Option_Info = {
	{ItemIndex = GET_ITEM(15, 40), Defense = 200, DefensePvP = 200, BlockSucess = 50, BlockSucessPvP = 30, AddLife = 0, AddMana = 0, MinDmgLeft = 100, MaxDmgLeft = 150, MinDmgRight = 100, MaxDmgRight = 150, MagicMinDmg = 100, MagicMaxDmg = 150, AttackSpeed = 0, MagicSpeed = 0},
}

FlagOptions = {}

function FlagOptions.ApplyDefenseSet(aIndex)
	if Flag_Options == 0
	then
		return
	end
	
	local player = User.new(aIndex)
	local pInv = Inventory.new(aIndex)
	
	if pInv:isItem(238) ~= 0
	then
		for i = 1, #Flag_Option_Info do
			local flag = Flag_Option_Info[i]
			
			if flag.ItemIndex == pInv:getIndex(238)
			then
				if flag.Defense > 0
				then
					player:setDefense((math.floor(player:getDefense() + flag.Defense)))
				end
				
				if flag.DefensePvP > 0
				then
					player:setDefensePvP((math.floor(player:getDefensePvP() + flag.DefensePvP)))
				end
				
				if flag.BlockSucess > 0
				then
					player:setSuccessBlock(math.floor(player:getSuccessBlock() + flag.BlockSucess))
				end
				
				if flag.BlockSucessPvP > 0
				then
					player:setSuccessBlockPvP(math.floor(player:getSuccessBlockPvP() + flag.BlockSucessPvP))
				end
				
				if flag.AddLife > 0
				then
					player:setAddLife((math.floor(player:getAddLife() + flag.AddLife)))
				end
				
				if flag.AddMana > 0
				then
					player:setAddMana((math.floor(player:getAddMana() + flag.AddMana)))
				end
				
				if flag.MinDmgLeft > 0
				then
					player:setAttackDamageMinLeft((math.floor(player:getAttackDamageMinLeft() + flag.MinDmgLeft)))
				end
				
				if flag.MaxDmgLeft > 0
				then
					player:setAttackDamageMaxLeft((math.floor(player:getAttackDamageMaxLeft() + flag.MaxDmgLeft)))
				end
				
				if flag.MinDmgRight > 0
				then
					player:setAttackDamageMinRight((math.floor(player:getAttackDamageMinRight() + flag.MinDmgRight)))
				end
				
				if flag.MaxDmgRight > 0
				then
					player:setAttackDamageMaxRight((math.floor(player:getAttackDamageMaxRight() + flag.MaxDmgRight)))
				end
				
				if flag.MagicMinDmg > 0
				then
					player:setMagicDamageMin((math.floor(player:getMagicDamageMin() + flag.MagicMinDmg)))
				end
				
				if flag.MagicMaxDmg > 0
				then
					player:setMagicDamageMax((math.floor(player:getMagicDamageMax() + flag.MagicMaxDmg)))
				end
				
				if flag.AttackSpeed > 0
				then
					player:setAttackSpeed((math.floor(player:getAttackSpeed() + flag.AttackSpeed)))
				end
				
				if flag.MagicSpeed > 0
				then
					player:setMagicSpeed((math.floor(player:getMagicSpeed() + flag.MagicSpeed)))
				end
			end
		end
	end
	
	pInv = nil
	player = nil
end

GameServerFunctions.CharacterSet(FlagOptions.ApplyDefenseSet)

return FlagOptions