local PlayersService = game:GetService("Players")
local LocalPlayer = PlayersService.LocalPlayer
local Change = {}

local function GetServerEndpoint()
	local BToolsKeywords = { "F3X", "BTools", "Building", "Building Tools" }
	local EndpointKeywords = { "serverend", "endpoint", "ServerEndPoint\226\128\140","\226\128\140" }
	local SyncAPIKeywords = { "sync", "api", "syncapi" }

	local function MatchesKeywords(ToolName, Keywords)
		local LowercaseName = ToolName:lower()
		for _, Keyword in ipairs(Keywords) do
			if LowercaseName:find(Keyword:lower()) then
				return true
			end
		end
		return false
	end

	local function FindSyncAPI(Parent)
		assert(Parent, "Error: Parent cannot be nil")

		for _, Child in ipairs(Parent:GetChildren()) do
			if Child:IsA("BindableFunction") and MatchesKeywords(Child.Name, SyncAPIKeywords) then
				return Child
			end
		end

		return nil
	end

	local function FindServerEndpoint(Parent)
		assert(Parent, "Error: Parent cannot be nil")

		for _, Child in ipairs(Parent:GetChildren()) do
			if Child:IsA("RemoteFunction") and MatchesKeywords(Child.Name, EndpointKeywords) then
				return Child
			end
		end

		return nil
	end

	for _, Tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
		if Tool:IsA("Tool") and MatchesKeywords(Tool.Name, BToolsKeywords) then
			local SyncAPI = FindSyncAPI(Tool)
			if SyncAPI then
				local ServerEndpoint = FindServerEndpoint(SyncAPI)
				if ServerEndpoint then
					return ServerEndpoint
				end
			end
		end
	end

	if LocalPlayer.Character then
		for _, Tool in ipairs(LocalPlayer.Character:GetChildren()) do
			if Tool:IsA("Tool") and MatchesKeywords(Tool.Name, BToolsKeywords) then
				local SyncAPI = FindSyncAPI(Tool)
				if SyncAPI then
					local ServerEndpoint = FindServerEndpoint(SyncAPI)
					if ServerEndpoint then
						return ServerEndpoint
					end
				end
			end
		end
	end

	return nil
end

local ServerEndpoint = GetServerEndpoint()

local function ExecuteArgs(Args)
	assert(Args ~= nil, "Error : ExecuteArgs Args cannot be nil")

	if not ServerEndpoint then
		ServerEndpoint = GetServerEndpoint()
	end

	if ServerEndpoint then
		ServerEndpoint:InvokeServer(unpack(Args))
	end
end

function Change.SetCollision(Parts, CanCollide)
	assert(Parts ~= nil and CanCollide ~= nil, "Arguments cannot be nil")
	assert(type(Parts) == "table", "Parts must be a table")

	local Args = {
		[1] = "SyncCollision",
		[2] = {}
	}

	for i, Part in ipairs(Parts) do
		assert(Part ~= nil, "Part cannot be nil")
		table.insert(Args[2], {
			["Part"] = Part,
			["CanCollide"] = CanCollide
		})
	end

	ExecuteArgs(Args)
end

function Change.SetAnchor(Parts, Anchored)
	assert(Anchored ~= nil and Parts ~= nil, "Arguments cannot be nil")
	assert(type(Parts) == "table", "Parts must be a table")

	local Args = {
		[1] = "SyncAnchor",
		[2] = {}
	}

	for i, Part in ipairs(Parts) do
		assert(Part ~= nil, "Part cannot be nil")
		table.insert(Args[2], {
			["Part"] = Part,
			["Anchored"] = Anchored
		})
	end

	ExecuteArgs(Args)
end

function Change.CreatePart(Cframe, Parent)
	assert(Cframe ~= nil and Parent ~= nil, "Argument cannot be nil")

	local Args = {
		[1] = "CreatePart",
		[2] = "Normal",
		[3] = Cframe,
		[4] = Parent
	}

	ExecuteArgs(Args)
end

function Change.Parent(Part, Parent)
	assert(Part ~= nil and Parent ~= nil, "Argument cannot be nil")

	local Args = {
		[1] = "SetParent",
		[2] = {
			["Part"] = Part,
		},
		[3] = Parent
	}

	ExecuteArgs(Args)
end

function Change.Clone(Part, Parent)
	assert(Part ~= nil and Parent ~= nil, "Argument cannot be nil")

	local Args = {
		[1] = "Clone",
		[2] = {
			["Part"] = Part,
		},
		[3] = Parent
	}

	ExecuteArgs(Args)
end

function Change.Destroy(Parts)
	assert(Parts ~= nil, "Argument cannot be nil")
	assert(type(Parts) == "table", "Parts must be a table")

	local Args = {
		[1] = "Remove",
		[2] = {}
	}

	for i, Part in ipairs(Parts) do
		assert(Part ~= nil, "Part cannot be nil")
		table.insert(Args[2], Part)
	end

	ExecuteArgs(Args)
end

function Change.MovePart(Parts, CFrame)
	assert(Parts ~= nil and CFrame ~= nil, "Arguments cannot be nil")
	assert(type(Parts) == "table", "Parts must be a table")

	local Args = {
		[1] = "SyncMove",
		[2] = {}
	}

	for i, Part in ipairs(Parts) do
		assert(Part ~= nil, "Part cannot be nil")
		table.insert(Args[2], {
			["Part"] = Part,
			["CFrame"] = CFrame
		})
	end

	ExecuteArgs(Args)
end

function Change.Resize(Parts, Size, CFrame)
	assert(Parts ~= nil and Size ~= nil and CFrame ~= nil, "Arguments cannot be nil")
	assert(type(Parts) == "table", "Parts must be a table")

	local Args = {
		[1] = "SyncResize",
		[2] = {}
	}

	for i, Part in ipairs(Parts) do
		assert(Part ~= nil, "Part cannot be nil")
		table.insert(Args[2], {
			["Part"] = Part,
			["CFrame"] = CFrame,
			["Size"] = Size
		})
	end

	ExecuteArgs(Args)
end

function Change.Rotate(Parts, CFrame_Angles)
	assert(Parts ~= nil and CFrame_Angles ~= nil, "Arguments cannot be nil")
	assert(type(Parts) == "table", "Parts must be a table")

	local Args = {
		[1] = "SyncRotate",
		[2] = {}
	}

	for i, Part in ipairs(Parts) do
		assert(Part ~= nil, "Part cannot be nil")
		local CFrame = Part.CFrame * CFrame_Angles
		table.insert(Args[2], {
			["Part"] = Part,
			["CFrame"] = CFrame
		})
	end

	ExecuteArgs(Args)
end


function Change.Color(Parts, Color)
	assert(Parts ~= nil and Color ~= nil, "Arguments cannot be nil")
	assert(type(Parts) == "table", "Parts must be a table")

	local Args = {
		[1] = "SyncColor",
		[2] = {}
	}

	for i, Part in ipairs(Parts) do
		assert(Part ~= nil, "Part cannot be nil")
		table.insert(Args[2], {
			["Color"] = Color,
			["UnionColoring"] = true,
			["Part"] = Part
		})
	end

	ExecuteArgs(Args)
end

--[[
Surface should look like this : 

					{
					["Back"] = Enum.SurfaceType.Weld,
					["Bottom"] = Enum.SurfaceType.Weld,
					["Front"] = Enum.SurfaceType.Weld,
					["Left"] = Enum.SurfaceType.Weld,
					["Right"] = Enum.SurfaceType.Weld,
					["Top"] = Enum.SurfaceType.Weld
					}
--]]

function Change.Surface(Parts, Surface)
	assert(Parts ~= nil and Surface ~= nil, "Arguments cannot be nil")
	assert(type(Parts) == "table", "Parts must be a table")
	assert(type(Surface) == "table", "Surface must be a table")

	local Args = {
		[1] = "SyncSurface",
		[2] = {}
	}

	for i, Part in ipairs(Parts) do
		assert(Part ~= nil, "Part cannot be nil")
		table.insert(Args[2], {
			["Part"] = Part,
			["Surfaces"] = Surface
		})
	end

	ExecuteArgs(Args)
end

function Change.AddMesh(Parts)
	assert(Parts ~= nil, "Argument cannot be nil")
	assert(type(Parts) == "table", "Parts must be a table")

	local Args = {
		[1] = "CreateMeshes",
		[2] = {}
	}

	for i, Part in ipairs(Parts) do
		assert(Part ~= nil, "Part cannot be nil")
		table.insert(Args[2], {
			["Part"] = Part
		})
	end

	ExecuteArgs(Args)
end

function Change.SetMesh(Parts, MeshId, TextureId, Scale) -- The MeshId, TextureId and Scale are optional
	assert(Parts ~= nil, "Argument cannot be nil")
	assert(type(Parts) == "table", "Parts must be a table")

	local Properties = {}

	if MeshId then
		Properties["MeshId"] = "rbxassetid://" .. MeshId
	end

	if TextureId then
		Properties["TextureId"] = "rbxassetid://" .. TextureId
	end

	if Scale then
		Properties["Scale"] = Scale
	end

	local Args = {
		[1] = "SyncMesh",
		[2] = {}
	}

	for i, Part in ipairs(Parts) do
		assert(Part ~= nil, "Part cannot be nil")
		local MeshProperties = { ["Part"] = Part }
		for key, value in pairs(Properties) do
			MeshProperties[key] = value
		end
		table.insert(Args[2], MeshProperties)
	end

	ExecuteArgs(Args)
end

function Change.CreateTexture(Parts, TextureType, Face)
	assert(Parts ~= nil and TextureType ~= nil and Face ~= nil, "Arguments cannot be nil")
	assert(type(Parts) == "table", "Parts must be a table")

	local ValidTextureTypes = {"Decal", "Texture"}
	local Valid = false

	for _, Type in pairs(ValidTextureTypes) do
		if Type == TextureType then
			Valid = true
			break
		end
	end

	if not Valid then
		error("Invalid TextureType provided")
		return
	end

	local Args = {
		[1] = "CreateTextures",
		[2] = {}
	}

	for i, Part in ipairs(Parts) do
		assert(Part ~= nil, "Part cannot be nil")
		table.insert(Args[2], {
			["Part"] = Part,
			["Face"] = Face,
			["TextureType"] = TextureType
		})
	end

	ExecuteArgs(Args)
end

function Change.SetTexture(Parts, TextureId, TextureType, Face, StudsPerTileU, StudsPerTileV) -- The TextureId, StudsPerTileU and StudsPerTileV are optional
	assert(Parts ~= nil and TextureType ~= nil and Face ~= nil, "Arguments cannot be nil")
	assert(type(Parts) == "table", "Parts must be a table")

	local ValidTextureTypes = {"Decal", "Texture"}
	local Valid = false

	for _, Type in pairs(ValidTextureTypes) do
		if Type == TextureType then
			Valid = true
			break
		end
	end

	if not Valid then
		error("Invalid TextureType provided")
		return
	end

	local Args = {
		[1] = "SyncTexture",
		[2] = {}
	}

	for i, Part in ipairs(Parts) do
		assert(Part ~= nil, "Part cannot be nil")

		local TextureProperties = {
			["Part"] = Part,
			["Face"] = Face,
			["TextureType"] = TextureType
		}

		if TextureId then
			TextureProperties["Texture"] = "rbxassetid://" .. TextureId
		end

		if StudsPerTileU then
			TextureProperties["StudsPerTileU"] = StudsPerTileU
		end

		if StudsPerTileV then
			TextureProperties["StudsPerTileV"] = StudsPerTileV
		end

		table.insert(Args[2], TextureProperties)
	end

	ExecuteArgs(Args)
end

function Change.SetName(Parts, Name)
	assert(Parts ~= nil and Name ~= nil, "Arguments cannot be nil")
	assert(type(Parts) == "table", "Parts must be a table")

	local Args = {
		[1] = "SetName",
		[2] = {}
	}

	for i, Part in ipairs(Parts) do
		assert(Part ~= nil, "Part cannot be nil")
		table.insert(Args[2], Part)
	end

	Args[3] = Name

	ExecuteArgs(Args)
end


function Change.Weld(Part1, Part2)
	assert(Part1 ~= nil and Part2 ~= nil, "Argument cannot be nil")

	local Args = {
		[1] = "CreateWelds",
		[2] = {
			[1] = Part1
		},
		[3] = Part2
	}

	ExecuteArgs(Args)
end

function Change.RemoveWelds(Welds)
	assert(Welds ~= nil, "Argument cannot be nil")

	local Args = {
		[1] = "RemoveWelds",
		[2] = Welds
	}

	ExecuteArgs(Args)
end

function Change.SetLocked(Parts, Locked)
	assert(Parts ~= nil and Locked ~= nil, "Arguments cannot be nil")
	assert(type(Parts) == "table", "Parts must be a table")

	local Args = {
		[1] = "SetLocked",
		[2] = {}
	}

	for i, Part in ipairs(Parts) do
		assert(Part ~= nil, "Part cannot be nil")
		table.insert(Args[2], Part)
	end

	Args[3] = Locked

	ExecuteArgs(Args)
end

function Change.SetMaterial(Parts, Material)
	assert(Parts ~= nil and Material ~= nil, "Arguments cannot be nil")
	assert(type(Parts) == "table", "Parts must be a table")

	local Args = {
		[1] = "SyncMaterial",
		[2] = {}
	}

	for i, Part in ipairs(Parts) do
		assert(Part ~= nil, "Part cannot be nil")
		table.insert(Args[2], {
			["Part"] = Part,
			["Material"] = Material
		})
	end

	ExecuteArgs(Args)
end

function Change.SetTransparency(Parts, Transparency)
	assert(Parts ~= nil and Transparency ~= nil, "Arguments cannot be nil")
	assert(type(Parts) == "table", "Parts must be a table")

	local Args = {
		[1] = "SyncMaterial",
		[2] = {}
	}

	for i, Part in ipairs(Parts) do
		assert(Part ~= nil, "Part cannot be nil")
		table.insert(Args[2], {
			["Part"] = Part,
			["Transparency"] = Transparency
		})
	end

	ExecuteArgs(Args)
end

function Change.SetReflectance(Parts, Reflectance)
	assert(Parts ~= nil and Reflectance ~= nil, "Arguments cannot be nil")
	assert(type(Parts) == "table", "Parts must be a table")

	local Args = {
		[1] = "SyncMaterial",
		[2] = {}
	}

	for i, Part in ipairs(Parts) do
		assert(Part ~= nil, "Part cannot be nil")
		table.insert(Args[2], {
			["Part"] = Part,
			["Reflectance"] = Reflectance
		})
	end

	ExecuteArgs(Args)
end

function Change.CreateEffect(Parts, EffectType)
	assert(Parts ~= nil and EffectType ~= nil, "Arguments cannot be nil")
	assert(type(Parts) == "table", "Parts must be a table")

	local ValidEffects = {"Smoke", "Fire", "Sparkles", "PointLight", "SurfaceLight", "SpotLight"}
	local LightEffects = {"PointLight", "SurfaceLight", "SpotLight"}

	local IsEffect = false
	for _, Effect in pairs(ValidEffects) do
		if Effect == EffectType then
			IsEffect = true
			break
		end
	end

	if not IsEffect then
		return
	end

	local IsLightEffect = false
	for _, Effect in pairs(LightEffects) do
		if Effect == EffectType then
			IsLightEffect = true
			break
		end
	end

	local Args = {
		[1] = IsLightEffect and "CreateLights" or "CreateDecorations",
		[2] = {}
	}

	for _, Part in ipairs(Parts) do
		assert(Part ~= nil, "Part cannot be nil")
		local EffectArgs = {["Part"] = Part, [IsLightEffect and "LightType" or "DecorationType"] = EffectType}
		table.insert(Args[2], EffectArgs)
	end

	ExecuteArgs(Args)
end


function Change.ChangeEffect(Effect, Properties)
	assert(Effect ~= nil and Properties ~= nil, "Argument cannot be nil")

	local VaildEffects = {"Smoke", "Fire", "Sparkles", "PointLight", "SurfaceLight", "SpotLight"}
	local LightEffects = {"PointLight", "SurfaceLight", "SpotLight"}
	local EffectType = Effect.ClassName
	local IsVaildEffect = false
	local IsLightEffect = false

	for _, ValidEffect in pairs(VaildEffects) do
		if EffectType == ValidEffect then
			IsVaildEffect = true
			if table.find(LightEffects, EffectType) then
				IsLightEffect = true
			end
			break
		end
	end

	if not IsVaildEffect then
		return
	end

	local Args = {}
	if IsLightEffect then
		Args = {
			[1] = "SyncLighting",
			[2] = {
				[1] = {
					["Part"] = Effect.Parent,
					["LightType"] = EffectType,
				}
			}
		}
	else
		Args = {
			[1] = "SyncDecorate",
			[2] = {
				[1] = {
					["Part"] = Effect.Parent,
					["DecorationType"] = EffectType,
				}
			}
		}
	end

	for key, value in pairs(Properties) do
		Args[2][1][key] = value
	end

	ExecuteArgs(Args)
end

function Change.Group(Type, Parent, Parts)
	assert(Type ~= nil and Parent ~= nil and Parts ~= nil, "Argument cannot be nil")

	local ValidGroupTypes = {
		"Model",
		"Folder"
	}

	if not table.find(ValidGroupTypes,Type) then
		return
	end

	local Args = {
		[1] = "CreateGroup",
		[2] = Type,
		[3] = Parent,
		[4] = Parts,
	}

	ExecuteArgs(Args)
end

function Change.UnGroup(Groups)
	assert(Groups ~= nil, "Argument cannot be nil")

	if typeof(Groups) ~= "table" then
		warn("ERROR : Invalid groups must be a table of the group/groups")
	end

	local Args = {
		[1] = "Ungroup",
		[2] = Groups,
	}

	ExecuteArgs(Args)
end

return Change
