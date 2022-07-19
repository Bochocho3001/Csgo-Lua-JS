local screen_size = engine.get_screen_size()

-- save to the config
local keybind_x = ui.add_slider_int("keybinds_x", "keybinds_x", 0, screen_size.x, screen_size.x / 2 - 300)
local keybind_y = ui.add_slider_int("keybinds_y", "keybinds_y", 0, screen_size.y, screen_size.y / 2 - 200)

keybind_x:set_visible(false)
keybind_y:set_visible(false)

local text_ouline = function (text, font, x, y, size, color)

    color = color or color_t.new(0, 0, 0, 255)

    renderer.text(text, font, vec2_t.new(x - 1, y), size, color)
    renderer.text(text, font, vec2_t.new(x + 1, y), size, color)
    renderer.text(text, font, vec2_t.new(x, y - 1), size, color)
    renderer.text(text, font, vec2_t.new(x, y + 1), size, color)
end

local keyBinds = {
    "Exploit",
    "AA Inverter",
    "Thirdperson",
    "Duck Peek Assist",
    "Quick Peek Assist",
    "Jump bug",
    "Jump at edge",
    "Legit Auto fire"
}

local bindVariables = {
    "rage_active_exploit_bind",
    "antihit_antiaim_flip_bind",
    "visuals_other_thirdperson_bind",
    "antihit_extra_fakeduck_bind",
    "antihit_extra_autopeek_bind",
    "misc_jump_bug_bind",
    "misc_edge_jump_bind",
    "legit_autofire_bind"
}

local bindTypes = {
    "always on",
    "holding",
    "toggled",
    "force disable"
}

local multiCombo = ui.add_multi_combo_box("Key bind options", "lua_multi_combo", keyBinds, {false, false, false, false, false, false, false, false})
local color = ui.add_color_edit("Global color", "lua_color", false, color_t.new(244, 182, 108, 255))

local width = 120
local bindHeight = 16

function inBind(mousePos)

    if mousePos.x >= keybind_x:get_value() - 16 and mousePos.x <= keybind_x:get_value() + width + 16 and mousePos.y >= keybind_y:get_value() - 3 - 16 and mousePos.y <= keybind_y:get_value() + bindHeight + 16 then
        return true
    end

end

local spSize = 12
local veSize = 12

local smallest_pixel_7 = renderer.setup_font("C:/Windows/Fonts/SMALLEST_PIXEL-7.ttf", spSize, 144)
local verdana_font = renderer.setup_font("C:/Windows/Fonts/verdana.ttf", veSize, 144)

function lerp(startP, endP, t)
    return startP + (endP-startP) * t
end

-- animations class
local animations = (function()

    local store = {data = {}}

    function store:clamp(val, min, max)
        return math.min(max, math.max(min, val))
    end

    function store:animate(name, side, multiplier)

        if not self.data[name] then self.data[name] = 0 end

        multiplier = multiplier or 4

        local val = globalvars.get_frame_time() * multiplier * (side and -1 or 1)

        self.data[name] = self:clamp(self.data[name] + val, 0, 1)

        return self.data[name]
 
    end

    return store

end)()

local anim_width = width

function on_paint()

--[[

    useful renderer functions:

    renderer.text(text, font, pos, size, color)
    renderer.get_text_size(font, size, text)
    renderer.line(from, to, color)
    renderer.rect / rect_filled (from, to, color)
    renderer.rect_filled_fade(from, to, col_upr_left, col_upr_right, col_bot_right, col_bot_left)
    renderer.get_cursor_pos()

]]

    if not entitylist.get_local_player() then
        return
    end

    renderer.rect_filled_fade(vec2_t.new(keybind_x:get_value() + 1, keybind_y:get_value()), vec2_t.new(keybind_x:get_value(), keybind_y:get_value() + bindHeight - 3), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255), color_t.new(64, 64, 64, 255), color_t.new(64, 64, 64, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() + 1, keybind_y:get_value() + bindHeight - 2), vec2_t.new(keybind_x:get_value() + 2, keybind_y:get_value() + bindHeight - 2), color_t.new(64, 64, 64, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() + 1, keybind_y:get_value() + bindHeight - 1), vec2_t.new(keybind_x:get_value() + 2, keybind_y:get_value() + bindHeight - 1), color_t.new(64, 64, 64, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() + 2, keybind_y:get_value() + bindHeight), vec2_t.new(keybind_x:get_value() + 3, keybind_y:get_value() + bindHeight), color_t.new(64, 64, 64, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() + 3, keybind_y:get_value() + bindHeight), vec2_t.new(keybind_x:get_value() + 4, keybind_y:get_value() + bindHeight), color_t.new(64, 64, 64, 255))

    renderer.rect_filled_fade(vec2_t.new(keybind_x:get_value() + 3 + width, keybind_y:get_value()), vec2_t.new(keybind_x:get_value() + 4 + width, keybind_y:get_value() + bindHeight - 3), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255), color_t.new(64, 64, 64, 255), color_t.new(64, 64, 64, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() - 2 + width + 4, keybind_y:get_value() + bindHeight - 2), vec2_t.new(keybind_x:get_value() - 1 + width + 4, keybind_y:get_value() + bindHeight - 2), color_t.new(64, 64, 64, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() - 2 + width + 4, keybind_y:get_value() + bindHeight - 1), vec2_t.new(keybind_x:get_value() - 1 + width + 4, keybind_y:get_value() + bindHeight - 1), color_t.new(64, 64, 64, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() - 3 + width + 4, keybind_y:get_value() + bindHeight), vec2_t.new(keybind_x:get_value() - 2 + width + 4, keybind_y:get_value() + bindHeight), color_t.new(64, 64, 64, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() - 4 + width + 4, keybind_y:get_value() + bindHeight), vec2_t.new(keybind_x:get_value() - 3 + width + 4, keybind_y:get_value() + bindHeight), color_t.new(64, 64, 64, 255))

    renderer.line(vec2_t.new(keybind_x:get_value() + 4, keybind_y:get_value() + bindHeight), vec2_t.new(keybind_x:get_value() + width, keybind_y:get_value() + bindHeight), color_t.new(64, 64, 64, 255))

    renderer.rect(vec2_t.new(keybind_x:get_value() + 1, keybind_y:get_value() - 0), vec2_t.new(keybind_x:get_value() + 2, keybind_y:get_value() - 0), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() + 1, keybind_y:get_value() - 1), vec2_t.new(keybind_x:get_value() + 2, keybind_y:get_value() - 1), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() + 2, keybind_y:get_value() - 2), vec2_t.new(keybind_x:get_value() + 3, keybind_y:get_value() - 2), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() + 3, keybind_y:get_value() - 2), vec2_t.new(keybind_x:get_value() + 4, keybind_y:get_value() - 2), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255))

    renderer.rect(vec2_t.new(keybind_x:get_value() - 2 + width + 4, keybind_y:get_value() - 0), vec2_t.new(keybind_x:get_value() - 1 + width + 4, keybind_y:get_value() - 0), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() - 2 + width + 4, keybind_y:get_value() - 1), vec2_t.new(keybind_x:get_value() - 1 + width + 4, keybind_y:get_value() - 1), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() - 3 + width + 4, keybind_y:get_value() - 2), vec2_t.new(keybind_x:get_value() - 2 + width + 4, keybind_y:get_value() - 2), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() - 4 + width + 4, keybind_y:get_value() - 2), vec2_t.new(keybind_x:get_value() - 3 + width + 4, keybind_y:get_value() - 2), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255))

    renderer.line(vec2_t.new(keybind_x:get_value() + 4, keybind_y:get_value() - 4), vec2_t.new(keybind_x:get_value() + width, keybind_y:get_value() - 4), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255))

    local mousePos = renderer.get_cursor_pos()

    if inBind(mousePos) and client.is_key_pressed(1) and ui.is_visible() then
        keybind_x:set_value(mousePos.x - width / 2)
        keybind_y:set_value(mousePos.y - bindHeight / 2)
    end

    -- out of bounds check
    if keybind_x:get_value() < 0 then keybind_x:set_value(0) end
    if keybind_x:get_value() + width + 4 > screen_size.x then keybind_x:set_value(screen_size.x - width - 4) end
    if keybind_y:get_value() - 4 < 0 then keybind_y:set_value(4) end
    if keybind_y:get_value() + bindHeight + 4 > screen_size.y then keybind_y:set_value(screen_size.y - bindHeight - 4) end

    text_ouline("keybinds", verdana_font, keybind_x:get_value() + width / 2 - renderer.get_text_size(verdana_font, veSize, "keybinds").x / 2, keybind_y:get_value() + bindHeight / 2 - renderer.get_text_size(verdana_font, veSize, "keybinds").y / 2 - 1, veSize)
    renderer.text("keybinds", verdana_font, vec2_t.new(keybind_x:get_value() + width / 2 - renderer.get_text_size(verdana_font, veSize, "keybinds").x / 2, keybind_y:get_value() + bindHeight / 2 - renderer.get_text_size(verdana_font, veSize, "keybinds").y / 2 - 1), veSize, color_t.new(255, 255, 255, 255))

    -- display items

    local item_y_offset = 12

    local item_y = keybind_y:get_value() + 6 + item_y_offset + .0

    local max_width = 0

    if ui.get_combo_box("rage_active_exploit"):get_value() == 2 then
        keyBinds[1] = "Double Tap"
    elseif ui.get_combo_box("rage_active_exploit"):get_value() == 1 then
        keyBinds[1] = "On shot anti-aim"
    else
        keyBinds[1] = "Exploit"
    end

    for i = 1, #bindVariables do

        if ui.get_key_bind(bindVariables[i]):get_type() == 0 then
            goto skip
        end

        local alpha = animations:animate("bind_" .. bindVariables[i], not (ui.get_key_bind(bindVariables[i]):is_active() and multiCombo:get_value(i - 1))) * 255

        local bind_state_width = renderer.get_text_size(verdana_font, spSize, "[" .. bindTypes[ui.get_key_bind(bindVariables[i]):get_type() + 1] .. "]")
        local bind_name_width = renderer.get_text_size(verdana_font, spSize, keyBinds[i])

        text_ouline(keyBinds[i], verdana_font, keybind_x:get_value() + 4, item_y, spSize, color_t.new(0, 0, 0, alpha))
        renderer.text(keyBinds[i], verdana_font, vec2_t.new(keybind_x:get_value() + 4, item_y), spSize, color_t.new(255, 255, 255, alpha))

        text_ouline("[" .. bindTypes[ui.get_key_bind(bindVariables[i]):get_type() + 1] .. "]", verdana_font, keybind_x:get_value() + width - bind_state_width.x, item_y, spSize, color_t.new(0, 0, 0, alpha))
        renderer.text("[" .. bindTypes[ui.get_key_bind(bindVariables[i]):get_type() + 1] .. "]", verdana_font, vec2_t.new(keybind_x:get_value() + width - bind_state_width.x, item_y), spSize, color_t.new(255, 255, 255, alpha))

        if multiCombo:get_value(i - 1) and alpha ~= 0 then
            item_y = item_y + item_y_offset
        end

        if not ui.get_key_bind(bindVariables[i]):is_active() then
            goto skip
        end

        local bind_width = bind_name_width.x + bind_state_width.x + 10
        
        if bind_width > 60 then
            if bind_width > max_width then
                max_width = bind_width
            end
        end

        ::skip::

    end

    width = math.max(120, max_width)

    if anim_width < width then
        anim_width = anim_width + 2
    elseif anim_width > width then
        anim_width = anim_width - 2
    end

    width = anim_width

end

client.register_callback("paint", on_paint)
