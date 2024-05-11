
function SertyModuleUI.Info(Title, RightText, LeftText)
    local LineCount = #RightText >= #LeftText and #RightText or #LeftText
    if Title ~= nil then
        RenderText("~h~" .. Title .. "~h~", 432 + 20 + -2, 7, 0, 0.34, 255, 255, 255, 255, 0)
    end
    if RightText ~= nil then
        RenderText(table.concat(RightText, "\n"), 432 + 20 + -2, Title ~= nil and 37 or 7, 0, 0.28, 255, 255, 255, 255, 0)
    end
    if LeftText ~= nil then
        RenderText(table.concat(LeftText, "\n"), 432 + 525 + -2, Title ~= nil and 37 or 7, 0, 0.28, 255, 255, 255, 255, 2)
    end
    RenderRectangle(432 + 10 + -2, 0, 525, Title ~= nil and 50 + (LineCount * 20) or ((LineCount + 1) * 20), 0, 0, 0, 160)
end