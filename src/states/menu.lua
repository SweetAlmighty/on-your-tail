--[[
Simple Menu Library
by nkorth

Requires: love2d
Recommended: hump.gamestate

Public Domain - feel free to hack and redistribute this as much as you want.
]]--

Menu = {
	new = function(title, align)
		local width = 0
		local items = { }
		local selected = 1
		local alignment = align or 'left'
		local menuTitle = love.graphics.newText(titleFont, title)
		return {
			--animOffset = 0,
			AddItem = function(item)
				item.name = love.graphics.newText(menuFont, item.name)
				if width < item.name:getWidth() then width = item.name:getWidth() end
				table.insert(items, item)
			end,
			Update = function(dt)
				--animOffset = animOffset / (1 + dt*10)
			end,
			Draw = function(x, y)
				local height = 20

				love.graphics.setColor(1, 1, 1, 1)
				love.graphics.draw(menuTitle,
					(screenWidth/2) - menuTitle:getWidth()/2,
					(screenHeight/2) - ((menuTitle:getHeight()*2) - 10))

				-- TODO: Implement custom draw function to show selection

				for i, item in ipairs(items) do
					love.graphics.setColor(1, 1, 1, selected == i and 1 or 0.5)

					local _x = x + 5

					if alignment == 'right' then
						_x = _x + (width-item.name:getWidth())
					elseif alignment == 'center' then
						_x = _x + (width-item.name:getWidth())/2
					end

					love.graphics.draw(item.name, _x, y + height*(i-1) + 5)
				end

				-- Reset to avoid alpha values outside of menu
				love.graphics.setColor(1, 1, 1)
			end,
			Selected = function()
				return selected
			end,
			Input = function(key)
				if key == InputMap.up then
					if selected > 1 then
						selected = selected - 1
						--animOffset = animOffset + 1
					else
						selected = #items
						--animOffset = animOffset - (#items-1)
					end
				elseif key == InputMap.down then
					if selected < #items then
						selected = selected + 1
						--animOffset = animOffset - 1
					else
						selected = 1
						--animOffset = animOffset + (#items-1)
					end
				elseif key == InputMap.a then
					if items[selected].action then
						items[selected]:action()
					end
				end
			end
		}
	end
}