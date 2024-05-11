---@type table
local SettingsButton = {
    Rectangle = { Y = 0, Width = 431, Height = 38 },
    Text = { X = 8, Y = 3, Scale = 0.33 },
    LeftBadge = { Y = -2, Width = 40, Height = 40 },
    RightBadge = { X = 385, Y = -2, Width = 40, Height = 40 },
    RightText = { X = 420, Y = 4, Scale = 0.35 },
    SelectedSprite = { Dictionary = "kikizizinazi", Texture = "gradient_nav", Y = 0, Width = 431, Height = 38 },
}

---Button
---@param Label string
---@param Description string
---@param Enabled boolean
---@param Callback function
---@param Submenu table
---@return nil
---@public
function SertyModuleUI.Button(Label, Description, Enabled, Callback, Submenu)
    local CurrentMenu = SertyModuleUI.CurrentMenu
    if CurrentMenu ~= nil and CurrentMenu() then
        ---@type number
        local Option = SertyModuleUI.Options + 1

        if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
            ---@type boolean
            local Active = CurrentMenu.Index == Option

            SertyModuleUI.ItemsSafeZone(CurrentMenu)

            if Active then
                RenderSprite(SettingsButton.SelectedSprite.Dictionary, SettingsButton.SelectedSprite.Texture, CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height)
            end

            local colorData = Enabled and (Active and { 0, 0, 0 } or { 255, 255, 255 }) or { 163, 159, 148 }
            RenderText(Label, CurrentMenu.X + SettingsButton.Text.X, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, 0, SettingsButton.Text.Scale, colorData[1], colorData[2], colorData[3], 255)

            SertyModuleUI.ItemOffset = SertyModuleUI.ItemOffset + SettingsButton.Rectangle.Height

            SertyModuleUI.ItemsDescription(CurrentMenu, Description, Active);

            if Enabled then
                ---@type boolean
                local Hovered = CurrentMenu.EnableMouse and (CurrentMenu.CursorStyle == 0 or CurrentMenu.CursorStyle == 1) and SertyModuleUI.ItemsMouseBounds(CurrentMenu, Active, Option + 1, SettingsButton);
                local Selected = (CurrentMenu.Controls.Select.Active or (Hovered and CurrentMenu.Controls.Click.Active)) and Active

                if Callback then
                    Callback(Hovered, Active, Selected)
                end

                if Selected then
                    local Audio = SertyModuleUI.Settings.Audio
                    SertyModuleUI.PlaySound(Audio[Audio.Use].Select.audioName, Audio[Audio.Use].Select.audioRef)

                    if Submenu and Submenu() then
                        SertyModuleUI.NextMenu = Submenu
                    end
                end
            end
        end

        SertyModuleUI.Options = SertyModuleUI.Options + 1
    end
end

---ButtonWithStyle
---@param Label string
---@param Description string
---@param Style table
---@param Enabled boolean
---@param Callback function
---@param Submenu table
---@return nil
---@public
function SertyModuleUI.ButtonWithStyle(Label, Description, Style, Enabled, Callback, Submenu)
    local CurrentMenu = SertyModuleUI.CurrentMenu
    if CurrentMenu ~= nil and CurrentMenu() then
        ---@type number
        local Option = SertyModuleUI.Options + 1

        if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
            ---@type boolean
            local Active = CurrentMenu.Index == Option

            SertyModuleUI.ItemsSafeZone(CurrentMenu)

            local haveLeftBadge = Style.LeftBadge and Style.LeftBadge ~= SertyModuleUI.BadgeStyle.None
            local haveRightBadge = (Style.RightBadge and Style.RightBadge ~= SertyModuleUI.BadgeStyle.None) or (not Enabled and Style.LockBadge ~= SertyModuleUI.BadgeStyle.None)

            local LeftBadgeOffset = haveLeftBadge and 27 or 0
            local RightBadgeOffset = haveRightBadge and 32 or 0

            if Style.Color and Style.Color.BackgroundColor then
                RenderRectangle(CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height, Style.Color.BackgroundColor[1], Style.Color.BackgroundColor[2], Style.Color.BackgroundColor[3])
            end

            if Active then
                if Style.Color and Style.Color.HightLightColor then
                    RenderRectangle(CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height, Style.Color.HightLightColor[1], Style.Color.HightLightColor[2], Style.Color.HightLightColor[3])
                else
                    RenderSprite(SettingsButton.SelectedSprite.Dictionary, SettingsButton.SelectedSprite.Texture, CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height)
                end
            end

            if Enabled then
                if haveLeftBadge then
                    local LeftBadge = Style.LeftBadge(Active)
                    RenderSprite(LeftBadge.BadgeDictionary or "kikizizinazi", LeftBadge.BadgeTexture or "", CurrentMenu.X, CurrentMenu.Y + SettingsButton.LeftBadge.Y + CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, SettingsButton.LeftBadge.Width, SettingsButton.LeftBadge.Height, 0, LeftBadge.BadgeColour and LeftBadge.BadgeColour.R or 255, LeftBadge.BadgeColour and LeftBadge.BadgeColour.G or 255, LeftBadge.BadgeColour and LeftBadge.BadgeColour.B or 255, LeftBadge.BadgeColour and LeftBadge.BadgeColour.A or 255)
                end

                if haveRightBadge then
                    local RightBadge = Style.RightBadge(Active)
                    RenderSprite(RightBadge.BadgeDictionary or "kikizizinazi", RightBadge.BadgeTexture or "", CurrentMenu.X + SettingsButton.RightBadge.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightBadge.Y + CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, SettingsButton.RightBadge.Width, SettingsButton.RightBadge.Height, 0, RightBadge.BadgeColour and RightBadge.BadgeColour.R or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.G or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.B or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.A or 255)
                end

                if Style.RightLabel then
                    RenderText(Style.RightLabel, CurrentMenu.X + SettingsButton.RightText.X - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightText.Y + CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, 0, SettingsButton.RightText.Scale, Active and 0 or 245, Active and 0 or 245, Active and 0 or 245, 255, 2)
                end

                RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, 0, SettingsButton.Text.Scale, Active and 0 or 245, Active and 0 or 245, Active and 0 or 245, 255)
            else
                if haveRightBadge then
                    local RightBadge = SertyModuleUI.BadgeStyle.Lock(Active)
                    RenderSprite(RightBadge.BadgeDictionary or "kikizizinazi", RightBadge.BadgeTexture or "", CurrentMenu.X + SettingsButton.RightBadge.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightBadge.Y + CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, SettingsButton.RightBadge.Width, SettingsButton.RightBadge.Height, 0, RightBadge.BadgeColour and RightBadge.BadgeColour.R or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.G or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.B or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.A or 255)
                end

                RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, 0, SettingsButton.Text.Scale, 163, 159, 148, 255)
            end

            SertyModuleUI.ItemOffset = SertyModuleUI.ItemOffset + SettingsButton.Rectangle.Height

            SertyModuleUI.ItemsDescription(CurrentMenu, Description, Active);

            if Enabled then
                ---@type boolean
                local Hovered = CurrentMenu.EnableMouse and (CurrentMenu.CursorStyle == 0 or CurrentMenu.CursorStyle == 1) and SertyModuleUI.ItemsMouseBounds(CurrentMenu, Active, Option + 1, SettingsButton);
                local Selected = (CurrentMenu.Controls.Select.Active or (Hovered and CurrentMenu.Controls.Click.Active)) and Active

                if Callback then
                    Callback(Hovered, Active, Selected)
                end

                if Selected then
                    local Audio = SertyModuleUI.Settings.Audio
                    SertyModuleUI.PlaySound(Audio[Audio.Use].Select.audioName, Audio[Audio.Use].Select.audioRef)

                    if Submenu and Submenu() then
                        SertyModuleUI.NextMenu = Submenu
                    end
                end
            end

        end

        SertyModuleUI.Options = SertyModuleUI.Options + 1
    end
end

function SertyModuleUI.Button(Label, Description, Style, Enabled, Callback, Submenu)


    ---@type table
    local CurrentMenu = SertyModuleUI.CurrentMenu;

    if CurrentMenu ~= nil then
        if CurrentMenu() then

            ---@type number
            local Option = SertyModuleUI.Options + 1

            if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then

                ---@type boolean
                local Selected = CurrentMenu.Index == Option

                SertyModuleUI.ItemsSafeZone(CurrentMenu)

                local LeftBadgeOffset = ((Style.LeftBadge == SertyModuleUI.BadgeStyle.None or tonumber(Style.LeftBadge) == nil) and 0 or 27)
                local RightBadgeOffset = ((Style.RightBadge == SertyModuleUI.BadgeStyle.None or tonumber(Style.RightBadge) == nil) and 0 or 32)

                local Hovered = false;
                if Style.Color ~= nil then
                    if Style.Color.BackgroundColor ~= nil then
                        RenderRectangle(CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height, Style.Color.BackgroundColor[1], Style.Color.BackgroundColor[2], Style.Color.BackgroundColor[3], Style.Color.BackgroundColor[4])
                    end
                end
                ---@type boolean
                if CurrentMenu.EnableMouse == true then
                    Hovered = SertyModuleUI.ItemsMouseBounds(CurrentMenu, Selected, Option, SettingsButton);
                end

                RenderRectangle(CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height, 255, 255, 255, 0)

                if Selected then
                    if Style.Color == nil then
                        RenderSprite(SettingsButton.SelectedSprite.Dictionary, SettingsButton.SelectedSprite.Texture, CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height)
                    end

                    if Style.Color ~= nil and Style.Color.HightLightColor ~= nil then
                        RenderRectangle(CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height, Style.Color.HightLightColor[1], Style.Color.HightLightColor[2], Style.Color.HightLightColor[3], Style.Color.HightLightColor[4])
                    else
                        RenderSprite(SettingsButton.SelectedSprite.Dictionary, SettingsButton.SelectedSprite.Texture, CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height)
                    end
                end

                if type(Style) == 'table' then
                    if Style.LeftBadge ~= nil then
                        if Style.LeftBadge ~= SertyModuleUI.BadgeStyle.None and tonumber(Style.LeftBadge) ~= nil then
                            RenderSprite(SertyModuleUI.GetBadgeDictionary(Style.LeftBadge, Selected), SertyModuleUI.GetBadgeTexture(Style.LeftBadge, Selected), CurrentMenu.X, CurrentMenu.Y + SettingsButton.LeftBadge.Y + CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, SettingsButton.LeftBadge.Width, SettingsButton.LeftBadge.Height, SertyModuleUI.GetBadgeColour(Style.LeftBadge, Selected))
                        end
                    end
                    if Style.RightBadge ~= nil then
                        if Style.RightBadge ~= SertyModuleUI.BadgeStyle.None and tonumber(Style.RightBadge) ~= nil then
                            RenderSprite(SertyModuleUI.GetBadgeDictionary(Style.RightBadge, Selected), SertyModuleUI.GetBadgeTexture(Style.RightBadge, Selected), CurrentMenu.X + SettingsButton.RightBadge.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightBadge.Y + CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, SettingsButton.RightBadge.Width, SettingsButton.RightBadge.Height, 0, SertyModuleUI.GetBadgeColour(Style.RightBadge, Selected))
                        end
                    end
                end

                if Enabled == true or Enabled == nil then
                    if Selected then
                        if Style.RightLabel ~= nil and Style.RightLabel ~= "" then
                            RenderText(Style.RightLabel, CurrentMenu.X + SettingsButton.RightText.X - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightText.Y + CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, 0, SettingsButton.RightText.Scale, 0, 0, 0, 255, 2)
                        end
                        RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, 0, SettingsButton.Text.Scale, 0, 0, 0, 255)
                    else
                        if Style.RightLabel ~= nil and Style.RightLabel ~= "" then
                            RenderText(Style.RightLabel, CurrentMenu.X + SettingsButton.RightText.X - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightText.Y + CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, 0, SettingsButton.RightText.Scale, 245, 245, 245, 255, 2)
                        end

                        RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, 0, SettingsButton.Text.Scale, 245, 245, 245, 255)
                    end
                else
                    RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + SertyModuleUI.ItemOffset, 0, SettingsButton.Text.Scale, 163, 159, 148, 255)
                end

                SertyModuleUI.ItemOffset = SertyModuleUI.ItemOffset + SettingsButton.Rectangle.Height

                SertyModuleUI.ItemsDescription(CurrentMenu, Description, Selected);

                if (Enabled) then
                    if Selected and (CurrentMenu.Controls.Select.Active or (Hovered and CurrentMenu.Controls.Click.Active)) then
                        local Audio = SertyModuleUI.Settings.Audio
                        SertyModuleUI.PlaySound(Audio[Audio.Use].Select.audioName, Audio[Audio.Use].Select.audioRef)
                        if (Callback.onSelected ~= nil) and (Selected) then
                            Callback.onSelected();
                        end
                        if Submenu ~= nil then
                            if Submenu() then
                                SertyModuleUI.NextMenu = Submenu
                            end
                        end
                    elseif Selected then
                        if(Callback.onActive ~= nil) then
                            Callback.onActive()
                        end 
                    end
                end
            end
            SertyModuleUI.Options = SertyModuleUI.Options + 1

        end
    end

end