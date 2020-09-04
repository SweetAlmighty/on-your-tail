local menu = { }
local Menu = { }

function menu.new(align)
	local self = {
		width = 0,
		items = { },
		selected = 1,
		--animOffset = 0,
		alignment = align or "left",
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

function Menu:add_item(item)
	item.name = love.graphics.newText(menuFont, item.name)
	if self.width < item.name:getWidth() then self.width = item.name:getWidth() end
	table.insert(self.items, item)
end

function Menu:draw(x, y)
	local height = 20

	x = x == nil and (screen_width - self.width)/2 or x
	y = y == nil and screen_height/2 or y

	-- TODO: Implement custom draw function to show selection

	for i, item in ipairs(self.items) do
		love.graphics.setColor(1, 1, 1, self.selected == i and 1 or 0.5)
		local _x = x + (self.width-item.name:getWidth()) / (self.alignment == "center" and 2 or 1)
		love.graphics.draw(item.name, _x, y + height*(i-1) + 5)
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