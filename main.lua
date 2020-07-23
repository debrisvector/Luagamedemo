


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
