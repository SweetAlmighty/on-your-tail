local animat = {
  _VERSION      = 'animat v1.0',
  _URL          = 'https://github.com/darkfire613/animat',
  _DESCRIPTION  = 'A simple animation package for love2d',
  _LICENSE      = [[
  The MIT License (MIT)

  Copyright (c) 2016 Owen Monsma

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
  ]]
}
animat.__index = animat

-- animation mode
local LOOP = 1 BOUNCE = 2 ONCE = 3

function animat.newAnimat(fps)
  return setmetatable({
    fps           = fps or 30,
    frames        = 0,
    frameCount    = 0,
    frameTime     = 0,
    currentFrame  = nil,
    mode          = LOOP,
    rev           = false,
  }, animat)
end

function animat:loop()
  self.mode = LOOP
end

function animat:bounce()
  self.mode = BOUNCE
end

function animat:once()
  self.mode = ONCE
end

function animat:addFrame(x,y,w,h)
  if self.img ~= nil then
    self[self.frames] = love.graphics.newQuad(x,y,w,h,self.img:getDimensions())
    if self.frames == 0 then
      self.currentFrame = self[0]
    end
    self.frames = self.frames + 1
  end
end

function animat:addSheet(sheet)
  self.img = sheet
end

function animat:play(dt)
  -- loop mode
  if self.mode == LOOP then
    self:playLoop(dt)
  -- bounce mode
  elseif self.mode == BOUNCE then
    self:playBounce(dt)
  -- once mode
  elseif self.mode == ONCE then
    self:playOnce(dt)
  end
end

function animat:playLoop(dt)
  if self.frameTime > (1/self.fps) then
    --inc current frame, looping when reaches end
    self.frameCount = (((self.frameCount + 1) % self.frames))
    --reset frame time
    self.frameTime = self.frameTime - (1/self.fps)
    --update current frame
    self.currentFrame = self[self.frameCount]
  else
    --update frame time
    self.frameTime = self.frameTime + dt
  end
end

function animat:playBounce(dt)
  if self.frameTime > (1/self.fps) then
    --inc current frame, looping when reaches end
    if (not rev) then
      self.frameCount = (self.frameCount + 1)
      if self.frameCount == self.frames - 1 then rev = not rev end
    else
      self.frameCount = (self.frameCount - 1)
      if self.frameCount == 0 then rev = not rev end
    end
    --reset frame time
    self.frameTime = self.frameTime - (1/self.fps)
    --update current frame
    self.currentFrame = self[self.frameCount]
  else
    --update frame time
    self.frameTime = self.frameTime + dt
  end
end

function animat:playOnce(dt)
  if self.frameTime > (1/self.fps) then
    -- only increase frame if not on last frame
    if self.frameCount < self.frames - 1 then
      self.frameCount = (self.frameCount + 1)
      self.frameTime = self.frameTime - (1/self.fps)
      self.currentFrame = self[self.frameCount]
    end
  else
    --update frame time
    self.frameTime = self.frameTime + dt
  end
end

function animat:reset()
  self.currentFrame = self[0]
  self.frameCount = 0
end

return animat
