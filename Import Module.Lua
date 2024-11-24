local Module = {}

function Module.Import(ImportCode,DelayPerPart)
	ImportCode = ImportCode or "----"
	DelayPerPart = DelayPerPart or 0.03
	DelayPerPart = math.max(DelayPerPart,0.01)

	local BtoolsModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/James-Lol/Roblox-F3x-Btools-Module/refs/heads/main/Module.Lua"))()
	local HttpService = game:GetService("HttpService")
	local ExportBaseUrl = "http://www.f3xteam.com/bt/export/%s"

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

	local Items = CreationData["Items"]

	local ConstructedObjects = {}

	local PartTypes = {
		[0] = "Normal",
		[1] = "Wedge",
		[2] = "Corner",
		[3] = "Vehicle Seat",
		[4] = "Seat",
		[5] = "Truss",
		[8] = "Spawn"
	}

	local function GetPartType(Number,NumberShape)
		local PartType = PartTypes[Number]
		if not PartType then
			warn("Unknown PartType: " .. tostring(Number))
			return "Normal"
		end

		local Shapes = {
			[0] = "Ball",
			[1] = "Normal",
			[2] = "Cylinder",
		}

		if PartType == "Normal" and NumberShape then
			return Shapes[NumberShape] or "Normal"
		else
			return PartType
		end
	end

	local function Slice(Table, Start, End)
		local Slice = {}
		for Index = Start, End do
			table.insert(Slice, Table[Index])
		end
		return Slice
	end

	for Index, ItemData in pairs(Items) do
		coroutine.wrap(function()
			local PartType = "Normal"
			if ItemData[33] then
				PartType = GetPartType(ItemData[1],ItemData[33])
			else
				PartType = GetPartType(ItemData[1])
			end

			if PartTypes[ItemData[1]] then --If it's a part?
				local PartSize = Vector3.new(unpack(Slice(ItemData, 4, 6)))
				local PartCFrame = CFrame.new(unpack(Slice(ItemData, 7, 18)))
				local PartColor = Color3.new(ItemData[19], ItemData[20], ItemData[21])
				local PartMaterial = ItemData[22]
				local IsAnchored = ItemData[23] == 1
				local PartCanCollide = ItemData[24] == 1
				local PartReflectance = ItemData[25]
				local PartTransparency = ItemData[26]
				local PartSurfaces = {
					["Top"] = ItemData[27],
					["Bottom"] = ItemData[28],
					["Front"] = ItemData[29],
					["Back"] = ItemData[30],
					["Left"] = ItemData[31],
					["Right"] = ItemData[32],
				}

				local CreatedPart = BtoolsModule.CreatePart(PartCFrame, game:GetService("Workspace"), PartType)
				BtoolsModule.Resize(CreatedPart, PartSize, PartCFrame)
				BtoolsModule.Color(CreatedPart, PartColor)
				BtoolsModule.SetMaterial(CreatedPart, PartMaterial)
				BtoolsModule.SetAnchor(CreatedPart, IsAnchored)
				BtoolsModule.SetCollision(CreatedPart, PartCanCollide)
				BtoolsModule.SetReflectance(CreatedPart, PartReflectance)
				BtoolsModule.SetTransparency(CreatedPart, PartTransparency)
				BtoolsModule.Surface(CreatedPart, PartSurfaces)
				table.insert(BtoolsModule,CreatedPart)
			end
		end)()
		task.wait(DelayPerPart)
	end

	return ConstructedObjects
end

return Module
