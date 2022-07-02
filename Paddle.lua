
Paddle = class{}

function Paddle:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.speed = 200
end

function Paddle:left(dt)
  self.x = math.max(0, self.x - self.speed *dt)
end

function Paddle:right(dt)
  self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.speed *dt)
end

function Paddle:render()
  love.graphics.rectangle('fill', self.x, self.y,self.width, self.height)
end