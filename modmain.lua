local function DoRemove()
    local list = {}
    for k,v in pairs(GLOBAL.Ents) do
        if v.components.inventoryitem and v.components.inventoryitem.owner == nil then
            if not v:HasTag("smallcreature")                --鸟、兔子、鼹鼠
                and not v:HasTag("irreplaceable")           --可疑的大理石、远古钥匙、眼骨、星空、天体灵球、格罗姆花
                and not v:HasTag("heavy")                   --雕像
                and not v:HasTag("backpack")                --背包、小猪包、小偷包
                and not v:HasTag("bundle")                  --包裹、礼物
                and not v:HasTag("deerantler")              --鹿角
                and not v:HasTag("trap")                    --陷阱、狗牙陷阱、海星
                and not string.find(v.prefab, "book")       --奶奶的书
                and not string.find(v.prefab, "mooneye")    --月眼
                and not string.find(v.prefab, "saddle")     --鞍
                and not string.find(v.prefab, "powcake")    --芝士蛋糕
                and v.prefab ~= "waxwelljournal"            --老麦的书
                and v.prefab ~= "fireflies"                 --萤火虫
                and v.prefab ~= "slurper"                   --啜食者
                and v.prefab ~= "pumpkin_lantern"           --南瓜灯
                and v.prefab ~= "bullkelp_beachedroot"      --海带
                and v.prefab ~= "driftwood_log"             --浮木桩
                and v.prefab ~= "panflute"                  --排箫
                and v.prefab ~= "tentaclespike"             --狼牙棒
                and v.prefab ~= "nightsword"                --影刀
                and v.prefab ~= "armor_sanity"              --影甲
                and v.prefab ~= "skeletonhat"               --骨盔
                and v.prefab ~= "armorskeleton"             --骨甲
                and v.prefab ~= "thurible"                  --香炉
                and v.prefab ~= "fossil_piece"              --化石碎片
                and v.prefab ~= "shadowheart"               --心脏
                and v.prefab ~= "amulet"                    --生命护符
                and v.prefab ~= "reviver"                   --救赎之心
                and v.prefab ~= "heatrock"                  --暖石
                and v.prefab ~= "dug_trap_starfish"         --挖起的海星
                and v.prefab ~= "yellowstaff"               --唤星法杖
                and v.prefab ~= "opalstaff"                 --喚月法杖
                and v.prefab ~= "cane"                      --步行手杖
                and v.prefab ~= "orangestaff"               --瞬移手杖
                and v.prefab ~= "glommerfuel"               --格罗姆燃料
                and v.prefab ~= "lureplantbulb"             --食人花种子
                and v.prefab ~= "tentaclespots"             --触手皮
                and v.prefab ~= "hivehat"                   --蜂王帽
            then
                if v:HasTag("RemoveCountOne") then
                    print("111")
                    v:Remove()
                    local numm = list[v.name.."  "..v.prefab]
                    if numm == nil then
                        list[v.name.."  "..v.prefab] = 1
                    else
                        numm = numm + 1
                        list[v.name.."  "..v.prefab] = numm
                    end
                else
                    print("222")
                    v:AddTag("RemoveCountOne")
                end
            end
        end
    end
    for k,v in pairs(list) do
        print("wiped", v, k)
    end
end

local function WorldPeriodicRemove(inst)
	if not GLOBAL.TheWorld:HasTag("cave") then
	    inst:ListenForEvent("cycleschanged", function()
	        local count_20days = GLOBAL.TheWorld.state.cycles / 20
	        if math.floor(count_20days) == count_20days then --try spawn prefabs every 20 days
	            DoRemove()
	        end
	    end)
	end
end

local function CavePeriodicRemove(inst)
	if GLOBAL.TheWorld:HasTag("cave") then
	    inst:ListenForEvent("cycleschanged", function()
	        local count_20days = GLOBAL.TheWorld.state.cycles / 20
	        if math.floor(count_20days) == count_20days then --try spawn prefabs every 20 days
	            DoRemove()
	        end
	    end)
	end
end

AddPrefabPostInit("world", WorldPeriodicRemove)
AddPrefabPostInit("cave", CavePeriodicRemove)