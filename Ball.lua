
Ball = class{}

function Ball:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  
  self.Dy = math.random(2) == 1 and 100 or -100
  self.Dx = math.random(-50, 50)
end

function Ball:update(dt)
  self.y = self.y + self.Dy *dt
  self.x = self.x + self.Dx *dt
end

function Ball:reset()
  self.x = (VIRTUAL_WIDTH + self.width) / 2
  self.y = (VIRTUAL_HEIGHT + self.height + 40) / 2
  self.Dy = math.random(2) == 1 and 100 or -100
  self.Dx = math.random(-50, 50)
end

function Ball:collision(paddle)
  if self.x > paddle.x + paddle.width 
  or paddle.x > self.x + self.width then
    return false
  end
  
  if self.y > paddle.y + paddle.height 
  or paddle.y > self.y + self.height then
    return false
  end
  
  return true
end

function Ball:render()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end