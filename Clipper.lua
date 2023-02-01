local DATA = {
    WARLOCK = {
        [172] = "corruption",
        [6222] = "corruption",
        [6223] = "corruption",
        [7648] = "corruption",
        [11671] = "corruption",
        [11672] = "corruption",
        [25311] = "corruption",
        [27216] = "corruption",
        [47812] = "corruption",
        [47813] = "corruption",
        
        [348] = "immolate",
        [707] = "immolate",
        [1094] = "immolate",
        [2941] = "immolate",
        [11665] = "immolate",
        [11667] = "immolate",
        [25309] = "immolate",
        [11668] = "immolate",
        [27215] = "immolate",
        [47810] = "immolate",
        [47811] = "immolate",
        
        [30108] = "ua",
        [30404] = "ua",
        [30405] = "ua",
        [47841] = "ua",
        [47843] = "ua",
        
        [18265] = "sl",
        [18879] = "sl",
        [18880] = "sl",
        [18881] = "sl",
        [27264] = "sl",
        [30911] = "sl",
        
        [689] = "drainlife",
        [699] = "drainlife",
        [709] = "drainlife",
        [7651] = "drainlife",
        [11699] = "drainlife",
        [11700] = "drainlife",
        [27219] = "drainlife",
        [27220] = "drainlife",
        [47857] = "drainlife",
        drainlife = true, -- channel flag
        
        [5138] = "drainmana",
        [6226] = "drainmana",
        [11703] = "drainmana",
        [11704] = "drainmana",
        [27221] = "drainmana",
        [30908] = "drainmana",
        drainmana = true, -- channel flag
    },
    DRUID = {
        [8921] = "moonfire",
        [8924] = "moonfire",
        [8925] = "moonfire",
        [8926] = "moonfire",
        [8927] = "moonfire",
        [8928] = "moonfire",
        [8929] = "moonfire",
        [9833] = "moonfire",
        [9834] = "moonfire",
        [9835] = "moonfire",
        [26987] = "moonfire",
        [26988] = "moonfire",
        [48462] = "moonfire",
        [48463] = "moonfire",
        
        [5570] = "is",
        [24974] = "is",
        [24975] = "is",
        [24976] = "is",
        [24977] = "is",
        [27013] = "is",
        [48468] = "is",
    },
    PRIEST = {
        [34914] = "vt",
        [34916] = "vt",
        [34917] = "vt",
        [48159] = "vt",
        [48160] = "vt",
        
        [589] = "swp",
        [594] = "swp",
        [970] = "swp",
        [992] = "swp",
        [2767] = "swp",
        [10892] = "swp",
        [10893] = "swp",
        [10894] = "swp",
        [25367] = "swp",
        [25368] = "swp",
        [48124] = "swp",
        [48125] = "swp",
        
        [2944] = "dp",
        [19276] = "dp",
        [19277] = "dp",
        [19278] = "dp",
        [19279] = "dp",
        [19280] = "dp",
        [25467] = "dp",
        [48299] = "dp",
        [48300] = "dp",
        
        [15407] = "mindflay",
        [17311] = "mindflay",
        [17312] = "mindflay",
        [17313] = "mindflay",
        [17314] = "mindflay",
        [18807] = "mindflay",
        [25387] = "mindflay",
        [48155] = "mindflay",
        [48156] = "mindflay",
        mindflay = true, -- channel flag
        
        [48045] = "mindsear",
        [53023] = "mindsear",
        mindsear = true, -- channel flag
    },
    HUNTER = {
        [1978] = "serpsting",
        [13549] = "serpsting",
        [13550] = "serpsting",
        [13551] = "serpsting",
        [13552] = "serpsting",
        [13553] = "serpsting",
        [13554] = "serpsting",
        [13555] = "serpsting",
        [25295] = "serpsting",
        [27016] = "serpsting",
        [49000] = "serpsting",
        [49001] = "serpsting",
        
        [3034] = "vipersting",
        [14279] = "vipersting",
        [14280] = "vipersting",
        [27018] = "vipersting",
    },
}

local select = select
local _G, SetCursor, LibStub, GetSpellTexture, CombatLogGetCurrentEventInfo =
      _G, SetCursor, LibStub, GetSpellTexture, CombatLogGetCurrentEventInfo
local InterfaceOptionsFrame, InterfaceOptionsFrame_OpenToCategory, InterfaceOptionsListButton_ToggleSubCategories =
      InterfaceOptionsFrame, InterfaceOptionsFrame_OpenToCategory, InterfaceOptionsListButton_ToggleSubCategories
local min, max, random = math.min, math.max, math.random

local MYDATA = DATA[(select(2, UnitClass("player")))]
if not MYDATA then return end

local MYNAME = (...)

local MYOPTIONS

local lastTicks = {}
for spellId, key in pairs(MYDATA) do lastTicks[key] = {} end

local renderFrame = CreateFrame("Frame", "ClipperFrame", UIParent)
renderFrame:SetPoint("CENTER")
renderFrame:SetMovable(true)

local font1 = renderFrame:CreateFontString(nil, "ARTWORK")
font1:SetTextColor(1,1,1)
font1:Hide()

local font2 = renderFrame:CreateFontString(nil, "ARTWORK")
font2:SetTextColor(1,1,1)
font2:Hide()

local moveFrame = CreateFrame("Frame", nil, renderFrame)
moveFrame:SetAllPoints()
moveFrame:Hide()
moveFrame:EnableMouse(true)
moveFrame:SetScript("OnEnter", function() SetCursor("Interface\\CURSOR\\UI-Cursor-Move") end)
moveFrame:SetScript("OnLeave", function() SetCursor(nil) end)
moveFrame:SetScript("OnMouseDown", function() renderFrame:StartMoving() end)
moveFrame:SetScript("OnMouseUp", function() renderFrame:StopMovingOrSizing() end)
moveFrame.tex = moveFrame:CreateTexture(nil, "BACKGROUND")
moveFrame.tex:SetAllPoints()
moveFrame.tex:SetAlpha(.7)
moveFrame.tex:SetColorTexture(.3,.3,1)
moveFrame.text = moveFrame:CreateFontString(nil, "ARTWORK")
moveFrame.text:SetPoint("CENTER")
moveFrame.text:SetTextColor(1,1,1)

local animateFrame = CreateFrame("Frame")
animateFrame:Hide()
local sin,pi = math.sin,math.pi
animateFrame:SetScript("OnUpdate", function(_,e)
    if font1.duration <= e then
        font1:Hide()
        font2:Hide()
        animateFrame:Hide()
        return
    end
    font1.duration = font1.duration-e
    if font1.duration > 2.5 then
        font1:SetScale(1+sin((font1.duration-2.5)/.5*pi)*.5)
    else
        font1:SetScale(1)
    end
    if font2:IsShown() then
        if font2.duration <= e then
            font2:Hide()
            return
        end
        font2.duration = font2.duration-e
        if font2.duration > 2.5 then
            font2:SetScale(1+sin((font2.duration-2.5)/.5*pi)*.5)
        else
            font2:SetScale(1)
        end
    end
end)

local function output(spellId, elapsed)
    local tex = GetSpellTexture(spellId)
    local __good = MYOPTIONS.goodThreshold
    local text
    if elapsed <= __good then
        local __best = MYOPTIONS.bestThreshold
        local red = ((elapsed - __best) / (__good - __best))
        text = ("|T%d:0|t |cff%02xff00GOOD (+%.2fs)|r"):format(tex, max(0,255*red), elapsed)
    elseif elapsed < 10 then
        local __worst = MYOPTIONS.worstThreshold
        local green = ((__worst - elapsed) / (__worst - __good))
        text = ("|T%d:0|t |cffff%02x00BAD (+%.2fs)|r"):format(tex, max(0,255*green), elapsed)
    end
    if font1:IsShown() then
        font2:SetText(font1.text)
        font2.duration = font1.duration
        font2:Show()
    end
    font1.duration = 3
    font1.text = text
    font1:SetText(text)
    font1:Show()
    animateFrame:Show()
end

local LSM = LibStub("LibSharedMedia-3.0")
local function UpdateFonts()
    local fontPath = LSM:Fetch("font", MYOPTIONS.fontFace)
    font1:SetFont(fontPath, MYOPTIONS.fontSize, MYOPTIONS.fontOptions)
    font2:SetFont(fontPath, MYOPTIONS.fontSize, MYOPTIONS.fontOptions)
    moveFrame.text:SetFont(fontPath, MYOPTIONS.fontSize, MYOPTIONS.fontOptions)
    moveFrame.text:SetText("Drag to move\n/clipper for config")
end

local function UpdateAnchors()
    local __lineHeight = MYOPTIONS.lineHeight
    local offset = (__lineHeight / 2)
    renderFrame:SetSize(300,__lineHeight * 2)
    font1:SetSize(300,__lineHeight)
    font1:SetPoint("CENTER", renderFrame, "TOP", 0, -offset)
    font2:SetSize(300,__lineHeight)
    font2:SetPoint("CENTER", renderFrame, "BOTTOM", 0, offset)
end

local testFrame = CreateFrame("Frame")
testFrame:Hide()
testFrame:SetScript("OnUpdate", function(_,e)
    if testFrame.elapsed <= e then
        if testFrame.step == 1 then
            output(34917, MYOPTIONS.goodThreshold + random() * (MYOPTIONS.worstThreshold - MYOPTIONS.goodThreshold))
            testFrame.step = 2
            testFrame.elapsed = 1
        elseif testFrame.step == 2 then
            output(25368, MYOPTIONS.bestThreshold + random() * (MYOPTIONS.goodThreshold - MYOPTIONS.bestThreshold))
            testFrame.step = 3
            testFrame.elapsed = 1
        else
            testFrame:Hide()
            moveFrame[MYOPTIONS.unlock and "Show" or "Hide"](moveFrame)
        end
    else
        testFrame.elapsed = testFrame.elapsed - e
    end
end)

local defaults = {
    unlock = true,
    bestThreshold = .2,
    goodThreshold = .5,
    worstThreshold = 1,
    fontFace = "Arial Narrow",
    fontSize = 20,
    fontOptions = "OUTLINE",
    lineHeight = 20,
    ignored = {},
}

local aceConfigTable = {
    name = "Clipper",
    type = "group",
    args = {
        lock = {
            name  = "Unlock frame",
            type  = "toggle",
            order = 1,
            get   = function() return MYOPTIONS.unlock end,
            set   = function(_,v) moveFrame[v and "Show" or "Hide"](moveFrame) MYOPTIONS.unlock = v end,
        },
        test = {
            name  = "Test output",
            type  = "execute",
            order = 2,
            func  = function() moveFrame:Hide() testFrame.elapsed = 0 testFrame.step = 1 testFrame:Show() end,
        },
        threshold = {
            type  = "group",
            name  = "Clipping thresholds",
        guiInline = true,
            order = 3,
            args = {
                bestThreshold = {
                    name  = "Green threshold";
                    desc  = "This, and anything below, is 100% green",
                    type  = "range",
                    min   = .05,
                  softMin = .1,
                  softMax = 3,
                    max   = 3,
                    order = 1,
                    get   = function() return MYOPTIONS.bestThreshold end,
                    set   = function(_,v)
                        MYOPTIONS.bestThreshold = v
                        MYOPTIONS.goodThreshold = max(v+.01, MYOPTIONS.goodThreshold)
                        MYOPTIONS.worstThreshold = max(v+.02, MYOPTIONS.worstThreshold)
                    end,
                },
                goodThreshold = {
                    name  = "Yellow threshold",
                    desc  = "This is yellow; anything below is GOOD, anything above is BAD",
                    type  = "range",
                    min   = .075,
                  softMin = .1,
                  softMax = 3,
                    max   = 3.025,
                    order = 2,
                    get   = function() return MYOPTIONS.goodThreshold end,
                    set   = function(_,v)
                        MYOPTIONS.bestThreshold = min(v-.01, MYOPTIONS.bestThreshold)
                        MYOPTIONS.goodThreshold = v
                        MYOPTIONS.worstThreshold = max(v+.01, MYOPTIONS.worstThreshold)
                    end,
                },
                worstThreshold = {
                    name  = "Red threshold",
                    desc  = "This, and anything above, is 100% red",
                    type  = "range",
                    min   = .1,
                  softMin = .1,
                    max   = 3.05,
                    order = 3,
                    get   = function() return MYOPTIONS.worstThreshold end,
                    set   = function(_,v)
                        MYOPTIONS.bestThreshold = min(v-.02, MYOPTIONS.bestThreshold)
                        MYOPTIONS.goodThreshold = min(v-.01, MYOPTIONS.goodThreshold)
                        MYOPTIONS.worstThreshold = v
                    end,
                },
            },
        },
        font = {
            type  = "group",
            name  = "Font settings",
        guiInline = true,
            order = 4,
            args = {
                fontFace = {
                    name  = "Font",
                    type  = "select",
                   values = LSM:HashTable("font"),
            dialogControl = "LSM30_Font",
                    order = 1,
                    width = 2,
                    get   = function() return MYOPTIONS.fontFace end,
                    set   = function(_,v) MYOPTIONS.fontFace = v UpdateFonts() end,
                },
                fontSize = {
                    name  = "Font size",
                    type  = "range",
                    min   = 1,
                    max   = 64,
                    step  = 1,
                    order = 2,
                    get   = function() return MYOPTIONS.fontSize end,
                    set   = function(_,v) MYOPTIONS.fontSize = v UpdateFonts() end,
                },
                fontOptions = {
                    name  = "Font options",
                    type  = "select",
                   values = {[""]="No Outline", OUTLINE="Outline", THICKOUTLINE="Thick Outline", MONOCHROME="No Outline + Monochrome", ["OUTLINE,MONOCHROME"]="Outline + Monochrome", ["THICKOUTLINE,MONOCHROME"]="Thick Outline + Monochrome"},
                    order = 3,
                    width = 2,
                    get   = function() return MYOPTIONS.fontOptions end,
                    set   = function(_,v) MYOPTIONS.fontOptions = v UpdateFonts() end,
                },
                lineHeight = {
                    name  = "Line height",
                    type  = "range",
                    min   = 1,
                    max   = 80,
                  bigStep = 1,
                    order = 4,
                    get   = function() return MYOPTIONS.lineHeight end,
                    set   = function(_,v) MYOPTIONS.lineHeight = v UpdateAnchors() end,
                },
            },
        },
    }
}

local aceConfigTableSpells = {
    name = "Clipper: Spells",
    type = "group",
    args = {},
}

do
    local spellList = {}
    for id,key in pairs(MYDATA) do
        if type(id) == "number" then
            if not aceConfigTableSpells.args[key] then
                local name, _, icon = GetSpellInfo(id)
                if name then
                    tinsert(spellList, { name, key })
                    aceConfigTableSpells.args[key] = {
                        name  = ("|T%d:0|t %s%s"):format(icon, name, MYDATA[key] and " [|cffaaaaffChannel|r]" or ""),
                        type  = "toggle",
                        width = "full",
                        get   = function() return not MYOPTIONS.ignored[key] end,
                        set   = function(_,v) if v then MYOPTIONS.ignored[key] = nil else MYOPTIONS.ignored[key] = true end end,
                    }
                end
            end
        end
    end
    table.sort(spellList, function(a,b) return a[1] < b[1] end)
    for i,t in ipairs(spellList) do
        aceConfigTableSpells.args[t[2]].order = i
    end
end

local me = UnitGUID("player")
local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(_,_,n)
    if n ~= MYNAME then return end
    f:UnregisterEvent("ADDON_LOADED")
    
    local db = LibStub("AceDB-3.0"):New("Clipper__DB", {profile = defaults})
    local adbDummy = { OnProfileEnable = function()
        MYOPTIONS = db.profile
        UpdateFonts()
        UpdateAnchors()
        moveFrame[MYOPTIONS.unlock and "Show" or "Hide"](moveFrame)
    end }
    db.RegisterCallback(adbDummy, "OnProfileChanged", "OnProfileEnable")
    db.RegisterCallback(adbDummy, "OnProfileCopied", "OnProfileEnable")
    db.RegisterCallback(adbDummy, "OnProfileReset", "OnProfileEnable")
    adbDummy:OnProfileEnable()
    
    local AC, ACD = LibStub("AceConfig-3.0"), LibStub("AceConfigDialog-3.0")
    AC:RegisterOptionsTable("Clipper", aceConfigTable)
    local optionsRef = ACD:AddToBlizOptions("Clipper")
    local optionsRefDummy = { element = optionsRef }
    
    AC:RegisterOptionsTable("Clipper-Spells", aceConfigTableSpells)
    ACD:AddToBlizOptions("Clipper-Spells", "Spells", "Clipper")
    
    AC:RegisterOptionsTable("Clipper-Profile", LibStub("AceDBOptions-3.0"):GetOptionsTable(db))
    ACD:AddToBlizOptions("Clipper-Profile", "Profiles", "Clipper")
    
    _G.SlashCmdList["CLIPPER"] = function()
        InterfaceOptionsFrame:Show() -- force it to load first
        InterfaceOptionsFrame_OpenToCategory(optionsRef) -- open to our category
        if optionsRef.collapsed then -- expand our sub-categories
            InterfaceOptionsListButton_ToggleSubCategories(optionsRefDummy)
        end
    end
    _G.SLASH_CLIPPER1 = "/CLIPPER"
    
    f:SetScript("OnEvent", function()
        local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24 = CombatLogGetCurrentEventInfo()
        
        if sourceGUID ~= me then return end

        local key = MYDATA[spellId]
        if not key then return end
        if MYOPTIONS.ignored[key] then return end
        
        local ticks = lastTicks[key]
        
        local isChannel = MYDATA[key]
        
        if 
          (isChannel and (subevent == "SPELL_AURA_REMOVED")) or
          ((subevent == "SPELL_AURA_APPLIED") or (subevent == "SPELL_AURA_REFRESH"))
        then
            local lastTick = ticks[destGUID]
            if lastTick then
                local elapsed = (timestamp - lastTick)
                if isChannel and (elapsed <= .001) then return end
                output(spellId, elapsed)
            end
            if subevent == "SPELL_AURA_REMOVED" then
                ticks[destGUID] = nil
            else
                ticks[destGUID] = timestamp
            end
        elseif (subevent == "SPELL_PERIODIC_DAMAGE") or (subevent == "SPELL_PERIODIC_DRAIN") or (subevent == "SPELL_PERIODIC_LEECH") then
            ticks[destGUID] = timestamp
        elseif (subevent == "SPELL_AURA_BROKEN") or (subevent == "SPELL_AURA_BROKEN_SPELL") then
            ticks[destGUID] = false
        end
    end)
    f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end)
f:RegisterEvent("ADDON_LOADED")
