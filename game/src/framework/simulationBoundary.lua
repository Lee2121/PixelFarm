local SimulationBoundary = {}

function SimulationBoundary:init(screenPadding)
	self.boundaryRect = { xMin = screenPadding, yMin = screenPadding, xMax = love.graphics.getWidth() - screenPadding, yMax = love.graphics.getHeight() - screenPadding }
	self.boundaryRect.width = self.boundaryRect.xMax - self.boundaryRect.xMin 
	self.boundaryRect.height = self.boundaryRect.yMax - self.boundaryRect.yMin
end

function SimulationBoundary:getRandomPointInBoundary()
	return math.random(self.boundaryRect.xMin, self.boundaryRect.xMax), math.random(self.boundaryRect.yMin, self.boundaryRect.yMax)
end

function SimulationBoundary:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("line", self.boundaryRect.xMin, self.boundaryRect.yMin, self.boundaryRect.width, self.boundaryRect.height )
end


return SimulationBoundary
