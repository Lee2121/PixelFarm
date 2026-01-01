local FlowFieldTile = {}

TILE_SIZE = 16

local FlowFieldTile = {}
setmetatable(FlowFieldTile, FlowFieldTile)

function FlowFieldTile:__call()
	local newTile = setmetatable({}, self)
	newTile.flowX, newTile.flowY = 0, 0
	return newTile
end

return FlowFieldTile
