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
	self.time = 0
	self.simpleTimer = 0
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
	self.time = self.time + dt
	self.simpleTimer = self.simpleTimer + dt

	local flowX, flowY

	local function clampVelocity(current, max)
		if math.abs(current) > max then
			return max * (current > 0 and 1 or -1)
		end
		return current
	end

	for pixel = 1, #self.pixelData, 1 do

		-- bounce on x
		if self.pixelData[pixel][1] > SimulationBoundary.boundaryRect.xMax or self.pixelData[pixel][1] < SimulationBoundary.boundaryRect.xMin then
			self.pixelVelocity[pixel][1] = self.pixelVelocity[pixel][1] * -BOUNDARY_BOUNCE_RESTITUTION
		end

		-- bounce on y
		if self.pixelData[pixel][2] > SimulationBoundary.boundaryRect.yMax or self.pixelData[pixel][2] < SimulationBoundary.boundaryRect.yMin then
			self.pixelVelocity[pixel][2] = self.pixelVelocity[pixel][2] * -BOUNDARY_BOUNCE_RESTITUTION
		end

		-- calculate the new velocity
		flowX, flowY = FlowField:getFlowAtWorldCoord(self.pixelData[pixel][1], self.pixelData[pixel][2])
		self.pixelVelocity[pixel][1] = clampVelocity(self.pixelVelocity[pixel][1] + flowX, MAX_PIXEL_SPEED)
		self.pixelVelocity[pixel][2] = clampVelocity(self.pixelVelocity[pixel][2] + flowY, MAX_PIXEL_SPEED)
		--self.pixelVelocity[pixel][1] = clampAbs(self.pixelVelocity[pixel][1] + ((mouseX - self.pixelData[pixel][1]) * .1 * dt), 30)
		--self.pixelVelocity[pixel][2] = clampAbs(self.pixelVelocity[pixel][2] + ((mouseY - self.pixelData[pixel][2]) * .1 * dt), 30)

		-- apply pixel's current velocity to its position
		self.pixelData[pixel][1] = self.pixelData[pixel][1] + (self.pixelVelocity[pixel][1] * dt)
		self.pixelData[pixel][2] = self.pixelData[pixel][2] + (self.pixelVelocity[pixel][2] * dt)
	end
	self.simpleTimer = 0
end

function PixelManager:draw()
	love.graphics.setShader(self.pixelMeshShader)
	love.graphics.draw(self.pixelMesh)
	love.graphics.setShader()
end

return PixelManager
