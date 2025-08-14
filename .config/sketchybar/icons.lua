local settings = require("settings")

local icons = {
    nerdfont = {
        app_discord = "󰙯",
        app_terminal = "",
        app_ghostty = "",
        app_chrome = "󰊯",
        app_vscode = "󰨞",
        app_finder = "󰀶",
        app_web_browser = "󰖟",
        app_zen = "",
        app_firefox = "",
        app_intellij = "",
        app_postman = "",
        app_mongo = "",
        app_xcode = "",
        app_figma = "",
        app_calendar = "",
        app_music = "󰌳",
        app_android_studio = "󰀴",
        app_word = "",
        app_excel = "󱎏",
        app_powerpoint = "󱎐",

        plus = "",
        loading = "",
        apple = "",
        gear = "",
        cpu = "",
        clipboard = "Missing Icon",

        switch = {
            on = "󱨥",
            off = "󱨦",
        },
        volume = {
            _100="",
            _66="",
            _33="",
            _10="",
            _0="",
        },
        battery = {
            _100 = "",
            _75 = "",
            _50 = "",
            _25 = "",
            _0 = "",
            charging = ""
        },
        wifi = {
            upload = "",
            download = "",
            connected = "󰖩",
            disconnected = "󰖪",
            router = "Missing Icon"
        },
        media = {
            back = "",
            forward = "",
            play_pause = "",
        },
    },
}

if not (settings.icons == "NerdFont") then
    return icons.sf_symbols
else
    return icons.nerdfont
end
