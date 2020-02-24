name = "Strong Cleaner"
description = [[
A cleaning mod for your server.
Cleaning Mechanism:
It will check the things on the ground every 20 days(by default, configurable).
Things that are check the first time will be added tags.
Things with tags that are previously added will be remove during the second round of checking.
That means if something will go through at least 20 days before removed.
The checking date is at the end of the day of 20,40,60,80,100,etc.
The mod will only remove things that are on the ground and not include in the whitelist.
Things that are in the players' inventory and containers or not include in the whitelist are secure.
BTW, server reboot will remove all tags.
]]
author = "辣椒小皇纸"
version = "1.7.0"

forumthread = ""

api_version = 10

all_clients_require_mod = false
client_only_mod = false
dst_compatible = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {"Strong Cleaner"}

----------------------
-- General settings --
----------------------

configuration_options =
{
	{
		name = "checking_days",
		label = "Checking Days",
		hover = "Checking Period清理间隔",
		options =	{
						{description = "10", data = 10, hover = ""},
						{description = "20", data = 20, hover = ""},
						{description = "30", data = 30, hover = ""},
						{description = "40", data = 40, hover = ""},
						{description = "50", data = 50, hover = ""},
					},
		default = 20,
	},
    {
        name = "white_area",
        label = "White Area",
        hover = "Things near the tables will not be removed茶几附近的物品不清理",
        options =   {
                        {description = "Yes", data = true, hover = ""},
                        {description = "No", data = false, hover = ""},
                    },
        default = true,
    },
    {
        name = "boat_clean",
        label = "Boat Clean",
        hover = "Destroy boats that were not used for a specific days.",
        options =   {
                        {description = "No", data = false, hover = ""},
                        {description = "180 days in game", data = 180, hover = ""},
                        {description = "360 days in game", data = 360, hover = ""},
                        {description = "540 days in game", data = 540, hover = ""},
                        {description = "720 days in game", data = 720, hover = ""},
                    },
        default = false,
    },
}