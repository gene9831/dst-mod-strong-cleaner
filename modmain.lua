local TheNet = GLOBAL.TheNet
local lang = TheNet:GetDefaultServerLanguage()
local Vector3 = GLOBAL.Vector3
local io = GLOBAL.io

local checkingdays = GetModConfigData("checking_days")
local white_area = GetModConfigData("white_area")
local clean_mode = GetModConfigData("clean_mode")

local lightbulb = "󰀏"

local whitelist = {
    "book",                     --奶奶的书(关键词)
    "mooneye",                  --月眼(关键词)
    "saddle",                   --鞍(关键词)
    "powcake",                  --芝士蛋糕(关键词)
    "waxwelljournal",           --老麦的书
    "fireflies",                --萤火虫
    "slurper",                  --啜食者
    "pumpkin_lantern",          --南瓜灯
    "bullkelp_beachedroot",     --海带
    "driftwood_log",            --浮木桩
    "panflute",                 --排箫
    "skeletonhat",              --骨盔
    "armorskeleton",            --骨甲
    "thurible",                 --香炉
    "fossil_piece",             --化石碎片
    "shadowheart",              --心脏
    "amulet",                   --生命护符
    "reviver",                  --救赎之心
    "heatrock",                 --暖石
    "dug_trap_starfish",        --挖起的海星
    "yellowstaff",              --唤星法杖
    "opalstaff",                --喚月法杖
    "cane",                     --步行手杖
    "orangestaff",              --瞬移手杖
    "glommerfuel",              --格罗姆燃料
    "lureplantbulb",            --食人花种子
    "tentaclespots",            --触手皮
    "hivehat",                  --蜂王帽
    "tentaclespike",            --狼牙棒
    "nightsword",               --影刀
    "armor_sanity",             --影甲
    "tacklecontainer",          --钓具箱
    "supertacklecontainer",     --超级钓具箱
    "singingshell_octave",      --贝壳钟(关键词 有3 4 5)
}

local blacklist = {
    "twigs",                    --树枝
    "cutgrass",                 --割下的草
    "spoiled_food",             --腐烂食物
    "houndstooth",              --狗牙
    "stinger",                  --蜂刺
}

local whitetag = {
    "smallcreature",           --鸟、兔子、鼹鼠
    "irreplaceable",           --可疑的大理石、远古钥匙、眼骨、星空、天体灵球、格罗姆花
    "heavy",                   --雕像
    "backpack",                --背包、小猪包、小偷包
    "bundle",                  --包裹、礼物
    "deerantler",              --鹿角
    "trap",                    --陷阱、狗牙陷阱、海星
}

local halfwhitelist = {
    "tentaclespike",            --狼牙棒
    "nightsword",               --影刀
    "armor_sanity",             --影甲
}

if clean_mode == 0 then
    local readtxt,err = io.open(MODROOT.."/whitelist.txt", "r")
    if not err then
        for line in readtxt:lines() do
            line = string.sub(line, 1, -2)
            table.insert(whitelist,line)
            print('Whitelist Add:', line)
        end
    end
else
    local readtxt,err = io.open(MODROOT.."/blacklist.txt", "r")
    if not err then
        for line in readtxt:lines() do
            line = string.sub(line, 1, -2)
            table.insert(blacklist,line)
            print('Blacklist Add:', line)
        end
    end
end

local function isWhitelist(name)
    for k,v in pairs(whitelist) do
        if string.find(name, v) then
            return true
        end
    end
    return false
end

local function isBlacklist(name)
    for k,v in pairs(blacklist) do
        if string.find(name, v) then
            return true
        end
    end
    return false
end

local function isWhiteTag(fabs)
    for k,v in pairs(whitetag) do
        if fabs:HasTag(v) then
            return true
        end
    end
    return false
end

local function isHalfWhitelist(fabs)
    for k,v in pairs(halfwhitelist) do
        if string.find(fabs.prefab, v) then
            if fabs.components.finiteuses then
                if fabs.components.finiteuses:GetPercent() < 1 then
                    return true
                end
            end
        end
    end
end

local function isFloat(fabs)
    if fabs.components.floater then
        if fabs.components.floater:IsFloating() and fabs.prefab ~= "driftwood_log" then
            return true
        end
    end
    return false
end

local function WhiteArea(inst)
    if white_area then
        local pos = Vector3(inst.Transform:GetWorldPosition())
        entity_list = TheSim:FindEntities(pos.x, pos.y, pos.z, 4)
        for i, entity in pairs(entity_list) do
            if entity.prefab == "endtable" then
                return false
            end
        end
        return true
    else
        return true
    end
end

local function DoRemove()
    local list = {}
    for k,v in pairs(GLOBAL.Ents) do
        if v.components.inventoryitem and v.components.inventoryitem.owner == nil then
            if (clean_mode == 0 and not isWhitelist(v.prefab) and not isWhiteTag(v))
                or (clean_mode == 1 and isBlacklist(v.prefab))
                or isHalfWhitelist(v) or isFloat(v) then
                if WhiteArea(v) then
                    if v:HasTag("RemoveCountOne") then
                        v:Remove()
                        local numm = list[v.name.."  "..v.prefab]
                        if numm == nil then
                            list[v.name.."  "..v.prefab] = 1
                        else
                            numm = numm + 1
                            list[v.name.."  "..v.prefab] = numm
                        end
                    else
                        v:AddTag("RemoveCountOne")
                    end
                end
            end
        end
    end
    
    --如果list为空就不宣告
    if GLOBAL.next(list) ~= nil then
        for k,v in pairs(list) do
            print("wiped", v, k)
        end
    	print("Wiping Done!")
        if not GLOBAL.TheShard:IsSecondary() then
            if lang == "zh" then
                TheNet:Announce(lightbulb.."服务器清理完毕"..lightbulb)
            else
                TheNet:Announce(lightbulb.."Server Cleaning Done"..lightbulb)
            end
        end
    end
end

local function WorldPeriodicRemove(inst)
	if not GLOBAL.TheWorld:HasTag("cave") then
        inst:DoTaskInTime(.5, function(inst)
    	    inst:ListenForEvent("cycleschanged", function()
    	        local count_days = GLOBAL.TheWorld.state.cycles / checkingdays
    	        if math.floor(count_days) == count_days then --默认每20天检查一次
    	            DoRemove()
    	        end
    	    end)
        end)
	end
end

local function CavePeriodicRemove(inst)
	if GLOBAL.TheWorld:HasTag("cave") then
        inst:DoTaskInTime(.5, function(inst)
    	    inst:ListenForEvent("cycleschanged", function()
    	        local count_days = GLOBAL.TheWorld.state.cycles / checkingdays
    	        if math.floor(count_days) == count_days then --默认每20天检查一次
    	            DoRemove()
    	        end
    	    end)
        end)
	end
end

AddPrefabPostInit("forest", WorldPeriodicRemove)
AddPrefabPostInit("cave", CavePeriodicRemove)

--For Boat

if GetModConfigData("boat_clean") then

    local boat_delete_time = GetModConfigData("boat_clean") * 480

    local function starttimer(inst)
        local players = inst.components.walkableplatform:GetEntitiesOnPlatform({"player"},nil)
        if #players == 0 then
            inst.components.timer:StartTimer("boatRemoval", boat_delete_time)
            --print("计时器：开始")
        end
    end

    local function stoptimer(inst, obj)
        if obj and obj:HasTag("player") then
            inst.components.timer:StopTimer("boatRemoval")
            --print("计时器：结束")
        end
    end

    local function ontimerdone(inst)
        local players = inst.components.walkableplatform:GetEntitiesOnPlatform({"player"},nil)
        if #players == 0 then
            inst:Remove()
            print("计时器：删除船")
        end
    end

    local function BoatAutoRemove(inst)
        if not GLOBAL.TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent("timer")
        inst:ListenForEvent("obj_got_on_platform", stoptimer )
        inst:ListenForEvent("obj_got_off_platform", starttimer)
        inst.components.timer:StartTimer("boatRemoval", boat_delete_time)
        inst:ListenForEvent("timerdone", ontimerdone)
    end

    AddPrefabPostInit("boat", BoatAutoRemove)
    
end