--[[Ring Transformation]]--

RingTransformation = {}

--Section: Item section
--Index: Item index
--Level: Level the ring needs to be -1 = any level
--Monster: Monster number that the player will transform into when equipping the ring

local RINGS_TRANSFORMATION = {{Section = 13, Index = 121, Level = 0, Monster = 234},}

function RingTransformation.CheckRing(aIndex)
	local player = User.new(aIndex)

	if player:getType() ~= 1
	then
		return
	end
	
	local pInv = Inventory.new(aIndex)
	local change = -1
	
	for i in ipairs(RINGS_TRANSFORMATION) do
		local Ring = RINGS_TRANSFORMATION[i]
		
		if pInv:isItem(10) == 1
		then
			if pInv:getIndex(10) == GET_ITEM(Ring.Section, Ring.Index)
			then
				change = Ring.Monster
			end
		end
		
		if pInv:isItem(11) == 1
		then
			if pInv:getIndex(11) == GET_ITEM(Ring.Section, Ring.Index)
			then
				change = Ring.Monster
			end
		end
	end
	
	if player:getSkin() >= 0 and player:getSkin() == change
	then
		return
	end
	
	if change ~= -1
	then
		player:setSkin(change)
		ViewportCreate(aIndex)
		return 1
	end
end

GameServerFunctions.PlayerRingEquiped(RingTransformation.CheckRing)

return RingTransformation