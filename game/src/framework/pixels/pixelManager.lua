local PixelAtlas = {}

function PixelAtlas:init()
	self.image = love.graphics.newImage("assets/PixelAtlas.png")
	self.black = love.graphics.newQuad(0, 0, 1, 1, self.image)
	self.white = love.graphics.newQuad(0, 1, 1, 1, self.image)
	self.red = love.graphics.newQuad(0, 2, 1, 1, self.image)
	self.green = love.graphics.newQuad(0, 3, 1, 1, self.image)
	self.blue = love.graphics.newQuad(1, 0, 1, 1, self.image)
end

local PixelManager = {
	pixelLocations = {},
	pixelColors = {},
	pixelBehaviors = {},

	pixelPoints = {}
}

local PixelMeshVertextFormat = {
	{"VertexPosition", "float", 2},
	{"VertexColor", "byte", 4},
}

function PixelManager:init()
	PixelAtlas:init()
	love.graphics.setPointSize(5)
	self.possiblePixelColors = { PixelAtlas.red, PixelAtlas.green, PixelAtlas.blue }
	self.spriteBatch = love.graphics.newSpriteBatch(PixelAtlas.image, 1000000, "dynamic")

	--self.pixelShader = love.graphics.newShader("src/framework/pixels/pixelShader.glsl")

	self.pixelMesh = love.graphics.newMesh(PixelMeshVertextFormat, MAX_PIXELS, "points", "dynamic")
	self.pixelMeshShader = love.graphics.newShader("src/framework/pixels/pixelMeshShader.glsl")
	self.time = 0
end

function PixelManager:spawnPixels(num)

	for i = 1, num, 1 do
		-- location
		local locX, locY = math.random(love.graphics.getWidth() * -.5, love.graphics.getWidth() * .5), math.random(love.graphics.getHeight() * -.5, love.graphics.getHeight() * .5)
		table.insert(self.pixelLocations, { locX, locY })
		
		-- color
		local randColorIndex = math.random(#self.possiblePixelColors)
		local randColor = self.possiblePixelColors[randColorIndex]
		table.insert(self.pixelColors, randColor)
		
		-- behavior
		
		math.randomseed(i)
		local newPoint = { locX, locY, math.random(), math.random(), math.random(), 1 }
		table.insert(self.pixelPoints, newPoint)
	end
end

function PixelManager:update(dt)
	self.pixelMesh:setVertices(self.pixelPoints, 1, #self.pixelPoints)
	self.time = self.time + dt
	self.pixelMeshShader:send("time", self.time)
end

function PixelManager:draw()
	-- SPRITE BATCH
	-- self.spriteBatch:clear()
	-- for pixel = 1, #self.pixelColors, 1 do
	-- 	self.spriteBatch:add(self.pixelColors[pixel], unpack(self.pixelLocations[pixel]))
	-- end
	-- love.graphics.draw(self.spriteBatch)
	-- END SPRITE BATCH

	-- PIXEL POINTS
	--love.graphics.points(self.pixelPoints)
	-- END PIXEL POINTS

	-- PIXEL SHADER
	-- self.pixelShader:send("pixelPositions", self.pixelLocations)
	-- love.graphics.setShader(self.pixelShader)
	-- love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	-- love.graphics.setShader()
	-- END PIXEL SHADER

	-- PIXEL MESH
	love.graphics.setShader(self.pixelMeshShader)
	love.graphics.draw(self.pixelMesh)
	love.graphics.setShader()
	-- END PIXEL MESH
end

return PixelManager
