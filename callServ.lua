function syka(users)
    local string = ''
    for k, v in ipairs(mobile) do
        string = string..v
    end
    outputChatBox('Используйте номера экстренных служб: '..string,users,255,0,0)
end

baza = {}

function getUserFormsNick(theCurrentAccount)
    for k, player in ipairs ( getElementsByType ( "player" ) ) do
        local p_id = getAccountName(getPlayerAccount ( player ))
        if ( p_id == getAccountName(theCurrentAccount) ) then
            player_n = getAccountName (getPlayerAccount( player ) )
            return player, player_n
        end
    end
    return false
end

addEventHandler("onResourceStart",resourceRoot, --Создание таблицы и столбцов
    function()
        if conn then
            local tabela = dbExec(conn,"CREATE TABLE IF NOT EXISTS callCenter(login TEXT,x INT,y INT,z INT)")
        else
            return
        end
end)

addEventHandler("onPlayerQuit", root,
    function ()
        local login = getAccountName ( getPlayerAccount ( source ) )
        triggerClientEvent ( source, "hhuk",source,login)

    end)

function loggedOut(thePreviousAccount,theCurrentAccount)
    -- outputChatBox( "Вы успешно вышли. Вас звать "..getPlayerName(source), source )
    -- local login = getAccountName(thePreviousAccount)
    triggerClientEvent (source,"dAlll",source)
end
addEventHandler("onPlayerLogout",getRootElement(),loggedOut)

addEventHandler("onResourceStart",resourceRoot, --Создание таблицы и столбцов
    function()
        -- table.insert(baza,{'LLIEPLLIEHb2',2590,-454,21})
end
)

function trigaHzNexochetPabotat(u1)
    triggerClientEvent (u1,"otobrCall",u1,baza,u1)
end

addEventHandler("onPlayerLogin",root,
    function(_, theCurrentAccount)
        local accNames = getAccountName(theCurrentAccount)
        if isObjectInACLGroup ("user."..accNames, aclGetGroup ( "Heal" ) ) then
            -----------------------Отправляем-данные-вызовов-игрокам-фраккции--------------------
            local u1,u2 = getUserFormsNick(theCurrentAccount)
            trigaHzNexochetPabotat(u1)
            -------------------------------------------------------------------------------------
        end
    end
)

function obtabotka(user)
    local login = getAccountName (getPlayerAccount(user))
    local x,y,z = getElementPosition(user)
    for i,v in ipairs(baza) do
        if v[1] == login then
            outputChatBox("Вы уже вызвали скорую, ожидайте медика",user,255,255,0) return end
    end
    mark = createMarker(x,y,z-zPosMarkHeal,'cylinder',radiusMarkHeal,0,200,0,100)
    warnmsg(ThePlayer,"Старайтесь не покидать зону вызова,иначе вызов будет отменён")
    addEventHandler("onMarkerLeave",mark,
        function ( leaveElement, matchingDimension )
            if getElementType( leaveElement ) == "player" then
                local log = getAccountName (getPlayerAccount(leaveElement))
                local user = getPlayerFromLog(log)

                triggerClientEvent ( user, "hhuk",user,log)
                if isElement(mark) then
                    destroyElement(mark)
                end
                outputChatBox ( "Вы покинули зону вызова, вызов скорой помощи отменён!",user, 255, 255, 0 )
                local login = getAccountName (getPlayerAccount(user))
                for i,v in ipairs(baza) do
                    if v[1] == login then
                        table.remove(baza,i)
                    end
                end
            end
        end)
    -- outputChatBox(''..math.ceil(x)..','..math.ceil(y)..','..math.ceil(z)..'')
    table.insert(baza,{login,math.ceil(x),math.ceil(y),math.ceil(z)})
    triggerClientEvent ( user, "updaterCall",user,login,math.ceil(x),math.ceil(y),math.ceil(z))
end

addEvent( "obtabotka", true )
addEventHandler( "obtabotka", resourceRoot, obtabotka )


function delCallUserHeal()
    local login = getAccountName (getPlayerAccount(source))
    for i,v in ipairs(baza) do
        if v[1] == login then
            table.remove(baza,i)
        end
    end
end
addEventHandler ( "onPlayerQuit", root, delCallUserHeal )

function callPlayer(ThePlayer,cmd,obr)
    if isGuestAccount ( getPlayerAccount ( ThePlayer ) ) then
        warnmsg(ThePlayer,w6)
        warnmsg(ThePlayer,w7) return end

    if obr == nil or obr == '' or obr == ' ' then syka(ThePlayer) return end
    if obr == mob[1] or obr == mob[2] then

        obtabotka(ThePlayer)
    else
        syka(ThePlayer) return end
    --------------------
end
addCommandHandler('call',callPlayer)







------------------------------------------------------------------------------------
-- local theTikGap = 7.5
-- local getLastTick = getTickCount()

-- function obrCall()
--     if (getTickCount ( ) - getLastTick < theTikGap*1000) then
--         -- outputChatBox('Не флуди подожи: '..theTikGap..' sec.',255,0,0)
--         return
--     end
--     triggerServerEvent ( "spawnUserHeal", resourceRoot, getLocalPlayer() )
--     -- outputChatBox("Функция")
--     getLastTick = getTickCount()
-- end


-- function quitPlayer ( quitType )
-- triggerClientEvent ( source, "qutSHeal",source,source)
-- end