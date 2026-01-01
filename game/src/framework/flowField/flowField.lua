local FlowField = {}

local TILE_SIZE = 32

function FlowField:init()
	self.tileColums = { tileRows = {} }
end

function FlowField:update(dt)
	
end

function FlowField:getFlowAtWorldCoord(x, y)

	local rowIndex = x % TILE_SIZE
	local columnIndex = y % TILE_SIZE

	local flowTile = {}

end

function FlowField:draw()

end

return FlowField
