local FlowFieldModifier_Base = {}
setmetatable(FlowFieldModifier_Base, FlowFieldModifier_Base)
FlowFieldModifier_Base.__index = FlowFieldModifier_Base

function FlowFieldModifier_Base:__call(size)
	local newModifier = setmetatable({}, self)
	newModifier.size = size
	newModifier.posX, newModifier.posY = 0, 0
	newModifier.tileDistances = {} -- caches off the distance to any tiles in range
	newModifier.bEnabled = true
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

local dx, dy = 0, 0
local dist = 0
function FlowFieldModifier_Base:isTileInRange(tile)
	if not self.bEnabled then return false end

	dx = (self.posX - tile.posX)
	dy = (self.posY - tile.posY)
	dist = math.sqrt(dx * dx + dy * dy)

	self.tileDistances[tile.tileIndex] = dist
	
	return dist <= self.size
end

function FlowFieldModifier_Base:initFrame()
end

function FlowFieldModifier_Base:calcTileFlow(tile)
	error("implement me!")
end

FlowFieldModifier_Mouse = FlowFieldModifier_Base:extend()
function FlowFieldModifier_Mouse:initFrame()
	self.posX, self.posY = GameCamera:mousePosition()

	if love.mouse.isDown(1) then
		self.bEnabled = true
	else
		self.bEnabled = false
	end
end

-- declare variables here so they aren't redefined every time we run calcTileFlow
local flowX, flowY
local dx, dy
local dist
function FlowFieldModifier_Mouse:calcTileFlow(tile)
	
	dist = self.tileDistances[tile.tileIndex]
	dx = (self.posX - tile.posX)
	dy = (self.posY - tile.posY)
	
	if dist > 0 then
		flowX = dx/dist
		flowY = dy/dist
	else
		flowX = 0
		flowY = 0
	end

	return flowX, flowY
end

return FlowFieldModifier_Base
