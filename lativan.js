ui = {   
    path: 'Script items',
    get: function(item){return 'Script items', item},
    show: function(path_value, script_path){if(path_value){UI.SetEnabled(script_path, 1)} else{UI.SetEnabled(script_path, 0)}},
    show2: function(path_value, path_value2, script_path){if(path_value && path_value2){UI.SetEnabled(script_path, 1)} else{UI.SetEnabled(script_path, 0)}},  
    show3: function(path_value, path_value2, path_value3, script_path){if(path_value && path_value2 && path_value3){UI.SetEnabled(script_path, 1)} else{UI.SetEnabled(script_path, 0)}},
    dropdown: function(a, b){
        const o = 1 << b;
        return a & o ? 1 : 0
    },
}

player = {
    isair: function(index){
        return Entity.GetProp(index, 'CBasePlayer', 'm_fFlags') & 1 ? 0 : 1
    },
    velocity: function(index){
        const velocity = Entity.GetProp(index, 'CBasePlayer', 'm_vecVelocity[0]');
        return Math.sqrt(velocity[0] * velocity[0] + velocity[1] * velocity[1])
    },
    iscrouch: function(index){return Entity.GetProp(index, 'CBasePlayer', 'm_flDuckAmount') > 0.8},
}

const custom_antiaim_conditions = 6

function setup_custom_aa(){
    for(i = 0; i < custom_antiaim_conditions; i++){
        UI.AddCheckbox('[' + (i + 1) + '] ' + 'override desync limit')
        UI.AddSliderInt('[' + (i + 1) + '] ' + 'right yaw', -180, 180)
        UI.AddSliderInt('[' + (i + 1) + '] ' + 'left yaw', -180, 180)
        UI.AddDropdown('[' + (i + 1) + '] ' + 'yaw modifier', ['off', 'center', 'offset', 'random'])
        UI.AddSliderInt('[' + (i + 1) + '] ' + 'yaw modifier amount', -180, 180)
        UI.AddDropdown('[' + (i + 1) + '] ' + 'fake limit type', ['static', 'jitter'])
        UI.AddSliderInt('[' + (i + 1) + '] ' + 'right limit', 0, 60)
        UI.AddSliderInt('[' + (i + 1) + '] ' + 'left limit', 0, 60)
        UI.AddDropdown('[' + (i + 1) + '] ' + 'jitter side', ['off', 'jitter', 'random jitter'])
    }
}

function handle_custom_aa(){
    const tab_value = UI.GetValue(ui.get('tab'))
    for(j = 0; j < custom_antiaim_conditions; j++){
        ui.show3(tab_value == 1, UI.GetValue(ui.get('anti aim type')) == 2, UI.GetValue(ui.get('anti aim condition')) == j, ui.get('[' + (j + 1) + '] ' + 'override desync limit'))
        ui.show3(tab_value == 1, UI.GetValue(ui.get('anti aim type')) == 2, UI.GetValue(ui.get('anti aim condition')) == j, ui.get('[' + (j + 1) + '] ' + 'right yaw'))
        ui.show3(tab_value == 1, UI.GetValue(ui.get('anti aim type')) == 2, UI.GetValue(ui.get('anti aim condition')) == j, ui.get('[' + (j + 1) + '] ' + 'left yaw'))
        ui.show3(tab_value == 1, UI.GetValue(ui.get('anti aim type')) == 2, UI.GetValue(ui.get('anti aim condition')) == j, ui.get('[' + (j + 1) + '] ' + 'yaw modifier'))
        ui.show3(tab_value == 1, UI.GetValue(ui.get('anti aim type')) == 2, UI.GetValue(ui.get('anti aim condition')) == j, ui.get('[' + (j + 1) + '] ' + 'yaw modifier amount'))
        ui.show3(tab_value == 1, UI.GetValue(ui.get('anti aim type')) == 2, UI.GetValue(ui.get('anti aim condition')) == j, ui.get('[' + (j + 1) + '] ' + 'fake limit type'))
        ui.show3(tab_value == 1, UI.GetValue(ui.get('anti aim type')) == 2, UI.GetValue(ui.get('anti aim condition')) == j, ui.get('[' + (j + 1) + '] ' + 'right limit'))
        ui.show3(tab_value == 1, UI.GetValue(ui.get('anti aim type')) == 2, UI.GetValue(ui.get('anti aim condition')) == j, ui.get('[' + (j + 1) + '] ' + 'left limit'))
        ui.show3(tab_value == 1, UI.GetValue(ui.get('anti aim type')) == 2, UI.GetValue(ui.get('anti aim condition')) == j, ui.get('[' + (j + 1) + '] ' + 'jitter side'))
    }
}

UI.AddDropdown('tab', ['rage', 'anti aim', 'visuals', 'misc'], 0)

// [ rage ]
UI.AddCheckbox('safe points on limbs')
UI.AddCheckbox('crosshair based targeting')
UI.AddHotkey('min damage override')
UI.AddSliderInt('pistol damage override', 1, 100)
UI.AddSliderInt('heavy pistol damage override', 1, 100)
UI.AddSliderInt('scout damage override', 1, 100)
UI.AddSliderInt('autosniper damage override', 1, 100)
UI.AddSliderInt('awp damage override', 1, 100)
UI.AddMultiDropdown('hp/2 weapons', ['autosniper', 'deagle'])
UI.AddCheckbox('air hitchance')
UI.AddSliderInt('air hc', 0, 100)
//UI.AddSliderInt('air hc maximum velocity', 0, 350)
UI.AddCheckbox('unscoped hitchance')
UI.AddSliderInt('unscoped hc', 0, 100)
//UI.AddSliderInt('unscoped hc maximum distance', 0, 3000)

// [ anti-aim ]
UI.AddDropdown('anti aim type', ['default', 'tank', 'custom'])
UI.AddDropdown('anti aim condition', ['stand', 'air', 'run', 'crouch', 'fakeduck', 'slowwalk'])
setup_custom_aa()
UI.AddMultiDropdown('legit desync', ['on use', 'force maximum desync'])
UI.AddMultiDropdown('anti-aim options', ['anti-bruteforce', 'leg breaker'])

// [ anti-bruteforce ]
UI.AddCheckbox('[anti-bruteforce] add phase')
UI.AddCheckbox('[anti-bruteforce] remove phase')

const max_antibrute_phases = 8
for(k = 0; k < max_antibrute_phases; k++) UI.AddSliderInt('[anti-bruteforce] phase ' + (k + 1).toString(), -60, 60)

UI.AddSliderInt('counter', 0, max_antibrute_phases)
UI.SetEnabled(ui.get('counter'), 0)

function anti_bruteforce_ui(){
    const tab_value = UI.GetValue(ui.get('tab'))
    ui.show2(tab_value == 1, ui.dropdown(UI.GetValue(ui.get('anti-aim options')), 0), ui.get('[anti-bruteforce] add phase'))
    ui.show2(tab_value == 1, ui.dropdown(UI.GetValue(ui.get('anti-aim options')), 0), ui.get('[anti-bruteforce] remove phase'))
    const add = UI.GetValue(ui.get('[anti-bruteforce] add phase'))
    const remove = UI.GetValue(ui.get('[anti-bruteforce] remove phase'))
    if(add) {UI.SetValue(ui.get('counter'), UI.GetValue(ui.get('counter')) + 1); UI.SetValue(ui.get('[anti-bruteforce] add phase'), 0)}
    if(remove) {UI.SetValue(ui.get('counter'), UI.GetValue(ui.get('counter')) - 1); UI.SetValue(ui.get('[anti-bruteforce] remove phase'), 0)}
    for(i = 0; i < max_antibrute_phases; i++){
        if(tab_value != 1 || !ui.dropdown(UI.GetValue(ui.get('anti-aim options')), 0)) {UI.SetEnabled(ui.get('[anti-bruteforce] phase ' + (i + 1).toString()), 0); continue}
        if(i >= UI.GetValue(ui.get('counter'))) {UI.SetEnabled(ui.get('[anti-bruteforce] phase ' + (i + 1).toString()), 0); continue}
        UI.SetEnabled(ui.get('[anti-bruteforce] phase ' + (i + 1).toString()), 1)
    }
}

function handle_menu(){
    const tab_value = UI.GetValue(ui.get('tab'))
    anti_bruteforce_ui()

    // [ rage ]
    ui.show(tab_value == 0, ui.get('adaptive doubletap'))
    ui.show(tab_value == 0, ui.get('safe points on limbs'))
    ui.show(tab_value == 0, ui.get('hp/2 weapons'))
    ui.show(tab_value == 0, ui.get('air hitchance'))
    ui.show(tab_value == 0, ui.get('unscoped hitchance'))
    ui.show(tab_value == 0, ui.get('override exploits'))
    ui.show(tab_value == 0, ui.get('crosshair based targeting'))
    ui.show(tab_value == 0, ui.get('min damage override'))
    ui.show(tab_value == 0, ui.get('pistol damage override'))
    ui.show(tab_value == 0, ui.get('heavy pistol damage override'))
    ui.show(tab_value == 0, ui.get('scout damage override'))
    ui.show(tab_value == 0, ui.get('autosniper damage override'))
    ui.show(tab_value == 0, ui.get('awp damage override'))
    ui.show2(tab_value == 0, UI.GetValue(ui.get('air hitchance')), ui.get('air hc'))
    //ui.show2(tab_value == 0, UI.GetValue(ui.get('air hitchance')), ui.get('air hc maximum velocity'))
    ui.show2(tab_value == 0, UI.GetValue(ui.get('unscoped hitchance')), ui.get('unscoped hc'))
    //ui.show2(tab_value == 0, UI.GetValue(ui.get('unscoped hitchance')), ui.get('unscoped hc maximum distance'))

    // [ anti-aim ]
    ui.show(tab_value == 1, ui.get('anti aim type'))
    ui.show2(tab_value == 1, UI.GetValue(ui.get('anti aim type')) == 2, ui.get('anti aim condition'))
    ui.show(tab_value == 1, ui.get('anti-aim options'))
    ui.show(tab_value == 1, ui.get('break leg animation'))
    ui.show(tab_value == 1, ui.get('legit desync'))
    handle_custom_aa()
}

function legfuck(){
    if(!ui.dropdown(UI.GetValue(ui.get('anti-aim options')), 1)) return
    tick_clock(4) ? UI.SetValue('Misc', 'GENERAL', 'Movement', 'Slide walk', 1) : UI.SetValue('Misc', 'GENERAL', 'Movement', 'Slide walk', 0)
}

var limb_index = [7, 8, 9, 10, 11, 12]

function safe_point_limbs(){
    if(!UI.GetValue(ui.get('safe points on limbs'))) return;
    for(i in limb_index) Ragebot.ForceHitboxSafety(limb_index[i])
}

function targeting(){
    if(!UI.GetValue(ui.get('crosshair based targeting'))) return;
    const screen_size = Render.GetScreenSize()
    const crosshair = [screen_size[0] / 2, screen_size[1] / 2]
    const enemies = Entity.GetEnemies()
    const minimumDistance = Infinity
    const enemy = 0
    for(i in enemies){
        if(Entity.IsAlive(enemies[i]) && Entity.IsValid(enemies[i]) && !Entity.IsDormant(enemies[i])){
            const enemies_pos = Entity.GetHitboxPosition(enemies[i], 2)
            const enemies_pos_2d = Render.WorldToScreen(enemies_pos)
            const final = vector_lenght(vector_rest(crosshair, enemies_pos_2d))
            if(final < minimumDistance) {
                minimumDistance = final
                enemy = enemies[i]
            }
        }
    }
    Ragebot.ForceTarget(enemy)
    return enemy
}

function hp2(){
    const local = Entity.GetLocalPlayer()
    const weapon = Entity.GetName(Entity.GetWeapon(local))
    const isdk = function(){if(weapon == 'desert eagle') return true}
    const isteco = function(){if(weapon =='g3sg1' || weapon == 'scar 20') return true}
    const val = UI.GetValue(ui.get('hp/2 weapons'))
    const enemies = Entity.GetEnemies()
    const target = Ragebot.GetTarget()
    if(ui.dropdown(val, 0) && isteco()){
        for(i in enemies){
            if(Entity.IsAlive(enemies[i]) && Entity.IsValid(enemies[i]) && !Entity.IsDormant(enemies[i])){
                const target_health = Entity.GetProp(enemies[i], 'CBasePlayer', 'm_iHealth')
                Ragebot.ForceTargetMinimumDamage(enemies[i], (target_health / 2) * 0.94)
            }
        }
    } else if(ui.dropdown(val, 1) && isdk()){
        for(i in enemies){
            if(Entity.IsAlive(enemies[i]) && Entity.IsValid(enemies[i]) && !Entity.IsDormant(enemies[i])){
                const target_health = Entity.GetProp(target, 'CBasePlayer', 'm_iHealth')
                Ragebot.ForceTargetMinimumDamage(enemies[i], ((target_health / 2) * 0.94))
            }
        }
    }
}

function air_hitchance(){
    if(!UI.GetValue(ui.get('air hitchance'))) return
    const hc = UI.GetValue(ui.get('air hc'))
    const maxvel = 100
    const local = Entity.GetLocalPlayer()
    const weapon = Entity.GetName(Entity.GetWeapon(local))
    const vel = vector_lenght(Entity.GetProp(local, 'CBasePlayer', 'm_vecVelocity[0]'))
    const isscout = function(){if(weapon == 'ssg 08') return true}
    const isr8 = function(){if(weapon == 'r8 revolver') return true}
    const enemies = Entity.GetEnemies()
    for(i in enemies){
        if(Entity.IsAlive(enemies[i]) && Entity.IsValid(enemies[i]) && !Entity.IsDormant(enemies[i])){
            if(isscout() || isr8()){
                if(vel <= maxvel){
                    Ragebot.ForceTargetHitchance(enemies[i], hc)
                }
            }
        }
    }
}

function noscope(){
    if(!UI.GetValue(ui.get('unscoped hitchance'))) return;
    const hc = UI.GetValue(ui.get('unscoped hc'))
    const maxdist = 900
    const local = Entity.GetLocalPlayer()
    const weapon = Entity.GetName(Entity.GetWeapon(local))
    const isteco = function(){if(weapon =='g3sg1' || weapon == 'scar 20') return true}
    const enemies = Entity.GetEnemies()
    const local_pos = Entity.GetEyePosition(local)
    const target = Ragebot.GetTarget()
    for(i in  enemies){
        const enemy_pos = Entity.GetHitboxPosition(target, 2)
        const lenght = vector_lenght(vector_rest(local_pos, enemy_pos))
        if(!Entity.IsAlive(enemies[i]) || !Entity.IsValid(enemies[i]) || Entity.IsDormant(enemies[i])) continue;
        if(isteco()){
            if(lenght < maxdist){
                Ragebot.ForceTargetHitchance(enemies[i], hc)
                UI.SetValue('Rage', 'Auto scope', 0)
            } else if(lenght > maxdist){
                UI.SetValue('Rage', 'Auto scope', 1)
            } else{
                UI.SetValue('Rage', 'Auto scope', 0)
            }
        } else{
            UI.SetValue('Rage', 'Auto scope', 1)
        }
    }
}

var anti_brute = 0

var lastHitTime = 0.0;
var lastImpactTimes = [0.0]
var lastImpacts = [[0.0, 0.0, 0.0]]

function OnBulletImpact()
{
    var curtime = Globals.Curtime();
    if (Math.abs(lastHitTime - curtime) < 0.5) return;

    var entity = Entity.GetEntityFromUserID(Event.GetInt('userid'));
    var impact = [Event.GetFloat('x'), Event.GetFloat('y'), Event.GetFloat('z'), curtime];
    var source;
    if (Entity.IsValid(entity) && Entity.IsEnemy(entity))
    {
        if (!Entity.IsDormant(entity))
        {
            source = Entity.GetEyePosition(entity);
        }
        else if (Math.abs(lastImpactTimes[entity] - curtime) < 0.1)
        {
            source = lastImpacts[entity];
        }
        else
        {
            lastImpacts[entity] = impact;
            lastImpactTimes[entity] = curtime;
            return;
        }
        var local = Entity.GetLocalPlayer();
        var localEye = Entity.GetEyePosition(local);
        var localOrigin = Entity.GetProp(local, 'CBaseEntity', 'm_vecOrigin');
        var localBody = VectorMultiply(VectorAdd(localEye, localOrigin), [0.5, 0.5, 0.5]);

        var bodyVec = ClosestPointOnRay(localBody, source, impact);
        var bodyDist = VectorDistance(localBody, bodyVec);
        
        if (bodyDist < 128.0)
        {
            var realAngle = Local.GetRealYaw();
            var fakeAngle = Local.GetFakeYaw();

            var headVec = ClosestPointOnRay(localEye, source, impact);
            var headDist = VectorDistance(localEye, headVec);
            var feetVec = ClosestPointOnRay(localOrigin, source, impact);
            var feetDist = VectorDistance(localOrigin, feetVec);

            var closestRayPoint;
            var realPos;
            var fakePos;

            if (bodyDist < headDist && bodyDist < feetDist) 
            {                                               
                closestRayPoint = bodyVec;
                realPos = ExtendVector(bodyVec, realAngle + 180.0, 10.0);
                fakePos = ExtendVector(bodyVec, fakeAngle + 180.0, 10.0);
            }
            else if (feetDist < headDist)
            {                            
                closestRayPoint = feetVec;
                var realPos1 = ExtendVector(bodyVec, realAngle - 30.0 + 90.0, 10.0);
                var realPos2 = ExtendVector(bodyVec, realAngle - 30.0 - 90.0, 10.0);
                var fakePos1 = ExtendVector(bodyVec, fakeAngle - 30.0 + 90.0, 10.0);
                var fakePos2 = ExtendVector(bodyVec, fakeAngle - 30.0 - 90.0, 10.0);
                if (VectorDistance(feetVec, realPos1) < VectorDistance(feetVec, realPos2))
                {
                    realPos = realPos1;
                }
                else
                {
                    realPos = realPos2;
                }
                if (VectorDistance(feetVec, fakePos1) < VectorDistance(feetVec, fakePos2))
                {
                    fakePos = fakePos1;
                }
                else
                {
                    fakePos = fakePos2;
                }
            }
            else
            {
                closestRayPoint = headVec;
                realPos = ExtendVector(bodyVec, realAngle, 10.0);
                fakePos = ExtendVector(bodyVec, fakeAngle, 10.0);
            }

            if (VectorDistance(closestRayPoint, fakePos) < VectorDistance(closestRayPoint, realPos))
            {
                lastHitTime = curtime;
                anti_brute += 1
            }
        }

        lastImpacts[entity] = impact;
        lastImpactTimes[entity] = curtime;
    }
}
Cheat.RegisterCallback('bullet_impact', 'OnBulletImpact');

function OnHurt()
{
    if (GetScriptOption("Anti Bruteforce") == 0) return;
    if (Entity.GetEntityFromUserID(Event.GetInt("userid")) !== Entity.GetLocalPlayer()) return;
    var hitbox = Event.GetInt('hitgroup');

    if (hitbox == 1 || hitbox == 6 || hitbox == 7)
    {
        var curtime = Globals.Curtime();
        if (Math.abs(lastHitTime - curtime) > 0.5) 
        {
            lastHitTime = curtime;
            anti_brute += 1;
        }
    }
}

Cheat.RegisterCallback("player_hurt", "OnHurt");

const antiaim_stages = ['stand', 'air', 'run', 'crouch', 'fakeduck', 'slowwalk']
const antiaim_struct = {
    stand: {
        override_desync_limit:  ui.get('[1] override desync limit'),
        right_yaw:              ui.get('[1] right yaw'),
        left_yaw:               ui.get('[1] left yaw'),
        yaw_modifier:           ui.get('[1] yaw modifier'),
        yaw_modifier_amount:    ui.get('[1] yaw modifier amount'),
        fake_limit_type:        ui.get('[1] fake limit type'),
        right_limit:            ui.get('[1] right limit'),
        left_limit:             ui.get('[1] left limit'),
        jitter_side:            ui.get('[1] jitter side')
    },
    air: {
        override_desync_limit:  ui.get('[2] override desync limit'),
        right_yaw:              ui.get('[2] right yaw'),
        left_yaw:               ui.get('[2] left yaw'),
        yaw_modifier:           ui.get('[2] yaw modifier'),
        yaw_modifier_amount:    ui.get('[2] yaw modifier amount'),
        fake_limit_type:        ui.get('[2] fake limit type'),
        right_limit:            ui.get('[2] right limit'),
        left_limit:             ui.get('[2] left limit'),
        jitter_side:            ui.get('[2] jitter side')
    },
    run: {
        override_desync_limit:  ui.get('[3] override desync limit'),
        right_yaw:              ui.get('[3] right yaw'),
        left_yaw:               ui.get('[3] left yaw'),
        yaw_modifier:           ui.get('[3] yaw modifier'),
        yaw_modifier_amount:    ui.get('[3] yaw modifier amount'),
        fake_limit_type:        ui.get('[3] fake limit type'),
        right_limit:            ui.get('[3] right limit'),
        left_limit:             ui.get('[3] left limit'),
        jitter_side:            ui.get('[3] jitter side')
    },
    crouch: {
        override_desync_limit:  ui.get('[4] override desync limit'),
        right_yaw:              ui.get('[4] right yaw'),
        left_yaw:               ui.get('[4] left yaw'),
        yaw_modifier:           ui.get('[4] yaw modifier'),
        yaw_modifier_amount:    ui.get('[4] yaw modifier amount'),
        fake_limit_type:        ui.get('[4] fake limit type'),
        right_limit:            ui.get('[4] right limit'),
        left_limit:             ui.get('[4] left limit'),
        jitter_side:            ui.get('[4] jitter side')
    },
    fakeduck: {
        override_desync_limit:  ui.get('[5] override desync limit'),
        right_yaw:              ui.get('[5] right yaw'),
        left_yaw:               ui.get('[5] left yaw'),
        yaw_modifier:           ui.get('[5] yaw modifier'),
        yaw_modifier_amount:    ui.get('[5] yaw modifier amount'),
        fake_limit_type:        ui.get('[5] fake limit type'),
        right_limit:            ui.get('[5] right limit'),
        left_limit:             ui.get('[5] left limit'),
        jitter_side:            ui.get('[5] jitter side')
    },
    slowwalk: {
        override_desync_limit:  ui.get('[6] override desync limit'),
        right_yaw:              ui.get('[6] right yaw'),
        left_yaw:               ui.get('[6] left yaw'),
        yaw_modifier:           ui.get('[6] yaw modifier'),
        yaw_modifier_amount:    ui.get('[6] yaw modifier amount'),
        fake_limit_type:        ui.get('[6] fake limit type'),
        right_limit:            ui.get('[6] right limit'),
        left_limit:             ui.get('[6] left limit'),
        jitter_side:            ui.get('[6] jitter side')
    }
}

function tick_clock(reset_time){
    if(Globals.Tickcount() % reset_time == 0) return true;
    return false;
}

function anti_aim(){
    UI.SetValue('Misc', 'GENERAL', 'Movement', 'Turn speed', 300)
    const local = Entity.GetLocalPlayer()
    const my_velocity = player.velocity(local)
    const ui_value = UI.GetValue(ui.get('anti aim type'))
    const side = UI.IsHotkeyActive('Anti-Aim', 'Fake angles', 'Inverter')
    const curtime = Globals.Curtime();
    if(ui.dropdown(UI.GetValue(ui.get('anti-aim options')), 0)){
        if(anti_brute > UI.GetValue(ui.get('counter'))) anti_brute = 1
        if(lastHitTime + 5 < curtime) anti_brute = 0
        for(i = 0; i < max_antibrute_phases; i++){
            if(anti_brute == 0) continue;
            if(anti_brute == i){
                AntiAim.SetOverride(1)
                AntiAim.SetRealOffset(UI.GetValue(ui.get('[anti-bruteforce] phase ' + (i + 1).toString())))
                return;
            }
        }
    }
    const handle_anti_aim = function(object, override_reset_time){
        if(UI.GetValue(object.override_desync_limit)) AntiAim.SetOverride(1); else AntiAim.SetOverride(0)
        if(override_reset_time == null || override_reset_time == undefined) override_reset_time = 3
        if(UI.GetValue(object.yaw_modifier) != 0){
            if(UI.GetValue(object.yaw_modifier) == 1 || UI.GetValue(object.yaw_modifier) == 2){
                UI.SetValue('Anti-Aim', 'Rage Anti-Aim', 'Jitter offset', UI.GetValue(object.yaw_modifier_amount))
            } else{
                UI.SetValue('Anti-Aim', 'Rage Anti-Aim', 'Jitter offset', Math.sign(UI.GetValue(object.yaw_modifier_amount)) == 1 ? rand(4, UI.GetValue(object.yaw_modifier_amount)): rand(-4, UI.GetValue(object.yaw_modifier_amount)))
            }
        }
        if(UI.GetValue(object.jitter_side) == 0){
            if(!side) {
                UI.SetValue('Anti-Aim', 'Rage Anti-Aim', 'Yaw offset', UI.GetValue(object.left_yaw))
                if(UI.GetValue(object.fake_limit_type) == 1){
                    if(tick_clock(override_reset_time)){
                        AntiAim.SetRealOffset(-UI.GetValue(object.left_limit))
                    } else{
                        AntiAim.SetRealOffset(-8)
                    }
                }else{
                    AntiAim.SetRealOffset(-UI.GetValue(object.left_limit))
                }
            } else {
                UI.SetValue('Anti-Aim', 'Rage Anti-Aim', 'Yaw offset', UI.GetValue(object.right_yaw))
                AntiAim.SetRealOffset(object.right_limit)
                if(UI.GetValue(object.fake_limit_type) == 1){
                    if(tick_clock(override_reset_time)){
                        AntiAim.SetRealOffset(UI.GetValue(object.right_limit))
                    } else{
                        AntiAim.SetRealOffset(8)
                    }
                }else{
                    AntiAim.SetRealOffset(UI.GetValue(object.right_limit))
                }
            }
        }else{
            if(tick_clock(override_reset_time)) {
                UI.SetValue('Anti-Aim', 'Rage Anti-Aim', 'Yaw offset', UI.GetValue(object.left_yaw))
                if(UI.GetValue(object.fake_limit_type) == 1){
                    if(tick_clock(override_reset_time)){
                        AntiAim.SetRealOffset(-UI.GetValue(object.left_limit))
                    } else{
                        AntiAim.SetRealOffset(-8)
                    }
                }else{
                    AntiAim.SetRealOffset(-UI.GetValue(object.left_limit))
                }
            } else {
                UI.SetValue('Anti-Aim', 'Rage Anti-Aim', 'Yaw offset', UI.GetValue(object.right_yaw))
                if(UI.GetValue(object.fake_limit_type) == 1){
                    if(tick_clock(override_reset_time)){
                        AntiAim.SetRealOffset(UI.GetValue(object.right_limit))
                    } else{
                        AntiAim.SetRealOffset(8)
                    }
                }else{
                    AntiAim.SetRealOffset(UI.GetValue(object.right_limit))
                }
            }
        }
    }
    if(ui_value != 0) AntiAim.SetOverride(0);
    if(ui_value == 2){
        if(my_velocity < 2){
            handle_anti_aim(antiaim_struct.stand)
        } else if(player.isair(local)){
            handle_anti_aim(antiaim_struct.air)
        } else if(player.iscrouch(local)){
            handle_anti_aim(antiaim_struct.crouch)
        } else if(UI.IsHotkeyActive('Anti-Aim', 'Extra', 'Fake duck')){
            handle_anti_aim(antiaim_struct.fakeduck)
        } else if(UI.IsHotkeyActive('Anti-Aim', 'Extra', 'Slow walk')){
            handle_anti_aim(antiaim_struct.slowwalk)
        } else if(my_velocity > 2){
            handle_anti_aim(antiaim_struct.run)
        }
    }
    if(ui_value == 1){
        AntiAim.SetOverride(0)
        if(tick_clock(3)){
            UI.SetValue('Anti-Aim', 'Rage Anti-Aim', 'Yaw offset', -67)
            UI.SetValue('Anti-Aim', 'Rage Anti-Aim', 'Jitter offset', 11)
        } else{
            UI.SetValue('Anti-Aim', 'Rage Anti-Aim', 'Yaw offset', 67)
            UI.SetValue('Anti-Aim', 'Rage Anti-Aim', 'Jitter offset', -11)
        }
    }
}

ondraw = function(){
    if(UI.IsMenuOpen()) handle_menu()
}; Cheat.RegisterCallback('Draw', 'ondraw')

oncm = function(){
    legfuck()
    safe_point_limbs()
    targeting()
    hp2()
    air_hitchance()
    noscope()
    anti_aim()
}; Cheat.RegisterCallback('CreateMove', 'oncm')

// math lib

function rand(min, max){
    return Math.floor(Math.random() * (max - min + 1)) + min
}

function radian(degree)
{
    return degree * Math.PI / 180.0;
}

function ExtendVector(vector, angle, extension)
{
    var radianAngle = radian(angle);
    return [extension * Math.cos(radianAngle) + vector[0], extension * Math.sin(radianAngle) + vector[1], vector[2]];
}

function VectorAdd(a, b)
{
    return [a[0] + b[0], a[1] + b[1], a[2] + b[2]];
}

function VectorSubtract(a, b)
{
    return [a[0] - b[0], a[1] - b[1], a[2] - b[2]];
}

function VectorMultiply(a, b)
{
    return [a[0] * b[0], a[1] * b[1], a[2] * b[2]];
}

function VectorLength(x, y, z)
{
    return Math.sqrt(x * x + y * y + z * z);
}

function VectorNormalize(vec)
{
    var length = VectorLength(vec[0], vec[1], vec[2]);
    return [vec[0] / length, vec[1] / length, vec[2] / length];
}

function VectorDot(a, b)
{
    return a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
}

function VectorDistance(a, b)
{
    return VectorLength(a[0] - b[0], a[1] - b[1], a[2] - b[2]);
}

function ClosestPointOnRay(target, rayStart, rayEnd)
{
    var to = VectorSubtract(target, rayStart);
    var dir = VectorSubtract(rayEnd, rayStart);
    var length = VectorLength(dir[0], dir[1], dir[2]);
    dir = VectorNormalize(dir);

    var rangeAlong = VectorDot(dir, to);
    if (rangeAlong < 0.0)
    {
        return rayStart;
    }
    if (rangeAlong > length)
    {
        return rayEnd;
    }
    return VectorAdd(rayStart, VectorMultiply(dir, [rangeAlong, rangeAlong, rangeAlong]));
}

function vector_add(a, b){
    return [a[0] + b[0], a[1] + b[1], a[2] + b[2]]
}

function vector_mul_fl(a, fl){
    return [a[0] * fl, a[1] * fl, a[2] * fl]
}
function vector_lenght(a){
    return Math.sqrt(a[0] * a[0] + a[1] * a[1])
}

function vector_rest(a, b){
    return [a[0] - b[0], a[1] - b[1], a[2] - b[2]]
}