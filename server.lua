conn = dbConnect("sqlite","Heal.db") --Подключение к базе данных в файла (FractionHeals.db)
if conn then
    outputDebugString("База ЦГБ загружена")
else
    outputDebugString("Ошибка! База ЦГБ не может быть загружена")
end

addEventHandler("onResourceStart",resourceRoot, --Создание таблицы и столбцов
    function()
        if conn then
            local tabela = dbExec(conn,"CREATE TABLE IF NOT EXISTS CGB(login TEXT,fracName TEXT,vigovor TEXT ,rang TEXT,reanim TEXT ,HealAcept TEXT ,oldJoin TEXT ,serial TEXT,oldSkin TEXT )")
        else
            return
        end
end
)

addEventHandler("onPlayerLogout", getRootElement(),
    function (acc,_)
        local name = getAccountName(acc)
        if isObjectInACLGroup("user." .. getAccountName(acc), aclGetGroup("Heal")) then
            triggerClientEvent ( source, "destMarkh", source,source )
        end
    end
)

addEventHandler("onPlayerLogin", root,
    function()

        local accNames = getAccountName(getPlayerAccount(source))
        if isObjectInACLGroup ("user."..accNames, aclGetGroup ( "Heal" ) ) then
            --------------Проверка без конекта к бд чтоб экономить ресурсы сервера---------------
            local q = dbQuery(conn, "SELECT * FROM CGB WHERE login=?",accNames)  -- поиск пользователя
            local result = dbPoll(q,-1)
            local tables = {}
            if not (#result == 0) then
                local q = dbQuery(conn,"SELECT rowid,* FROM CGB" ) --Получает все значения игроков
                local result = dbPoll(q,-1)
                if result then
                    setElementData(source,'frac',"CGB")
                    setElementData(source,'smena-Heal',"сдал")
                    triggerClientEvent ( source, "okeyJob", source, source )
                end
                -------------------------------------------------------------------------------------
            end
        end
    end
)

function warnmsg(ThePlayer,msg)
    outputChatBox(''..tostring(msg)..'',ThePlayer,255,0,0)
end


function getPlayerFromID ( id )
    for k, player in ipairs ( getElementsByType ( "player" ) ) do
        local p_id = getElementData ( player, "ID" )
        if ( p_id == tonumber(id) ) then
            player_n = getPlayerName ( player )
            return player, player_n
        end
    end
    return false
end


function getInviteData()
    local time = getRealTime()
    local dias = {"Воскресенье", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота"}
    local diaSemana = dias[time.weekday + 1]

    local dia = ("%02d"):format(time.monthday)
    local mes = ("%02d"):format(time.month+1)
    local ano = ("%02d"):format(time.year + 1900)

    local hours = time.hour
    local minutes = time.minute
    local seconds = time.second
    if minutes <= 9 then
        minutes = "0"..minutes
    end
    if (seconds < 10) then
        seconds = "0"..seconds
    end
    return dia.."."..mes.."."..ano..", "..diaSemana..", "..hours..":"..minutes..":"..seconds
end


-- function invite(ThePlayer, cmd, id,comanda)
--     local accountplayer = getPlayerAccount(ThePlayer)
--     local accName = getAccountName (accountplayer)
--     if isObjectInACLGroup ("user."..accName, aclGetGroup ( "Heal" ) ) then

--         -------------------------------------------------------------------------------------------------------------------------------
--         if id == nil or id == 0 then warnmsg(ThePlayer,w0) return end
--         if comanda == nil or comanda == '' or comanda == ' ' then warnmsg(ThePlayer,w1) return end
--         if comanda == 'heal' then
--             --------------------

--             -- -- -- -- -- -- --
--             -----------------------------------------
--             local userID = getPlayerFromID (id)
--             if userID then
--                 local login = getAccountName ( getPlayerAccount ( userID ) )
--                 local serial = getPlayerSerial (userID)
--                 local name = getPlayerName(userID)
--                 -----------------------------------------
--                 -- -- -- -- -- -- --

--                 --------------------
--                 local q = dbQuery(conn, "SELECT * FROM CGB WHERE login=?",login)  --Отправляет все значения игрока с логином, определяемым как "login"
--                 local result = dbPoll(q,-1)
--                 dbFree(q)
--                 if #result == 0 then
--                     dbQuery(conn,"INSERT INTO CGB (login,fracName,serial,oldJoin) VALUES (?,?,?,?) ",login,name,serial,getInviteData()) --Отправляет данные в базу данных в первый раз
--                     -- outputDebugString("dbQuery! "..login..","..name..","..serial.." ")
--                 elseif #result <= 1 then
--                     dbExec(conn,"UPDATE CGB SET fracName=?,serial=? WHERE login=?",name,serial,login) --Обновляет данные игрока
--                 end
--             end
--             --------------------
--         end
--         -------------------------------------------------------------------------------------------------------------------------------
--     else
--         warnmsg(ThePlayer,w2)
--     end
-- end
-- addCommandHandler("invite",invite)


function inveteUserId(ThePlayer,cmd,id,FRAC)
    local accountplayer = getPlayerAccount(ThePlayer)
    local accName = getAccountName (accountplayer)
    if isObjectInACLGroup ("user."..accName, aclGetGroup ( "Heal" ) ) then

       if id == nil or id == 0 then warnmsg(ThePlayer,w0) return end
       if FRAC == nil or FRAC == '' or FRAC == ' ' then warnmsg(ThePlayer,w1) return end
       if FRAC == 'heal' then
       local userID = getPlayerFromID (id)
       
       if userID then
       triggerClientEvent ( userID, "pipUser", userID, true , ThePlayer)
       end

      end
   end      
end
addCommandHandler("invite",inveteUserId)


function inviteFracAccept(data,attacer)
    local key = 14882020666777
    if data then
        local decodedString = teaDecode( data, key )

        local theUserDecID,ggName = getPlayerFromID(decodedString)
        if theUserDecID == false then return end
        local login = getAccountName ( getPlayerAccount ( theUserDecID ) )
        local serial = getPlayerSerial (theUserDecID)
        local name = getPlayerName(theUserDecID)

        local q = dbQuery(conn, "SELECT * FROM CGB WHERE login=?",login)  --Отправляет все значения игрока с логином, определяемым как "login"
        local result = dbPoll(q,-1)
        dbFree(q)
        if #result == 0 then
            dbQuery(conn,"INSERT INTO CGB (login,fracName,serial,oldJoin,rang) VALUES (?,?,?,?,?) ",login,name,serial,getInviteData(),1) --Отправляет данные в базу данных в первый раз

        elseif #result <= 1 then
            outputChatBox("Игрок уже состоит в данной фракции!",attacer,255,0,0)
            outputChatBox("Вы уже состоите в данной фракции!",theUserDecID,255,0,0)
        end

    end
end
addEvent( "hachukaPizza", true )
addEventHandler( "hachukaPizza", resourceRoot, inviteFracAccept )





function giveRunk(ThePlayer,cmd,id,idR)
if id == nil or id == 0 then warnmsg(ThePlayer,w0) return end

end
addCommandHandler("giverung",giveRunk)



function uninvite(ThePlayer,cmd,id)
    if id == nil or id == 0 then warnmsg(ThePlayer,w0) return end
    local userID = getPlayerFromID (id)
    if not userID == false then
        local login = getAccountName ( getPlayerAccount ( userID ) )
        local q = dbQuery(conn, "SELECT * FROM CGB WHERE login=?",login)  --Отправляет все значения игрока с логином, определяемым как "login"
        local result = dbPoll(q,-1)
        dbFree(q)
        if #result == 0 then
            warnmsg(userID,w4)
        elseif #result <= 1 then
            print("Удаляем")
            -- dbExec(conn,"UPDATE CGB SET fracName=?,serial=?,rang=? WHERE login=?",name,serial,11,login)
            outputChatBox('Вас исключили из фракции ЦГБ.',userID,255,0,0)
            outputChatBox('Приказ от '..getInviteData()..' || Исполнитель: '..getPlayerName(ThePlayer)..'',userID,255,255,0)
            dbExec(conn,"DELETE FROM CGB WHERE login=?", login)
            outputChatBox('')
        end
    end
end
addCommandHandler("medleave",uninvite)



function stleader(ThePlayer, cmd, id,comanda)
    local accountplayer = getPlayerAccount(ThePlayer)
    local accName = getAccountName (accountplayer)
    if isObjectInACLGroup ("user."..accName, aclGetGroup ( "Heal" ) ) then

        -------------------------------------------------------------------------------------------------------------------------------
        if id == nil or id == 0 then warnmsg(ThePlayer,w0) return end
        if comanda == nil or comanda == '' or comanda == ' ' then warnmsg(ThePlayer,w1) return end
        if comanda == 'heal' then
            --------------------

            -- -- -- -- -- -- --
            -----------------------------------------
            local userID = getPlayerFromID (id)
            if userID then
                local login = getAccountName ( getPlayerAccount ( userID ) )
                local serial = getPlayerSerial (userID)
                local name = getPlayerName(userID)
                -----------------------------------------
                -- -- -- -- -- -- --

                --------------------
                local q = dbQuery(conn, "SELECT * FROM CGB WHERE login=?",login)  --Отправляет все значения игрока с логином, определяемым как "login"
                local result = dbPoll(q,-1)
                dbFree(q)
                if #result == 0 then
                    outputChatBox("Вы назначили лидером фракции ЦГБ - "..getPlayerName(userID).." ",ThePlayer,255,25,100)
                    outputChatBox("Вас назначили лидером фракции ЦГБ",userID,0,255,0)
                    outputChatBox('Приказ от '..getInviteData()..' || Исполнитель: '..getPlayerName(ThePlayer)..'',userID,255,255,0)

                    dbQuery(conn,"INSERT INTO CGB (login,fracName,serial,rang,oldJoin) VALUES (?,?,?,?,?) ",login,name,serial,11,getInviteData()) --Отправляет данные в базу данных в первый раз
                    -- outputDebugString("dbQuery! "..login..","..name..","..serial.." ")
                elseif #result <= 1 then
                    outputChatBox("Вы назначили лидером фракции ЦГБ - "..getPlayerName(userID).." ",ThePlayer,255,25,100)
                    outputChatBox("Вас назначили лидером фракции ЦГБ",userID,0,255,0)
                    outputChatBox('Приказ от '..getInviteData()..' || Исполнитель: '..getPlayerName(ThePlayer)..'',userID,255,255,0)
                    dbExec(conn,"UPDATE CGB SET fracName=?,serial=?,rang=? WHERE login=?",name,serial,11,login) --Обновляет данные игрока
                end
            end
            --------------------
        end
        -------------------------------------------------------------------------------------------------------------------------------
    else
        warnmsg(ThePlayer,w2)
    end
end
addCommandHandler("setleader",stleader)

addEventHandler("onPlayerQuit", root,
    function ()
        local login = getAccountName ( getPlayerAccount ( source ) )
        if isObjectInACLGroup ("user."..login, aclGetGroup ( "Heal" ) ) then
            local q = dbQuery(conn, "SELECT * FROM CGB WHERE login=?",accName)  -- подкючение к счёту Получателя
            local result = dbPoll(q,-1)
            if #result <= 1 then
                local dataOut = getInviteData() or nil
                local names = getPlayerName(source)
                dbExec(conn,"UPDATE CGB SET oldJoin=?,fracName=? WHERE login=?",dataOut,names,login)
            end
        end
    end)



function getPlayerFromLog( lg )
    for k, player in ipairs ( getElementsByType ( "player" ) ) do
        local p_id = getAccountName(getPlayerAccount(player))
        if ( p_id == lg ) then
            player_n = getPlayerName ( player )
            return player, player_n
        end
    end
    return false
end



function openConcentFind(ThePlayer)
    local acc = getPlayerAccount(ThePlayer)
    local accNames = getAccountName(acc)
    if isObjectInACLGroup ("user."..accNames, aclGetGroup ( "Heal" ) ) then
        --------------Проверка без конекта к бд чтоб экономить ресурсы сервера---------------
        local q = dbQuery(conn, "SELECT * FROM CGB WHERE login=?",accNames)  -- поиск пользователя
        local result = dbPoll(q,-1)
        local tables = {}
        if not (#result == 0) then
            local q = dbQuery(conn,"SELECT rowid,* FROM CGB" ) --Получает все значения игроков
            local result = dbPoll(q,-1)
            if result then



                for _,row in ipairs(result) do
                    local d1 = row['login']
                    local d2 = row['fracName']
                    local d3 = getPlayerFromLog(row['login'])
                    local d4 = tonumber((row['rang']) or 1)
                    -- local d5 = getElementData(ThePlayer,'smena-Heal') or 'сдал'
                    table.insert(tables, {d1,d2,d3,d4})
                end
                ------
                triggerClientEvent ( ThePlayer, "windowFindH", ThePlayer, tables )
                ------
            end
            -------------------------------------------------------------------------------------
        end
    end
end
addCommandHandler("find",openConcentFind)
-- 1 логин игрока
-- 2 Никнейм
-- 3 Указатель на игрока
-- 4 Ранг
-- 5 состояние работы





function goJob(user)
    setElementData(user,'smena-Heal','работает')
end
addEvent( "goJob", true )
addEventHandler( "goJob", resourceRoot, goJob )


function stopJob(user)
    setElementData(user,'smena-Heal','сдал')
end
addEvent( "stopJob", true )
addEventHandler( "stopJob", resourceRoot, stopJob )


for i,v in ipairs(markerJobsH) do
    mark = createMarker(v[1],v[2],v[3]-1,'cylinder',1.5,255,0,75,175)
    addEventHandler("onMarkerHit",mark,
        function (thePlayer)
            if getElementType(thePlayer) == "player" and not getPedOccupiedVehicle(thePlayer) then
                triggerClientEvent(thePlayer,'okeyJob',thePlayer)
            end
        end)
end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

function getPlayerFromID ( id )
    for k, player in ipairs ( getElementsByType ( "player" ) ) do
        local p_id = getElementData ( player, "ID" )
        if ( p_id == tonumber(id) ) then
            player_n = getPlayerName ( player )
            return player, player_n
        end
    end
    return false
end


local theTikGap = 5
local getLastTick = getTickCount()

function obrCall(ThePlayer,cmd,id, ...)
    if (getTickCount ( ) - getLastTick < theTikGap*1000) then
        outputChatBox('Нельзя так часто использовать эту команду',ThePlayer,255,0,0)
        return
    end
    if getElementData(ThePlayer,'smena-Heal') == 'работает' then
        local x,y,z = getElementPosition(ThePlayer)
        local xa,ya,za = getElementPosition(getPlayerFromID(tonumber(id)))
        if getDistanceBetweenPoints3D(x,y,z,xa,ya,za) >= 2 then warnmsg(ThePlayer,'Вы слишком далеко от игрока,подойдите по ближе') return end
        if id == nil or id == 0 then warnmsg(ThePlayer,w0) return end
        local message = table.concat({...}, " ")
        if message == nil or message == '' or message == ' ' then  warnmsg(ThePlayer,'Укажите препарат') return end
        print(message)
        local theName = getPlayerName(ThePlayer)
        local userId = getPlayerFromID(tonumber(id))
        triggerClientEvent ( userId, "MsgWinHeal", userId,userId,message,getPlayerName(ThePlayer))
    else
        warnmsg(ThePlayer,'Вам необходимо начать смену')
    end
    getLastTick = getTickCount()
end


-- function serverivent(ThePlayer,cmd,id, ... )
--     if getElementData(ThePlayer,'smena-Heal') == 'работает' then
--         local x,y,z = getElementPosition(ThePlayer)
--         local xa,ya,za = getElementPosition(getPlayerFromID(tonumber(id)))
--         if getDistanceBetweenPoints3D(x,y,z,xa,ya,za) >= 2 then warnmsg(ThePlayer,'Вы слишком далеко от игрока,подойдите по ближе') return end
--         if id == nil or id == 0 then warnmsg(ThePlayer,w0) return end
--         local message = table.concat({...}, " ")
--         if message == nil or message == '' or message == ' ' then  warnmsg(ThePlayer,'Укажите препарат') return end
--         print(message)
--         local theName = getPlayerName(ThePlayer)
--         local userId = getPlayerFromID(tonumber(id))
--         triggerClientEvent ( userId, "MsgWinHeal", userId,userId,message,getPlayerName(ThePlayer))
--     else
--         warnmsg(ThePlayer,'Вам необходимо начать смену')
--     end
-- end
addCommandHandler ( "heal", obrCall )




------------------------------------------------------------------------------------



function healPedik(user)
    if not (getElementHealth(user) == 100) then
        local mybabki = getPlayerMoney (user)
        if (mybabki >= mTK)  then
            takePlayerMoney(user, mTK)
            setElementHealth ( user, 100)
        else
            outputChatBox("У вас не хватает денег",user,255,0,0)
        end
    else
        outputChatBox("Вы здоровы",user,0,255,0)
    end
end
addEvent( "healPedik", true )
addEventHandler( "healPedik", resourceRoot, healPedik )
