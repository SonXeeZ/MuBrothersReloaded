--[[
Game Master Level
Username - PlayerName - Level
]]

GAME_MASTER_LEVEL = {}

GAME_MASTER_LEVEL['SonXeez'] = { characterName = 'jolvan', level = 1 }

function CheckGameMasterLevel(account, name, level)
    local gamemaster = GAME_MASTER_LEVEL[account]

    if gamemaster ~= nil
    then
        if name == gamemaster.characterName
        then
            if gamemaster.level >= level
            then
                return 1
            end
        end
    end

    return 0
end