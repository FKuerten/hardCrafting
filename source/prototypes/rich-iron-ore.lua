-- Copy from prototypes.entity.demo-resources.lua
local function autoplace_settings(name, coverage)
  local ret = {
    control = name,
    sharpness = 1,
    richness_multiplier = 1500,
    richness_multiplier_distance_bonus = 20,
    richness_base = 500,
    coverage = coverage,
    starting_area_size = 600 * coverage,
    starting_area_amount = 1500,
    peaks = {
      {
        noise_layer = name,
        noise_octaves_difference = -1.5,
        -- somehow determines how much resource is spawned (0.3 = usual for vanilla
        -- the higher the value, the less resource is spawned
        noise_persistence = 0.35, 
      }
    }
  }
  return ret
end

function setNegativeInfluenceOnOtherResources(resource)
	for i, resource in ipairs({ "copper-ore", "iron-ore", "coal", "stone", "rich-copper-ore","rich-iron-ore" }) do
		table.insert(resource.autoplace.peaks,{
					influence = -0.99, -- Negative influence reduces value near other resource
					max_influence = 0, -- Max of 0 stops resource from generating on other resource
					noise_layer = resource, -- Noise layer determines what to avoid
					noise_octaves_difference = -2.3, -- Increased effect further from start to match irons own increase
					noise_persistence = 0.3,
				})
  end
end



data:extend({
	{
		type = "autoplace-control",
		name = "rich-iron-ore",
		richness = true,
		order = "b-a"
	},
	{
		type = "item",
		name = "rich-iron-ore",
		icon = "__hardCrafting__/graphics/icons/rich-iron-ore.png",
		flags = {"goes-to-main-inventory"},
		subgroup = "raw-resource",
		order = "f[iron-ore]2",
		stack_size = 50
	},
	{
		type = "noise-layer",
		name = "rich-iron-ore"
	},
	{
		type = "resource",
		name = "rich-iron-ore",
		icon = "__hardCrafting__/graphics/icons/rich-iron-ore.png",
		flags = {"placeable-neutral"},
		order="a-b-a",
		minable =
		{
			hardness = 0.7,
			mining_particle = "iron-ore-particle",
			mining_time = 1.5,
			results = {} -- see below
		},
		collision_box = {{ -0.1, -0.1}, {0.1, 0.1}},
		selection_box = {{ -0.5, -0.5}, {0.5, 0.5}},
		autoplace = autoplace_settings("rich-iron-ore", 0.015),
		stage_counts = {1000, 600, 400, 200, 100, 50, 20, 1},
		stages =
		{
			sheet =
			{
				filename = "__hardCrafting__/graphics/resources/rich-iron-ore.png",
				priority = "extra-high",
				width = 38,
				height = 38,
				frame_count = 4,
				variation_count = 8
			}
		},
		map_color = {r=0.47, g=0.52, b=0.7}
	},
})


data.raw["resource"]["rich-iron-ore"].minable.results = {
	ressourceItemMinMaxProb("rich-iron-ore", 	1, 2, 0.6),
	ressourceItemMinMaxProb("iron-slag",			1, 1, 0.1),
	ressourceItemMinMaxProb("iron-nugget",			1, 1, 0.2)
}