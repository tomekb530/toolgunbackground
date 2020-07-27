--DO NOT TOUCH
CUSTOMTOOLGUN = {}
CUSTOMTOOLGUN.data = {
    enabled = false,
    overridecustom = true,
    overridewithpic = true,
    color = Color(255,255,255),
    picture = "https://pm1.narvii.com/7349/20496af691a3f529d64bdffade368e123b204328r1-640-526v2_uhq.jpg",
    textcolor = Color(255,255,255),
    textheight = 210,
    textspeed=250,
    rainbowtext = true,
    textsize = 60,
    rainbowspeed=10,
    showdesc = true,
    descheight = 240,
    descsize = 30,
    descspeed = 200,
}

if SERVER then
    for i,v in ipairs(file.Find("custom_toolgun/*","LUA")) do
        if(string.StartWith(v,"cl_"))then
            AddCSLuaFile("custom_toolgun/"..v)
        end
        if(string.StartWith(v,"sh_"))then
            AddCSLuaFile("custom_toolgun/"..v)
            include("custom_toolgun/"..v)
        end
        if(string.StartWith(v,"sv_"))then
            include("custom_toolgun/"..v)
        end
    end
else
for i,v in ipairs(file.Find("custom_toolgun/*","LUA")) do
        if(string.StartWith(v,"cl_"))then
            include("custom_toolgun/"..v)
        end
        if(string.StartWith(v,"sh_"))then
            include("custom_toolgun/"..v)
        end
    end
end