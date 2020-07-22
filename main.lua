-- 
-- Created by 关东升 on 2016-3-18.
-- 本书网站：http://www.51work6.com
-- 智捷课堂在线课堂：http://www.zhijieketang.com/
-- 智捷课堂微信公共号：zhijieketang
-- 作者微博：@tony_关东升
-- 作者微信：tony关东升
-- QQ：569418560 邮箱：eorient@sina.com
--  QQ交流群：162030268
-- 


require "cocos.init"

-- cclog
cclog = function(...)
    print(string.format(...))
end --qweweqew

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    ----------------
    cc.FileUtils:getInstance():addSearchPath("src")
    cc.FileUtils:getInstance():addSearchPath("res")

    local director = cc.Director:getInstance()
    director:getOpenGLView():setDesignResolutionSize(960, 640, 0)

    --设置是否显示帧率和精灵个数
    director:setDisplayStats(true)

    --设置帧率
    director:setAnimationInterval(1.0 / 60)

    --创建场景
    local scene = require("GameScene")
    local gameScene = scene:create()

    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(gameScene)
    else
        cc.Director:getInstance():runWithScene(gameScene)
    end

end


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
