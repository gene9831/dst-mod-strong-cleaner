local TheNet = GLOBAL.TheNet
local lang = TheNet:GetDefaultServerLanguage()
local Vector3 = GLOBAL.Vector3

local checkingdays = GetModConfigData("checking_days")
local white_area = GetModConfigData("white_area")

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
    "tentaclespike",            --狼牙棒
    "nightsword",               --影刀
    "armor_sanity",             --影甲
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

local function isWhitelist(prefab)
    for k,v in pairs(whitelist) do
        if string.find(prefab, v) then
            return true
        end
    end
    return false
end

local function isWhiteTag(prefab)
    for k,v in pairs(whitetag) do
        if prefab:HasTag(v) then
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
            if not isWhitelist(v.prefab) and not isWhiteTag(v) then
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
        if not GLOBAL.TheShard:IsSlave() then
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

AddPrefabPostInit("world", WorldPeriodicRemove)
AddPrefabPostInit("cave", CavePeriodicRemove)