require "fonts/utf8lib"


local aims = {}

local aim = {
    x = love.math.random(0, 400),
    y = love.math.random(0, 300),
    speed = 0,
    width = 50,
    height = 50,
}

local timer = 0
local cooldown = 3
local airs = {}
function ClassAir()
    local air = {
        x = 20,
        y = 300,
        width = 50,
        height = 20,
        speedx = 0,
        speedy = 0,
        strike = 0,
        accel = 0,
        respawn = false,
        tg = 0,
        lose = false,
        records = 0,
        country = 'dd'

    }
    return air
end

local start = false
local y_tower = 275
local x_tower = 500
local z = 255
table.insert(airs, ClassAir())



function love.load()
    Airplane_SOV = love.graphics.newImage('src/Airplanes/Airplane_SOV.png')
    Airplane_GER = love.graphics.newImage('src/Airplanes/Airplane_GER.png')
    Airplane_USA = love.graphics.newImage('src/Airplanes/Airplane_USA.png')
    Airplane_ANA = love.graphics.newImage('src/Airplanes/Airplane_ANA.png')
    Airplane_SEC = love.graphics.newImage('src/Airplanes/Airplane_SEC.png')
    GER_icon = love.graphics.newImage('src/Icons/GER_icon.png')
    SOV_icon = love.graphics.newImage('src/Icons/SOV_icon.png')
    USA_icon = love.graphics.newImage('src/Icons/USA_icon.png')
    ANA_icon = love.graphics.newImage('src/Icons/ANA_icon.png')
    Tower_GER = love.graphics.newImage('src/Towers/Tower_GER.png')
    Tower_USA = love.graphics.newImage('src/Towers/Tower_USA.png')
    Tower1_SOV = love.graphics.newImage('src/Towers/Tower1_SOV.png')
    Tower2_SOV = love.graphics.newImage('src/Towers/Tower2_SOV.png')
    Tower1_ANA = love.graphics.newImage('src/Towers/Tower1_ANA.png')
    Tower2_ANA = love.graphics.newImage('src/Towers/Tower2_ANA.png')
    Tower1_SEC = love.graphics.newImage('src/Towers/Tower1_SEC.png')
    Tower2_SEC = love.graphics.newImage('src/Towers/Tower2_SEC.png')
    Restart_button = love.graphics.newImage('src/Buttons/Restart_button.png')
    Back_button = love.graphics.newImage('src/Buttons/Back_button.png')
    Sound_main = love.audio.newSource('sounds/Sound_main.wav', 'stream')
    Sound_USA = love.audio.newSource('sounds/Sound_USA.wav', 'stream')
    Sound_GER = love.audio.newSource('sounds/Sound_GER.wav', 'stream')
    Sound_SOV = love.audio.newSource('sounds/Sound_SOV.wav', 'stream')
    Sound_ANA = love.audio.newSource('sounds/Sound_ANA.wav', 'stream')
    Sound_SEC = love.audio.newSource('sounds/Sound_SEC.wav', 'stream')
    bg = love.graphics.newImage('src/Background_start.png')
    love.graphics.setNewFont("fonts/PressStart2P.ttf", 16)
    --Underground = love.graphics.newImage('Underground.png')
end

function Length(vec)
    local v = vec.x * vec.x + vec.y * vec.y
    return math.sqrt(v)
end

function Normalize(vec)
    local l = Length(vec)
    if l == 0 then
        return vec
    end
    return {
        x = vec.x / l,
        y = vec.y / l
    }
end

function Scale(vec, self)
    return {
        x = vec.x * self.speedx,
        y = vec.y * self.speedy
    }
end

function VecAc(vec, self)
    return {
        x = vec.x * self.accel,
        y = vec.y * self.accel
    }
end

function CollidesOne(point)
    local lx = x_tower
    local rx = x_tower + 25
    local ty = y_tower
    local by = y_tower + 100
    return point.x + point.width >= lx and
        point.x <= rx and
        point.y + point.height >= ty and
        point.y <= by
end

function CollidesTwo(point)
    local lx = x_tower + 75
    local rx = x_tower + 125
    local ty = y_tower
    local by = y_tower + 100
    return point.x + point.width >= lx and
        point.x <= rx and
        point.y + point.height >= ty and
        point.y <= by
end

function CollidesRectangle(point)
    local lx = aim.x
    local rx = aim.x + 50
    local ty = aim.y
    local by = aim.y + 100
    return point.x + point.width >= lx and
        point.x <= rx and
        point.y + point.height >= ty and
        point.y <= by
end

function AirUpdate(self, dt)
    if start then
        local dir = { x = 0, y = 0 }
        if self.lose == false then
            if love.keyboard.isDown('d') then
                dir.x = 1
                if love.keyboard.isDown('w') then
                    dir.y = -1
                end
                if love.keyboard.isDown('s') then
                    dir.y = 1
                end
            end
        end
        local vec = Normalize(dir)
        vel = Scale(vec, self)
        local ac = VecAc(vec, self)
        self.x = self.x + (vel.x + (ac.x * self.strike)) * dt
        self.y = self.y + (vel.y + (ac.y * self.strike)) * dt
        if vel.x == 0 and vel.y == 0 then
            self.x = self.x + (30 + (ac.x * self.strike)) * dt
            self.y = self.y + (100 + (ac.y * self.strike)) * dt
            self.tg = math.sqrt(3)
        else
            self.tg = vel.y / vel.x
        end


        vel = { x = 0, y = 0 }

        if CollidesOne(self) then
            self.strike = self.strike + 1
            self.respawn = true
        end
        if CollidesTwo(self) then
            self.strike = self.strike + 1.5
            self.respawn = true
        end
        if self.respawn then
            self.x = 20
            self.y = love.math.random(120, 300)
            if self.strike >= 5 then
                aim.x = love.math.random(0, 300)
                aim.y = love.math.random(0, 300)
            end
        end

        self.respawn = false
        dir = { x = 0, y = 0 }
        self.lose = false
        if self.strike >= 5 then
            table.insert(aims, aim)
        end
    end
end

--Стандарт скоростей: speedx=300,speedy=50,accel=10
function Start_game(self)
    if (love.mouse.getX() > 200 and love.mouse.getX() < 282) and (love.mouse.getY() > 150 and love.mouse.getY() < 202) then
        SOV = string.utf8sub('На советской скорости перегоним', 0, 35)
        love.graphics.print(SOV, 200, 222)
        if love.mouse.isDown(1) then
            Airplane = Airplane_SOV
            start = true
            self.speedx = 300
            self.speedy = 50
            self.accel = 10
            love.audio.stop()
            love.audio.play(Sound_SOV)
            self.country = 'SOV'
        end
    end
    if (love.mouse.getX() > 414 and love.mouse.getX() < 496) and (love.mouse.getY() > 364 and love.mouse.getY() < 416) then
        USA = string.utf8sub('Тише едешь - дальше будешь', 0, 35)
        love.graphics.print(USA, 380, 436)
        if love.mouse.isDown(1) then
            Airplane = Airplane_USA
            start = true
            self.speedx = 150
            self.speedy = 30
            self.accel = 50
            love.audio.stop()
            love.audio.play(Sound_USA)
            self.country = 'USA'
        end
    end
    if (love.mouse.getX() > 414 and love.mouse.getX() < 496) and (love.mouse.getY() > 150 and love.mouse.getY() < 202) then
        GER = string.utf8sub('Быстрее блицкрига', 0, 35)
        love.graphics.print(GER, 414, 222)
        if love.mouse.isDown(1) then
            Airplane = Airplane_GER
            start = true
            self.speedx = 550
            self.speedy = 200
            self.accel = 6
            love.audio.stop()
            love.audio.play(Sound_GER)
            self.country = 'GER'
        end
    end
    if (love.mouse.getX() > 200 and love.mouse.getX() < 282) and (love.mouse.getY() > 364 and love.mouse.getY() < 416) then
        ANA = string.utf8sub('Анархия - мать порядка', 0, 35)
        love.graphics.print(ANA, 200, 436)
        if love.mouse.isDown(1) then
            Airplane = Airplane_ANA
            start = true
            self.speedx = 300
            self.speedy = 50
            self.accel = 10
            love.audio.stop()
            love.audio.play(Sound_ANA)
            self.country = 'ANA'
        end
    end
    if (love.mouse.getX() > 314 and love.mouse.getX() < 364) and (love.mouse.getY() > 207 and love.mouse.getY() < 257) then
        SEC = string.utf8sub('?', 0, 1)
        love.graphics.print(SEC, 329, 277)
        if love.mouse.isDown(1) then
            Airplane = Airplane_SEC
            start = true
            self.speedx = 300
            self.speedy = 50
            self.accel = 10
            love.audio.stop()
            love.audio.play(Sound_SEC)
            self.country = 'SEC'
        end
    end
    return Airplane
end

function AirDraw(self)
    -- love.graphics.rotate(math.atan(self.tg))
    if start == false then
        love.audio.play(Sound_main)
        loading = string.utf8sub('Выбирай', 0, 7)
        love.graphics.print(loading, 350, 20)
        love.graphics.draw(SOV_icon, 200, 150)
        love.graphics.draw(USA_icon, 414, 364)
        love.graphics.draw(GER_icon, 414, 150)
        love.graphics.draw(ANA_icon, 200, 364)
        Start_game(self)
    else
        if self.country == 'ANA' and self.strike > 15 then
            love.graphics.draw(Airplane, self.x, self.y, math.random(0, 90))
        else
            love.graphics.draw(Airplane, self.x, self.y, math.atan(self.tg))
        end
    end
end

--function AimDraw(self)
--love.graphics.rectangle('fill', self.x, self.y, self.height, self.width)
--end

function Restart(self)
    if love.mouse.isDown(1) and (love.mouse.getX() > 130 and love.mouse.getX() < 160) and (love.mouse.getY() > 230 and love.mouse.getY() < 260) then
        self.x = 20
        self.y = 300
        self.strike = 0
    end
end

function Back(self)
    if love.mouse.isDown(1) and (love.mouse.getX() > 750 and love.mouse.getX() < 780) and (love.mouse.getY() > 40 and love.mouse.getY() < 55) then
        self.x = 20
        self.y = 300
        self.strike = 0
        start = false
        love.audio.stop()
    end
end

function Building(self)
    if start == true then
        --love.graphics.draw(Underground, 0, 375)
        love.graphics.setColor(255, z, z)
        if self.country == 'GER' then
            love.graphics.draw(Tower_GER, x_tower, y_tower)
            love.graphics.draw(Tower_GER, x_tower + 75, y_tower)
        end
        if self.country == 'USA' then
            love.graphics.draw(Tower_USA, x_tower, y_tower)
            love.graphics.draw(Tower_USA, x_tower + 75, y_tower)
        end
        if self.country == 'SOV' then
            love.graphics.draw(Tower2_SOV, x_tower, y_tower)
            love.graphics.draw(Tower1_SOV, x_tower + 75, y_tower)
        end
        if self.country == 'ANA' then
            self.accel = love.math.random(1, self.strike + 5)
            if self.strike > 5 then
                local ANA_t = { [0] = Tower1_ANA, [1] = Tower2_ANA }
                local k = love.math.random(0, 1)
                local l = love.math.random(0, 1)
                Tow1 = ANA_t[k]
                Tow2 = ANA_t[l]
                love.graphics.draw(Tow1, x_tower, y_tower)
                love.graphics.draw(Tow2, x_tower + 75, y_tower)
            else
                love.graphics.draw(Tower2_ANA, x_tower, y_tower)
                love.graphics.draw(Tower2_ANA, x_tower + 75, y_tower)
            end
        end
        if self.country == 'SEC' then
            love.graphics.draw(Tower2_SEC, x_tower, y_tower)
            love.graphics.draw(Tower1_SEC, x_tower + 75, y_tower)
        end
        love.graphics.draw(Back_button, 750, 40)
        Back(self)




        if (self.x + self.width > x_tower + 200) or (self.y + self.height > y_tower + 100) then
            love.graphics.print('You loh', 100, 200)

            self.lose = true
            love.graphics.draw(Restart_button, 130, 230)
            Restart(self)
            if self.records < self.strike then
                self.records = self.strike
            end
        end
        love.graphics.print(self.strike, 30, 40)
        love.graphics.print('You records' .. self.records, 70, 40)
    end
end

function love.update(dt)
    for _, a in ipairs(airs) do
        AirUpdate(a, dt)
    end
end

function love.draw()
    for _, a in ipairs(airs) do
        AirDraw(a)
        Building(a)
    end
end
