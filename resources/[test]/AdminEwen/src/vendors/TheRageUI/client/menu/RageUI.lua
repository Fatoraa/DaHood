---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Dylan Malandain.
--- DateTime: 21/04/2019 21:20
---


---round
---@param num number
---@param numDecimalPlaces number
---@return number
---@public
function math.round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

---starts
---@param String string
---@param Start number
---@return number
---@public
function string.starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

---@type table
VIPUI.Menus = setmetatable({}, VIPUI.Menus)

---@type table
---@return boolean
VIPUI.Menus.__call = function()
    return true
end

---@type table
VIPUI.Menus.__index = VIPUI.Menus

---@type table
VIPUI.CurrentMenu = nil

---@type table
VIPUI.NextMenu = nil

---@type number
VIPUI.Options = 0

---@type number
VIPUI.ItemOffset = 0

---@type number
VIPUI.StatisticPanelCount = 0

---@type table
VIPUI.UI = {
    Current = "VIPUI",
    Style = {
        VIPUI = {
            Width = 0
        },
        NativeUI = {
            Width = 0
        }
    }
}

---@type table
VIPUI.Settings = {
    Debug = false,
    Controls = {
        Up = {
            Enabled = true,
            Active = false,
            Pressed = false,
            Keys = {
                { 0, 172 },
                { 1, 172 },
                { 2, 172 },
                { 0, 241 },
                { 1, 241 },
                { 2, 241 },
            },
        },
        Down = {
            Enabled = true,
            Active = false,
            Pressed = false,
            Keys = {
                { 0, 173 },
                { 1, 173 },
                { 2, 173 },
                { 0, 242 },
                { 1, 242 },
                { 2, 242 },
            },
        },
        Left = {
            Enabled = true,
            Active = false,
            Pressed = false,
            Keys = {
                { 0, 174 },
                { 1, 174 },
                { 2, 174 },
            },
        },
        Right = {
            Enabled = true,
            Pressed = false,
            Active = false,
            Keys = {
                { 0, 175 },
                { 1, 175 },
                { 2, 175 },
            },
        },
        SliderLeft = {
            Enabled = true,
            Active = false,
            Pressed = false,
            Keys = {
                { 0, 174 },
                { 1, 174 },
                { 2, 174 },
            },
        },
        SliderRight = {
            Enabled = true,
            Pressed = false,
            Active = false,
            Keys = {
                { 0, 175 },
                { 1, 175 },
                { 2, 175 },
            },
        },
        Select = {
            Enabled = true,
            Pressed = false,
            Active = false,
            Keys = {
                { 0, 201 },
                { 1, 201 },
                { 2, 201 },
            },
        },
        Back = {
            Enabled = true,
            Active = false,
            Pressed = false,
            Keys = {
                { 0, 177 },
                { 1, 177 },
                { 2, 177 },
                { 0, 199 },
                { 1, 199 },
                { 2, 199 },
            },
        },
        Click = {
            Enabled = true,
            Active = false,
            Pressed = false,
            Keys = {
                { 0, 24 },
            },
        },
        Enabled = {
            Controller = {
                { 0, 2 }, -- Look Up and Down
                { 0, 1 }, -- Look Left and Right
                { 0, 25 }, -- Aim
                { 0, 24 }, -- Attack
            },
            Keyboard = {
                { 0, 201 }, -- Select
                { 0, 195 }, -- X axis
                { 0, 196 }, -- Y axis
                { 0, 187 }, -- Down
                { 0, 188 }, -- Up
                { 0, 189 }, -- Left
                { 0, 190 }, -- Right
                { 0, 202 }, -- Back
                { 0, 217 }, -- Select
                { 0, 242 }, -- Scroll down
                { 0, 241 }, -- Scroll up
                { 0, 239 }, -- Cursor X
                { 0, 240 }, -- Cursor Y
                { 0, 31 }, -- Move Up and Down
                { 0, 30 }, -- Move Left and Right
                { 0, 21 }, -- Sprint
                { 0, 22 }, -- Jump
                { 0, 23 }, -- Enter
                { 0, 75 }, -- Exit Vehicle
                { 0, 71 }, -- Accelerate Vehicle
                { 0, 72 }, -- Vehicle Brake
                { 0, 59 }, -- Move Vehicle Left and Right
                { 0, 89 }, -- Fly Yaw Left
                { 0, 9 }, -- Fly Left and Right
                { 0, 8 }, -- Fly Up and Down
                { 0, 90 }, -- Fly Yaw Right
                { 0, 76 }, -- Vehicle Handbrake
            },
        },
    },
    Audio = {
        Id = nil,
        Use = "VIPUI",
        VIPUI = {
            UpDown = {
                audioName = "HUD_FREEMODE_SOUNDSET",
                audioRef = "NAV_UP_DOWN",
            },
            LeftRight = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "NAV_LEFT_RIGHT",
            },
            Select = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "SELECT",
            },
            Back = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "BACK",
            },
            Error = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "ERROR",
            },
            Slider = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "CONTINUOUS_SLIDER",
                Id = nil
            },
        },
        NativeUI = {
            UpDown = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "NAV_UP_DOWN",
            },
            LeftRight = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "NAV_LEFT_RIGHT",
            },
            Select = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "SELECT",
            },
            Back = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "BACK",
            },
            Error = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "ERROR",
            },
            Slider = {
                audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                audioRef = "CONTINUOUS_SLIDER",
                Id = nil
            },
        }
    },
    Items = {
        Title = {
            Background = { Width = 431, Height = 107 },
            Text = { X = 215, Y = 20, Scale = 1.15 },
        },
        Subtitle = {
            Background = { Width = 431, Height = 37 },
            Text = { X = 8, Y = 3, Scale = 0.35 },
            PreText = { X = 425, Y = 3, Scale = 0.35 },
        },
        Background = { Dictionary = "commonmenu", Texture = "gradient_bgd", Y = 0, Width = 431 },
        Navigation = {
            Rectangle = { Width = 431, Height = 18 },
            Offset = 5,
            Arrows = { Dictionary = "commonmenu", Texture = "shop_arrows_upanddown", X = 190, Y = -6, Width = 50, Height = 50 },
        },
        Description = {
            Bar = { Y = 4, Width = 431, Height = 4 },
            Background = { Dictionary = "commonmenu", Texture = "gradient_bgd", Y = 4, Width = 431, Height = 30 },
            Text = { X = 8, Y = 10, Scale = 0.35 },
        },
    },
    Panels = {
        Grid = {
            Background = { Dictionary = "commonmenu", Texture = "gradient_bgd", Y = 4, Width = 431, Height = 275 },
            Grid = { Dictionary = "pause_menu_pages_char_mom_dad", Texture = "nose_grid", X = 115.5, Y = 47.5, Width = 200, Height = 200 },
            Circle = { Dictionary = "mpinventory", Texture = "in_world_circle", X = 115.5, Y = 47.5, Width = 20, Height = 20 },
            Text = {
                Top = { X = 215.5, Y = 15, Scale = 0.35 },
                Bottom = { X = 215.5, Y = 250, Scale = 0.35 },
                Left = { X = 57.75, Y = 130, Scale = 0.35 },
                Right = { X = 373.25, Y = 130, Scale = 0.35 },
            },
        },
        Percentage = {
            Background = { Dictionary = "commonmenu", Texture = "gradient_bgd", Y = 4, Width = 431, Height = 76 },
            Bar = { X = 9, Y = 50, Width = 413, Height = 10 },
            Text = {
                Left = { X = 25, Y = 15, Scale = 0.35 },
                Middle = { X = 215.5, Y = 15, Scale = 0.35 },
                Right = { X = 398, Y = 15, Scale = 0.35 },
            },
        },
    },
}

function VIPUI.SetScaleformParams(scaleform, data)
    data = data or {}
    for k, v in pairs(data) do
        PushScaleformMovieFunction(scaleform, v.name)
        if v.param then
            for _, par in pairs(v.param) do
                if math.type(par) == "integer" then
                    PushScaleformMovieFunctionParameterInt(par)
                elseif type(par) == "boolean" then
                    PushScaleformMovieFunctionParameterBool(par)
                elseif math.type(par) == "float" then
                    PushScaleformMovieFunctionParameterFloat(par)
                elseif type(par) == "string" then
                    PushScaleformMovieFunctionParameterString(par)
                end
            end
        end
        if v.func then
            v.func()
        end
        PopScaleformMovieFunctionVoid()
    end
end

---Visible
---@param Menu function
---@param Value boolean
---@return table
---@public
function VIPUI.Visible(Menu, Value)
    if Menu ~= nil then
        if Menu() then
            if type(Value) == "boolean" then
                if Value then
                    if VIPUI.CurrentMenu ~= nil then
			if VIPUI.CurrentMenu.Closed ~= nil then
                            VIPUI.CurrentMenu.Closed()
                        end
                        VIPUI.CurrentMenu.Open = not Value
                    end
                    Menu:UpdateInstructionalButtons(Value);
                    Menu:UpdateCursorStyle();
                    VIPUI.CurrentMenu = Menu
                    menuOpen = true
                else
                    menuOpen = false
                    VIPUI.CurrentMenu = nil
                end
                Menu.Open = Value
                VIPUI.Options = 0
                VIPUI.ItemOffset = 0
                VIPUI.LastControl = false
            else
                return Menu.Open
            end
        end
    end
end

function VIPUI.CloseAll()
    menuOpen = false
    if VIPUI.CurrentMenu ~= nil then
        local parent = VIPUI.CurrentMenu.Parent
        while parent ~= nil do
            parent.Index = 1
            parent.Pagination.Minimum = 1
            parent.Pagination.Maximum = 10
            parent = parent.Parent
        end
        VIPUI.CurrentMenu.Index = 1
        VIPUI.CurrentMenu.Pagination.Minimum = 1
        VIPUI.CurrentMenu.Pagination.Maximum = 10
        VIPUI.CurrentMenu.Open = false
        VIPUI.CurrentMenu = nil
    end
    VIPUI.Options = 0
    VIPUI.ItemOffset = 0
    ResetScriptGfxAlign()
end

---Banner
---@return nil
---@public
---@param Enabled boolean
function VIPUI.Banner(Enabled, Glare)
    if type(Enabled) == "boolean" then
        if Enabled == true then


            if VIPUI.CurrentMenu ~= nil then
                if VIPUI.CurrentMenu() then


                    VIPUI.ItemsSafeZone(VIPUI.CurrentMenu)

                    if VIPUI.CurrentMenu.Sprite then
                        RenderSprite(VIPUI.CurrentMenu.Sprite.Dictionary, VIPUI.CurrentMenu.Sprite.Texture, VIPUI.CurrentMenu.X, VIPUI.CurrentMenu.Y, VIPUI.Settings.Items.Title.Background.Width + VIPUI.CurrentMenu.WidthOffset, VIPUI.Settings.Items.Title.Background.Height, nil)
                    else
                        RenderRectangle(VIPUI.CurrentMenu.X, VIPUI.CurrentMenu.Y, VIPUI.Settings.Items.Title.Background.Width + VIPUI.CurrentMenu.WidthOffset, VIPUI.Settings.Items.Title.Background.Height, VIPUI.CurrentMenu.Rectangle.R, VIPUI.CurrentMenu.Rectangle.G, VIPUI.CurrentMenu.Rectangle.B, VIPUI.CurrentMenu.Rectangle.A)
                    end

                    --if (VIPUI.CurrentMenu.WidthOffset == 100) then
                        if Glare then

                            local ScaleformMovie = RequestScaleformMovie("MP_MENU_GLARE")
                            while not HasScaleformMovieLoaded(ScaleformMovie) do
                                Citizen.Wait(0)
                            end

							---@type number
							local Glarewidth = VIPUI.Settings.Items.Title.Background.Width

							---@type number
							local Glareheight = VIPUI.Settings.Items.Title.Background.Height
							---@type number
							local GlareX = VIPUI.CurrentMenu.X / 1860 + (VIPUI.CurrentMenu.SafeZoneSize.X / (64.399 - (VIPUI.CurrentMenu.WidthOffset * 0.065731)))
                            ---@type number
                            local GlareY = VIPUI.CurrentMenu.Y / 1080 + VIPUI.CurrentMenu.SafeZoneSize.Y / 33.195020746888
                            VIPUI.SetScaleformParams(ScaleformMovie, {
                                { name = "SET_DATA_SLOT", param = { GetGameplayCamRelativeHeading() } }
                            })

                            DrawScaleformMovie(ScaleformMovie, GlareX, GlareY, Glarewidth / 430, Glareheight / 100, 255, 255, 255, 255, 0)

                        end
                    --end

                    RenderText(VIPUI.CurrentMenu.Title, VIPUI.CurrentMenu.X + VIPUI.Settings.Items.Title.Text.X + (VIPUI.CurrentMenu.WidthOffset / 2), VIPUI.CurrentMenu.Y + VIPUI.Settings.Items.Title.Text.Y, 1, VIPUI.Settings.Items.Title.Text.Scale, 255, 255, 255, 255, 1)
                    VIPUI.ItemOffset = VIPUI.ItemOffset + VIPUI.Settings.Items.Title.Background.Height
                end
            end
        end
    else
        error("Enabled is not boolean")
    end
end

---CloseAll -- TODO 
---@return nil
---@public
-- function VIPUI:CloseAll()
--     VIPUI.PlaySound(VIPUI.Settings.Audio.Library, VIPUI.Settings.Audio.Back)
--     VIPUI.NextMenu = nil
--     VIPUI.Visible(VIPUI.CurrentMenu, false)
-- end

---Subtitle
---@return nil
---@public
function VIPUI.Subtitle()
    if VIPUI.CurrentMenu ~= nil then
        if VIPUI.CurrentMenu() then
            VIPUI.ItemsSafeZone(VIPUI.CurrentMenu)
            if VIPUI.CurrentMenu.Subtitle ~= "" then
                RenderRectangle(VIPUI.CurrentMenu.X, VIPUI.CurrentMenu.Y + VIPUI.ItemOffset, VIPUI.Settings.Items.Subtitle.Background.Width + VIPUI.CurrentMenu.WidthOffset, VIPUI.Settings.Items.Subtitle.Background.Height + VIPUI.CurrentMenu.SubtitleHeight, 0, 0, 0, 255)
                RenderText(VIPUI.CurrentMenu.Subtitle, VIPUI.CurrentMenu.X + VIPUI.Settings.Items.Subtitle.Text.X, VIPUI.CurrentMenu.Y + VIPUI.Settings.Items.Subtitle.Text.Y + VIPUI.ItemOffset, 0, VIPUI.Settings.Items.Subtitle.Text.Scale, 245, 245, 245, 255, nil, false, false, VIPUI.Settings.Items.Subtitle.Background.Width + VIPUI.CurrentMenu.WidthOffset)
                if VIPUI.CurrentMenu.Index > VIPUI.CurrentMenu.Options or VIPUI.CurrentMenu.Index < 0 then
                    VIPUI.CurrentMenu.Index = 1
                end
                VIPUI.RefreshPagination()
                if VIPUI.CurrentMenu.PageCounter == nil then
                    RenderText(VIPUI.CurrentMenu.PageCounterColour .. VIPUI.CurrentMenu.Index .. " / " .. VIPUI.CurrentMenu.Options, VIPUI.CurrentMenu.X + VIPUI.Settings.Items.Subtitle.PreText.X + VIPUI.CurrentMenu.WidthOffset, VIPUI.CurrentMenu.Y + VIPUI.Settings.Items.Subtitle.PreText.Y + VIPUI.ItemOffset, 0, VIPUI.Settings.Items.Subtitle.PreText.Scale, 245, 245, 245, 255, 2)
                else
                    RenderText(VIPUI.CurrentMenu.PageCounter, VIPUI.CurrentMenu.X + VIPUI.Settings.Items.Subtitle.PreText.X + VIPUI.CurrentMenu.WidthOffset, VIPUI.CurrentMenu.Y + VIPUI.Settings.Items.Subtitle.PreText.Y + VIPUI.ItemOffset, 0, VIPUI.Settings.Items.Subtitle.PreText.Scale, 245, 245, 245, 255, 2)
                end
                VIPUI.ItemOffset = VIPUI.ItemOffset + VIPUI.Settings.Items.Subtitle.Background.Height
            end
        end
    end
end

---Background
---@return nil
---@public
function VIPUI.Background()
    if VIPUI.CurrentMenu ~= nil then
        if VIPUI.CurrentMenu() then
            VIPUI.ItemsSafeZone(VIPUI.CurrentMenu)
            SetScriptGfxDrawOrder(0)
            RenderSprite(VIPUI.Settings.Items.Background.Dictionary, VIPUI.Settings.Items.Background.Texture, VIPUI.CurrentMenu.X, VIPUI.CurrentMenu.Y + VIPUI.Settings.Items.Background.Y + VIPUI.CurrentMenu.SubtitleHeight, VIPUI.Settings.Items.Background.Width + VIPUI.CurrentMenu.WidthOffset, VIPUI.ItemOffset, 0, 0, 0, 0, 255)
            SetScriptGfxDrawOrder(1)
        end
    end
end

---Description
---@return nil
---@public
function VIPUI.Description()
    if VIPUI.CurrentMenu ~= nil and VIPUI.CurrentMenu.Description ~= nil then
        if VIPUI.CurrentMenu() then
            VIPUI.ItemsSafeZone(VIPUI.CurrentMenu)
            RenderRectangle(VIPUI.CurrentMenu.X, VIPUI.CurrentMenu.Y + VIPUI.Settings.Items.Description.Bar.Y + VIPUI.CurrentMenu.SubtitleHeight + VIPUI.ItemOffset, VIPUI.Settings.Items.Description.Bar.Width + VIPUI.CurrentMenu.WidthOffset, VIPUI.Settings.Items.Description.Bar.Height, 0, 0, 0, 255)
            RenderSprite(VIPUI.Settings.Items.Description.Background.Dictionary, VIPUI.Settings.Items.Description.Background.Texture, VIPUI.CurrentMenu.X, VIPUI.CurrentMenu.Y + VIPUI.Settings.Items.Description.Background.Y + VIPUI.CurrentMenu.SubtitleHeight + VIPUI.ItemOffset, VIPUI.Settings.Items.Description.Background.Width + VIPUI.CurrentMenu.WidthOffset, VIPUI.CurrentMenu.DescriptionHeight, 0, 0, 0, 255)
            RenderText(VIPUI.CurrentMenu.Description, VIPUI.CurrentMenu.X + VIPUI.Settings.Items.Description.Text.X, VIPUI.CurrentMenu.Y + VIPUI.Settings.Items.Description.Text.Y + VIPUI.CurrentMenu.SubtitleHeight + VIPUI.ItemOffset, 0, VIPUI.Settings.Items.Description.Text.Scale, 255, 255, 255, 255, nil, false, false, VIPUI.Settings.Items.Description.Background.Width + VIPUI.CurrentMenu.WidthOffset - 8.0)
            VIPUI.ItemOffset = VIPUI.ItemOffset + VIPUI.CurrentMenu.DescriptionHeight + VIPUI.Settings.Items.Description.Bar.Y
        end
    end
end

---Render
---@param instructionalButton boolean
---@return nil
---@public
function VIPUI.Render(instructionalButton)
    if VIPUI.CurrentMenu ~= nil then
        if VIPUI.CurrentMenu() then
            if VIPUI.CurrentMenu.Safezone then
                ResetScriptGfxAlign()
            end
            if (instructionalButton) then
                DrawScaleformMovieFullscreen(VIPUI.CurrentMenu.InstructionalScaleform, 255, 255, 255, 255, 0)
            end
            VIPUI.CurrentMenu.Options = VIPUI.Options
            VIPUI.CurrentMenu.SafeZoneSize = nil
            VIPUI.Controls()
            VIPUI.Options = 0
            VIPUI.StatisticPanelCount = 0
            VIPUI.ItemOffset = 0
            if VIPUI.CurrentMenu.Controls.Back.Enabled and VIPUI.CurrentMenu.Closable then
                if VIPUI.CurrentMenu.Controls.Back.Pressed then
                    VIPUI.CurrentMenu.Controls.Back.Pressed = false
                    local Audio = VIPUI.Settings.Audio
                    VIPUI.PlaySound(Audio[Audio.Use].Back.audioName, Audio[Audio.Use].Back.audioRef)
                    collectgarbage()
                    if VIPUI.CurrentMenu.Closed ~= nil then
                        VIPUI.CurrentMenu.Closed()
                    end
                    if VIPUI.CurrentMenu.Parent ~= nil then
                        if VIPUI.CurrentMenu.Parent() then
                            VIPUI.NextMenu = VIPUI.CurrentMenu.Parent
                            VIPUI.CurrentMenu:UpdateCursorStyle()
                        else
                            --print('xxx') Debug print
                            VIPUI.NextMenu = nil
                            VIPUI.Visible(VIPUI.CurrentMenu, false)
                        end
                    else
                        --print('zz') Debug print
                        VIPUI.NextMenu = nil
                        VIPUI.Visible(VIPUI.CurrentMenu, false)
                    end
                end
            end
            if VIPUI.NextMenu ~= nil then
                if VIPUI.NextMenu() then
                    VIPUI.Visible(VIPUI.CurrentMenu, false)
                    VIPUI.Visible(VIPUI.NextMenu, true)
                    VIPUI.CurrentMenu.Controls.Select.Active = false
                    VIPUI.NextMenu = nil
                    VIPUI.LastControl = false
                end
            end
        end
    end
end

---ItemsDescription
---@param CurrentMenu table
---@param Description string
---@param Selected boolean
---@return nil
---@public
function VIPUI.ItemsDescription(CurrentMenu, Description, Selected)
    ---@type table
    if Description ~= "" or Description ~= nil then
        local SettingsDescription = VIPUI.Settings.Items.Description;
        if Selected and CurrentMenu.Description ~= Description then
            CurrentMenu.Description = Description or nil
            ---@type number
            local DescriptionLineCount = GetLineCount(CurrentMenu.Description, CurrentMenu.X + SettingsDescription.Text.X, CurrentMenu.Y + SettingsDescription.Text.Y + CurrentMenu.SubtitleHeight + VIPUI.ItemOffset, 0, SettingsDescription.Text.Scale, 255, 255, 255, 255, nil, false, false, SettingsDescription.Background.Width + (CurrentMenu.WidthOffset - 5.0))
            if DescriptionLineCount > 1 then
                CurrentMenu.DescriptionHeight = SettingsDescription.Background.Height * DescriptionLineCount
            else
                CurrentMenu.DescriptionHeight = SettingsDescription.Background.Height + 7
            end
        end
    end
end

---MouseBounds
---@param CurrentMenu table
---@param Selected boolean
---@param Option number
---@param SettingsButton table
---@return boolean
---@public
function VIPUI.ItemsMouseBounds(CurrentMenu, Selected, Option, SettingsButton)
    ---@type boolean
    local Hovered = false
    Hovered = VIPUI.IsMouseInBounds(CurrentMenu.X + CurrentMenu.SafeZoneSize.X, CurrentMenu.Y + SettingsButton.Rectangle.Y + CurrentMenu.SafeZoneSize.Y + CurrentMenu.SubtitleHeight + VIPUI.ItemOffset, SettingsButton.Rectangle.Width + CurrentMenu.WidthOffset, SettingsButton.Rectangle.Height)
    if Hovered and not Selected then
        RenderRectangle(CurrentMenu.X, CurrentMenu.Y + SettingsButton.Rectangle.Y + CurrentMenu.SubtitleHeight + VIPUI.ItemOffset, SettingsButton.Rectangle.Width + CurrentMenu.WidthOffset, SettingsButton.Rectangle.Height, 255, 255, 255, 20)
        if CurrentMenu.Controls.Click.Active then
            CurrentMenu.Index = Option
            local Audio = VIPUI.Settings.Audio
            VIPUI.PlaySound(Audio[Audio.Use].Error.audioName, Audio[Audio.Use].Error.audioRef)
        end
    end
    return Hovered;
end

---ItemsSafeZone
---@param CurrentMenu table
---@return nil
---@public
function VIPUI.ItemsSafeZone(CurrentMenu)
    if not CurrentMenu.SafeZoneSize then
        CurrentMenu.SafeZoneSize = { X = 0, Y = 0 }
        if CurrentMenu.Safezone then
            CurrentMenu.SafeZoneSize = VIPUI.GetSafeZoneBounds()
            SetScriptGfxAlign(76, 84)
            SetScriptGfxAlignParams(0, 0, 0, 0)
        end
    end
end

function VIPUI.CurrentIsEqualTo(Current, To, Style, DefaultStyle)
    if (Current == To) then
        return Style;
    else
        return DefaultStyle or {};
    end
end

function VIPUI.RefreshPagination()
    if (VIPUI.CurrentMenu ~= nil) then
        if (VIPUI.CurrentMenu.Index > 10) then
            local offset = VIPUI.CurrentMenu.Index - 10
            VIPUI.CurrentMenu.Pagination.Minimum = 1 + offset
            VIPUI.CurrentMenu.Pagination.Maximum = 10 + offset
        else
            VIPUI.CurrentMenu.Pagination.Minimum = 1
            VIPUI.CurrentMenu.Pagination.Maximum = 10
        end
    end
end

function VIPUI.IsVisible(menu, header, glare, instructional, items, panels)
    if (VIPUI.Visible(menu)) then
        if (header == true) then
            VIPUI.Banner(true, glare or false)
        end
        VIPUI.Subtitle()
        if (items ~= nil) then
            items()
        end
        VIPUI.Background();
        VIPUI.Navigation();
        VIPUI.Description();
        if (panels ~= nil) then
            panels()
        end
        VIPUI.Render(instructional or false)
    end
end


---CreateWhile
---@param wait number
---@param menu table
---@param key number
---@param closure function
---@return void
---@public
function VIPUI.CreateWhile(wait, menu, key, closure)
    Citizen.CreateThread(function()
        while (true) do
            Citizen.Wait(wait or 0.1)

            if (key ~= nil) then
                if IsControlJustPressed(1, key) then
                    VIPUI.Visible(menu, not VIPUI.Visible(menu))
                end
            end

            closure()
        end
    end)
end

---SetStyleAudio
---@param StyleAudio string
---@return void
---@public
function VIPUI.SetStyleAudio(StyleAudio)
    VIPUI.Settings.Audio.Use = StyleAudio or "VIPUI"
end

function VIPUI.GetStyleAudio()
    return VIPUI.Settings.Audio.Use or "VIPUI"
end