-- Get screen size
local screen_size = engine.get_screen_size()

-- Save x and y on the config file
local keybind_x = ui.add_slider_float("keybinds_x", "keybinds_x", 0, screen_size.x, screen_size.x / 2 - 300)
local keybind_y = ui.add_slider_float("keybinds_y", "keybinds_y", 0, screen_size.y, screen_size.y / 2 - 200)

local line_color = ui.add_color_edit("keybinds_line_color", "keybinds_line_color", true, color_t.new(255, 255, 255, 255))


--[[
    Freetype font flags:
    -- By default, hinting is enabled and the font's native hinter is preferred over the auto-hinter.
        NoHinting = 1 -- Disable hinting. This generally generates 'blurrier' bitmap glyphs when the glyph are rendered in any of the anti-aliased modes.
        NoAutoHint = 2 -- Disable auto-hinter.
        ForceAutoHint = 4 -- Indicates that the auto-hinter is preferred over the font's native hinter.
        LightHinting = 8 -- A lighter hinting algorithm for gray-level modes. Many generated glyphs are fuzzier but better resemble their m_original shape. This is achieved by snapping glyphs to the pixel grid only vertically (Y-axis), as is done by Microsoft's ClearType and Adobe's proprietary font renderer. This preserves inter-glyph spacing in horizontal text.
        MonoHinting = 16 -- Strong hinting algorithm that should only be used for monochrome output.
        Bold = 32 --  Styling: Should we artificially embolden the font?
        Oblique = 64 -- Styling: Should we slant the font, emulating italic style?
        Monochrome = 128 -- Disable anti-aliasing. Combine this with MonoHinting for best results!
]]
-- Render text with freetype
local function font_freetypes(anti_alliasing, bold, italic)
    local result = 0
    if not anti_aliasing then
        result = result + 128 + 16
    end
    if bold then
        result = result + 32
    end
    if italic then
        result = result + 64
    end
    return result
end

-- Render text outline
local text_ouline = function (text, font, x, y, size)
    renderer.text(text, font, vec2_t.new(x - 1, y), size, color_t.new(0, 0, 0, 255))
    renderer.text(text, font, vec2_t.new(x + 1, y), size, color_t.new(0, 0, 0, 255))
    renderer.text(text, font, vec2_t.new(x, y - 1), size, color_t.new(0, 0, 0, 255))
    renderer.text(text, font, vec2_t.new(x, y + 1), size, color_t.new(0, 0, 0, 255))
end

local smallest_pixel_7 = renderer.setup_font("C:/Windows/Fonts/SMALLEST_PIXEL-7.ttf", 50, font_freetypes(true, false, false)) -- Smallest Pixel 7 font with anti-aliasing and no bold and no italic style (default)
local verdana_font = renderer.setup_font("C:/Windows/Fonts/verdana.ttf", 11, font_freetypes(false, false, false)) -- Verdana font without anti-aliasing and no bold and no italic style (default)

-- Box structure
local box = {
    x = keybind_x:get_value(),
    y = keybind_y:get_value(),
    w = 125,
    h = 17,
    color = {255, 255, 255, 0}
}

-- Keybinds text structure
local keybinds_text = {
    x = box.x + box.w / 2,
    y = box.y + box.h / 2,
    str = "keybinds",
    color = {255, 255, 255, 255},
    font = verdana_font,
    size = 11
}

-- Keybinds line structure
local keybind_line = {
    x = box.x,
    y = box.y,
    color = line_color:get_value()
}

local items = {
    item_names = {
        "Active Exploit",
        "Anti-Aim inverter",
        "Duck peek assist",
        "Quick peek assist",
        "Third person",
        "Jump bug",
        "Edge jump"
    },

    item_paths = {
        "rage_active_exploit_bind",
        "antihit_antiaim_flip_bind",
        "antihit_extra_fakeduck_bind",
        "antihit_extra_autopeek_bind",
        "visuals_other_thirdperson_bind",
        "misc_jump_bug_bind",
        "misc_edge_jump_bind"
    },
}

-- On paint function
function on_paint()

    keybind_x:set_visible(false)
    keybind_y:set_visible(false)

    local mouse_pos = renderer.get_cursor_pos()

    local pressing = client.is_key_pressed(1) -- Left mouse button

    -- If mouse is inside the box and left mouse button is pressed then change its position to the mouse position and save it on the config file
    if mouse_pos.x >= box.x and mouse_pos.x <= box.x + box.w and mouse_pos.y >= box.y and mouse_pos.y <= box.y + box.h and pressing then
        box.x = mouse_pos.x - box.w / 2
        box.y = mouse_pos.y - box.h / 2
        keybind_x:set_value(box.x)
        keybind_y:set_value(box.y)
    else -- If mouse is outside the box and left mouse button is pressed then change its position to the mouse position and save it on the config file
        box.x = keybind_x:get_value()
        box.y = keybind_y:get_value()
    end

    if box.x < 0 then
        box.x = 0
    end
    
    if box.y < 0 then
        box.y = 0
    end

    if box.x + box.w > screen_size.x then
        box.x = screen_size.x - box.w
    end

    if box.y + box.h > screen_size.y then
        box.y = screen_size.y - box.h
    end

    box.x = math.floor(box.x)
    box.y = math.floor(box.y)

    -- Set "Keybinds" x and y at the center of the box
    keybinds_text.x = box.x + box.w / 2 - renderer.get_text_size(keybinds_text.font, keybinds_text.size , keybinds_text.str).x / 2
    keybinds_text.y = box.y + box.h / 2 - renderer.get_text_size(keybinds_text.font, keybinds_text.size , keybinds_text.str).y / 2

    renderer.rect_filled(vec2_t.new(box.x, box.y), vec2_t.new(box.w + box.x, box.h + box.y), color_t.new(20, 20, 20, line_color:get_value().a))

    -- Draw "Keybinds" text outline
    text_ouline(keybinds_text.str, keybinds_text.font, keybinds_text.x, keybinds_text.y, keybinds_text.size)
    -- Draw "Keybinds" text
    renderer.text(keybinds_text.str, keybinds_text.font, vec2_t.new(keybinds_text.x, keybinds_text.y), keybinds_text.size, color_t.new(keybinds_text.color[1], keybinds_text.color[2], keybinds_text.color[3], keybinds_text.color[4]))


    keybind_line.x = box.x
    keybind_line.y = box.y

    renderer.line(vec2_t.new(box.x, box.y), vec2_t.new(box.x + box.w, box.y), color_t.new(line_color:get_value().r, line_color:get_value().g, line_color:get_value().b, 255))

    -- Draw box
    --renderer.rect(vec2_t.new(box.x, box.y), vec2_t.new(box.w + box.x, box.h + box.y), color_t.new(box.color[1], box.color[2], box.color[3], box.color[4]))

    local item_x = box.x + 2
    local item_y = box.y + 17

    for i = 1, 7 do
        local item_name = items.item_names[i]
        local item_path = items.item_paths[i]

        if ui.get_key_bind(item_path):is_active() then

            text_ouline(item_name, verdana_font, item_x, item_y, 11)
            renderer.text(item_name, verdana_font, vec2_t.new(item_x, item_y), 11, color_t.new(255, 255, 255, 255))

            text_ouline("[on]", verdana_font, box.x + box.w - renderer.get_text_size(verdana_font, 11, "[on]").x, item_y, 11)
            renderer.text("[on]", verdana_font, vec2_t.new(box.x + box.w - renderer.get_text_size(verdana_font, 11, "[on]").x , item_y), 11, color_t.new(255, 255, 255, 255))

            item_y = item_y + 11

        end
    end
    
end

client.register_callback("paint", on_paint)
