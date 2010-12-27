Lasers = {first = 0, last = -1}
Lasers.mt = {__index = Lasers}

function Lasers:new(o)
    o = o or {}
    setmetatable(o, Lasers.mt)

    self._SPEED = 400
    self._LENGTH = 20
	self._WIDTH = 8

    return o
end

function Lasers:fire(value)
  local last = self.last + 1
  self.last = last
  self[last] = value
end

function Lasers:draw()
    love.graphics.setColor(255, 0, 0)
    for i=self.first,self.last do
        local v = self[i]
        love.graphics.line(v.x, v.y, v.x+self._LENGTH, v.y)
    end
    
    love.graphics.setColor(255, 255, 255)
end

function Lasers:update(dt)
    for i=self.first,self.last do
        local v = self[i]
        v.x = v.x - self._SPEED * dt
        
        if v.x < -self._LENGTH then
            self[i] = nil
            self.first = self.first + 1
        end
    end
end

