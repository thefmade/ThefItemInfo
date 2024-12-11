-- Name: ThefItemItem
-- Revision: $Revision: 0.1 $
-- Developed by: Thef (https://www.github.com/thefmade/ThefItemInfo)
-- Description: Shows the content phase of an item

--  Function to return ItemID
local function GetItemID(itemLink)
    if not itemLink then return; end
    local itemString = string.match(itemLink, "item[%-?%d:]+")
    local _, itemID = strsplit(":", itemString)
    return itemID
end

--  Function to add custom text to the tooltip
local function ThefItemInfoAddTooltipText(tooltip, itemLink)
    local itemID = GetItemID(itemLink)

    if ThefItemInfoPhases[tonumber(itemID)] then
        tooltip:AddDoubleLine(" ", "Hinzugefügt in Phase " .. ThefItemInfoPhases[tonumber(itemID)])
        tooltip:AppendText("|cff999999 (Phase " .. ThefItemInfoPhases[tonumber(itemID)] .. ")|r")
        tooltip:Show() -- Ensure the tooltip updates and shows the new line
    end
end

--  hook into the tooltip
GameTooltip:HookScript("OnTooltipSetItem",
    function (self)
        local _, itemLink = self:GetItem()
        if itemLink == "" or itemLink == nil then return; end
        ThefItemInfoAddTooltipText(self, itemLink)
    end
)