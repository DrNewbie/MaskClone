local BeCloneMaskIcon = BlackMarketTweakData.get_mask_icon

function BlackMarketTweakData:get_mask_icon(mask_id)
	return BeCloneMaskIcon(self, mask_id:gsub('_beclone', ''))
end