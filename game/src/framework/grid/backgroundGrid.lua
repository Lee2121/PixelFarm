local BackgroundGrid = {}

function BackgroundGrid:init()
	self.gridShader = love.graphics.newShader("src/framework/grid/gridShader.glsl")
	self.gridShader:send("gridSize", 128)
	self.gridShader:send("lineColor", { .1, .1, .1, 1 })
end

function BackgroundGrid:draw()
	love.graphics.setShader(self.gridShader)
	self.gridShader:send("cameraCoords", { GameCamera:position() })
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	love.graphics.setShader()
end

return BackgroundGrid
