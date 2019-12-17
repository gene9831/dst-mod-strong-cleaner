name = "Strong Cleaner"
description = [[
A cleaning mod for your server.
Cleaning Mechanism:
It will check the things on the ground every 20 days.
Things that are check the first time will be added tags.
Things with tags that are previously added will be remove during the second round of checking.
That means if something will go through at least 20 days before removed.
The checking date is at the end of the day of 20,40,60,80,100,etc.
The mod will only remove things that are on the ground and not include in the whitelist.
Things that are in the players' inventory and containers or not include in the whitelist are secure.
]]
author = "辣椒小皇纸"
version = "1.0.0"

forumthread = ""

api_version = 10

all_clients_require_mod = false
client_only_mod = false
dst_compatible = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {"Strong Cleaner"}