local BOUNDARY_PADDING = -300

local MAX_PIXEL_SPEED = 1000
local BOUNDARY_BOUNCE_RESTITUTION = .5

local PixelManager = {
	pixelData = {},
	pixelVelocity = {}
}

local PixelMeshVertextFormat = {
	{"VertexPosition", "float", 2},
	{"VertexColor", "byte", 4},
}

function PixelManager:init()
	love.graphics.setPointSize(5)
	self.pixelMesh = love.graphics.newMesh(PixelMeshVertextFormat, MAX_PIXELS, "points", "dynamic")
	self.pixelMeshShader = love.graphics.newShader("src/framework/pixels/pixelMeshShader.glsl")
end

function PixelManager:spawnPixels(num)

	for i = 1, num, 1 do

		local locX, locY = SimulationBoundary:getRandomPointInBoundary(.99)
	
		local newPoint = { locX, locY, math.random(), math.random(), math.random(), 1 }

		table.insert(self.pixelData, newPoint)
		table.insert(self.pixelVelocity, { math.random(-10, 10), math.random(-10, 10) } )
	end
end

function PixelManager:update(dt)
	if #self.pixelData == 0 then return end

	self.pixelMesh:setVertices(self.pixelData, 1, #self.pixelData)

	local function clampVelocity(current, max)
		if math.abs(current) > max then
			return max * (current > 0 and 1 or -1)
		end
		return current
	end

	local flowX, flowY
	local pixelData
	local pixelVelocity

	for pixel = 1, #self.pixelData, 1 do

		pixelData = self.pixelData[pixel]
		pixelVelocity = self.pixelVelocity[pixel]

		-- bounce on x
		if pixelData[1] > SimulationBoundary.boundaryRect.xMax or pixelData[1] < SimulationBoundary.boundaryRect.xMin then
			pixelVelocity[1] = pixelVelocity[1] * -BOUNDARY_BOUNCE_RESTITUTION
		end

		-- bounce on y
		if pixelData[2] > SimulationBoundary.boundaryRect.yMax or pixelData[2] < SimulationBoundary.boundaryRect.yMin then
			pixelVelocity[2] = pixelVelocity[2] * -BOUNDARY_BOUNCE_RESTITUTION
		end

		-- calculate the new velocity
		flowX, flowY = FlowField:getFlowAtWorldCoord(pixelData[1], pixelData[2])
		pixelVelocity[1] = clampVelocity(pixelVelocity[1] + flowX, MAX_PIXEL_SPEED)
		pixelVelocity[2] = clampVelocity(pixelVelocity[2] + flowY, MAX_PIXEL_SPEED)
		--pixelVelocity[1] = clampAbs(pixelVelocity[1] + ((mouseX - pixelData[1]) * .1 * dt), 30)
		--pixelVelocity[2] = clampAbs(pixelVelocity[2] + ((mouseY - pixelData[2]) * .1 * dt), 30)

		-- apply pixel's current velocity to its position
		pixelData[1] = pixelData[1] + (pixelVelocity[1] * dt)
		pixelData[2] = pixelData[2] + (pixelVelocity[2] * dt)
	end
end

function PixelManager:draw()
	love.graphics.setShader(self.pixelMeshShader)
	love.graphics.draw(self.pixelMesh)
	love.graphics.setShader()
end

return PixelManager
