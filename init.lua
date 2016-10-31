hud = {}
--Einstellungen
hud.time = true
hud.item = true


function register_hud(playername)
	local player = minetest.get_player_by_name(playername)
	if hud.item then	
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
	if hud.time then
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
	hud[playername] = item
	hud.zeit = zeit
	return item, zeit
end
minetest.register_on_joinplayer(function(player)
	local playername = player:get_player_name()
	register_hud(playername)
end)

function itemstring(player)
	return tostring("Item: "..player:get_wielded_item():get_name()..", Menge: "..player:get_wielded_item():get_count()..", Haltbarkeit: "..prozent(player).."%")
end

function prozent(player)
	return math.ceil(math.floor(100-player:get_wielded_item():get_wear()/65535*100+0.5))
end

minetest.register_globalstep(function()
	for _,player in ipairs(minetest.get_connected_players()) do
		player_name=player:get_player_name()
		if hud.item then
			player:hud_change(hud[player_name], "text", itemstring(player))
		end
		if hud.time then
			player:hud_change(hud.zeit, "text", timeofday())
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
