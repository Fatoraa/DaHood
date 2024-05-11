---@type table
VIPUI.LastControl = false

---IsMouseInBounds
---@param X number
---@param Y number
---@param Width number
---@param Height number
---@return number
---@public
function VIPUI.IsMouseInBounds(X, Y, Width, Height)
    local MX, MY = math.round(GetControlNormal(2, 239) * 1920) / 1920, math.round(GetControlNormal(2, 240) * 1080) / 1080
    X, Y = X / 1920, Y / 1080
    Width, Height = Width / 1920, Height / 1080
    return (MX >= X and MX <= X + Width) and (MY > Y and MY < Y + Height)
end

---GetSafeZoneBounds
---@return table
---@public
function VIPUI.GetSafeZoneBounds()
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
function VIPUI.GoUp(Options)
    if VIPUI.CurrentMenu ~= nil then
        Options = VIPUI.CurrentMenu.Options
        if VIPUI.CurrentMenu() then
            if (Options ~= 0) then
                if Options > VIPUI.CurrentMenu.Pagination.Total then
                    if VIPUI.CurrentMenu.Index <= VIPUI.CurrentMenu.Pagination.Minimum then
                        if VIPUI.CurrentMenu.Index == 1 then
                            VIPUI.CurrentMenu.Pagination.Minimum = Options - (VIPUI.CurrentMenu.Pagination.Total - 1)
                            VIPUI.CurrentMenu.Pagination.Maximum = Options
                            VIPUI.CurrentMenu.Index = Options
                        else
                            VIPUI.CurrentMenu.Pagination.Minimum = (VIPUI.CurrentMenu.Pagination.Minimum - 1)
                            VIPUI.CurrentMenu.Pagination.Maximum = (VIPUI.CurrentMenu.Pagination.Maximum - 1)
                            VIPUI.CurrentMenu.Index = VIPUI.CurrentMenu.Index - 1
                        end
                    else
                        VIPUI.CurrentMenu.Index = VIPUI.CurrentMenu.Index - 1
                    end
                else
                    if VIPUI.CurrentMenu.Index == 1 then
                        VIPUI.CurrentMenu.Pagination.Minimum = Options - (VIPUI.CurrentMenu.Pagination.Total - 1)
                        VIPUI.CurrentMenu.Pagination.Maximum = Options
                        VIPUI.CurrentMenu.Index = Options
                    else
                        VIPUI.CurrentMenu.Index = VIPUI.CurrentMenu.Index - 1
                    end
                end

                local Audio = VIPUI.Settings.Audio
                VIPUI.PlaySound(Audio[Audio.Use].UpDown.audioName, Audio[Audio.Use].UpDown.audioRef)
                VIPUI.LastControl = true
                if (VIPUI.CurrentMenu.onIndexChange ~= nil) then
                    VIPUI.CurrentMenu.onIndexChange(VIPUI.CurrentMenu.Index)
                end
            else
                local Audio = VIPUI.Settings.Audio
                VIPUI.PlaySound(Audio[Audio.Use].Error.audioName, Audio[Audio.Use].Error.audioRef)
            end
        end
    end
end

---GoDown
---@param Options number
---@return nil
---@public
function VIPUI.GoDown(Options)
    if VIPUI.CurrentMenu ~= nil then
        Options = VIPUI.CurrentMenu.Options
        if VIPUI.CurrentMenu() then
            if (Options ~= 0) then
                if Options > VIPUI.CurrentMenu.Pagination.Total then
                    if VIPUI.CurrentMenu.Index >= VIPUI.CurrentMenu.Pagination.Maximum then
                        if VIPUI.CurrentMenu.Index == Options then
                            VIPUI.CurrentMenu.Pagination.Minimum = 1
                            VIPUI.CurrentMenu.Pagination.Maximum = VIPUI.CurrentMenu.Pagination.Total
                            VIPUI.CurrentMenu.Index = 1
                        else
                            VIPUI.CurrentMenu.Pagination.Maximum = (VIPUI.CurrentMenu.Pagination.Maximum + 1)
                            VIPUI.CurrentMenu.Pagination.Minimum = VIPUI.CurrentMenu.Pagination.Maximum - (VIPUI.CurrentMenu.Pagination.Total - 1)
                            VIPUI.CurrentMenu.Index = VIPUI.CurrentMenu.Index + 1
                        end
                    else
                        VIPUI.CurrentMenu.Index = VIPUI.CurrentMenu.Index + 1
                    end
                else
                    if VIPUI.CurrentMenu.Index == Options then
                        VIPUI.CurrentMenu.Pagination.Minimum = 1
                        VIPUI.CurrentMenu.Pagination.Maximum = VIPUI.CurrentMenu.Pagination.Total
                        VIPUI.CurrentMenu.Index = 1
                    else
                        VIPUI.CurrentMenu.Index = VIPUI.CurrentMenu.Index + 1
                    end
                end
                local Audio = VIPUI.Settings.Audio
                VIPUI.PlaySound(Audio[Audio.Use].UpDown.audioName, Audio[Audio.Use].UpDown.audioRef)
                VIPUI.LastControl = false
                if (VIPUI.CurrentMenu.onIndexChange ~= nil) then
                    VIPUI.CurrentMenu.onIndexChange(VIPUI.CurrentMenu.Index)
                end
            else
                local Audio = VIPUI.Settings.Audio
                VIPUI.PlaySound(Audio[Audio.Use].Error.audioName, Audio[Audio.Use].Error.audioRef)
            end
        end
    end
end

function VIPUI.GoLeft(Controls)
    if Controls.Left.Enabled then
        for Index = 1, #Controls.Left.Keys do
            if not Controls.Left.Pressed then
                if IsDisabledControlJustPressed(Controls.Left.Keys[Index][1], Controls.Left.Keys[Index][2]) then
                    Controls.Left.Pressed = true

                    Citizen.CreateThread(function()
                        Controls.Left.Active = true

                        Citizen.Wait(0.01)

                        Controls.Left.Active = false

                        Citizen.Wait(174.99)

                        while Controls.Left.Enabled and IsDisabledControlPressed(Controls.Left.Keys[Index][1], Controls.Left.Keys[Index][2]) do
                            Controls.Left.Active = true

                            Citizen.Wait(0.01)

                            Controls.Left.Active = false

                            Citizen.Wait(124.99)
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

function VIPUI.GoRight(Controls)
    if Controls.Right.Enabled then
        for Index = 1, #Controls.Right.Keys do
            if not Controls.Right.Pressed then
                if IsDisabledControlJustPressed(Controls.Right.Keys[Index][1], Controls.Right.Keys[Index][2]) then
                    Controls.Right.Pressed = true

                    Citizen.CreateThread(function()
                        Controls.Right.Active = true

                        Citizen.Wait(0.01)

                        Controls.Right.Active = false

                        Citizen.Wait(174.99)

                        while Controls.Right.Enabled and IsDisabledControlPressed(Controls.Right.Keys[Index][1], Controls.Right.Keys[Index][2]) do
                            Controls.Right.Active = true

                            Citizen.Wait(1)

                            Controls.Right.Active = false

                            Citizen.Wait(124.99)
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

function VIPUI.GoSliderLeft(Controls)
    if Controls.SliderLeft.Enabled then
        for Index = 1, #Controls.SliderLeft.Keys do
            if not Controls.SliderLeft.Pressed then
                if IsDisabledControlJustPressed(Controls.SliderLeft.Keys[Index][1], Controls.SliderLeft.Keys[Index][2]) then
                    Controls.SliderLeft.Pressed = true
                    Citizen.CreateThread(function()
                        Controls.SliderLeft.Active = true
                        Citizen.Wait(1)
                        Controls.SliderLeft.Active = false
                        while Controls.SliderLeft.Enabled and IsDisabledControlPressed(Controls.SliderLeft.Keys[Index][1], Controls.SliderLeft.Keys[Index][2]) do
                            Controls.SliderLeft.Active = true
                            Citizen.Wait(1)
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

function VIPUI.GoSliderRight(Controls)
    if Controls.SliderRight.Enabled then
        for Index = 1, #Controls.SliderRight.Keys do
            if not Controls.SliderRight.Pressed then
                if IsDisabledControlJustPressed(Controls.SliderRight.Keys[Index][1], Controls.SliderRight.Keys[Index][2]) then
                    Controls.SliderRight.Pressed = true
                    Citizen.CreateThread(function()
                        Controls.SliderRight.Active = true
                        Citizen.Wait(1)
                        Controls.SliderRight.Active = false
                        while Controls.SliderRight.Enabled and IsDisabledControlPressed(Controls.SliderRight.Keys[Index][1], Controls.SliderRight.Keys[Index][2]) do
                            Controls.SliderRight.Active = true
                            Citizen.Wait(1)
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
function VIPUI.Controls()
    if VIPUI.CurrentMenu ~= nil then
        if VIPUI.CurrentMenu() then
            if VIPUI.CurrentMenu.Open then

                local Controls = VIPUI.CurrentMenu.Controls;
                ---@type number
                local Options = VIPUI.CurrentMenu.Options
                VIPUI.Options = VIPUI.CurrentMenu.Options
                if VIPUI.CurrentMenu.EnableMouse then
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
                                    VIPUI.GoUp(Options)

                                    Citizen.Wait(175)

                                    while Controls.Up.Enabled and IsDisabledControlPressed(Controls.Up.Keys[Index][1], Controls.Up.Keys[Index][2]) do
                                        VIPUI.GoUp(Options)

                                        Citizen.Wait(50)
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
                                    VIPUI.GoDown(Options)

                                    Citizen.Wait(175)

                                    while Controls.Down.Enabled and IsDisabledControlPressed(Controls.Down.Keys[Index][1], Controls.Down.Keys[Index][2]) do
                                        VIPUI.GoDown(Options)

                                        Citizen.Wait(50)
                                    end

                                    Controls.Down.Pressed = false
                                end)

                                break
                            end
                        end
                    end
                end

                VIPUI.GoLeft(Controls)
                --- Default Left navigation
                VIPUI.GoRight(Controls) --- Default Right navigation

                VIPUI.GoSliderLeft(Controls)
                VIPUI.GoSliderRight(Controls)

                if Controls.Select.Enabled then
                    for Index = 1, #Controls.Select.Keys do
                        if not Controls.Select.Pressed then
                            if IsDisabledControlJustPressed(Controls.Select.Keys[Index][1], Controls.Select.Keys[Index][2]) then
                                Controls.Select.Pressed = true

                                Citizen.CreateThread(function()
                                    Controls.Select.Active = true

                                    Citizen.Wait(0.01)

                                    Controls.Select.Active = false

                                    Citizen.Wait(174.99)

                                    while Controls.Select.Enabled and IsDisabledControlPressed(Controls.Select.Keys[Index][1], Controls.Select.Keys[Index][2]) do
                                        Controls.Select.Active = true

                                        Citizen.Wait(0.01)

                                        Controls.Select.Active = false

                                        Citizen.Wait(124.99)
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

                                    Citizen.Wait(0.01)

                                    Controls.Click.Active = false

                                    Citizen.Wait(174.99)

                                    while Controls.Click.Enabled and IsDisabledControlPressed(Controls.Click.Keys[Index][1], Controls.Click.Keys[Index][2]) do
                                        Controls.Click.Active = true

                                        Citizen.Wait(0.01)

                                        Controls.Click.Active = false

                                        Citizen.Wait(124.99)
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
function VIPUI.Navigation()
    if VIPUI.CurrentMenu ~= nil then
        if VIPUI.CurrentMenu() then
            if VIPUI.CurrentMenu.EnableMouse then
                SetMouseCursorActiveThisFrame()
            end
            if VIPUI.Options > VIPUI.CurrentMenu.Pagination.Total then

                ---@type boolean
                local UpHovered = false

                ---@type boolean
                local DownHovered = false

                if not VIPUI.CurrentMenu.SafeZoneSize then
                    VIPUI.CurrentMenu.SafeZoneSize = { X = 0, Y = 0 }

                    if VIPUI.CurrentMenu.Safezone then
                        VIPUI.CurrentMenu.SafeZoneSize = VIPUI.GetSafeZoneBounds()

                        SetScriptGfxAlign(76, 84)
                        SetScriptGfxAlignParams(0, 0, 0, 0)
                    end
                end

                UpHovered = VIPUI.IsMouseInBounds(VIPUI.CurrentMenu.X + VIPUI.CurrentMenu.SafeZoneSize.X, VIPUI.CurrentMenu.Y + VIPUI.CurrentMenu.SafeZoneSize.Y + VIPUI.CurrentMenu.SubtitleHeight + VIPUI.ItemOffset, VIPUI.Settings.Items.Navigation.Rectangle.Width + VIPUI.CurrentMenu.WidthOffset, VIPUI.Settings.Items.Navigation.Rectangle.Height)
                DownHovered = VIPUI.IsMouseInBounds(VIPUI.CurrentMenu.X + VIPUI.CurrentMenu.SafeZoneSize.X, VIPUI.CurrentMenu.Y + VIPUI.Settings.Items.Navigation.Rectangle.Height + VIPUI.CurrentMenu.SafeZoneSize.Y + VIPUI.CurrentMenu.SubtitleHeight + VIPUI.ItemOffset, VIPUI.Settings.Items.Navigation.Rectangle.Width + VIPUI.CurrentMenu.WidthOffset, VIPUI.Settings.Items.Navigation.Rectangle.Height)

                if VIPUI.CurrentMenu.EnableMouse then


                    if VIPUI.CurrentMenu.Controls.Click.Active then
                        if UpHovered then
                            VIPUI.GoUp(VIPUI.Options)
                        elseif DownHovered then
                            VIPUI.GoDown(VIPUI.Options)
                        end
                    end

                    if UpHovered then
                        RenderRectangle(VIPUI.CurrentMenu.X, VIPUI.CurrentMenu.Y + VIPUI.CurrentMenu.SubtitleHeight + VIPUI.ItemOffset, VIPUI.Settings.Items.Navigation.Rectangle.Width + VIPUI.CurrentMenu.WidthOffset, VIPUI.Settings.Items.Navigation.Rectangle.Height, 30, 30, 30, 255)
                    else
                        RenderRectangle(VIPUI.CurrentMenu.X, VIPUI.CurrentMenu.Y + VIPUI.CurrentMenu.SubtitleHeight + VIPUI.ItemOffset, VIPUI.Settings.Items.Navigation.Rectangle.Width + VIPUI.CurrentMenu.WidthOffset, VIPUI.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                    end

                    if DownHovered then
                        RenderRectangle(VIPUI.CurrentMenu.X, VIPUI.CurrentMenu.Y + VIPUI.Settings.Items.Navigation.Rectangle.Height + VIPUI.CurrentMenu.SubtitleHeight + VIPUI.ItemOffset, VIPUI.Settings.Items.Navigation.Rectangle.Width + VIPUI.CurrentMenu.WidthOffset, VIPUI.Settings.Items.Navigation.Rectangle.Height, 30, 30, 30, 255)
                    else
                        RenderRectangle(VIPUI.CurrentMenu.X, VIPUI.CurrentMenu.Y + VIPUI.Settings.Items.Navigation.Rectangle.Height + VIPUI.CurrentMenu.SubtitleHeight + VIPUI.ItemOffset, VIPUI.Settings.Items.Navigation.Rectangle.Width + VIPUI.CurrentMenu.WidthOffset, VIPUI.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                    end
                else
                    RenderRectangle(VIPUI.CurrentMenu.X, VIPUI.CurrentMenu.Y + VIPUI.CurrentMenu.SubtitleHeight + VIPUI.ItemOffset, VIPUI.Settings.Items.Navigation.Rectangle.Width + VIPUI.CurrentMenu.WidthOffset, VIPUI.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                    RenderRectangle(VIPUI.CurrentMenu.X, VIPUI.CurrentMenu.Y + VIPUI.Settings.Items.Navigation.Rectangle.Height + VIPUI.CurrentMenu.SubtitleHeight + VIPUI.ItemOffset, VIPUI.Settings.Items.Navigation.Rectangle.Width + VIPUI.CurrentMenu.WidthOffset, VIPUI.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                end
                RenderSprite(VIPUI.Settings.Items.Navigation.Arrows.Dictionary, VIPUI.Settings.Items.Navigation.Arrows.Texture, VIPUI.CurrentMenu.X + VIPUI.Settings.Items.Navigation.Arrows.X + (VIPUI.CurrentMenu.WidthOffset / 2), VIPUI.CurrentMenu.Y + VIPUI.Settings.Items.Navigation.Arrows.Y + VIPUI.CurrentMenu.SubtitleHeight + VIPUI.ItemOffset, VIPUI.Settings.Items.Navigation.Arrows.Width, VIPUI.Settings.Items.Navigation.Arrows.Height)

                VIPUI.ItemOffset = VIPUI.ItemOffset + (VIPUI.Settings.Items.Navigation.Rectangle.Height * 2)

            end
        end
    end
end

---GoBack
---@return nil
---@public
function VIPUI.GoBack()
    if VIPUI.CurrentMenu ~= nil then
        local Audio = VIPUI.Settings.Audio
        VIPUI.PlaySound(Audio[Audio.Use].Back.audioName, Audio[Audio.Use].Back.audioRef)
        if VIPUI.CurrentMenu.Parent ~= nil then
            if VIPUI.CurrentMenu.Parent() then
                VIPUI.NextMenu = VIPUI.CurrentMenu.Parent
            else
                VIPUI.NextMenu = nil
                VIPUI.Visible(VIPUI.CurrentMenu, false)
            end
        else
            VIPUI.NextMenu = nil
            VIPUI.Visible(VIPUI.CurrentMenu, false)
        end
    end
end
