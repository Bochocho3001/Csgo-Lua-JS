local screen_size = engine.get_screen_size()

-- save to the config
local keybind_x = ui.add_slider_int("keybinds_x", "keybinds_x", 0, screen_size.x, screen_size.x / 2 - 300)
local keybind_y = ui.add_slider_int("keybinds_y", "keybinds_y", 0, screen_size.y, screen_size.y / 2 - 200)

keybind_x:set_visible(false)
keybind_y:set_visible(false)

local text_ouline = function (text, font, x, y, size)
    renderer.text(text, font, vec2_t.new(x - 1, y), size, color_t.new(0, 0, 0, 255))
    renderer.text(text, font, vec2_t.new(x + 1, y), size, color_t.new(0, 0, 0, 255))
    renderer.text(text, font, vec2_t.new(x, y - 1), size, color_t.new(0, 0, 0, 255))
    renderer.text(text, font, vec2_t.new(x, y + 1), size, color_t.new(0, 0, 0, 255))
end

local keyBinds = {
    "Exploit",
    "AA Inverter",
    "Thirdperson",
    "Fakeduck",
    "Auto peek",
    "Jump bug",
    "Edge jump",
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
    "Always on",
    "Hold",
    "Toggle",
    "Force disable"
}

local multiCombo = ui.add_multi_combo_box("Key bind options", "lua_multi_combo", keyBinds, {false, false, false, false, false, false, false, false})
local color = ui.add_color_edit("Global color", "lua_color", false, color_t.new(244, 182, 108, 255))

local bindWidth = 128
local bindHeight = 16

function inBind(mousePos)

    if mousePos.x >= keybind_x:get_value() - 16 and mousePos.x <= keybind_x:get_value() + bindWidth + 16 and mousePos.y >= keybind_y:get_value() - 3 - 16 and mousePos.y <= keybind_y:get_value() + bindHeight + 16 then
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

    renderer.rect_filled_fade(vec2_t.new(keybind_x:get_value() + 1, keybind_y:get_value()), vec2_t.new(keybind_x:get_value(), keybind_y:get_value() + bindHeight - 3), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255), color_t.new(64, 64, 64, 255), color_t.new(64, 64, 64, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() + 1, keybind_y:get_value() + bindHeight - 2), vec2_t.new(keybind_x:get_value() + 2, keybind_y:get_value() + bindHeight - 2), color_t.new(64, 64, 64, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() + 1, keybind_y:get_value() + bindHeight - 1), vec2_t.new(keybind_x:get_value() + 2, keybind_y:get_value() + bindHeight - 1), color_t.new(64, 64, 64, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() + 2, keybind_y:get_value() + bindHeight), vec2_t.new(keybind_x:get_value() + 3, keybind_y:get_value() + bindHeight), color_t.new(64, 64, 64, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() + 3, keybind_y:get_value() + bindHeight), vec2_t.new(keybind_x:get_value() + 4, keybind_y:get_value() + bindHeight), color_t.new(64, 64, 64, 255))

    renderer.rect_filled_fade(vec2_t.new(keybind_x:get_value() + 3 + bindWidth, keybind_y:get_value()), vec2_t.new(keybind_x:get_value() + 4 + bindWidth, keybind_y:get_value() + bindHeight - 3), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255), color_t.new(64, 64, 64, 255), color_t.new(64, 64, 64, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() - 2 + bindWidth + 4, keybind_y:get_value() + bindHeight - 2), vec2_t.new(keybind_x:get_value() - 1 + bindWidth + 4, keybind_y:get_value() + bindHeight - 2), color_t.new(64, 64, 64, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() - 2 + bindWidth + 4, keybind_y:get_value() + bindHeight - 1), vec2_t.new(keybind_x:get_value() - 1 + bindWidth + 4, keybind_y:get_value() + bindHeight - 1), color_t.new(64, 64, 64, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() - 3 + bindWidth + 4, keybind_y:get_value() + bindHeight), vec2_t.new(keybind_x:get_value() - 2 + bindWidth + 4, keybind_y:get_value() + bindHeight), color_t.new(64, 64, 64, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() - 4 + bindWidth + 4, keybind_y:get_value() + bindHeight), vec2_t.new(keybind_x:get_value() - 3 + bindWidth + 4, keybind_y:get_value() + bindHeight), color_t.new(64, 64, 64, 255))

    renderer.line(vec2_t.new(keybind_x:get_value() + 4, keybind_y:get_value() + bindHeight), vec2_t.new(keybind_x:get_value() + bindWidth, keybind_y:get_value() + bindHeight), color_t.new(64, 64, 64, 255))

    renderer.rect(vec2_t.new(keybind_x:get_value() + 1, keybind_y:get_value() - 0), vec2_t.new(keybind_x:get_value() + 2, keybind_y:get_value() - 0), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() + 1, keybind_y:get_value() - 1), vec2_t.new(keybind_x:get_value() + 2, keybind_y:get_value() - 1), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() + 2, keybind_y:get_value() - 2), vec2_t.new(keybind_x:get_value() + 3, keybind_y:get_value() - 2), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() + 3, keybind_y:get_value() - 2), vec2_t.new(keybind_x:get_value() + 4, keybind_y:get_value() - 2), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255))

    renderer.rect(vec2_t.new(keybind_x:get_value() - 2 + bindWidth + 4, keybind_y:get_value() - 0), vec2_t.new(keybind_x:get_value() - 1 + bindWidth + 4, keybind_y:get_value() - 0), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() - 2 + bindWidth + 4, keybind_y:get_value() - 1), vec2_t.new(keybind_x:get_value() - 1 + bindWidth + 4, keybind_y:get_value() - 1), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() - 3 + bindWidth + 4, keybind_y:get_value() - 2), vec2_t.new(keybind_x:get_value() - 2 + bindWidth + 4, keybind_y:get_value() - 2), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255))
    renderer.rect(vec2_t.new(keybind_x:get_value() - 4 + bindWidth + 4, keybind_y:get_value() - 2), vec2_t.new(keybind_x:get_value() - 3 + bindWidth + 4, keybind_y:get_value() - 2), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255))

    renderer.line(vec2_t.new(keybind_x:get_value() + 4, keybind_y:get_value() - 4), vec2_t.new(keybind_x:get_value() + bindWidth, keybind_y:get_value() - 4), color_t.new((color:get_value()).r, (color:get_value()).g, (color:get_value()).b, 255))

    local mousePos = renderer.get_cursor_pos()

    if inBind(mousePos) and client.is_key_pressed(1) then
        keybind_x:set_value(mousePos.x - bindWidth / 2)
        keybind_y:set_value(mousePos.y - bindHeight / 2)
    end

    -- out of bounds
    if keybind_x:get_value() < 0 then keybind_x:set_value(0) end
    if keybind_x:get_value() + bindWidth + 4 > screen_size.x then keybind_x:set_value(screen_size.x - bindWidth - 4) end
    if keybind_y:get_value() - 4 < 0 then keybind_y:set_value(4) end
    if keybind_y:get_value() + bindHeight + 4 > screen_size.y then keybind_y:set_value(screen_size.y - bindHeight - 4) end

    text_ouline("keybinds", verdana_font, keybind_x:get_value() + bindWidth / 2 - renderer.get_text_size(verdana_font, veSize, "keybinds").x / 2, keybind_y:get_value() + bindHeight / 2 - renderer.get_text_size(verdana_font, veSize, "keybinds").y / 2 - 1, veSize)
    renderer.text("keybinds", verdana_font, vec2_t.new(keybind_x:get_value() + bindWidth / 2 - renderer.get_text_size(verdana_font, veSize, "keybinds").x / 2, keybind_y:get_value() + bindHeight / 2 - renderer.get_text_size(verdana_font, veSize, "keybinds").y / 2 - 1), veSize, color_t.new(255, 255, 255, 255))

    -- display items

    local item_y_offset = 10

    local item_y = keybind_y:get_value() + 8 + item_y_offset + .0

    for i = 1, #bindVariables do

        if not ui.get_key_bind(bindVariables[i]):is_active() or ui.get_key_bind(bindVariables[i]):get_type() == 0 or not multiCombo:get_value(i - 1) then
            goto continue
        end

        text_ouline(keyBinds[i], smallest_pixel_7, keybind_x:get_value() + 4, item_y, spSize)
        renderer.text(keyBinds[i], smallest_pixel_7, vec2_t.new(keybind_x:get_value() + 4, item_y), spSize, color_t.new(255, 255, 255, 255))

        text_ouline("[" .. bindTypes[ui.get_key_bind(bindVariables[i]):get_type() + 1] .. "]", smallest_pixel_7, keybind_x:get_value() + bindWidth - renderer.get_text_size(smallest_pixel_7, spSize, "[" .. bindTypes[ui.get_key_bind(bindVariables[i]):get_type() + 1] .. "]").x, item_y, spSize)
        renderer.text("[" .. bindTypes[ui.get_key_bind(bindVariables[i]):get_type() + 1] .. "]", smallest_pixel_7, vec2_t.new(keybind_x:get_value() + bindWidth - renderer.get_text_size(smallest_pixel_7, spSize, "[" .. bindTypes[ui.get_key_bind(bindVariables[i]):get_type() + 1] .. "]").x, item_y), spSize, color_t.new(255, 255, 255, 255))

        item_y = item_y + item_y_offset

        ::continue::

    end

end

client.register_callback("paint", on_paint)