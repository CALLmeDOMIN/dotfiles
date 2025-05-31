--[[
  SketchyBar Space Configuration:
  - Shows spaces that have windows ( num : apps).
  - Shows the currently active space ( num : apps), even if empty.
  - Hides empty, inactive spaces.
]]

local colors = require("colors")
local icons_config = require("icons") -- Loaded to ensure it's available if needed elsewhere, though not directly used in this script's logic after helpers/app_icons.lua
local settings = require("settings")
local app_icons_helper = require("helpers.app_icons")

-- Configuration
local MAX_SPACES = 10

-- Define new icons for space states
local SPACE_ICON_ACTIVE = ""  -- e.g., FontAwesome U+F192
local SPACE_ICON_OCCUPIED = "" -- e.g., FontAwesome U+F111

-- Define colors
local active_dot_color = colors.blue
local inactive_dot_color = colors.foreground
local active_label_color = colors.white
local inactive_label_color = colors.foreground_alt


-- Remove previously defined items
sbar.log("Spaces: Removing existing space items...")
for i = 1, MAX_SPACES, 1 do
    sbar.remove("space." .. i)
    sbar.remove("space.padding." .. i)
    sbar.remove("space.popup." .. i) -- Explicitly remove named popups
end
sbar.remove("space_window_observer")
sbar.log("Spaces: Removal complete.")

local active_space_id = nil
local space_has_windows = {}
local space_label_app_icons_strings = {}

local spaces_widgets = {}
local space_bracket_widgets = {}
local space_padding_widgets = {}

for i = 1, MAX_SPACES, 1 do
    space_has_windows[i] = false
    space_label_app_icons_strings[i] = ""
end

local function update_space_visibility(space_id_to_update)
    if not space_id_to_update then return end
    local id = tonumber(space_id_to_update)
    if not id or id < 1 or id > MAX_SPACES then return end

    local target_space_widget = spaces_widgets[id]
    local target_bracket_widget = space_bracket_widgets[id]
    local target_padding_widget = space_padding_widgets[id]

    if not target_space_widget then return end

    local has_windows_currently = space_has_windows[id] or false
    local is_active_currently = (active_space_id and id == tonumber(active_space_id))
    local should_be_visible = has_windows_currently or is_active_currently

    local new_dot_icon_string = ""
    local new_label_string = ""
    local current_app_icons_str = space_label_app_icons_strings[id] or ""

    if is_active_currently then
        new_dot_icon_string = SPACE_ICON_ACTIVE
        if current_app_icons_str ~= "" then
            -- Added one space after colon for padding
            new_label_string = tostring(id) .. ":" .. " " .. current_app_icons_str
            -- For two spaces, use: tostring(id) .. ":" .. "  " .. current_app_icons_str
        else
            new_label_string = tostring(id)
        end
    elseif has_windows_currently then -- Inactive but has windows
        new_dot_icon_string = SPACE_ICON_OCCUPIED
        -- Added one space after colon for padding
        new_label_string = tostring(id) .. ":" .. " " .. current_app_icons_str
        -- For two spaces, use: tostring(id) .. ":" .. "  " .. current_app_icons_str
    end

    target_space_widget:set({
        icon = { string = new_dot_icon_string },
        label = { string = new_label_string },
        drawing = should_be_visible and "on" or "off"
    })

    if target_bracket_widget then
        target_bracket_widget:set({ drawing = should_be_visible and "on" or "off" })
    end
    if target_padding_widget then
        target_padding_widget:set({ drawing = should_be_visible and "on" or "off" })
    end
end

sbar.log("Spaces: Adding space items...")
for i = 1, MAX_SPACES, 1 do
    local space_widget_name = "space." .. i
    local space_widget = sbar.add("space", space_widget_name, {
        space = i,
        icon = { -- This is for  or 
            font = { family = settings.font.icons, size = 14.0 },
            string = "",
            color = inactive_dot_color,
            highlight_color = active_dot_color,
            padding_left = 10,
            padding_right = 5,
            y_offset = 1,
        },
        label = { -- This is for "{num} : {apps}" or "{num}"
            font = { family = settings.font.default, size = settings.font.default_size },
            string = "",
            color = inactive_label_color,
            highlight_color = active_label_color,
            padding_left = 0,    -- No padding before the number (it's right after the icon item)
            padding_right = 10,  -- Padding after the entire label string
            y_offset = 0,        -- Global y_offset for the entire label (number, colon, app icons)
                                 -- Try -1 or 1 here to see if it helps overall alignment.
        },
        padding_right = 1,
        padding_left = 1,
        background = { color = colors.bg1, border_width = 1, height = 26 },
        drawing = "off"
    })
    spaces_widgets[i] = space_widget

    local bracket_widget = sbar.add("bracket", { space_widget_name }, {
        background = { color = colors.transparent, border_color = colors.bg2, height = 28, border_width = 2 },
        drawing = "off"
    })
    space_bracket_widgets[i] = bracket_widget

    local padding_widget_name = "space.padding." .. i
    local padding_widget = sbar.add("space", padding_widget_name, {
        space = i, script = "", width = settings.group_paddings, drawing = "off"
    })
    space_padding_widgets[i] = padding_widget

    local space_popup_name = "space.popup." .. i -- Named popup
    local space_popup_handle = sbar.add("item", space_popup_name, { -- Use name
        position = "popup." .. space_widget_name,
        padding_left= 5, padding_right= 0,
        background = { drawing = true, image = { corner_radius = 9, scale = 0.2 } }
    })

    space_widget:subscribe("space_change", function(env)
        local event_space_id = tonumber(env.SID)
        if not event_space_id then return end
        local is_now_selected = (env.SELECTED == "true")
        local previous_active_space_id = active_space_id

        if is_now_selected then
            active_space_id = event_space_id
            sbar.log("Spaces: Active space changed to: " .. active_space_id)
        end

        update_space_visibility(event_space_id)
        if previous_active_space_id and previous_active_space_id ~= active_space_id then
            update_space_visibility(previous_active_space_id)
        end

        for k = 1, MAX_SPACES, 1 do
            local current_s_widget = spaces_widgets[k]
            local current_b_widget = space_bracket_widgets[k]
            if current_s_widget then
                local highlight_this = (active_space_id and k == tonumber(active_space_id))
                current_s_widget:set({
                    icon = { highlight = highlight_this },
                    label = { highlight = highlight_this },
                })
                if current_b_widget then
                    current_b_widget:set({
                        background = { border_color = highlight_this and colors.blue or colors.bg2 }
                    })
                end
            end
        end
    end)

    space_widget:subscribe("mouse.clicked", function(env)
        if env.BUTTON == "other" then
            if space_popup_handle then
                 space_popup_handle:set({ background = { image = "space." .. env.SID } })
            end
            space_widget:set({ popup = { drawing = "toggle" } })
        else
            local op = (env.BUTTON == "right") and "--destroy" or "--focus"
            sbar.exec("yabai -m space " .. op .. " " .. env.SID)
        end
    end)
    space_widget:subscribe("mouse.exited", function(env)
        space_widget:set({ popup = { drawing = false } })
    end)
end
sbar.log("Spaces: Space items added and subscriptions set.")

local space_window_observer = sbar.add("item", "space_window_observer", {
    drawing = false, updates = true,
})
sbar.log("Spaces: Space window observer added.")

space_window_observer:subscribe("space_windows_change", function(env)
    local changed_space_id = tonumber(env.INFO.space)
    if not changed_space_id or changed_space_id < 1 or changed_space_id > MAX_SPACES then return end
    sbar.log("Spaces: Window change in space: " .. changed_space_id)

    local new_app_icons_line = ""
    local has_windows_now = false

    if env.INFO.apps and next(env.INFO.apps) ~= nil then
        has_windows_now = true
        local app_icons_to_display = {}
        sbar.log("Spaces: Processing apps for space " .. changed_space_id .. ":")
        for app, count in pairs(env.INFO.apps) do
            sbar.log("Spaces:   - Yabai app name: '" .. app .. "'")
            local lookup = app_icons_helper[app]
            sbar.log("Spaces:     Lookup in app_icons_helper['" .. app .. "']: " .. tostring(lookup))
            
            local default_icon_from_helper = app_icons_helper["default"] -- Renamed for clarity
            sbar.log("Spaces:     Default icon from app_icons_helper: " .. tostring(default_icon_from_helper))

            local icon_str = ((lookup == nil) and default_icon_from_helper or lookup)
            sbar.log("Spaces:     Final icon_str for '" .. app .. "': '" .. tostring(icon_str) .. "'")
            
            table.insert(app_icons_to_display, icon_str)
        end
        new_app_icons_line = table.concat(app_icons_to_display, " ")
    else
        sbar.log("Spaces: No apps found in env.INFO.apps for space " .. changed_space_id)
    end

    space_has_windows[changed_space_id] = has_windows_now
    space_label_app_icons_strings[changed_space_id] = new_app_icons_line

    update_space_visibility(changed_space_id)
end)

sbar.log("Spaces: Queueing initial visibility update for all spaces...")
sbar.exec("sleep 0.2", function()
    sbar.log("Spaces: Performing initial visibility update for all spaces.")
    if not active_space_id then
        sbar.log("Spaces: Active space ID not yet set by event, querying Yabai...")
        local current_space_json = sbar.exec("yabai -m query --spaces --space | jq -r '.index'")
        if current_space_json and current_space_json ~= "" then
            active_space_id = tonumber(current_space_json)
            sbar.log("Spaces: Initial active space queried from Yabai: " .. active_space_id)
        else
            sbar.log("Spaces: Could not query initial active space from Yabai.")
        end
    end

    for j = 1, MAX_SPACES, 1 do
        update_space_visibility(j)
        local space_w = spaces_widgets[j]
        local bracket_w = space_bracket_widgets[j]
        if space_w then
            local highlight_j = (active_space_id and j == tonumber(active_space_id))
            space_w:set({
                icon = { highlight = highlight_j },
                label = { highlight = highlight_j },
            })
            if bracket_w then
                bracket_w:set({
                    background = { border_color = highlight_j and colors.blue or colors.bg2 }
                })
            end
        end
    end
    sbar.log("Spaces: Initial visibility update complete.")
end)

sbar.log("Spaces: Configuration script finished.")
