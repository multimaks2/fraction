function rpCharLocFrac(ThePlayer, cmd, ...)
    local playerlist = getElementsByType("player")
    local acc = getPlayerAccount(ThePlayer)
    local accName = getAccountName(acc)
    local acl = aclGetGroup ("Heal" )
    if isObjectInACLGroup ("user."..accName, acl) then
        for k, v in ipairs(playerlist) do
            local arg = {...}
            local text = table.concat( arg, " " )
            local account = getPlayerAccount(v)
            local accountName = getAccountName(account)
            if isObjectInACLGroup ("user."..accountName, aclGetGroup ( "Heal" ) ) then
                if ... then
                    local policeRank = 'Питух'
                    local idrang = getRang(ThePlayer)
                    for i,v in ipairs(rangs) do
                        if i == idrang then
                            rang =v
                        end
                    end
                    outputChatBox("#ff0000["..rang.."] "..getPlayerName(ThePlayer).."["..getElementData(ThePlayer,"ID").."]: "..text, v, 65, 105, 225,true)
                end
            end
        end
    end
end
addCommandHandler("r", rpCharLocFrac)

function nrpCharLocFrac(ThePlayer, cmd, ...)
    local playerlist = getElementsByType("player")
    local acc = getPlayerAccount(ThePlayer)
    local accName = getAccountName(acc)
    local acl = aclGetGroup ("Heal" )
    if isObjectInACLGroup ("user."..accName, acl) then
        for k, v in ipairs(playerlist) do
            local arg = {...}
            local text = table.concat( arg, " " )
            local account = getPlayerAccount(v)
            local accountName = getAccountName(account)
            if isObjectInACLGroup ("user."..accountName, aclGetGroup ( "Heal" ) ) then
                if ... then
                    local idrang = getRang(ThePlayer)
                    for i,v in ipairs(rangs) do
                        if i == idrang then
                            rang =v
                        end
                    end
                    outputChatBox("#ff0000(( NRP CHAT -  ["..rang.."] "..getPlayerName(ThePlayer).."["..getElementData(ThePlayer,"ID").."]:#f5f5dc "..text.."#ff0000 ))", v, 65, 105, 225,true)
                end
            end
        end
    end
end
addCommandHandler("rb", nrpCharLocFrac)



function ceGovkaFrac(ThePlayer,cmd,...)
    local account = getPlayerAccount(ThePlayer)
    local accountName = getAccountName(account)
    if isObjectInACLGroup ("user."..accountName, aclGetGroup ( "Heal" ) ) then
        local arg = {...}
        local text = table.concat( arg, " " )
        if ... then
            local idrang = getRang(ThePlayer)
            if idrang <= 8 then
                warnmsg(ThePlayer,'Вам запрещено сюда писать (с '..govMSG..' ранга)') return end
            outputChatBox ("#00bfff[Новости "..FracGlobalNameChat.."] "..getPlayerName(ThePlayer).."["..getElementData(ThePlayer,"ID").."]:#00bfff "..text, root, 200, 0, 0, true)
        end
    end
end
addCommandHandler("gov",ceGovkaFrac)










function printMsgOuSheet(msg,ThePlayer)
for i,v in ipairs(getElementsByType("player")) do
if getElementData(v,"frac") then 

if  v == ThePlayer then return end
outputChatBox(msg,root,65, 105, 225,true)

end
end

end




function obChat(ThePlayer, cmd, ...)
    local playerlist = getElementsByType("player")
    local acc = getPlayerAccount(ThePlayer)
    local accName = getAccountName(acc)
    local acl = aclGetGroup ("Heal" )
    if isObjectInACLGroup ("user."..accName, acl) then
        for k, v in ipairs(playerlist) do
            local arg = {...}
            local text = table.concat( arg, " " )
            local account = getPlayerAccount(v)
            local accountName = getAccountName(account)
            if isObjectInACLGroup ("user."..accountName, aclGetGroup ( "Heal" ) ) then
                if ... then

                    local idrang = getRang(ThePlayer)
                    for i,v in ipairs(rangs) do
                        if i == idrang then
                            rang =v
                        end
                    end

                    if idrang <= 7 then
                        warnmsg(ThePlayer,'Вам запрещено сюда писать (с '..okRang..' ранга)') return end

                            printMsgOuSheet("#ff0000[ Общий чат ["..FracGlobalNameChat.."] ["..rang.."] "..getPlayerName(ThePlayer).."["..getElementData(ThePlayer,"ID").."]: "..text.." ]",ThePlayer)

                end
            end
        end
    end
end
addCommandHandler("ob", obChat)


