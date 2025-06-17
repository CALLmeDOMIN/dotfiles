#!/bin/sh

# Define the window property to match your game.
# Using `initialTitle` can be more reliable than `class` for some games.
# Use `hyprctl clients` to find the best property for your game.
GAME_WINDOW_PROPERTY='initialTitle:^(W.o.T. Client)$'

# Define your main modifier key and the mouse bindings
mainMod="ALT"
move_binding="mouse:272" # Left Mouse Button
resize_binding="mouse:273" # Right Mouse Button

# A variable to track the current state to prevent spamming commands
in_game_mode=false

# Function to handle focus change events
handle() {
  # The event is in the format "activewindowv2>>WINDOWADDRESS"
  # We need to get the window info using hyprctl
  if [[ $1 == "activewindowv2>>"* ]]; then
    # Get the JSON data for all clients
    clients_json=$(hyprctl clients -j)
    # Get the address of the active window
    active_window_address=$(echo "$1" | sed 's/activewindowv2>>//')
    # Extract the relevant property of the active window
    active_window_prop=$(echo "$clients_json" | jq -r ".[] | select(.address == \"0x$active_window_address\") | .${GAME_WINDOW_PROPERTY%%:*}")

    # Check if the active window matches our game property
    if [[ "$active_window_prop" =~ ${GAME_WINDOW_PROPERTY#*:} ]]; then
      # We are focused on the game window
      if ! $in_game_mode; then
        # If not already in game mode, switch to it
        hyprctl --batch "\
          keyword unbind $mainMod, $move_binding; \
          keyword unbind $mainMod, $resize_binding; \
          dispatch submap game"
        in_game_mode=true
      fi
    else
      # We are focused on a different window
      if $in_game_mode; then
        # If we were in game mode, switch back to normal
        hyprctl --batch "\
          keyword bindm $mainMod, $move_binding, movewindow; \
          keyword bindm $mainMod, $resize_binding, resizewindow; \
          dispatch submap reset"
        in_game_mode=false
      fi
    fi
  fi
}

# Use socat to listen to Hyprland's event socket
socat -U - "UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
  handle "$line"
done
