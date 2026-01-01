local FlowFieldTile = {}

TILE_SIZE = 16

local FlowFieldTile = {}
setmetatable(FlowFieldTile, FlowFieldTile)

function FlowFieldTile:__call(tileIndex, posX, posY)
	local newTile = setmetatable({}, self)
	newTile.tileIndex = tileIndex
	newTile.posX, newTile.posY = posX, posY
	newTile.flowX, newTile.flowY = 0, 0
	return newTile
end

return FlowFieldTile
