-- Name: ThefItemItem
-- Revision: $Revision: 0.1 $
-- Developed by: Thef (https://www.github.com/thefmade/ThefItemInfo)
-- Description: Shows the content phase of an item

--  Function to return ItemID
local function GetItemID(itemLink)
    if not itemLink then return; end
    local itemString = string.match(itemLink, "item[%-?%d:]+")
    local _, itemID = strsplit(":", itemString)
    return tonumber(itemID)
end

local function ThefGetItemPhase(itemID, itemLevel)
	if itemID > 29293 and itemID < 29310 then return 3; end -- hdz3 reputation rings
	if itemID > 33495 and itemID < 33501 then return 4; end -- ZA rings
	if itemID > 34575 and itemID < 34581 then return 4; end -- badge of justice pvp trinkets
	if itemID > 35327 and itemID < 35417 and itemLevel == 115 then return 1; end -- 70 rar pvp sets
	if itemID > 32449 and itemID < 32997 and itemLevel == 123 then return 1; end -- late S1 items
	if itemID == 33304 then return 4; end -- badge of justice pvp cloak
	if itemID > 30485 and itemID < 33314 and itemLevel == 136 then return 2; end -- S2 items
	if itemID > 33935 and itemID < 33954 then -- relic S1-3
		if itemLevel == 115 then return 1; end
		if itemLevel == 136 then return 2; end
		if itemLevel == 146 then return 3; end
	end
	if itemID < 31958 and itemLevel < 128 then return 1; end
	if itemID < 30861 and itemLevel < 142 then return 2; end
	if itemID < 33006 then return 3; end
	if itemID < 34541 and itemLevel > 140 then return 3; end -- hdz3 trash mace and all S3 items
	if itemID < 34164 then return 4; end
	return 5
end

--  Function to add custom text to the tooltip
local function ThefItemInfoAddTooltipText(tooltip, itemLink)
    local itemID = GetItemID(itemLink)
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, invTexture = GetItemInfo(itemID)
    tooltip:AppendText("|cff999999 (Phase " .. ThefGetItemPhase(itemID, itemLevel) .. ")|r")
end

--  hook into the tooltip
GameTooltip:HookScript("OnTooltipSetItem",
    function (self)
        local _, itemLink = self:GetItem()
        if itemLink == "" or itemLink == nil then return; end
        ThefItemInfoAddTooltipText(self, itemLink)
    end
)
