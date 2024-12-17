-- Name: ThefItemItem
-- Revision: $Revision: 0.1.3 $
-- Developed by: Thef (https://www.github.com/thefmade/ThefItemInfo)
-- Description: Shows the content phase of an item

--  Function to return ItemID
local function GetItemID(itemLink)
    if not itemLink then return; end
    local itemString = string.match(itemLink, "item[%-?%d:]+")
    local _, itemID = strsplit(":", itemString)
    return tonumber(itemID)
end

--  Function to check if detailed tooltips are activated
local function ThefItemInfoIsDetailedTooltipsActivated()
    return GetCVar("UberTooltips") == "1"
end

--  Function to determine the item phase
local function ThefItemInfoGetPhase(itemID)
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, invTexture = GetItemInfo(itemID)

    --  hyjal summit, reputation rings
    if itemID > 29293 and itemID < 29310 then return 3; end
    --  zul'aman, rings
    if itemID > 33495 and itemID < 33501 then return 4; end
    --  pvp trinkets, badge of justice
    if itemID > 34575 and itemID < 34581 then return 4; end
    --  pvp items, level 70 rare sets
    if itemID > 35327 and itemID < 35417 and itemLevel == 115 then return 1; end
    --  pvp items, season 1 late
    if itemID > 32449 and itemID < 32997 and itemLevel == 123 then return 1; end 
    --  pvp items, cloaks, badge of justice
    if itemID == 33304 then return 4; end
    --  pvp items, season 2
    if itemID > 30485 and itemID < 33314 and itemLevel == 136 then return 2; end
    --  pvp items, season 1 to season 3, relics
    if itemID > 33935 and itemID < 33954 then
        if itemLevel == 115 then return 1; end
        if itemLevel == 136 then return 2; end
        if itemLevel == 146 then return 3; end
    end
    --  phase 1
    if itemID < 31958 and itemLevel < 128 then return 1; end
    --  phase 2
    if itemID < 30861 and itemLevel < 142 then return 2; end
    --  phase , ogri'la, items
    if (itemID >= 32645 and itemID <= 32654) and itemLevel >= 105  then return 2; end
    --  phase , ogri'la, gems
    if (itemID >= 32634 and itemID <= 32641) and itemLevel == 70 then return 2; end
    --  phase 3
    if itemID < 33006 then return 3; end
    --  hyjal summit, mace from trash
    --  pvp items, season 3
    if itemID < 34541 and itemLevel > 140 then return 3; end
    --  phase 4
    if itemID < 34164 then return 4; end
    --  phase 5
    return 5
end

--  Function to lookup the item phase
local function ThefItemInfoGetPhaseByTable(itemID)
    if not itemID then return; end
    
    return ThefItemInfoPhases[itemID]
end

--  Function to add custom text to the tooltip
local function ThefItemInfoAddTooltipText(tooltip, itemLink)
    local itemID = GetItemID(itemLink)

    local itemPhase = ThefItemInfoGetPhaseByTable(itemID)

    --[[
    local itemDebug
    if ThefItemInfoGetPhaseByTable(itemID) ~= ThefItemInfoGetPhase(itemID) then
        byTable = ThefItemInfoGetPhaseByTable(itemID)
        byGuess = ThefItemInfoGetPhase(itemID)
        if not byTable and byGuess == 1
        if not byTable then byTable = "false"; end
        if not byGuess then byGuess = "false"; end
        itemDebug = itemID .. ": by table " .. byTable .. " vs. by guess " .. byGuess
        --  DEBUG
        ChatFrame1:AddMessage(itemDebug)
    end
    ]]

    if itemPhase then
        tooltip:AppendText(" |cff999999(Phase " .. itemPhase .. ")|r")

        --  only add detailed text if UberTooltips is activated in the interface options
        if ThefItemInfoIsDetailedTooltipsActivated() then
            --  todo: add translation table
            tooltip:AddLine("Hinzugefügt in Phase " .. itemPhase .. ".")
        end

        tooltip:Show() -- Ensure the tooltip updates and shows the new line
    end
end

--  Function to handle the hook
local function ThefItemInfoInfoLatch(self)
    local _, itemLink = self:GetItem()
    if itemLink == "" or itemLink == nil then return; end
    ThefItemInfoAddTooltipText(self, itemLink)
end

--[[
local TooltipList = {
    --  standard tooltip
    "GameTooltip",
    --  tooltip of linked items, with close button
    "ItemRefTooltip",
    --  shopping tooltip
    "ShoppingTooltip",
    --  equip comparison tooltip
    "ComparisonTooltip",
    --  support for EQCompare
    "EQCompareTooltip",
    --  support for takKompare
    "tekKompareTooltip",
    --  support for LinkWrangler
    "IRR_",
    "LinkWrangler",
    --  support for MultiTips
    --  support for Links
    "LinksTooltip",
    --  support for AtlasLoot
    "AtlasLootTooltip",
    --  support for ItemMagic
    "ItemMagicTooltip",
    --  support for Sniff
    "SniffTooltip",
    --  support for LinkHeaven
    "LH_",
    --  support for Mirror
    "MirrorTooltip",
    --  support for TooltipExchange
    "TooltipExchange_TooltipShow",
    --  support for AtlasQuest
    "AtlasQuestTooltip"
}
]]

--  hook into the game tooltip
GameTooltip:HookScript("OnTooltipSetItem", ThefItemInfoInfoLatch)

--  hook into the item reference tooltip
ItemRefTooltip:HookScript("OnTooltipSetItem", ThefItemInfoInfoLatch)

--  hook into the shopping tooltips
ShoppingTooltip1:HookScript("OnTooltipSetItem", ThefItemInfoInfoLatch)
ShoppingTooltip2:HookScript("OnTooltipSetItem", ThefItemInfoInfoLatch)

--  hook into the equip comparison tooltip
--  ComparisonTooltip:HookScript("OnTooltipSetItem", ThefItemInfoInfoLatch)

--  hook into AtlasLoot tooltip
AtlasLootTooltip:HookScript("OnTooltipSetItem", ThefItemInfoInfoLatch)

--  hook into AtlasQuest tooltip
--  AtlasQuestTooltip:HookScript("OnTooltipSetItem", ThefItemInfoInfoLatch)