function findClosest(ply)
	local x,y,z = getElementPosition(ply)
	local i = 1
	for k,v in pairs(SmerTpositions) do
		local dist = getDistanceBetweenPoints3D( x,y,z,v[1],v[2],v[3] )
		if dist <= getDistanceBetweenPoints3D( x,y,z,SmerTpositions[i][1],SmerTpositions[i][2],SmerTpositions[i][3] ) then
			i = k
		end
	end
	return SmerTpositions[i]
end



function spawnPlayerAtHospital(user)
	source = user
	local oldskin = getElementModel(source)
	local pos = findClosest(source)

	setTimer(function(ply,skin,pos) 
		spawnPlayer( ply, pos[1],pos[2],pos[3],pos[4],skin)
		fadeCamera(ply, true,5)


			setElementHealth(ply,20)
            outputChatBox("Вас успешно реанимировали,ожидайте врача",ply, 89,125,163,true)

	end,5000,1,source,oldskin,pos)
end
addEvent('spawnUserHeal',true)
addEventHandler('spawnUserHeal',root,spawnPlayerAtHospital)

