local x, y = guiGetScreenSize()
m1 = 500
m2 = 240
Lbase = {}

function findWindow(unpackData)

    showCursor(true)
    windowFindH = guiCreateWindow(x/2-(m1/2),y/2-(m2/2),m1,m2, "Список игроков фракции", false)
    GridHeals =   guiCreateGridList(10, 29, 490, 160, false, windowFindH)
    guiGridListAddColumn(GridHeals, "  ID", 0.1)
    guiGridListAddColumn(GridHeals, "Имя", 0.275)
    guiGridListAddColumn(GridHeals, "Должность", 0.25)
    guiGridListAddColumn(GridHeals, "Смена", 0.16)
    guiGridListAddColumn(GridHeals, "Статус", 0.15)
    guiGridListClear(GridHeals)
    HealCloseButton = guiCreateButton(10, 210, 490, 22, "Закрыть", false, windowFindH)


    -- ◊ ◈  □ ■  ▪ ▫

    for key, value in pairs( unpackData ) do
        table.insert(Lbase, {value[key]})
        local row = guiGridListAddRow(GridHeals)
        guiGridListSetItemText(GridHeals, row, 2,'  '..value[2], false, false)
        for i,v in ipairs(rangs) do
            if i == value[4] then
                guiGridListSetItemText(GridHeals, row, 3,'  ['..v..']', false, false)
            end
            if not value[3] == false then
                local dat1 = getElementData(value[3],"ID") or "-"
                guiGridListSetItemText(GridHeals, row, 1,'('..dat1..')', false, false)
            else
                guiGridListSetItemText(GridHeals, row, 1,'  -', false, false)
            end
            if not value[3] == false then
                local dat2 = getElementData(value[3],"smena-Heal") or "error"
                if dat2 == "сдал" then
                    guiGridListSetItemText(GridHeals, row,4,'  '..dat2, false, false)
                    guiGridListSetItemColor ( GridHeals, row, 4, 255,0,0 )

                elseif dat2 == "работает" then
                    guiGridListSetItemText(GridHeals, row,4,'  '..dat2, false, false)
                    guiGridListSetItemColor ( GridHeals, row, 4, 0,255,0 )
                end
            end
            if not value[3] == false then
                guiGridListSetItemText(GridHeals, row, 5,'  online', false, false)
                guiGridListSetItemColor ( GridHeals, row, 5, 0,255,0 )
            else
                guiGridListSetItemText(GridHeals, row,4,"  сдал", false, false)
                guiGridListSetItemColor ( GridHeals, row, 4, 255,0,0 )
                guiGridListSetItemText(GridHeals, row, 5,'  offline', false, false)
                guiGridListSetItemColor ( GridHeals, row, 5, 150,150,150 )
            end
        end
    end


    -- 1 логин игрока
    -- 2 Никнейм
    -- 3 Указатель на игрока
    -- 4 Ранг
    -- 5 состояние работы (не отпровляем т.к лучше искать на клиенте)
    ---------------------------------------------------------------------------------------------
    guiWindowSetSizable(windowFindH, false)
    guiSetFont(HealCloseButton, "default-bold-small")
    guiSetProperty(HealCloseButton, "NormalTextColour", "FFFF0000")
end

function opWindows(unpackData)
    if isElement(windowFindH) then
    else
        findWindow(unpackData)
    end
end
addEvent( "windowFindH", true )
addEventHandler( "windowFindH", localPlayer, opWindows )

function closeFind(button,state)
    if button == "left" and state == "up" then
        if source == HealCloseButton then
            destroyElement(windowFindH)
            showCursor(false)
        end
    end
end
addEventHandler("onClientGUIClick",resourceRoot,closeFind)

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
m3 = 350
m4 = 125
statka = false
function jobmedic(hitPlayer)
    if hitPlayer == getLocalPlayer() then return end
    if statka == false then
        statka = true
        showCursor(true)
        main = guiCreateWindow(x/2-(m3/2),y/2-(m4/2),m3,m4, "Выберите действие", false)

        if getElementData(getLocalPlayer(),'smena-Heal') == "сдал" then
            btns = guiCreateButton(10, 90, 130, 25, "Заступить на смену", false, main)
            guiSetFont(btns, "default-bold-small")
            guiSetProperty(btns, "NormalTextColour", "FF00defd")


        elseif getElementData(getLocalPlayer(),'smena-Heal') == "работает" then
            btns = guiCreateButton(10, 90, 130, 25, "Закончить на смену", false, main)
            guiSetFont(btns, "default-bold-small")
            guiSetProperty(btns, "NormalTextColour", "FFaf7c00")
        end


        close = guiCreateButton(210, 90, 130, 25, "Закрыть", false, main)
        guiWindowSetSizable(main, false)
        guiSetFont(close, "default-bold-small")
        guiSetProperty(close, "NormalTextColour", "FFFF0000")
    end
end
addEvent( "okeyJob", true )
addEventHandler( "okeyJob", localPlayer, jobmedic )

function cls()
    if isElement(main) then
        destroyElement(main)
        statka = false
        showCursor(false)
    end
end


function getJobState(user)
    local data = getElementData(getLocalPlayer(),'smena-Heal') or nil
    if data == 'сдал' then
        return false
    elseif data == 'работает' then
        return true
    end
end

function closeFind(button,state)
    if button == "left" and state == "up" then
        if source == btns then
            cls()
            if getJobState() == false then
                triggerServerEvent ( "goJob", resourceRoot, getLocalPlayer() )
            elseif getJobState() == true then
                triggerServerEvent ( "stopJob", resourceRoot, getLocalPlayer() )
            end
        elseif source  == close then
            cls()
        end
    end
end
addEventHandler("onClientGUIClick",resourceRoot,closeFind)


-- function Renderds()
-- local data = getElementData(getLocalPlayer(),'smena-Heal') or 0
-- dxDrawText (data, x/2,y/2,x/2,y/2, tocolor(255,255,255),1, f.text,"center" )
-- end

-- addEventHandler ( "onClientRender", root,Renderds)

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

myFont = guiCreateFont( "font.ttf", 10.5)

function createAcceptWindowMeDICK(userId,message,ThePlayer)
    if not userId == getLocalPlayer() then return end

    winn = guiCreateWindow((x - 407) / 2, (y - 159) / 2, 407, 159, "Оплата медикоментов.", false)
    guiSetProperty(winn, "CaptionColour", "FFEC5412")
    guiWindowSetSizable(winn, false)


    clOplata = guiCreateButton(255, 109, 120, 33, "Отменить", false, winn)
    guiSetProperty(clOplata, "NormalTextColour", "FFED1010")
    okOplata = guiCreateButton(35, 109, 120, 33, "Оплатить", false, winn)
    guiSetProperty(okOplata, "NormalTextColour", "FF2CE01E")

    labels = guiCreateLabel(38, 36, 330, 63, "Игрок "..ThePlayer..", предлагает  вам \n \""..message.."\",\n за "..mTK.." рублей.", false, winn)
    guiSetFont(labels, myFont)
    guiSetFont(clOplata, myFont)
    guiSetFont(okOplata, myFont)
    guiLabelSetHorizontalAlign(labels, "center", false)
    guiLabelSetVerticalAlign(labels, "center")

    guiSetInputMode("no_binds")


end





function Opppa1(userId,message,ThePlayer)
    if not isElement(winn) then
        showCursor(true)
        createAcceptWindowMeDICK(userId,message,ThePlayer)
    end
end


addEvent( "MsgWinHeal", true )
addEventHandler( "MsgWinHeal", localPlayer, Opppa1 )


function fnClose()
    if isElement(winn) then
        destroyElement(winn)
    end
    guiSetInputMode("allow_binds")
    showCursor(false)
end


function clickOff(button,state) -- Скрытие окна
    if button == "left" and state == "up" then
        if source == clOplata then
            fnClose()
        elseif source == okOplata then
            fnClose()
            local mybabki = getPlayerMoney ()
            if (mybabki >= mTK)  then
                triggerServerEvent ( "healPedik", resourceRoot,getLocalPlayer())
            else
                outputChatBox("У вас не хватает денег",255,0,0)
            end
        end
end
end

addEventHandler("onClientGUIClick",resourceRoot,clickOff)

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
local px = x/x
fonts = {
    text = guiCreateFont("font.ttf", 8*px, false, "antialiased"),

}



function pipUser(user,AttUser)
    if user then
        pipPlayer = user
    else
        user = nil
    end

    if AttUser then
    ThePlayer = AttUser
    end
    invites()
end
addEvent( "pipUser", true )
addEventHandler( "pipUser", localPlayer, pipUser )
-- pipUser()





function invites()
    -- showCursor(true)
    winAccepts = guiCreateWindow((x - 350) / 2, (y - 110) / 2, 350, 110, "Вступить в фракцию "..FracGlobalNameChat.."?", false)
    guiSetProperty(winAccepts, "CaptionColour", "FF2CE01E")
    guiWindowSetSizable(winAccepts, false)

    aFrac = guiCreateButton(0, 75, 120, 30, "Вступить", false, winAccepts)
    guiSetProperty(aFrac, "NormalTextColour", "FF2CE01E")
    nFrac = guiCreateButton(215, 75, 120, 30, "Отказаться", false, winAccepts)
    guiSetProperty(nFrac, "NormalTextColour", "FFED1010")


    guiSetFont(aFrac, fonts.text)
    guiSetFont(nFrac, fonts.text)


    guiSetInputMode("no_binds")
end
-- invites()



function Adest()
    if isElement(winAccepts) then
        destroyElement(winAccepts)
    end
    local currentState = isCursorShowing ()
    local oppositeState =  currentState
    guiSetInputMode("allow_binds")
    showCursor ( oppositeState )
end


function iClick(button,state)
    if button == "left" and state == "up" then
        if source == aFrac then
            --------------
            if ThePlayer then
            if  pipPlayer == nil  then return end
            local tostr = getElementData(getLocalPlayer(),"ID") or nil
            if not tostr == nil then return end

            local encodedString = teaEncode(tostr, 14882020666777 )
            triggerServerEvent ( "hachukaPizza", resourceRoot, encodedString,ThePlayer)
            Adest()
            -----------------------------------------------------------------
        else if source == nFrac then
            -----------------------------------------------------------------
            Adest()
            --------------
        end
        end
    end
end
end
addEventHandler("onClientGUIClick",resourceRoot,iClick)
