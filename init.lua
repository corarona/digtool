local digabovey=5

ws.rg('DigAll','Dig','digall',function()
	ws.dignodes(ws.get_reachable_positions(ws.range))
end)

ws.rg('DigList','Dig','diglist',function()
	local badnodes=nlist.get(nlist.selected)
	local ppos=minetest.localplayer:get_pos()
	local nds=minetest.find_nodes_near(ppos, ws.range, badnodes, true)
	ws.dignodes(nds)
end)

ws.rg('DigBadN','Dig','digbadnodes',function()
	local badnodes={'mcl_tnt:tnt','mcl_fire:basic_flame','mcl_fire:fire','mcl_fire:fire_charge','mcl_heads:wither_skeleton','mcl_sponges:sponge','mcl_sponges:sponge_wet'}

	if ws.get_dimension(ws.dircoord(0,0,0)) ~= "nether" then
		table.insert(badnodes,'mcl_nether:soul_sand')
	end

	local ppos=minetest.localplayer:get_pos()
	local nds=minetest.find_nodes_near(ppos, 3, badnodes, true)
	ws.dignodes(nds)
end)

ws.rg("DigAbove","Dig",'digabove',function()
	local i=0
	for k,p in ipairs(ws.get_reachable_positions(4)) do
		if i > 8 then return end
		local n=minetest.get_node_or_nil(p)
		if n and n.name ~= "air" and p.y > digabovey then
			i = i + 1
			ws.dig(p)
		end
	end
end)

minetest.register_chatcommand("dgy", {
	params = "id",
	description = "digabove",
	func = function() digabovey = tonumber(param) or digabovey end
})

ws.rg('Waterway','Diggers','excavator_waterway',function()
    minetest.settings:set_bool('continuous_forward',true)
    local lp=ws.dircoord(0,0,0)
    --local pos=ws.get_reachable_positions(2)
	local pos= {
    	ws.dircoord(1,0,0),
		ws.dircoord(1,1,0),
		ws.dircoord(1,2,0),
		ws.dircoord(1,0,1),
		ws.dircoord(1,1,1),
		ws.dircoord(1,2,1)
	}
	local wpos= {
    	ws.dircoord(1,-1,0),
		ws.dircoord(1,-1,1),

		ws.dircoord(1,0,-1),
		ws.dircoord(1,1,-1),
		--ws.dircoord(1,2,-1),

		ws.dircoord(1,0,2),
		ws.dircoord(1,1,2)
		--ws.dircoord(1,2,2),

		--ws.dircoord(1,2,-2)

	}
    for k,v in pairs(pos) do
		local n=minetest.get_node_or_nil(v)
		local dst=vector.distance(lp,v)
		ws.dig(v)
		if dst < 2 and ( not n or n.name ~= "air" )then
		    minetest.settings:set_bool('continuous_forward',false)
		end
    end
    for k,v in pairs(wpos) do
		local n=minetest.get_node_or_nil(v)
		if n and n.name == 'air' then
			local tnode='mcl_core:obsidian'
			ws.place(v,tnode)
			if not n or n.name ~= tnode then
				minetest.settings:set_bool('continuous_forward',false)
			end
		end
    end

end,function()end,function()end,{'afly_snap'})
