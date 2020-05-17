-- Returns a list of SV objects as defined in Quaver.API/Maps/Structures/SliderVelocityInfo.cs
function sv.linear(startSV, endSV, startOffset, endOffset, intermediatePoints, skipEndSV)

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
function sv.cubicBezier(P1_x, P1_y, P2_x, P2_y, startOffset, endOffset, averageSV, intermediatePoints, skipEndSV)

    local stepInterval = 1/intermediatePoints
    local timeInterval = (endOffset - startOffset) * stepInterval

    -- the larger this number, the more accurate the final sv is
    -- ... and the longer it's going to take
    local totalSampleSize = 5000
    local allBezierSamples = {}
    for t=0, 1, 1/totalSampleSize do
        local x = math.cubicBezier({0, P1_x, P2_x, 1}, t)
        local y = math.cubicBezier({0, P1_y, P2_y, 1}, t)
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
        local velocity = math.round((positions[i] - (positions[i-1] or 0)) * averageSV * intermediatePoints, 2)
        table.insert(SVs, utils.CreateScrollVelocity(offset, velocity))
    end

    if skipEndSV == false then
        table.insert(SVs, utils.CreateScrollVelocity(endOffset, averageSV))
    end

    return SVs
end
