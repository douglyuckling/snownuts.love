require "PlayerPiece"
require "Lasers"

bounds = {lowX=0, highX=800, lowY=250, highY=600}
lastLaserFireTime = -100

function love.load()
    playerPiece = PlayerPiece:new{position=Vector:new{x=400,y=425}, radius=25, bounds=bounds}
    lasers = Lasers:new()
end

function love.draw()
    lasers:draw()
    playerPiece:draw()
end

function love.update(dt)
    playerPiece:update(dt)
    
    local currentTime = love.timer.getTime()
    if currentTime - lastLaserFireTime > 0.4 then
		lasers:fire(playerPiece:getMuzzlePosition())
        lastLaserFireTime = currentTime
    end
    
    lasers:update(dt)
end

