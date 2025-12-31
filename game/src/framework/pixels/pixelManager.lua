local PixelManager = {
	pixels = {}, -- location and color
	pixelBehaviors = {},
}

function PixelManager:init()
	-- init pixel colors
	self.possiblePixelColors = {
		{ 1, 0, 0, 1 }, -- red
		{ 0, 1, 0, 1 }, -- green
		{ 0, 0, 1, 1 } -- blue
	}
end

function PixelManager:spawnPixels(num)

	for i = 1, num, 1 do
		-- location
		local locX, locY = math.random(love.graphics.getWidth()), math.random(love.graphics.getHeight())
		
		-- color
		local randColorIndex = math.random(#self.possiblePixelColors)
		local randColor = self.possiblePixelColors[randColorIndex]
		
		-- behavior

		local newPixel = { locX, locY, unpack(randColor) }
		table.insert(self.pixels, newPixel)
	end
end

function PixelManager:update(dt)

end

function PixelManager:draw()
	love.graphics.points(self.pixels)
end

return PixelManager
