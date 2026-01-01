HumpCamera = require "lib.hump.camera"
BackgroundGrid = require "src.framework.grid.backgroundGrid"

PixelManager = require "src.framework.pixels.pixelManager"
SimulationBoundary = require "src.framework.simulationBoundary"

FlowField = require "src.framework.flowField.flowField"
FlowFieldModifiers = require "src.framework.flowField.flowFieldModifier"

DebugCommands = require "src.framework.debugCommands"

MAX_PIXELS = 100000

GameCamera = {}
local CAMERA_SPEED = 500
local camTargetX, camTargetY = 0, 0

function love.load()
	love.graphics.setDefaultFilter( 'nearest', 'nearest' )

	SimulationBoundary:init(512)

	camTargetX, camTargetY = (SimulationBoundary.boundaryRect.width / 2) - 70, SimulationBoundary.boundaryRect.height / 2
	GameCamera = HumpCamera(camTargetX, camTargetY)

	BackgroundGrid:init()

	FlowField:init()
	local mouseX, mouseY = GameCamera:mousePosition()
	local mouseFieldModifier = FlowFieldModifier_Mouse(mouseX, mouseY, 30)
	FlowField:addModifier(mouseFieldModifier)

	PixelManager:init()
	PixelManager:spawnPixels(MAX_PIXELS)
end

function love.update(dt)

	-- limit DT
	if dt > .007 then dt = .007 end
	
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

	FlowField:getFlowAtWorldCoord(GameCamera:mousePosition())

	camTargetX = camTargetX + cameraInput[1] * dt * CAMERA_SPEED
	camTargetY = camTargetY + cameraInput[2] * dt * CAMERA_SPEED
	GameCamera:lockPosition(camTargetX, camTargetY, GameCamera.smooth.damped(2))
end

function love.keypressed(key, scancode, isRepeat)
	DebugCommands:handleKeyPressed(key)
end

function love.draw()
		
	BackgroundGrid:draw()

	GameCamera:attach()
	
		PixelManager:draw()
		SimulationBoundary:draw()
		FlowField:debugDraw()

	GameCamera:detach()

	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
	love.graphics.print("Num Particles: "..tostring(#PixelManager.pixelData), 10, 30)
end
