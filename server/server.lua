if not UseKey then
	RegisterCommand("engine", function(Source, Arguments, RawCommand)
		if #Arguments == 0 then
			TriggerClientEvent('EngineToggle:Engine', Source)
		end
	end, false)
end