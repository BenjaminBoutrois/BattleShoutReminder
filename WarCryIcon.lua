local wci = {}

wci.frame = CreateFrame("Frame", "FramePlaceholder", UIParent)
wci.iconFrame = CreateFrame("Frame", "WarCryIconFrame", UIParent)
wci.iconFrame:SetWidth(40)
wci.iconFrame:SetHeight(40)
wci.frame:SetScript("OnEvent", function() wci[event](wci, arg2, arg3) end)
wci.frame:SetScript("OnUpdate", function() wci["OnUpdate"]() end)
wci.frame:RegisterEvent("PLAYER_REGEN_DISABLED")
wci.frame:RegisterEvent("PLAYER_REGEN_ENABLED")
wci.iconFrame:SetPoint("CENTER", 0, 150)

local iconTexture = wci.iconFrame:CreateTexture(nil, "BACKGROUND")
iconTexture:SetAllPoints()
iconTexture:SetTexture("Interface\\Icons\\Ability_Warrior_BattleShout")

local function UpdateIconVisibility()
    -- If player is warrior and in combat
    if UnitClass("player") == "Warrior" and UnitAffectingCombat("player") == 1 then

        -- Check for Battle Shout buff
        local hasBattleShout = false
        for i = 0, 16 do
            local name = UnitBuff("player", i)

            if name == "Interface\\Icons\\Ability_Warrior_BattleShout" then
                hasBattleShout = true
                -- DEFAULT_CHAT_FRAME:AddMessage("Battle Shout found")
                break
            end
        end

        if not hasBattleShout then
            wci.iconFrame:Show()
        else
            wci.iconFrame:Hide()
        end
    else
        wci.iconFrame:Hide()
    end
end

local interval = 1  -- Intervalle en secondes entre les messages.
local lastMessageTime = 0

function wci:OnUpdate()
    if not lastMessageTime or lastMessageTime < GetTime() - 1 then
        lastMessageTime = GetTime()
        --DEFAULT_CHAT_FRAME:AddMessage("Update WCI")
        UpdateIconVisibility()
    end
end

function wci:PLAYER_REGEN_DISABLED()
    -- DEFAULT_CHAT_FRAME:AddMessage("PLAYER_REGEN_DISABLED triggered")

    UpdateIconVisibility()
end

function wci:PLAYER_REGEN_ENABLED()
    UpdateIconVisibility()
end

-- Mettez à jour l'icône à l'initialisation de l'addon
UpdateIconVisibility()
