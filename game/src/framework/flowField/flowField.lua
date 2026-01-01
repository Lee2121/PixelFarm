local FlowField = {}

local TILE_SIZE = 16

local FlowFieldTile = {}
setmetatable(FlowFieldTile, FlowFieldTile)

function FlowFieldTile:__call()
	local newTile = setmetatable({}, self)
	newTile.flowX, newTile.flowY = 0, 0
	return newTile
end

function FlowField:init()
	self.tiles = {}
	self.edgeLength = SimulationBoundary.boundaryRect.width / TILE_SIZE

	for tileIndex = 1, (self.edgeLength * self.edgeLength), 1 do
		self.tiles[tileIndex] = FlowFieldTile()
	end
end

function FlowField:update(dt)
	local mouseX, mouseY = GameCamera:mousePosition()
	local tileX, tileY
	local dist
	local dirX, dirY
	local dx, dy
	for index, tile in ipairs(self.tiles) do

		tileX, tileY = self:getTilePos(index)
		
		dx = (mouseX - tileX)
		dy = (mouseY - tileY)
		
		dist = math.sqrt(dx * dx + dy * dy)
		
		if dist > 0 then
			dirX = dx/dist
			dirY = dy/dist
		else
			dirX = 0
			dirY = 0
		end

		tile.flowX = dirX
		tile.flowY = dirY
	end
end

function FlowField:getFlowAtWorldCoord(x, y)
	if x < 0 or x >= self.edgeLength * TILE_SIZE or y < 0 or y >= self.edgeLength * TILE_SIZE then
		return 0, 0
	end
	local rowIndex = math.floor(x / TILE_SIZE)
	local columnIndex = math.floor(y / TILE_SIZE)
	local tileIndex = (rowIndex + (columnIndex * self.edgeLength)) + 1
	return self.tiles[tileIndex].flowX, self.tiles[tileIndex].flowY
end

function FlowField:getTilePos(tileIndex)
	local row = (tileIndex - 1) % self.edgeLength
	local column = (tileIndex - 1 - row) / self.edgeLength
	return row * TILE_SIZE, column * TILE_SIZE
end

function FlowField:debugDraw()
	love.graphics.setLineWidth(1)
	local tileX, tileY, tileCenterX, tileCenterY
	for index, tile in ipairs(self.tiles) do
		tileX, tileY = self:getTilePos(index)
		tileCenterX, tileCenterY = tileX + (TILE_SIZE / 2), tileY + (TILE_SIZE / 2)
		
		-- draw cells
		love.graphics.rectangle("line", tileX, tileY, TILE_SIZE, TILE_SIZE)
		
		-- draw flow direction
		love.graphics.line(tileCenterX, tileCenterY, tileCenterX + tile.flowX * 10, tileCenterY + tile.flowY * 10)
	end
end

return FlowField
