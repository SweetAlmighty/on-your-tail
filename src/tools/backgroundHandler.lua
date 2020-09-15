local props = { }
local light_pos = 2
local prop_count = 9
local total_props = 9
local prop_tiles = { }
local building_count = 4
local current_props = { }
local building_props = { }
local building_tiles = { }
local total_buildings = 10
local light_offset = false
local building_frames = { }
local current_buildings = { }

local function get_next_position(index)
    local prev = index - 1 < 1 and building_count or index - 1
    return current_buildings[prev].pos + (current_buildings[prev].width + love.math.random(-20, 150))
end

local function get_prop_position_on_building(building, prop)
    local prop_width = prop.dimensions.w
    local prop_areas = building.properties

    for i=1, #prop_areas, 1 do
        local area = prop_areas[i].Value
        if area.w > prop_width then
            return love.math.random(area.x, (area.x + area.w) - prop_width)
        end
    end

    return nil
end

local function initialize_buildings()
    building_tiles = AnimationFactory.CreateTileSet("buildings")

    building_props = { }
    building_frames = { }
    current_buildings = { }

    for i=1, total_buildings, 1 do
        building_frames[#building_frames+1] = building_tiles.GetFrame(i)
        if i <= building_count then
            building_props[#building_props+1] = { }
            current_buildings[#current_buildings+1] = { }
        end
    end
end

local function initialize_props()
    prop_tiles = AnimationFactory.CreateTileSet("props")

    current_props = { }

    for i=1, total_props, 1 do
        props[#props+1] = prop_tiles.GetFrame(i)
        if i <= prop_count then current_props[#current_props+1] = { } end
    end
end

local function update_buildings()
    for i=1, #current_buildings, 1 do
        local new_x = current_buildings[i].pos - 2
        local threshold = (current_buildings[i].width + 1)
        local offscreen = new_x < -threshold

        if offscreen then
            -- Change Building
            local index = love.math.random(1, total_buildings)
            local building = building_frames[index]
            current_buildings[i] = {
                pos = get_next_position(i),
                type = index,
                width = building.dimensions.w
            }

            -- Change Building Prop
            index = love.math.random(2, 8)
            local prop = props[index]
            local prop_pos = get_prop_position_on_building(building, prop)
            if prop_pos then
                building_props[i] = {
                    type = index,
                    width = prop.dimensions.w,
                    pos = current_buildings[i].pos + get_prop_position_on_building(building, prop)
               }
            else
                building_props[i] = nil
            end
        else
            current_buildings[i].pos = new_x

            if building_props[i] then
                building_props[i].pos = building_props[i].pos - 2
            end
        end
    end
end

local function update_hydrant()
    if current_props[9].pos == nil then
        current_props[9].pos = current_buildings[2].pos
    end

    current_props[9].pos = current_buildings[1].pos
end

local function update_lamp_post()
    if current_props[1].pos == nil then
        current_props[1].pos = current_buildings[2].pos
    end

    if current_props[1].pos < -(current_props[1].width + 1) then
        light_offset = not light_offset
        light_pos = light_offset and 4 or 2
    end

    current_props[1].pos = current_buildings[light_pos].pos
end

local function update_props()
    update_hydrant()
    update_lamp_post()
end

local function reset_props()
    for i=1, prop_count, 1 do
        local index = i
        local prop = props[index]
        current_props[i] = {
            pos = nil,
            type = index,
            width = prop.dimensions.w
        }
    end

    update_props()
end

local function reset_buildings()
    for i=1, building_count, 1 do
        local index = love.math.random(1, total_buildings)
        local building = building_frames[index]
        current_buildings[i] = {
            type = index,
            width = building.dimensions.w,
            pos = i == 1 and 0 or get_next_position(i)
        }

        -- Change Building Prop
        index = love.math.random(2, 8)
        local prop = props[index]
        local prop_pos = get_prop_position_on_building(building, prop)
        if prop_pos then
            building_props[i] = {
                type = index,
                width = prop.dimensions.w,
                pos = current_buildings[i].pos + get_prop_position_on_building(building, prop)
           }
        else
            building_props[i] = nil
        end
    end
end

local function draw()
    for i=1, #current_buildings, 1 do
        building_tiles.Draw(current_buildings[i].type, current_buildings[i].pos, 0)
    end

    for i=1, #building_props, 1 do
        if building_props[i] then
            prop_tiles.Draw(building_props[i].type, building_props[i].pos, 85)
        end
    end

    prop_tiles.Draw(current_props[1].type, current_props[1].pos, 12)
    prop_tiles.Draw(current_props[9].type, current_props[9].pos, 115)
end

local function reset()
    reset_buildings()
    reset_props()
end

local function update()
    update_buildings()
    update_props()
end

local function initialize()
    initialize_props()
    initialize_buildings()
    reset()
end

BackgroundHandler = {
    Draw = draw,
    Reset = reset,
    Update = update,
    Initialize = initialize
}