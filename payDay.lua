function payDay()
local playerlist = getElementsByType("player")
for k, player in ipairs(playerlist) do
local idrang = getRang(player)
for i,v in ipairs(zarplata) do
	if idrang == i then
		zp = tonumber(v)
		outputChatBox("Вы получили зарплату: "..zp.."р ",player,255,255,15)
end
end
end
end
setTimer(payDay,payTime*60000,0)


nTime = payTime
function payTime()
nTime = nTime-1
if nTime == 0 then
nTime = payTime
end
end
setTimer(payTime,60000,0)



function ppAy(thePlayer)
outputChatBox("До зарплаты осталось "..nTime.." минут.", thePlayer, 255, 255, 0)
end
addCommandHandler("paytime", ppAy)


