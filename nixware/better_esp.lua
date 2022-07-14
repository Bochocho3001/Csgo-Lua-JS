local text_size = 10

local smallest_pixel_7 = renderer.setup_font("c:/windows/fonts/smallest_pixel-7.ttf", text_size, 0)

function render_outline(sText, font, x, y,  iSize)
    renderer.text(sText, font, vec2_t.new(x - 1, y - 1), iSize, color_t.new(0, 0, 0, 255))
    renderer.text(sText, font, vec2_t.new(x + 1, y + 1), iSize, color_t.new(0, 0, 0, 255))
    renderer.text(sText, font, vec2_t.new(x - 1, y), iSize, color_t.new(0, 0, 0, 255))
    renderer.text(sText, font, vec2_t.new(x,  y + 1), iSize,color_t.new(0, 0, 0, 255))
    renderer.text(sText, font, vec2_t.new(x, y - 1), iSize, color_t.new(0, 0, 0, 255))
    renderer.text(sText, font, vec2_t.new(x + 1, y), iSize, color_t.new(0, 0, 0, 255))
end

function esp_debug()

    local enemies = entitylist.get_players(0)

    if enemies == nil then
        return
    end

    local y = 400

    for i = 1, #enemies do

        if enemies[i] == nil or enemies[i]:is_dormant() or not enemies[i]:is_alive() then
            goto continue
        end

        local bbox = enemies[i]:get_bbox()

        local pId = enemies[i]:get_index()

        local pInfo = engine.get_player_info(pId)

        -- name start

        local pName = pInfo.name

        render_outline(pName, smallest_pixel_7, (bbox.left + bbox.right) / 2 - renderer.get_text_size(smallest_pixel_7, text_size, pName).x / 2, bbox.top - renderer.get_text_size(smallest_pixel_7, text_size, pName).y, text_size)

        renderer.text(pName, smallest_pixel_7, vec2_t.new((bbox.left + bbox.right) / 2 - renderer.get_text_size(smallest_pixel_7, text_size, pName).x / 2, bbox.top - renderer.get_text_size(smallest_pixel_7, text_size, pName).y), text_size, color_t.new(255, 255, 255, 255))

        -- name end

        -- health start

        local pHealth = enemies[i]:get_prop_int(256) --0x100

        local healthWidth = bbox.left
        local healthx = bbox.left - 1
        local healthHeight = bbox.top
        local healthy = bbox.bottom

        local hStartPos = vec2_t.new(healthx, healthHeight)
        local hEndPos = vec2_t.new(healthWidth, healthy)

        renderer.rect_filled(vec2_t.new(healthx, healthHeight + 1), vec2_t.new(healthWidth - 1, healthy), color_t.new(0, 0, 0, 255))
        renderer.rect_filled(vec2_t.new(healthx, healthHeight - 1), vec2_t.new(healthWidth + 1, healthy), color_t.new(0, 0, 0, 255))
        renderer.rect_filled(vec2_t.new(healthx + 1, healthHeight), vec2_t.new(healthWidth - 1, healthy), color_t.new(0, 0, 0, 255))
        renderer.rect_filled(vec2_t.new(healthx - 1, healthHeight), vec2_t.new(healthWidth + 1, healthy), color_t.new(0, 0, 0, 255))
        renderer.rect_filled(vec2_t.new(healthx, bbox.bottom - pHealth / 100 * (bbox.bottom - bbox.top)), hEndPos, color_t.new(20, 200, 20, 255))

        render_outline(tostring(pHealth), smallest_pixel_7, healthx - renderer.get_text_size(smallest_pixel_7, text_size, tostring(pHealth)).x - 2 , bbox.top - 2, text_size)

        renderer.text(tostring(pHealth), smallest_pixel_7, vec2_t.new(healthx - renderer.get_text_size(smallest_pixel_7, text_size, tostring(pHealth)).x - 2 , bbox.top - 2), text_size, color_t.new(255, 255, 255, 255))

        --health end

        ::continue::

    end
    
end

function hook_draw()
    esp_debug()
end

client.register_callback("paint", hook_draw)
