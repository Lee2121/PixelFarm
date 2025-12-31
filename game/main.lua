HumpCamera = require "lib.hump.camera"
BackgroundGrid = require "src.framework.grid.backgroundGrid"

GameCamera = {}

function love.load()
	love.graphics.setDefaultFilter( 'nearest', 'nearest' )
	GameCamera = HumpCamera(0, 0)
	BackgroundGrid:init()
end

function love.update(dt)
	GameCamera:move(1, 1)
end

function love.draw()
	
	BackgroundGrid:draw()

	GameCamera:attach()

	-- draw game objects here
	love.graphics.rectangle("fill", 0, 0, 1, 1)

	GameCamera:detach()

	-- draw UI her
end
