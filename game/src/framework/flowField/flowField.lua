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
	
end

function FlowField:getFlowAtWorldCoord(x, y)

	local columnIndex = y % TILE_SIZE
	local rowIndex = x % TILE_SIZE

	-- local column = self.tileColums[columnIndex]
	-- if column == nil then
	-- 	self.tileColums[columnIndex] = {}
	-- 	self.tileColums[columnIndex][rowIndex] = FlowFieldTile()
	-- else
	-- 	local row = column[columnIndex]
	-- 	if row == nil then
	-- 		-- create new row
	-- 	end
	-- end

end

function FlowField:draw()
	love.graphics.setLineWidth(1)
	local row, column
	for index, tile in ipairs(self.tiles) do
		row = (index - 1) % self.edgeLength
		column = (index - 1 - row) / self.edgeLength
		love.graphics.rectangle("line", row * TILE_SIZE, column * TILE_SIZE, TILE_SIZE, TILE_SIZE)
	end
end

return FlowField
