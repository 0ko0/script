if not game:IsLoaded() then
    game.Loaded:Wait()
end

local CORRECT_PLACE_ID = 8540168650 
local isWrongGame = false

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
if not LP then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LP = Players.LocalPlayer
end

if game.PlaceId ~= CORRECT_PLACE_ID then
    isWrongGame = true
    if LP then
        LP:Kick("Stand Upright")
    end
    return
end

local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")

local queue_on_teleport = (syn and syn.queue_on_teleport) 
    or queue_on_teleport 
    or (fluxus and fluxus.queue_on_teleport)

local idk = "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" 
local url = "https://raw.githubusercontent.com/0ko0/Trash/main/trash%20hub.lua"

local SCRIPT_SOURCE = string.format([[
    local req = (syn and syn.request) or http_request or request or (fluxus and fluxus.request)
    if req then
        local res = req({
            Url = "%s",
            Method = "GET",
            Headers = {
                ["Authorization"] = "token %s"
            }
        })
        if res and res.Body then
            loadstring(res.Body)()
        end
    end
]], url, idk)

local function QueueScript()
    if queue_on_teleport and not isWrongGame then
        pcall(function()
            queue_on_teleport(SCRIPT_SOURCE)
        end)
    end
end

if LP then
    LP.OnTeleport:Connect(function(teleportState)
        if teleportState == Enum.TeleportState.InProgress or teleportState == Enum.TeleportState.Started then
            QueueScript()
        end
    end)
end

task.spawn(function()
    GuiService.ErrorMessageChanged:Connect(function()
        if isWrongGame then return end
        task.wait(1)
        QueueScript()
        TeleportService:Teleport(game.PlaceId, LP)
    end)

    local promptOverlay = CoreGui:WaitForChild("RobloxPromptGui", 10) and CoreGui.RobloxPromptGui:WaitForChild("promptOverlay", 10)
    if promptOverlay then
        promptOverlay.ChildAdded:Connect(function(child)
            if isWrongGame then return end
            if child.Name == "ErrorPrompt" then
                task.wait(2)
                QueueScript()
                TeleportService:Teleport(game.PlaceId, LP)
            end
        end)
    end
end)

task.spawn(function()
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local playerGui = LP:WaitForChild("PlayerGui", 30)
    if not playerGui then return end

    local function hideChangelog(gui)
        if gui and gui.Name == "Changelogs" then
            gui.Enabled = false
        end
    end

    local existingChangelog = playerGui:FindFirstChild("Changelogs")
    if existingChangelog then
        hideChangelog(existingChangelog)
    end

    playerGui.ChildAdded:Connect(function(child)
        if child.Name == "Changelogs" then
            task.wait()
            hideChangelog(child)
        end
    end)

    local function isGuiVisible(guiObject)
        if not guiObject then return false end
        if guiObject.AbsoluteSize.X <= 0 or guiObject.AbsoluteSize.Y <= 0 then
            return false
        end
        local current = guiObject
        while current do
            if current:IsA("GuiObject") and not current.Visible then
                return false
            elseif current:IsA("ScreenGui") and not current.Enabled then
                return false
            end
            current = current.Parent
            if current == playerGui then break end
        end
        return true
    end

    local function clickButton(guiObject)
        if typeof(firesignal) == "function" then
            if guiObject:IsA("GuiButton") then
                firesignal(guiObject.MouseButton1Click)
                firesignal(guiObject.Activated)
                return true
            end
        end
        
        local absPos = guiObject.AbsolutePosition
        local absSize = guiObject.AbsoluteSize
        local clickX = absPos.X + (absSize.X / 2)
        local clickY = absPos.Y + (absSize.Y / 2) + 36 
        
        VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, true, game, 1)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, false, game, 1) 
        return true
    end

    local menuGui = playerGui:WaitForChild("MenuGUI", 15)
    local playButton = menuGui and menuGui:WaitForChild("Play", 15)

    if playButton then
        task.wait(0.2)
        if isGuiVisible(playButton) then
            clickButton(playButton)
        end
    end
end)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/0ko0/Gui2/refs/heads/main/test.txt"))()

local Window = Library:Window({
    Name = "skibidi",
    Icon = "layers",
    Accent = Color3.fromRGB(179, 165, 255)
})

local Tab = Window:Tab({
    Name = "Main",
    Icon = "house"
})

local SubTab = Tab:SubTab({
    Name = "farm",
    Icon = "swords"
})

local Section = SubTab:Section({
    Name = "farm",
    Side = "Left"
})

_G.AutoQuest      = false   
_G.AutoTeleport   = false   
_G.Noclip         = false  
_G.CameraNoclip   = false   
_G.BringMob       = false   
_G.AutoSummon     = true
_G.AutoResetMob   = true 
_G.AutoSkill = true
getgenv().SelectedFarmSkills = {"M1", "Heavy", "Barrage"}
_G.AutoBoss            = false
_G.SelectedBoss        = "All Bosses"
_G.BossFarmMode        = "bring"  
_G.BossLegitPos        = "above"  
_G.BossLegitDistance   = 6        
local currentBossTarget    = nil
local currentBossData      = nil
local currentBossObj       = nil
local isTeleportingBoss    = false
local isBossLegitHovering  = false
_G.BossMiasma              = false
_G.MiasmaHealthThreshold   = 20       
_G.MiasmaDirectStick       = false    
local isMiasmaAttacking    = false
local originalMiasmaCFrame = nil
local miasmaOrbitAngle     = 0


local BossList = {
    { Name = "Giorno Giovanna Requiem", Pos = Vector3.new(-734.48, 43.39, -272.05) },
    { Name = "JohnnyJoestar",           Pos = Vector3.new(77.02, 53.97, -310.54) },
    { Name = "Jotaro Over Heaven",      Pos = Vector3.new(28149.34, 15.36, -225.31) },
    { Name = "Alternate Jotaro Part 4", Pos = Vector3.new(11863.48, -20.89, -4498.17) },
    { Name = "Dio_Coffin",              Pos = Vector3.new(-10517.69, -191.28, -195.09) },
    { Name = "Towh_coffin",             Pos = Vector3.new(-10517.69, -191.28, -195.09) },
    { Name = "STUTowh",                 Pos = Vector3.new(-10517.69, -191.28, -195.09) },
    { Name = "Chaka",                   Pos = Vector3.new(-266.29, 49.16, 251.55) }
}

local ResetPos    = Vector3.new(-652.62, -514.32, -171.38)
local isResettingMob = false
local lastTeleportTier = nil

local BringConfig = {
    Range = 55,           
    MaxMobs = 4,          
    DistanceOffset = 5,  
    HeightOffset = 0       
}

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local LP = Players.LocalPlayer

repeat task.wait() until LP:FindFirstChild("Data") and LP.Data:FindFirstChild("Level")
local PlayerLevel = LP.Data.Level
local PlayerQuests = LP.Data:WaitForChild("Quests")

local QuestList = {
    { Name = "Giorno",         Quest = "KillBadGi",         Enemy = "Bad Gi",          Level = 1,   Pos = Vector3.new(-699.89, 43.39, -839.06) },
    { Name = "Scared Noob",    Quest = "KillMonster",       Enemy = "Scary Monster",    Level = 10,  Pos = Vector3.new(-692.31, 42.32, -1058.89) },
    { Name = "Koichi",         Quest = "KillGiorno",        Enemy = "Giorno Giovanna",  Level = 20,  Pos = Vector3.new(-190.93, 43.24, -537.37) },
    { Name = "aLLmemester",    Quest = "KillRker312",       Enemy = "Rker Dummy",      Level = 30,  Pos = Vector3.new(-619.04, 42.47, -475.73) },
    { Name = "Okayasu",        Quest = "KillKira",          Enemy = "Yoshikage Kira",   Level = 40,  Pos = Vector3.new(-535.94, 46.94, -1039.10) },
    { Name = "Joseph Joestar", Quest = "KillDioOH",         Enemy = "Dio Over Heaven",  Level = 50,  Pos = Vector3.new(41.83, 66.83, -882.87) },
    { Name = "Josuke",         Quest = "KillAngelo",        Enemy = "Angelo",          Level = 75,  Pos = Vector3.new(-588.82, 48.33, -651.85) },
    { Name = "Rohan",          Quest = "KillAlien",         Enemy = "Alien",           Level = 100, Pos = Vector3.new(-221.57, 46.97, -703.68) },
    { Name = "DIO",            Quest = "KillJotarop4",      Enemy = "Jotaro Part 4",   Level = 125, Pos = Vector3.new(-385.97, 48.71, -74.44) },
    { Name = "Muhammed Avdol", Quest = "KillKakyoin",       Enemy = "Kakyoin",         Level = 150, Pos = Vector3.new(-242.52, 45.99, -163.79) },
    { Name = "Giorno2",        Quest = "KillJungleGi",      Enemy = "Jungle Bandit",   Level = 175, Pos = Vector3.new(-502.03, 44.04, 27.38) },
    { Name = "Zeppeli",        Quest = "KillSewervampires", Enemy = "Sewer Vampire",   Level = 200, Pos = Vector3.new(-5195.19, -465.73, -3817.24) },
    { Name = "Young Joseph",   Quest = "KillPillermen",     Enemy = "Pillerman",       Level = 275, Pos = Vector3.new(-704.02, 51.06, -147.08) },
    { Name = "ImRageFr",       Quest = "KillBeachJimbos",   Enemy = "Jimbo",           Level = 500, Pos = Vector3.new(-102.95, 45.95, 36.07) }
}

local QuestByFolder = {}
for _, q in ipairs(QuestList) do
    QuestByFolder[q.Quest] = q
end

local function CreateQuestPlatforms()
    local folderName = "QuestPlatformsFolder"
    local oldFolder = Workspace:FindFirstChild(folderName)
    if oldFolder then oldFolder:Destroy() end

    local folder = Instance.new("Folder")
    folder.Name = folderName
    folder.Parent = Workspace

    for _, q in ipairs(QuestList) do
        local platform = Instance.new("Part")
        platform.Name = "Platform_Lv" .. q.Level .. "_" .. q.Name
        platform.Size = Vector3.new(12, 1, 12)
        platform.CFrame = CFrame.new(q.Pos)
        platform.Anchored = true
        platform.CanCollide = true
        platform.Material = Enum.Material.Neon
        platform.Color = Color3.fromRGB(0, 220, 255)
        platform.Transparency = 0.5
        platform.CastShadow = false
        platform.Parent = folder
    end
end

local function GetWorldPivot(model)
    if not model or not model:IsA("Model") then return nil end
    local s, pivot = pcall(function()
        return model:GetPivot()
    end)
    if s and typeof(pivot) == "CFrame" then
        return pivot
    end
    local s2, wp = pcall(function()
        return model.WorldPivot
    end)
    if s2 and typeof(wp) == "CFrame" then
        return wp
    end
    local root = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model.PrimaryPart
    return root and root.CFrame or nil
end

local function CreateBossPlatforms()
    local folderName = "BossPlatformsFolder"
    local oldFolder = Workspace:FindFirstChild(folderName)
    if oldFolder then oldFolder:Destroy() end

    local folder = Instance.new("Folder")
    folder.Name = folderName
    folder.Parent = Workspace

    for _, b in ipairs(BossList) do
        local partName = "Platform_Boss_" .. b.Name:gsub("%s+", "_")
        local platform = Instance.new("Part")
        platform.Name = partName
        platform.Size = Vector3.new(16, 1, 16)
        platform.CFrame = CFrame.new(b.Pos)
        platform.Anchored = true
        platform.CanCollide = true
        platform.Material = Enum.Material.Neon
        platform.Color = Color3.fromRGB(255, 140, 0)
        platform.Transparency = 0.5
        platform.CastShadow = false
        platform.Parent = folder
    end
    
end

task.spawn(function()
    CreateBossPlatforms()
end)

local function GetBossPlatform(bossName)
    local folder = Workspace:FindFirstChild("BossPlatformsFolder")
    if not folder then return nil end
    local cleanName = "Platform_Boss_" .. bossName:gsub("%s+", "_")
    local plat = folder:FindFirstChild(cleanName)
    if plat then return plat end
    
    if bossName == "Dio_Coffin" or bossName == "Towh_coffin" or bossName == "STUTowh" then
        return folder:FindFirstChild("Platform_Boss_Dio_Coffin")
            or folder:FindFirstChild("Platform_Boss_Towh_coffin")
            or folder:FindFirstChild("Platform_Boss_STUTowh")
    end
    return nil
end

local function IsOnPlatform(platform)
    if not platform or not platform:IsA("BasePart") then return false end
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local rel = platform.CFrame:PointToObjectSpace(hrp.Position)
    local halfSize = platform.Size * 0.5

    local onX = math.abs(rel.X) <= (halfSize.X + 1.5)
    local onZ = math.abs(rel.Z) <= (halfSize.Z + 1.5)

    local onY = (rel.Y >= halfSize.Y - 1.5) and (rel.Y <= halfSize.Y + 8)

    return onX and onZ and onY
end

local function TeleportToBossPlatform(bossData)
    local char = LP.Character or LP.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart", 10)
    if not hrp or not bossData then return end

    local platform = GetBossPlatform(bossData.Name)

    if platform and IsOnPlatform(platform) then
        return
    end

    pcall(function()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.Sit = false end
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end)

    if platform then
        hrp.CFrame = platform.CFrame + Vector3.new(0, (platform.Size.Y / 2) + 3, 0)
    else
        hrp.CFrame = CFrame.new(bossData.Pos + Vector3.new(0, 3.5, 0))
    end
    
end

local MIASMA_WHITELIST = {
    ["chaka"] = true,
    ["stutowh"] = true,
    ["towh_coffin"] = true,
    ["dio_coffin"] = true,
    ["jotaro over heaven"] = true,
    ["johnnyjoestar"] = true,
    ["giorno giovanna requiem"] = true
}

local function IsMiasmaSupportedBoss(name)
    if not name then return false end
    local clean = string.lower(string.gsub(name, "^%s*(.-)%s*$", "%1"))
    return MIASMA_WHITELIST[clean] == true
end

local function CalculateBossHealthPercent(hum)
    if not hum or hum.MaxHealth <= 0 then return 0 end
    return (hum.Health / hum.MaxHealth) * 100
end

local function GetMiasmaPart()
    local map = Workspace:FindFirstChild("Map")
    local quest = map and map:FindFirstChild("MiasmaQuest")
    local miasma = nil

    if quest then
        if not originalMiasmaCFrame and quest:IsA("PVInstance") then
            originalMiasmaCFrame = quest:GetPivot()
        end

        local named = quest:FindFirstChild("Miasma")
        if named and named:IsA("BasePart") then
            miasma = named
        end

        if not miasma then
            for _, child in ipairs(quest:GetChildren()) do
                if child:IsA("BasePart") and child.PivotOffset then
                    miasma = child
                    break
                elseif child:IsA("Model") then
                    local p = child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")
                    if p and p.PivotOffset then
                        miasma = p
                        break
                    end
                end
            end
        end

        if not miasma then
            for _, desc in ipairs(quest:GetDescendants()) do
                if desc:IsA("BasePart") and (desc.Name == "Miasma" or desc.PivotOffset ~= CFrame.identity) then
                    miasma = desc
                    break
                end
            end
        end
    end

    if not miasma then
        local fallback = Workspace:FindFirstChild("Miasma", true)
        if fallback and fallback:IsA("BasePart") then
            miasma = fallback
        end
    end

    if miasma and not originalMiasmaCFrame then
        originalMiasmaCFrame = miasma:GetPivot()
    end

    return miasma
end

local function MaintainMiasmaNetwork()
    pcall(function()
        if setsimulationradius then
            setsimulationradius(1e9, 1e9)
        end
        if sethiddenproperty then
            sethiddenproperty(LP, "SimulationRadius", 1e9)
            sethiddenproperty(LP, "MaximumSimulationRadius", 1e9)
        end
        if settings and settings().Physics then
            settings().Physics.AllowSleep = false
            settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
        end
    end)
end

local function ReturnMiasmaToOrigin(miasma)
    isMiasmaAttacking = false
    if not miasma then return end

    local targetCF = originalMiasmaCFrame
    local map = Workspace:FindFirstChild("Map")
    local quest = map and map:FindFirstChild("MiasmaQuest")
    if quest and quest:IsA("PVInstance") then
        targetCF = quest:GetPivot()
        originalMiasmaCFrame = targetCF
    end

    if targetCF then
        if miasma:IsA("PVInstance") and miasma.PivotTo then
            miasma:PivotTo(targetCF)
        else
            miasma.CFrame = targetCF
        end
    end

    miasma.AssemblyLinearVelocity = Vector3.zero
    miasma.AssemblyAngularVelocity = Vector3.zero

    pcall(function()
        miasma.CanCollide = true
        miasma.Anchored = true
        miasma.Massless = false
    end)
end

local function IsWaitingForMiasma()
    if not (_G.AutoBoss and _G.BossMiasma) then return false end
    if not currentBossObj or not currentBossObj.Parent then return false end
    if not IsMiasmaSupportedBoss(currentBossObj.Name) then return false end

    local bHum = currentBossObj:FindFirstChildOfClass("Humanoid")
    if not bHum or bHum.Health <= 0 or bHum:GetState() == Enum.HumanoidStateType.Dead then 
        return false 
    end

    local hpPct = CalculateBossHealthPercent(bHum)
    local threshold = tonumber(_G.MiasmaHealthThreshold) or 20
    if hpPct <= threshold then 
        return false 
    end

    local miasma = GetMiasmaPart()
    if not miasma then 
        return false 
    end

    return true
end

local miasmaStepConn = (RunService.PreSimulation or RunService.Stepped):Connect(function()
    if _G.AutoBoss and _G.BossMiasma and isMiasmaAttacking then
        local miasma = GetMiasmaPart()
        if miasma then
            MaintainMiasmaNetwork()
            if miasma.Anchored then
                miasma.Anchored = false
            end
            miasma.CanCollide = false
            miasma.Massless = true
        end
    end
end)

RunService.Heartbeat:Connect(function(dt)
    if not (_G.AutoBoss and _G.BossMiasma) then
        if isMiasmaAttacking then
            ReturnMiasmaToOrigin(GetMiasmaPart())
        end
        return
    end

    if not currentBossObj or not currentBossObj.Parent then
        if isMiasmaAttacking then
            ReturnMiasmaToOrigin(GetMiasmaPart())
        end
        return
    end

    local bHum = currentBossObj:FindFirstChildOfClass("Humanoid")
    local bRoot = currentBossObj:FindFirstChild("HumanoidRootPart") or currentBossObj:FindFirstChild("Torso") or currentBossObj.PrimaryPart

    if not bHum or not bRoot or bHum.Health <= 0 or bHum:GetState() == Enum.HumanoidStateType.Dead then
        if isMiasmaAttacking then
            ReturnMiasmaToOrigin(GetMiasmaPart())
        end
        return
    end

    if not IsMiasmaSupportedBoss(currentBossObj.Name) then
        if isMiasmaAttacking then
            ReturnMiasmaToOrigin(GetMiasmaPart())
        end
        return
    end

    local hpPct = CalculateBossHealthPercent(bHum)
    local threshold = tonumber(_G.MiasmaHealthThreshold) or 20

    if hpPct <= threshold then
        if isMiasmaAttacking then
            ReturnMiasmaToOrigin(GetMiasmaPart())
        end
        return
    end

    local miasma = GetMiasmaPart()
    if not miasma then
        isMiasmaAttacking = false
        return
    end

    isMiasmaAttacking = true
    if miasma.Anchored then
        miasma.Anchored = false
    end
    miasma.CanCollide = false
    miasma.Massless = true

    if _G.MiasmaDirectStick then
        miasma.CFrame = bRoot.CFrame
    else
        miasmaOrbitAngle = (miasmaOrbitAngle + 7 * dt) % (2 * math.pi)
        local targetRootPos = bRoot.Position
        local attackOffset = Vector3.new(
            math.cos(miasmaOrbitAngle) * 1.8,
            0.5,
            math.sin(miasmaOrbitAngle) * 1.8
        )
        miasma.CFrame = CFrame.new(targetRootPos + attackOffset, targetRootPos)
    end

    miasma.AssemblyLinearVelocity = Vector3.new(0, 30.5, 0)
    miasma.AssemblyAngularVelocity = Vector3.new(0, 15, 0)

    if firetouchinterest and bRoot then
        firetouchinterest(miasma, bRoot, 0)
        firetouchinterest(miasma, bRoot, 1)
    end
end)

local function IsItemInList(tbl, item)
    if not tbl or not item then return false end
    if type(tbl) == "table" then
        for k, v in pairs(tbl) do
            if type(k) == "number" and v == item then
                return true
            elseif type(k) == "string" and k == item and v == true then
                return true
            end
        end
    elseif type(tbl) == "string" then
        return tbl == item
    end
    return false
end

local function IsBossTargeted(bossName)
    local sel = _G.SelectedBoss
    if not sel or sel == "All Bosses" then
        return true
    end
    if type(sel) == "string" then
        return sel == bossName
    elseif type(sel) == "table" then
        if table.find(sel, "All Bosses") or sel["All Bosses"] then
            return true
        end
        return IsItemInList(sel, bossName)
    end
    return false
end

local function FindBossByWorldPivot(bData)
    local living = Workspace:FindFirstChild("Living")
    local candidates = {}
    if living then
        for _, obj in ipairs(living:GetChildren()) do
            table.insert(candidates, obj)
        end
    end
    
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj ~= living and obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
            table.insert(candidates, obj)
        end
    end

    for _, obj in ipairs(candidates) do
        if obj:IsA("Model") and obj ~= LP.Character and not Players:GetPlayerFromCharacter(obj) then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and hum:GetState() ~= Enum.HumanoidStateType.Dead then
                local pivot = GetWorldPivot(obj)
                if pivot then
                    local nameMatch = string.find(string.lower(obj.Name), string.lower(bData.Name), 1, true)
                    local distToSpawn = (pivot.Position - bData.Pos).Magnitude
                   
                    if nameMatch then
                        return obj, pivot
                    elseif distToSpawn <= 60 and (bData.Name ~= "Dio_Coffin" and bData.Name ~= "Towh_coffin" and bData.Name ~= "STUTowh") then
                        return obj, pivot
                    end
                end
            end
        end
    end
    return nil, nil
end

local function FindAnyAliveBoss()
    for _, bData in ipairs(BossList) do
        if IsBossTargeted(bData.Name) then
            local bossObj, pivot = FindBossByWorldPivot(bData)
            if bossObj and pivot then
                return bData, bossObj, pivot
            end
        end
    end
    return nil, nil, nil
end

local function GetBestQuestData()
    local currentLvl = PlayerLevel.Value
    local chosen = QuestList[1]
    local highestReq = 0

    for _, q in ipairs(QuestList) do
        if currentLvl >= q.Level and q.Level >= highestReq then
            highestReq = q.Level
            chosen = q
        end
    end
    return chosen
end

local function SafeTeleport(targetPos, questName)
    local char = LP.Character or LP.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart", 10)
    if hrp and targetPos then
        task.wait(0.2)
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)

        hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3.5, 0))
        
    end
end

local function TeleportToCurrentFarm()
    local best = GetBestQuestData()
    if not best then return end

    local char = LP.Character or LP.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart", 10)
    if not hrp then return end

    local folder = Workspace:FindFirstChild("QuestPlatformsFolder")
    local partName = "Platform_Lv" .. best.Level .. "_" .. best.Name
    local platform = folder and folder:FindFirstChild(partName)

    if platform and IsOnPlatform(platform) then
        lastTeleportTier = best.Level
        return
    end

    pcall(function()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.Sit = false end
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end)

    if platform then
        hrp.CFrame = platform.CFrame + Vector3.new(0, (platform.Size.Y / 2) + 3, 0)
    else
        hrp.CFrame = CFrame.new(best.Pos + Vector3.new(0, 3.5, 0))
    end

    lastTeleportTier = best.Level
    
end

local function CheckAndTeleportOnce()
    if not _G.AutoTeleport then return end
    local best = GetBestQuestData()
    if best and best.Level ~= lastTeleportTier then
        TeleportToCurrentFarm() 
    end
end

task.spawn(function()
    
    pcall(function()
        local get_cons = getconnections or get_signal_cons
        if get_cons then
            for _, conn in pairs(get_cons(LP.Idled)) do
                if type(conn) == "table" or typeof(conn) == "RBXScriptConnection" then
                    if conn["Disable"] then
                        conn["Disable"](conn)
                    elseif conn["Disconnect"] then
                        conn["Disconnect"](conn)
                    end
                end
            end
        end
    end)

    LP.Idled:Connect(function()
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    end)

    while true do
        task.wait(300)
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    end
end)

RunService.Stepped:Connect(function()
    if _G.Noclip and LP.Character then
        for _, part in ipairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

local function EnableCameraNoclip()
    if not _G.CameraNoclip then return end

    local success = pcall(function()
        local Popper = LP:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("CameraModule"):WaitForChild("ZoomController"):WaitForChild("Popper")
        if getgc and debug and debug.getconstants and debug.setconstant then
            for _, v in pairs(getgc()) do
                if type(v) == "function" then
                    local s, env = pcall(getfenv, v)
                    if s and env and env.script == Popper then
                        local s2, constants = pcall(debug.getconstants, v)
                        if s2 and constants then
                            for i2, v2 in pairs(constants) do
                                if tonumber(v2) == 0.25 then
                                    debug.setconstant(v, i2, 0)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

    if not success then
        pcall(function()
            LP.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
        end)
    end
end

local function HandleQuestRemotes(questInfo)
    local map = Workspace:FindFirstChild("Map")
    local npcsFolder = map and map:FindFirstChild("NPCs")
    if not npcsFolder then return end

    local currentQuest = nil
    if type(questInfo) == "table" then
        currentQuest = questInfo
    elseif type(questInfo) == "string" then
        for _, q in ipairs(QuestList) do
            if q.Name == questInfo or q.Quest == questInfo then
                currentQuest = q
                break
            end
        end
    end
    if not currentQuest then
        currentQuest = GetBestQuestData()
    end
    if not currentQuest then return end

    for _, q in ipairs(PlayerQuests:GetChildren()) do
        local completed = q:FindFirstChild("Completed")
        if completed and completed.Value == true then
            local qData = QuestByFolder[q.Name]
            local targetNPCName = qData and qData.Name or currentQuest.Name
            local targetModel = npcsFolder:FindFirstChild(targetNPCName)
            local questDoneEvent = targetModel and targetModel:FindFirstChild("QuestDone")
            if questDoneEvent then
                questDoneEvent:FireServer()
                
            end
            task.wait(0.2)
        end
    end

    local currentNPC = npcsFolder:FindFirstChild(currentQuest.Name)
    if not currentNPC then return end

    local hasThisQuest = PlayerQuests:FindFirstChild(currentQuest.Quest) ~= nil
    if not hasThisQuest then
        local doneEvent = currentNPC:FindFirstChild("Done")
        if doneEvent then
            doneEvent:FireServer()
            
        end
        task.wait(0.2)
    end
end

local function GetCurrentTargetEnemy()
    
    if _G.AutoBoss and currentBossTarget then
        return currentBossTarget
    end

    local hasCompletedQuest = false
    for _, q in ipairs(PlayerQuests:GetChildren()) do
        local completed = q:FindFirstChild("Completed")
        if completed and completed.Value == true then
            hasCompletedQuest = true
        else
            local qInfo = QuestByFolder[q.Name]
            if qInfo then
                return qInfo.Enemy
            end
            local enemyVal = q:FindFirstChild("Enemy")
            if enemyVal and enemyVal.Value ~= "" then
                return enemyVal.Value
            end
        end
    end

    if hasCompletedQuest then
        return nil
    end

    local best = GetBestQuestData()
    return best and best.Enemy or nil
end

local function EnsureResetPlatform()
    local platformName = "ResetMobPlatform"
    local existing = Workspace:FindFirstChild(platformName)
    if existing then return existing end

    local platform = Instance.new("Part")
    platform.Name = platformName
    platform.Size = Vector3.new(15, 1, 15)
    platform.CFrame = CFrame.new(ResetPos)
    platform.Anchored = true
    platform.CanCollide = true
    platform.Material = Enum.Material.Neon
    platform.Color = Color3.fromRGB(255, 80, 80)
    platform.Transparency = 0.5
    platform.CastShadow = false
    platform.Parent = Workspace
    return platform
end

local function GetAliveTargetMobCount(targetEnemy)
    if not targetEnemy or targetEnemy == "" then return 0 end

    local char = LP.Character
    local myRoot = char and char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return 0 end

    local livingFolder = Workspace:FindFirstChild("Living")
    if not livingFolder then return 0 end

    local count = 0
    for _, obj in ipairs(livingFolder:GetChildren()) do
        if obj:IsA("Model") and obj ~= char and not Players:GetPlayerFromCharacter(obj) then
            if string.find(string.lower(obj.Name), string.lower(targetEnemy), 1, true) then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj.PrimaryPart
                               
                if hum and root and hum.Health > 0 and hum:GetState() ~= Enum.HumanoidStateType.Dead then
                    local dist = (root.Position - myRoot.Position).Magnitude
                    if dist <= BringConfig.Range then
                        count = count + 1
                    end
                end
            end
        end
    end
    return count
end

local function MaximizePhysics()
    pcall(function()
        if setsimulationradius then
            setsimulationradius(math.huge, math.huge)
        end
        if sethiddenproperty then
            sethiddenproperty(LP, "SimulationRadius", 1e9)
            sethiddenproperty(LP, "MaximumSimulationRadius", 1e9)
        end
    end)
end

task.spawn(function()
    while true do
        if (_G.AutoQuest or _G.AutoBoss) and _G.BringMob then
            MaximizePhysics()
        end
        task.wait(0.25)
    end
end)

local BroughtMobs = {}
local MobSpawnCache = {} 

local function CacheMobSpawn(obj, root)
    if not MobSpawnCache[obj] and root and root.Position.Y > -450 then
        MobSpawnCache[obj] = root.CFrame
        obj.AncestryChanged:Connect(function(_, parent)
            if not parent then
                MobSpawnCache[obj] = nil
            end
        end)
    end
end

local function RestoreMob(obj, data, isDeath)
    if not obj then return end
    pcall(function()
        local root = data.root or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj.PrimaryPart
        local hum = data.hum or obj:FindFirstChildOfClass("Humanoid")

        if data.connections then
            for _, conn in ipairs(data.connections) do
                if conn and typeof(conn) == "RBXScriptConnection" and conn.Connected then
                    conn:Disconnect()
                end
            end
            data.connections = nil
        end

        local spawnCF = MobSpawnCache[obj] or data.originalCF
        if not spawnCF and root then
            spawnCF = root.CFrame
        end

        if root and root.Parent and spawnCF then
            
            local holdBV = root:FindFirstChild("HoldBV")
            if holdBV then holdBV:Destroy() end
            local holdBG = root:FindFirstChild("HoldBG")
            if holdBG then holdBG:Destroy() end

            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            root.Velocity = Vector3.zero
            root.RotVelocity = Vector3.zero
            root.CFrame = spawnCF

            if isDeath then
                
                root.Anchored = true

                local freezeBV = root:FindFirstChild("SafeReturnBV")
                if not freezeBV then
                    freezeBV = Instance.new("BodyVelocity")
                    freezeBV.Name = "SafeReturnBV"
                    freezeBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                    freezeBV.Velocity = Vector3.zero
                    freezeBV.Parent = root
                else
                    freezeBV.Velocity = Vector3.zero
                end
               
                if hum and hum.Parent and hum.Health > 0 then
                    hum.PlatformStand = false
                    hum.Sit = false
                    hum.AutoRotate = false
                    hum.WalkSpeed = 0
                    hum.JumpPower = 0
                end

                task.spawn(function()
                    local startTime = tick()
                    while (tick() - startTime < 2.5) and obj and obj.Parent and root and root.Parent do
                        pcall(function()
                            root.CFrame = spawnCF
                            root.AssemblyLinearVelocity = Vector3.zero
                            root.AssemblyAngularVelocity = Vector3.zero
                            root.Velocity = Vector3.zero
                            root.RotVelocity = Vector3.zero
                        end)
                        task.wait(0.05)
                    end

                    pcall(function()
                        if root and root.Parent then
                            local bv = root:FindFirstChild("SafeReturnBV")
                            if bv then bv:Destroy() end
                            root.Anchored = false
                            root.AssemblyLinearVelocity = Vector3.zero
                            root.AssemblyAngularVelocity = Vector3.zero
                        end

                        if hum and hum.Parent and hum.Health > 0 then
                            hum.WalkSpeed = data.origWalkSpeed or 16
                            hum.JumpPower = data.origJumpPower or 50
                            hum.AutoRotate = true
                            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                        end
                    end)
                end)
            end
        end

        if not isDeath and hum and hum.Parent and hum.Health > 0 then
            hum.PlatformStand = false
            hum.Sit = false
            hum.AutoRotate = true
            hum.WalkSpeed = data.origWalkSpeed or 16
            hum.JumpPower = data.origJumpPower or 50

            hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end

        if data.partCollisions then
            for part, coll in pairs(data.partCollisions) do
                if part and part.Parent and part:IsA("BasePart") then
                    part.CanCollide = coll.CanCollide
                    part.CanTouch = coll.CanTouch
                end
            end
        else
            for _, part in ipairs(obj:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                    part.CanTouch = true
                end
            end
        end

        obj:SetAttribute("Optimized", nil)
        obj:SetAttribute("MAttackTitanActive", nil)
        obj:SetAttribute("RagdollBound", nil)
    end)
end

local function ResetAllBroughtMobs(isDeath)
    for obj, data in pairs(BroughtMobs) do
        RestoreMob(obj, data, isDeath)
    end
    table.clear(BroughtMobs)
end

local function OptimizeMob(obj, hum, root, connList)
    pcall(function()
        obj:SetAttribute("MAttackTitanActive", true)
        obj:SetAttribute("RagdollBound", true)

        hum.PlatformStand = false
        hum.Sit = false
        hum.AutoRotate = false
        hum.WalkSpeed = 0
        hum.JumpPower = 0

        hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)

        local c1 = hum:GetPropertyChangedSignal("PlatformStand"):Connect(function()
            if hum.PlatformStand then hum.PlatformStand = false end
        end)
        local c2 = hum:GetPropertyChangedSignal("Sit"):Connect(function()
            if hum.Sit then hum.Sit = false end
        end)
        local c3 = hum.StateChanged:Connect(function(_, newState)
            if newState == Enum.HumanoidStateType.Ragdoll 
            or newState == Enum.HumanoidStateType.FallingDown 
            or newState == Enum.HumanoidStateType.Physics 
            or newState == Enum.HumanoidStateType.PlatformStanding then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)

        if connList then
            table.insert(connList, c1)
            table.insert(connList, c2)
            table.insert(connList, c3)
        end

        local function bindMotor(desc)
            if not desc:IsA("Motor6D") then return end
            local origPart0 = desc.Part0
            local origPart1 = desc.Part1
            desc.Enabled = true
            
            if not desc:GetAttribute("LockBound") then
                desc:SetAttribute("LockBound", true)
                local mConn1 = desc:GetPropertyChangedSignal("Enabled"):Connect(function()
                    if not desc.Enabled then desc.Enabled = true end
                end)
                local mConn2 = desc:GetPropertyChangedSignal("Part1"):Connect(function()
                    if desc.Part1 == nil and origPart1 and origPart1.Parent then
                        desc.Part1 = origPart1
                    end
                end)
                if connList then
                    table.insert(connList, mConn1)
                    table.insert(connList, mConn2)
                end
            end
        end

        for _, desc in ipairs(obj:GetDescendants()) do
            if desc:IsA("Motor6D") then
                bindMotor(desc)
            elseif desc:IsA("BallSocketConstraint") or (desc:IsA("Constraint") and string.find(desc.Name, "Ragdoll", 1, true)) then
                desc.Enabled = false
                pcall(function() desc:Destroy() end)
            end
        end

        local constraintsFolder = obj:FindFirstChild("RagdollConstraints")
        if constraintsFolder then constraintsFolder:Destroy() end

        local c4 = obj.ChildAdded:Connect(function(child)
            if child.Name == "RagdollConstraints" then
                task.defer(function() child:Destroy() end)
            end
        end)

        local c5 = obj.DescendantAdded:Connect(function(desc)
            if desc:IsA("BallSocketConstraint") or (desc:IsA("Constraint") and string.find(desc.Name, "Ragdoll", 1, true)) then
                task.defer(function() desc:Destroy() end)
            elseif desc:IsA("Motor6D") then
                bindMotor(desc)
            end
        end)

        if connList then
            table.insert(connList, c4)
            table.insert(connList, c5)
        end

        if sethiddenproperty then
            sethiddenproperty(root, "NetworkIsSleeping", false)
        end
    end)
end

local function DisableCollisions(obj)
    for _, part in ipairs(obj:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.CanTouch = false
        end
    end
end

local function GetTargetMobCandidates(targetEnemy)
    if not targetEnemy or targetEnemy == "" then return {} end
    local char = LP.Character
    local candidates = {}
    local livingFolder = Workspace:FindFirstChild("Living")

    if livingFolder then
        for _, obj in ipairs(livingFolder:GetChildren()) do
            if obj:IsA("Model") and obj ~= char and not Players:GetPlayerFromCharacter(obj) then
                if string.find(string.lower(obj.Name), string.lower(targetEnemy), 1, true) then
                    table.insert(candidates, obj)
                end
            end
        end
    end

    if #candidates == 0 then
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj ~= livingFolder and obj:IsA("Model") and obj ~= char and not Players:GetPlayerFromCharacter(obj) then
                if string.find(string.lower(obj.Name), string.lower(targetEnemy), 1, true) then
                    table.insert(candidates, obj)
                end
            end
        end
    end

    return candidates
end

local HoverConfig = {
    DistanceBelow = 8.0, 
    Enabled = true
}

local hoverTarget = nil
local isHoverFarming = false

local function CanBringMob(rootPart)
    if not rootPart or rootPart.Anchored then 
        return false 
    end
    if isnetworkowner then
        local ok, isOwner = pcall(isnetworkowner, rootPart)
        if ok and isOwner == false then
            return false
        end
    end
    return true
end

local function StopHoverFarm()
    hoverTarget = nil
    isHoverFarming = false
    
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local bv = hrp:FindFirstChild("HoverFarmBV")
        if bv then bv:Destroy() end
        local bg = hrp:FindFirstChild("HoverFarmBG")
        if bg then bg:Destroy() end
        
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
    end
end

local function StopBossLegit()
    isBossLegitHovering = false
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local bv = hrp:FindFirstChild("BossLegitBV")
        if bv then bv:Destroy() end
        local bg = hrp:FindFirstChild("BossLegitBG")
        if bg then bg:Destroy() end
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
    end
end

RunService.Heartbeat:Connect(function()
    
    if not _G.AutoBoss or string.lower(_G.BossFarmMode or "bring") ~= "legit" or IsWaitingForMiasma() then
        if isBossLegitHovering then
            StopBossLegit()
        end
        return
    end

    if not currentBossObj or not currentBossObj.Parent then
        if isBossLegitHovering then
            StopBossLegit()
        end
        return
    end

    local char = LP.Character
    local myHrp = char and char:FindFirstChild("HumanoidRootPart")
    local myHum = char and char:FindFirstChildOfClass("Humanoid")
    if not myHrp or not myHum or myHum.Health <= 0 then
        if isBossLegitHovering then
            StopBossLegit()
        end
        return
    end

    local bHum = currentBossObj:FindFirstChildOfClass("Humanoid")
    local bRoot = currentBossObj:FindFirstChild("HumanoidRootPart") or currentBossObj:FindFirstChild("Torso") or currentBossObj.PrimaryPart
    if not bHum or not bRoot or bHum.Health <= 0 or bHum:GetState() == Enum.HumanoidStateType.Dead then
        if isBossLegitHovering then
            StopBossLegit()
        end
        return
    end

    isBossLegitHovering = true
    myHum.PlatformStand = false
    myHum.Sit = false
    myHrp.AssemblyLinearVelocity = Vector3.zero
    myHrp.AssemblyAngularVelocity = Vector3.zero

    local bv = myHrp:FindFirstChild("BossLegitBV")
    if not bv then
        bv = Instance.new("BodyVelocity")
        bv.Name = "BossLegitBV"
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.zero
        bv.Parent = myHrp
    else
        bv.Velocity = Vector3.zero
    end

    local bg = myHrp:FindFirstChild("BossLegitBG")
    if not bg then
        bg = Instance.new("BodyGyro")
        bg.Name = "BossLegitBG"
        bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        bg.P = 15000
        bg.Parent = myHrp
    end

    local modePos = string.lower(_G.BossLegitPos or "above")
    local dist = tonumber(_G.BossLegitDistance) or 6
    local targetPos

    if modePos == "above" then
        targetPos = bRoot.Position + Vector3.new(0, dist, 0)
    elseif modePos == "behind" then
        local look = Vector3.new(bRoot.CFrame.LookVector.X, 0, bRoot.CFrame.LookVector.Z)
        if look.Magnitude > 0 then look = look.Unit else look = Vector3.new(0, 0, -1) end
        targetPos = bRoot.Position - (look * dist) + Vector3.new(0, 1)
    elseif modePos == "below" then
        targetPos = bRoot.Position - Vector3.new(0, dist, 0)
    else
        targetPos = bRoot.Position + Vector3.new(0, dist, 0)
    end

    local targetCF = CFrame.lookAt(targetPos, bRoot.Position)
    myHrp.CFrame = targetCF
    bg.CFrame = targetCF
end)

RunService.Heartbeat:Connect(function()
    if not isHoverFarming or not hoverTarget or not hoverTarget.Parent then
        return
    end

    local char = LP.Character
    local myHrp = char and char:FindFirstChild("HumanoidRootPart")
    local myHum = char and char:FindFirstChildOfClass("Humanoid")
    if not myHrp or not myHum or myHum.Health <= 0 then
        StopHoverFarm()
        return
    end

    local tHum = hoverTarget:FindFirstChildOfClass("Humanoid")
    local tRoot = hoverTarget:FindFirstChild("HumanoidRootPart") or hoverTarget:FindFirstChild("Torso") or hoverTarget.PrimaryPart

    if not tHum or not tRoot or tHum.Health <= 0 or tHum:GetState() == Enum.HumanoidStateType.Dead then
        StopHoverFarm()
        return
    end

    myHum.PlatformStand = false
    myHum.Sit = false

    myHrp.AssemblyLinearVelocity = Vector3.zero
    myHrp.AssemblyAngularVelocity = Vector3.zero

    local bv = myHrp:FindFirstChild("HoverFarmBV")
    if not bv then
        bv = Instance.new("BodyVelocity")
        bv.Name = "HoverFarmBV"
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.zero
        bv.Parent = myHrp
    else
        bv.Velocity = Vector3.zero
    end

    local bg = myHrp:FindFirstChild("HoverFarmBG")
    if not bg then
        bg = Instance.new("BodyGyro")
        bg.Name = "HoverFarmBG"
        bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        bg.P = 15000
        bg.Parent = myHrp
    end

    local targetPos = tRoot.Position - Vector3.new(0, HoverConfig.DistanceBelow, 0)
    local targetCF = CFrame.lookAt(targetPos, tRoot.Position)

    myHrp.CFrame = targetCF
    bg.CFrame = targetCF
end)

local simConnection = RunService.PreSimulation or RunService.Stepped
simConnection:Connect(function()
    local char = LP.Character
    local myHum = char and char:FindFirstChildOfClass("Humanoid")
    local myRoot = char and char:FindFirstChild("HumanoidRootPart")
    
    local isAlive = myHum and myHum.Health > 0 and myHum:GetState() ~= Enum.HumanoidStateType.Dead

    local isFallingToVoid = false
    if myRoot and isAlive then
        if myRoot.AssemblyLinearVelocity.Y < -65 and myHum:GetState() == Enum.HumanoidStateType.Freefall then
            isFallingToVoid = true
        end
    end

    if not ((_G.AutoQuest or _G.AutoBoss) and _G.BringMob) or not isAlive or isFallingToVoid or IsWaitingForMiasma() then
        if next(BroughtMobs) ~= nil then
            ResetAllBroughtMobs(true)
        end
        if isHoverFarming then
            StopHoverFarm()
        end
        return
    end

    if isResettingMob then 
        if isHoverFarming then StopHoverFarm() end
        return 
    end 

    if not myRoot then return end

    local targetEnemy = GetCurrentTargetEnemy()
    if not targetEnemy then 
        if next(BroughtMobs) ~= nil then ResetAllBroughtMobs(false) end
        if isHoverFarming then StopHoverFarm() end
        return 
    end

    local candidates = GetTargetMobCandidates(targetEnemy)
    if #candidates == 0 then 
        if isHoverFarming then StopHoverFarm() end
        return 
    end

    local forwardPos = myRoot.Position + (myRoot.CFrame.LookVector * BringConfig.DistanceOffset)
    local targetPos = Vector3.new(forwardPos.X, myRoot.Position.Y + BringConfig.HeightOffset, forwardPos.Z)
    local targetCF = CFrame.lookAt(targetPos, targetPos + myRoot.CFrame.LookVector)

    local count = 0
    local maxRange = _G.AutoBoss and 200 or BringConfig.Range 
    local currentBroughtThisFrame = {}

    for _, obj in ipairs(candidates) do
        if count >= (_G.AutoBoss and 1 or BringConfig.MaxMobs) then break end

        local hum = obj:FindFirstChildOfClass("Humanoid")
        local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj.PrimaryPart
        
        if hum and root and hum.Health > 0 and hum:GetState() ~= Enum.HumanoidStateType.Dead and (_G.AutoBoss or root.Position.Y > -200) then
            
            CacheMobSpawn(obj, root)

            local dist = (root.Position - myRoot.Position).Magnitude
            if dist <= maxRange then
                if not CanBringMob(root) then
                    if next(BroughtMobs) ~= nil then
                        ResetAllBroughtMobs(false)
                    end
                    hoverTarget = obj
                    isHoverFarming = true
                    return 
                end
                
                if isHoverFarming then
                    StopHoverFarm()
                end

                count = count + 1
                currentBroughtThisFrame[obj] = true

                if not BroughtMobs[obj] then
                    local partColls = {}
                    for _, part in ipairs(obj:GetDescendants()) do
                        if part:IsA("BasePart") then
                            partColls[part] = {
                                CanCollide = part.CanCollide,
                                CanTouch = part.CanTouch
                            }
                        end
                    end

                    BroughtMobs[obj] = {
                        root = root,
                        hum = hum,
                        originalCF = MobSpawnCache[obj] or root.CFrame,
                        origWalkSpeed = (hum.WalkSpeed and hum.WalkSpeed > 0) and hum.WalkSpeed or 16,
                        origJumpPower = (hum.JumpPower and hum.JumpPower > 0) and hum.JumpPower or 50,
                        partCollisions = partColls,
                        connections = {}
                    }
                end
                
                DisableCollisions(obj)
             
                if not obj:GetAttribute("Optimized") then
                    obj:SetAttribute("Optimized", true)
                    OptimizeMob(obj, hum, root, BroughtMobs[obj] and BroughtMobs[obj].connections)
                end

                local rf = obj:FindFirstChild("RagdollConstraints")
                if rf then rf:Destroy() end

                if hum.PlatformStand then hum.PlatformStand = false end
                if hum.Sit then hum.Sit = false end
                local humState = hum:GetState()
                if humState == Enum.HumanoidStateType.Ragdoll 
                or humState == Enum.HumanoidStateType.FallingDown 
                or humState == Enum.HumanoidStateType.Physics 
                or humState == Enum.HumanoidStateType.PlatformStanding then
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end

                for _, part in ipairs(obj:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.AssemblyLinearVelocity = Vector3.zero
                        part.AssemblyAngularVelocity = Vector3.zero
                        part.Velocity = Vector3.zero
                        part.RotVelocity = Vector3.zero
                    elseif (part:IsA("BodyVelocity") or part:IsA("LinearVelocity") or part:IsA("VectorForce")) and part.Name ~= "HoldBV" then
                        part:Destroy()
                    elseif (part:IsA("BodyGyro") or part:IsA("BodyPosition") or part:IsA("AlignPosition")) and part.Name ~= "HoldBG" then
                        part:Destroy()
                    end
                end

                local holdBV = root:FindFirstChild("HoldBV")
                if not holdBV then
                    holdBV = Instance.new("BodyVelocity")
                    holdBV.Name = "HoldBV"
                    holdBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                    holdBV.Velocity = Vector3.zero
                    holdBV.Parent = root
                else
                    holdBV.Velocity = Vector3.zero
                end

                root.CFrame = targetCF
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                root.Velocity = Vector3.zero
                root.RotVelocity = Vector3.zero
            end
        end
    end

    for mobObj, mobData in pairs(BroughtMobs) do
        if not mobObj.Parent or not mobData.hum or mobData.hum.Health <= 0 or mobData.hum:GetState() == Enum.HumanoidStateType.Dead then
            BroughtMobs[mobObj] = nil
        elseif not currentBroughtThisFrame[mobObj] then
            RestoreMob(mobObj, mobData)
            BroughtMobs[mobObj] = nil
        end
    end
end)

local SkillCooldowns = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoolDownEvent = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("CoolDownGUI")

task.spawn(function()
    pcall(function()
        local RagdollHandler = require(ReplicatedStorage:WaitForChild("RagdollHandler", 5))
        if RagdollHandler and type(RagdollHandler) == "table" then
            local dummyFunc = function() end
            
            RagdollHandler.setRagdollEnabled = dummyFunc
            RagdollHandler.startTrueInfiniteSpin = dummyFunc
            RagdollHandler.serverRagdollForDuration = dummyFunc
            
            if hookfunction then
                pcall(hookfunction, RagdollHandler.setRagdollEnabled, dummyFunc)
                pcall(hookfunction, RagdollHandler.startTrueInfiniteSpin, dummyFunc)
                pcall(hookfunction, RagdollHandler.serverRagdollForDuration, dummyFunc)
            end
        end
    end)
end)

if CoolDownEvent then
    CoolDownEvent.OnClientEvent:Connect(function(skillName, duration)
        if type(duration) == "number" and duration > 0 then
            SkillCooldowns[skillName] = tick() + duration
        elseif duration == "Clear" then
            SkillCooldowns[skillName] = 0
        elseif duration == "ClearAll" then
            table.clear(SkillCooldowns)
        end
    end)
end

local function IsTargetMobBrought()
if IsWaitingForMiasma() then return false end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    if _G.AutoBoss and string.lower(_G.BossFarmMode or "") == "legit" and currentBossObj and currentBossObj.Parent then
        local bHum = currentBossObj:FindFirstChildOfClass("Humanoid")
        local bRoot = currentBossObj:FindFirstChild("HumanoidRootPart") or currentBossObj:FindFirstChild("Torso") or currentBossObj.PrimaryPart
        if bHum and bRoot and bHum.Health > 0 and bHum:GetState() ~= Enum.HumanoidStateType.Dead then
            local maxRange = math.max(15, (tonumber(_G.BossLegitDistance) or 6) + 6)
            if (bRoot.Position - root.Position).Magnitude <= maxRange then
                return true
            end
        end
    end

    if isHoverFarming and hoverTarget and hoverTarget.Parent then
        local mobHum = hoverTarget:FindFirstChildOfClass("Humanoid")
        local mobRoot = hoverTarget:FindFirstChild("HumanoidRootPart") or hoverTarget:FindFirstChild("Torso") or hoverTarget.PrimaryPart
        if mobHum and mobRoot and mobHum.Health > 0 and mobHum:GetState() ~= Enum.HumanoidStateType.Dead then
            if (mobRoot.Position - root.Position).Magnitude <= (HoverConfig.DistanceBelow + 4) then
                return true
            end
        end
    end

    local targetEnemy = GetCurrentTargetEnemy()
    if not targetEnemy then return false end

    local candidates = GetTargetMobCandidates(targetEnemy)
    for _, obj in ipairs(candidates) do
        local mobHum = obj:FindFirstChildOfClass("Humanoid")
        local mobRoot = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj.PrimaryPart
        
        if mobHum and mobRoot and mobHum.Health > 0 and mobHum:GetState() ~= Enum.HumanoidStateType.Dead then
            if (mobRoot.Position - root.Position).Magnitude <= (BringConfig.DistanceOffset + 5) then
                return true
            end
        end
    end
    return false
end

local function ExecuteSkills(skillList)
    local char = LP.Character
    if not char then return end

    local standEvents = char:FindFirstChild("StandEvents")
    if not standEvents then return end

    local skillsToUse = {}
    if type(skillList) == "table" then
        for k, v in pairs(skillList) do
            if type(k) == "number" then
                table.insert(skillsToUse, v)
            elseif type(k) == "string" and v == true then
                table.insert(skillsToUse, k)
            end
        end
    end

    local currentTime = tick()
    for _, skillName in ipairs(skillsToUse) do
        local cooldownExp = SkillCooldowns[skillName] or 0
        if currentTime >= cooldownExp then
            local remote = standEvents:FindFirstChild(skillName)
            if remote and remote:IsA("RemoteEvent") then
                if skillName == "Barrage" then
                    remote:FireServer(true)
                else
                    remote:FireServer()
                end
                
                SkillCooldowns[skillName] = currentTime + 0.3
                task.wait(0.05)
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.1)
        if (_G.AutoQuest or _G.AutoBoss) and _G.AutoSkill and not isResettingMob then
            if IsTargetMobBrought() then
                ExecuteSkills(getgenv().SelectedFarmSkills)
            end
        end
    end
end)

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local lastSummonTime = 0

local function isAutoSummonEnabled()
    if Library and Library.Flags and Library.Flags["Toggle_AutoSummonStand"] ~= nil then
        return Library.Flags["Toggle_AutoSummonStand"]
    end
    return _G.AutoSummon == true
end

local function getStandModel(char)
    if not char then return nil end

    local standData = LP:FindFirstChild("Data") and LP.Data:FindFirstChild("Stand")
    local standName = standData and standData.Value

    if standName and standName ~= "None" and standName ~= "" then
        local direct = char:FindFirstChild(standName)
        if direct and direct:IsA("Model") then
            return direct
        end
        if CodenameToDisplay and CodenameToDisplay[standName] then
            local directDisp = char:FindFirstChild(CodenameToDisplay[standName])
            if directDisp and directDisp:IsA("Model") then
                return directDisp
            end
        end
    end

    local namedStand = char:FindFirstChild("Stand")
    if namedStand and namedStand:IsA("Model") then
        return namedStand
    end

    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Model") and not child:IsA("Accessory") and child ~= char then
            if child:FindFirstChild("HumanoidRootPart") or child:FindFirstChild("Head") or child:FindFirstChild("Torso") or child:FindFirstChild("RightUpperArm") then
                return child
            end
        end
    end

    return nil
end

local function isStandActive(char)
    local standModel = getStandModel(char)
    if not standModel then
        return false
    end

    for _, desc in ipairs(standModel:GetDescendants()) do
        if desc:IsA("BasePart") then
            if desc.Name ~= "HumanoidRootPart" 
               and desc.Name ~= "TrailPart" 
               and desc.Name ~= "CamSubject" 
               and desc.Name ~= "PosPart" 
               and desc.Name ~= "LTPart" then
                
                if desc.Transparency < 0.8 then
                    return true
                end
            end
        elseif desc:IsA("ParticleEmitter") then
            if (desc.Name == "Aura" or desc.Name == "Custom" or desc:GetAttribute("StandIdleVFX") == true) and desc.Enabled then
                return true
            end
        end
    end

    return false
end

local function fireSummon(char)
    if not char then return false end
    local standEvents = char:FindFirstChild("StandEvents")
    local summonEvent = standEvents and standEvents:FindFirstChild("Summon")
    if summonEvent and summonEvent:IsA("RemoteEvent") then
        summonEvent:FireServer()
        return true
    end
    return false
end

task.spawn(function()
    while true do
        task.wait(0.3)

        if isAutoSummonEnabled() then
            _G.AutoSummon = true 
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local standVal = LP:FindFirstChild("Data") and LP.Data:FindFirstChild("Stand") and LP.Data.Stand.Value

            if char and hum and hum.Health > 0 and standVal and standVal ~= "None" and standVal ~= "" then
                if not isStandActive(char) then
                    if (tick() - lastSummonTime) >= 1.2 then
                        if fireSummon(char) then
                            lastSummonTime = tick()
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    CreateQuestPlatforms()
end)

PlayerLevel:GetPropertyChangedSignal("Value"):Connect(function()
    CheckAndTeleportOnce()
end)

local function BindCharacterDeath(char)
    if not char then return end
    local hum = char:WaitForChild("Humanoid", 10)
    
    local function handleInstantDeath()
        ResetAllBroughtMobs(true)
        if isHoverFarming then
            StopHoverFarm()
        end
        StopBossLegit() 
        ReturnMiasmaToOrigin(GetMiasmaPart()) 
    end

    if hum then
        
        hum.Died:Connect(handleInstantDeath)
        
        hum:GetPropertyChangedSignal("Health"):Connect(function()
            if hum.Health <= 0 then
                handleInstantDeath()
            end
        end)
        
        hum.StateChanged:Connect(function(_, newState)
            if newState == Enum.HumanoidStateType.Dead then
                handleInstantDeath()
            end
        end)
    end

    char.AncestryChanged:Connect(function(_, parent)
        if not parent then
            handleInstantDeath()
        end
    end)
end

if LP.Character then
    task.spawn(BindCharacterDeath, LP.Character)
end

LP.CharacterAdded:Connect(function(char)
    lastSummonTime = 0 
    ResetAllBroughtMobs(true)
    task.spawn(BindCharacterDeath, char)

    task.wait(1.5)
    if _G.AutoTeleport then
        local best = GetBestQuestData()
        if best then
            SafeTeleport(best.Pos, best.Name)
        end
    elseif _G.AutoBoss and currentBossData then
        TeleportToBossPlatform(currentBossData)
    end
end)

task.spawn(function()
    while true do
        if _G.AutoQuest then
            local best = GetBestQuestData()
            if best then
                HandleQuestRemotes(best)
                                
                if _G.AutoTeleport and not isResettingMob and not isHoverFarming then
                    TeleportToCurrentFarm()
                end
            end
        end
        task.wait(0.5)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.5)

        if _G.AutoQuest and _G.AutoResetMob and not isResettingMob then
            local targetEnemy = GetCurrentTargetEnemy()

            if targetEnemy then
                local aliveCount = GetAliveTargetMobCount(targetEnemy)
                
                if aliveCount == 0 then
                    local char = LP.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")

                    if hrp then
                        isResettingMob = true
                        

                        EnsureResetPlatform()

                        local savedCFrame = hrp.CFrame

                        pcall(function()
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            hrp.AssemblyAngularVelocity = Vector3.zero
                        end)
                        hrp.CFrame = CFrame.new(ResetPos + Vector3.new(0, 3.5, 0))
                        
                        task.wait(0.5)

                        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                            local returnHrp = LP.Character.HumanoidRootPart
                            pcall(function()
                                returnHrp.AssemblyLinearVelocity = Vector3.zero
                                returnHrp.AssemblyAngularVelocity = Vector3.zero
                            end)
                            returnHrp.CFrame = savedCFrame
                            
                        end
                        
                        task.wait(0.5)
                        isResettingMob = false
                    end
                end
            end
        end
    end
end)

local BossStatusLabel = nil

task.spawn(function()
    while true do
        task.wait(0.4)

        if _G.AutoBoss then
            local bData, bossObj, pivot = FindAnyAliveBoss()

            if bData and bossObj then
                currentBossData = bData
                currentBossTarget = bData.Name 
                currentBossObj = bossObj

                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local platform = GetBossPlatform(bData.Name)
                
                if BossStatusLabel then
                    BossStatusLabel:SetText("Boss: " .. bData.Name)
                    if IsWaitingForMiasma() then
                        local bHum = bossObj:FindFirstChildOfClass("Humanoid")
                        local hpPct = bHum and CalculateBossHealthPercent(bHum) or 100
                        BossStatusLabel:SetRightText(string.format("Miasma (%.0f%% -> %d%%)", hpPct, _G.MiasmaHealthThreshold or 20))
                    else
                        BossStatusLabel:SetRightText("fighting (" .. tostring(_G.BossFarmMode) .. ")")
                    end
                end
                              
                if hrp and not isTeleportingBoss and not isHoverFarming then
                    
                    if string.lower(_G.BossFarmMode or "bring") == "bring" or IsWaitingForMiasma() then
                        local isStandingOnBossPart = platform and IsOnPlatform(platform)
                        if not isStandingOnBossPart then
                            isTeleportingBoss = true
                            TeleportToBossPlatform(bData)
                            task.wait(0.6)
                            isTeleportingBoss = false
                        end
                    else
                        
                        local bRoot = bossObj:FindFirstChild("HumanoidRootPart") or bossObj:FindFirstChild("Torso") or bossObj.PrimaryPart
                        if bRoot and (bRoot.Position - hrp.Position).Magnitude > 70 then
                            pcall(function()
                                hrp.AssemblyLinearVelocity = Vector3.zero
                                hrp.AssemblyAngularVelocity = Vector3.zero
                                hrp.CFrame = bRoot.CFrame + Vector3.new(0, 5, 0)
                            end)
                        end
                    end
                end
            else
                currentBossData = nil
                currentBossTarget = nil
                currentBossObj = nil
                StopBossLegit()
                if BossStatusLabel then
                    BossStatusLabel:SetText("Boss: scanning...")
                    BossStatusLabel:SetRightText("Waiting for boss to spawn")
                end
            end
        else
            currentBossData = nil
            currentBossTarget = nil
            currentBossObj = nil
            StopBossLegit()
            if BossStatusLabel then
                BossStatusLabel:SetText("Boss: disabling")
                BossStatusLabel:SetRightText("Off")
            end
        end
    end
end)

Section:Toggle({
    Name = "auto farm lv",
    Default = false,
    Flag = "Toggle_AutoQuest",
    Callback = function(Value)
        _G.AutoQuest    = Value
        _G.AutoTeleport = Value
        _G.Noclip       = Value
        _G.CameraNoclip = Value       
        _G.BringMob     = Value  

        if Value then            
            task.spawn(EnableCameraNoclip)
                        
            task.spawn(function()
                TeleportToCurrentFarm()
            end)
        else
            ResetAllBroughtMobs()
            StopHoverFarm()
            lastTeleportTier = nil
            pcall(function()
                LP.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
            end)
        end
    end
})

Section:Slider({
    Name = "Bring Distance",
    Min = 1,
    Max = 10,
    Default = BringConfig.DistanceOffset, 
    Step = 1,
    Decimals = 0,
    Suffix = " studs",
    Flag = "Slider_BringDistance",
    Callback = function(Value)
        BringConfig.DistanceOffset = Value
    end
})

Section:Toggle({
    Name = "auto reset mob",
    Default = true,
    Flag = "Toggle_AutoResetMob",
    Callback = function(Value)
        _G.AutoResetMob = Value
    end
})

Section:Toggle({
    Name = "auto summon stand",
    Default = true,
    Flag = "Toggle_AutoSummonStand",
    Callback = function(Value)
        _G.AutoSummon = Value
        if Value then
            lastSummonTime = 0 
        end
    end
})

Section:Toggle({
    Name = "auto skill",
    Default = true,
    Flag = "Toggle_AutoSkill",
    Callback = function(Value)
        _G.AutoSkill = Value
    end
})

local SkillDropdown = Section:Dropdown({
    Name = "skill",
    Options = {"M1", "Heavy", "Barrage"},
    Default = {"M1", "Heavy", "Barrage"},
    Multi = true,
    Search = true,
    Flag = "Dropdown_FarmSkills",
    Callback = function(Selected)
        getgenv().SelectedFarmSkills = Selected
    end
})

Section:Button({
    Name = "refresh",
    Icon = "rotate-cw",
    Callback = function()
        local skills = {"M1", "Heavy", "Barrage"}
        local char = LP.Character
        if char then
            local standEvents = char:FindFirstChild("StandEvents")
            if standEvents then
                for _, remote in ipairs(standEvents:GetChildren()) do
                    if remote:IsA("RemoteEvent") and not table.find(skills, remote.Name) then
                        table.insert(skills, remote.Name)
                    end
                end
            end
        end

        SkillDropdown:Refresh(skills, false)
        
        Library:Notification({
            Name = "success",
            Description = "refreshed",
            Duration = 3,
            Type = "Success"
        })
    end
})

_G.AutoPromptHolder = false
local activeHolders = {}
local addedConnection = nil

local function isCharacterAlive()
    local char = LP.Character
    if not char or not char.Parent then return false end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local rootPart = char:FindFirstChild("HumanoidRootPart")

    return humanoid and humanoid.Health > 0 and rootPart ~= nil
end

local function registerHolder(obj)
    if obj:IsA("BasePart") and obj.Name == "ItemPromptHolder" then
        if not table.find(activeHolders, obj) then
            table.insert(activeHolders, obj)
        end
    end
end

local function handlePrompt(part, prompt)
    if not isCharacterAlive() then return end

    pcall(function()
        local character = LP.Character
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end

        
        character:PivotTo(part:GetPivot() + Vector3.new(0, 1.5, 0))

        task.wait(0.08)

        if not isCharacterAlive() then return end

        if prompt and prompt.Parent and prompt.Enabled then
            local originalHold = prompt.HoldDuration
            prompt.HoldDuration = 0

            if typeof(fireproximityprompt) == "function" then
                fireproximityprompt(prompt)
            else
                prompt:InputHoldBegin()
                task.wait()
                prompt:InputHoldEnd()
            end

            prompt.HoldDuration = originalHold
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(0.2)
        if _G.AutoPromptHolder then
            if not isCharacterAlive() then
                LP.CharacterAdded:Wait()
                task.wait(0.5)
            end

            for i = #activeHolders, 1, -1 do
                if not _G.AutoPromptHolder then break end
                if not isCharacterAlive() then break end

                local part = activeHolders[i]

                
                if not part or not part.Parent then
                    table.remove(activeHolders, i)
                else
                    local prompt = part:FindFirstChildWhichIsA("ProximityPrompt")
                    if prompt and prompt.Enabled then
                        handlePrompt(part, prompt)
                        task.wait(0.12)
                    end
                end
            end
        end
    end
end)

Section:Toggle({
    Name = "auto pick up item",
    Default = false,
    Flag = "Toggle_AutoPickUpItem",
    Callback = function(Value)
        _G.AutoPromptHolder = Value
        if Value then
            
            for _, obj in ipairs(Workspace:GetDescendants()) do
                registerHolder(obj)
            end
            
            if not addedConnection then
                addedConnection = Workspace.DescendantAdded:Connect(registerHolder)
            end
            Library:Notification({
                Name = "Auto Pick Up",
                Description = "✅️",
                Duration = 3,
                Type = "Info"
            })
        else
            
            if addedConnection then
                addedConnection:Disconnect()
                addedConnection = nil
            end
            table.clear(activeHolders)
        end
    end
})

local BossSection = SubTab:Section({
    Name = "boss farm",
    Side = "Right"
})

local LegitPosDropdown
local LegitDistanceSlider

local BossModeDropdown = BossSection:Dropdown({
    Name = "mode",
    Options = {"bring", "legit"},
    Default = "bring",
    Flag = "Dropdown_BossFarmMode",
    Callback = function(Value)
        _G.BossFarmMode = Value
        local isLegit = (Value == "legit")

        if LegitPosDropdown then
            LegitPosDropdown:SetVisible(isLegit)
        end
        if LegitDistanceSlider then
            LegitDistanceSlider:SetVisible(isLegit)
        end

        if _G.AutoBoss then
            if Value == "bring" then
                StopBossLegit()
                _G.BringMob = true
            else
                ResetAllBroughtMobs(false)
                _G.BringMob = false
            end
        end
    end
})

LegitPosDropdown = BossSection:Dropdown({
    Name = "position",
    Options = {"above", "behind", "below"},
    Default = "above",
    Flag = "Dropdown_BossLegitPos",
    Callback = function(Value)
        _G.BossLegitPos = Value
    end
})

LegitDistanceSlider = BossSection:Slider({
    Name = "distance",
    Min = 1,
    Max = 10,
    Default = 6,
    Step = 1,
    Decimals = 0,
    Suffix = " studs",
    Flag = "Slider_BossLegitDistance",
    Callback = function(Value)
        _G.BossLegitDistance = Value
    end
})

task.spawn(function()
    task.wait(1) 
    local isLegit = (_G.BossFarmMode == "legit")
    if LegitPosDropdown then
        LegitPosDropdown:SetVisible(isLegit)
    end
    if LegitDistanceSlider then
        LegitDistanceSlider:SetVisible(isLegit)
    end
end)

BossSection:Toggle({
    Name = "auto farm boss",
    Default = false,
    Flag = "Toggle_AutoBoss",
    Callback = function(Value)
        _G.AutoBoss     = Value
        _G.Noclip       = Value
        _G.CameraNoclip = Value       
        
        _G.BringMob     = (string.lower(_G.BossFarmMode or "bring") == "bring") and Value or false

        if Value then
            if _G.AutoQuest then
                _G.AutoQuest = false
                if Library.Flags["Toggle_AutoQuest"] ~= nil then
                    pcall(function() Library.SetFlags["Toggle_AutoQuest"](false) end)
                end
            end
            
            task.spawn(EnableCameraNoclip)
            
            Library:Notification({
                Name = "Auto Boss",
                Description = "(" .. tostring(_G.SelectedBoss) .. " | " .. tostring(_G.BossFarmMode) .. ")",
                Duration = 3,
                Type = "Info"
            })
        else
            ResetAllBroughtMobs()
            StopHoverFarm()
            StopBossLegit()
            ReturnMiasmaToOrigin(GetMiasmaPart()) -- Thu hồi Miasma khi tắt Auto Boss
            currentBossData = nil
            currentBossTarget = nil
            currentBossObj = nil
            if not _G.AutoQuest then
                pcall(function()
                    LP.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
                end)
            end
        end
    end
})

-- [THÊM TOGGLE & SLIDER MIASMA Ở ĐÂY]
BossSection:Toggle({
    Name = "Miasma",
    Default = false,
    Flag = "Toggle_BossMiasma",
    Callback = function(Value)
        _G.BossMiasma = Value
        if not Value then
            ReturnMiasmaToOrigin(GetMiasmaPart())
        else
            Library:Notification({
                Name = "Miasma Boss",
                Description = "Đã kích hoạt hỗ trợ rút máu boss",
                Duration = 3,
                Type = "Success"
            })
        end
    end
})

BossSection:Slider({
    Name = "hp boss",
    Min = 5,
    Max = 50,
    Default = 20,
    Step = 1,
    Decimals = 0,
    Suffix = "%",
    Flag = "Slider_MiasmaThreshold",
    Callback = function(Value)
        _G.MiasmaHealthThreshold = Value
    end
})

BossSection:Dropdown({
    Name = "select boss",
    Options = {
        "All Bosses",
        "Giorno Giovanna Requiem",
        "JohnnyJoestar",
        "Jotaro Over Heaven",
        "Alternate Jotaro Part 4",
        "Dio_Coffin",
        "Towh_coffin",
        "STUTowh",
        "Chaka"
    },
    Default = "All Bosses",
    Multi = true,
    Search = true,
    Flag = "Dropdown_SelectBoss",
    Callback = function(Value)
        _G.SelectedBoss = Value
    end
})

BossStatusLabel = BossSection:Label({
    Name = "Boss: disabling",
    RightText = "Off",
    Icon = "skull"
})

-- ROLL

local StandMap = {
    ["Star Platinum OVA"] = "StarPlatinumOVA", ["Silver Chariot"] = "SilverChariot", ["Cream"] = "Cream", 
    ["Hierophant Green"] = "HG", ["Sticky Fingers"] = "StickyFingers", ["Star Platinum"] = "StarPlatinum", 
    ["Killer Queen"] = "KillerQueen", ["Aerosmith"] = "Aerosmith", ["Star Platinum Stone Ocean"] = "StarPlatinumStoneOcean", 
    ["Crazy Diamond"] = "CrazyDiamond", ["The Emperor"] = "TheEmperor", ["Stone Free"] = "StoneFree", 
    ["Soft And Wet"] = "SoftAndWet", ["Magicians's Red"] = "MR", ["Purple Smoke"] = "PurpleHaze", 
    ["White Snake"] = "WhiteSnake", ["Diver Down"] = "DiverDown", ["The World"] = "TheWorld", 
    ["Golden Experience"] = "GE", ["King Crimson"] = "KingCrimson", ["Dirty Deeds Done Dirt Cheap"] = "D4C", 
    ["Premier Macho"] = "PM", ["Silver Chariot OVA"] = "SCOVA", ["The World OVA"] = "TWOVA", 
    ["Jotaro's Star Platinum"] = "JotarosStarPlatinum", ["Weather Report"] = "WeatherReport", ["The Hand"] = "TheHand", 
    ["Tusk Act 1"] = "TA1", ["The World Alternate Universe"] = "TWAU", ["IBM"] = "IBM",  ["Dio's The World"] = "DTW", 
    ["Sol Spirit"] = "SolSpirit", ["Sol Spirit OVA"] = "SolSpiritOVA", ["shadow the universe"] = "STU", 
    ["the universe vestige"] = "TUVestige", ["The Sun"] = "Sun", ["Vanilla Ice's Cream"] = "Cream_R", 
    ["Hierophant Green OVA"] = "HGOVA", ["Magicians's Red OVA"] = "MROVA", ["Putrid Whine"] = "PutridWhine"
}

local CodenameToDisplay = {}
local StandDisplayList = {}
for dispName, codeName in pairs(StandMap) do
    CodenameToDisplay[codeName] = dispName
    table.insert(StandDisplayList, dispName)
end
table.sort(StandDisplayList)

local AttriList = {
    "Daemon", "Enrage", "Glass Cannon", "Godly", "Hacker", 
    "Invincible", "Legendary", "Lethargic", "Manic", "Powerful", 
    "Scourge", "Sloppy", "Strong", "Tough", "Tragic"
}

_G.AutoRoll = false
local RollConfig = {
    RollMode = "stand or attribute",    
    ArrowMode = "random arrow",         
    SafeDelay = 1.0,                    
    TargetStands = {},                  
    TargetAttributes = {}               
}

_G.WebhookRoll = false
_G.WebhookURL  = ""
_G.WebhookMode = "Target Only" 

local HttpService = game:GetService("HttpService")
local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

local function CountItem(itemName)
    local count = 0
    local backpack = LP:FindFirstChild("Backpack")
    local char = LP.Character

    local function checkContainer(container)
        if not container then return end
        for _, it in ipairs(container:GetChildren()) do
            if it:IsA("Tool") and it.Name == itemName then
                
                local amount = it:GetAttribute("ItemAmount")
                if type(amount) == "number" then
                    count = count + amount
                else
                    count = count + 1
                end
            end
        end
    end

    checkContainer(backpack)
    checkContainer(char)

    return count
end

local function SendRollWebhook(standName, attriName, isTarget, note)
    if not _G.WebhookRoll or not _G.WebhookURL or _G.WebhookURL == "" then return end
    if not httpRequest then 
        warn("[Webhook] executor không hỗ trợ hàm HTTP Request")
        return 
    end

    if _G.WebhookMode == "Target Only" and not isTarget then
        return
    end

    local cRoka = CountItem("Rokakaka")
    local cArrow = CountItem("Stand Arrow")
    local cCharged = CountItem("Charged Arrow")

    local title = isTarget and "[TARGET] Target found" or "[ROLL] Stand"
    local embedColor = isTarget and 0x2ECC71 or 0xE67E22 

    local fields = {
        {
            name = "player",
            value = string.format("`%s` (`%s`)", LP.Name, LP.DisplayName),
            inline = true
        },
        {
            name = "Stand",
            value = string.format("**%s**", standName or "None"),
            inline = true
        },
        {
            name = "Attribute",
            value = string.format("**%s**", (attriName and attriName ~= "") and attriName or "None"),
            inline = true
        },
        {
            name = "inventory",
            value = string.format("Roka: `%d` | S-Arrow: `%d` | C-Arrow: `%d`", cRoka, cArrow, cCharged),
            inline = false
        }
    }

    if note and note ~= "" then
        table.insert(fields, {
            name = "status",
            value = note,
            inline = false
        })
    end

    local payload = {
        username = "Auto Roll Notifier",
        avatar_url = "https://i.imgur.com/8Q5F5gD.png",
        embeds = {
            {
                title = title,
                color = embedColor,
                fields = fields,
                footer = {
                    text = "skibidi • Auto Roll"
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }
    }

    task.spawn(function()
        pcall(function()
            httpRequest({
                Url = _G.WebhookURL,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode(payload)
            })
        end)
    end)
end

local MarketplaceService = game:GetService("MarketplaceService")
local EventsFolder = ReplicatedStorage:WaitForChild("Events", 10)
local SwitchStandRemote = EventsFolder and EventsFolder:WaitForChild("SwitchStand", 10)
local ChatMessageRemote = EventsFolder and EventsFolder:FindFirstChild("ChatMessage")

_G.AutoStorage = false

local CachedGamepasses = {}
local function CheckPlayerGamepass(gpId)
    if not gpId or gpId == 0 then return false end
    if CachedGamepasses[gpId] ~= nil then return CachedGamepasses[gpId] end
    local s, owns = pcall(function()
        return MarketplaceService:UserOwnsGamePassAsync(LP.UserId, gpId)
    end)
    if s then
        CachedGamepasses[gpId] = owns
        return owns
    end
    return false
end

local function IsSlotUnlocked(slotNum)
    if slotNum == 1 or slotNum == 2 then
        return true
    elseif slotNum == 3 then
        local gp = ReplicatedStorage:FindFirstChild("Gamepasses")
        local gp1 = gp and gp:FindFirstChild("StandStorage1")
        local altGp1 = gp and gp:FindFirstChild("AltStandStorage1")
        local owns = (gp1 and CheckPlayerGamepass(gp1.Value)) or (altGp1 and CheckPlayerGamepass(altGp1.Value))
        return owns or false
    elseif slotNum == 4 then
        local lvl = LP.Data and LP.Data:FindFirstChild("Level")
        return (lvl and lvl.Value >= 120) or false
    elseif slotNum == 5 then
        local gp = ReplicatedStorage:FindFirstChild("Gamepasses")
        local gp2 = gp and gp:FindFirstChild("StandStorage2")
        return (gp2 and CheckPlayerGamepass(gp2.Value)) or false
    end
    return false
end

local function GetAvailableEmptySlots()
    local emptySlots = {}
    for i = 1, 5 do
        local slotVal = LP.Data and LP.Data:FindFirstChild("Slot" .. i .. "Stand")
        if slotVal and slotVal.Value == "None" and IsSlotUnlocked(i) then
            table.insert(emptySlots, "Slot" .. i)
        end
    end
    return emptySlots
end

local function StoreCurrentStand()
    local emptySlots = GetAvailableEmptySlots()
    if #emptySlots == 0 then
        return false, "Full"
    end

    for _, slotName in ipairs(emptySlots) do
        local switchSuccess = false
        local chatConn

        if ChatMessageRemote then
            chatConn = ChatMessageRemote.OnClientEvent:Connect(function(msg)
                if type(msg) == "string" and string.find(string.lower(msg), "switching stands") then
                    switchSuccess = true
                end
            end)
        end

        SwitchStandRemote:FireServer(slotName)

        local startCheck = tick()
        while (tick() - startCheck < 2.5) do
            if switchSuccess then break end
            task.wait(0.05)
        end

        if chatConn then chatConn:Disconnect() end

        if switchSuccess then
            print("gay")
            
            task.wait(4.0)
            
            local timeout = tick()
            while LP.Data.Stand.Value ~= "None" and (tick() - timeout < 5) do
                task.wait(0.2)
            end
                        
            if LP.Data.Stand.Value == "None" then
                return true, slotName
            else
                
                warn("gay")
                return false, "NetworkLag"
            end
        end

        task.wait(0.3)
    end

    return false, "Failed"
end

local function GetAvailableArrow()
    local hasNormal = CountItem("Stand Arrow") > 0
    local hasCharged = CountItem("Charged Arrow") > 0

    if RollConfig.ArrowMode == "Stand Arrow" then
        return hasNormal and "Stand Arrow" or nil
    elseif RollConfig.ArrowMode == "Charged Arrow" then
        return hasCharged and "Charged Arrow" or nil
    elseif RollConfig.ArrowMode == "random arrow" then
        local available = {}
        if hasNormal then table.insert(available, "Stand Arrow") end
        if hasCharged then table.insert(available, "Charged Arrow") end
        if #available > 0 then
            return available[math.random(1, #available)]
        end
    end
    return nil
end

local function EquipAndUseItem(itemName)
    local char = LP.Character or LP.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    local backpack = LP:FindFirstChild("Backpack")
    if not hum or hum.Health <= 0 or not backpack then return false end

    local tool = char:FindFirstChild(itemName) or backpack:FindFirstChild(itemName)
    if not tool then return false end

    if tool.Parent == backpack then
        hum:EquipTool(tool)
        local waitEquip = 0
        while tool.Parent ~= char and waitEquip < 1 do
            task.wait(0.05)
            waitEquip = waitEquip + 0.05
        end
    end

    task.wait(0.1)

    local useRemote = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("UseItem")
    if useRemote then
        useRemote:FireServer()
    end

    return true
end

local RollTab = Window:Tab({
    Name = "Roll",
    Icon = "refresh-cw"
})

local RollSubTab = RollTab:SubTab({
    Name = "Auto Roll",
    Icon = "sparkles"
})

local SectionSettings = RollSubTab:Section({
    Name = "settings",
    Side = "Left"
})

local Sectiontar = RollSubTab:Section({
    Name = "target",
    Side = "Right"
})

local ToggleAutoRoll

ToggleAutoRoll = SectionSettings:Toggle({
    Name = "Auto Roll",
    Default = false,
    Flag = "Toggle_AutoRollMain",
    Callback = function(Value)
        _G.AutoRoll = Value
        if Value then
            
            local hasStandTarget = false
            local hasAttriTarget = false
            for _ in pairs(RollConfig.TargetStands) do hasStandTarget = true break end
            for _ in pairs(RollConfig.TargetAttributes) do hasAttriTarget = true break end

            if RollConfig.RollMode == "stand only" and not hasStandTarget then
                _G.AutoRoll = false
                ToggleAutoRoll:Set(false)
                Library:Notification({
                    Name = "No target selected",
                    Description = "Please select at least 1 Stand",
                    Duration = 4,
                    Type = "Warning"
                })
                return
            
            elseif (RollConfig.RollMode == "attribute only" or RollConfig.RollMode == "Kars") and not hasAttriTarget then
                _G.AutoRoll = false
                ToggleAutoRoll:Set(false)
                Library:Notification({
                    Name = "No target selected",
                    Description = "Please select at least 1 Attribute",
                    Duration = 4,
                    Type = "Warning"
                })
                return
            elseif (RollConfig.RollMode == "stand and attribute" or RollConfig.RollMode == "stand or attribute") and (not hasStandTarget and not hasAttriTarget) then
                _G.AutoRoll = false
                ToggleAutoRoll:Set(false)
                Library:Notification({
                    Name = "No target selected",
                    Description = "Please select at least 1 Stand or 1 Attribute",
                    Duration = 4,
                    Type = "Warning"
                })
                return
            end

            Library:Notification({
                Name = "Auto Roll",
                Description = "Mode: " .. RollConfig.RollMode,
                Duration = 3,
                Type = "Info"
            })
        end
    end
})

SectionSettings:Toggle({
    Name = "Auto Storage",
    Default = false,
    Flag = "Toggle_AutoStorage",
    Callback = function(Value)
        _G.AutoStorage = Value
    end
})

SectionSettings:Dropdown({
    Name = "Roll Mode",
    Options = {
        "stand or attribute",
        "stand only",
        "attribute only",
        "stand and attribute",
        "Kars"
    },
    Default = "stand or attribute",
    Flag = "Dropdown_RollMode",
    Callback = function(Value)
        RollConfig.RollMode = Value
    end
})

SectionSettings:Dropdown({
    Name = "Arrow",
    Options = {
        "random arrow",
        "Stand Arrow",
        "Charged Arrow"
    },
    Default = "random arrow",
    Flag = "Dropdown_ArrowMode",
    Callback = function(Value)
        RollConfig.ArrowMode = Value
    end
})

SectionSettings:Slider({
    Name = "Safe Delay",
    Min = 0.5,
    Max = 2.0,
    Default = 1.0,
    Step = 0.1,
    Decimals = 1,
    Suffix = "s",
    Flag = "Slider_SafeDelay",
    Callback = function(Value)
        RollConfig.SafeDelay = Value
    end
})

Sectiontar:Dropdown({
    Name = "Stands",
    Options = StandDisplayList,
    Default = {},
    Multi = true,
    Search = true,
    Flag = "Dropdown_TargetStands",
    Callback = function(Selected)
        RollConfig.TargetStands = Selected
    end
})

Sectiontar:Dropdown({
    Name = "Attributes",
    Options = AttriList,
    Default = {},
    Multi = true,
    Search = true,
    Flag = "Dropdown_TargetAttributes",
    Callback = function(Selected)
        RollConfig.TargetAttributes = Selected
    end
})

local SectionWebhook = RollSubTab:Section({
    Name = "Webhook Settings",
    Side = "Left"
})

SectionWebhook:Toggle({
    Name = "Webhook",
    Default = false,
    Flag = "Toggle_RollWebhook",
    Callback = function(Value)
        _G.WebhookRoll = Value
    end
})

SectionWebhook:Dropdown({
    Name = "Webhook Mode",
    Options = {
        "Target Only",
        "Everything"
    },
    Default = "Target Only",
    Flag = "Dropdown_WebhookMode",
    Callback = function(Value)
        _G.WebhookMode = Value
    end
})

SectionWebhook:Textbox({
    Name = "Webhook URL",
    Default = "",
    Placeholder = "https://discord.com/api/webhooks/...",
    ClearOnFocus = false,
    Flag = "Textbox_WebhookURL",
    Callback = function(Value)
        _G.WebhookURL = Value
    end
})

SectionWebhook:Button({
    Name = "Test Webhook",
    Icon = "send",
    Callback = function()
        if not _G.WebhookURL or _G.WebhookURL == "" then
            Library:Notification({
                Name = "error",
                Description = "Please enter the Webhook URL first",
                Duration = 3,
                Type = "Warning"
            })
            return
        end

        local ok = pcall(function()
            local payload = {
                username = "Auto Roll Notifier",
                embeds = {
                    {
                        title = "gay",
                        description = "acc **" .. LP.Name .. "** ✅️",
                        color = 0x3498DB,
                        footer = { text = "skibidi • Test" },
                        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
                    }
                }
            }
            httpRequest({
                Url = _G.WebhookURL,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode(payload)
            })
        end)

        if ok then
            Library:Notification({
                Name = "success",
                Description = "Webhook sent",
                Duration = 3,
                Type = "Success"
            })
        else
            Library:Notification({
                Name = "failure",
                Description = "unable to send, please check the URL again",
                Duration = 4,
                Type = "Error"
            })
        end
    end
})

local LabelCurrentStand = Sectiontar:Label({
    Name = "Stand: Loading...",
    Icon = "user"
})

local LabelCurrentAttri = Sectiontar:Label({
    Name = "Attribute: Loading...",
    Icon = "shield"
})

local LabelItems = Sectiontar:Label({
    Name = "roka: 0 | s-arrow: 0 | c-arrow: 0",
    Icon = "package"
})

local function UpdateUIStatus()
    local curStandCode = LP.Data and LP.Data:FindFirstChild("Stand") and LP.Data.Stand.Value or "None"
    local curAttri = LP.Data and LP.Data:FindFirstChild("Attri") and LP.Data.Attri.Value or "None"
    local dispStand = (curStandCode == "None") and "None" or (CodenameToDisplay[curStandCode] or curStandCode)

    LabelCurrentStand:SetText("Stand: " .. dispStand)
    LabelCurrentAttri:SetText("Attribute: " .. curAttri)

    local cRoka = CountItem("Rokakaka")
    local cArrow = CountItem("Stand Arrow")
    local cCharged = CountItem("Charged Arrow")
    local cMask = CountItem("Kars Mask")
    LabelItems:SetText(string.format("roka: %d | s-arrow: %d | c-arrow: %d | kars mask: %d", cRoka, cArrow, cCharged, cMask))
end

if LP:FindFirstChild("Data") then
    if LP.Data:FindFirstChild("Stand") then
        LP.Data.Stand:GetPropertyChangedSignal("Value"):Connect(UpdateUIStatus)
    end
    if LP.Data:FindFirstChild("Attri") then
        LP.Data.Attri:GetPropertyChangedSignal("Value"):Connect(UpdateUIStatus)
    end
end
UpdateUIStatus()

task.spawn(function()
    while true do
        pcall(UpdateUIStatus)
        task.wait(1.5)
    end
end)

_G.SpecificRoll = false
local SpecificRules = {} 

local function HasAnyItem(tbl)
    if not tbl or type(tbl) ~= "table" then return false end
    for k, v in pairs(tbl) do
        if type(k) == "number" and v ~= nil and v ~= "" then
            return true
        elseif type(k) == "string" and v == true then
            return true
        end
    end
    return false
end

local function CheckSpecificMatched(curDisplayStand, curAttri)
    if not _G.SpecificRoll then return false end

    for i = 1, 20 do
        local rule = SpecificRules[i]
        if rule then
            local hasStand = HasAnyItem(rule.Stands)
            local hasAttri = HasAnyItem(rule.Attributes)

            if hasStand and hasAttri then
                
                local sMatch = IsItemInList(rule.Stands, curDisplayStand)
                local aMatch = (curAttri ~= "None" and curAttri ~= "") and IsItemInList(rule.Attributes, curAttri)
                if sMatch and aMatch then
                    return true
                end
            elseif hasStand and not hasAttri then
                
                if IsItemInList(rule.Stands, curDisplayStand) then
                    return true
                end
            elseif not hasStand and hasAttri then
                
                if curAttri ~= "None" and curAttri ~= "" and IsItemInList(rule.Attributes, curAttri) then
                    return true
                end
            end
        end
    end
    return false
end

local SpecificSubTab = RollTab:SubTab({
    Name = "Specific",
    Icon = "target"
})

local SpecificLeft = SpecificSubTab:Section({
    Name = "setting & Slot 1 - 10",
    Side = "Left"
})

local SpecificRight = SpecificSubTab:Section({
    Name = "Slot 11 - 20",
    Side = "Right"
})

SpecificLeft:Toggle({
    Name = "Specific Roll",
    Default = false,
    Flag = "Toggle_SpecificRoll",
    Callback = function(Value)
        _G.SpecificRoll = Value
    end
})

for i = 1, 20 do
    SpecificRules[i] = {
        Stands = {},
        Attributes = {}
    }

    local targetSec = (i <= 10) and SpecificLeft or SpecificRight

    targetSec:Dropdown({
        Name = string.format("Slot %d: Stand", i),
        Options = StandDisplayList,
        Default = {},
        Multi = true,
        Search = true,
        Flag = "Specific_Stand_" .. i,
        Callback = function(Selected)
            SpecificRules[i].Stands = Selected
        end
    })

    targetSec:Dropdown({
        Name = string.format("Slot %d: Attribute", i),
        Options = AttriList,
        Default = {},
        Multi = true,
        Search = true,
        Flag = "Specific_Attri_" .. i,
        Callback = function(Selected)
            SpecificRules[i].Attributes = Selected
        end
    })
end

task.spawn(function()
    local pGui = LP:WaitForChild("PlayerGui")
    while true do
        task.wait(0.2)
        if _G.AutoRoll then
            local newPromptGUI = pGui:FindFirstChild("newPromptGUI")
            if newPromptGUI and newPromptGUI:GetAttribute("ItemPromptActive") == true then
                local mainFrame = newPromptGUI:FindFirstChild("MainFrame")
                local yesBtn = mainFrame and mainFrame:FindFirstChild("YesButton")
                if yesBtn and yesBtn.Visible then
                    pcall(function()
                        local get_cons = getconnections or get_signal_cons
                        if get_cons then
                            for _, conn in pairs(get_cons(yesBtn.MouseButton1Click)) do
                                conn:Fire()
                            end
                        end
                    end)
                end
            end
        end
    end
end)

local hasNotifiedThisStand = false

task.spawn(function()
    while true do
        task.wait(0.1)

        if _G.AutoRoll then
            local curStandCode = LP.Data.Stand.Value
            local curAttri = LP.Data.Attri.Value
            local curDisplayStand = (curStandCode ~= "None") and (CodenameToDisplay[curStandCode] or curStandCode) or "None"
            
            local standMatched = (curStandCode ~= "None") and IsItemInList(RollConfig.TargetStands, curDisplayStand)
            local attriMatched = (curAttri ~= "None" and curAttri ~= "") and IsItemInList(RollConfig.TargetAttributes, curAttri)
            
            local goalReached = false
            if RollConfig.RollMode == "stand or attribute" then
                goalReached = standMatched or attriMatched
            elseif RollConfig.RollMode == "stand only" then
                goalReached = standMatched
            elseif RollConfig.RollMode == "attribute only" then
                goalReached = attriMatched
            elseif RollConfig.RollMode == "stand and attribute" then
                goalReached = standMatched and attriMatched
            elseif RollConfig.RollMode == "Kars" then
                goalReached = attriMatched 
            end
           
            if _G.SpecificRoll and CheckSpecificMatched(curDisplayStand, curAttri) then
                goalReached = true
            end
            
            if goalReached then
                if not hasNotifiedThisStand then
                    hasNotifiedThisStand = true
                    SendRollWebhook(curDisplayStand, curAttri, true, "Target found")
                end

                if _G.AutoStorage then
                    local emptySlots = GetAvailableEmptySlots()
                 
                    if #emptySlots > 0 then
                        Library:Notification({
                            Name = "Target found",
                            Description = string.format("rolled: %s | %s\n", curDisplayStand, curAttri),
                            Duration = 3,
                            Type = "Info"
                        })

                        local success, resultSlot = StoreCurrentStand()

                        if success then
                            SendRollWebhook(curDisplayStand, curAttri, true, "Successfully stored in " .. resultSlot)
                            hasNotifiedThisStand = false

                            task.wait(RollConfig.SafeDelay)

                            local remainingSlots = GetAvailableEmptySlots()
                            if #remainingSlots == 0 then
                                Library:Notification({
                                    Name = "Stored in storage",
                                    Description = "Stored in " .. resultSlot .. "!\nStorage is full",
                                    Duration = 5,
                                    Type = "Warning"
                                })
                            else
                                Library:Notification({
                                    Name = "Stored in storage",
                                    Description = "Successfully stored in " .. resultSlot .. "!\n" .. #remainingSlots .. " slots remaining",
                                    Duration = 4,
                                    Type = "Success"
                                })
                            end

                            continue 
                        else
                            SendRollWebhook(curDisplayStand, curAttri, true, "error (" .. tostring(resultSlot) .. ") - Auto Roll stopped")
                            _G.AutoRoll = false
                            ToggleAutoRoll:Set(false)
                            local reasonText = (resultSlot == "Full") and "No slots available" or "error"
                            Library:Notification({
                                Name = "error",
                                Description = reasonText .. " Auto Roll stopped",
                                Duration = 6,
                                Type = "Error"
                            })
                            continue
                        end
                    else
                        SendRollWebhook(curDisplayStand, curAttri, true, "Inventory is full — Roll stopped")
                        _G.AutoRoll = false
                        ToggleAutoRoll:Set(false)
                        Library:Notification({
                            Name = "The storage is full",
                            Description = string.format("\nStand: %s | %s", curDisplayStand, curAttri),
                            Duration = 8,
                            Type = "Success"
                        })
                        continue
                    end
                else
                    _G.AutoRoll = false
                    ToggleAutoRoll:Set(false)
                    Library:Notification({
                        Name = "Target found",
                        Description = string.format("Stand: %s\nAttribute: %s", curDisplayStand, curAttri),
                        Duration = 8,
                        Type = "Success"
                    })
                    continue
                end
            end
           
            if RollConfig.RollMode == "Kars" then
                if not hasNotifiedThisStand then
                    hasNotifiedThisStand = true
                    SendRollWebhook(curDisplayStand, curAttri, false, "Not the target")
                end
               
                if CountItem("Kars Mask") <= 0 then
                    _G.AutoRoll = false
                    ToggleAutoRoll:Set(false)
                    Library:Notification({
                        Name = "Out of Kars Mask",
                        Description = "No more Kars Mask in inventory",
                        Duration = 5,
                        Type = "Warning"
                    })
                    continue
                end

                local oldAttri = curAttri
                
                local used = EquipAndUseItem("Kars Mask")
                if used then
                    hasNotifiedThisStand = false
                    local startWait = tick()
                    
                    while _G.AutoRoll and (LP.Data.Attri.Value == oldAttri) and (tick() - startWait < 3) do
                        task.wait(0.1)
                    end
                    task.wait(RollConfig.SafeDelay)
                end
           
            elseif curStandCode == "None" then
                hasNotifiedThisStand = false
                local arrowToUse = GetAvailableArrow()
                if not arrowToUse then
                    _G.AutoRoll = false
                    ToggleAutoRoll:Set(false)
                    Library:Notification({
                        Name = "Out of arrows",
                        Description = "No more Arrows (" .. RollConfig.ArrowMode .. ") in inventory",
                        Duration = 5,
                        Type = "Warning"
                    })
                    continue
                end

                local used = EquipAndUseItem(arrowToUse)
                if used then
                    local startWait = tick()
                    while _G.AutoRoll and LP.Data.Stand.Value == "None" and (tick() - startWait < 6) do
                        task.wait(0.1)
                    end
                    task.wait(RollConfig.SafeDelay)
                end
           
            else
                if not hasNotifiedThisStand then
                    hasNotifiedThisStand = true
                    SendRollWebhook(curDisplayStand, curAttri, false, "Not the target")
                end

                if CountItem("Rokakaka") <= 0 then
                    _G.AutoRoll = false
                    ToggleAutoRoll:Set(false)
                    Library:Notification({
                        Name = "Out of Rokakaka",
                        Description = "No more Rokakaka in inventory",
                        Duration = 5,
                        Type = "Warning"
                    })
                    continue
                end

                local used = EquipAndUseItem("Rokakaka")
                if used then
                    local startWait = tick()
                    while _G.AutoRoll and LP.Data.Stand.Value ~= "None" and (tick() - startWait < 4) do
                        task.wait(0.1)
                    end
                    task.wait(RollConfig.SafeDelay)
                end
            end
        end
    end
end)

_G.AutoLair = false
_G.SelectedLair = "15+"
getgenv().inskill = false
_G.InsKillDelay = 2       
local lairEnterTime = 0   
local wasInLair = false   

local LairSafeZones = {
    ["15+"]  = CFrame.new(-739.41, 67.02, -937.28),
    ["40+"]  = CFrame.new(-743.24, 66.53, -385.86),
    ["80+"]  = CFrame.new(-333.14, 66.97, -132.11),
    ["100+"] = CFrame.new(-100.67, 66.93, -871.43)
}

local isnetworkowner = isnetworkowner or isnetowner
local sethiddenproperty = sethiddenproperty or set_hidden_property or set_hidden_prop
local setsimulationradius = setsimulationradius or set_simulation_radius

local function isAnyTpToggleActive()
    return _G.AutoQuest or _G.AutoTeleport or _G.AutoBoss or isResettingMob
end

local function getInLair()
    local val = false
    pcall(function()
        local char = LP.Character
        if char and char:FindFirstChild("InLair") then
            val = char.InLair.Value
        else
            local living = Workspace:FindFirstChild("Living")
            if living and living:FindFirstChild(LP.Name) and living[LP.Name]:FindFirstChild("InLair") then
                val = living[LP.Name].InLair.Value
            end
        end
    end)
    return val
end

local TargetPivot200 = CFrame.new(28082.2109, 47.42313, -234.005859, -0.647272944, 0, -0.762258351, 0, 1, 0, 0.762258351, 0, -0.647272944)

local function GetLairNPC(levelString)
    if levelString == "200+" then
        local targetPos = TargetPivot200.Position
        local map = Workspace:FindFirstChild("Map")
        local npcsFolder = map and map:FindFirstChild("NPCs")

        if npcsFolder then
            for _, v in ipairs(npcsFolder:GetChildren()) do
                if v:IsA("Model") then
                    local p = GetWorldPivot(v)
                    if p and (p.Position - targetPos).Magnitude <= 3 then
                        return v
                    end
                end
            end
        end

        for _, v in ipairs(Workspace:GetChildren()) do
            if v:IsA("Model") and v ~= LP.Character then
                local p = GetWorldPivot(v)
                if p and (p.Position - targetPos).Magnitude <= 3 then
                    return v
                end
            end
        end

        if map then
            for _, v in ipairs(map:GetDescendants()) do
                if v:IsA("Model") and v ~= LP.Character then
                    local p = GetWorldPivot(v)
                    if p and (p.Position - targetPos).Magnitude <= 3 then
                        return v
                    end
                end
            end
        end

        return nil
    end

    local map = Workspace:FindFirstChild("Map")
    local npcsFolder = map and map:FindFirstChild("NPCs")
    if not npcsFolder then return nil end

    for _, v in pairs(npcsFolder:GetChildren()) do
        if v.Name == "i_stabman" and v:FindFirstChild("Head") and v.Head:FindFirstChild("Main") then
            local success, text = pcall(function() 
                local textObj = v.Head.Main.Text
                if typeof(textObj) == "Instance" then return textObj.Text end
                return textObj
            end)
            if success and type(text) == "string" and string.find(text, levelString, 1, true) then
                return v
            end
        end
    end
    return nil
end

local isLairHovering = false

local function stopLairHover()
    if not isLairHovering then return end 
    isLairHovering = false

    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local bv = hrp:FindFirstChild("LairHoverBV")
        if bv then bv:Destroy() end
        local bg = hrp:FindFirstChild("LairHoverBG")
        if bg then bg:Destroy() end
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
    end
end

local LairTab = Window:Tab({
    Name = "Lair",
    Icon = "skull"
})

local LairSubTab = LairTab:SubTab({
    Name = "Auto Lair",
    Icon = "swords"
})

local LairSettingsSection = LairSubTab:Section({
    Name = "Lair",
    Side = "Left"
})

LairSettingsSection:Toggle({
    Name = "Auto Lair",
    Default = false,
    Flag = "Toggle_AutoLair",
    Callback = function(Value)
        _G.AutoLair     = Value
        _G.Noclip       = Value
        _G.CameraNoclip = Value       

        if Value then
            if _G.AutoQuest then
                _G.AutoQuest = false
                if Library.Flags["Toggle_AutoQuest"] ~= nil then
                    pcall(function() Library.SetFlags["Toggle_AutoQuest"](false) end)
                end
            end
            if _G.AutoBoss then
                _G.AutoBoss = false
                if Library.Flags["Toggle_AutoBoss"] ~= nil then
                    pcall(function() Library.SetFlags["Toggle_AutoBoss"](false) end)
                end
            end

            task.spawn(EnableCameraNoclip)
        else
            if not _G.AutoQuest and not _G.AutoBoss then
                pcall(function()
                    LP.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
                end)
            end
        end
    end
})

LairSettingsSection:Toggle({
    Name = "ins kill",
    Default = false,
    Flag = "Toggle_InsKill",
    Callback = function(Value)
        getgenv().inskill = Value
        if not Value then
            stopLairHover()
        end
    end
})

LairSettingsSection:Textbox({
    Name = "Ins Kill Delay",
    Default = "2",
    Placeholder = "s",
    Finished = false,
    ClearOnFocus = false,
    Numeric = true,
    Min = 0,
    Max = 300,
    Icon = "clock",
    ClearButton = true,
    Flag = "Textbox_InsKillDelay",
    Callback = function(Value)
        _G.InsKillDelay = tonumber(Value) or 0
    end
})

LairSettingsSection:Dropdown({
    Name = "Lair",
    Options = {
        "15+",
        "40+",
        "80+",
        "100+",
        "200+"
    },
    Default = "15+",
    Flag = "Dropdown_SelectLair",
    Callback = function(Value)
        _G.SelectedLair = Value
    end
})

local LairWebhookSection = LairSubTab:Section({
    Name = "Webhook Settings",
    Side = "Right"
})

LairWebhookSection:Toggle({
    Name = "Webhook",
    Default = false,
    Flag = "Toggle_LairWebhook",
    Callback = function(Value)
        _G.WebhookLair = Value
    end
})

LairWebhookSection:Textbox({
    Name = "Webhook URL",
    Default = "",
    Placeholder = "https://discord.com/api/webhooks/...",
    ClearOnFocus = false,
    Flag = "Textbox_LairWebhookURL",
    Callback = function(Value)
        _G.LairWebhookURL = Value
    end
})

LairWebhookSection:Button({
    Name = "Test Webhook",
    Icon = "send",
    Callback = function()
        local targetURL = (_G.LairWebhookURL and _G.LairWebhookURL ~= "") and _G.LairWebhookURL or _G.WebhookURL
        if not targetURL or targetURL == "" then
            Library:Notification({
                Name = "Error",
                Description = "Please enter the Webhook URL first",
                Duration = 3,
                Type = "Warning"
            })
            return
        end

        local ok = pcall(function()
            local payload = {
                username = "Auto Lair Notifier",
                embeds = {
                    {
                        title = "Test Webhook Lair",
                        description = "acc **" .. LP.Name .. "** ✅",
                        color = 0x3498DB,
                        footer = { text = "skibidi • Test" },
                        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
                    }
                }
            }
            httpRequest({
                Url = targetURL,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode(payload)
            })
        end)

        if ok then
            Library:Notification({
                Name = "Success",
                Description = "Webhook sent",
                Duration = 3,
                Type = "Success"
            })
        else
            Library:Notification({
                Name = "failure",
                Description = "unable to send, please check the URL again",
                Duration = 4,
                Type = "Error"
            })
        end
    end
})

_G.WebhookLair = false
_G.LairWebhookURL = ""

local function SendLairWebhook(tier, reward)
    local targetURL = (_G.LairWebhookURL and _G.LairWebhookURL ~= "") and _G.LairWebhookURL or _G.WebhookURL
    if not _G.WebhookLair or not targetURL or targetURL == "" then return end
    if not httpRequest then 
        warn("[Webhook Lair] Executor không hỗ trợ HTTP Request")
        return 
    end

    local fields = {
        {
            name = "Player",
            value = string.format("`%s` (`%s`)", LP.Name, LP.DisplayName),
            inline = true
        },
        {
            name = "Lair",
            value = string.format("**%s**", tostring(tier or _G.SelectedLair or "Unknown")),
            inline = true
        },
        {
            name = "Reward",
            value = string.format("```yaml\n%s\n```", tostring(reward or "None")),
            inline = false
        }
    }

    local payload = {
        username = "Auto Lair Notifier",
        avatar_url = "https://i.imgur.com/8Q5F5gD.png",
        embeds = {
            {
                title = "Lair Cleared",
                color = 0x2ECC71, 
                fields = fields,
                footer = {
                    text = "skibidi • Auto Lair"
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }
    }

    task.spawn(function()
        pcall(function()
            httpRequest({
                Url = targetURL,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode(payload)
            })
        end)
    end)
end

local isLairCleared = false 
local currentLairDungeon = nil

local eventsFolder = ReplicatedStorage:WaitForChild("Events", 10)
local lairClearRemote = eventsFolder and eventsFolder:FindFirstChild("LairClear")
local lairStartRemote = eventsFolder and eventsFolder:FindFirstChild("LairStart")

if lairStartRemote then
    lairStartRemote.OnClientEvent:Connect(function()
        isLairCleared = false
        lairEnterTime = tick() 
        wasInLair = true
    end)
end

local TARGET_DUNGEON_NAMES = {
    ["level200dungeon"] = true,
    ["lvl100dungeon"]   = true,
    ["lvl80dungeon"]    = true,
    ["diodungeon"]      = true,
    ["lvl 15 lair"]     = true,
}

local currentLairDungeon = nil

local function isInsideBoundingBox(pos, model)
    if not model or not model:IsA("Model") then return false end
    local s, cf, size = pcall(function() return model:GetBoundingBox() end)
    if not s or not cf or not size then return false end

    local rel = cf:PointToObjectSpace(pos)
    local hSize = size / 2

    return math.abs(rel.X) <= hSize.X
        and math.abs(rel.Y) <= hSize.Y
        and math.abs(rel.Z) <= hSize.Z
end

local function findStandingDungeonModel()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local pos = hrp.Position
    local hitPart = nil

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {char}
    rayParams.IgnoreWater = false

    local rayHit = Workspace:Raycast(pos, Vector3.new(0, -25, 0), rayParams)
    if rayHit and rayHit.Instance then
        hitPart = rayHit.Instance
    end

    if not hitPart then
        local overlapParams = OverlapParams.new()
        overlapParams.FilterType = Enum.RaycastFilterType.Exclude
        overlapParams.FilterDescendantsInstances = {char}

        local parts = Workspace:GetPartBoundsInBox(hrp.CFrame, Vector3.new(6, 12, 6), overlapParams)
        if #parts > 0 then
            hitPart = parts[1]
        end
    end

    if hitPart then
        local current = hitPart.Parent
        while current and current ~= Workspace do
            if current:IsA("Model") then
                if TARGET_DUNGEON_NAMES[string.lower(current.Name)] or current.Name == "myDungeon" then
                    return current
                end
            end
            current = current.Parent
        end
    end

    for _, item in ipairs(Workspace:GetChildren()) do
        if item:IsA("Model") and (TARGET_DUNGEON_NAMES[string.lower(item.Name)] or item.Name == "myDungeon") then
            if isInsideBoundingBox(pos, item) then
                return item
            end
        end
    end

    local map = Workspace:FindFirstChild("Map")
    if map then
        for _, item in ipairs(map:GetChildren()) do
            if item:IsA("Model") and (TARGET_DUNGEON_NAMES[string.lower(item.Name)] or item.Name == "myDungeon") then
                if isInsideBoundingBox(pos, item) then
                    return item
                end
            end
        end
    end

    return nil
end

local function renameBossToRealBoss(dungeonModel)
    local found = false
    local dungeon = dungeonModel or currentLairDungeon or Workspace:FindFirstChild("myDungeon")
    if not dungeon or not dungeon.Parent then return false end

    local function shouldRename(entity)
        if entity:IsA("Model") and string.lower(entity.Name) == "boss" and entity ~= LP.Character then
            local hrp = entity:FindFirstChild("HumanoidRootPart") or entity:FindFirstChild("Torso") or entity.PrimaryPart
            local pos = hrp and hrp.Position or (entity:GetPivot() and entity:GetPivot().Position)
                       
            if entity:IsDescendantOf(dungeon) or (pos and isInsideBoundingBox(pos, dungeon)) then
                entity.Name = "realboss"
                return true
            end
        end
        return false
    end

    for _, desc in ipairs(dungeon:GetDescendants()) do
        if shouldRename(desc) then found = true end
    end

    local living = Workspace:FindFirstChild("Living")
    if living then
        for _, entity in ipairs(living:GetChildren()) do
            if shouldRename(entity) then found = true end
        end
    end

    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj ~= living and obj ~= dungeon then
            if shouldRename(obj) then found = true end
        end
    end

    return found
end

local livingWatcherConn = nil
local function enableLivingBossWatcher()
    if livingWatcherConn then return end
    local living = Workspace:FindFirstChild("Living")
    if living then
        livingWatcherConn = living.ChildAdded:Connect(function(child)
            if child:IsA("Model") and string.lower(child.Name) == "boss" then
                task.wait(0.1)
                local dungeon = currentLairDungeon or Workspace:FindFirstChild("myDungeon")
                if dungeon and dungeon.Parent then
                    local hrp = child:FindFirstChild("HumanoidRootPart") or child:FindFirstChild("Torso") or child.PrimaryPart
                    local pos = hrp and hrp.Position or (child:GetPivot() and child:GetPivot().Position)
                    if child:IsDescendantOf(dungeon) or (pos and isInsideBoundingBox(pos, dungeon)) then
                        child.Name = "realboss"
                    end
                end
            end
        end)
    end
end

local function disableLivingBossWatcher()
    if livingWatcherConn then
        livingWatcherConn:Disconnect()
        livingWatcherConn = nil
    end
end

task.spawn(function()
    while true do
        task.wait(0.5)

        if _G.AutoLair then
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")

            if char and hrp and hum and hum.Health > 0 then
                local inLair = getInLair()
                
                if not inLair then
    isLairCleared = false 
    currentLairDungeon = nil
    disableLivingBossWatcher()
    lairEnterTime = 0    
    wasInLair = false
    

                    if not isAnyTpToggleActive() then
                        local targetTier = _G.SelectedLair or "15+"
                        local safeCF = LairSafeZones[targetTier]

                        if safeCF then
                            pcall(function()
                                hum.Sit = false
                                hrp.AssemblyLinearVelocity = Vector3.zero
                                hrp.AssemblyAngularVelocity = Vector3.zero
                                hrp.CFrame = safeCF
                            end)
                        end

                        local npc = GetLairNPC(targetTier)
                        if npc then
                            local doneRemote = npc:FindFirstChild("Done") or npc:FindFirstChildOfClass("RemoteEvent")
                            if doneRemote then
                                doneRemote:FireServer()
                            end
                        end
                    end
                else
                    
                    enableLivingBossWatcher()
                    
                    if not currentLairDungeon or not currentLairDungeon.Parent or currentLairDungeon.Name ~= "myDungeon" then
                        local detected = findStandingDungeonModel()
                        if detected then
                            local oldName = detected.Name
                            if oldName ~= "myDungeon" then
                                detected.Name = "myDungeon"
                                currentLairDungeon = detected
                                
                                pcall(function()
                                    
                                end)
                            else
                                currentLairDungeon = detected
                            end
                        end
                    end                    
                    renameBossToRealBoss(currentLairDungeon)
                end
            end
        else
            currentLairDungeon = nil
            disableLivingBossWatcher()
        end
    end
end)

local INS_CONFIG = {
    TARGET_NAME = "realboss",
    DISTANCE_BELOW = HoverConfig.DistanceBelow or 8.0, 
    LOOP_INTERVAL = 0.05
}

local function ResetLairData()
    isLairCleared = true
    lairEnterTime = 0
    wasInLair = false
    
    stopLairHover()
    
    disableLivingBossWatcher()
    
    currentLairDungeon = nil
    
    pcall(function()
        local living = Workspace:FindFirstChild("Living")
        if living then
            for _, obj in ipairs(living:GetChildren()) do
                if obj:IsA("Model") and string.lower(obj.Name) == "realboss" then
                    obj.Name = "cleared_boss"
                end
            end
        end
    end)
end

if lairClearRemote then
    lairClearRemote.OnClientEvent:Connect(function(reward)
        ResetLairData()
        SendLairWebhook(_G.SelectedLair, reward)
    end)
end

local function updateLairState()
    local inLair = getInLair()
    if inLair then
        if not wasInLair or lairEnterTime == 0 then
            lairEnterTime = tick()
            wasInLair = true
        end
    else
        wasInLair = false
        lairEnterTime = 0
    end
    return inLair
end

local function canRunInsKill()
    if not (_G.AutoLair and getgenv().inskill) then
        return false
    end

    local inLair = updateLairState()
    if not inLair or isLairCleared then
        return false
    end

    local delaySec = tonumber(_G.InsKillDelay) or 0
    if delaySec > 0 then
        if lairEnterTime == 0 or (tick() - lairEnterTime) < delaySec then
            return false
        end
    end

    return true
end

local function claimSimulationRadius()
    pcall(function()
        if setsimulationradius then
            setsimulationradius(999999999999999999999, 999999999999999999999)
        elseif sethiddenproperty then
            sethiddenproperty(LP, "SimulationRadius", 999999999999999999999)
            sethiddenproperty(LP, "MaxSimulationRadius", 999999999999999999999)
        end
    end)
end

RunService.RenderStepped:Connect(function()
    if canRunInsKill() then
        claimSimulationRadius()
    end
end)

local function findRealBoss()
    if isLairCleared then return nil, nil, nil end

    local dungeon = currentLairDungeon
    if not dungeon or not dungeon.Parent or dungeon.Name ~= "myDungeon" then
        dungeon = Workspace:FindFirstChild("myDungeon")
    end
    
    if not dungeon or not dungeon.Parent then return nil, nil, nil end

    local function checkBossModel(obj)
        if obj and obj:IsA("Model") and obj ~= LP.Character and not Players:GetPlayerFromCharacter(obj) then
            if string.lower(obj.Name) == INS_CONFIG.TARGET_NAME then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj.PrimaryPart
                                              
                if hum and hrp then
                    local inDungeon = obj:IsDescendantOf(dungeon) or isInsideBoundingBox(hrp.Position, dungeon)
                    if inDungeon then
                        return obj, hum, hrp
                    end
                end
            end
        end
        return nil, nil, nil
    end

    for _, desc in ipairs(dungeon:GetDescendants()) do
        local b, h, r = checkBossModel(desc)
        if b then return b, h, r end
    end

    local livingFolder = Workspace:FindFirstChild("Living")
    if livingFolder then
        for _, obj in ipairs(livingFolder:GetChildren()) do
            local b, h, r = checkBossModel(obj)
            if b then return b, h, r end
        end
    end

    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj ~= livingFolder and obj ~= dungeon then
            local b, h, r = checkBossModel(obj)
            if b then return b, h, r end
        end
    end

    return nil, nil, nil
end

local function instantkill(npc, hum, hrp)
    if not npc or not npc.Parent then return end
    if string.lower(npc.Name) ~= INS_CONFIG.TARGET_NAME then return end

    pcall(function()
        if hrp and hrp:IsA("BasePart") and hrp.Anchored then
            hrp.Anchored = false
        end

        local hasNetwork = true
        if isnetworkowner and hrp then
            hasNetwork = isnetworkowner(hrp)
        end

        if hum then
            hum.MaxHealth = 0
            hum.Health = 0
            if hasNetwork then
                hum:ChangeState(Enum.HumanoidStateType.Dead)
            end
            hum:TakeDamage(math.huge)
        end       
        npc:BreakJoints()
    end)
end

RunService.Heartbeat:Connect(function()
    if not canRunInsKill() then
        if isLairHovering then
            stopLairHover()
        end
        return
    end

    local char = LP.Character
    local myHRP = char and char:FindFirstChild("HumanoidRootPart")
    local myHum = char and char:FindFirstChildOfClass("Humanoid")
    if not myHRP or not myHum or myHum.Health <= 0 then
        if isLairHovering then
            stopLairHover()
        end
        return
    end

    local boss, bossHum, bossHRP = findRealBoss()
    if not boss or not bossHRP or not boss.Parent then
        if isLairHovering then
            stopLairHover()
        end
        return
    end

    isLairHovering = true 

    myHum.PlatformStand = false
    myHum.Sit = false

    myHRP.AssemblyLinearVelocity = Vector3.zero
    myHRP.AssemblyAngularVelocity = Vector3.zero

    local bv = myHRP:FindFirstChild("LairHoverBV")
    if not bv then
        bv = Instance.new("BodyVelocity")
        bv.Name = "LairHoverBV"
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.zero
        bv.Parent = myHRP
    else
        bv.Velocity = Vector3.zero
    end

    local bg = myHRP:FindFirstChild("LairHoverBG")
    if not bg then
        bg = Instance.new("BodyGyro")
        bg.Name = "LairHoverBG"
        bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        bg.P = 15000
        bg.Parent = myHRP
    end

    local targetPos = bossHRP.Position - Vector3.new(0, INS_CONFIG.DISTANCE_BELOW or 7, 0)
    local targetCF = CFrame.lookAt(targetPos, bossHRP.Position)

    myHRP.CFrame = targetCF
    bg.CFrame = targetCF
end)

task.spawn(function()
    while true do
        
        if canRunInsKill() then
            local char = LP.Character
            local myHRP = char and char:FindFirstChild("HumanoidRootPart")
            local myHum = char and char:FindFirstChildOfClass("Humanoid")

            if char and myHRP and myHum and myHum.Health > 0 then
                local boss, bossHum, bossHRP = findRealBoss()

                if boss and bossHRP and boss.Parent then
                    instantkill(boss, bossHum, bossHRP)

                    local standEvents = char:FindFirstChild("StandEvents")
                    if standEvents then
                        local m1Event = standEvents:FindFirstChild("M1")
                        if m1Event and m1Event:IsA("RemoteEvent") then
                            m1Event:FireServer()
                        end
                    end
                end
            end
        end
        task.wait(INS_CONFIG.LOOP_INTERVAL)
    end
end)

local HttpService = HttpService or game:GetService("HttpService")
local TeleportService = TeleportService or game:GetService("TeleportService")
local ReplicatedStorage = ReplicatedStorage or game:GetService("ReplicatedStorage")
local Players = Players or game:GetService("Players")
local Workspace = Workspace or game:GetService("Workspace")
local LP = LP or Players.LocalPlayer

_G.AutoHopShutdown = false
_G.AutoRejoin      = false

local RejoinConfig = {
    Hours   = 1,
    Minutes = 0
}

local rejoinTargetTime = tick() + 3600
local isHoppingServer  = false

local function OpenStorageNPC()
    local success = pcall(function()
        local map = Workspace:FindFirstChild("Map")
        local npcsFolder = map and map:FindFirstChild("NPCs")
        local admpn = npcsFolder and npcsFolder:FindFirstChild("admpn")
        local doneRemote = admpn and (admpn:FindFirstChild("Done") or admpn:FindFirstChildOfClass("RemoteEvent"))

        if doneRemote then
            doneRemote:FireServer()
        else
            workspace.Map.NPCs.admpn.Done:FireServer()
        end
    end)

    if success then
        Library:Notification({
            Name = "Storage",
            Description = "✅️",
            Duration = 3,
            Type = "Success"
        })
    else
        Library:Notification({
            Name = "error",
            Description = "NPC not found",
            Duration = 3,
            Type = "Error"
        })
    end
end

local function SafeServerHop()
    if isHoppingServer then return end
    isHoppingServer = true

    local placeId = game.PlaceId
    local currentJob = game.JobId
    local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    local cursor = ""
    local candidateServers = {}

    for _ = 1, 5 do
        local apiUrl = string.format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100%s", tostring(placeId), cursor ~= "" and ("&cursor=" .. cursor) or "")
        local rawData = nil

        if req then
            local ok, res = pcall(function()
                return req({ Url = apiUrl, Method = "GET" })
            end)
            if ok and res and res.Body then
                rawData = res.Body
            end
        else
            pcall(function()
                rawData = game:HttpGet(apiUrl)
            end)
        end

        if rawData then
            local data = nil
            pcall(function()
                data = HttpService:JSONDecode(rawData)
            end)

            if data and data.data then
                for _, srv in ipairs(data.data) do
                    if type(srv) == "table" and srv.id and srv.id ~= currentJob and (srv.playing or 0) < (srv.maxPlayers or 0) then
                        table.insert(candidateServers, srv.id)
                    end
                end

                if #candidateServers > 0 then
                    break
                end

                if data.nextPageCursor and data.nextPageCursor ~= "null" and data.nextPageCursor ~= cursor then
                    cursor = data.nextPageCursor
                else
                    break
                end
            else
                break
            end
        else
            break
        end
        task.wait(0.25)
    end

    if #candidateServers > 0 then
        local chosenServer = candidateServers[math.random(1, #candidateServers)]
        pcall(function()
            TeleportService:TeleportToPlaceInstance(placeId, chosenServer, LP)
        end)
    else
        pcall(function()
            TeleportService:Teleport(placeId, LP)
        end)
    end

    task.wait(3)
    isHoppingServer = false
end

task.spawn(function()
    local events = ReplicatedStorage:WaitForChild("Events", 15)
    local shutdownEvent = events and events:WaitForChild("Shutdown", 15)

    if shutdownEvent and shutdownEvent:IsA("RemoteEvent") then
        shutdownEvent.OnClientEvent:Connect(function()
            if _G.AutoHopShutdown then
                
                Library:Notification({
                    Name = "Server Shutdown",
                    Description = "✅️",
                    Duration = 6,
                    Type = "Warning"
                })
                task.wait(0.5)
                SafeServerHop()
            end
        end)
    end
end)

task.spawn(function()
    local pGui = LP:WaitForChild("PlayerGui", 20)
    if not pGui then return end

    local function checkGui(child)
        if child and child.Name == "ShutdownGUI" and _G.AutoHopShutdown then
            
            task.wait(0.5)
            SafeServerHop()
        end
    end

    if pGui:FindFirstChild("ShutdownGUI") then
        checkGui(pGui.ShutdownGUI)
    end
    pGui.ChildAdded:Connect(checkGui)
end)

local function RejoinCurrentGame()
    task.wait(0.2)

    local success = pcall(function()
        if #Players:GetPlayers() <= 1 then
            TeleportService:Teleport(game.PlaceId, LP)
        else
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
        end
    end)

    if not success then
        pcall(function()
            TeleportService:Teleport(game.PlaceId, LP)
        end)
    end
end

local MiscTab = Window:Tab({
    Name = "Misc",
    Icon = "wrench"
})

local MiscSubTab = MiscTab:SubTab({
    Name = "General",
    Icon = "sliders"
})

local MiscStorageSection = MiscSubTab:Section({
    Name = "Storage",
    Side = "Left"
})

MiscStorageSection:Button({
    Name = "Open Storage",
    Icon = "package",
    Callback = function()
        OpenStorageNPC()
    end
})

_G.AntiTimeStop = false
_G.AntiRagdoll  = false

local MiscProtectionSection = MiscSubTab:Section({
    Name = "anti",
    Side = "Left"
})

task.spawn(function()
    pcall(function()
        local clientEffects = ReplicatedStorage:WaitForChild("ClientEffects", 5)
        local modulesFolder = clientEffects and clientEffects:WaitForChild("Modules", 5)
        local tsFreezeModule = modulesFolder and modulesFolder:WaitForChild("TimestopFreeze", 5)

        if tsFreezeModule and tsFreezeModule:IsA("ModuleScript") then
            local TSFreeze = require(tsFreezeModule)
            if type(TSFreeze) == "table" and type(TSFreeze.Start) == "function" then
                local rawStart = TSFreeze.Start
                TSFreeze.Start = function(self, arg1)
                    if _G.AntiTimeStop and type(arg1) == "table" then
                        local targetChar = arg1.CharacterToEffect
                        if targetChar and targetChar == LP.Character then
                            
                            return
                        end
                    end
                    return rawStart(self, arg1)
                end
            end
        end
    end)
end)

RunService.Heartbeat:Connect(function()
    if not _G.AntiTimeStop then return end

    local char = LP.Character
    if not char then return end

    local cam = Workspace.CurrentCamera
    local lighting = game:GetService("Lighting")
    local bw1 = cam and cam:FindFirstChild("TimestopBlackAndWhite")
    if bw1 then bw1:Destroy() end
    local bw2 = lighting and lighting:FindFirstChild("TimestopBlackAndWhite")
    if bw2 then bw2:Destroy() end

    local isHovering = (isHoverFarming == true) or (isLairHovering == true)
    if not isHovering then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Anchored then
                part.Anchored = false
            end
        end
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health > 0 then
        if hum.WalkSpeed == 0 then
            hum.WalkSpeed = 16
        end
        if hum.JumpPower == 0 then
            hum.JumpPower = 50
        end
    end
end)

local function EnforceAntiRagdoll(char)
    if not char or not _G.AntiRagdoll then return end

    char:SetAttribute("MAttackTitanActive", true)
    char:SetAttribute("RagdollBound", true)
    char:SetAttribute("ClientRagdollLeaseUntil", nil)

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health > 0 then
        hum.PlatformStand = false
        hum.Sit = false
        hum.AutoRotate = true

        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)

        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Ragdoll 
        or state == Enum.HumanoidStateType.FallingDown 
        or state == Enum.HumanoidStateType.Physics 
        or state == Enum.HumanoidStateType.PlatformStanding then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end

    local animate = char:FindFirstChild("Animate")
    if animate and animate:IsA("BaseScript") and animate.Disabled then
        animate.Disabled = false
    end

    for _, desc in ipairs(char:GetDescendants()) do
        if desc:IsA("Motor6D") then
            if not desc.Enabled then
                desc.Enabled = true
            end
        elseif desc:IsA("BallSocketConstraint") and string.find(desc.Name, "Ragdoll", 1, true) then
            pcall(function() desc:Destroy() end)
        end
    end

    local constraints = char:FindFirstChild("RagdollConstraints")
    if constraints then
        pcall(function() constraints:Destroy() end)
    end
end

RunService.Stepped:Connect(function()
    if _G.AntiRagdoll and LP.Character then
        EnforceAntiRagdoll(LP.Character)
    end
end)

LP.CharacterAdded:Connect(function(newChar)
    if _G.AntiRagdoll then
        task.wait(0.2)
        EnforceAntiRagdoll(newChar)

        local ragdollRemote = newChar:WaitForChild("Ragdoll", 5)
        if ragdollRemote and ragdollRemote:IsA("RemoteEvent") and getconnections then
            for _, conn in pairs(getconnections(ragdollRemote.OnClientEvent)) do
                conn:Disable()
            end
        end
    end
end)

MiscProtectionSection:Toggle({
    Name = "Anti Time Stop",
    Default = false,
    Flag = "Toggle_AntiTimeStop",
    Callback = function(Value)
        _G.AntiTimeStop = Value

        if Value then
            Library:Notification({
                Name = "Anti Time Stop",
                Description = "✅️",
                Duration = 3,
                Type = "Success"
            })
        else
            Library:Notification({
                Name = "Anti Time Stop",
                Description = "Disabled",
                Duration = 3,
                Type = "Info"
            })
        end
    end
})

MiscProtectionSection:Toggle({
    Name = "Anti Ragdoll",
    Default = false,
    Flag = "Toggle_AntiRagdoll",
    Callback = function(Value)
        _G.AntiRagdoll = Value

        if Value then
            if LP.Character then
                EnforceAntiRagdoll(LP.Character)
            end

            Library:Notification({
                Name = "Anti Ragdoll",
                Description = "✅️",
                Duration = 3,
                Type = "Success"
            })
        else
            if LP.Character then
                LP.Character:SetAttribute("MAttackTitanActive", nil)
                LP.Character:SetAttribute("RagdollBound", nil)
            end

            Library:Notification({
                Name = "Anti Ragdoll",
                Description = "Disabled",
                Duration = 3,
                Type = "Info"
            })
        end
    end
})

local MiscServerSection = MiscSubTab:Section({
    Name = "Server & Rejoin",
    Side = "Right"
})

MiscServerSection:Toggle({
    Name = "Auto Hop (Server Shutdown)",
    Default = false,
    Flag = "Toggle_AutoHopShutdown",
    Callback = function(Value)
        _G.AutoHopShutdown = Value
        if Value then
            Library:Notification({
                Name = "Auto Hop",
                Description = "✅️",
                Duration = 3,
                Type = "Info"
            })
        end
    end
})

MiscServerSection:Button({
    Name = "Server Hop",
    Icon = "rotate-cw",
    Callback = function()
        Library:Notification({
            Name = "Server Hop",
            Description = "✅️",
            Duration = 3,
            Type = "Info"
        })
        SafeServerHop()
    end
})

local RejoinCountdownLabel = MiscServerSection:Label({
    Name = "Rejoin Countdown",
    RightText = "Off",
    Icon = "clock"
})

local function ResetRejoinTimer()
    local totalSecs = (RejoinConfig.Hours * 3600) + (RejoinConfig.Minutes * 60)
    if totalSecs <= 0 then
        totalSecs = 60
    end
    rejoinTargetTime = tick() + totalSecs
end

MiscServerSection:Toggle({
    Name = "Auto Rejoin",
    Default = false,
    Flag = "Toggle_AutoRejoin",
    Callback = function(Value)
        _G.AutoRejoin = Value
        if Value then
            ResetRejoinTimer()
            Library:Notification({
                Name = "Auto Rejoin",
                Description = string.format("rejoin: %d hour %d min", RejoinConfig.Hours, RejoinConfig.Minutes),
                Duration = 4,
                Type = "Info"
            })
        else
            RejoinCountdownLabel:SetRightText("Off")
        end
    end
})

MiscServerSection:Slider({
    Name = "Hours",
    Min = 0,
    Max = 24,
    Default = 1,
    Step = 1,
    Decimals = 0,
    Suffix = " hrs",
    Flag = "Slider_RejoinHours",
    Callback = function(Value)
        RejoinConfig.Hours = Value
        if _G.AutoRejoin then
            ResetRejoinTimer()
        end
    end
})

MiscServerSection:Slider({
    Name = "Minutes",
    Min = 0,
    Max = 59,
    Default = 0,
    Step = 1,
    Decimals = 0,
    Suffix = " min",
    Flag = "Slider_RejoinMinutes",
    Callback = function(Value)
        RejoinConfig.Minutes = Value
        if _G.AutoRejoin then
            ResetRejoinTimer()
        end
    end
})

MiscServerSection:Button({
    Name = "Rejoin",
    Icon = "refresh-cw",
    Callback = function()
        Library:Notification({
            Name = "Rejoining",
            Description = "✅️",
            Duration = 3,
            Type = "Info"
        })
        RejoinCurrentGame()
    end
})

task.spawn(function()
    while true do
        task.wait(1)
        if _G.AutoRejoin then
            local remaining = math.floor(rejoinTargetTime - tick())
            if remaining <= 0 then
                RejoinCountdownLabel:SetRightText("Rejoining...")
                Library:Notification({
                    Name = "Auto Rejoin",
                    Description = "✅️",
                    Duration = 4,
                    Type = "Warning"
                })
                task.wait(1)
                RejoinCurrentGame()
                ResetRejoinTimer()
            else
                local h = math.floor(remaining / 3600)
                local m = math.floor((remaining % 3600) / 60)
                local s = remaining % 60
                RejoinCountdownLabel:SetRightText(string.format("%02d:%02d:%02d", h, m, s))
            end
        end
    end
end)

_G.AutoResetPlayer = false

local ResetCharConfig = {
    Minutes = 1,
    Seconds = 0
}

local resetCharTargetTime = tick() + 60

local function GetResetTotalSeconds()
    local total = (ResetCharConfig.Minutes * 60) + ResetCharConfig.Seconds
    return math.max(total, 5) 
end

local function ResetCharTimer()
    resetCharTargetTime = tick() + GetResetTotalSeconds()
end

local function KillLocalPlayer()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health > 0 then
        hum.Health = 0
    elseif char then
        char:BreakJoints()
    end
end

local MiscResetSection = MiscSubTab:Section({
    Name = "Auto Reset",
    Side = "Right"
})

local ResetCountdownLabel = MiscResetSection:Label({
    Name = "Reset Countdown",
    RightText = "Off",
    Icon = "clock"
})

MiscResetSection:Toggle({
    Name = "Auto Reset Character",
    Default = false,
    Flag = "Toggle_AutoResetPlayer",
    Callback = function(Value)
        _G.AutoResetPlayer = Value
        if Value then
            ResetCharTimer()
            Library:Notification({
                Name = "Auto Reset",
                Description = string.format("Reset: %d min %d s", ResetCharConfig.Minutes, ResetCharConfig.Seconds),
                Duration = 3,
                Type = "Info"
            })
        else
            ResetCountdownLabel:SetRightText("Off")
        end
    end
})

MiscResetSection:Slider({
    Name = "Minutes",
    Min = 0,
    Max = 60,
    Default = 1,
    Step = 1,
    Decimals = 0,
    Suffix = " min",
    Flag = "Slider_ResetMinutes",
    Callback = function(Value)
        ResetCharConfig.Minutes = Value
        if _G.AutoResetPlayer then
            ResetCharTimer()
        end
    end
})

MiscResetSection:Slider({
    Name = "Seconds",
    Min = 0,
    Max = 59,
    Default = 0,
    Step = 1,
    Decimals = 0,
    Suffix = " sec",
    Flag = "Slider_ResetSeconds",
    Callback = function(Value)
        ResetCharConfig.Seconds = Value
        if _G.AutoResetPlayer then
            ResetCharTimer()
        end
    end
})

MiscResetSection:Button({
    Name = "Reset Now",
    Icon = "skull",
    Callback = function()
        KillLocalPlayer()
        Library:Notification({
            Name = "Reset Character",
            Description = "✅️",
            Duration = 2,
            Type = "Warning"
        })
    end
})

task.spawn(function()
    while true do
        task.wait(1)
        if _G.AutoResetPlayer then
            local remaining = math.floor(resetCharTargetTime - tick())
            if remaining <= 0 then
                ResetCountdownLabel:SetRightText("Resetting...")
                KillLocalPlayer()
                task.wait(2)
                ResetCharTimer()
            else
                local m = math.floor(remaining / 60)
                local s = remaining % 60
                ResetCountdownLabel:SetRightText(string.format("%02d:%02d", m, s))
            end
        end
    end
end)

LP.CharacterAdded:Connect(function()
    if _G.AutoResetPlayer then
        ResetCharTimer()
    end
end)

local SettingsTab = Window:Tab({
    Name = "Settings",
    Icon = "settings"
})

local ConfigSubTab = SettingsTab:SubTab({
    Name = "Configs",
    Icon = "folder"
})

ConfigSubTab:ThemeConfig()