local FlowFieldModifier_Base = {}
setmetatable(FlowFieldModifier_Base, FlowFieldModifier_Base)
FlowFieldModifier_Base.__index = FlowFieldModifier_Base

function FlowFieldModifier_Base:__call(size)
	local newModifier = setmetatable({}, self)
	newModifier.size = size
	newModifier:new()
	newModifier.__index = self
	return newModifier
end

function FlowFieldModifier_Base:extend()
	local newModifier = {}
	newModifier.__index = newModifier
	setmetatable(newModifier, self)
	return newModifier
end

function FlowFieldModifier_Base:new()
end

function FlowFieldModifier_Base:initFrame()
end

function FlowFieldModifier_Base:calcTileFlow(tileIndex, tile)
	error("implement me!")
end

FlowFieldModifier_Mouse = FlowFieldModifier_Base:extend()
function FlowFieldModifier_Mouse:new()
	self.mouseX, self.mouseY = 0, 0
end

function FlowFieldModifier_Mouse:initFrame()
	self.mouseX, self.mouseY = GameCamera:mousePosition()
end

local tileX, tileY
local dist
local dirX, dirY
local dx, dy
function FlowFieldModifier_Mouse:calcTileFlow(tileIndex, tile)

	tileX, tileY = FlowField:getTilePos(tileIndex)
	
	dx = (self.mouseX - tileX)
	dy = (self.mouseY - tileY)
	
	dist = math.sqrt(dx * dx + dy * dy)
	
	if dist > 0 then
		dirX = dx/dist
		dirY = dy/dist
	else
		dirX = 0
		dirY = 0
	end

	return dirX, dirY
end

return FlowFieldModifier_Base
