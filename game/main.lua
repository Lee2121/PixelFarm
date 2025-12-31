HumpCamera = require "lib.hump.camera"
BackgroundGrid = require "src.framework.grid.backgroundGrid"

PixelManager = require "src.framework.pixels.pixelManager"

MAX_PIXELS = 1000000

GameCamera = {}
local CameraSpeed = 100

function love.load()
	love.graphics.setDefaultFilter( 'nearest', 'nearest' )
	GameCamera = HumpCamera(0, 0)
	BackgroundGrid:init()

	PixelManager:init()
	PixelManager:spawnPixels(100000)
end

function love.update(dt)
	
	PixelManager:update(dt)

	local cameraInput = { 0, 0 }
	if love.keyboard.isDown('a', "left") then
		cameraInput[1] = cameraInput[1] - 1
	end
	if love.keyboard.isDown('d', "right") then
		cameraInput[1] = cameraInput[1] + 1
	end
	if love.keyboard.isDown('w', 'up') then
		cameraInput[2] = cameraInput[2] - 1
	end
	if love.keyboard.isDown('s', "down") then
		cameraInput[2] = cameraInput[2] + 1
	end

	GameCamera:move(cameraInput[1] * dt * CameraSpeed, cameraInput[2] * dt * CameraSpeed)
end

function love.draw()
	
	BackgroundGrid:draw()

	GameCamera:attach()

	-- draw game objects here
	--love.graphics.rectangle("fill", 0, 0, 1, 1)
	PixelManager:draw()

	GameCamera:detach()


	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end
