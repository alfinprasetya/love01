
--[[
    Project Metadata
    No          : 1
    Name        : Pong
    Author      : Alfin Prasetya
    Start Date  : 13 May 2022
    Finish Date : 18 May 2022
]]

-- Include library
push = require 'push'
class = require 'class'
require 'Paddle'
require 'Ball'

-- Declare all constant variables
WINDOW_WIDTH    = 380
WINDOW_WIDTH    = 380
WINDOW_HEIGHT   = 800
VIRTUAL_WIDTH   = 205
VIRTUAL_HEIGHT  = 432
PLAYER_WIDTH    = 50
PLAYER_HEIGHT   = 5
PLAYER_SPEED    = 200


-- Function to initialize the game
function love.load()
    
    --Set window title
    love.window.setTitle('Pong')
    
    --Set retro filter
    love.graphics.setDefaultFilter('nearest','nearest')
    
    --Declare the randomness using time (unpredictable)
    math.randomseed(os.time())
    
    --Register new font
    smallFont = love.graphics.newFont('font.ttf',8)
    scoreFont = love.graphics.newFont('font.ttf',32)
    love.graphics.setFont(smallFont)
    
    --Register sound effect
    sounds = {
      ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
      ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
      ['score'] = love.audio.newSource('sounds/score.wav', 'static')
    }
    
    --Set game window
    push:setupScreen(
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        {
            fullscreen = false,
            resizable = false,
            vsync = true
        }
        )
    
    --Clear window with specific color (set background)
    love.graphics.clear(40, 45, 52, 255)
    
    --Set player initial position
    player1 = Paddle((VIRTUAL_WIDTH - PLAYER_WIDTH)/2, 45, PLAYER_WIDTH, PLAYER_HEIGHT)
    player2 = Paddle((VIRTUAL_WIDTH - PLAYER_WIDTH)/2, VIRTUAL_HEIGHT - PLAYER_HEIGHT - 5, PLAYER_WIDTH, PLAYER_HEIGHT)
    
    --Set player initial score
    player1Score = 0
    player2Score = 0
    
    --Set ball initial position
    ball = Ball(VIRTUAL_WIDTH/2-3, (VIRTUAL_HEIGHT+40)/2-3, 6, 6)

    gameState = 'start'
end


-- Function that always update
function love.update(dt)
    if gameState == 'play' then
    --Ball movement
        ball:update(dt)
        
    --Ball collision
        if ball:collision(player1) then
            ball.Dy = -ball.Dy * 1.05
            ball.y = player1.y + player1.height
        end
      
        if ball:collision(player2) then
            ball.Dy = -ball.Dy * 1.05
            ball.y = player2.y - ball.height
        end
        
        if ball:collision(player1) or ball:collision(player2) then
            if ball.Dx < 0 then
                ball.Dx = -math.random(10, 150)   
            else
                ball.Dx = math.random(10, 150)
            end
            
            sounds['paddle_hit']:play()
        end
        
        if ball.x <= 0 then
            ball.x = 0 
            ball.Dx = -ball.Dx
            sounds['wall_hit']:play()
        end
        if ball.x + ball.width >= VIRTUAL_WIDTH then
            ball.x = VIRTUAL_WIDTH - ball.width
            ball.Dx = -ball.Dx
            sounds['wall_hit']:play()
        end
    
    --Touchscreen control
        local touches = love.touch.getTouches()
    
        for i, id in ipairs(touches) do
            local x, y = love.touch.getPosition(id)
         
         --Player 1 controller   
            if y <= WINDOW_HEIGHT / 2 then
                if x <= WINDOW_WIDTH / 2 then
                    player1:left(dt)
                else
                    player1:right(dt)
                end
            end
            
    --Player 2 controller
            if y > WINDOW_HEIGHT / 2 then
                if x <= WINDOW_WIDTH / 2 then
                    player2:left(dt)
                else
                    player2:right(dt)
                end
            end
            
        end
    end
        if ball.y <= 40 then
          player2Score = player2Score + 1
          ball:reset()
          sounds['score']:play()
          gameState = 'start'
        end
        if ball.y >= VIRTUAL_HEIGHT then
            player1Score = player1Score + 1
            ball:reset()
            sounds['score']:play()
            gameState = 'start'
        end
end


-- Function when touch pressed
function love.mousepressed(x, y, button)
    
    if button == 1 then
        if gameState == 'start' then
            gameState = 'play' 
        end
    end
    
end


-- Function to draw on screen
function love.draw()
    
    push:apply('start')
    --Draw game title
    love.graphics.setFont(smallFont)
    love.graphics.print('First Game : Pong', 0, 20)
        
    if gameState == 'start' then
        
    --Draw winner
    love.graphics.setFont(smallFont)
    local winner = ''
    if player1Score > player2Score then
        winner = 'Player 1 win'
    elseif player1Score < player2Score then
        winner = 'Player 2 win'
    else
        winner = 'draw'
    end
    
    love.graphics.printf(
        winner,
        0,
        (VIRTUAL_HEIGHT+40)/2 - 60,
        VIRTUAL_WIDTH,
        'center'
        )
    
    love.graphics.printf(
        'Press to start',
        0,
        (VIRTUAL_HEIGHT+40)/2 + 30,
        VIRTUAL_WIDTH,
        'center'
        )
    
    --Draw player score
        love.graphics.setFont(scoreFont)
        love.graphics.printf(
            player1Score,
            VIRTUAL_WIDTH - VIRTUAL_WIDTH*4/5,
            (VIRTUAL_HEIGHT+40) / 2 - 32,
            VIRTUAL_WIDTH,
            'left'
            )
        love.graphics.printf(
            player2Score,
            0,
            (VIRTUAL_HEIGHT+40) / 2 - 32,
            VIRTUAL_WIDTH*4/5,
            'right'
            )
    end
        
    --Draw border
    love.graphics.rectangle(
        'line',
        0,
        40,
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT - 40
        )
        
    --Draw player 1
    player1:render()
    
    --Draw player 2
    player2:render()
    
    --Draw ball
    ball:render()
    
    --Draw FPS
    displayFPS()
    
    push:apply('end')
end


--Renders the current FPS
function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.printf('FPS: ' .. tostring(love.timer.getFPS()), 0, 20, VIRTUAL_WIDTH, 'right')
end