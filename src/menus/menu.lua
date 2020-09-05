local menu = { }
local Menu = { }

MenuAlignments = {
	Left = 1, Center = 2, Right = 2
}

MenuQuadrants = {
	TopLeft    = 1, TopMiddle    = 2, TopRight    = 3,
	MiddleLeft = 4, MiddleMiddle = 5, MiddleRight = 6,
	BottomLeft = 7, BottomMiddle = 8, BottomRight = 9
}

local align = 2
local quad_width = 320/3
local quad_height = 240/3
local start = { x = 0, y = 0 }
local background = { x = 0, y = 0, w = 0, h = 0 }

function menu.new()
	local self = {
		width = 0,
		height = 0,
		items = { },
		selected = 1,
		--animOffset = 0,
		offset = { x = 0, y = 0 },
		move_sfx = Resources.LoadSFX("move"),
		accept_sfx = Resources.LoadSFX("accept"),
		decline_sfx = Resources.LoadSFX("decline")
	}
	setmetatable(self, { __index = Menu })
	return self
end

function Menu:update(dt) end

function Menu:selected()
	return self.selected
end

function Menu:set_offset(x, y)
	self.offset = { x = x, y = y }
end

function Menu:set_alignment(alignment)
    if     alignment == MenuAlignments.Left   then align = 0
    elseif alignment == MenuAlignments.Center then align = 2
    elseif alignment == MenuAlignments.Right  then align = 1
    end
end

function Menu:set_start(alignment)
    if     alignment == MenuQuadrants.TopLeft      then start = { x = 0,              y = 0 }
    elseif alignment == MenuQuadrants.TopMiddle    then start = { x = quad_width,     y = 0 }
    elseif alignment == MenuQuadrants.TopRight     then start = { x = quad_width * 2, y = 0 }
    elseif alignment == MenuQuadrants.MiddleLeft   then start = { x = 0,              y = quad_height }
    elseif alignment == MenuQuadrants.MiddleMiddle then start = { x = quad_width    , y = quad_height }
    elseif alignment == MenuQuadrants.MiddleRight  then start = { x = quad_width * 2, y = quad_height }
    elseif alignment == MenuQuadrants.BottomLeft   then start = { x = 0,              y = quad_height * 2 }
    elseif alignment == MenuQuadrants.BottomMiddle then start = { x = quad_width    , y = quad_height * 2 }
    elseif alignment == MenuQuadrants.BottomRight  then start = { x = quad_width * 2, y = quad_height * 2 }
    end
end

function Menu:set_background(x, y, w, h)
    background = { x = x, y = y, w = w, h = h }
end

function Menu:add_item(item)
	item.name = love.graphics.newText(menuFont, item.name)

	if self.width < item.name:getWidth() then
		self.width = item.name:getWidth()
	end

	self.height = self.height + item.name:getHeight()

	self.width_offset = quad_width - self.width
	self.height_offset = quad_height - self.height

	table.insert(self.items, item)
end

function Menu:draw(x, y)
	-- TODO: Implement custom draw function to show selection

	-- Background
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("line", background.x, background.y, background.w, background.h)

	love.graphics.setColor(0, 0, 0, 0.75)
	love.graphics.rectangle("fill", background.x, background.y, background.w, background.h)

	for i, item in ipairs(self.items) do
		love.graphics.setColor(1, 1, 1, self.selected == i and 1 or 0.5)

		local _x = start.x + (self.width_offset/ 2)
		local _y = start.y + item.name:getHeight() * (i - 1)

		if align ~= 0 then _x = _x + (self.width - item.name:getWidth()) / align end

		love.graphics.draw(item.name, _x + self.offset.x, _y + self.offset.y)
	end

	-- Reset to avoid alpha values outside of menu
	love.graphics.setColor(1, 1, 1)
end

function Menu:input(key)
	if key == InputMap.up then
		self.move_sfx:play()
		if self.selected > 1 then
			self.selected = self.selected - 1
			--animOffset = animOffset + 1
		else
			self.selected = #self.items
			--animOffset = animOffset - (#items-1)
		end
	elseif key == InputMap.down then
		self.move_sfx:play()
		if self.selected < #self.items then
			self.selected = self.selected + 1
			--animOffset = animOffset - 1
		else
			self.selected = 1
			--animOffset = animOffset + (#items-1)
		end
	elseif key == InputMap.a then
		if self.items[self.selected].action then
			if self.selected == #self.items then
				self.decline_sfx:play()
			else
				self.accept_sfx:play()
			end
			self.items[self.selected]:action()
		end
	end
end

return menu