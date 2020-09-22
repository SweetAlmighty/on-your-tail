require("src/entities/entity")
local Cat = require("src/entities/cat")
local Enemy = require("src/entities/enemy")
local Player = require("src/entities/player")

local entities = { }

-- Logic for the sort function for draw order sorting
local function sort_function(a, b)
    local a_pos = a.entity.position
    local b_pos = b.entity.position

    if a_pos.y == b_pos.y then
        if a.entity.type == EntityTypes.Player or b.entity.type == EntityTypes.Player then
            return a.entity.type == EntityTypes.Player
        else return a.index < b.index end
    else return a_pos.y < b_pos.y end
end

-- Sorts the entities by their Y to mock draw order
local function sort_draw_order()
    local new_table = { }
    for i=1, #entities, 1 do new_table[#new_table+1] = { index = i, entity = entities[i] } end
    table.sort(new_table, sort_function)
    entities = { }
    for i=1, #new_table, 1 do entities[#entities+1] = new_table[i].entity end
end

local function check_collision(one, two)
    local col_one = entities[one]:collider()
    local col_two = entities[two]:collider()
    return col_one.x < col_two.x + col_two.w and
           col_two.x < col_one.x + col_one.w and
           col_one.y < col_two.y + col_two.h and
           col_two.y < col_one.y + col_one.h
end

local function handle_collisions(entity, collisions)
    local entity_collisions = entity.collisions

    -- Process new collisions
    for i=1, #collisions, 1 do
        local index = find_index(entity_collisions, collisions[i])
        if index == nil then
            -- Enter
            collisions[i]:collision_enter(entity)
            entity:collision_enter(collisions[i])
        end
    end

    -- Find collisions to remove
    local remove = {}
    for i=1, #entity_collisions, 1 do
        local index = find_index(collisions, entity_collisions[i])
        if index == nil then
            remove[#remove+1] = entity_collisions[i]
        end
    end

    -- Process collisions that are no longer valid
    for i=1, #remove, 1 do
        -- Exit
        remove[i]:collision_exit(entity)
        entity:collision_exit(remove[i])
    end
end

local function check_collisions()
    for i=1, #entities, 1 do
        local collisions = { }
        for j=1, #entities, 1 do
            if i ~= j then
                if check_collision(i, j) then
                    collisions[#collisions+1] = entities[j]
                end
            end
        end
        handle_collisions(entities[i], collisions)
    end
end

EntityController = {
    Count = function() return #entities end,
    Clear = function() for _=1, #entities, 1 do entities[#entities] = nil end end,

    RemoveEntity = function(entity)
        local index = find_index(entities, entity)
        if index then table.remove(entities, index)end
    end,

    Draw = function()
        sort_draw_order()
        for i=1, #entities, 1 do
            entities[i]:draw()
            --draw_debug_info(entities[i])
        end
    end,

    Update = function(dt)
        check_collisions()
        for i=1, #entities, 1 do
            if entities[i]:is_out_of_bounds() then
                entities[i]:reset()
            end

            entities[i]:update(dt)
        end
    end,

    AddEntity = function(type)
        local entity = nil
        if type == EntityTypes.Enemy then
            entity = Enemy()
        elseif type == EntityTypes.Player then
            entity = Player()
            player = entity
        elseif type == EntityTypes.Cat or type == EntityTypes.Kitten then
            entity = Cat(type)
        end
        entities[#entities+1] = entity
    end,
}