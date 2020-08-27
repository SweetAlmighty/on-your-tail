EntityTypes = {
    Player = 1,
    Cat    = 2,
    Kitten = 3,
    Enemy  = 4
}

EntityStates = {
    Idle   = 1,
    Moving = 2,
    Action = 3,
    Fail   = 4
}


--t = nil
--po = false

--local color = po and { 1, 0, 0 } or { 1, 1, 1 }
--love.graphics.setColor(color[1], color[2], color[3])
--love.graphics.polygon('line', t)
--love.graphics.setColor(1, 1, 1)

--t = { a.x, a.y, b.x, b.y, c.x, c.y }

local stateNames = {
    'idle',
    'move',
    'action',
    'fail'
}

local sheetNames = {
    'character',
    'cats',
    'kittens',
    'animalControl'
}

local createAnimations = function(type)
    local info = AnimationFactory.CreateAnimationSet(sheetNames[type])[1]
    if type == EntityTypes.Player then
        return { idle = info[1], move = info[2], action = info[3], fail = info[4] }
    elseif type == EntityTypes.Enemy then
        return { idle = info[1], move = info[2], action = info[3] }
    elseif type == EntityTypes.Cat then
        return { idle = info[3], move = info[2], action = info[3] }
    end
end

return {
    new = function(type)
        local x, y = 0, 0
        local direction = 1
        local collisions = { }
        local state = EntityStates.Idle
        local animations = createAnimations(type)
        local currentAnimation = animations.idle

        return {
            SetDirection = function(dir)
                if direction ~= dir then direction = math.min(1, math.max(-1, dir)) end
                return direction
            end,

            Collider = function()
                local col = currentAnimation.CurrentFrame().collider
                return { x = col.x + x, y = col.y + y, w = col.w, h = col.h }
            end,

            CollisionEnter = function(entity)
                local index = lume.find(collisions, entity)
                if index == nil then table.insert(collisions, entity) end
            end,

            CollisionExit = function(entity)
                local index = lume.find(collisions, entity)
                if index ~= nil then table.remove(collisions, index) end
                if #collisions == 0 then entity.EndInteraction() end
            end,

            SetState = function(s)
                local name = stateNames[s]
                print(s, name)
                if currentAnimation ~= animations[name] then
                    state = s
                    currentAnimation.Reset()
                    currentAnimation = animations[name]
                end
            end,

            State = function() return state end,
            Position = function() return x, y end,
            Update = function(dt) InternalUpdate(dt) end,
            Collisions = function() return collisions end,
            InternalUpdate = function(dt) currentAnimation.Update(dt) end,
            Draw = function() currentAnimation.Draw(x, y, direction == -1) end,
            DrawY = function() return y + currentAnimation.CurrentFrame().dimensions.h end,
            InternalMove = function(dx, dy) x, y = math.floor((x + dx) + 0.5), math.floor((y + dy) + 0.5) end,
        }
    end
}