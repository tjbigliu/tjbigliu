return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 7,
			"version_minor", 6,
		}),
	},
	"title", "Construction Show Hex Buildable Grid",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"saved", 0,
	"image", "Preview.png",
	"id", "ChoGGi_ConstructionShowHexBuildableGrid",
	"steam_id", "1743031290",
	"pops_any_uuid", "79aaafdd-712c-40f8-873b-3a4d59273f1f",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[Show Hex Buildable Grid during construction (follows the mouse).
Passable (drones/rovers can drive here), Buildable (buildings can be placed here)

Green = pass/build
Yellow = no pass/build
Blue = pass/no build (shows blue for pipes, but you can build some stuff under them)
Red = no pass/no build
The colours use the centre of the hex, so they aren't exact.

[url=https://steamcommunity.com/sharedfiles/filedetails/?id=1479851929]Show Hex Grid[/url]


Toggle in-game with Mod Options.
You can also set the size/opacity.]],
})
