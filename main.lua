require "PlayerPiece"
require "Lasers"
require "Squirrels"
require "Nuts"

bounds = {lowX=0, highX=800, lowY=250, highY=600}
lastLaserFireTime = -100
lastSquirrelFireTime= -100
lastNutFireTime = 0.5

function love.load()
    playerPiece = PlayerPiece:new{position=Vector:new{x=400,y=425}, radius=25, bounds=bounds}
    lasers = Lasers:new()
    squirrels = Squirrels:new()
	nuts = Nuts:new()
end

function love.draw()
    lasers:draw()
    squirrels:draw()
	nuts:draw()
    playerPiece:draw()
end

function love.update(dt)
    playerPiece:update(dt)
    
    local currentTime = love.timer.getTime()
    if currentTime - lastLaserFireTime > 0.3 then
		lasers:fire(playerPiece:getMuzzlePosition())
        lastLaserFireTime = currentTime
    end
    
    if currentTime - lastSquirrelFireTime > 2.5 then
		squirrels:fire(Vector:new{x=0,y=math.random()*((bounds.highY-bounds.lowY)-150)+bounds.lowY+75})
        lastSquirrelFireTime = currentTime
    end

    if currentTime - lastNutFireTime > 1.5 then
		nuts:fire(Vector:new{x=bounds.highX+nuts._RADIUS,y=math.random()*(bounds.highY-bounds.lowY)+bounds.lowY})
        lastNutFireTime = currentTime
    end

    lasers:update(dt)
    squirrels:update(dt)
	nuts:update(dt)
end

