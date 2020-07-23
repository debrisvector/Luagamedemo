local animationList = class("animationList", function(numberofframes,animationname,animationtime,repeatbool)
end)

function animationList:ctor(numberofframes,animationname,animationtime,repeatbool)
	self.numberofframes=numberofframes
	self.animationname=animationname
	self.animationtime=animationtime
	self.repeatbool=repeatbool
	--///////////////动画开始//////////////////////
    local animation = cc.Animation:create()
    for i=1, numberofframes do

        local frameName = string.format(animationname.."%d.png",i)
        --cclog("frameName = %s",frameName)
        local spriteFrame2 = spriteFrame:getSpriteFrame(frameName)
        animation:addSpriteFrame(spriteFrame2)
    end

    animation:setDelayPerUnit(animationtime)           --设置两个帧播放时间
    animation:setRestoreOriginalFrame(false)    --动画执行后还原初始状态

    local action = cc.Animate:create(animation)
    if(repeatbool)then
        local Repeatacttion=cc.RepeatForever:create(action)
        return Repeatacttion
    else
        return action
    end
end

return animationList