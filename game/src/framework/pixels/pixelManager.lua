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
	love.graphics.setPointSize(2.5)
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

function PixelManager:reset()
	local numOriginalPixels = #self.pixelData
	self.pixelData = {}
	self.pixelVelocity = {}
	self:spawnPixels(numOriginalPixels)
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
	local posX, posY
	local velX, velY

	for pixel = 1, #self.pixelData, 1 do

		pixelData = self.pixelData[pixel]
		posX, posY = pixelData[1], pixelData[2]
		pixelVelocity = self.pixelVelocity[pixel]
		velX, velY =  pixelVelocity[1], pixelVelocity[2]

		-- bounce on x
		if posX > SimulationBoundary.boundaryRect.xMax or posX < SimulationBoundary.boundaryRect.xMin then
			velX = velX * -BOUNDARY_BOUNCE_RESTITUTION
			posX = (posX > SimulationBoundary.boundaryRect.xMax and SimulationBoundary.boundaryRect.xMax or SimulationBoundary.boundaryRect.xMin) -- snap pixel back into bounds
		end

		-- bounce on y
		if posY > SimulationBoundary.boundaryRect.yMax or posY < SimulationBoundary.boundaryRect.yMin then
			velY = velY * -BOUNDARY_BOUNCE_RESTITUTION
			posY = (posY > SimulationBoundary.boundaryRect.yMax and SimulationBoundary.boundaryRect.yMax or SimulationBoundary.boundaryRect.yMin) -- snap pixel back into bounds
		end

		-- read from the flow field
		flowX, flowY = FlowField:getFlowAtWorldCoord(posX, posY)

		-- apply calculated velocity to the pixel's velocity
		pixelVelocity[1] = clampVelocity(velX + flowX, MAX_PIXEL_SPEED)
		pixelVelocity[2] = clampVelocity(velY + flowY, MAX_PIXEL_SPEED)

		-- apply pixel's velocity to its position
		pixelData[1] = posX + (velX * dt)
		pixelData[2] = posY + (velY * dt)
	end
end

function PixelManager:draw()
	love.graphics.setShader(self.pixelMeshShader)
	love.graphics.draw(self.pixelMesh)
	love.graphics.setShader()
end

return PixelManager
