local PlayersService = game:GetService("Players")
local LocalPlayer = PlayersService.LocalPlayer
local Change = {}

local function GetServerEndpoint()
	local BToolsKeywords = { "F3X", "BTools", "Building", "Building Tools" }
	local EndpointKeywords = { "serverend", "endpoint" }
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

function Change.SetCollision(Part, CanCollide)
	assert(Part ~= nil and CanCollide ~= nil, "Argument cannot be nil")

	local Args = {
		[1] = "SyncCollision",
		[2] = {
			[1] = {
				["Part"] = Part,
				["CanCollide"] = CanCollide
			}
		}
	}

	ExecuteArgs(Args)
end

function Change.SetAnchor(Part, Anchored)
	assert(Anchored ~= nil and Part ~= nil, "Argument cannot be nil")

	local Args = {
		[1] = "SyncAnchor",
		[2] = {
			[1] = {
				["Part"] = Part,
				["Anchored"] = Anchored
			}
		}
	}

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

function Change.Destory(Part)
	assert(Part ~= nil, "Argument cannot be nil")

	local Args = {
		[1] = "Remove",
		[2] = {
			[1] = Part
		}
	}

	ExecuteArgs(Args)
end

function Change.MovePart(Part, Cframe)
	assert(Part ~= nil and Cframe ~= nil, "Argument cannot be nil")

	local Args = {
		[1] = "SyncMove",
		[2] = {
			[1] = {
				["Part"] = Part,
				["CFrame"] = Cframe
			}
		}
	}

	ExecuteArgs(Args)
end

function Change.Resize(Part, Size, Cframe)
	assert(Part ~= nil and Size ~= nil and Cframe ~= nil, "Argument cannot be nil")

	local Args = {
		[1] = "SyncResize",
		[2] = {
			[1] = {
				["Part"] = Part,
				["CFrame"] = Cframe,
				["Size"] = Size
			}
		}
	}

	ExecuteArgs(Args)
end

function Change.Rotate(Part, Cframe_Angles)
	assert(Part ~= nil and Cframe_Angles ~= nil, "Argument cannot be nil")

	local Cframe = Part.CFrame * Cframe_Angles

	local Args = {
		[1] = "SyncRotate",
		[2] = {
			[1] = {
				["Part"] = Part,
				["CFrame"] = Cframe
			}
		}
	}

	ExecuteArgs(Args)
end

function Change.Color(Part, Color)
	assert(Part ~= nil and Color ~= nil, "Argument cannot be nil")

	local Args = {
		[1] = "SyncColor",
		[2] = {
			[1] = {
				["Color"] = Color,
				["UnionColoring"] = true,
				["Part"] = Part,
			}
		}
	}

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

function Change.Surface(Part, Surface)
	assert(Part ~= nil and Surface ~= nil, "Argument cannot be nil")

	local Args = {
		[1] = "SyncSurface",
		[2] = {
			[1] = {
				["Part"] = Part,
				["Surfaces"] = Surface
			}
		}
	}

	ExecuteArgs(Args)
end

function Change.AddMesh(Part)
	assert(Part ~= nil, "Argument cannot be nil")

	local Args = {
		[1] = "CreateMeshes",
		[2] = {
			[1] = {
				["Part"] = Part
			}
		}
	}

	ExecuteArgs(Args)
end

function Change.SetMesh(Part, MeshId, TextureId, Scale) --These are Optional
	assert(Part ~= nil, "Argument cannot be nil")

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
		[2] = {
			[1] = {
				["Part"] = Part,
			}
		}
	}

	for key, value in pairs(Properties) do
		Args[2][1][key] = value
	end

	ExecuteArgs(Args)
end

function Change.CreateTexture(Part, TextureType, Face)
	assert(Part ~= nil and TextureType ~= nil and Face ~= nil, "Argument cannot be nil")

	local ValidTextureTypes = {"Decal", "Texture"}

	local Valid = false
	for _, Type in pairs(ValidTextureTypes) do
		if Type == TextureType then
			Valid = true
		end
	end

	if not Valid then
		return
	end

	local Args = {
		[1] = "CreateTextures",
		[2] = {
			[1] = {
				["Part"] = Part,
				["Face"] = Face,
				["TextureType"] = TextureType
			}
		}
	}

	ExecuteArgs(Args)
end

function Change.SetTexture(Part, TextureId, TextureType, Face)
	assert(Part ~= nil and TextureId ~= nil and TextureType ~= nil and Face ~= nil, "Argument cannot be nil")

	local ValidTextureTypes = {"Decal", "Texture"}

	local Valid = false
	for _, Type in pairs(ValidTextureTypes) do
		if Type == TextureType then
			Valid = true
		end
	end

	if not Valid then
		return
	end

	local Args = {
		[1] = "SyncTexture",
		[2] = {
			[1] = {
				["Face"] = Face,
				["Part"] = Part,
				["Texture"] = "rbxassetid://" .. TextureId,
				["TextureType"] = TextureType
			}
		}
	}

	ExecuteArgs(Args)
end

function Change.SetName(Part, Name)
	assert(Part ~= nil and Name ~= nil, "Argument cannot be nil")

	local Args = {
		[1] = "SetName",
		[2] = {
			[1] = Part
		},
		[3] = Name
	}

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

function Change.SetLocked(Part, Locked)
	assert(Part ~= nil and Locked ~= nil, "Argument cannot be nil")

	local Args = {
		[1] = "SetLocked",
		[2] = {
			[1] = Part
		},
		[3] = Locked
	}

	ExecuteArgs(Args)
end

function Change.SetMaterial(Part, Material)
	assert(Part ~= nil and Material ~= nil, "Argument cannot be nil")

	local Args = {
		[1] = "SyncMaterial",
		[2] = {
			[1] = {
				["Part"] = Part,
				["Material"] = Material
			}
		}
	}

	ExecuteArgs(Args)
end

function Change.SetTransparency(Part, Transparency)
	assert(Part ~= nil and Transparency ~= nil, "Argument cannot be nil")

	local Args = {
		[1] = "SyncMaterial",
		[2] = {
			[1] = {
				["Part"] = Part,
				["Transparency"] = Transparency
			}
		}
	}

	ExecuteArgs(Args)
end

function Change.SetReflectance(Part, Reflectance)
	assert(Part ~= nil and Reflectance ~= nil, "Argument cannot be nil")

	local Args = {
		[1] = "SyncMaterial",
		[2] = {
			[1] = {
				["Part"] = Part,
				["Reflectance"] = Reflectance
			}
		}
	}

	ExecuteArgs(Args)
end

function Change.CreateEffect(Part, EffectType)
	assert(Part ~= nil and EffectType ~= nil, "Argument cannot be nil")

	local VaildEffects = {"Smoke","Fire","Sparkles","PointLight","SurfaceLight","SpotLight"}
	local LightEffects = {"PointLight","SurfaceLight","SpotLight"}

	local IsEffect = false

	for _,Effect in pairs(VaildEffects) do
		if Effect == EffectType then
			IsEffect = true
		end
	end

	if IsEffect == false then
		return
	end

	local IsLightEffect = false

	for _,Effect in pairs(LightEffects) do
		if Effect == EffectType then
			IsLightEffect = true
		end
	end

	local Args = nil

	if IsLightEffect then
		Args = {
			[1] = "CreateLights",
			[2] = {
				[1] = {
					["Part"] = Part,
					["LightType"] = EffectType
				}
			}
		}
	else
		Args = {
			[1] = "CreateDecorations",
			[2] = {
				[1] = {
					["Part"] = Part,
					["DecorationType"] = EffectType
				}
			}
		}
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
