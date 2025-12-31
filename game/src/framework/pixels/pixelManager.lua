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

function PixelManager:init()
	PixelAtlas:init()

	self.possiblePixelColors = { PixelAtlas.red, PixelAtlas.green, PixelAtlas.blue }
	self.spriteBatch = love.graphics.newSpriteBatch(PixelAtlas.image)

	self.pixelShader = love.graphics.newShader("src/framework/pixels/pixelShader.glsl")
end

function PixelManager:spawnPixels(num)

	for i = 1, num, 1 do
		-- location
		local locX, locY = math.random(love.graphics.getWidth()), math.random(love.graphics.getHeight())
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

end

function PixelManager:draw()
	-- self.spriteBatch:clear()
	-- for pixel = 1, #self.pixelColors, 1 do
	-- 	self.spriteBatch:add(self.pixelColors[pixel], unpack(self.pixelLocations[pixel]))
	-- end
	-- love.graphics.draw(self.spriteBatch)

	--love.graphics.points(self.pixelPoints)
	self.pixelShader:send("pixelPositions", self.pixelLocations)
	love.graphics.setShader(self.pixelShader)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	love.graphics.setShader()
end

return PixelManager
