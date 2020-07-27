for size=1,100 do
    surface.CreateFont("GModToolScreen"..size,  {
        font = "Helvetica", 
        size = size, 
        antialias = true,
        weight = 900}
    )
end

local function DrawScrollingText( text, y, texwide , color,speed)
	local w, h = surface.GetTextSize( text )
	w = w + 64
	y = y - h / 2
	local x = RealTime() * speed % w * -1
	while ( x < texwide ) do
		surface.SetTextColor( 0, 0, 0, 255 )
		surface.SetTextPos( x + 3, y + 3 )
		surface.DrawText( text )
		surface.SetTextColor( color )
		surface.SetTextPos( x, y )
		surface.DrawText( text )
		x = x + w
	end
end

local mats = {}
local RTTexture = GetRenderTarget( "GModToolgunScreen", 256, 256 ) 
local matScreen = Material( "models/weapons/v_toolgun/screen" ) -- like in basic toolgun files
local errMat = Material("error")
local test = Material("icons16/wrench.png")

local function drawScreen(self)
    matScreen:SetTexture( "$basetexture", RTTexture )
    local size = 256
    local mode = GetConVarString( "gmod_toolmode" )
    local back =  render.GetRenderTarget()
    local oldW = ScrW()
    local oldH = ScrH()

    render.SetRenderTarget( RTTexture )
	render.SetViewPort( 0, 0, size,size )
	cam.Start2D()
    local textcolor = CUSTOMTOOLGUN.data.rainbowtext and HSVToColor(CurTime()*CUSTOMTOOLGUN.data.rainbowspeed,1,1) or CUSTOMTOOLGUN.data.textcolor
    if ( self:GetToolObject() && self:GetToolObject().DrawToolScreen && !CUSTOMTOOLGUN.data.overridecustom ) then
		self:GetToolObject():DrawToolScreen( size,size )
    elseif CUSTOMTOOLGUN.data.overridewithpic then
        draw.NoTexture()
        surface.SetDrawColor(Color(0,0,0))
        surface.DrawRect(0,0,size,size)
        local mat
            if(string.StartWith(CUSTOMTOOLGUN.data.picture,"http"))then
                mat = CUSTOMTOOLGUN.getURLMaterial(CUSTOMTOOLGUN.data.picture,size,size)
            else
                if(mats[CUSTOMTOOLGUN.data.picture])then 
                    mat = mats[CUSTOMTOOLGUN.data.picture] 
                else
                    mats[CUSTOMTOOLGUN.data.picture] = Material(CUSTOMTOOLGUN.data.picture)
                end
            end
        if(mat)then
            surface.SetMaterial(mat)
        end
        surface.SetDrawColor(Color(255,255,255,255))
        surface.DrawTexturedRect(0,0,size,size)
        surface.SetFont("GModToolScreen"..CUSTOMTOOLGUN.data.textsize)
        DrawScrollingText("#tool." .. mode .. ".name",CUSTOMTOOLGUN.data.textheight,size,textcolor,CUSTOMTOOLGUN.data.textspeed)
        if(CUSTOMTOOLGUN.data.showdesc)then
            surface.SetFont("GModToolScreen"..CUSTOMTOOLGUN.data.descsize)
            DrawScrollingText( "#tool." .. mode .. ".desc", CUSTOMTOOLGUN.data.descheight, size,textcolor,CUSTOMTOOLGUN.data.descspeed)
        end
        //draw.SimpleTextOutlined("#tool." .. mode .. ".name","GModToolScreen"..CUSTOMTOOLGUN.data.textsize,CUSTOMTOOLGUN.data.textpos.x, CUSTOMTOOLGUN.data.textpos.y, textcolor, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,CUSTOMTOOLGUN.data.outlinesize,Color(0,0,0))
    else
        draw.NoTexture()
        surface.SetDrawColor(CUSTOMTOOLGUN.data.color)
        surface.DrawTexturedRect(0,0,256,256)
        surface.SetFont("GModToolScreen"..CUSTOMTOOLGUN.data.textsize)
        DrawScrollingText("#tool." .. mode .. ".name",CUSTOMTOOLGUN.data.textheight,size,textcolor,CUSTOMTOOLGUN.data.textspeed)
        if(CUSTOMTOOLGUN.data.showdesc)then
            surface.SetFont("GModToolScreen"..CUSTOMTOOLGUN.data.descsize)
            DrawScrollingText( "#tool." .. mode .. ".desc", CUSTOMTOOLGUN.data.descheight, size,textcolor,CUSTOMTOOLGUN.data.descspeed)
        end
        //draw.SimpleTextOutlined("#tool." .. mode .. ".name","GModToolScreen"..CUSTOMTOOLGUN.data.textsize,CUSTOMTOOLGUN.data.textpos.x, CUSTOMTOOLGUN.data.textpos.y, textcolor, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,CUSTOMTOOLGUN.data.outlinesize,Color(0,0,0))
    end
    cam.End2D()
    render.SetRenderTarget(back)
    render.SetViewPort( 0, 0, oldW, oldH )
end



CUSTOMTOOLGUN.CanLoad = function()
    return file.Exists("customtoolgun.txt","DATA")
end

CUSTOMTOOLGUN.Load = function()
    if(!CUSTOMTOOLGUN.CanLoad())then return end
    local data = file.Read("customtoolgun.txt")
    CUSTOMTOOLGUN.data = util.JSONToTable(data)
end

CUSTOMTOOLGUN.Save = function()
    file.Write("customtoolgun.txt",util.TableToJSON(CUSTOMTOOLGUN.data))
end


--Hooking into toolgun
hook.Add("InitPostEntity","ok",function()
local toolgun = weapons.Get("gmod_tool")
toolgun.OldRenderScreen = toolgun.OldRenderScreen or toolgun.RenderScreen
toolgun.RenderScreen = function(s)
    if CUSTOMTOOLGUN.data.enabled then 
    drawScreen(s)
    else
    toolgun.OldRenderScreen(s)
    end
end
weapons.Register(toolgun,"gmod_tool")
CUSTOMTOOLGUN.Load()
end)

