--[[
    PastLauncher
    Original launcher layout and settings retained.
    Select a game, then press Run the script.
]]

local LAUNCHING = false

local function notify(title, message)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = tostring(title),
            Text = tostring(message),
            Duration = 5,
        })
    end)
end

-- Obsidian UI
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

Library.Font = Enum.Font.Roboto

local Window = Library:CreateWindow({
    Title = '<font color="#c4b5fd"><b>PastLauncher</b></font>',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.15,
    Size = UDim2.new(0, 520, 0, 360),
})

local Tab = Window:AddTab("Launch", "rocket")
local Box = Tab:AddLeftGroupbox("Games", "gamepad-2")
Box:AddLabel("Choose a game")
Box:AddDivider()

local SCRIPT_URL = "https://raw.githubusercontent.com/kopanda16056/Shizukascripts/main/PASTAHUB"
local GAME_SELECTED = false

Box:AddToggle("SelectBloxstrike", {
    Text = "Bloxstrike",
    Default = false,
    Callback = function(value)
        GAME_SELECTED = value
    end,
})

Box:AddDivider()
Box:AddButton("Run the script", function()
    if LAUNCHING then return end
    if not GAME_SELECTED then
        notify("PastLauncher", "First select Bloxstrike")
        return
    end

    LAUNCHING = true
    task.spawn(function()
        local ok, err = pcall(function()
            local source = game:HttpGet(SCRIPT_URL)
            assert(type(source) == "string" and #source > 0, "Downloaded script is empty")
            local fn, loadErr = loadstring(source, "=PASTAHUB")
            assert(type(fn) == "function", loadErr or "loadstring failed")
            Library:Unload()
            fn()
        end)
        if not ok then
            LAUNCHING = false
            notify("PastLauncher", "Bloxstrike failed to load: " .. tostring(err))
        end
    end)
end)

local Settings = Window:AddTab("Settings", "settings")
local SG = Settings:AddLeftGroupbox("Interface", "settings")
SG:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", {
    Text = "MenuKeybind",
    Default = "RightShift",
    Mode = "Toggle",
    Callback = function()
        Library:Toggle()
    end,
})

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("PastLauncher")
SaveManager:SetFolder("PastLauncher/configs")
SaveManager:SetSubFolder("main")
SaveManager:BuildConfigSection(Settings)
ThemeManager:ApplyToTab(Settings)
