require "Vector"

PlayerPiece = {}
PlayerPiece.mt = {__index = PlayerPiece}

function PlayerPiece:new(o)
    o = o or {}
    setmetatable(o, PlayerPiece.mt)

    self._ACCELERATION_MAGNITUDE = 1500
    self._DRAG = 0.05
    self._MAX_SPEED = 300
    self._MIN_SPEED = 20

    -- We required that radius and bounds have been set
    self.position = self.position or Vector:new()
    self.velocity = Vector:new()
    
    return o
end

function PlayerPiece:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.push()
    love.graphics.translate(self.position.x, self.position.y)
    love.graphics.circle("fill", 0, 0, self.radius, 16)
    love.graphics.push()
    love.graphics.translate(0, 10 - self.radius)
    self._drawSquirrel()
    love.graphics.pop()
    love.graphics.pop()
    
    -- love.graphics.setColor(255,   0,   0)
    -- love.graphics.line(self.position.x,
                       -- self.position.y,
                       -- self.position.x + self.velocity.x,
                       -- self.position.y + self.velocity.y)
end

function PlayerPiece:_drawSquirrel()
    local squirrelTorsoSize = Vector:new{x=10, y=32}
    local squirrelHeadSize = Vector:new{x=15, y=15}
    local squirrelTailAngle = 1 -- in radians
    local squirrelTailSize = Vector:new{x=13, y=30}
    
    love.graphics.setColor(102, 51, 0)
    
    love.graphics.rectangle("fill",
                            -squirrelTorsoSize.x/2, -squirrelTorsoSize.y,
                            squirrelTorsoSize.x, squirrelTorsoSize.y)

    love.graphics.rectangle("fill",
                            squirrelTorsoSize.x/2-squirrelHeadSize.x, -(squirrelTorsoSize.y+squirrelHeadSize.y/2),
                            squirrelHeadSize.x, squirrelHeadSize.y)

    love.graphics.push()
    love.graphics.rotate(squirrelTailAngle)
    love.graphics.rectangle("fill",
                            -squirrelTailSize.x/2, -squirrelTailSize.y,
                            squirrelTailSize.x, squirrelTailSize.y)
    love.graphics.pop()
    
    love.graphics.setColor(127, 127, 127)
    
    love.graphics.rectangle("fill",
                            -20, -20,
                            20, 6)
end

function PlayerPiece:getMuzzlePosition()
    return self.position + Vector:new{x = -18,y = -(self.radius+7)}
end

function PlayerPiece:update(dt, bounds)
    -- Apply drag.
    -- Potential speed-up here.  Exponent is expensive.
    self.velocity = self.velocity * (self._DRAG ^ dt)

	local acceleration = Vector:new()
	
	if love.keyboard.isDown("up") then
		acceleration.y = acceleration.y - 1
    end
    
	if love.keyboard.isDown("down") then
		acceleration.y = acceleration.y + 1
    end
    
    if love.keyboard.isDown("left") then
		acceleration.x = acceleration.x - 1
    end

    if love.keyboard.isDown("right") then
		acceleration.x = acceleration.x + 1
    end
    
    acceleration = acceleration:normalize() * (self._ACCELERATION_MAGNITUDE * dt)
    
    self.velocity = self.velocity + acceleration
    
    -- Potential speed-up here.  Sqrt is expensive.
	local speed = self.velocity:length()
	
    if speed > self._MAX_SPEED then
        local speedCoefficient = self._MAX_SPEED / speed
        self.velocity = self.velocity * speedCoefficient
    elseif speed == 0 then
    elseif speed < self._MIN_SPEED and acceleration:length() == 0 then
        self.velocity = self.velocity * 0
    end

    self.position = self.position + (self.velocity * dt)

	if self.position.x < self.bounds.lowX  + self.radius then self.position.x = self.bounds.lowX  + self.radius ; self.velocity.x = 0 end
	if self.position.x > self.bounds.highX - self.radius then self.position.x = self.bounds.highX - self.radius ; self.velocity.x = 0  end
	if self.position.y < self.bounds.lowY  + self.radius then self.position.y = self.bounds.lowY  + self.radius ; self.velocity.y = 0  end
	if self.position.y > self.bounds.highY - self.radius then self.position.y = self.bounds.highY - self.radius ; self.velocity.y = 0  end
    
    if love.keyboard.isDown("=") or love.keyboard.isDown("kp+") then
        self.radius = self.radius + 10 * dt
    end
    
    if love.keyboard.isDown("-") or love.keyboard.isDown("kp-") then
        self.radius = self.radius - 10 * dt
    end
    
    if self.radius > 50 then
        self.radius = 50
    elseif self.radius < 10 then
        self.radius = 10
     end
end
