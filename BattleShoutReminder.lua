local bsr = {}

bsr.frame = CreateFrame("Frame", "FramePlaceholder", UIParent)
bsr.iconFrame = CreateFrame("Frame", "BattleShoutReminderFrame", UIParent)
bsr.iconFrame:SetWidth(46)
bsr.iconFrame:SetHeight(46)
bsr.frame:SetScript("OnEvent", function() bsr[event](bsr, arg2, arg3) end)
bsr.frame:SetScript("OnUpdate", function() bsr["OnUpdate"]() end)
bsr.frame:RegisterEvent("PLAYER_REGEN_DISABLED")
bsr.frame:RegisterEvent("PLAYER_REGEN_ENABLED")
bsr.iconFrame:SetPoint("CENTER", 0, 150)

local iconTexture = bsr.iconFrame:CreateTexture(nil, "BACKGROUND")
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
            bsr.iconFrame:Show()
        else
            bsr.iconFrame:Hide()
        end
    else
        bsr.iconFrame:Hide()
    end
end

local interval = 1  -- Intervalle en secondes entre les messages.
local lastMessageTime = 0

function bsr:OnUpdate()
    if not lastMessageTime or lastMessageTime < GetTime() - 1 then
        lastMessageTime = GetTime()
        --DEFAULT_CHAT_FRAME:AddMessage("Update BSR")
        UpdateIconVisibility()
    end
end

function bsr:PLAYER_REGEN_DISABLED()
    -- DEFAULT_CHAT_FRAME:AddMessage("PLAYER_REGEN_DISABLED triggered")

    UpdateIconVisibility()
end

function bsr:PLAYER_REGEN_ENABLED()
    UpdateIconVisibility()
end

-- Mettez à jour l'icône à l'initialisation de l'addon
UpdateIconVisibility()
