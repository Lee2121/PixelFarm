local FlowFieldModifier_Base = {}
setmetatable(FlowFieldModifier_Base, FlowFieldModifier_Base)
FlowFieldModifier_Base.__index = FlowFieldModifier_Base

function FlowFieldModifier_Base:__call(posX, posY, size, ...)
	local newModifier = setmetatable({}, self)
	newModifier.posX, newModifier.posY = posX, posY
	newModifier.size = size
	newModifier.tileDistances = {} -- caches off the distance to any tiles in range
	newModifier.bEnabled = true
	newModifier:new(...)
	newModifier.__index = self
	return newModifier
end

function FlowFieldModifier_Base:extend()
	local newModifier = {}
	newModifier.__index = newModifier
	setmetatable(newModifier, self)
	return newModifier
end

function FlowFieldModifier_Base:new(...)
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

function FlowFieldModifier_Base:initUpdate(dt)
end

function FlowFieldModifier_Base:calcTileFlow(tile)
	error("implement me!")
end

FlowFieldModifier_Mouse = FlowFieldModifier_Base:extend()
function FlowFieldModifier_Mouse:new(...)
	self.prevPosX, self.prevPosY = self.posX, self.posY
	self.mouseVelX, self.mouseVelY = 0, 0
end

function FlowFieldModifier_Mouse:initUpdate(dt)
	self.posX, self.posY = GameCamera:mousePosition()
	self.mouseVelX, self.mouseVelY = (self.prevPosX - self.posX) / dt, (self.prevPosY - self.posY) / dt

	if love.mouse.isDown(1) then
		self.bEnabled = true
	else
		self.bEnabled = false
	end

	self.prevPosX, self.prevPosY = self.posX, self.posY
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
		-- calc normalized direction
		flowX = dx/dist
		flowY = dy/dist
	
		-- apply velocity to direction
		flowX = flowX + (self.mouseVelX * -.001)
		flowY = flowY + (self.mouseVelY * -.001)
	else
		flowX = 0
		flowY = 0
	end

	return flowX, flowY
end

FlowFieldModifier_Whirlpool = FlowFieldModifier_Base:extend()
function FlowFieldModifier_Whirlpool:new(initialIntensity, lifetime)
	self.initialIntensity = initialIntensity
	self.currentIntensity = initialIntensity
	self.lifetime = lifetime
	self.lifetimeTimer = 0
	self.initialSize = self.size
end

local intensityAlpha = 0
function FlowFieldModifier_Whirlpool:initUpdate(dt)
	self.lifetimeTimer = self.lifetimeTimer + dt

	-- clean ourselves up if our lifetime is done
	if self.lifetimeTimer > self.lifetime then
		FlowField:removeModifier(self)
		return
	end

	self.currentIntensity = self.initialIntensity - (self.initialIntensity * (self.lifetimeTimer / self.lifetime))
	self.size = self.initialSize - (self.initialSize * (self.lifetimeTimer / self.lifetime) )
end

local dx, dy
local dist
local WHIRLPOOL_ANGLE = 45
local cs = math.cos(math.rad(WHIRLPOOL_ANGLE))
local sn = math.sin(math.rad(WHIRLPOOL_ANGLE))
local dirX, dirY
function FlowFieldModifier_Whirlpool:calcTileFlow(tile)

	dist = self.tileDistances[tile.tileIndex]
	dx = (self.posX - tile.posX)
	dy = (self.posY - tile.posY)
	
	if dist > 0 then
		-- calc normalized direction
		dirX = dx/dist
		dirY = dy/dist
	else
		return 0, 0
	end

	-- the further from the outside, the more head on the force should be

	flowX = dirX * cs - dirY * sn
	flowY = dirY * sn + dirY * cs

	return flowX, flowY
end

return FlowFieldModifier_Base
