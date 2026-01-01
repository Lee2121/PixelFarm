local SimulationBoundary = {}

function SimulationBoundary:init(size)
	self.boundaryRect = { xMin = 0, yMin = 0, xMax = size, yMax = size }
	self.boundaryRect.width = self.boundaryRect.xMax - self.boundaryRect.xMin 
	self.boundaryRect.height = self.boundaryRect.yMax - self.boundaryRect.yMin
end

function SimulationBoundary:getRandomPointInBoundary(edgeTolerance)
	edgeTolerance = edgeTolerance or 1
	return math.random(self.boundaryRect.xMin * edgeTolerance, self.boundaryRect.xMax * edgeTolerance), math.random(self.boundaryRect.yMin * edgeTolerance, self.boundaryRect.yMax * edgeTolerance)
end

function SimulationBoundary:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setLineWidth(5)
	love.graphics.rectangle("line", self.boundaryRect.xMin, self.boundaryRect.yMin, self.boundaryRect.width, self.boundaryRect.height )
end

return SimulationBoundary
