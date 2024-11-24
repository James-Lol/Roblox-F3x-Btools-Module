F3x Module V1 Documentation

1. Module.SetCollision(Part, CanCollide)  Sets the collision property of a part to CanCollide.

2. Module.SetAnchor(Part, Anchored)  Sets the anchored property of a part to Anchored.

3. Module.CreatePart(CFrame, Parent, PartType)  Creates a new part at the specified CFrame and sets its parent to the specified Parent. [PartType not required]
This also monstly returnes the created Part but sometimes it dosen't!

All Part Types :
"Normal","Truss","Wedge","Corner","Cylinder","Ball","Seat","Vehicle Seat","Spawn"

4. Module.Parent(Part, Parent)  Sets the parent of a part to the specified Parent.

5. Module.Clone(Part, Parent)  Clones a part and sets its parent to the specified Parent.

6. Module.Destroy(Part)  Destroys a part.

7. Module.MovePart(Part, CFrame)  Moves a part to the specified CFrame.

8. Module.Resize(Part, Size, CFrame)  Resizes a part to the specified Size and sets its CFrame to the specified CFrame.

9. Module.Rotate(Part, Cframe_Angles)  Rotates a part to the specified Cframe_Angles.

10. Module.Color(Part, Color)  Sets the color of a part to the specified Color.

11. Module.Surface(Part, Surface)  Sets the surface property of a part to the specified Surface.

The Surface table should look like this :

{
	["Back"] = Enum.SurfaceType.Weld,
	["Bottom"] = Enum.SurfaceType.Weld,
	["Front"] = Enum.SurfaceType.Weld,
	["Left"] = Enum.SurfaceType.Weld,
	["Right"] = Enum.SurfaceType.Weld,
	["Top"] = Enum.SurfaceType.Weld
}

12. Module.AddMesh(Part)  Adds a mesh to a part.

13. Module.SetMesh(Part, MeshId, TextureId, Scale)  Sets the mesh and texture of a part to the specified MeshId, TextureId, and Scale. [Properties not required]

14. Module.CreateTexture(Part, TextureType, Face)  Creates a new texture on a part with the specified TextureType and Face.

15. Module.SetTexture(Part, TextureId, TextureType, Face)  Sets the texture of a part to the specified TextureId, TextureType, and Face.

16. Module.SetName(Part, Name)  Sets the name of a part to the specified Name.

17. Module.Weld(Part1, Part2)  Welds two parts together.

18. Module.RemoveWelds(Welds)  Removes welds from a part.

19. Module.SetLocked(Part, Locked)  Sets the locked property of a part to Locked.

20. Module.SetMaterial(Part, Material)  Sets the material property of a part to the specified Material.

21. Module.SetTransparency(Part, Transparency)  Sets the transparency property of a part to the specified Transparency.

22. Module.SetReflectance(Part, Reflectance)  Sets the reflectance property of a part to the specified Reflectance.

23. Module.CreateEffect(Part, EffectType)  Creates a new effect on a part with the specified EffectType. [Properties not required]

24. Module.ChangeEffect(Effect, Properties)  Changes the properties of an effect. [Properties not required]

25. Module.Group(Type, Parent, Parts)  Groups parts together into a model or folder.

26. Module.UnGroup(Groups)  Ungroups a model or folder into individual parts.
