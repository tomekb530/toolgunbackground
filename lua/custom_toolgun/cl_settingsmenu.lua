local pnl
local matScreen = Material( "models/weapons/v_toolgun/screen" )

local function quickcheck(parent,lblt)
    local wrap = vgui.Create("DPanel",parent)
    wrap:Dock(TOP)
    wrap.Paint = function() end
    local chckbox = vgui.Create("DCheckBox",wrap)
    local lbl = vgui.Create("DLabel",wrap)
    lbl:SetText(lblt)
    chckbox:Dock(RIGHT)
    chckbox:SetWide(wrap:GetTall())
    lbl:Dock(FILL)
    return chckbox
end

local function quickcolor(parent,lblt,var)
    local wrap = vgui.Create("DPanel",parent)
    wrap:Dock(TOP)
    wrap.Paint = function() end
    local chckbox = vgui.Create("DButton",wrap)
    local lbl = vgui.Create("DLabel",wrap)
    lbl:SetText(lblt)
    chckbox:Dock(RIGHT)
    chckbox:SetText("Pick")
    function chckbox:DoClick()
        local picker = vgui.Create("DFrame")
        picker:SetTitle("Pick A Color")
        picker:SetSize(300,300)
        picker:Center()
        function picker:Paint(w,h)
            surface.SetDrawColor(Color(50,50,50,200))
            surface.DrawRect(0,0,w,h)
        end
        picker:MakePopup()
        local color = vgui.Create("DColorMixer",picker)
        color:Dock(FILL)
        color:SetColor(CUSTOMTOOLGUN.data[var])
        local butt = vgui.Create("DButton",picker)
        butt:SetText("Apply")
        butt:Dock(BOTTOM)
        function butt:DoClick()
            local col = color:GetColor()
            col = Color(col.r,col.g,col.b,255)
            CUSTOMTOOLGUN.data[var] = col
            picker:Remove()
        end
    end
    --chckbox:SetWide(wrap:GetTall())
    lbl:Dock(FILL)
    return chckbox
end

local function quicknum(parent,lblt)
    local wrap = vgui.Create("DPanel",parent)
    wrap:Dock(TOP)
    wrap.Paint = function() end
    local chckbox = vgui.Create("DNumSlider",wrap)
    local lbl = vgui.Create("DLabel",wrap)
    lbl:SetText(lblt)
    chckbox:Dock(FILL)
    --chckbox:SetWide(wrap:GetTall())
    lbl:Dock(FILL)
    return chckbox
end

local function OpenMenu()
    pnl = vgui.Create("DFrame")
    pnl:SetSize(600,300)
    pnl:SetTitle("Custom Toolgun Settings Menu")
    pnl:Center()
    pnl:MakePopup()
    function pnl:Paint(w,h)
        surface.SetDrawColor(Color(50,50,50,255))
        surface.DrawRect(0,0,w,h)
    end
    function pnl:OnClose()
        pnl:Remove()
        CUSTOMTOOLGUN.Save()
        print("saved")
    end
    local toolgunwrapper = vgui.Create("DPanel",pnl)
    toolgunwrapper:Dock(RIGHT)
    toolgunwrapper:SetWide(256)
    function toolgunwrapper:Paint(w,h)
        surface.SetMaterial(matScreen)
        surface.DrawTexturedRect(0,0,256,256)
        local toolgun = weapons.Get("gmod_tool")
        toolgun:RenderScreen()
    end
    local settingswrapper = vgui.Create("DScrollPanel",pnl)
    settingswrapper:Dock(FILL)
    settingswrapper:DockMargin(0,0,10,0)
    settingswrapper.Paint = function() end
    local enabled = quickcheck(settingswrapper,"Enabled")
    enabled:SetChecked(CUSTOMTOOLGUN.data.enabled)
    function enabled:OnChange(check)
        CUSTOMTOOLGUN.data.enabled = check
    end
    local urllbl = vgui.Create("DLabel",settingswrapper)
    urllbl:SetText("Link for custom background")
    urllbl:Dock(TOP)

    local url = vgui.Create("DTextEntry",settingswrapper)
    url:Dock(TOP)
    --url:DockMargin(0,0,5,0)
    url:SetText(CUSTOMTOOLGUN.data.picture)
    function url:OnChange()
        local val = url:GetValue()
        timer.Create("debounce", 1, 1,function()
            CUSTOMTOOLGUN.data.picture = val
        end)
    end

    local compass = quickcheck(settingswrapper,"Show Compass")
    compass:SetChecked(CUSTOMTOOLGUN.data.compass)
    function compass:OnChange(check)
        CUSTOMTOOLGUN.data.compass = check
    end

    quickcolor(settingswrapper,"Compass Color","compasscolor")
    quickcolor(settingswrapper,"Compass Outline Color","compassoutline")

    local textsize = quicknum(settingswrapper,"Tool text size")
    textsize:SetMinMax(1,100)
    textsize:SetDecimals(0)
    textsize:SetValue(math.floor(CUSTOMTOOLGUN.data.textsize))

    function textsize:OnValueChanged(val)
        CUSTOMTOOLGUN.data.textsize = math.floor(val)
    end

    local textposy = quicknum(settingswrapper,"Text Height")
    textposy:SetMinMax(0,256)
    textposy:SetDecimals(0)
    textposy:SetValue(math.floor(CUSTOMTOOLGUN.data.textheight))

    function textposy:OnValueChanged(val)
        CUSTOMTOOLGUN.data.textheight = math.floor(val)
    end

    local textspeed = quicknum(settingswrapper,"Text Speed")
    textspeed:SetMinMax(0,500)
    textspeed:SetDecimals(0)
    textspeed:SetValue(math.floor(CUSTOMTOOLGUN.data.textspeed))

    function textspeed:OnValueChanged(val)
        CUSTOMTOOLGUN.data.textspeed = math.floor(val)
    end

    local showdesc = quickcheck(settingswrapper,"Show Desc")
    showdesc:SetChecked(CUSTOMTOOLGUN.data.showdesc)
    function showdesc:OnChange(check)
        CUSTOMTOOLGUN.data.showdesc = check
    end

    local descsize = quicknum(settingswrapper,"Desc size")
    descsize:SetMinMax(1,100)
    descsize:SetDecimals(0)
    descsize:SetValue(math.floor(CUSTOMTOOLGUN.data.descsize))

    function descsize:OnValueChanged(val)
        CUSTOMTOOLGUN.data.descsize = math.floor(val)
    end

    local descposy = quicknum(settingswrapper,"Desc Height")
    descposy:SetMinMax(0,256)
    descposy:SetDecimals(0)
    descposy:SetValue(math.floor(CUSTOMTOOLGUN.data.descheight))

    function descposy:OnValueChanged(val)
        CUSTOMTOOLGUN.data.descheight = math.floor(val)
    end

    local descspeed = quicknum(settingswrapper,"Desc Speed")
    descspeed:SetMinMax(0,500)
    descspeed:SetDecimals(0)
    descspeed:SetValue(math.floor(CUSTOMTOOLGUN.data.descspeed))

    function descspeed:OnValueChanged(val)
        CUSTOMTOOLGUN.data.descspeed = math.floor(val)
    end
    
    local rainbowspeed = quicknum(settingswrapper,"Rainbow Speed")
    rainbowspeed:SetMinMax(0,100)
    rainbowspeed:SetDecimals(0)
    rainbowspeed:SetValue(math.floor(CUSTOMTOOLGUN.data.rainbowspeed))

    function rainbowspeed:OnValueChanged(val)
        CUSTOMTOOLGUN.data.rainbowspeed = math.floor(val)
    end
    local rainbow = quickcheck(settingswrapper,"Rainbow Text")
    rainbow:SetChecked(CUSTOMTOOLGUN.data.rainbowtext)
    rainbowspeed:SetEnabled(CUSTOMTOOLGUN.data.rainbowtext)
    function rainbow:OnChange(check)
        CUSTOMTOOLGUN.data.rainbowtext = check
        rainbowspeed:SetEnabled(check)
    end

    quickcolor(settingswrapper,"Pick Text Color","textcolor")

    local overridewithcolor = quickcheck(settingswrapper,"Override BG With Color")
    overridewithcolor:SetChecked(!CUSTOMTOOLGUN.data.overridewithpic)
    function overridewithcolor:OnChange(check)
        CUSTOMTOOLGUN.data.overridewithpic = !check
    end

    quickcolor(settingswrapper,"Pick BG Color","color")

    local overridecustom = quickcheck(settingswrapper,"Override custom screens (Like from Wiremod)")
    overridecustom:SetChecked(CUSTOMTOOLGUN.data.overridecustom)
    function overridecustom:OnChange(check)
        CUSTOMTOOLGUN.data.overridecustom = check
    end
end

local function ToggleMenu()
    if(IsValid(pnl))then
        pnl:Remove()
    else
        OpenMenu()
    end
end
concommand.Add("custom_toolgun",function()
ToggleMenu()
end)


list.Set(
	"DesktopWindows",
	"Custom Toolgun",
	{
		title = "Custom Toolgun Menu",
		icon = "icon16/wrench.png",
		width = 960,
		height = 700,
		onewindow = true,
		init = function(icn, pnl)
			pnl:Remove()
			RunConsoleCommand("custom_toolgun")
		end
	}
)