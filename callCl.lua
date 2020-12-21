function sykaNah(vizov)
    local string = ''
    for k, v in ipairs(vizov) do
        string = string..v
    end
    outputChatBox(string,255,0,0)
end



WastedCall = {}

function updaterCall(login,x,y,z)

    mark = createMarker(x,y,z-zPosMarkHeal,'cylinder',radiusMarkHeal,255,200,0,90)



    callBlip = createBlip( x, y, z, 0, 0, 255,255, 0 )
    setElementData(callBlip,'indexMark',login)
    setElementData(callBlip,'blip','callHeal')
    setBlipSize ( callBlip, 4)
end
addEvent( "updaterCall", true )
addEventHandler( "updaterCall", localPlayer, updaterCall )




function otobrCall(tabloIbanoe,u1)
    for i,v in ipairs(tabloIbanoe) do
        callBlip = createBlip( v[2], v[3], v[4], 0, 0, 255,255, 0 )
        setElementData(callBlip,'indexMark',v[1])
        setElementData(callBlip,'blip','callHeal')
        setBlipSize ( callBlip, 4)
    end
end
addEvent( "otobrCall", true )
addEventHandler( "otobrCall", localPlayer, otobrCall )




function destroyQuit(login)
    for blID,bb in ipairs(getElementsByType ( "blip" )) do
        if (getElementData(bb,'indexMark') or nil ) == login then
            destroyElement(bb)
        end
                        if isElement(mark) then
                    destroyElement(mark)
                end
    end
end
addEvent( "hhuk", true )
addEventHandler( "hhuk", localPlayer, destroyQuit )


function destroyAll()
    for blID,bb in ipairs(getElementsByType ( "blip" )) do
        if (getElementData(bb,'blip')) == "callHeal" then
            destroyElement(bb)
        end
    end
end
addEvent( "dAlll", true )
addEventHandler( "dAlll", localPlayer, destroyAll )




setTimer ( function()
    for blID,BlVal in ipairs(getElementsByType ( "blip" )) do
        local red, green, blue, alpha = getBlipColor ( BlVal )
        if getElementData(BlVal,'blip') == "callHeal" then
            if ( green == 255 ) then
                setBlipColor ( BlVal, 255, 0, 0, 255 )
            elseif (green == 0) then
                setBlipColor ( BlVal, 255,255, 0, 255 )
            end
        end
    end
end, 1000,0)

