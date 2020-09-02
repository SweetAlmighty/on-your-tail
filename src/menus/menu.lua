--[[
Simple Menu Library
by nkorth

Requires: love2d
Recommended: hump.gamestate

Public Domain - feel free to hack and redistribute this as much as you want.
]]--

local menu = { }
local Menu = { }

function menu.new(title, align)
	local self = {
		width = 0,
		items = { },
		selected = 1,
		--animOffset = 0,
		alignment = align or "left",
	}
	setmetatable(self, { __index = Menu })
	return self
end

function Menu:update(dt) end

function Menu:selected() return self.selected end

function Menu:add_item(item)
	item.name = love.graphics.newText(menuFont, item.name)
	if self.width < item.name:getWidth() then self.width = item.name:getWidth() end
	table.insert(self.items, item)
end

function Menu:draw(x, y)
	local height = 20

	x = x == nil and (screenWidth - self.width)/2 or x
	y = y == nil and screenHeight/2 or y

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
		if self.selected > 1 then
			self.selected = self.selected - 1
			--animOffset = animOffset + 1
		else
			self.selected = #self.items
			--animOffset = animOffset - (#items-1)
		end
	elseif key == InputMap.down then
		if self.selected < #self.items then
			self.selected = self.selected + 1
			--animOffset = animOffset - 1
		else
			self.selected = 1
			--animOffset = animOffset + (#items-1)
		end
	elseif key == InputMap.a then
		if self.items[self.selected].action then
			self.items[self.selected]:action()
		end
	end
end

return menu

--Menu = {
--	new = function(title, align)
--		--animOffset = 0,
--		local width = 0
--		local items = { }
--		local selected = 1
--		local alignment = align or "left"
--		--local menuTitle = love.graphics.newText(titleFont, title)
--		return {
--			Selected = function() return selected end,
--			Update = function(dt) --[[animOffset = animOffset / (1 + dt*10)]] end,
--			AddItem = function(item)
--				item.name = love.graphics.newText(menuFont, item.name)
--				if width < item.name:getWidth() then width = item.name:getWidth() end
--				table.insert(items, item)
--			end,
--			Draw = function(x, y)
--				local height = 20
--
--				x = x == nil and (screenWidth - width)/2 or x
--				y = y == nil and screenHeight/2 or y
--
--				--love.graphics.setColor(1, 1, 1, 1)
--				--love.graphics.draw(menuTitle,
--				--	(screenWidth/2) - menuTitle:getWidth()/2,
--				--	(screenHeight/2) - ((menuTitle:getHeight()*2) - 10))
--
--				-- TODO: Implement custom draw function to show selection
--
--				for i, item in ipairs(items) do
--					love.graphics.setColor(1, 1, 1, selected == i and 1 or 0.5)
--					local _x = x + (width-item.name:getWidth()) / (alignment == "center" and 2 or 1)
--					love.graphics.draw(item.name, _x, y + height*(i-1) + 5)
--				end
--
--				-- Reset to avoid alpha values outside of menu
--				love.graphics.setColor(1, 1, 1)
--			end,
--			Input = function(key)
--				if key == InputMap.up then
--					if selected > 1 then
--						selected = selected - 1
--						--animOffset = animOffset + 1
--					else
--						selected = #items
--						--animOffset = animOffset - (#items-1)
--					end
--				elseif key == InputMap.down then
--					if selected < #items then
--						selected = selected + 1
--						--animOffset = animOffset - 1
--					else
--						selected = 1
--						--animOffset = animOffset + (#items-1)
--					end
--				elseif key == InputMap.a then
--					if items[selected].action then
--						items[selected]:action()
--					end
--				end
--			end
--		}
--	end
--}