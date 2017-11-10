core:import("CoreMissionScriptElement")
ElementInventoryDummy = ElementInventoryDummy or class(CoreMissionScriptElement.MissionScriptElement)

local BeCloneMaskDummy_spawn_mask = ElementInventoryDummy._spawn_mask
function ElementInventoryDummy:_spawn_mask(category, slot, ...)
	local slot_data = category[slot]
	if not slot_data then
		return
	end
	local mask_id = slot_data.mask_id
	if mask_id:find('_beclone') then
		return
	end
	BeCloneMaskDummy_spawn_mask(self, category, slot, ...)
end

local BeCloneMaskDummy = ElementInventoryDummy.assemble_mask
function ElementInventoryDummy:assemble_mask(mask_id, ...)
	if mask_id:find('_beclone') then
		return
	end
	BeCloneMaskDummy(self, mask_id, ...)
end