--[[
  SketchyBar Space Configuration:
  - Shows spaces that have windows ( num : apps).
  - Shows the currently active space ( num : apps), even if empty.
  - Hides empty, inactive spaces.
]]

local colors = require("colors")
local icons_module = require("icons")
local settings = require("settings")
local app_icons_helper = require("helpers.app_icons")

local MAX_SPACES = 10
local SPACE_ICON_ACTIVE = ""
local SPACE_ICON_OCCUPIED = ""

-- --- Color Definitions ---
local active_item_text_and_icon_color = colors.orange
local inactive_item_text_and_icon_color = colors.white
local individual_item_bg_color = colors.bar.bg -- Transparent
local container_fill_color = colors.bg1
local container_border_color = colors.bg2
-- --- End Color Definitions ---

sbar.log("Spaces: Removing existing space items...")
local all_potential_items_for_bracket = {} -- Collect all potential items
for i = 1, MAX_SPACES, 1 do
    local space_name = "space." .. i
    local padding_name = "space.padding." .. i
    sbar.remove(space_name)
    sbar.remove(padding_name)
    sbar.remove("space.popup." .. i)
    table.insert(all_potential_items_for_bracket, space_name)
    table.insert(all_potential_items_for_bracket, padding_name)
end
sbar.remove("spaces_container_bracket")
sbar.remove("space_window_observer")
sbar.log("Spaces: Removal complete.")

local active_space_id = nil
local space_has_windows = {}
local space_label_app_icons_strings = {}
local spaces_widgets = {}
local space_padding_widgets = {}

local group_padding_width = settings.group_paddings or 2
if group_padding_width < 0 then group_padding_width = 0 end

for i = 1, MAX_SPACES, 1 do
    space_has_windows[i] = false
    space_label_app_icons_strings[i] = ""
end

-- Define update_space_item_display first
local function update_space_item_display(id)
    if not id then return end
    id = tonumber(id)
    if not id or id < 1 or id > MAX_SPACES then return end

    local target_space_widget = spaces_widgets[id]
    local target_padding_widget = space_padding_widgets[id]
    if not target_space_widget then
        sbar.log("Spaces: No widget for space " .. id .. " in update_space_item_display")
        return
    end

    local has_windows_currently = space_has_windows[id] or false
    local is_active_currently = (active_space_id and id == tonumber(active_space_id))
    local should_be_visible = has_windows_currently or is_active_currently

    sbar.log("Spaces: Updating space " .. id .. ": active=" .. tostring(is_active_currently) ..
               ", has_windows=" .. tostring(has_windows_currently) ..
               ", should_be_visible=" .. tostring(should_be_visible))

    local new_dot_icon_string = ""
    local new_label_string = ""
    local current_app_icons_str = space_label_app_icons_strings[id] or ""
    local current_text_and_icon_color_to_set

    if is_active_currently then
        new_dot_icon_string = SPACE_ICON_ACTIVE
        current_text_and_icon_color_to_set = active_item_text_and_icon_color
        if current_app_icons_str ~= "" then
            new_label_string = tostring(id) .. ":" .. " " .. current_app_icons_str
        else
            new_label_string = tostring(id)
        end
    elseif has_windows_currently then
        new_dot_icon_string = SPACE_ICON_OCCUPIED
        current_text_and_icon_color_to_set = inactive_item_text_and_icon_color
        new_label_string = tostring(id) .. ":" .. " " .. current_app_icons_str
    else -- Not visible (and not active, not has_windows)
        new_dot_icon_string = ""
        current_text_and_icon_color_to_set = inactive_item_text_and_icon_color
        new_label_string = ""
    end

    target_space_widget:set({
        icon = { string = new_dot_icon_string, color = current_text_and_icon_color_to_set },
        label = { string = new_label_string, color = current_text_and_icon_color_to_set },
        background = { color = individual_item_bg_color },
        drawing = should_be_visible and "on" or "off"
    })

    if target_padding_widget then
        -- Padding is visible if its corresponding space is visible.
        -- The "trailing padding" issue will be managed by the bracket's own padding or by accepting it.
        target_padding_widget:set({ drawing = should_be_visible and "on" or "off" })
    end
end

-- Function to refresh all displays
local function refresh_all_displays()
    sbar.log("Spaces: Refreshing all displays. Active SID: " .. tostring(active_space_id))
    for i = 1, MAX_SPACES, 1 do
        update_space_item_display(i)
    end
end


sbar.log("Spaces: Adding space items...")
for i = 1, MAX_SPACES, 1 do
    local space_widget_name = "space." .. i
    local space_widget = sbar.add("space", space_widget_name, {
        space = i,
        icon = {
            font = { family = settings.font.icons, size = 14.0 },
            string = "", color = inactive_item_text_and_icon_color,
            padding_left = 2, padding_right = 3, y_offset = 1,
        },
        label = {
            font = { family = settings.font.default, size = settings.font.default_size },
            string = "", color = inactive_item_text_and_icon_color,
            padding_left = 0, padding_right = 0, y_offset = 0,
        },
        background = { color = individual_item_bg_color, corner_radius = 5, height = 26, border_width = 0 },
        drawing = "off"
    })
    spaces_widgets[i] = space_widget

    local padding_widget_name = "space.padding." .. i
    local padding_widget = sbar.add("space", padding_widget_name, {
        space = i, script = "", width = group_padding_width, drawing = "off"
    })
    space_padding_widgets[i] = padding_widget

    local space_popup_name = "space.popup." .. i
    sbar.add("item", space_popup_name, {
        position = "popup." .. space_widget_name,
        padding_left= 5, padding_right= 0,
        background = { drawing = true, image = { corner_radius = 5, scale = 0.2 } }
    })

    space_widget:subscribe("space_change", function(env)
        local event_space_id = tonumber(env.SID)
        if not event_space_id then return end
        sbar.log("Spaces: space_change event for SID " .. event_space_id .. ", SELECTED=" .. env.SELECTED)
        if env.SELECTED == "true" then
            active_space_id = event_space_id
        elseif tonumber(active_space_id) == event_space_id then
            -- The currently active space became unselected, and no new one immediately took its place.
            -- This can happen if the last window on the active space is closed, and Yabai moves focus.
            -- We might need to query Yabai for the new active space.
            -- For now, let refresh_all_displays handle it based on current active_space_id.
            -- If another space becomes active, its event will update active_space_id.
            -- If no space is "active" (e.g. focus is on desktop), active_space_id might remain.
        end
        refresh_all_displays()
    end)
    space_widget:subscribe("mouse.clicked", function(env)
        if env.BUTTON == "other" then
            local popup_handle = sbar.items["space.popup." .. i]
            if popup_handle then popup_handle:set({ background = { image = "space." .. env.SID } }) end
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

if #all_potential_items_for_bracket > 0 then
    sbar.add("bracket", "spaces_container_bracket", all_potential_items_for_bracket, {
        background = {
            color = container_fill_color,
            border_color = container_border_color,
            border_width = 2, corner_radius = 5,
            padding_left = 4, padding_right = 4,
        }
    })
    sbar.log("Spaces: Main container bracket added.")
end

sbar.log("Spaces: Space items added and subscriptions set.")
local space_window_observer = sbar.add("item", "space_window_observer", {
    drawing = false, updates = true,
})
sbar.log("Spaces: Space window observer added.")

space_window_observer:subscribe("space_windows_change", function(env)
    local changed_space_id = tonumber(env.INFO.space)
    if not changed_space_id or changed_space_id < 1 or changed_space_id > MAX_SPACES then return end
    sbar.log("Spaces: space_windows_change event for SID " .. changed_space_id)
    local new_app_icons_line = ""
    local has_windows_now = false
    if env.INFO.apps and next(env.INFO.apps) ~= nil then
        has_windows_now = true
        local app_icons_to_display = {}
        for app, count in pairs(env.INFO.apps) do
            local lookup = app_icons_helper[app]
            local default_icon_from_helper = app_icons_helper["default"]
            local icon_str = ((lookup == nil) and default_icon_from_helper or lookup)
            table.insert(app_icons_to_display, icon_str)
        end
        new_app_icons_line = table.concat(app_icons_to_display, " ")
    end
    space_has_windows[changed_space_id] = has_windows_now
    space_label_app_icons_strings[changed_space_id] = new_app_icons_line
    -- Only update the changed space directly, then refresh all to ensure active state is correct
    update_space_item_display(changed_space_id)
    refresh_all_displays() -- Refresh all to correctly update active state if it was affected
end)

sbar.log("Spaces: Queueing initial visibility update for all spaces...")
sbar.exec("sleep 0.2", function()
    sbar.log("Spaces: Performing initial visibility update for all spaces.")
    if not active_space_id then
        local current_space_json = sbar.exec("yabai -m query --spaces --space | jq -r '.index'")
        if current_space_json and current_space_json ~= "" then
            active_space_id = tonumber(current_space_json)
            sbar.log("Spaces: Initial active_space_id set to: " .. active_space_id)
        else
            sbar.log("Spaces: Could not query initial active space.")
        end
    end
    refresh_all_displays()
    sbar.log("Spaces: Initial visibility update complete.")
end)
sbar.log("Spaces: Configuration script finished.")

