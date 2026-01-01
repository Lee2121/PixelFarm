local DebugCommands = {
	bDebugDrawFlowField = false
}

function DebugCommands:handleKeyPressed(key)
	if key == 'f' then self.bDebugDrawFlowField = not self.bDebugDrawFlowField
	elseif key == 'r' then PixelManager:reset() FlowField:reset() end
end

return DebugCommands
