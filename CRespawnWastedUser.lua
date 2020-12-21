local x,y = guiGetScreenSize()
opeWinH = {bb = {}}


function msg(int)
    if int then
        outputChatBox(int,0,255,0,true)
    end
end


local player = getLocalPlayer()
local px = x/x
DGS = exports.dgs
fonts = {
    text = dxCreateFont("font.ttf", 10*px, false, "antialiased"),
    mtext = dxCreateFont("font.ttf", 8*px, false, "antialiased"),
    Rtext = dxCreateFont("font.ttf", 95*px, false, "antialiased"),
}

local r1,r2 = 400,125
local p1,p2 = x/2-r1/2,y/2-r2/2
local posDx1,posDx2 = x/2-r1/2,y/2-r2/2

function createMarkers()
    for i,v in ipairs(SmerTpositions) do
        myMarker = createMarker(v[1],v[2],v[3],'Corona',1,255,0,0,100)
    end
end
createMarkers()


addEventHandler ( "onClientRender", root,
    function ( )
        for k,v in ipairs(SmerTpositions) do
            local x,y,z = v[1],v[2],v[3]+2
            local x1,y1,z1 = v[1],v[2],v[3]+0.5
            local px,py,pz = getElementPosition(getLocalPlayer())
            local distance = getDistanceBetweenPoints3D ( x,y,z,px,py,pz )
            local Mx, My, Mz = getCameraMatrix()
            if ( getDistanceBetweenPoints3D ( x,y,z, getElementPosition ( localPlayer ) ) ) < 154 then
                local coords = { getScreenFromWorldPosition ( x,y,z+1 ) }
                if coords[1] and coords[2] then

                    if processLineOfSight(x1,y1,z1, Mx, My, Mz, true, false, false, true, false, true) then break end
                    local dist = math.ceil(getDistanceBetweenPoints3D(px,py,pz,v[1],v[2],v[3]))
                    dxDrawText ("id markers: "..k.."\nРастояние: "..dist.."м", coords[1], coords[2], coords[1], coords[2], tocolor(255,255,255), math.min ( 0.4*(15/distance)/1.4,1), fonts.Rtext,"center" )
                end
            end
        end
    end)




------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

sTime = 10
time = sTime



function tt ()
    tempo = setTimer (function()

            time = time - 1


            if time == 0 then
            killTimer(tempo)

            end
    end, 1000, sTime)
end


function RenderWastedMessage()

    dxDrawRectangleCr(posDx1,posDx2,r1,r2-105,5,tocolor(10,10,10,150))
    dxDrawRectangleCr(x/2-r1/2,y/2-r2/2,r1,r2,5,tocolor(25,25,25,125))

    dxDrawText ("Вы погибли - выберите действие",x/2,p2,x/2,p2, tocolor ( 255, 255, 255, 255 ), 1, 1, fonts.text,"center",nil )
    dxDrawText ("Вы окажитесь в больнице через: "..time.."с.",x/2,p2+35,x/2,p2+35, tocolor ( 255, 255, 255, 255 ), 1, 1, fonts.mtext,"center",nil )
end

function createButtonsW()
    showCursor(true)

    opeWinH.bb[1] = DGS:dgsCreateButton(x/2-150,p2+75,125, 33.5, "Ждать скорую", false, false,nil,nil,nil,nil,nil,nil,tocolor(0,255,0,25),tocolor(0,255,0,200),tocolor(0,100,0,200))
    opeWinH.bb[2] = DGS:dgsCreateButton(x/2+25,p2+75,125, 33.5, "Умереть", false, false,nil,nil,nil,nil,nil,nil,tocolor(255,0,0,25),tocolor(255,0,0,200),tocolor(100,0,0,200))

    for i=1,2 do
        DGS:dgsSetFont (opeWinH.bb[i],fonts.mtext)
    end
end




addEventHandler ( "onClientPlayerWasted", getLocalPlayer(),
    function()
    tt()
    end)

function triggeredResp()
    triggerServerEvent ( "spawnUserHeal", resourceRoot, getLocalPlayer() )
end



function op()
    addEventHandler("onClientRender",root,RenderWastedMessage)
    createButtonsW()
end


function bbind()
end
bindKey( "SPACE", "up", bbind )




function CloseWasted()
    showCursor(false)
    for i=1,2 do
        if isElement(opeWinH.bb[i]) then
            destroyElement(opeWinH.bb[i])
            removeEventHandler("onClientRender",root,RenderWastedMessage)
        end
    end
end



function clickRegister(button,state)
    if button == "left" and state == "up" then
        if source == opeWinH.bb[1]  then
            ------------------------------------

            ------------------------------------
        elseif source == opeWinH.bb[2] then
            ------------------------------------

            ------------------------------------    
        end
    end
end
addEventHandler("onDgsMouseClick",root,clickRegister)









----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

function round(num)
    if ( num >= 0 ) then return math.floor( num + .5 )
    else return math.ceil( num - .5 ) end
end

function dxDrawCorner( x, y, r, color, corner, postGUI )
    local corner = corner or 1
    local start = corner % 2 == 0 and 0 or -r
    local stop = corner % 2 == 0 and r or 0
    local m = corner > 2 and -1 or 1
    local h = ( corner == 1 or corner == 3 ) and -1 or 1
    for yoff = start, stop do
        local xoff = math.sqrt( r * r - yoff * yoff ) * m
        dxDrawRectangle( x - xoff, y + yoff, xoff, h, color, postGUI )
    end
end

function dxDrawRectangleCr( posX, posY, width, height, radius, color, postGUI )
    local posX, posY, width, height = round( posX ), round( posY ), round( width ), round( height )
    local radius = radius and math.min( radius, math.min( width, height ) / 2 )  or 12

    dxDrawRectangle( posX, posY + radius, width, height - radius * 2, color, postGUI )
    dxDrawRectangle( posX + radius, posY, width - 2 * radius, radius, color, postGUI )
    dxDrawRectangle( posX + radius, posY + height - radius, width - 2 * radius, radius, color, postGUI )

    dxDrawCorner( posX + radius, posY + radius, radius, color, 1, postGUI )
    dxDrawCorner( posX + radius, posY + height - radius, radius, color, 2, postGUI )
    dxDrawCorner( posX + width - radius, posY + radius, radius, color, 3, postGUI )
    dxDrawCorner( posX + width - radius, posY + height - radius, radius, color, 4, postGUI )
end
