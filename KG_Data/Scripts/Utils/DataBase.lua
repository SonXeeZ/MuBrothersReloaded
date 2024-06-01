--[[
Arquivo de Funções SQL
]]--

--[[
Get from GameServer SQL functions
]]--

db = SQL.new()

--[[
Declare Database class
]]--
DataBase = {}

SQL_NO_DATA = 100

function DataBase.Connect(iType,ODBC,User,Password)
	if db:connect(iType,ODBC,User,Password) == 0
	then
		LogAddC(2,string.format("Couldn't connect to database"))
	else
		LogAddC(2,string.format("Connected to database"))
		
		DataBase.Init()

		DataBase.CallRunAfterLoad()
	end

	--Connect Sql Async
	if ConnectQueryAsync(ODBC,User,Password) == 0
	then
		LogAddC(2,string.format("Couldn't connect to database Async"))
	end
end

function DataBase.Connect2(Host, Port, Database, User, Password)
    local success = db:connect2(Host, Port, Database, User, Password)
    
    if success == 0 then
        LogAddC(2, string.format("Couldn't connect to database"))
    else
        LogAddC(2, string.format("Connected to database"))
        DataBase.Init()
        DataBase.CallRunAfterLoad()
    end

    -- Connect Sql Async
    if ConnectQueryAsync2(Host, Port, Database, User, Password) == 0 then
        LogAddC(2, string.format("Couldn't connect to database Async"))
    end
end

function DataBase.Init()
	--Criar todas as colunas para não haver problemas de SQL.
	
	for i = 0 , #COLUMN_RESET do
		DataBase.CreateColumn(TABLE_RESET, COLUMN_RESET[i], "INT NOT NULL DEFAULT 0")
	end
	
	for i = 0 , #COLUMN_MRESET do
		DataBase.CreateColumn(TABLE_MRESET, COLUMN_MRESET[i], "INT NOT NULL DEFAULT 0")
	end
	
	for i = 0 , #COLUMN_PK do
		DataBase.CreateColumn(TABLE_PK, COLUMN_PK[i], "INT NOT NULL DEFAULT 0")
	end
	
	for i = 0 , #COLUMN_HERO do
		DataBase.CreateColumn(TABLE_HERO, COLUMN_HERO[i], "INT NOT NULL DEFAULT 0")
	end
	
	DataBase.CreateColumn(TABLE_VIP, COLUMN_VIP, "INT NOT NULL DEFAULT 0")
	
	DataBase.CreateColumn(TABLE_MULT_WAREHOUSE, COLUMN_MULT_WAREHOUSE, "INT NOT NULL DEFAULT 0")
	
	DataBase.CreateColumn(TABLE_LAST_VAULT_ID_WAREHOUSE, COLUMN_LAST_VAULT_ID_WAREHOUSE, "INT NOT NULL DEFAULT 0")
	
	DataBase.CreateColumn(TABLE_REWARD_PLAYER, COLUMN_REWARD_PLAYER, "INT NOT NULL DEFAULT 0")

end

function DataBase.getDb()
	return db
end

function DataBase.GetValue(Table, Column, Where, Name)
	local Query = string.format("SELECT %s FROM %s WHERE %s = '%s'", Column, Table, Where, Name)
	ret = db:exec(Query)
	
	if ret == 0
	then
		LogAddC(2,string.format("The query could not be executed: %s", Query))
		db:clear()
		return 0
	end
	
	nRet = db:fetch()
	
	if nRet == SQL_NO_DATA
	then
		LogAddC(2,string.format("The query could not be executed: %s", Query))
		db:clear()
		return 0
	end
	
	local val = db:getInt(Column)
	db:clear()
	return val
end

function DataBase.SetValue(Table, Column, Value, Where, Name)
	local Query = string.format("UPDATE %s SET %s=%d WHERE %s = '%s'", Table, Column, Value, Where, Name)

	ret = db:exec(Query)
	
	if ret == 0
	then
		LogAddC(2,string.format("The query could not be executed: %s", Query))
		db:clear()
		return
	end
	
	db:clear()
end

function DataBase.SetAddValue(Table, Column, Value, Where, Name)
	local Query = string.format("UPDATE %s SET %s=%s+%d WHERE %s = '%s'", Table, Column, Column, Value, Where, Name)

	ret = db:exec(Query)
	
	if ret == 0
	then
		LogAddC(2,string.format("The query could not be executed: %s", Query))
		db:clear()
		return
	end
	
	db:clear()
end

function DataBase.SetDecreaseValue(Table, Column, Value, Where, Name)
	local Query = string.format("UPDATE %s SET %s=%s-%d WHERE %s = '%s'", Table, Column, Column, Value, Where, Name)

	ret = db:exec(Query)
	
	if ret == 0
	then
		LogAddC(2,string.format("The query could not be executed: %s", Query))
		db:clear()
		return
	end
	
	db:clear()
end

function DataBase.GetString(Table, Column, Where, Name)
	local Query = string.format("SELECT %s FROM %s WHERE %s = '%s'", Column, Table, Where, Name)
	ret = db:exec(Query)
	
	if ret == 0
	then
		LogAddC(2,string.format("The query could not be executed: %s", Query))
		db:clear()
		return 'We could not find'
	end
	
	nRet = db:fetch()
	if nRet == SQL_NO_DATA
	then
		LogAddC(2,string.format("The query could not be executed: %s", Query))
		db:clear()
		return 'We could not find'
	end
	
	local str = db:getStr(Column)
	db:clear()
	return str
end

function DataBase.SetString(Table, Column, String, Where, Name)
	local Query = string.format("UPDATE %s SET %s='%s' WHERE %s = '%s'", Table, Column, String, Where, Name)
	ret = db:exec(Query)
	
	if ret == 0
	then
		LogAddC(2,string.format("The query could not be executed: %s", Query))
		db:clear()
		return
	end
	
	db:clear()
end

function DataBase.CreateColumn(table, column, definition)
	db:exec(string.format("IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '%s' AND COLUMN_NAME = '%s') ALTER TABLE %s ADD %s %s", table, column, table, column, definition))
	db:clear()
end

local DataBase_Handles = {}

function DataBase.CallRunAfterLoad()
	for i in pairs(DataBase_Handles) do
		DataBase_Handles[i].callback()	
	end
end

function DataBase.RunAfterLoad(callback)
	DataBase_Handles[callback] = { callback = callback }
end

return DataBase