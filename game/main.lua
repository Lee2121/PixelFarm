HumpCamera = require "lib.hump.camera"
BackgroundGrid = require "src.framework.grid.backgroundGrid"

PixelManager = require "src.framework.pixels.pixelManager"

GameCamera = {}

function love.load()
	love.graphics.setDefaultFilter( 'nearest', 'nearest' )
	GameCamera = HumpCamera(0, 0)
	BackgroundGrid:init()

	PixelManager:init()
	PixelManager:spawnPixels(100000)
end

function love.update(dt)
	

	--GameCamera:move(1, 1)
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
