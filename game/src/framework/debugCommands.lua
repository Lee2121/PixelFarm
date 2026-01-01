local DebugCommands = {
	bDebugDrawFlowField = false
}

function DebugCommands:handleKeyPressed(key)
	if key == 'f' then self.bDebugDrawFlowField = not self.bDebugDrawFlowField end
end

return DebugCommands
