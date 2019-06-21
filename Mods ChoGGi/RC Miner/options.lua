DefineClass("ModOptions_ChoGGi_PortableMiner", {
	__parents = {
		"ModOptionsObject",
	},
	properties = {
		{
			default = true,
			editor = "bool",
			id = "visual_cues",
			name = T(302535920011196, "Paint ground around mine"),
			desc = "mspaint 4eva",
		},
		{
			default = true,
			editor = "bool",
			id = "ShowRocket",
			name = T(302535920011197, "Show Rocket"),
			desc = "up 'n down 'n up 'n down",
		},
		{
			default = 1,
			max = 500,
			min = 1,
			editor = "number",
			id = "mine_amount",
			name = T(302535920011198, "Amount per mine anim"),
			desc = "How much is mined each time.",
		},
		{
			default = 90,
			max = 1000,
			min = 1,
			editor = "number",
			id = "max_res_amount_man",
			name = T(302535920011199, "Amount stored in stockpile manual"),
			desc = "XXXXXXXXXXXXXX",
		},
		{
			default = 25,
			max = 1000,
			min = 1,
			editor = "number",
			id = "max_res_amount_auto",
			name = T(302535920011200, "Amount stored in stockpile auto"),
			desc = "XXXXXXXXXXXXXX",
		},
		{
			default = 1000,
			max = 100000,
			min = 1,
			editor = "number",
			id = "mine_time_animConcrete",
			name = T(302535920011201, "Time to mine concrete anim"),
			desc = "XXXXXXXXXXXXXX",
		},
		{
			default = 1500,
			max = 100000,
			min = 1,
			editor = "number",
			id = "mine_time_idleConcrete",
			name = T(302535920011202, "Time to mine concrete idle"),
			desc = "XXXXXXXXXXXXXX",
		},
		{
			default = 2000,
			max = 100000,
			min = 1,
			editor = "number",
			id = "mine_time_animMetals",
			name = T(302535920011203, "Time to mine metal anim"),
			desc = "XXXXXXXXXXXXXX",
		},
		{
			default = 3000,
			max = 100000,
			min = 1,
			editor = "number",
			id = "mine_time_idleMetals",
			name = T(302535920011204, "Time to mine metal idle"),
			desc = "XXXXXXXXXXXXXX",
		},
		{
			default = 10000,
			max = 100000,
			min = 1,
			editor = "number",
			id = "mine_time_animPreciousMetals",
			name = T(302535920011205, "Time to mine precious metal anim"),
			desc = "XXXXXXXXXXXXXX",
		},
		{
			default = 15000,
			max = 100000,
			min = 1,
			editor = "number",
			id = "mine_time_idlePreciousMetals",
			name = T(302535920011206, "Time to mine precious metal idle"),
			desc = "XXXXXXXXXXXXXX",
		},
	},
})