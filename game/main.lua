HumpCamera = require "lib.hump.camera"
BackgroundGrid = require "src.framework.grid.backgroundGrid"

PixelManager = require "src.framework.pixels.pixelManager"

FlowField = require "src.framework.flowField.flowField"

SimulationBoundary = require "src.framework.simulationBoundary"

MAX_PIXELS = 100000

GameCamera = {}
local CAMERA_SPEED = 500
local camTargetX, camTargetY = 0, 0

function love.load()
	love.graphics.setDefaultFilter( 'nearest', 'nearest' )
	
	camTargetX, camTargetY = love.graphics.getWidth() / 2, love.graphics.getHeight() / 2
	GameCamera = HumpCamera(camTargetX, camTargetY)

	SimulationBoundary:init(-500)

	BackgroundGrid:init()

	FlowField:init()

	PixelManager:init()
	PixelManager:spawnPixels(MAX_PIXELS)
end

function love.update(dt)
	
	FlowField:update(dt)

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

	camTargetX = camTargetX + cameraInput[1] * dt * CAMERA_SPEED
	camTargetY = camTargetY + cameraInput[2] * dt * CAMERA_SPEED
	GameCamera:lockPosition(camTargetX, camTargetY, GameCamera.smooth.damped(2))
end

function love.draw()
	
	BackgroundGrid:draw()
	FlowField:draw()

	GameCamera:attach()
		SimulationBoundary:draw()
		PixelManager:draw()
	GameCamera:detach()

	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end
