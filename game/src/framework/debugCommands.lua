local DebugCommands = {
	bDebugDrawFlowField = false
}

function DebugCommands:handleKeyPressed(key)
	if key == 'f' then self.bDebugDrawFlowField = not self.bDebugDrawFlowField
	elseif key == 'r' then PixelManager:reset() FlowField:reset() 
	elseif key == 't' then 
		local mouseX, mouseY = GameCamera:mousePosition()
		FlowField:addModifier(FlowFieldModifier_Whirlpool(mouseX, mouseY, 100, 50, 3)) 
	end
end

return DebugCommands
