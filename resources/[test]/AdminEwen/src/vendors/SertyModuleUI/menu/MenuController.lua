local AeroEvent = TriggerServerEvent
---@type table
SertyModuleUI.LastControl = false

---IsMouseInBounds
---@param X number
---@param Y number
---@param Width number
---@param Height number
---@return number
---@public
function SertyModuleUI.IsMouseInBounds(X, Y, Width, Height)
    local MX, MY = math.round(GetControlNormal(0, 239) * 1920) / 1920, math.round(GetControlNormal(0, 240) * 1080) / 1080
    X, Y = X / 1920, Y / 1080
    Width, Height = Width / 1920, Height / 1080
    return (MX >= X and MX <= X + Width) and (MY > Y and MY < Y + Height)
end

---GetSafeZoneBounds
---@return table
---@public
function SertyModuleUI.GetSafeZoneBounds()
    local SafeSize = GetSafeZoneSize()
    SafeSize = math.round(SafeSize, 2)
    SafeSize = (SafeSize * 100) - 90
    SafeSize = 10 - SafeSize

    local W, H = 1920, 1080

    return { X = math.round(SafeSize * ((W / H) * 5.4)), Y = math.round(SafeSize * 5.4) }
end
---GoUp
---@param Options number
---@return nil
---@public
function SertyModuleUI.GoUp(Options)
    if SertyModuleUI.CurrentMenu ~= nil then
        Options = SertyModuleUI.CurrentMenu.Options
        if SertyModuleUI.CurrentMenu() then
            if (Options ~= 0) then
                if Options > SertyModuleUI.CurrentMenu.Pagination.Total then
                    if SertyModuleUI.CurrentMenu.Index <= SertyModuleUI.CurrentMenu.Pagination.Minimum then
                        if SertyModuleUI.CurrentMenu.Index == 1 then
                            SertyModuleUI.CurrentMenu.Pagination.Minimum = Options - (SertyModuleUI.CurrentMenu.Pagination.Total - 1)
                            SertyModuleUI.CurrentMenu.Pagination.Maximum = Options
                            SertyModuleUI.CurrentMenu.Index = Options
                        else
                            SertyModuleUI.CurrentMenu.Pagination.Minimum = (SertyModuleUI.CurrentMenu.Pagination.Minimum - 1)
                            SertyModuleUI.CurrentMenu.Pagination.Maximum = (SertyModuleUI.CurrentMenu.Pagination.Maximum - 1)
                            SertyModuleUI.CurrentMenu.Index = SertyModuleUI.CurrentMenu.Index - 1
                        end
                    else
                        SertyModuleUI.CurrentMenu.Index = SertyModuleUI.CurrentMenu.Index - 1
                    end
                else
                    if SertyModuleUI.CurrentMenu.Index == 1 then
                        SertyModuleUI.CurrentMenu.Pagination.Minimum = Options - (SertyModuleUI.CurrentMenu.Pagination.Total - 1)
                        SertyModuleUI.CurrentMenu.Pagination.Maximum = Options
                        SertyModuleUI.CurrentMenu.Index = Options
                    else
                        SertyModuleUI.CurrentMenu.Index = SertyModuleUI.CurrentMenu.Index - 1
                    end
                end

                local Audio = SertyModuleUI.Settings.Audio
                SertyModuleUI.PlaySound(Audio[Audio.Use].UpDown.audioName, Audio[Audio.Use].UpDown.audioRef)
                SertyModuleUI.LastControl = true
            else
                local Audio = SertyModuleUI.Settings.Audio
                SertyModuleUI.PlaySound(Audio[Audio.Use].Error.audioName, Audio[Audio.Use].Error.audioRef)
            end
        end
    end
end

---GoDown
---@param Options number
---@return nil
---@public
function SertyModuleUI.GoDown(Options)
    if SertyModuleUI.CurrentMenu ~= nil then
        Options = SertyModuleUI.CurrentMenu.Options
        if SertyModuleUI.CurrentMenu() then
            if (Options ~= 0) then
                if Options > SertyModuleUI.CurrentMenu.Pagination.Total then
                    if SertyModuleUI.CurrentMenu.Index >= SertyModuleUI.CurrentMenu.Pagination.Maximum then
                        if SertyModuleUI.CurrentMenu.Index == Options then
                            SertyModuleUI.CurrentMenu.Pagination.Minimum = 1
                            SertyModuleUI.CurrentMenu.Pagination.Maximum = SertyModuleUI.CurrentMenu.Pagination.Total
                            SertyModuleUI.CurrentMenu.Index = 1
                        else
                            SertyModuleUI.CurrentMenu.Pagination.Maximum = (SertyModuleUI.CurrentMenu.Pagination.Maximum + 1)
                            SertyModuleUI.CurrentMenu.Pagination.Minimum = SertyModuleUI.CurrentMenu.Pagination.Maximum - (SertyModuleUI.CurrentMenu.Pagination.Total - 1)
                            SertyModuleUI.CurrentMenu.Index = SertyModuleUI.CurrentMenu.Index + 1
                        end
                    else
                        SertyModuleUI.CurrentMenu.Index = SertyModuleUI.CurrentMenu.Index + 1
                    end
                else
                    if SertyModuleUI.CurrentMenu.Index == Options then
                        SertyModuleUI.CurrentMenu.Pagination.Minimum = 1
                        SertyModuleUI.CurrentMenu.Pagination.Maximum = SertyModuleUI.CurrentMenu.Pagination.Total
                        SertyModuleUI.CurrentMenu.Index = 1
                    else
                        SertyModuleUI.CurrentMenu.Index = SertyModuleUI.CurrentMenu.Index + 1
                    end
                end
                local Audio = SertyModuleUI.Settings.Audio
                SertyModuleUI.PlaySound(Audio[Audio.Use].UpDown.audioName, Audio[Audio.Use].UpDown.audioRef)
                SertyModuleUI.LastControl = false
            else
                local Audio = SertyModuleUI.Settings.Audio
                SertyModuleUI.PlaySound(Audio[Audio.Use].Error.audioName, Audio[Audio.Use].Error.audioRef)
            end
        end
    end
end

function SertyModuleUI.GoLeft(Controls)
    if Controls.Left.Enabled then
        for Index = 1, #Controls.Left.Keys do
            if not Controls.Left.Pressed then
                if IsDisabledControlJustPressed(Controls.Left.Keys[Index][1], Controls.Left.Keys[Index][2]) then
                    Controls.Left.Pressed = true

                    Citizen.CreateThread(function()
                        Controls.Left.Active = true

                        Wait(0.01)

                        Controls.Left.Active = false

                        Wait(174.99)

                        while Controls.Left.Enabled and IsDisabledControlPressed(Controls.Left.Keys[Index][1], Controls.Left.Keys[Index][2]) do
                            Controls.Left.Active = true

                            Wait(0.01)

                            Controls.Left.Active = false

                            Wait(124.99)
                        end

                        Controls.Left.Pressed = false
                        Wait(10)
                    end)

                    break
                end
            end
        end
    end
end

function SertyModuleUI.GoRight(Controls)
    if Controls.Right.Enabled then
        for Index = 1, #Controls.Right.Keys do
            if not Controls.Right.Pressed then
                if IsDisabledControlJustPressed(Controls.Right.Keys[Index][1], Controls.Right.Keys[Index][2]) then
                    Controls.Right.Pressed = true

                    Citizen.CreateThread(function()
                        Controls.Right.Active = true

                        Wait(0.01)

                        Controls.Right.Active = false

                        Wait(174.99)

                        while Controls.Right.Enabled and IsDisabledControlPressed(Controls.Right.Keys[Index][1], Controls.Right.Keys[Index][2]) do
                            Controls.Right.Active = true

                            Wait(1)

                            Controls.Right.Active = false

                            Wait(124.99)
                        end

                        Controls.Right.Pressed = false
                        Wait(10)
                    end)

                    break
                end
            end
        end
    end
end

function SertyModuleUI.GoSliderLeft(Controls)
    if Controls.SliderLeft.Enabled then
        for Index = 1, #Controls.SliderLeft.Keys do
            if not Controls.SliderLeft.Pressed then
                if IsDisabledControlJustPressed(Controls.SliderLeft.Keys[Index][1], Controls.SliderLeft.Keys[Index][2]) then
                    Controls.SliderLeft.Pressed = true
                    Citizen.CreateThread(function()
                        Controls.SliderLeft.Active = true
                        Wait(1)
                        Controls.SliderLeft.Active = false
                        while Controls.SliderLeft.Enabled and IsDisabledControlPressed(Controls.SliderLeft.Keys[Index][1], Controls.SliderLeft.Keys[Index][2]) do
                            Controls.SliderLeft.Active = true
                            Wait(1)
                            Controls.SliderLeft.Active = false
                        end
                        Controls.SliderLeft.Pressed = false
                    end)
                    break
                end
            end
        end
    end
end

function SertyModuleUI.GoSliderRight(Controls)
    if Controls.SliderRight.Enabled then
        for Index = 1, #Controls.SliderRight.Keys do
            if not Controls.SliderRight.Pressed then
                if IsDisabledControlJustPressed(Controls.SliderRight.Keys[Index][1], Controls.SliderRight.Keys[Index][2]) then
                    Controls.SliderRight.Pressed = true
                    Citizen.CreateThread(function()
                        Controls.SliderRight.Active = true
                        Wait(1)
                        Controls.SliderRight.Active = false
                        while Controls.SliderRight.Enabled and IsDisabledControlPressed(Controls.SliderRight.Keys[Index][1], Controls.SliderRight.Keys[Index][2]) do
                            Controls.SliderRight.Active = true
                            Wait(1)
                            Controls.SliderRight.Active = false
                        end
                        Controls.SliderRight.Pressed = false
                    end)
                    break
                end
            end
        end
    end
end

---Controls
---@return nil
---@public
function SertyModuleUI.Controls()
    if SertyModuleUI.CurrentMenu ~= nil then
        if SertyModuleUI.CurrentMenu() then
            if SertyModuleUI.CurrentMenu.Open then

                local Controls = SertyModuleUI.CurrentMenu.Controls;
                ---@type number
                local Options = SertyModuleUI.CurrentMenu.Options
                SertyModuleUI.Options = SertyModuleUI.CurrentMenu.Options
                if SertyModuleUI.CurrentMenu.EnableMouse then
                    DisableAllControlActions(2)
                end

                if not IsInputDisabled(2) then
                    for Index = 1, #Controls.Enabled.Controller do
                        EnableControlAction(Controls.Enabled.Controller[Index][1], Controls.Enabled.Controller[Index][2], true)
                    end
                else
                    for Index = 1, #Controls.Enabled.Keyboard do
                        EnableControlAction(Controls.Enabled.Keyboard[Index][1], Controls.Enabled.Keyboard[Index][2], true)
                    end
                end

                if Controls.Up.Enabled then
                    for Index = 1, #Controls.Up.Keys do
                        if not Controls.Up.Pressed then
                            if IsDisabledControlJustPressed(Controls.Up.Keys[Index][1], Controls.Up.Keys[Index][2]) then
                                Controls.Up.Pressed = true

                                Citizen.CreateThread(function()
                                    SertyModuleUI.GoUp(Options)

                                    Wait(175)

                                    while Controls.Up.Enabled and IsDisabledControlPressed(Controls.Up.Keys[Index][1], Controls.Up.Keys[Index][2]) do
                                        SertyModuleUI.GoUp(Options)

                                        Wait(50)
                                    end

                                    Controls.Up.Pressed = false
                                end)

                                break
                            end
                        end
                    end
                end

                if Controls.Down.Enabled then
                    for Index = 1, #Controls.Down.Keys do
                        if not Controls.Down.Pressed then
                            if IsDisabledControlJustPressed(Controls.Down.Keys[Index][1], Controls.Down.Keys[Index][2]) then
                                Controls.Down.Pressed = true

                                Citizen.CreateThread(function()
                                    SertyModuleUI.GoDown(Options)

                                    Wait(175)

                                    while Controls.Down.Enabled and IsDisabledControlPressed(Controls.Down.Keys[Index][1], Controls.Down.Keys[Index][2]) do
                                        SertyModuleUI.GoDown(Options)

                                        Wait(50)
                                    end

                                    Controls.Down.Pressed = false
                                end)

                                break
                            end
                        end
                    end
                end

                SertyModuleUI.GoLeft(Controls)
                --- Default Left navigation
                SertyModuleUI.GoRight(Controls) --- Default Right navigation

                SertyModuleUI.GoSliderLeft(Controls)
                SertyModuleUI.GoSliderRight(Controls)

                if Controls.Select.Enabled then
                    for Index = 1, #Controls.Select.Keys do
                        if not Controls.Select.Pressed then
                            if IsDisabledControlJustPressed(Controls.Select.Keys[Index][1], Controls.Select.Keys[Index][2]) then
                                Controls.Select.Pressed = true

                                Citizen.CreateThread(function()
                                    Controls.Select.Active = true

                                    Wait(0.01)

                                    Controls.Select.Active = false

                                    Wait(174.99)

                                    while Controls.Select.Enabled and IsDisabledControlPressed(Controls.Select.Keys[Index][1], Controls.Select.Keys[Index][2]) do
                                        Controls.Select.Active = true

                                        Wait(0.01)

                                        Controls.Select.Active = false

                                        Wait(124.99)
                                    end

                                    Controls.Select.Pressed = false

                                end)

                                break
                            end
                        end
                    end
                end

                if Controls.Click.Enabled then
                    for Index = 1, #Controls.Click.Keys do
                        if not Controls.Click.Pressed then
                            if IsDisabledControlJustPressed(Controls.Click.Keys[Index][1], Controls.Click.Keys[Index][2]) then
                                Controls.Click.Pressed = true

                                Citizen.CreateThread(function()
                                    Controls.Click.Active = true

                                    Wait(0.01)

                                    Controls.Click.Active = false

                                    Wait(174.99)

                                    while Controls.Click.Enabled and IsDisabledControlPressed(Controls.Click.Keys[Index][1], Controls.Click.Keys[Index][2]) do
                                        Controls.Click.Active = true

                                        Wait(0.01)

                                        Controls.Click.Active = false

                                        Wait(124.99)
                                    end

                                    Controls.Click.Pressed = false
                                end)

                                break
                            end
                        end
                    end
                end
                if Controls.Back.Enabled then
                    for Index = 1, #Controls.Back.Keys do
                        if not Controls.Back.Pressed then
                            if IsDisabledControlJustPressed(Controls.Back.Keys[Index][1], Controls.Back.Keys[Index][2]) then
                                Controls.Back.Pressed = true
                                Wait(10)
                                break
                            end
                        end
                    end
                end

            end
        end
    end
end

---Navigation
---@return nil
---@public
function SertyModuleUI.Navigation()
    if SertyModuleUI.CurrentMenu ~= nil then
        if SertyModuleUI.CurrentMenu() then
            if SertyModuleUI.CurrentMenu.EnableMouse   then
                SetMouseCursorActiveThisFrame()
            end
            if SertyModuleUI.Options > SertyModuleUI.CurrentMenu.Pagination.Total then

                ---@type boolean
                local UpHovered = false

                ---@type boolean
                local DownHovered = false

                if not SertyModuleUI.CurrentMenu.SafeZoneSize then
                    SertyModuleUI.CurrentMenu.SafeZoneSize = { X = 0, Y = 0 }

                    if SertyModuleUI.CurrentMenu.Safezone then
                        SertyModuleUI.CurrentMenu.SafeZoneSize = SertyModuleUI.GetSafeZoneBounds()

                        SetScriptGfxAlign(76, 84)
                        SetScriptGfxAlignParams(0, 0, 0, 0)
                    end
                end

                UpHovered = SertyModuleUI.IsMouseInBounds(SertyModuleUI.CurrentMenu.X + SertyModuleUI.CurrentMenu.SafeZoneSize.X, SertyModuleUI.CurrentMenu.Y + SertyModuleUI.CurrentMenu.SafeZoneSize.Y + SertyModuleUI.CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, SertyModuleUI.Settings.Items.Navigation.Rectangle.Width + SertyModuleUI.CurrentMenu.WidthOffset, SertyModuleUI.Settings.Items.Navigation.Rectangle.Height)
                DownHovered = SertyModuleUI.IsMouseInBounds(SertyModuleUI.CurrentMenu.X + SertyModuleUI.CurrentMenu.SafeZoneSize.X, SertyModuleUI.CurrentMenu.Y + SertyModuleUI.Settings.Items.Navigation.Rectangle.Height + SertyModuleUI.CurrentMenu.SafeZoneSize.Y + SertyModuleUI.CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, SertyModuleUI.Settings.Items.Navigation.Rectangle.Width + SertyModuleUI.CurrentMenu.WidthOffset, SertyModuleUI.Settings.Items.Navigation.Rectangle.Height)

                if SertyModuleUI.CurrentMenu.EnableMouse   then


                    if SertyModuleUI.CurrentMenu.Controls.Click.Active then
                        if UpHovered then
                            SertyModuleUI.GoUp(SertyModuleUI.Options)
                        elseif DownHovered then
                            SertyModuleUI.GoDown(SertyModuleUI.Options)
                        end
                    end

                    if UpHovered then
                        RenderRectangle(SertyModuleUI.CurrentMenu.X, SertyModuleUI.CurrentMenu.Y + SertyModuleUI.CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, SertyModuleUI.Settings.Items.Navigation.Rectangle.Width + SertyModuleUI.CurrentMenu.WidthOffset, SertyModuleUI.Settings.Items.Navigation.Rectangle.Height, 30, 30, 30, 255)
                    else
                        RenderRectangle(SertyModuleUI.CurrentMenu.X, SertyModuleUI.CurrentMenu.Y + SertyModuleUI.CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, SertyModuleUI.Settings.Items.Navigation.Rectangle.Width + SertyModuleUI.CurrentMenu.WidthOffset, SertyModuleUI.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                    end

                    if DownHovered then
                        RenderRectangle(SertyModuleUI.CurrentMenu.X, SertyModuleUI.CurrentMenu.Y + SertyModuleUI.Settings.Items.Navigation.Rectangle.Height + SertyModuleUI.CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, SertyModuleUI.Settings.Items.Navigation.Rectangle.Width + SertyModuleUI.CurrentMenu.WidthOffset, SertyModuleUI.Settings.Items.Navigation.Rectangle.Height, 30, 30, 30, 255)
                    else
                        RenderRectangle(SertyModuleUI.CurrentMenu.X, SertyModuleUI.CurrentMenu.Y + SertyModuleUI.Settings.Items.Navigation.Rectangle.Height + SertyModuleUI.CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, SertyModuleUI.Settings.Items.Navigation.Rectangle.Width + SertyModuleUI.CurrentMenu.WidthOffset, SertyModuleUI.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                    end
                else
                    RenderRectangle(SertyModuleUI.CurrentMenu.X, SertyModuleUI.CurrentMenu.Y + SertyModuleUI.CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, SertyModuleUI.Settings.Items.Navigation.Rectangle.Width + SertyModuleUI.CurrentMenu.WidthOffset, SertyModuleUI.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                    RenderRectangle(SertyModuleUI.CurrentMenu.X, SertyModuleUI.CurrentMenu.Y + SertyModuleUI.Settings.Items.Navigation.Rectangle.Height + SertyModuleUI.CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, SertyModuleUI.Settings.Items.Navigation.Rectangle.Width + SertyModuleUI.CurrentMenu.WidthOffset, SertyModuleUI.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                end
                RenderSprite(SertyModuleUI.Settings.Items.Navigation.Arrows.Dictionary, SertyModuleUI.Settings.Items.Navigation.Arrows.Texture, SertyModuleUI.CurrentMenu.X + SertyModuleUI.Settings.Items.Navigation.Arrows.X + (SertyModuleUI.CurrentMenu.WidthOffset / 2), SertyModuleUI.CurrentMenu.Y + SertyModuleUI.Settings.Items.Navigation.Arrows.Y + SertyModuleUI.CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, SertyModuleUI.Settings.Items.Navigation.Arrows.Width, SertyModuleUI.Settings.Items.Navigation.Arrows.Height)

                SertyModuleUI.ItemOffset = SertyModuleUI.ItemOffset + (SertyModuleUI.Settings.Items.Navigation.Rectangle.Height * 2)

            end
        end
    end
end

---GoBack
---@return nil
---@public
function SertyModuleUI.GoBack()
    if SertyModuleUI.CurrentMenu ~= nil then
        local Audio = SertyModuleUI.Settings.Audio
        SertyModuleUI.PlaySound(Audio[Audio.Use].Back.audioName, Audio[Audio.Use].Back.audioRef)
        if SertyModuleUI.CurrentMenu.Parent ~= nil then
            if SertyModuleUI.CurrentMenu.Parent() then
                SertyModuleUI.NextMenu = SertyModuleUI.CurrentMenu.Parent
            else
                SertyModuleUI.NextMenu = nil
                SertyModuleUI.Visible(SertyModuleUI.CurrentMenu, false)
            end
        else
            SertyModuleUI.NextMenu = nil
            SertyModuleUI.Visible(SertyModuleUI.CurrentMenu, false)
        end
    end
end
