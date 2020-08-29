--[[
Simple Menu Library
by nkorth

Requires: love2d
Recommended: hump.gamestate

Public Domain - feel free to hack and redistribute this as much as you want.
]]--

Menu = {
	new = function(align)
		local menuFont = Resources.LoadFont('8bitOperatorPlusSC-Bold', 15)
		love.graphics.setFont(menuFont)

		return {
			width = 0,
			items = { },
			selected = 1,
			alignment = align or 'left',
			--animOffset = 0,
			AddItem = function(self, item)
				item.name = love.graphics.newText(menuFont, item.name)
				if self.width < item.name:getWidth() then self.width = item.name:getWidth() end
				table.insert(self.items, item)
			end,
			Update = function(self, dt)
				--self.animOffset = self.animOffset / (1 + dt*10)
			end,
			Draw = function(self, x, y)
				local height = 20

				-- TODO: Implement custom draw function to show selection

				for i, item in ipairs(self.items) do
					love.graphics.setColor(1, 1, 1, self.selected == i and 1 or 0.5)

					local _x = x + 5

					if align == 'right' then
						_x = _x + (self.width-item.name:getWidth())
					elseif align == 'center' then
						_x = _x + (self.width-item.name:getWidth())/2
					end

					love.graphics.draw(item.name, _x, y + height*(i-1) + 5)
				end

				-- Reset to avoid alpha values outside of menu
				love.graphics.setColor(1, 1, 1)
			end,
			Selected = function(self)
				return self.selected
			end,
			Input = function(self, key)
				if key == InputMap.up then
					if self.selected > 1 then
						self.selected = self.selected - 1
						--self.animOffset = self.animOffset + 1
					else
						self.selected = #self.items
						--self.animOffset = self.animOffset - (#self.items-1)
					end
				elseif key == InputMap.down then
					if self.selected < #self.items then
						self.selected = self.selected + 1
						--self.animOffset = self.animOffset - 1
					else
						self.selected = 1
						--self.animOffset = self.animOffset + (#self.items-1)
					end
				elseif key == InputMap.a then
					if self.items[self.selected].action then
						self.items[self.selected]:action()
					end
				end
			end
		}
	end
}