return PlaceObj("ModDef", {
	"title", "Map Overview Show Surface Resources",
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
	"saved", 0,
	"image", "Preview.png",
	"id", "ChoGGi_MapOverviewShowSurfaceResources",
	"steam_id", "1768449416",
	"pops_any_uuid", "77783c38-6f89-4371-9628-a6fdb2fec8bb",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagInterface", true,
	"description", [[Adds count of surface resources (metal/polymer) to each sector in the map overview.

Mod Options:
Show Metals/Show Polymers: What you'd expect.
Text Opacity: 0-255 (0 == completely visible).
Text Background: Add black background around info.
Text Style: I default to a larger one since I use a small UI scale.


Requested by: Nobody... Though you can thank Skye Storme, since I noticed how often he had to mouse over sectors looking for them.]],
})
