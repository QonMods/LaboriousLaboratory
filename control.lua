-- LaboriousLaboratory. Factorio mod: Get research progress without a lab by manually handcrafting your technological revolution!
-- Copyright (C) 2016  Qon

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>

local mod_name = 'LaboriousLaboratory'

local debugging = false
script.on_event(defines.events.on_player_crafted_item, function(event)
    if not event.item_stack.valid_for_read or event.item_stack.name ~= 'progress' then return nil end
    local p = game.players[event.player_index]
    if not p then return nil end
    -- p.print(1)
    local inv = p.get_main_inventory()
    if not inv then return nil end
    local f = p.force
    if not f then return nil end
    local cr = f.current_research
    if not cr then return nil end
    -- if cr.research_unit_count_formula then return nil end

    -- f.laboratory_speed_modifier (and f.laboratory_productivity_bonus) is always 0 regardless of lab speed research?!
    local time = settings.global['speed'].value -- * f.laboratory_speed_modifier
    local research_unit_energy_seconds = cr.research_unit_energy / 60
    -- printOrFly(p, 'energy: '..research_unit_energy_seconds ..'  count: '.. cr.research_unit_count
    --     -- ..'  labspeedmod: '.. f.laboratory_speed_modifier..'  labprodmod: '.. f.laboratory_productivity_bonus
    -- )
    local haveall = true
    local ingredientstacks = {}
    for _, ingredient in pairs(cr.research_unit_ingredients) do
        local stack = inv.find_item_stack(ingredient.name)
        if not stack then haveall = false
        else
            table.insert(ingredientstacks, {stack = stack, ingredient = ingredient})
        end
    end
    -- p.print('sadsadds')
    local units_done = time / research_unit_energy_seconds
    if haveall then
        -- p.print(units_done)
        -- p.print('time ' .. time)
        for _, ingredientstack in pairs(ingredientstacks) do
            ingredientstack.stack.drain_durability(ingredientstack.ingredient.amount * units_done)
        end
        f.research_progress = math.min(1, f.research_progress
            + units_done -- * f.laboratory_productivity_bonus
            * settings.global['productivity'].value
            / cr.research_unit_count
        )
    end
end)

script.on_event(defines.events.on_player_main_inventory_changed, function(event)
    local p = game.players[event.player_index]
    if not p or not p.character then return nil end
    local inv = p.get_main_inventory()
    if not inv then return nil end
    inv.remove{name = 'progress', count = 100000}
end)

function printOrFly(p, text)
    if p.character ~= nil then
        p.create_local_flying_text({
            ['text'] = text,
            ['position'] = p.character.position
        })
    else
        p.print(text)
    end
end