local x,y = guiGetScreenSize()
local px = x/x
fonts = {
    text = dxCreateFont("font.ttf", 10*px, false, "antialiased"),

}




function Render()

        for k,v in ipairs(markerJobsH) do
            local x,y,z = v[1],v[2],v[3]-0.5
            local x1,y1,z1 = v[1],v[2],v[3]-0.75
            local Mx, My, Mz = getCameraMatrix()
            local px,py,pz = getElementPosition(getLocalPlayer())
            local distance = getDistanceBetweenPoints3D ( x,y,z,px,py,pz )
            if ( getDistanceBetweenPoints3D ( x,y,z, getElementPosition ( localPlayer ) ) ) < 20 then
                local coords = { getScreenFromWorldPosition ( x,y,z+1 ) }
                if coords[1] and coords[2] then
                    if processLineOfSight(x1,y1,z1, Mx, My, Mz, true, false, false, true, false, true) then break end
                    dxDrawText ( "Раздевалка", coords[1], coords[2], coords[1], coords[2], tocolor(255,255,255), math.min ( 0.4*(15/distance)/1.4,1), fonts.text,"center" )
                end
            end
        end
    end
addEventHandler ("onClientRender",root,Render)



bindKey ("f2", "down", function()
    if not isEventHandlerAdded( 'onClientRender', root, Render) then
    outputChatBox("Нет рендера")
    end
end)



function destMarkh(user)
    if not user == getLocalPlayer() then return end

    if isElement(myMarkerH) then
        removeEventHandler('onClientRender',root,Render)
    end

    for i, mark in ipairs ( getElementsByType ( "marker" ) ) do
        if (getElementData(mark,'marker-Healssss') ==  true) then
            destroyElement(mark)
        end
    end
end
addEvent( "destMarkh", true )
addEventHandler( "destMarkh", localPlayer, destMarkh )
