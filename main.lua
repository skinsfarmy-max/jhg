local player = { x = 100, y = 100, speed = 300, size = 40 }
local blocks = {}
local gridSize = 60 -- На мобиле лучше покрупнее
local joystick = { x = 150, y = 0, radius = 80 } -- Область для управления

function love.load()
    -- Делаем экран на весь телефон
    width, height = love.graphics.getDimensions()
    joystick.y = height - 150
end

function love.update(dt)
    -- Проверка тачей (пальцев на экране)
    local touches = love.touch.getTouches()
    for _, id in ipairs(touches) do
        local tx, ty = love.touch.getPosition(id)
        
        -- Если палец в левой части экрана — идем влево
        if tx < width / 3 then
            player.x = player.x - player.speed * dt
        -- Если в средней (чуть правее) — идем вправо
        elseif tx > width / 3 and tx < (width / 3) * 2 then
            player.x = player.x + player.speed * dt
        end
    end
end

function love.touchpressed(id, x, y)
    -- Если нажали в правой трети экрана — ставим блок
    if x > (width / 3) * 2 then
        local gx = math.floor(x / gridSize) * gridSize
        local gy = math.floor(y / gridSize) * gridSize
        table.insert(blocks, {x = gx, y = gy})
    end
end

function love.draw()
    -- Фон
    love.graphics.clear(0.1, 0.1, 0.2)

    -- Рисуем блоки
    love.graphics.setColor(0.5, 0.3, 0.1)
    for _, b in ipairs(blocks) do
        love.graphics.rectangle("fill", b.x, b.y, gridSize - 2, gridSize - 2)
    end

    -- Игрок
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", player.x, player.y, player.size, player.size)

    -- Подсказки (зоны управления)
    love.graphics.setColor(1, 1, 1, 0.2)
    love.graphics.line(width/3, 0, width/3, height)
    love.graphics.line((width/3)*2, 0, (width/3)*2, height)
    
    love.graphics.print("ЛЕВО | ПРАВО | СТАВИТЬ", 20, 20, 0, 2, 2)
end