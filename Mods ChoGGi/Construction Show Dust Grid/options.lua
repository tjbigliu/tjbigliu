DefineClass("ModOptions_ChoGGi_ConstructionShowDustGrid", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = true,
			editor = "bool",
			id = "Option1",
			name = "Show Grids",
		},
		{
			default = true,
			editor = "bool",
			id = "ShowConSites",
			name = "Show Construction Site Grids",
		},
		{
			default = 30,
			max = 100,
			min = 0,
			editor = "number",
			id = "GridOpacity",
			name = "Grid Opacity",
		},
		{
			default = 25,
			max = 100,
			min = 0,
			editor = "number",
			id = "DistFromCursor",
			name = "Dist From Cursor",
		},
	},
})