QuestSystemNpc = {}

function QuestSystemNpc.OpenQuest(player, NpcQuestIdentification, CheckAnotherQuest)
    local Language = player:getLanguage()
	
	if player:getInterfaceUse() ~= 0 or player:getInterfaceType() ~= 0 or player:getState() == 32 or player:getDieRegen() ~= 0 or player:getTeleport() ~= 0
	then
		SendMessage(string.format(QUEST_SYSTEM_NPC_MESSAGES[Language][1]), player:getIndex(), 1)
		return
	end

    local PlayerQuest = player:getCacheInt("QuestSystemNpcIdentification")
	local QuestFinished = player:getCacheInt("QuestSystemNpcFinished")

    if QuestFinished > 0
    then
        if PlayerQuest == NpcQuestIdentification
        then
            QuestSystemNpc.OpenFinishedQuest(player)
            return
        end
    end

    if QUEST_SYSTEM_NPC_ONLY_ONE_QUEST == 1
    then
        local questUsed = QuestSystemNpc.CheckQuestUsed(player:getAccountID(), player:getName(), NpcQuestIdentification)

        if questUsed > 0
        then
            QuestSystemNpc.OpenFinishedQuest(player)
            return
        end
    end

    if CheckAnotherQuest == 1
    then
        if PlayerQuest ~= 0
        then
			if QuestFinished == 1
			then
				QuestSystemNpc.DeleteQuestInfo(player:getAccountID(), player:getName())
            elseif PlayerQuest ~= NpcQuestIdentification
            then
                QuestSystemNpc.OpenDismissQuest(player, NpcQuestIdentification)
                return
            end
        end
    end

    local QuestIdentification = player:getCacheInt("QuestSystemNpcIdentification")

    if QuestIdentification == 0 or QuestIdentification == -1
    then
        QuestIdentification = NpcQuestIdentification
    end

    local packetIdentification = string.format("%s_%s",QUEST_SYSTEM_NPC_PACKET_OPEN_NAME, player:getName())
    CreatePacket(packetIdentification, QUEST_SYSTEM_NPC_PACKET)
    SetDwordPacket(packetIdentification, QuestIdentification)
    SetDwordPacket(packetIdentification, player:getCacheInt("QuestSystemNpcStarted"))
    SetDwordPacket(packetIdentification, player:getLevel())
    SetDwordPacket(packetIdentification, player:getReset())
    SetDwordPacket(packetIdentification, player:getMasterReset())
    SetDwordPacket(packetIdentification, player:getMoney())
    SetDwordPacket(packetIdentification, player:getCoin1())
    SetDwordPacket(packetIdentification, player:getCoin2())
    SetDwordPacket(packetIdentification, player:getCoin3())
    SetDwordPacket(packetIdentification, player:getVip())
    SetDwordPacket(packetIdentification, player:getCacheInt("QuestSystemNpcKills"))
    --kills monster by db
    for i = 1, 9 do
        SetDwordPacket(packetIdentification, player:getCacheInt(string.format('QuestSystemNpcKillsMonster%d', i)))
    end

    local ItensRequirement = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    local questRequirementInfo = QUEST_SYSTEM_NPC_REQUIREMENTS_ITEMS[QuestIdentification]

    if questRequirementInfo ~= nil
    then
        local pInv = Inventory.new(player:getIndex())

        local count = 1

        for key in pairs(questRequirementInfo) do
            if count > 10
            then
                break
            end

            local item = questRequirementInfo[key]
            for i = 12, 203 do
                if ItensRequirement[count] > item.Quantity
                then
                    break
                end

                if pInv:isItem(i) ~= 0
                then
                    if pInv:getIndex(i) == item.ItemIndex
                    then
                        if (item.Level == -1 or pInv:getLevel(i) == item.Level)
                            and (item.Skill == -1 or pInv:getItemTable(i, 2) == item.Skill)
                            and (item.Luck == -1 or pInv:getItemTable(i, 3) == item.Luck)
                        then
                            if GetStackItem(pInv:getIndex(i)) <= 0
                            then
                                ItensRequirement[count] = ItensRequirement[count] + 1
                            else
                                if pInv:getDurability(i) > 0
                                then
                                    ItensRequirement[count] = ItensRequirement[count] + pInv:getDurability(i)
                                else
                                    ItensRequirement[count] = ItensRequirement[count] + 1
                                end
                            end
                        end
                    end
                end
            end

            count = count + 1
        end

        pInv = nil
    end

    --itens player by inventory
    for i = 1, 10 do
        SetDwordPacket(packetIdentification, ItensRequirement[i])
    end

    SendPacket(packetIdentification, player:getIndex())
    ClearPacket(packetIdentification)
end

function QuestSystemNpc.StartQuest(player, QuestIdentification)
    local Language = player:getLanguage()
	
	if player:getInterfaceUse() ~= 0 or player:getInterfaceType() ~= 0 or player:getState() == 32 or player:getDieRegen() ~= 0 or player:getTeleport() ~= 0
	then
		SendMessage(string.format(QUEST_SYSTEM_NPC_MESSAGES[Language][1]), player:getIndex(), 1)
		return
	end

    if player:getCacheInt("QuestSystemNpcStarted") ~= 0
    then
        if player:getCacheInt("QuestSystemNpcFinished") == 0
        then
            SendMessage(string.format(QUEST_SYSTEM_NPC_MESSAGES[Language][5]), player:getIndex(), 1)
            return
        end
    end

    if QUEST_SYSTEM_NPC_ONLY_ONE_QUEST == 1
    then
        local questUsed = QuestSystemNpc.CheckQuestUsed(player:getAccountID(), player:getName(), QuestIdentification)

        if questUsed > 0
        then
            return
        end
    end

    local getFirstQuest = QuestSystemNpc.GetQuestIdentification(QuestIdentification)

    if getFirstQuest == nil
    then
        SendMessage(string.format(QUEST_SYSTEM_NPC_MESSAGES[Language][2]), player:getIndex(), 1)
		return
    end

    QuestSystemNpc.InsertPlayer(player:getAccountID(), player:getName(), getFirstQuest.QuestIdentification)

    QuestSystemNpc.InsertQuestUsed(player:getAccountID(), player:getName(), getFirstQuest.QuestIdentification)

    SendMessage(string.format(QUEST_SYSTEM_NPC_MESSAGES[Language][3], getFirstQuest.QuestName), player:getIndex(), 1)

    player:setCacheInt("QuestSystemNpcStarted", 1)
    player:setCacheInt("QuestSystemNpcIdentification", getFirstQuest.QuestIdentification)
    player:setCacheInt("QuestSystemNpcKills", 0)
    player:setCacheInt("QuestSystemNpcFinished", 0)

    for i = 1, 9 do 
        player:setCacheInt(string.format('QuestSystemNpcKillsMonster%d', i), 0)
    end

    QuestSystemNpc.OpenQuest(player, getFirstQuest.QuestIdentification, 0)
end

function QuestSystemNpc.GetReward(player)
    local Language = player:getLanguage()

    if player:getCacheInt("QuestSystemNpcStarted") ~= 1
    then
        SendMessage(string.format(QUEST_SYSTEM_NPC_MESSAGES[Language][4]), player:getIndex(), 1)
        return
    end

    if player:getCacheInt("QuestSystemNpcFinished") == 1
    then
        return
    end
	
	if player:getInterfaceUse() ~= 0 or player:getInterfaceType() ~= 0 or player:getState() == 32 or player:getDieRegen() ~= 0 or player:getTeleport() ~= 0
	then
		SendMessage(string.format(QUEST_SYSTEM_NPC_MESSAGES[Language][1]), player:getIndex(), 1)
		return
	end

    local QuestIdentification = player:getCacheInt("QuestSystemNpcIdentification")
    local Level = 0
    local Resets = 0
    local MResets = 0
    local Zen = 0
    local Coin1 = 0
    local Coin2 = 0
    local Coin3 = 0
    local Coin4 = 0
    local Vip = 0
    local Kills = 0
    local KillsMonster = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    local ItensRequirement = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }

    local questInfo = QuestSystemNpc.GetQuestIdentification(QuestIdentification)

    if questInfo ~= nil
    then
        Kills = player:getCacheInt("QuestSystemNpcKills")

        for i = 1, 9 do
            KillsMonster[i] = player:getCacheInt(string.format('QuestSystemNpcKillsMonster%d', i))
        end

        if questInfo.Level ~= 0
        then
            Level = player:getLevel()
        end

        if questInfo.Reset ~= 0
        then
            Resets = player:getReset()
        end

        if questInfo.MReset ~= 0
        then
            MResets = player:getMasterReset()
        end

        if questInfo.Zen ~= 0
        then
            Zen = player:getMoney()
        end

        if questInfo.Coin1 ~= 0
        then
            Coin1 = player:getCoin1()
        end

        if questInfo.Coin2 ~= 0
        then
            Coin2 = player:getCoin2()
        end

        if questInfo.Coin3 ~= 0
        then
            Coin3 = player:getCoin3()
        end

        if questInfo.Vip ~= 0
        then
            Vip = player:getVip()
        end

        local questRequirementInfo = QUEST_SYSTEM_NPC_REQUIREMENTS_ITEMS[QuestIdentification]

        if questRequirementInfo ~= nil
        then
            local pInv = Inventory.new(player:getIndex())

            local count = 1

            for key in pairs(questRequirementInfo) do
                if count > 10
                then
                    break
                end

                local item = questRequirementInfo[key]
                for i = 12, 203 do
                    if ItensRequirement[count] > item.Quantity
                    then
                        break
                    end

                    if pInv:isItem(i) ~= 0
                    then
                        if pInv:getIndex(i) == item.ItemIndex
                        then
                            if (item.Level == -1 or pInv:getLevel(i) == item.Level)
                                and (item.Skill == -1 or pInv:getItemTable(i, 2) == item.Skill)
                                and (item.Luck == -1 or pInv:getItemTable(i, 3) == item.Luck)
                            then
                                if GetStackItem(pInv:getIndex(i)) <= 0
                                then
                                    ItensRequirement[count] = ItensRequirement[count] + 1
                                else
                                    if pInv:getDurability(i) > 0
                                    then
                                        ItensRequirement[count] = ItensRequirement[count] + pInv:getDurability(i)
                                    else
                                        ItensRequirement[count] = ItensRequirement[count] + 1
                                    end
                                end
                            end
                        end
                    end
                end

                count = count + 1
            end

            pInv = nil
        end
    end

    local questInfoCheck = QuestSystemNpc.GetQuestIdentification(QuestIdentification)

    if questInfoCheck ~= nil
    then
        if Level < questInfoCheck.Level
            or Resets < questInfoCheck.Reset
            or MResets < questInfoCheck.MReset
            or Zen < questInfoCheck.Zen
            or Coin1 < questInfoCheck.Coin1
            or Coin2 < questInfoCheck.Coin2
            or Coin3 < questInfoCheck.Coin3
            or Vip < questInfoCheck.Vip
            or Kills < questInfoCheck.Kills
        then
            SendMessage(string.format(QUEST_SYSTEM_NPC_MESSAGES[Language][6]), player:getIndex(), 1)
            return
        end

        local questMonsterInfo = QUEST_SYSTEM_NPC_REQUIREMENTS_MONSTER[QuestIdentification]
        if questMonsterInfo ~= nil
        then
            local count = 1

            for key in pairs(questMonsterInfo) do
                if count > 9
                then
                    break
                end

                local monster = questMonsterInfo[key]

                if monster.Quantity > KillsMonster[count]
                then
                    SendMessage(string.format(QUEST_SYSTEM_NPC_MESSAGES[Language][6]), player:getIndex(), 1)
                    return
                end

                count = count + 1
            end
        end

        local questItemInfo = QUEST_SYSTEM_NPC_REQUIREMENTS_ITEMS[QuestIdentification]

        if questItemInfo ~= nil
        then
            local count = 1
            for key in pairs(questItemInfo) do
                if count > 9
                then
                    break
                end

                local item = questItemInfo[key]

                if item.Quantity > ItensRequirement[count]
                then
                    SendMessage(string.format(QUEST_SYSTEM_NPC_MESSAGES[Language][6]), player:getIndex(), 1)
                    return
                end

                count = count + 1
            end
        end

        --Remove things
        if QUEST_SYSTEM_NPC_REMOVE_RESETS == 1
        then
            if questInfoCheck.Reset > 0
            then
                player:setReset(player:getReset() - questInfoCheck.Reset)
                DataBaseAsync.SetDecreaseValue(TABLE_RESET, COLUMN_RESET[0], questInfoCheck.Reset, WHERE_RESET, player:getName())
            end
        end

        if QUEST_SYSTEM_NPC_REMOVE_MRESETS == 1
        then
            if questInfoCheck.MReset > 0
            then
                player:setMasterReset(player:getMasterReset() - questInfoCheck.MReset)
                DataBaseAsync.SetDecreaseValue(TABLE_MRESET, COLUMN_MRESET[0], questInfoCheck.MReset, WHERE_MRESET, player:getName())
            end
        end

        local Coin1Remove = 0
        local Coin2Remove = 0
        local Coin3Remove = 0

        if QUEST_SYSTEM_NPC_REMOVE_COIN1 == 1
        then
            if questInfoCheck.Coin1 > 0
            then
                Coin1Remove = questInfoCheck.Coin1
            end
        end

        if QUEST_SYSTEM_NPC_REMOVE_COIN2 == 1
        then
            if questInfoCheck.Coin2 > 0
            then
                Coin2Remove = questInfoCheck.Coin2
            end
        end

        if QUEST_SYSTEM_NPC_REMOVE_COIN3 == 1
        then
            if questInfoCheck.Coin3 > 0
            then
                Coin3Remove = questInfoCheck.Coin3
            end
        end

        if Coin1Remove > 0 or Coin2Remove > 0  or Coin3Remove > 0
        then
            RemoveCoins(player:getIndex(), Coin1Remove, Coin2Remove, Coin3Remove)
        end

        local questItemInfo = QUEST_SYSTEM_NPC_REQUIREMENTS_ITEMS[QuestIdentification]

        if questItemInfo ~= nil
        then
            local count = 1
            for key in pairs(questItemInfo) do
                if count > 9
                then
                    break
                end

                local item = questItemInfo[key]

                DeleteItemCount(player:getIndex(), item.ItemIndex, item.Level, item.Quantity)

                count = count + 1
            end
        end

        --Reward player
        local questRewardItem = QUEST_SYSTEM_NPC_REWARD_ITEMS[QuestIdentification]

        if questRewardItem ~= nil
        then
            for key in pairs(questRewardItem) do
                local item = questRewardItem[key]

                if item.Class == -1 or item.Class == player:getClass()
                then
                    for i = 1, item.Count do
                        NpcRescueItem.InsertItem(player:getAccountID(), item.ItemIndex, item.Level, item.Op1, item.Op2, item.Life, item.Exc, item.Ancient, item.JoH, item.SocketBonus, item.Sock1, item.Sock2, item.Sock3, item.Sock4, item.Sock5, item.DaysExpire, item.ItemTime)
                    end
                end
            end
        end

        local questRewardCoins = QUEST_SYSTEM_NPC_REWARD_COINS[QuestIdentification]

        if questRewardCoins ~= nil
        then
            local AddCoin1 = 0
            local AddCoin2 = 0
            local AddCoin3 = 0

            for key in pairs(questRewardCoins) do
                local coin = questRewardCoins[key]

                if coin.CoinIdentification == 1
                then
                    AddCoin1 = AddCoin1 + coin.CoinAmount
                    SendMessage(string.format(QUEST_SYSTEM_NPC_MESSAGES[player:getLanguage()][7], coin.CoinAmount, coin.CoinName), player:getIndex(), 1)
                elseif coin.CoinIdentification == 2
                then
                    AddCoin2 = AddCoin2 + coin.CoinAmount
                    SendMessage(string.format(QUEST_SYSTEM_NPC_MESSAGES[player:getLanguage()][7], coin.CoinAmount, coin.CoinName), player:getIndex(), 1)
                elseif coin.CoinIdentification == 3
                then
                    AddCoin3 = AddCoin3 + coin.CoinAmount
                    SendMessage(string.format(QUEST_SYSTEM_NPC_MESSAGES[player:getLanguage()][7], coin.CoinAmount, coin.CoinName), player:getIndex(), 1)
                end
            end

            if AddCoin1 > 0 or AddCoin2 > 0 or AddCoin3 > 0
            then
                AddCoins(player:getIndex(), AddCoin1, AddCoin2, AddCoin3, 0) -- 0 = ruud
            end
        end

        local questRewardBuff = QUEST_SYSTEM_NPC_REWARD_BUFF[QuestIdentification]

        if questRewardBuff ~= nil
        then
            for key in pairs(questRewardBuff) do
                local buff = questRewardBuff[key]

                AddEffect(player:getIndex(), 1, buff.EffectID, os.time() + buff.EffectTime, 0, 0, 0, 0)
            end
        end

        player:setCacheInt("QuestSystemNpcFinished", 1)

        if QUEST_SYSTEM_NPC_ONLY_ACCOUNT == 1
        then
            DataBaseAsync.SetAddValue('QUEST_SYSTEM_NPC', 'Finished', 1, 'AccountID', player:getAccountID())
        else
            DataBaseAsync.SetAddValue('QUEST_SYSTEM_NPC', 'Finished', 1, 'Name', player:getName())
        end

        QuestSystemNpc.OpenFinishedQuest(player)
    end
end

function QuestSystemNpc.DismissQuest(player, QuestIdentification)
    if player:getCacheInt("QuestSystemNpcStarted") ~= 1
    then
        return
    end

    QuestSystemNpc.DeleteQuestInfo(player:getAccountID(), player:getName())

    player:setCacheInt("QuestSystemNpcStarted", 0)
    player:setCacheInt("QuestSystemNpcIdentification", 0)
    player:setCacheInt("QuestSystemNpcKills", 0)
    player:setCacheInt("QuestSystemNpcFinished", 0)

    for i = 1, 9 do 
        player:setCacheInt(string.format('QuestSystemNpcKillsMonster%d', i), 0)
    end

    QuestSystemNpc.StartQuest(player, QuestIdentification)
end

function QuestSystemNpc.Protocol(aIndex, Packet, PacketName)
    if Packet == QUEST_SYSTEM_NPC_PACKET
    then
        local player = User.new(aIndex)

        if string.format("%s_%s",QUEST_SYSTEM_NPC_PACKET_START_NAME, player:getName()) == PacketName
        then
            QuestSystemNpc.StartQuest(player, GetDwordPacket(PacketName, -1))
            ClearPacket(PacketName)
        elseif string.format("%s_%s",QUEST_SYSTEM_NPC_PACKET_GET_REWARD_NAME, player:getName()) == PacketName
        then
            ClearPacket(PacketName)
            QuestSystemNpc.GetReward(player)
        elseif string.format("%s_%s",QUEST_SYSTEM_NPC_PACKET_DISMISS_QUEST_NAME, player:getName()) == PacketName
        then
            QuestSystemNpc.DismissQuest(player, GetDwordPacket(PacketName, -1))
            ClearPacket(PacketName)
        end

        player = nil
    end
end

function QuestSystemNpc.GetQuestIdentification(id)
    for i in pairs(QUEST_SYSTEM_NPC_INFO) do
        if QUEST_SYSTEM_NPC_INFO[i].QuestIdentification == id
        then
            return QUEST_SYSTEM_NPC_INFO[i]
        end
    end

    return nil
end

function QuestSystemNpc.PlayerJoin(aIndex)
    local player = User.new(aIndex)

    local query = ""

    if QUEST_SYSTEM_NPC_ONLY_ACCOUNT == 1
    then
        query = string.format("SELECT QuestIdentification,Finished,Kills,KillsMonster1,KillsMonster2,KillsMonster3,KillsMonster4,KillsMonster5,KillsMonster6,KillsMonster7,KillsMonster8,KillsMonster9 FROM QUEST_SYSTEM_NPC where AccountID='%s'", player:getAccountID())
    else
        query = string.format("SELECT QuestIdentification,Finished,Kills,KillsMonster1,KillsMonster2,KillsMonster3,KillsMonster4,KillsMonster5,KillsMonster6,KillsMonster7,KillsMonster8,KillsMonster9 FROM QUEST_SYSTEM_NPC where AccountID='%s' and Name='%s'", player:getAccountID(), player:getName())
    end

    player:setCacheInt("QuestSystemNpcStarted", 0)
    player:setCacheInt("QuestSystemNpcIdentification", 0)
    player:setCacheInt("QuestSystemNpcKills", 0)
    player:setCacheInt("QuestSystemNpcFinished", 0)

    for i = 1, 9 do 
        player:setCacheInt(string.format('QuestSystemNpcKillsMonster%d', i), 0)
    end

    CreateAsyncQuery('GetQuestNpcPlayer', query, player:getIndex(), 1)
end

function QuestSystemNpc.OpenFinishedQuest(player)
    local packetString = string.format("%s_%s", QUEST_SYSTEM_NPC_PACKET_FINISHED_QUEST_NAME, player:getName())
    CreatePacket(packetString, QUEST_SYSTEM_NPC_PACKET)
    SendPacket(packetString, player:getIndex())
    ClearPacket(packetString)
end

function QuestSystemNpc.OpenDismissQuest(player, QuestIdentification)
    local packetString = string.format("%s_%s", QUEST_SYSTEM_NPC_PACKET_DISMISS_QUEST_NAME, player:getName())
    CreatePacket(packetString, QUEST_SYSTEM_NPC_PACKET)
    SetDwordPacket(packetString, QuestIdentification)
    SendPacket(packetString, player:getIndex())
    ClearPacket(packetString)
end

function QuestSystemNpc.PlayerLogout(aIndex)
    player = User.new(aIndex)

    player:clearCacheInt("QuestSystemNpcIdentification")
    player:clearCacheInt("QuestSystemNpcStarted")
    player:clearCacheInt("QuestSystemNpcKills")
    player:clearCacheInt("QuestSystemNpcFinished")

    for i = 1, 9 do 
        player:clearCacheInt(string.format('QuestSystemNpcKillsMonster%d', i))
    end

    player = nil
end

function QuestSystemNpc.PlayerDie(PlayerIndex, TargetIndex)
    local player = User.new(PlayerIndex)

    if player:getCacheInt("QuestSystemNpcStarted") == 1
    then
        if player:getCacheInt("QuestSystemNpcFinished") ~= 0
        then
            return
        end

        local getQuestInfo = QuestSystemNpc.GetQuestIdentification(player:getCacheInt("QuestSystemNpcIdentification"))

        if getQuestInfo ~= nil
        then
            local kills = player:getCacheInt("QuestSystemNpcKills")

            if getQuestInfo.Kills > 0 and kills < getQuestInfo.Kills
            then
                if QUEST_SYSTEM_NPC_ONLY_ACCOUNT == 1
                then
                    DataBaseAsync.SetAddValue('QUEST_SYSTEM_NPC', 'Kills', 1, 'AccountID', player:getAccountID())
                else
                    DataBaseAsync.SetAddValue('QUEST_SYSTEM_NPC', 'Kills', 1, 'Name', player:getName())
                end

                player:setCacheInt("QuestSystemNpcKills", kills + 1)
            end
        end
    end

    player = nil
end

function QuestSystemNpc.MonsterDie(PlayerIndex, MonsterIndex)
    local player = User.new(PlayerIndex)

    if player:getCacheInt("QuestSystemNpcStarted") == 1
    then
        if player:getCacheInt("QuestSystemNpcFinished") ~= 0
        then
            return
        end

        local getQuestInfo = QUEST_SYSTEM_NPC_REQUIREMENTS_MONSTER[player:getCacheInt("QuestSystemNpcIdentification")]

        if getQuestInfo ~= nil
        then
            local monster = User.new(MonsterIndex)

            local count = 1

            for key = 1, #getQuestInfo do
                if count > 9
                then
                    break
                end

                local monsterInfo = getQuestInfo[key]

                if monsterInfo.MonsterIndex == monster:getClass()
                then
                    local kills = player:getCacheInt(string.format('QuestSystemNpcKillsMonster%d', count))

                    if kills < monsterInfo.Quantity
                    then
                        if QUEST_SYSTEM_NPC_ONLY_ACCOUNT == 1
                        then
                            DataBaseAsync.SetAddValue('QUEST_SYSTEM_NPC', string.format('KillsMonster%d', count), 1, 'AccountID', player:getAccountID())
                        else
                            DataBaseAsync.SetAddValue('QUEST_SYSTEM_NPC', string.format('KillsMonster%d', count), 1, 'Name', player:getName())
                        end

                        player:setCacheInt(string.format('QuestSystemNpcKillsMonster%d', count), kills + 1)

                        quest = QuestSystemNpc.GetQuestIdentification(player:getCacheInt("QuestSystemNpcIdentification"))

                        if quest ~= nil
                        then
                            SendMessage(string.format(QUEST_SYSTEM_NPC_MESSAGES[player:getLanguage()][9], quest.QuestName, monster:getName(), kills+1, monsterInfo.Quantity), PlayerIndex, 1)
                        end
                    end
                    break
                end

                count = count + 1
            end

            monster = nil
        end
    end

    player = nil
end

function QuestSystemNpc.CreatePlayerCache()
    for i = OBJECT_START_MONSTER, MAX_OBJECT_MONSTER do
        local monster = User.new(i)

        if monster:getConnected() > 0
        then
            for i = 1, #QUEST_SYSTEM_NPC_LOCATION_INFO do
                if monster:getClass() == QUEST_SYSTEM_NPC_LOCATION_INFO[i].Class
                then
                    monster:setType(3)
                end
            end
        end

        monster = nil
    end
end

function QuestSystemNpc.QueryAsyncProcess(queryName, identification, aIndex)
    if queryName == 'GetQuestNpcPlayer'
    then
        if gObjIsConnectedGP(aIndex) ~= 0
		then
            local QuestIdentification = tonumber(QueryAsyncGetValue(identification, 'QuestIdentification'))
            local Finished = tonumber(QueryAsyncGetValue(identification, 'Finished'))
            local Kills = tonumber(QueryAsyncGetValue(identification, 'Kills'))
            local KillsMonster1 = tonumber(QueryAsyncGetValue(identification, 'KillsMonster1'))
            local KillsMonster2 = tonumber(QueryAsyncGetValue(identification, 'KillsMonster2'))
            local KillsMonster3 = tonumber(QueryAsyncGetValue(identification, 'KillsMonster3'))
            local KillsMonster4 = tonumber(QueryAsyncGetValue(identification, 'KillsMonster4'))
            local KillsMonster5 = tonumber(QueryAsyncGetValue(identification, 'KillsMonster5'))
            local KillsMonster6 = tonumber(QueryAsyncGetValue(identification, 'KillsMonster6'))
            local KillsMonster7 = tonumber(QueryAsyncGetValue(identification, 'KillsMonster7'))
            local KillsMonster8 = tonumber(QueryAsyncGetValue(identification, 'KillsMonster8'))
            local KillsMonster9 = tonumber(QueryAsyncGetValue(identification, 'KillsMonster9'))

            if QuestIdentification ~= nil and Kills ~= nil and KillsMonster1 ~= nil and KillsMonster9 ~= nil
            then
                local player = User.new(aIndex)

                player:setCacheInt("QuestSystemNpcStarted", 1)
                player:setCacheInt("QuestSystemNpcIdentification", QuestIdentification)
                player:setCacheInt("QuestSystemNpcKills", Kills)
                player:setCacheInt("QuestSystemNpcFinished", Finished)

                player:setCacheInt('QuestSystemNpcKillsMonster1', KillsMonster1)
                player:setCacheInt('QuestSystemNpcKillsMonster2', KillsMonster2)
                player:setCacheInt('QuestSystemNpcKillsMonster3', KillsMonster3)
                player:setCacheInt('QuestSystemNpcKillsMonster4', KillsMonster4)
                player:setCacheInt('QuestSystemNpcKillsMonster5', KillsMonster5)
                player:setCacheInt('QuestSystemNpcKillsMonster6', KillsMonster6)
                player:setCacheInt('QuestSystemNpcKillsMonster7', KillsMonster7)
                player:setCacheInt('QuestSystemNpcKillsMonster8', KillsMonster8)
                player:setCacheInt('QuestSystemNpcKillsMonster9', KillsMonster9)
            end
        end

        QueryAsyncDelete(identification)
        return 1
    end
end

function QuestSystemNpc.InsertPlayer(account, name, questIdentification)
    local query = string.format("INSERT INTO [dbo].[QUEST_SYSTEM_NPC] ([AccountID],[Name],[QuestIdentification]) VALUES ('%s','%s','%d')", account, name, questIdentification)

    CreateAsyncQuery('InsertQuestNpcPlayer', query, -1, 0)
end

function QuestSystemNpc.DeleteQuestInfo(account, name)
    local query = ""

    if QUEST_SYSTEM_NPC_ONLY_ACCOUNT == 1
    then
        query = string.format("DELETE FROM [dbo].[QUEST_SYSTEM_NPC] WHERE AccountID='%s'", account)
    else
        query = string.format("DELETE FROM [dbo].[QUEST_SYSTEM_NPC] WHERE AccountID='%s' and Name='%s'", account, name)
    end

    CreateAsyncQuery('DeleteQuestNpcInfo', query, -1, 0)
end

function QuestSystemNpc.InsertQuestUsed(account, name, questIdentification)
    local query = string.format("INSERT INTO [dbo].[QUEST_SYSTEM_NPC_USED] ([AccountID],[Name],[QuestIdentification]) VALUES ('%s','%s','%d')", account, name, questIdentification)

    CreateAsyncQuery('InsertQuestNpcUsed', query, -1, 0)
end

function QuestSystemNpc.CheckQuestUsed(account, name, questIdentification)
    local query = ""

    if QUEST_SYSTEM_NPC_ONLY_ACCOUNT == 1
    then
        query = string.format("SELECT count(*) as count FROM [dbo].[QUEST_SYSTEM_NPC_USED] WHERE AccountID='%s' and questIdentification = '%d'", account, questIdentification)
    else
        query = string.format("SELECT count(*) as count FROM [dbo].[QUEST_SYSTEM_NPC_USED] WHERE AccountID='%s' and Name='%s' and questIdentification = '%d'", account, name, questIdentification)
    end

    local value = 0

    if db:exec(query) ~= 0
    then
        if db:fetch() ~= SQL_NO_DATA
        then
            value = db:getInt('count')
        end
    end

    db:clear()

    return value
end

function QuestSystemNpc.NpcTalk(NpcIndex, PlayerIndex)
    local npc = User.new(NpcIndex)

    for i = 1, #QUEST_SYSTEM_NPC_LOCATION_INFO do
        local NpcInfo = QUEST_SYSTEM_NPC_LOCATION_INFO[i]

        if npc:getClass() == NpcInfo.Class
        then
            if npc:getMapNumber() == NpcInfo.Map and npc:getX() == NpcInfo.CoordX and npc:getY() == NpcInfo.CoordY
            then
                local player = User.new(PlayerIndex)

                QuestSystemNpc.OpenQuest(player, NpcInfo.QuestIdentification, 1)

                player = nil
                return 1
            end
        end
    end

    npc = nil
end

function QuestSystemNpc.Init()
    if QUEST_SYSTEM_NPC_SWITCH ~= 1
    then
        return
    end

    GameServerFunctions.GameServerProtocol(QuestSystemNpc.Protocol)
    GameServerFunctions.EnterCharacter(QuestSystemNpc.PlayerJoin)
    GameServerFunctions.PlayerLogout(QuestSystemNpc.PlayerLogout)
    GameServerFunctions.PlayerDie(QuestSystemNpc.PlayerDie)
    GameServerFunctions.MonsterDie(QuestSystemNpc.MonsterDie)
    GameServerFunctions.NpcTalk(QuestSystemNpc.NpcTalk)
    GameServerFunctions.QueryAsyncProcess(QuestSystemNpc.QueryAsyncProcess)

    QuestSystemNpc.CreatePlayerCache()
end

QuestSystemNpc.Init()

return QuestSystemNpc