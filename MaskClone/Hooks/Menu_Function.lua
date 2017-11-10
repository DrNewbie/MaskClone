Hooks:Add("LocalizationManagerPostInit", "MaskClone_loc", function(loc)
	LocalizationManager:add_localized_strings({
		["MaskClone_menu_title"] = "Mask Clone",
		["MaskClone_menu_desc"] = " ",
		["MaskClone_menu_forced_update_all_title"] = "Update",
		["MaskClone_menu_forced_update_all_desc"] = " "
	})
end)

Hooks:Add("MenuManagerSetupCustomMenus", "MaskCloneOptions", function( menu_manager, nodes )
	MenuHelper:NewMenu("MaskClone_menu")
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "MaskCloneOptions", function( menu_manager, nodes )
	MenuCallbackHandler.MaskClone_menu_forced_update_callback = function(self, item)
		local _file = io.open('assets/mod_overrides/MaskClone/main.xml', "w")
		local _new_named_ids = {}
		local _data_tables = {}
		local _, _, _mask_lists, _, _, _, _, _, _ = tweak_data.statistics:statistics_table()
		local banned = {saw = true, saw_secondary = true}
		if _file then
			_file:write('<table name=\"MaskClone\"> \n')
			_file:write('	<Localization directory="Loc" default="english.txt"/> \n')
			_file:write('	<Hooks directory="Hooks"> \n')
			_file:write('		<hook file="Menu_Function.lua" source_file="lib/managers/menumanager"/> \n')
			_file:write('		<hook file="BM_Icon.lua" source_file="lib/tweak_data/blackmarkettweakdata"/> \n')
			_file:write('		<hook file="BG_Icon.lua" source_file="lib/managers/mission/elementinventorydummy"/> \n')
			_file:write('	</Hooks> \n')
			for _, _mask_id in ipairs(_mask_lists) do
				local _md = tweak_data.blackmarket.masks[_mask_id]
				if _md and not _mask_id:find('_beclone') then
					local _datas = string.format('%s %s %s %s', 
							(_md.unit and 'unit="'.._md.unit ..'"' or ''),
							(_md.name_id and 'name_id="'.._md.name_id ..'_beclone"' or ''),
							(_md.type and 'type="'.._md.type ..'"' or ''),
							'guis_id="'.. _mask_id ..'"'
						)
					local name_txt = managers.localization:to_upper_text(_md.name_id)
					_new_named_ids[_md.name_id ..'_beclone'] = '[CL] ' .. name_txt
					local desc_txt = managers.localization:to_upper_text(_md.name_id..'_desc')
					if desc_txt:find('ERROR') then desc_txt = ' ' end
					_datas = string.format('%s %s', _datas, ('desc_id="'.. _md.name_id ..'_beclone_desc"'))
					_new_named_ids[_md.name_id ..'_beclone_desc'] = desc_txt
					_data_tables[Idstring(name_txt):key()] = tostring('	<Mask id="'.. _mask_id ..'_beclone" based_on="'.. _mask_id ..'" '.. _datas ..'/> \n')
				end
			end
			for _, _dataInsert in pairs(_data_tables) do
				_file:write(_dataInsert)
			end
			_file:write('</table>')
			_file:close()
			_file = io.open('assets/mod_overrides/MaskClone/Loc/english.txt', "w+")
			table.insert(_new_named_ids, "MaskClone")
			_file:write(json.encode(_new_named_ids))
			_file:close()
			local _dialog_data = {
				title = "[Weapon Clone]",
				text = "Please reboot the game.",
				button_list = {{ text = "[OK]", is_cancel_button = true }},
				id = tostring(math.random(0,0xFFFFFFFF))
			}
			managers.system_menu:show(_dialog_data)
		end
	end
	MenuHelper:AddButton({
		id = "MaskClone_menu_forced_update_callback",
		title = "MaskClone_menu_forced_update_all_title",
		desc = "MaskClone_menu_forced_update_all_desc",
		callback = "MaskClone_menu_forced_update_callback",
		menu_id = "MaskClone_menu",
	})
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MaskCloneOptions", function(menu_manager, nodes)
	nodes["MaskClone_menu"] = MenuHelper:BuildMenu( "MaskClone_menu" )
	MenuHelper:AddMenuItem(nodes["blt_options"], "MaskClone_menu", "MaskClone_menu_title", "MaskClone_menu_desc")
end)