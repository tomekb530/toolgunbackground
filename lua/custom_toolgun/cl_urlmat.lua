local urlmats = {}
local pnls = {}
function CUSTOMTOOLGUN.getURLMaterial(url,w,h)
if !url or !w or !h then return Material("error") end
if urlmats[url] then return urlmats[url] end
if(pnls[url])then return Material("error") end
    local pnl = vgui.Create("HTML")
    pnl:SetAlpha(0)
    pnl:SetSize(w,h)
    pnl:SetHTML([[
        <html>
        <head>
        <style>
        body{
            background-image:url(']]..url..[[');
            background-size:cover;
        }
        </style>
        </head>
        <body>
        </body>
        </html>
    ]])
    pnls[url] = pnl
    function pnl:Paint()
        if(!urlmats[url] and self:GetHTMLMaterial())then
            urlmats[url] = self:GetHTMLMaterial()
            //self:Remove()
            //print("ok")
        end
    end

    timer.Simple(1,function()
    if(IsValid(pnl)) then
    pnls[url] = nil
    pnl:Remove()
    end
    end)
return Material("error")
end