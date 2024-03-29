return PlaceObj("ModDef", {
	"title", "Fix Grid Not Working",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"saved", 0,
	"image", "Preview.png",
	"id", "ChoGGi_FixGridNotWorking",
	"steam_id", "1528605256",
	"pops_any_uuid", "037516df-9fcf-4176-945c-a75d3b362050",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"description", [[When you load a save this will go through the grids and check for objects that shouldn't be in there.

If your batteries haven't been charging since the Sagan update this will fix it.
This won't fix the seemingly random unpowered buildings bug (try salvaging and rebuilding cables running parallel under pipes).

You can remove afterwards.]],
})
