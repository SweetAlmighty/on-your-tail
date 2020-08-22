require 'src/tools/animation'
require 'src/tools/spritesheet'

AnimationFactory = {
    CreateAnimationSet = function(filename)
        local file = Resources.LoadAnim(filename)
        if file ~= nil then
            local types = { }
            local image = Resources.LoadImage(filename)

            for i = 1, #file.Types do
                local animats = { }

                for j = 1, #file.Types[i].Animations do
                    local anim = Animation.new(image)
                    for k = 1, #file.Types[i].Animations[j].Frames do
                        anim.AddFrameWithData(file.Types[i].Animations[j].Frames[k])
                    end
                    animats[#animats + 1] = anim
                end

                types[#types + 1] = animats
            end

            return types
        end

        return nil
    end,

    CreateTileSet = function(filename)
        local file = Resources.LoadSheet(filename)
        if file ~= nil then
            local image = Resources.LoadImage(filename)
            local sheet = SpriteSheet.new(image)

            for i = 1, #file.Frames do sheet.AddFrame(file.Frames[i]) end

            return sheet
        end

        return nil
    end
}