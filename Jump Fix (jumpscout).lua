local bit = require("bit")

local bor, band = bit.bor, bit.band

local weapons = Menu.MultiCombo("Jump Fix", "Active Weapons", {"Knife", "Nades", "Scout", "Awp", "Autsniper", "Pistol", "Heavy Pistol", "Global"}, 0, "Deactivates Auto Strafe When Jumping With The Selected Weapons")
local hc_on = Menu.Switch("Jump Fix", "Override Hitchance", false)
local hc = Menu.SliderInt("Jump Fix", "Hitchance On Jump", 0, 0, 100)

local auto_strafe = Menu.FindVar("Miscellaneous", "Main", "Movement", "Auto Strafe")

local velocity = function(entity)
    local velocity_x = entity:GetProp("m_vecVelocity[0]")
    local velocity_y = entity:GetProp("m_vecVelocity[1]")
    return math.sqrt(velocity_x * velocity_x + velocity_y * velocity_y)
end

function jump_fix()
    local me = EntityList.GetClientEntity(EngineClient.GetLocalPlayer()):GetPlayer()
    if me == nil then return end
    local weap = me:GetActiveWeapon()
	if weap == nil then return end
    local weap_id = weap:GetClassId()
    local is_nade = weap:IsGrenade()
    local is_knife = weap:IsKnife()
    local is_pistol = weap:IsPistol()
    local is_gun = weap:IsGun()
    local is_ssg = weap_id == 267
    local is_awp = weap_id == 233
    local is_auto = weap_id == 242 or weap_id == 261
    local is_heavy_pistol = weap_id == 46

    local player = EntityList.GetLocalPlayer()
    if player == nil then return end

    local get_multiCombo = function(number)
        local shift = bit.lshift(1, number)
        return bit.band(weapons:Get(), shift) > 0 and true or false
    end

    local get_knife = get_multiCombo(0)
    local get_nades = get_multiCombo(1)
    local get_scout = get_multiCombo(2)
    local get_awp = get_multiCombo(3)
    local get_auto = get_multiCombo(4)
    local get_pistol = get_multiCombo(5)
    local get_heavy = get_multiCombo(6)
    local get_global = get_multiCombo(7)

    local standing = velocity(player) < 2

    -- jump fix
    if standing then
        if is_knife and get_knife then auto_strafe:Set(false)
        elseif is_nade and get_nades then auto_strafe:Set(false) 
        elseif is_ssg and get_scout then auto_strafe:Set(false) 
        elseif is_awp and get_awp then auto_strafe:Set(false) 
        elseif is_auto and get_auto then auto_strafe:Set(false) 
        elseif is_pistol and get_pistol then auto_strafe:Set(false) 
        elseif is_heavy_pistol and get_heavy then auto_strafe:Set(false)
        elseif is_gun and get_global then auto_strafe:Set(false)
        else auto_strafe:Set(true) end
    else
        auto_strafe:Set(true)
    end
end

function jump_hitchance()
    local player = EntityList.GetLocalPlayer()
    if player == nil then return end

    local standing = velocity(player) < 5
		
    if hc_on:GetBool() then
        if standing and band(player:GetProp("m_fFlags"), 1) ~= 1 then
            for i = 1, 64 do
                RageBot.OverrideHitchance(i , hc:GetInt())
            end
        end
    end
end

Cheat.RegisterCallback("prediction", function ()
    jump_hitchance()
    jump_fix()
end)

Cheat.RegisterCallback("draw", function()
    if hc_on:GetBool() then
        hc:SetVisible(true)
    else
        hc:SetVisible(false)
    end
end)
