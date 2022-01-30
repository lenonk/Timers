--[[
* timers - Copyright (c) 2022 The Mystic
*
* This file is part of Timers for Ashita.
*
* Timers is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Timers is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with Timers.  If not, see <https://www.gnu.org/licenses/>.
--]]

require('common')

local helpers = require('helpers')
local imgui = require('imgui')

local gHeaderColor = { 1.0, 0.75, 0.55, 1.0 }

local ui = T{
    is_open = { false, },
}

ui.render_panel_tab = function(settings)
    -- Panel Settings
    imgui.TextColored(gHeaderColor, 'Panel Settings')
    imgui.BeginChild('panel_options', { 0, 233 }, true);
        if imgui.Checkbox('Enabled?', { settings.timers.settings.enabled }) then
            settings.timers.settings.enabled = not settings.timers.settings.enabled
        end
        imgui.ShowHelp('Toggle visibility of panel.')
        imgui.SameLine()
        imgui.Dummy({10, 1})
        imgui.SameLine()
        if imgui.Checkbox('Locked?', { settings.settings.locked }) then
            settings.settings.locked = not settings.settings.locked
        end
        imgui.ShowHelp('Prevent panel from being dragged with Shift+LMouse.')

        local height = T{ settings.timers.settings.max_height }
        imgui.SliderInt('\xef\x95\x88 Height', height, 20, 1000, '%dpx');
        imgui.ShowHelp('Maximum panel height.', true);
        settings.timers.settings.max_height = height[1]

        -- Background
        imgui.TextColored(gHeaderColor, 'Background')
        imgui.BeginChild('background_options', { 0, 149 }, true);
            if imgui.Checkbox('Visible?', { settings.timers.settings.enable_background }) then
                settings.timers.settings.enable_background = not settings.timers.settings.enable_background
            end
            imgui.ShowHelp('Toggle visibility of panel background.')
            
            local c = helpers.color_u32_to_v4(settings.timers.bg.color);
            if (imgui.ColorEdit4('\xef\x94\xbf Color', c)) then
                settings.timers.bg.color = helpers.color_v4_to_u32(c);
            end
            imgui.ShowHelp('Panel background color.', true);

            imgui.Dummy({1, 1})
            imgui.Separator()
            imgui.Dummy({1, 1})

            -- Background Border
            if imgui.Checkbox('Border Visible?', { settings.timers.bg.border_visible }) then
                settings.timers.bg.border_visible = not settings.timers.bg.border_visible
            end
            imgui.ShowHelp('Toggle visibility of panel background border.')
            
            c = helpers.color_u32_to_v4(settings.timers.bg.border_color);
            if (imgui.ColorEdit4('\xef\x94\xbf Border Color', c)) then
                settings.timers.bg.border_color = helpers.color_v4_to_u32(c);
            end
            imgui.ShowHelp('Panel background border color.', true);

            local size = T{ string.sub(settings.timers.settings.background.border_sizes, 1, 1):num() }
            imgui.SliderInt('\xef\x95\x87 Border Size', size, 1, 10, '%dpx');
            settings.timers.settings.background.border_sizes = ('%d,%d,%d,%d'):fmt(size[1], size[1], size[1], size[1])
            settings.timers.bg.border_sizes = settings.timers.settings.background.border_sizes
            imgui.ShowHelp('Border size in pixels.', true);
        imgui.EndChild();
    imgui.EndChild();
end

ui.render_timer_tab = function(settings)
    -- Timer Settings
    imgui.TextColored(gHeaderColor, 'Timer Settings')
    imgui.BeginChild('timer_options', { 0, 441 }, true);
        if imgui.Checkbox('AoE Timers?', { settings.settings.party_buffs }) then
            settings.settings.party_buffs = not settings.settings.party_buffs
        end
        imgui.ShowHelp('Toggle timer bars for party members affected by AoE spells. Trusts are excluded for technical reasons.')

        local width = T{ settings.timers.settings.bar_width }
        imgui.SliderInt('\xef\x95\x87 Width', width, 100, 1000, '%dpx');
        imgui.ShowHelp('Width of individual timer bars.', true);
        settings.timers.settings.bar_width = width[1]

        local height = T{ settings.timers.settings.bar_height }
        imgui.SliderInt('\xef\x95\x88 Height', height, 1, 50, '%dpx');
        settings.timers.settings.bar_height = height[1]
        imgui.ShowHelp('Height of individual timer bars.', true);

        -- Timer padding
        imgui.TextColored(gHeaderColor, 'Padding')
        local left = { settings.timers.settings.padding[1] }
        imgui.SliderInt('\xef\x95\x87 Left', left, 0, 50, '%dpx');
        settings.timers.settings.padding[1] = left[1]
        imgui.ShowHelp('Left padding.', true);
        
        local top = { settings.timers.settings.padding[2] }
        imgui.SliderInt('\xef\x95\x88 Top', top, 0, 50, '%dpx');
        settings.timers.settings.padding[2] = top[1]
        imgui.ShowHelp('Top padding.', true);

        local right = { settings.timers.settings.padding[3] }
        imgui.SliderInt('\xef\x95\x87 Right', right, 0, 50, '%dpx');
        settings.timers.settings.padding[3] = right[1]
        imgui.ShowHelp('Right padding.', true);

        local bottom = { settings.timers.settings.padding[4] }
        imgui.SliderInt('\xef\x95\x88 Bottom', bottom, 0, 50, '%dpx');
        settings.timers.settings.padding[4] = bottom[1]
        imgui.ShowHelp('Bottom padding.', true);

        -- Thresholds
        imgui.TextColored(gHeaderColor, 'Thresholds');
        imgui.BeginChild('conf_timer_threshold', { 0, 87 }, true)
            imgui.PushID('T#1');
            local t = T{ settings.timers.settings.thresholds.t75 }
            imgui.InputInt(' ', t);
            settings.timers.settings.thresholds.t75 = t[1]
            imgui.PopID();
            imgui.SameLine();
            imgui.TextColored(helpers.color_u32_to_v4(settings.timers.settings.colors.color75), '\xef\x80\x97 T1');
            imgui.ShowHelp('Threshold in seconds remaining.', true);

            imgui.PushID('T#2');
            t = T{ settings.timers.settings.thresholds.t50 }
            imgui.InputInt(' ', t);
            settings.timers.settings.thresholds.t50 = t[1]
            imgui.PopID();
            imgui.SameLine();
            imgui.TextColored(helpers.color_u32_to_v4(settings.timers.settings.colors.color50), '\xef\x80\x97 T2');
            imgui.ShowHelp('Threshold in seconds remaining.', true);

            imgui.PushID('T#3');
            t = T{ settings.timers.settings.thresholds.t25 }
            imgui.InputInt(' ', t);
            settings.timers.settings.thresholds.t25 = t[1]
            imgui.PopID();
            imgui.SameLine();
            imgui.TextColored(helpers.color_u32_to_v4(settings.timers.settings.colors.color25), '\xef\x80\x97 T3');
            imgui.ShowHelp('Threshold in seconds remaining.', true);
        imgui.EndChild();

        imgui.TextColored(gHeaderColor, 'Colors');
        imgui.BeginChild('conf_timer_colors', { 0, 110 }, true)
            local c = helpers.color_u32_to_v4(settings.timers.settings.colors.color100);
            if (imgui.ColorEdit4(('\xef\x80\x97 > T1 (%ds)'):format(settings.timers.settings.thresholds.t75), c)) then
                settings.timers.settings.colors.color100 = helpers.color_v4_to_u32(c);
            end
            imgui.ShowHelp('Bar color with more than T1 seconds remaining.', true);

            c = helpers.color_u32_to_v4(settings.timers.settings.colors.color75);
            if (imgui.ColorEdit4(('\xef\x80\x97 > T2 (%ds)'):format(settings.timers.settings.thresholds.t50), c)) then
                settings.timers.settings.colors.color75 = helpers.color_v4_to_u32(c);
            end
            imgui.ShowHelp('Bar color with more than T2 seconds remaining.', true);

            c = helpers.color_u32_to_v4(settings.timers.settings.colors.color50);
            if (imgui.ColorEdit4(('\xef\x80\x97 > T3 (%ds)'):format(settings.timers.settings.thresholds.t25), c)) then
                settings.timers.settings.colors.color50 = helpers.color_v4_to_u32(c);
            end
            imgui.ShowHelp('Bar color with more than T3 seconds remaining.', true);

            c = helpers.color_u32_to_v4(settings.timers.settings.colors.color25);
            if (imgui.ColorEdit4(('\xef\x80\x97 < T3 (%ds)'):format(settings.timers.settings.thresholds.t25), c)) then
                settings.timers.settings.colors.color25 = helpers.color_v4_to_u32(c);
            end
            imgui.ShowHelp('Bar color with less than T3 seconds remaining.', true);
        imgui.EndChild();
    imgui.EndChild();
end

ui.render_font_tab = function(settings)
    -- Font Settings
    imgui.TextColored(gHeaderColor, 'Font Settings');
    imgui.BeginChild('conf_font', { 0, 322 }, true);
        if imgui.Checkbox('Background Visible?', { settings.timers.settings.font_bg_visible }) then
            settings.timers.settings.font_bg_visible = not settings.timers.settings.font_bg_visible
        end
        imgui.ShowHelp('Toggle visibility of the font background.')

        local ffamily = T{ settings.timers.settings.font_family }
        imgui.InputText('\xef\x80\xb1 Font Family', ffamily, 255)
        settings.timers.settings.font_family = table.concat(ffamily)

        local size = T{ settings.timers.settings.font_height }
        imgui.SliderInt('\xef\x95\x88 Font Size', size, 1, 20, '%dpx');
        settings.timers.settings.font_height = size[1]
        imgui.ShowHelp('Font size for timer bars.', true);

        local c = helpers.color_u32_to_v4(settings.timers.settings.font_fg_color);
        if (imgui.ColorEdit4('\xef\x94\xbf Color', c)) then
            settings.timers.settings.font_fg_color = helpers.color_v4_to_u32(c);
        end
        imgui.ShowHelp('Timer font foreground color.', true);

        c = helpers.color_u32_to_v4(settings.timers.settings.font_outline_color);
        if (imgui.ColorEdit4('\xef\x94\xbf Outline Color', c)) then
            settings.timers.settings.font_outline_color = helpers.color_v4_to_u32(c);
        end
        imgui.ShowHelp('Timer font outline color.', true);

        c = helpers.color_u32_to_v4(settings.timers.settings.font_bg_color);
        if (imgui.ColorEdit4('\xef\x94\xbf Background', c)) then
            settings.timers.settings.font_bg_color = helpers.color_v4_to_u32(c);
        end
        imgui.ShowHelp('Timer font background color.', true);

        imgui.TextColored(gHeaderColor, 'Title Font');
        imgui.BeginChild('conf_title_font', { 0, 60 }, true);
            local size = T{ settings.timers.settings.name_font_offset_x }
            imgui.SliderInt('\xef\x95\x87 X Offset', size, -250, 250, '%dpx');
            settings.timers.settings.name_font_offset_x = size[1]
            imgui.ShowHelp('Title X offset.', true);

            size = T{ settings.timers.settings.name_font_offset_y }
            imgui.SliderInt('\xef\x95\x88 Y Offset', size, -250, 250, '%dpx');
            settings.timers.settings.name_font_offset_y = size[1]
            imgui.ShowHelp('Title Y offset.', true);
        imgui.EndChild()

        imgui.TextColored(gHeaderColor, 'Timer Font');
        imgui.BeginChild('conf_timer_font', { 0, 60 }, true);
            local size = T{ settings.timers.settings.timer_font_offset_x }
            imgui.SliderInt('\xef\x95\x87 X Offset', size, -250, 250, '%dpx');
            settings.timers.settings.timer_font_offset_x = size[1]
            imgui.ShowHelp('Timer X offset.', true);

            size = T{ settings.timers.settings.timer_font_offset_y }
            imgui.SliderInt('\xef\x95\x88 Y Offset', size, -250, 250, '%dpx');
            settings.timers.settings.timer_font_offset_y = size[1]
            imgui.ShowHelp('Timer Y offset.', true);
        imgui.EndChild()
    imgui.EndChild();
end

ui.render_icon_tab = function(settings)
    -- Icon Settings
    imgui.TextColored(gHeaderColor, 'Icon Settings');
    imgui.BeginChild('conf_icon', { 0, 110 }, true);
        if imgui.Checkbox('Enabled?', { settings.timers.settings.enable_icons }) then
            settings.timers.settings.enable_icons = not settings.timers.settings.enable_icons
        end
        imgui.ShowHelp('Toggles icon visibility.')

        local scale = T{ settings.timers.settings.icon_scale }
        imgui.SliderFloat('\xef\x95\x86 Scale', scale, 0.1, 1.0, '%.3f');
        settings.timers.settings.icon_scale = scale[1]
        imgui.ShowHelp('Icon scale.', true);

        local x = T{ settings.timers.settings.icon_offset_x }
        imgui.SliderInt('\xef\x95\x87 X Offset', x, -50, 50, '%dpx');
        settings.timers.settings.icon_offset_x = x[1]
        imgui.ShowHelp('Icon X offset.', true);

        local y = T{ settings.timers.settings.icon_offset_y }
        imgui.SliderInt('\xef\x95\x88 Y Offset', y, -50, 50, '%dpx');
        settings.timers.settings.icon_offset_y = y[1]
        imgui.ShowHelp('Icon Y offset.', true);
    imgui.EndChild();
end

ui.render_main_tab = function(settings, name)
    imgui.BeginGroup()
        if imgui.BeginTabBar('##timers_tabbar' .. name, ImGuiTabBarFlags_NoCloseWIthMiddleMouseButton) then
            if imgui.BeginTabItem('Panel', nil) then
                ui.render_panel_tab(settings)
                imgui.EndTabItem()
            end
            if imgui.BeginTabItem('Timers', nil) then
                ui.render_timer_tab(settings)
                imgui.EndTabItem()
            end
            if imgui.BeginTabItem('Fonts', nil) then
                ui.render_font_tab(settings)
                imgui.EndTabItem()
            end
            if imgui.BeginTabItem('Icons', nil) then
                ui.render_icon_tab(settings)
                imgui.EndTabItem()
            end
            imgui.EndTabBar()
        end
        imgui.TextDisabled(('\xef\x87\xb9 2022 by %s - %s'):fmt(addon.author, addon.link));
    imgui.EndGroup()

    settings.timers:update_settings()
end

ui.render_config_ui = function(settings)
    if (not ui.is_open[1]) then return end

    if imgui.Begin(('Timers v%s'):fmt(addon.version), ui.is_open, ImGuiWindowFlags_AlwaysAutoResize) then
        if imgui.BeginTabBar('##timers_tabbar', ImGuiTabBarFlags_NoCloseWIthMiddleMouseButton) then
            if imgui.BeginTabItem('Recasts', nil) then
                ui.render_main_tab(settings.recasts, 'recasts')
                imgui.EndTabItem()
            end
            if imgui.BeginTabItem('Durations', nil) then
                ui.render_main_tab(settings.buffs, 'durations')
                imgui.EndTabItem()
            end
            if imgui.BeginTabItem('Debuffs', nil) then
                ui.render_main_tab(settings.debuffs, 'debuffs')
                imgui.EndTabItem()
            end
            imgui.EndTabBar()
        end
    end
    imgui.End()
end

return ui