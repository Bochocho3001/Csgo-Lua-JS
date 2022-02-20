local bit = require("bit")
local bor, band = bit.bor, bit.band

local enabled = Menu.Switch("Dormant Aimbot", "Enable Dormant Aimbot", false)
local dmg = Menu.SliderInt("Dormant Aimbot", "Minimum Damage", 1, 1, 10)
local max_misses = Menu.SliderInt("Dormant Aimbot", "Maximum Misses", 1, 1, 5, "Maximum misses before safe mode")

Cheat.RegisterCallback("createmove", function(cmd)
    if enabled:Get() ~= true then return end
    local me = EntityList.GetLocalPlayer()
    if me == nil then return end
    local weap = (me:GetPlayer()):GetActiveWeapon()
    if weap == nil then return end
    if weap:IsKnife() or weap:IsGrenade() or weap:IsReloading() then return end
    local inaccuracy = weap:GetInaccuracy(weap)
    local maxplayers = GlobalVars.maxClients
    for i = 1, maxplayers do
        local player = EntityList.GetPlayer(i)
        if player ~= nil then
            if not player:IsTeamMate() and player:IsAlive() and player:IsDormant() then
                local dormant_state = player:GetNetworkState()
                local eye_pos = (me:GetPlayer()):GetEyePosition()
                local enemy_hitbox_pos = player:GetHitboxCenter(3)
                local trace = Cheat.FireBullet(me, eye_pos, enemy_hitbox_pos)
                if dormant_state == 1 or dormant_state == 2 or  dormant_state == 3 or dormant_state == 4 then
                    if inaccuracy < 0.01 and trace.damage >= dmg:GetInt() then
                        local end_pos = (trace.trace).endpos
                        local start_pos = (trace.trace).startpos
                        local va = Cheat.VectorToAngle(Vector.new(end_pos.x - start_pos.x, end_pos.y - start_pos.y, end_pos.z - start_pos.z))
                        cmd.viewangles = va
                        cmd.buttons = bor(cmd.buttons, 1)
                    end
                end
            end
        end
    end
end)
