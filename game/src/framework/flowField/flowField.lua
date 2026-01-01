local FlowField = {}

local FlowFieldTile = require "src.framework.flowField.flowFieldTile"

local REDUCTION_RATE = 1

function FlowField:init()
	self.tiles = {}
	self.modifiers = {}
	self.edgeLength = SimulationBoundary.boundaryRect.width / TILE_SIZE

	for tileIndex = 1, (self.edgeLength * self.edgeLength), 1 do
		self.tiles[tileIndex] = FlowFieldTile(tileIndex, unpack({self:calcTilePos(tileIndex)}))
	end
end

function FlowField:addModifier(modifier)
	table.insert(self.modifiers, modifier)
end

function FlowField:removeModifier(modifier)
	for index = 1, #self.modifiers, 1 do
		if self.modifiers[index] == modifier then
			table.remove(self.modifiers, index)
			break
		end
	end
end

function FlowField:update(dt)
	for i = 1, #self.modifiers, 1 do
		self.modifiers[i]:initFrame()
	end
	for tileIndex, tile in ipairs(self.tiles) do
		for _, modifier in ipairs(self.modifiers) do
			if modifier:isTileInRange(tile) then
				-- TODO - modifiers should be apply in an additive way
				tile.flowX, tile.flowY = modifier:calcTileFlow(tile)
			else
				-- reduce back to 0
				tile.flowX = math.max(math.abs(tile.flowX) - dt * REDUCTION_RATE, 0) * (tile.flowX > 0 and 1 or -1)
				tile.flowY = math.max(math.abs(tile.flowY) - dt * REDUCTION_RATE, 0) * (tile.flowY > 0 and 1 or -1)  
			end
		end
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

function FlowField:calcTilePos(tileIndex)
	local row = (tileIndex - 1) % self.edgeLength
	local column = (tileIndex - 1 - row) / self.edgeLength
	return row * TILE_SIZE, column * TILE_SIZE
end

function FlowField:reset()
	for _, tile in ipairs(self.tiles) do
		tile.flowX, tile.flowY = 0, 0
	end
end

function FlowField:debugDraw()
	if not DebugCommands.bDebugDrawFlowField then return end
	love.graphics.setLineWidth(1)
	local tileX, tileY, tileCenterX, tileCenterY
	for index, tile in ipairs(self.tiles) do
		tileX, tileY = self:calcTilePos(index)
		tileCenterX, tileCenterY = tileX + (TILE_SIZE / 2), tileY + (TILE_SIZE / 2)
		
		-- draw cells
		love.graphics.setColor(.3, .3, .3, 1)
		love.graphics.rectangle("line", tileX, tileY, TILE_SIZE, TILE_SIZE)
		
		-- draw flow direction
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.line(tileCenterX, tileCenterY, tileCenterX + tile.flowX * 10, tileCenterY + tile.flowY * 10)
	end
end

return FlowField
