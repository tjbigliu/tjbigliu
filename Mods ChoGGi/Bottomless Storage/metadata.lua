return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 7,
			"version_minor", 6,
		}),
	},
	"title", "Bottomless Storage",
	"version", 5,
	"version_major", 0,
	"version_minor", 5,
	"saved", 0,
	"image", "Preview.png",
	"id", "ChoGGi_BottomlessStorage",
	"author", "ChoGGi",
	"steam_id", "1411102605",
	"pops_any_uuid", "72c1a8e6-a886-4448-b726-f81f92e37faa",
	"code", {
		"Code/Script.lua",
	},
	"lua_revision", 249143,
	"description", [[Anything added to this storage depot will disappear (good for excess resources).

Be careful where you place it as drones will use it like a regular depot (defaults to no resources accepted).]],
})
