function getRang(user)
    if user == nil or user == '' then   return false end
    local login = getAccountName(getPlayerAccount(user))
    if isObjectInACLGroup ("user."..login, aclGetGroup ( "Heal" ) ) then
        local q = dbQuery(conn, "SELECT * FROM CGB WHERE login=?",login)
        local result = dbPoll(q,-1)
        if result then
            for _,row in ipairs(result) do
                if row["rang"] then
                    return tonumber(row["rang"])
                end
            end
        end
    end
    return false
end

function getSkinSpawn()
    local rang = getRang(source)
    for i,v in ipairs(invalidSkinMedic) do
        if i == rang then
            return v
        end
    end
    return 0
end


function spawnUser()
    local login = getAccountName(getPlayerAccount(source))
    if isObjectInACLGroup ("user."..login, aclGetGroup ( "Heal" ) ) then
        local x,y,z,r = unpack(spawnPoint[math.random(1,#spawnPoint)])
        spawnPlayer(source,x+math.random(-0.5,0.5),y+math.random(-0.5,0.5),z,r,getSkinSpawn(),0,0)
        fadeCamera(source, true)
        setCameraTarget(source, source)
    end
end
addEventHandler("onPlayerLogin",root,spawnUser)
