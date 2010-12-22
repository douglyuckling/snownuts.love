require "PlayerPiece"

bounds = {lowX=0, highX=800, lowY=250, highY=600}

function love.load()
    playerPiece = PlayerPiece:new{position=Vector:new{x=400,y=425}, radius=25, bounds=bounds}
end

function love.draw()
    playerPiece:draw()
end

function love.update(dt)
    playerPiece:update(dt)
end

