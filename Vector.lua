Vector = {x=0, y=0}
Vector.mt = {__index = Vector}

function Vector:new(o)
    o = o or {}
    setmetatable(o, Vector.mt)
    return o
end

function Vector:length()
	return math.sqrt((self.x*self.x) + (self.y*self.y))
end

function Vector:normalize()
    local length = self:length()
    
    if length > 0 then
        self.x = self.x / length
        self.y = self.y / length
    end
    
    return self
end

function Vector:add(other)
    return Vector:new{ x = self.x + other.x;
                       y = self.y + other.y }
end

function Vector:subtract(other)
    return Vector:new{ x = self.x - other.x;
                       y = self.y - other.y }
end

function Vector:multiply(multiplier)
    return Vector:new{ x = self.x * multiplier;
                       y = self.y * multiplier }
end

function Vector:divide(divisor)
    return Vector:new{ x = self.x / divisor;
                       y = self.y / divisor }
end

function Vector:negation()
    return Vector:new{ x = -self.x;
                       y = -self.y }
end

Vector.mt.__add = Vector.add
Vector.mt.__sub = Vector.subtract
Vector.mt.__mul = Vector.multiply
Vector.mt.__div = Vector.divide
Vector.mt.__unm = Vector.negation
