if (not script.Parent:IsA('ModuleScript')) then
	error('\'main\' for tfog must be parented to the module!')
end

local Players = game:GetService('Players')
local cfg = require(script.Parent)

local function waitForChildOfClass(object, class)
	local foundClass;
	repeat
		foundClass = object:FindFirstChildOfClass(class)
		if (not foundClass) then
			object.ChildAdded:Wait()
		end
	until foundClass
	return foundClass
end

local function set(arr)
	local set = {}
	for _, obj in ipairs(arr) do
		set[obj] = true
	end
	return set
end

local function traverse(objs, traverseClassNames, includeClassNames, maxDepth, depth, list)
	depth = depth or 1
	maxDepth = maxDepth or -1

	if (maxDepth == depth) then
		return
	end

	list = list or {}

	local newDepth = depth + 1
	for p = 1, #objs do
		local parentObject = objs[p]
		local children = parentObject:GetChildren()
		local traverseChildren, doTraverse = {}, false

		for c = 1, #children do
			local child = children[c]
			if (traverseClassNames and traverseClassNames[child.ClassName]) then
				traverseChildren[#traverseChildren + 1] = child
				doTraverse = true
			end

			if (includeClassNames and includeClassNames[child.ClassName]) then
				list[#list + 1] = child
			end
		end

		if (doTraverse) then
			traverse(
				traverseChildren,
				traverseClassNames,
				includeClassNames,
				maxDepth,
				newDepth,
				list
			)
		end
	end

	return list
end

local function yieldFigure(figure)
	local retrieved = {}
	retrieved.humanoid = waitForChildOfClass(figure, 'Humanoid')
	return retrieved
end

local function clearMakeupDescriptions(parts)
	local appliedDescription = parts.humanoid:GetAppliedDescription()
	
	-- use getdescendants just in-case roblox wants to change the hierarchy/ancestry of makeupdescriptions
	for _, object in (appliedDescription:GetDescendants()) do
		if (object:IsA('MakeupDescription')) then
			object.Instance:Destroy()
			object:Destroy()
		end
	end
end

local function clearAccessories(figure)
	for _, object in (figure:GetDescendants()) do
		if (object:IsA('Accoutrement')) then
			if (cfg.accessoryTaboo and not cfg.deleteAnyModernJunk) then
				local lowerName = string.lower(object.Name)
				for _, taboo in (cfg.accessoryTaboo) do
					if (string.find(lowerName, taboo)) then
						object:Destroy()
						break
					end
				end
			end
		elseif (
			object:IsA('BaseWrap') or
			object:IsA('WrapTextureTransfer')
		) then
			if (cfg.deleteAnyModernJunk) then
				local accoutrement = object:FindFirstAncestorWhichIsA('Accoutrement')
				if (accoutrement) then
					accoutrement:Destroy()
				end
			end
			
			object:Destroy()
		elseif (object:IsA('Decal')) then
			if (object.ColorMapContent.SourceType == Enum.ContentSourceType.None) then
				object:Destroy()
			end
		end
	end
end

local function applyFigure(figure)
	local parts = yieldFigure(figure)
	
	if (cfg.noMakeup) then
		clearMakeupDescriptions(parts)
		parts.humanoid.ApplyDescriptionFinished:Connect(function() -- no chances.
			clearMakeupDescriptions(parts)
		end)
		
		if (cfg.micellar) then
			clearAccessories(figure)
			figure.DescendantAdded:Connect(function(object) -- NO chances!
				clearAccessories(figure)
			end)
		end
	end
end

local function characterAdded(player, character)
	applyFigure(character)
	
	local humanoid = waitForChildOfClass(character, 'Humanoid')
	local humanoidDescription: HumanoidDescription = humanoid:GetAppliedDescription()
	-- micellar
end

local function playerAdded(player)
	characterAdded(player, player.Character or player.CharacterAdded:Wait())
	player.CharacterAdded:Connect(function(character)
		characterAdded(player, character)
	end)
end

local function humanoidAdded(humanoid)
	if (humanoid.Parent:IsA('Model') and not Players:GetPlayerFromCharacter(humanoid)) then
		applyFigure(humanoid.Parent)
	end
end

if (cfg.applyPlayers) then
	for _, player in (Players:GetPlayers()) do
		task.spawn(playerAdded, player)
	end
	
	Players.PlayerAdded:Connect(playerAdded)
end

if (cfg.applyOtherHumanoids) then
	if (cfg.instancesToTraverseForHumanoid) then
		cfg.instancesToTraverseForHumanoid = set(cfg.instancesToTraverseForHumanoid)
	end
	
	local search = traverse(
		{workspace},
		cfg.instancesToTraverseForHumanoid,
		set{'Humanoid'},
		cfg.applyOtherHumanoidsDepth
	)
	
	for _, humanoid in (search) do
		task.spawn(humanoidAdded, humanoid)
	end
	
	workspace.DescendantAdded:Connect(function(object)
		if (object:IsA('Humanoid')) then
			task.spawn(humanoidAdded, object)
		end
	end)
end

return {
	ApplyTo = function(_, figure)
		return applyFigure(figure)
	end,
	
	ClearMakeupDescriptions = function(_, figure)
		return clearMakeupDescriptions(yieldFigure(figure))
	end,
	
	ClearAllEvil = function(_, figure)
		return clearAccessories(figure)
	end,
}