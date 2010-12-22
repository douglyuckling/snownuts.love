require "Vector"

PlayerPiece = {}

function PlayerPiece:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

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
    love.graphics.circle("fill", self.position.x, self.position.y, self.radius)
    
    love.graphics.setColor(255,   0,   0)
    love.graphics.line(self.position.x,
                       self.position.y,
                       self.position.x + self.velocity.x,
                       self.position.y + self.velocity.y)
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
    elseif speed < self._MIN_SPEED then
        self.velocity = self.velocity * 0
    end

    self.position = self.position + (self.velocity * dt)

	if self.position.x < self.bounds.lowX  + self.radius then self.position.x = self.bounds.lowX  + self.radius ; self.velocity.x = 0 end
	if self.position.x > self.bounds.highX - self.radius then self.position.x = self.bounds.highX - self.radius ; self.velocity.x = 0  end
	if self.position.y < self.bounds.lowY  + self.radius then self.position.y = self.bounds.lowY  + self.radius ; self.velocity.y = 0  end
	if self.position.y > self.bounds.highY - self.radius then self.position.y = self.bounds.highY - self.radius ; self.velocity.y = 0  end
end
