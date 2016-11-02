hudinfo = {}
--Einstellungen
hudinfo.time = true
hudinfo.item = true


function register_hud(playername)
	local player = minetest.get_player_by_name(playername)
	if hudinfo.item then	
		item = player:hud_add({
			hud_elem_type = "text",
			position = { x = 0.85, y=1.05 },
			text = itemstring(player),
			alignment = { x = 1, y = 0},
			direction = 1,
			number = 0xFFFFFF,
			offset = { x = -262, y = -103}
		})
	end
	if hudinfo.time then
		zeit = player:hud_add({
			hud_elem_type = "text",
			position = { x = 0.85, y=1.07 },
			text = timeofday(),
			alignment = { x = 1, y = 0},
			direction = 1,
			number = 0xFFFFFF,
			offset = { x = -262, y = -103}
		})
	end
	hudinfo[playername] = item
	hudinfo.zeit = zeit
	return item, zeit
end
minetest.register_on_joinplayer(function(player)
	local playername = player:get_player_name()
	register_hud(playername)
end) 

function itemstring(player)
	item = player:get_wielded_item()
	name = core.registered_items[item:get_name()]["description"]
	if core.registered_items[item:get_name()].type=="tool" then
		return tostring("Item: "..name..", Haltbarkeit: "..prozent(player).."%")
	elseif core.registered_items[item:get_name()].type=="craft" then
		return tostring("Item: "..name..", Menge: "..item:get_count())
	elseif core.registered_items[item:get_name()].type=="node" then
		return tostring("Item: "..name..", Menge: "..item:get_count())
	else
		return " "
	end
end

function prozent(player)
	return math.ceil(math.floor(100-player:get_wielded_item():get_wear()/65535*100+0.5))
end

minetest.register_globalstep(function()
	for _,player in ipairs(minetest.get_connected_players()) do
		player_name=player:get_player_name()
		if hudinfo.item then
			player:hud_change(hudinfo[player_name], "text", itemstring(player))
		end
		if hudinfo.time then
			player:hud_change(hudinfo.zeit, "text", timeofday())
		end
	end
end)

--Diese Funktion wurde aus https://github.com/minetest/minetest/blob/master/builtin/game/chatcommands.lua#L770 übernommen und abgewandelt.
function timeofday()
	local current_time = math.floor(core.get_timeofday() * 1440)
	local minutes = current_time % 60
	local hour = (current_time - minutes) / 60
	return string.format("Uhrzeit: %02d:%02d", hour, minutes)
end
