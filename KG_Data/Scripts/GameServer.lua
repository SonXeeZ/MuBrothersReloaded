--[[
declare global var
--]]

command = Command.new()

--[[
Initial System
]]--
OpenExtension('LuaSystem')
OpenExtension('Utils')
OpenExtension('Configs\\Commands')
OpenExtension('Configs')
OpenExtension('Character')
OpenExtension('Systems')
OpenExtension('Commands')

function GameServer()
	LogAddC(1,"Lua loaded successfully!")
	
	--Use Local ODBC -> Script.dat gameserver (0)
	DataBase.Connect(3, "MuOnlineS6", "sa", "Rallyy111") 
	
	--Use remote connection sql -> script.dat gameserver (1)
	--DataBase.Connect2("127.0.0.1", 1433, "MuOnlineS6", "sa", "KGEmulator")
end