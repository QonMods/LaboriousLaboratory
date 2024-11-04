-- local progress = table.deepcopy(data.raw.item.lab)
-- progress.name = 'progress'
-- progress.stack_size = 1000
local progress_recipe = table.deepcopy(data.raw.recipe.lab)
progress_recipe.name = 'progress'
progress_recipe.result = 'progress'
-- progress_recipe.results = {{
--   name='progress',
--   amount_min=0.0,
--   amount_max=0.0,
--   probability=0.0,
-- }}
-- progress_recipe.place_result = nil
progress_recipe.order = 'g[progress]'
progress_recipe.energy_required = 1
progress_recipe.ingredients = {}


data:extend({
  -- progress,
  progress_recipe,
  {
    icon = "__base__/graphics/icons/lab.png",
    icon_size = 32,
    name = "progress",
    order = "g[progress]",
    stack_size = 3600,
    subgroup = "production-machine",
    type = "item"
  },
    -- {
  --   enabled = true,
  --   energy_required = 1,
  --   ingredients = {},
  --   name = "progress",
  --   result = "progress",
  --   result_count = 1,
  --   type = "recipe"
  -- }
})