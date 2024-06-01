GameServerFunctions = {}

--when player drop item
--if you want block drop return 1 in your function
local PlayerDropItem_Handles = {}

function PlayerDropItem(aIndex, x, y, slot)
	for i = 1, #PlayerDropItem_Handles do
		if PlayerDropItem_Handles[i].callback(aIndex, x, y, slot) == 1 
		then
			return 1
		end
	end

	return 0
end

function GameServerFunctions.PlayerDropItem(callback)
	table.insert(PlayerDropItem_Handles, { callback = callback })
end

-- when player login or equip item
local CharacterSet_Handles = {}

function CharacterSet(aIndex)
	for i = 1, #CharacterSet_Handles do
		CharacterSet_Handles[i].callback(aIndex)
	end
end
function GameServerFunctions.CharacterSet(callback)
	table.insert(CharacterSet_Handles, { callback = callback })
end

-- when monster die
local MonsterDie_Handles = {}

function MonsterDie(Player, Monster)
	for i = 1, #MonsterDie_Handles do
		MonsterDie_Handles[i].callback(Player, Monster)
	end
end

function GameServerFunctions.MonsterDie(callback)
	table.insert(MonsterDie_Handles, { callback = callback })
end

-- Quando o monstro dropa um item para o player
-- retorno 1 impede o monstro de dropar um item
local MonsterDieGiveItem_Handles = {}
function MonsterDieGiveItem(Player, Monster)
	for i = 1, #MonsterDieGiveItem_Handles do
		if MonsterDieGiveItem_Handles[i].callback(Player, Monster) == 1 then
			return 1
		end
	end

	return 0
end
function GameServerFunctions.MonsterDieGiveItem(callback)
	table.insert(MonsterDieGiveItem_Handles, { callback = callback })
end

-- Quando um player mata outro player
local PlayerDie_Handles = {}
function PlayerDie(aIndex, TargetIndex)
	for i = 1, #PlayerDie_Handles do
		PlayerDie_Handles[i].callback(aIndex, TargetIndex)
	end
end
function GameServerFunctions.PlayerDie(callback)
	table.insert(PlayerDie_Handles, { callback = callback })
end

-- Quando um player ataca o outro
local PlayerAttack_Handles = {}
function PlayerAttack(aIndex, TargetIndex)
	for i = 1, #PlayerAttack_Handles do
		if PlayerAttack_Handles[i].callback(aIndex, TargetIndex) == 1 then
			return 1
		end
	end

	return 0
end
function GameServerFunctions.PlayerAttack(callback)
	table.insert(PlayerAttack_Handles, { callback = callback })
end

-- when player try add point in "c"
local LevelUpPointAdd_Handles = {}
function LevelUpPointAdd(aIndex, Type)
	for i = 1, #LevelUpPointAdd_Handles do
		if LevelUpPointAdd_Handles[i].callback(aIndex, TargetIndex) == 1 then
			return 1
		end
	end

	return 0
end

function GameServerFunctions.LevelUpPointAdd(callback)
	table.insert(LevelUpPointAdd_Handles, { callback = callback })
end

-- Quando um player envia pedido de trade para outro jogador
-- retorno 1 impede o evnio do pedidod e trade
local PlayerSendTrade_Handles = {}
function PlayerSendTrade(aIndex, TargetIndex)
	for i = 1, #PlayerSendTrade_Handles do
		if PlayerSendTrade_Handles[i].callback(aIndex, TargetIndex) == 1 then
			return 1
		end
	end

	return 0
end
function GameServerFunctions.PlayerSendTrade(callback)
	table.insert(PlayerSendTrade_Handles, { callback = callback })
end

-- Quando o player equipa um ring de transformação
-- retorno 1 não muda a skin do player
local PlayerRingEquiped_Handles = {}
function PlayerRingEquiped(aIndex)
	for i = 1, #PlayerRingEquiped_Handles do
		if PlayerRingEquiped_Handles[i].callback(aIndex) == 1 then
			return 1
		end
	end

	return 0
end
function GameServerFunctions.PlayerRingEquiped(callback)
	table.insert(PlayerRingEquiped_Handles, { callback = callback })
end

-- Quando dois player em negociação apertam OK no trade
-- retnorno 1 cancela a negociação
local PlayerTradeOk_Handles = {}
function PlayerTradeOk(aIndex, TargetIndex)
	for i = 1, #PlayerTradeOk_Handles do
		if PlayerTradeOk_Handles[i].callback(aIndex, TargetIndex) == 1	then
			return 1
		end
	end

	return 0
end
function GameServerFunctions.PlayerTradeOk(callback)
	table.insert(PlayerTradeOk_Handles, { callback = callback })
end

-- Quando o player desloga
local PlayerLogout_Handles = {}
function PlayerLogout(aIndex, Name, Account)
	for i = 1, #PlayerLogout_Handles do
		PlayerLogout_Handles[i].callback(aIndex, Name, Account)
	end
end
function GameServerFunctions.PlayerLogout(callback)
	table.insert(PlayerLogout_Handles, { callback = callback })
end

-- Quando duas guilds estao em War e uma delas marca ponto
local GuildWarProc_Handles = {}
function GuildWarProc(GuildName1, GuildPoints1, GuildName2, GuildPoints2)
	for i = 1, #GuildWarProc_Handles do
		GuildWarProc_Handles[i].callback(GuildName1, GuildPoints1, GuildName2, GuildPoints2)
	end
end
function GameServerFunctions.GuildWarProc(callback)
	table.insert(GuildWarProc_Handles, { callback = callback })
end

-- Quando um player entra na sala
local EnterCharacter_Handles = {}
function EnterCharacter(aIndex)
	for i = 1, #EnterCharacter_Handles do
		EnterCharacter_Handles[i].callback(aIndex)
	end
end
function GameServerFunctions.EnterCharacter(callback)
	table.insert(EnterCharacter_Handles, { callback = callback })
end

-- Quando um player deleta um personagem
local DeleteCharacter_Handles = {}
function DeleteCharacter(aIndex, name)
	for i = 1, #DeleteCharacter_Handles do
		DeleteCharacter_Handles[i].callback(aIndex, name)
	end
end
function GameServerFunctions.DeleteCharacter(callback)
	table.insert(DeleteCharacter_Handles, { callback = callback })
end

-- Quando o player é movido usando a função Teleport()
local CharacterMove_Handles = {}
function CharacterMove(aIndex, map, x, y)
	for i = 1, #CharacterMove_Handles do
		if CharacterMove_Handles[i].callback(aIndex, map, x, y) == 1 then
			return 1
		end
	end

	return 0
end

function GameServerFunctions.CharacterMove(callback)
	table.insert(CharacterMove_Handles, { callback = callback })
end

-- Quando o player caminha
local PlayerMove_Handles = {}
function PlayerMove(aIndex, map, x, y, sx, sy)
	for i = 1, #PlayerMove_Handles do
		PlayerMove_Handles[i].callback(aIndex, map, x, y, sx, sy)
	end
end
function GameServerFunctions.PlayerMove(callback)
	table.insert(PlayerMove_Handles, { callback = callback })
end

-- Quando o player clica em um NPC
-- retorno 1 não deixa o NPC abrir
local NpcTalk_Handles = {}
function NpcTalk(Npc, Player)
	for i = 1, #NpcTalk_Handles do
		if NpcTalk_Handles[i].callback(Npc, Player) == 1 then
			return 1
		end
	end

	return 0
end
function GameServerFunctions.NpcTalk(callback)
	table.insert(NpcTalk_Handles, { callback = callback })
end

-- Quando o player vende um item no Npc
-- retorno 1 impede a venda do item
local PlayerSellItem_Handles = {}
function PlayerSellItem(aIndex, Position)
	for i = 1, #PlayerSellItem_Handles do
		if PlayerSellItem_Handles[i].callback(aIndex, Position) == 1 then
			return 1
		end
	end

	return 0
end
function GameServerFunctions.PlayerSellItem(callback)
	table.insert(PlayerSellItem_Handles, { callback = callback })
end

-- Quando o player repara um item
-- retorno 1 impede que o item seja reparado
local PlayerRepairItem_Handles = {}
function PlayerRepairItem(aIndex, Position)
	for i = 1, #PlayerRepairItem_Handles do
		if PlayerRepairItem_Handles[i].callback(aIndex, Position) == 1 then
			return 1
		end
	end

	return 0
end
function GameServerFunctions.PlayerRepairItem(callback)
	table.insert(PlayerRepairItem_Handles, { callback = callback })
end

-- Quando o player tenta caminhar
-- renoto 1 impede de caminhar, porem fica dando o bug de ficar puxando o char
local PlayerCanMove_Handles = {}
function PlayerCanMove(aIndex)
	for i = 1, #PlayerCanMove_Handles do
		if PlayerCanMove_Handles[i].callback(aIndex) == 1 then
			return 1
		end
	end

	return 0
end
function GameServerFunctions.PlayerCanMove(callback)
	table.insert(PlayerCanMove_Handles, { callback = callback })
end

-- Quando o player muda o item de lugar
local PlayerMoveItem_Handles = {}
function PlayerMoveItem(aIndex, SourceSlot, TargetSlot, Type)
	for i = 1, #PlayerMoveItem_Handles do
		PlayerMoveItem_Handles[i].callback(aIndex, SourceSlot, TargetSlot, Type)
	end
	return 0
end
function GameServerFunctions.PlayerMoveItem(callback)
	table.insert(PlayerMoveItem_Handles, { callback = callback })
end

-- Quando o player abre o baú
local PlayerVaultOpen_Handles = {}
function PlayerVaultOpen(aIndex)
	for i = 1, #PlayerVaultOpen_Handles do
		PlayerVaultOpen_Handles[i].callback(aIndex)
	end
	return 0
end
function GameServerFunctions.PlayerVaultOpen(callback)
	table.insert(PlayerVaultOpen_Handles, { callback = callback })
end

-- Quando um player declara war a uma guild
-- retorno 1 impede de declarar war
local DeclareWar_Handles = {}
function DeclareWar(aIndex)
	for i = 1, #DeclareWar_Handles do
		if DeclareWar_Handles[i].callback(aIndex) == 1 then
			return 1
		end
	end

	return 0
end
function GameServerFunctions.DeclareWar(callback)
	table.insert(DeclareWar_Handles, { callback = callback })
end

-- Quando um player usa uma jóia
-- return 1 não permite o uso da joia, porém a joia desaparece e buga o slot, so volta quando relogar
local PlayerUseItem_Handles = {}
function PlayerUseItem(aIndex, SourceSlot, TargetSlot)
	for i = 1, #PlayerUseItem_Handles do
		if PlayerUseItem_Handles[i].callback(aIndex, SourceSlot, TargetSlot) == 1 then
			return 1
		end
	end

	return 0
end
function GameServerFunctions.PlayerUseItem(callback)
	table.insert(PlayerUseItem_Handles, { callback = callback })
end

-- Qunado o player fecha o baú
local PlayerVaultClose_Handles = {}
function PlayerVaultClose(aIndex)
	for i = 1, #PlayerVaultClose_Handles do
		PlayerVaultClose_Handles[i].callback(aIndex)
	end
	return 0
end
function GameServerFunctions.PlayerVaultClose(callback)
	table.insert(PlayerVaultClose_Handles, { callback = callback })
end

-- Quando o player envia pedido de TradeX
-- retorno 1 impede o envio do pedido
local PlayerSendTradeX_Handles = {}
function PlayerSendTradeX(aIndex, TargetIndex)
	for i = 1, #PlayerSendTradeX_Handles do
		if PlayerSendTradeX_Handles[i].callback(aIndex, TargetIndex) == 1 then
			return 1
		end
	end

	return 0
end
function GameServerFunctions.PlayerSendTradeX(callback)
	table.insert(PlayerSendTradeX_Handles, { callback = callback })
end

-- Quando dois player usando TradeX clicam aceitar
-- return 1 cancela a negociação
local PlayerTradeXOk_Handles = {}
function PlayerTradeXOk(aIndex, TargetIndex)
	for i = 1, #PlayerTradeXOk_Handles do
		if PlayerTradeXOk_Handles[i].callback(aIndex, TargetIndex) == 1 then
			return 1
		end
	end

	return 0
end
function GameServerFunctions.PlayerTradeXOk(callback)
	table.insert(PlayerTradeXOk_Handles, { callback = callback })
end

-- Quando o player tenta equipar um item no slot Element
-- return 1 impede de equipar
local ElementSlot_Handles = {}
function CanEquipElementSlot(aIndex)
	for i = 1, #ElementSlot_Handles do
		if ElementSlot_Handles[i].callback(aIndex) == 1
		then
			return 1
		end
	end
	return 0
end
function GameServerFunctions.CanEquipElementSlot(callback)
	table.insert(ElementSlot_Handles, { callback = callback })
end

-- Quando o player abre uma lojinha
-- retrun 1 impede de abrir
local PlayerOpenShop_Handles = {}
function PlayerOpenShop(aIndex)
	for i = 1, #PlayerOpenShop_Handles do
		if PlayerOpenShop_Handles[i].callback(aIndex, TargetIndex) == 1
		then
			return 1
		end
	end
	return 0
end
function GameServerFunctions.PlayerOpenShop(callback)
	table.insert(PlayerOpenShop_Handles, { callback = callback })
end

-- Quando o player fecha uma lojinha
-- retrun 1 impede de fechar
local PlayerCloseShop_Handles = {}
function PlayerCloseShop(aIndex)
	for i = 1, #PlayerCloseShop_Handles do
		if PlayerCloseShop_Handles[i].callback(aIndex, TargetIndex) == 1
		then
			return 1
		end
	end
	return 0
end
function GameServerFunctions.PlayerCloseShop(callback)
	table.insert(PlayerCloseShop_Handles, { callback = callback })
end

-- Quando o player tenta equipar um item
-- return 1 impede de equipar
local PlayerCanEquipItem_Handles = {}
function PlayerCanEquipItem(aIndex, SourceSlot, TargetSlot)
	for i = 1, #PlayerCanEquipItem_Handles do
		if PlayerCanEquipItem_Handles[i].callback(aIndex, SourceSlot, TargetSlot) == 1
		then
			return 1
		end
	end
	return 0
end
function GameServerFunctions.PlayerCanEquipItem(callback)
	table.insert(PlayerCanEquipItem_Handles, { callback = callback })
end

-- Packets que vem do cliente
local GameServerProtocol_Handles = {}
function GameServerProtocol(aIndex, Packet, PacketName)
	for i = 1, #GameServerProtocol_Handles do
		if GameServerProtocol_Handles[i].callback(aIndex, Packet, PacketName)
		then
			return
		end
	end

	ClearPacket(PacketName)
end

function GameServerFunctions.GameServerProtocol(callback)
	table.insert(GameServerProtocol_Handles, { callback = callback })
end

-- Recebe o HWID do player quando ele loga
local MacAddressPlayer_Handles = {}
function MacAddressPlayer(aIndex, HWID)
	for i = 1, #MacAddressPlayer_Handles do
		MacAddressPlayer_Handles[i].callback(aIndex, HWID)
	end
end

function GameServerFunctions.MacAddressPlayer(callback)
	table.insert(MacAddressPlayer_Handles, { callback = callback })
end

-- detectar quando o player está usando a skill da fenrir, caso retorne 1 não deixará quebrar ou reduzir a durabilidade de itens do target!
local PlayerAttackFenrirSkill_Handles = {}

function PlayerAttackFenrirSkill(aIndex, TargetIndex)
	for i = 1, #PlayerAttackFenrirSkill_Handles do
		if PlayerAttackFenrirSkill_Handles[i].callback(aIndex, TargetIndex) == 1
		then
			return 1
		end
	end

	return 0
end

function GameServerFunctions.PlayerAttackFenrirSkill(callback)
	table.insert(PlayerAttackFenrirSkill_Handles, { callback = callback })
end

-- Quando um jogador está renascendo através do Type 5
local RespawnUser_Handles = {}

function RespawnUser(aIndex)
	for i = 1, #RespawnUser_Handles do
		RespawnUser_Handles[i].callback(aIndex)
	end
end

function GameServerFunctions.RespawnUser(callback)
	table.insert(RespawnUser_Handles, { callback = callback })
end

-- Quando o sistema da monster Reload
local MonsterReload_Handles = {}

function MonsterReload()
	for i = 1, #MonsterReload_Handles do
		MonsterReload_Handles[i].callback()
	end
end

function GameServerFunctions.MonsterReload(callback)
	table.insert(MonsterReload_Handles, { callback = callback })
end

-- Chaos Machine Genesis
local ChaosMachineGenesis_Handles = {}

function ChaosMachineGenesisMix(aIndex)
	for i = 1, #ChaosMachineGenesis_Handles do
		ChaosMachineGenesis_Handles[i].callback(aIndex)
	end
end

function GameServerFunctions.ChaosMachineGenesisMix(callback)
	table.insert(ChaosMachineGenesis_Handles, { callback = callback })
end

--When run only reload lua
local ReloadLuaMonster_Handles = {}

function ReloadLuaMonster()
	for i = 1, #ReloadLuaMonster_Handles do
		ReloadLuaMonster_Handles[i].callback()
	end
end

function GameServerFunctions.ReloadLuaMonster(callback)
	table.insert(ReloadLuaMonster_Handles, { callback = callback })
end

--When player send party
local PlayerSendParty_Handles = {}

function PlayerSendParty(aIndex, TargetIndex)
	for i = 1, #PlayerSendParty_Handles do
		if PlayerSendParty_Handles[i].callback(aIndex, TargetIndex) == 1
		then
			return 1
		end
	end

	return 0
end

function GameServerFunctions.PlayerSendParty(callback)
	table.insert(PlayerSendParty_Handles, { callback = callback })
end

--When BC, DS, CC reward player
local RewardNativeEvents_Handles = {}

function ReceiveEventReward(aIndex, EventType)
	for i = 1, #RewardNativeEvents_Handles do
		if RewardNativeEvents_Handles[i].callback(aIndex, EventType) == 1
		then
			return 1
		end
	end

	return 0
end

function GameServerFunctions.ReceiveEventReward(callback)
	table.insert(RewardNativeEvents_Handles, { callback = callback })
end

--Sql Async Querys
local QueryAsyncProcess_Handles = {}

function QueryAsyncProcess(queryName, identification, aIndex)
	for i = 1, #QueryAsyncProcess_Handles do
		if QueryAsyncProcess_Handles[i].callback(queryName, identification, aIndex) == 1
		then
			return 1
		end
	end

  QueryAsyncDelete(identification)
end

function GameServerFunctions.QueryAsyncProcess(callback)
	table.insert(QueryAsyncProcess_Handles, { callback = callback })
end

return GameServerFunctions
