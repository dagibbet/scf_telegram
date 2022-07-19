

function getRandomPostbox()
    local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    local length = 2
    local randomString = ''

    math.randomseed(os.time())

    charTable = {}
    for c in chars:gmatch "." do
        table.insert(charTable, c)
    end

    for i = 1, length do
        randomString = randomString .. charTable[math.random(1, #charTable)]
    end
    return randomString .. math.random(1000, 9999)
end

function getPostbox(charid, cb)
		result = MySQL.Sync.fetchAll('SELECT * FROM players WHERE citizenid = @chid', { ['@chid'] = charid }) --, function(result)	
        if result ~= nil then			
            cb(result[1]['postbox'])
        end
        return nil
    --end)
end

function getOrGenerate(charid, cb)
    getPostbox(charid, function(s)		
        local postbox = s
        if postbox == nil then
            postbox = getRandomPostbox()
            MySQL.Async.execute('UPDATE players SET postbox = @pox WHERE citizenid = @chid', { ['@chid'] = charid, ['@pox'] = postbox }) --, function() cb(postbox) end)
			cb(postbox)
        else
            cb(postbox)
        end
    end)
end

RegisterServerEvent("scf_telegram:check_inbox")
AddEventHandler("scf_telegram:check_inbox", function()
    local _source = source
    local User = exports['qbr-core']:GetPlayer(_source)
    local Character = User.PlayerData
	--local postbox = getOrGenerate(Character.citizenid)
    getOrGenerate(Character.citizenid, function(postbox)
		MySQL.query('SELECT * FROM telegrams WHERE recipient = "'..postbox..'" ORDER BY id DESC', { }, function(result)
		local res = {}
		res['box'] = postbox
		res['firstname'] = Character.name
		res['list'] = result or {}
		--print(postbox, result)
				
		TriggerClientEvent("scf_telegram:client:inboxlist", _source, res)
            
        end)
    end)
end)

RegisterServerEvent("scf_telegram:check_inboxPD")
AddEventHandler("scf_telegram:check_inboxPD", function()
    local _source = source
	local result = MySQL.query.await('SELECT * FROM telegrams WHERE recipient = @reci ORDER BY id DESC', { ['@reci'] = "anon" }) --, function(result)
	local res = {}
	res['box'] = "ANON"
	res['firstname'] = "ANON"			
	res['list'] = result or {}
	--print(result)
		--if result ~= nil then
	TriggerClientEvent("scf_telegram:client:inboxlist", _source, res)
		--end
	--end)
end)

RegisterServerEvent("scf_telegram:SendTelegram")
AddEventHandler("scf_telegram:SendTelegram", function(data)
    local _source = source
    local User = exports['qbr-core']:GetPlayer(_source)
    local Character = User.PlayerData
    local currentMoney = User.Functions.GetMoney('cash')
    local removeMoney = Config.Pay

    if currentMoney >= removeMoney then
        getOrGenerate(Character.citizenid, function(postbox)
            local sentDate = os.date("%x")
            result = MySQL.Sync.fetchAll('SELECT postbox FROM players WHERE postbox = @pox',{['@pox'] = data.recipient}) --, function(result)
                if result[1] ~= nil then
                    if data.recipient == nil or data.recipient == '' and data.subject == nil or data.subject == '' then
                        TriggerClientEvent('QBCore:Notify', _source, 9,  "You need to add a PO Box and the Subject of your message", 3000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE') 
                    else
                        local Parameters = { ['recipient'] = data.recipient:upper(), ['sender'] = data.sender, ['subject'] = data.subject, ['sentTime'] = sentDate, ['message'] = data.message, ['postoffice'] = data.postoffice }
                        MySQL.Async.execute("INSERT INTO telegrams ( `recipient`,`sender`,`subject`,`sentTime`,`message`,`postoffice`) VALUES ( @recipient,@sender, @subject,@sentTime,@message,@postoffice )", Parameters)
                        User.Functions.RemoveMoney("cash", removeMoney)
                        TriggerClientEvent('QBCore:Notify', _source, 9,  "Telegram has been sent for an ammount of " .. removeMoney .. "cents", 3000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
                    end
                elseif data.recipient == "ANON" or data.recipient == "anon" then
					local Parameters = { ['recipient'] = data.recipient:upper(), ['sender'] = data.sender, ['subject'] = data.subject, ['sentTime'] = sentDate, ['message'] = data.message, ['postoffice'] = data.postoffice }            
					MySQL.Async.execute("INSERT INTO telegrams ( `recipient`,`sender`,`subject`,`sentTime`,`message`,`postoffice`) VALUES ( 'anon','anon', @subject,@sentTime,@message,@postoffice )", Parameters)
					if data.system == nil then 
						TriggerClientEvent('QBCore:Notify', _source, 9,  "Telegram has been sent free of charge.", 3000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
					end
				else
                    TriggerClientEvent('QBCore:Notify', _source, 9,  "The POBox you are trying to send the Telegram to, does not exist", 3000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')  
                end
            --end)
        end)
    else
        TriggerClientEvent('QBCore:Notify', _source, 9,  "you do not have enough money", 3000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')  
    end
end)

RegisterServerEvent("scf_telegram:getTelegram")
AddEventHandler("scf_telegram:getTelegram", function(tid)
    local _source = source
    local User = exports['qbr-core']:GetPlayer(_source)
    local telegram = {}
    Citizen.Wait(0)
    local result = MySQL.query.await('SELECT * FROM telegrams WHERE id = @id', { ['@id'] = tid }) --, function(result)

        if result[1] ~= nil then
            telegram['recipient'] = User.PlayerData.firstname
            telegram['sender'] = result[1]['sender']
            telegram['sentTime'] = result[1]['sentTime']
            telegram['subject'] = result[1]['subject']
            telegram['message'] = result[1]['message']
            MySQL.Async.execute('UPDATE telegrams SET status = 1 WHERE id = @id', { ['@id'] = tid })
            TriggerClientEvent("scf_telegram:client:messageData", _source, telegram)
        end
    --end)
end)

RegisterServerEvent("scf_telegram:DeleteTelegram")
AddEventHandler("scf_telegram:DeleteTelegram", function(tid)
	local _source = source

    Citizen.Wait(0)
   
    local result = MySQL.query.await("SELECT * FROM telegrams WHERE id = @id", { ['@id'] = tid }) --, function(result)
        if result[1] ~= nil then
            MySQL.Async.execute("DELETE FROM telegrams WHERE id = @id", { ["@id"] = tid })
            TriggerClientEvent('QBCore:Notify', _source, 9,  "Telegram deleted.", 3000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')  
        else
            TriggerClientEvent('QBCore:Notify', _source, 9,  "Failed to delete your message.", 3000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')  
        end
    --end)
    
end)