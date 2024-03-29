return PlaceObj("ModDef", {
	"title", "Mark Deposit Ground",
	"version", 7,
	"version_major", 0,
	"version_minor", 7,
	"saved", 0,
	"image", "Preview.png",
	"id", "ChoGGi_MarkDepositGround",
	"steam_id", "1555446081",
--~ 	"pops_desktop_uuid", "8a57f30a-6bae-46c0-99b9-ca497bf74bd3",
	"pops_any_uuid", "3b37cc32-66d0-4233-8366-9038691ebe0e",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[Marks the ground around deposits so you can turn off the ugly signs and still see where they are.
Marks are sized depending on max amount.

Includes a Mod Option to always hide the signs (you can still select the invisible sign and see the amount).
An option to change all anomalies to the greenman model (suggestions for a different model?).
And one more to show signs during construction mode.]],
})
