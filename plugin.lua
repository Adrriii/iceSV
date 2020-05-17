-- MoonSharp Documentation - http://www.moonsharp.org/getting_started.html
-- ImGui - https://github.com/ocornut/imgui
-- ImGui.NET - https://github.com/mellinoe/ImGui.NET

-- MAIN ------------------------------------------------------

function draw()
    applyStyle()
    window_svMenu()
end

function applyStyle()

    -- GLOBALS

    SAMELINE_SPACING = 4
    CONTENT_WIDTH = 250
    DEFAULT_WIDGET_HEIGHT = 26

    -- COLORS

    imgui.PushStyleColor(   imgui_col.WindowBg,                { 0.11, 0.11 ,0.11, 1.00 })
    imgui.PushStyleColor(   imgui_col.FrameBg,                 { 0.20, 0.29 ,0.42, 0.59 })
    imgui.PushStyleColor(   imgui_col.FrameBgHovered,          { 0.35, 0.51 ,0.74, 0.78 })
    imgui.PushStyleColor(   imgui_col.FrameBgActive,           { 0.17, 0.27 ,0.39, 0.67 })
    imgui.PushStyleColor(   imgui_col.TitleBg,                 { 0.11, 0.11 ,0.11, 1.00 })
    imgui.PushStyleColor(   imgui_col.TitleBgActive,           { 0.19, 0.21 ,0.23, 1.00 })
    imgui.PushStyleColor(   imgui_col.TitleBgCollapsed,        { 0.20, 0.25 ,0.30, 1.00 })
    imgui.PushStyleColor(   imgui_col.ScrollbarGrab,           { 0.44, 0.44 ,0.44, 1.00 })
    imgui.PushStyleColor(   imgui_col.ScrollbarGrabHovered,    { 0.75, 0.73 ,0.73, 1.00 })
    imgui.PushStyleColor(   imgui_col.ScrollbarGrabActive,     { 0.99, 0.99 ,0.99, 1.00 })
    imgui.PushStyleColor(   imgui_col.CheckMark,               { 1.00, 1.00 ,1.00, 1.00 })
    imgui.PushStyleColor(   imgui_col.Button,                  { 0.57, 0.79 ,0.84, 0.40 })
    imgui.PushStyleColor(   imgui_col.ButtonHovered,           { 0.40, 0.62 ,0.64, 1.00 })
    imgui.PushStyleColor(   imgui_col.ButtonActive,            { 0.24, 0.74 ,0.76, 1.00 })
    imgui.PushStyleColor(   imgui_col.Tab,                     { 0.30, 0.33 ,0.38, 0.86 })
    imgui.PushStyleColor(   imgui_col.TabHovered,              { 0.67, 0.71 ,0.75, 0.80 })
    imgui.PushStyleColor(   imgui_col.TabActive,               { 0.39, 0.65 ,0.74, 1.00 })

    -- VALUES

    -- Will make a PR soon to have this ImGui enum accessible
    local imgui_style_var = {
        Alpha = 0,
        WindowPadding = 1,
        WindowRounding = 2,
        WindowBorderSize = 3,
        WindowMinSize = 4,
        WindowTitleAlign = 5,
        ChildRounding = 6,
        ChildBorderSize = 7,
        PopupRounding = 8,
        PopupBorderSize = 9,
        FramePadding = 10,
        FrameRounding = 11,
        FrameBorderSize = 12,
        ItemSpacing = 13,
        ItemInnerSpacing = 14,
        IndentSpacing = 15,
        ScrollbarSize = 16,
        ScrollbarRounding = 17,
        GrabMinSize = 18,
        GrabRounding = 19,
        TabRounding = 20,
        ButtonTextAlign = 21,
        COUNT = 22
    }

    local rounding = 0

    imgui.PushStyleVar( imgui_style_var.WindowPadding,      { 20, 10 } )
    imgui.PushStyleVar( imgui_style_var.FramePadding,       {  9,  6 } )
    imgui.PushStyleVar( imgui_style_var.ItemSpacing,        { DEFAULT_WIDGET_HEIGHT/2 - 1,  4 } )
    imgui.PushStyleVar( imgui_style_var.ItemInnerSpacing,   { SAMELINE_SPACING, 6 } )
    imgui.PushStyleVar( imgui_style_var.ScrollbarSize,      10         )
    imgui.PushStyleVar( imgui_style_var.WindowBorderSize,   0          )
    imgui.PushStyleVar( imgui_style_var.WindowRounding,     rounding   )
    imgui.PushStyleVar( imgui_style_var.ChildRounding,      rounding   )
    imgui.PushStyleVar( imgui_style_var.FrameRounding,      rounding   )
    imgui.PushStyleVar( imgui_style_var.ScrollbarRounding,  rounding   )
    imgui.PushStyleVar( imgui_style_var.TabRounding,        rounding   )
end

-- WINDOWS ----------------------------------------------------

function window_svMenu()
    statusMessage = state.GetValue("statusMessage") or "b2020.05.17"

    imgui.Begin("SV Menu", true, imgui_window_flags.AlwaysAutoResize)

    imgui.BeginTabBar("function_selection")
    menu_information()
    menu_linearSV()
    -- menu_stutterSV()
    menu_cubicBezierSV()
    -- menu_editSVRange()
    -- menu_BpmGradient()
    imgui.EndTabBar()

    gui_separator()
    imgui.TextDisabled(statusMessage)

    -- This line needs to be added, so that the UI under it in-game
    -- is not able to be clicked. If you have multiple windows, you'll want to check if
    -- either one is hovered.
    state.IsWindowHovered = imgui.IsWindowHovered()
    imgui.End()

    state.SetValue("statusMessage", statusMessage)
end

-- MENUS -------------------------------------------------------

function menu_information()
    if imgui.BeginTabItem("Information") then
        gui_title("Help")

        imgui.TextWrapped("Hover over each function for an explanation")

        imgui.BulletText("Linear SV")
        gui_tooltip("Creates an SV gradient based on two points in time")

        imgui.BulletText("Stutter SV")
        gui_tooltip("Creates a normalized stutter effect")

        gui_separator()
        gui_title("About")

        gui_hyperlink("https://github.com/IceDynamix/IceSV", "Github")
        imgui.TextWrapped("Created by IceDynamix")
        imgui.TextWrapped("Heavily inspired by Evening's re:amber")
        gui_tooltip("let's be real this is basically a direct quaver port")
        imgui.EndTabItem()
    end
end


function menu_linearSV()

    local menuID = "linear"

    if imgui.BeginTabItem("Linear SV") then

        -- Initialize variables
        local vars = {
            startSV = 1,
            endSV = 1,
            intermediatePoints = 16,
            startOffset = 0,
            endOffset = 0,
            skipEndSV = false
        }

        util_retrieveStateVariables(menuID, vars)

        -- Create UI Elements

        gui_title("Offset")
        gui_startEndOffset(vars)

        gui_separator()
        gui_title("Velocities")

        local velocities = { vars["startSV"], vars["endSV"] }
        imgui.PushItemWidth(CONTENT_WIDTH)
        _, velocities = imgui.DragFloat2("Start/End Velocity", velocities, 0.01, -10.0, 10.0, "%.2fx")
        imgui.PopItemWidth()
        vars["startSV"], vars["endSV"] = table.unpack(velocities)
        gui_helpMarker("Ctrl+Click to enter as text!")

        local widths = util_calcAbsoluteWidths({0.7,0.3})

        if imgui.Button("Swap start and end velocity", {widths[1], DEFAULT_WIDGET_HEIGHT}) then
            vars["startSV"], vars["endSV"] = vars["endSV"], vars["startSV"]
        end

        imgui.SameLine(0, SAMELINE_SPACING)

        if imgui.Button("Reset", {widths[2], DEFAULT_WIDGET_HEIGHT}) then
            vars["startSV"] = 1
            vars["endSV"] = 1
        end

        gui_separator()

        gui_title("Utilities")

        imgui.PushItemWidth(CONTENT_WIDTH)
        _, vars["intermediatePoints"] = imgui.InputInt("Intermediate points", vars["intermediatePoints"], 4)
        imgui.PopItemWidth()

        vars["intermediatePoints"] = math_clamp(vars["intermediatePoints"], 1, 500)

        _, vars["skipEndSV"] = imgui.Checkbox("Skip end SV?", vars["skipEndSV"])

        gui_separator()

        gui_title("CALCULATE")

        if imgui.Button("Insert into map", {CONTENT_WIDTH, DEFAULT_WIDGET_HEIGHT}) then
            SVs = sv_linear(
                vars["startSV"],
                vars["endSV"],
                vars["startOffset"],
                vars["endOffset"],
                vars["intermediatePoints"],
                vars["skipEndSV"]
            )
            editor_placeSVs(SVs)
        end

        -- Save variables
        util_saveStateVariables(menuID, vars)

        imgui.EndTabItem()
    end
end

function menu_cubicBezierSV()

    local menuID = "cubicBezier"

    if imgui.BeginTabItem("Cubic Bezier") then

        local vars = {
            startOffset = 0,
            endOffset = 0,
            x1 = 0.35,
            y1 = 0.00,
            x2 = 0.65,
            y2 = 1.00,
            averageSV = 1.0,
            intermediatePoints = 16,
            skipEndSV = false,
            lastSVs = {}
        }

        util_retrieveStateVariables(menuID, vars)

        gui_title("Note")
        gui_hyperlink("https://cubic-bezier.com/")

        gui_separator()
        gui_title("Offset")

        gui_startEndOffset(vars)

        gui_separator()
        gui_title("Values")

        imgui.PushItemWidth(CONTENT_WIDTH)

        local x = {vars["x1"],vars["x2"]}
        _, x = imgui.DragFloat2("x1, x2", x, 0.01, 0, 1, "%.2f")
        vars["x1"], vars["x2"] = table.unpack(x)

        local y = {vars["y1"],vars["y2"]}
        _, y = imgui.DragFloat2("y1, y2", y, 0.01, -1, 2, "%.2f")
        vars["y1"], vars["y2"] = table.unpack(y)


        _, vars["averageSV"] = imgui.DragFloat("Average SV", vars["averageSV"], 0.01, -100, 100, "%.2f")

        if imgui.Button("Reset") then
            --[[
                I tried to implement a function where it takes the default values
                but it seems that I'm unsuccessful in deep-copying the table

                Something like this:

                function util_resetToDefaultValues(currentVars, defaultVars, varsToReset)
                    for _, key in pairs(varsToReset) do
                        if currentVars[key] and defaultVars[key] then
                            currentVars[key] = defaultVars[key]
                        end
                    end
                    return currentVars
                end
            ]]

            vars["x1"] = 0.35
            vars["x2"] = 0.00
            vars["y1"] = 0.65
            vars["y2"] = 1.00
            vars["averageSV"] = 1.0
        end

        imgui.PopItemWidth()

        gui_separator()
        gui_title("Utilities")

        imgui.PushItemWidth(CONTENT_WIDTH)
        _, vars["intermediatePoints"] = imgui.InputInt("Intermediate points", vars["intermediatePoints"], 4)
        imgui.PopItemWidth()

        vars["intermediatePoints"] = math_clamp(vars["intermediatePoints"], 1, 500)
        _, vars["skipEndSV"] = imgui.Checkbox("Skip end SV?", vars["skipEndSV"])


        gui_separator()
        gui_title("Calculate")

        imgui.PushItemWidth(CONTENT_WIDTH)
        if imgui.Button("Insert into map") then
            vars["lastSVs"] = sv_cubicBezier(
                vars["x1"],
                vars["y1"],
                vars["x2"],
                vars["y2"],
                vars["startOffset"],
                vars["endOffset"],
                vars["averageSV"],
                vars["intermediatePoints"],
                vars["skipEndSV"]
            )
            editor_placeSVs(vars["lastSVs"])
        end
        imgui.PopItemWidth()

        util_saveStateVariables(menuID, vars)
    end
end

-- SV ---------------------------------------------------

-- Returns a list of SV objects as defined in Quaver.API/Maps/Structures/SliderVelocityInfo.cs
function sv_linear(startSV, endSV, startOffset, endOffset, intermediatePoints, skipEndSV)

    local timeInterval = (endOffset - startOffset)/intermediatePoints
    local velocityInterval = (endSV - startSV)/intermediatePoints

    if skipEndSV then intermediatePoints = intermediatePoints - 1 end

    local SVs = {}

    for step = 0, intermediatePoints, 1 do
        local offset = step * timeInterval + startOffset
        local velocity = step * velocityInterval + startSV
        table.insert(SVs, utils.CreateScrollVelocity(offset, velocity))
    end

    return SVs
end

--[[
    about beziers

    i originally planned to support any number of control points from 3 (quadratic)
    to, idk, 10 or something

    i ran into some issues when trying to write general code for all orders of n,
    which made me give up on them for now

    the way to *properly* do it
        - find length t at position x
        - use the derivative of bezier to find y at t

    problem is that i cant reliably perform the first step for any curve
    so i guess i'll be using a very bad approach to this for now... if you know more about
    this stuff please get in contact with me
]]

-- @return table of scroll velocities
function sv_cubicBezier(P1_x, P1_y, P2_x, P2_y, startOffset, endOffset, averageSV, intermediatePoints, skipEndSV)

    local stepInterval = 1/intermediatePoints
    local timeInterval = (endOffset - startOffset) * stepInterval

    -- the larger this number, the more accurate the final sv is
    -- ... and the longer it's going to take
    local totalSampleSize = 5000
    local allBezierSamples = {}
    for t=0, 1, 1/totalSampleSize do
        local x = math_cubicBezier({0, P1_x, P2_x, 1}, t)
        local y = math_cubicBezier({0, P1_y, P2_y, 1}, t)
        table.insert(allBezierSamples, {x=x,y=y})
    end

    local SVs = {}
    local positions = {}

    local currentPoint = 0

    for sampleCounter = 1, totalSampleSize, 1 do
        if allBezierSamples[sampleCounter].x > currentPoint then
            table.insert(positions, allBezierSamples[sampleCounter].y)
            currentPoint = currentPoint + stepInterval
        end
    end

    for i = 1, intermediatePoints, 1 do
        local offset = (i-1) * timeInterval + startOffset
        local velocity = math_round((positions[i] - (positions[i-1] or 0)) * averageSV * intermediatePoints, 2)
        table.insert(SVs, utils.CreateScrollVelocity(offset, velocity))
    end

    if skipEndSV == false then
        table.insert(SVs, utils.CreateScrollVelocity(endOffset, averageSV))
    end

    return SVs
end

-- MATH ----------------------------------------------------

-- Simple recursive implementation of the binomial coefficient
function math_binom(n, k)
    if k == 0 or k == n then return 1 end
    return math_binom(n-1, k-1) + math_binom(n-1, k)
end

-- Currently unused
function math_bernsteinPolynomial (i,n,t) return math_binom(n,i) * t^i * (1-t)^(n-i) end

-- Derivative for *any* bezier curve with at point t
-- Currently unused
function math_bezierDerivative(P, t)
    local n = #P
    local sum = 0
    for i = 0, n-2, 1 do sum = sum + math_bernsteinPolynomial(i,n-2,t) * (P[i+2].y - P[i+1].y) end
    return sum
end

function math_cubicBezier(P, t)
    return P[1] + 3*t*(P[2]-P[1]) + 3*t^2*(P[1]+P[3]-2*P[2]) + t^3*(P[4]-P[1]+3*P[2]-3*P[3])
end

function math_round(x, n) return tonumber(string.format("%." .. (n or 0) .. "f", x)) end

function math_clamp(x, min, max) return math.max(math.min(x, max), min) end

-- UTIL ---------------------------------------------------

function util_retrieveStateVariables(menuID, variables)
    for key in pairs(variables) do
        variables[key] = state.GetValue(menuID..key) or variables[key]
    end
end

function util_saveStateVariables(menuID, variables)
    for key in pairs(variables) do
        state.SetValue(menuID..key, variables[key])
    end
end

function util_displayVal(label, value)
    imgui.TextWrapped(string.format("%s: %s", label, tostring(value)))
end

function util_toString(var)
    local string = ""
    string = var or "<null>"
    if type(var) == "table" then string = "<list.length=".. #var ..">" end
    if var == "" then string = "<empty string>" end
    return string
end

function util_calcAbsoluteWidths(relativeWidths)
    local absoluteWidths = {}
    local n = #relativeWidths
    for _, value in pairs(relativeWidths) do
        table.insert(absoluteWidths, (value * CONTENT_WIDTH) - (SAMELINE_SPACING/n))
    end
    return absoluteWidths
end

-- GUI ELEMENTS ----------------------------------------------------------

function gui_title(title)
    imgui.Dummy({0,5})
    imgui.Text(string.upper(title))
    imgui.Dummy({0,5})
end

function gui_separator()
    imgui.Dummy({0,5})
    imgui.Separator()
end

function gui_tooltip(text)
    if imgui.IsItemHovered() then imgui.SetTooltip(text) end
end

function gui_helpMarker(text)
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    gui_tooltip(text)
end

function gui_startEndOffset(variables)

    local widths = util_calcAbsoluteWidths({ 0.3, 0.7 })

    -- ROW 1

    if imgui.Button("Current", {widths[1], DEFAULT_WIDGET_HEIGHT}) then
        variables["startOffset"] = state.SongTime
        statusMessage = "Copied into start offset!"
    end

    gui_tooltip("Copies the current editor position into the start offset")

    imgui.SameLine(0, SAMELINE_SPACING)

    imgui.PushItemWidth(widths[2])
    _, variables["startOffset"] = imgui.InputInt("Start offset in ms", variables["startOffset"], 1000)
    imgui.PopItemWidth()

    -- ROW 2

    if imgui.Button(" Current ", {widths[1], DEFAULT_WIDGET_HEIGHT}) then
        variables["endOffset"] = state.SongTime
        statusMessage = "Copied into end offset!"
    end

    gui_tooltip("Copies the current editor position into the end offset")

    imgui.SameLine(0, SAMELINE_SPACING)

    imgui.PushItemWidth(widths[2])
    _, variables["endOffset"] = imgui.InputInt("End offset in ms", variables["endOffset"], 1000)
    imgui.PopItemWidth()
end

function gui_printVars(vars, title)
    if imgui.CollapsingHeader(title, imgui_tree_node_flags.DefaultOpen) then
        imgui.Columns(3)
        gui_separator()

        imgui.Text("var");      imgui.NextColumn();
        imgui.Text("type");     imgui.NextColumn();
        imgui.Text("value");    imgui.NextColumn();

        gui_separator()

        if vars == state then
            local varList = { "DeltaTime", "UnixTime", "IsWindowHovered", "Values", "SongTime", "SelectedHitObjects", "CurrentTimingPoint" }
            for _, value in pairs(varList) do
                util_toString(value);               imgui.NextColumn();
                util_toString(type(vars[value]));   imgui.NextColumn();
                util_toString(vars[value]);         imgui.NextColumn();
            end
        else
            for key, value in pairs(vars) do
                util_toString(key);             imgui.NextColumn();
                util_toString(type(value));     imgui.NextColumn();
                util_toString(value);           imgui.NextColumn();
            end
        end

        imgui.Columns(1)
        gui_separator()
    end
end

-- Plots will come once Quaver#1985 is merged
function gui_svPlot(SVs)
    local velocities = {}
    for _, SV in pairs(SVs) do
        table.insert(velocities, SV.velocity)
    end
    imgui.PlotLines("SV Plot", velocities, #velocities)
end

-- Hyperlinks will word once Quaver#1986 is merged
function gui_hyperlink(url, text)
    local hyperlinkColor = { 0.53, 0.66, 0.96, 1.00 }

    if text then
        imgui.TextColored(hyperlinkColor, text)
    else
        imgui.TextColored(hyperlinkColor, url)
    end

    if imgui.IsItemHovered() then
        if text then imgui.SetTooltip(url) end
    end
end

-- EDITOR ----------------------------------------------------------

function editor_placeSVs(SVs)
    if #SVs == 0 then return end
        actions.PlaceScrollVelocityBatch(SVs)
    statusMessage = "Inserted " .. #SVs .. " SV points!"
end
