local PixelManager = {
	pixelData = {},
	pixelUpdateTimes = {}
}

local PixelMeshVertextFormat = {
	{"VertexPosition", "float", 2},
	{"VertexColor", "byte", 4},
	{"VertexVelocity", "float", 2}
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

		local locX, locY = math.random(love.graphics.getWidth() * -.5, love.graphics.getWidth() * .5), math.random(love.graphics.getHeight() * -.5, love.graphics.getHeight() * .5)
	
		local newPoint = { locX, locY, math.random(), math.random(), math.random(), 1, math.random(50), math.random(50) }
		table.insert(self.pixelData, newPoint)
		table.insert(self.pixelUpdateTimes, self.time)
	end
end

function PixelManager:update(dt)
	self.pixelMesh:setVertices(self.pixelData, 1, #self.pixelData)
	self.time = self.time + dt
	self.simpleTimer = self.simpleTimer + dt
	self.pixelMeshShader:send("time", self.simpleTimer)
	--self.pixelMeshShader:send("speed", 50)

	--if self.simpleTimer >= 2 then
		for pixel = 1, #self.pixelData, 1 do

			-- calculate where the GPU thinks this pixel is
			-- Pixel Position 		 = 		pixel location 		+ (		pixel velocity      * 			since last update 				)
			self.pixelData[pixel][1] = self.pixelData[pixel][1] + (self.pixelData[pixel][7] * (self.simpleTimer))
			self.pixelData[pixel][2] = self.pixelData[pixel][2] + (self.pixelData[pixel][8] * (self.simpleTimer))

			-- assign a new velocity
			self.pixelData[pixel][7] = math.random(-50, 50)
			self.pixelData[pixel][8] = math.random(-50, 50)

			-- store off the new updated time
			self.pixelUpdateTimes[pixel] = self.time
		end
		self.simpleTimer = 0
	--end

end

function PixelManager:draw()
	-- PIXEL MESH
	love.graphics.setShader(self.pixelMeshShader)
	love.graphics.draw(self.pixelMesh)
	love.graphics.setShader()
	-- END PIXEL MESH
end

return PixelManager
