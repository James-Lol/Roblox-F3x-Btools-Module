local Module = {}

function Module.Import(ImportCode,DelayPerPart)
	ImportCode = ImportCode or "----"
	DelayPerPart = DelayPerPart or 0.03
	DelayPerPart = math.max(DelayPerPart,0.01)

	local BtoolsModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/James-Lol/Roblox-F3x-Btools-Module/refs/heads/main/Module.Lua"))()
	local HttpService = game:GetService("HttpService")
	local ExportBaseUrl = 'http://www.f3xteam.com/bt/export/%s'

	local function ImportCreationData(CreationId)
		local CreationData
		local Success, ErrorMessage = pcall(function()
			local Response = game:HttpGet(ExportBaseUrl:format(CreationId))
			CreationData = HttpService:JSONDecode(Response)
		end)

		if Success and CreationData then
			return CreationData
		else
			warn("Failed To Import Creation Data: " .. (ErrorMessage or "Unknown Error"))
			return nil
		end
	end

	local CreationData = ImportCreationData(ImportCode)
	if not CreationData then return nil end

	if CreationData.Version ~= 3 then
		warn("Unsupported Version: " .. tostring(CreationData.Version))
		return nil
	end

	local ObjectTypes = {
		Part = 0,
		WedgePart = 1,
		CornerWedgePart = 2,
		VehicleSeat = 3,
		Seat = 4,
		TrussPart = 5,
		SpecialMesh = 6,
		Texture = 7,
		Decal = 8,
		PointLight = 9,
		SpotLight = 10,
		SurfaceLight = 11,
		Smoke = 12,
		Fire = 13,
		Sparkles = 14
	}

	local DefaultObjectNames = {
		Part = "Part",
		WedgePart = "Wedge",
		CornerWedgePart = "CornerWedge",
		VehicleSeat = "VehicleSeat",
		Seat = "Seat",
		TrussPart = "Truss",
		SpecialMesh = "Mesh",
		Texture = "Texture",
		Decal = "Decal",
		PointLight = "PointLight",
		SpotLight = "SpotLight",
		SurfaceLight = "SurfaceLight",
		Smoke = "Smoke",
		Fire = "Fire",
		Sparkles = "Sparkles"
	}

	local function SliceArray(Array, StartIndex, EndIndex)
		local SlicedArray = {}
		for Index = StartIndex, EndIndex do
			table.insert(SlicedArray, Array[Index])
		end
		return SlicedArray
	end

	local ConstructedObjects = {}

	if not CreationData.Items or type(CreationData.Items) ~= "table" then
		warn("Invalid Or Missing Items In CreationData.")
		return nil
	end

	for Index, ItemData in ipairs(CreationData.Items) do
		if type(ItemData) ~= "table" then
			warn("Invalid Item Data At Index " .. Index)
			continue
		end

		coroutine.wrap(function()
			local CreatedObject
			print(ItemData[1],ItemData.ClassName)
			if ItemData[1] <= ObjectTypes.TrussPart then
				local PartType = "Normal"
				if ItemData[1] == ObjectTypes.WedgePart then
					PartType = "Wedge"
				elseif ItemData[1] == ObjectTypes.CornerWedgePart then
					PartType = "Corner"
				elseif ItemData[1] == ObjectTypes.VehicleSeat then
					PartType = "Vehicle Seat"
				elseif ItemData[1] == ObjectTypes.Seat then
					PartType = "Seat"
				elseif ItemData[1] == ObjectTypes.TrussPart then
					PartType = "Truss"
				end

				local CFrameValue = CFrame.new(unpack(SliceArray(ItemData, 7, 18)))

				local PartParent = game.Workspace

				CreatedObject = BtoolsModule.CreatePart(CFrameValue, PartParent, PartType)

				if CreatedObject then
					BtoolsModule.Resize(CreatedObject, Vector3.new(unpack(SliceArray(ItemData, 4, 6))), CFrameValue)
					BtoolsModule.Color(CreatedObject, Color3.new(ItemData[19], ItemData[20], ItemData[21]))
					BtoolsModule.SetMaterial(CreatedObject, ItemData[22])
					BtoolsModule.SetAnchor(CreatedObject, ItemData[23] == 1)
					BtoolsModule.SetCollision(CreatedObject, ItemData[24] == 1)
					BtoolsModule.SetReflectance(CreatedObject, ItemData[25])
					BtoolsModule.SetTransparency(CreatedObject, ItemData[26])
					BtoolsModule.Surface(CreatedObject, {
						["Top"] = ItemData[27],
						["Bottom"] = ItemData[28],
						["Front"] = ItemData[29],
						["Back"] = ItemData[30],
						["Left"] = ItemData[31],
						["Right"] = ItemData[32]
					})
					ConstructedObjects[Index] = CreatedObject
				else
					warn("Failed To Create Part.")
				end
			end
		end)()

		task.wait(DelayPerPart)
	end

	return ConstructedObjects
end

return Module
