Nuts = {first = 0, last = -1}
Nuts.mt = {__index = Nuts}

function Nuts:new(o)
    o = o or {}
    setmetatable(o, Nuts.mt)

    self._SPEED = 200
	self._RADIUS = 5

    return o
end

function Nuts:fire(value)
  local last = self.last + 1
  self.last = last
  self[last] = value
end

function Nuts:draw()
    love.graphics.setColor(102, 51, 0)
    for i=self.first,self.last do
        local v = self[i]
        
        if v then
            love.graphics.circle("fill", v.x, v.y, self._RADIUS)
        end
    end
    
    love.graphics.setColor(255, 255, 255)
    
    --love.graphics.print("first: "..self.first.."  last: "..self.last, 20, 20)
end

function Nuts:update(dt)
    for i=self.first,self.last do
        if self[i] then break end
        
        self.first = self.first + 1
    end

    for i=self.first,self.last do
        local v = self[i]
        
        if v then
            v.x = v.x - self._SPEED * dt
            
            if v.x < self._RADIUS*2 then
                self[i] = nil
            end
        end
    end

    for i=self.first,self.last do
        local nut = self[i]
        
        if nut then
			local distanceOfNutCenterToSnowballCenter = math.sqrt((nut.x-playerPiece.position.x)^2 + (nut.y-playerPiece.position.y)^2)
			
			if distanceOfNutCenterToSnowballCenter < playerPiece.radius then
				playerPiece.collectedNuts = playerPiece.collectedNuts + 1
				self[i] = nil
			end
        end
    end
end

