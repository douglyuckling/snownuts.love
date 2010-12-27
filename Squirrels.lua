Squirrels = {first = 0, last = -1}
Squirrels.mt = {__index = Squirrels}

function Squirrels:new(o)
    o = o or {}
    setmetatable(o, Squirrels.mt)

    self._SPEED = 300
    self._WIDTH = 32
    self._HEIGHT = 12

    return o
end

function Squirrels:fire(value)
  local last = self.last + 1
  self.last = last
  self[last] = value
end

function Squirrels:draw()
    love.graphics.setColor(102, 51, 0)
    for i=self.first,self.last do
        local v = self[i]
        
        if v then
            love.graphics.rectangle("fill",
                v.x-self._WIDTH/2, v.y-self._HEIGHT/2,
                self._WIDTH, self._HEIGHT
            )
        end
    end
    
    love.graphics.setColor(255, 255, 255)
    
    --love.graphics.print("first: "..self.first.."  last: "..self.last, 20, 20)
end

function Squirrels:update(dt)
    for i=self.first,self.last do
        if self[i] then break end
        
        self.first = self.first + 1
    end

    for i=self.first,self.last do
        local v = self[i]
        
        if v then
            v.x = v.x + self._SPEED * dt
            
            if v.x > 800+self._WIDTH then
                self[i] = nil
            end
        end
    end

    for i=self.first,self.last do
        local squirrel = self[i]
        
        if squirrel then
            for j=lasers.first,lasers.last do
                local laserPulse = lasers[j]
                if ((laserPulse.x < squirrel.x+self._WIDTH/2) and
                        (laserPulse.x > squirrel.x-self._WIDTH/2) and
                        (laserPulse.y-Lasers._WIDTH/2 < squirrel.y+self._HEIGHT/2) and
                        (laserPulse.y-Lasers._WIDTH/2 > squirrel.y-self._HEIGHT/2)) or
						((laserPulse.x < squirrel.x+self._WIDTH/2) and
                        (laserPulse.x > squirrel.x-self._WIDTH/2) and
                        (laserPulse.y+Lasers._WIDTH/2 < squirrel.y+self._HEIGHT/2) and
                        (laserPulse.y+Lasers._WIDTH/2 > squirrel.y-self._HEIGHT/2))
						then
                    self[i] = nil
                end
            end
        end
    end
end

