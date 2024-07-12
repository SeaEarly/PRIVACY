local DiscordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/discord"))()

local win = DiscordLib:Window("Authlest - Aim Viewer")

local serv = win:Server("Aim Viewer", "")

local btns = serv:Channel("Controls")

btns:Button(
    "Start Aim Viewer",
    function()
        DiscordLib:Notification("Notification", "Aim Viewer started!", "Okay!")
        startAimViewer()
    end
)

btns:Seperator()

btns:Button(
    "Stop Aim Viewer",
    function()
        DiscordLib:Notification("Notification", "Aim Viewer stopped!", "Okay!")
        stopAimViewer()
    end
)

local lbls = serv:Channel("Info")

lbls:Label("Press Ctrl+H to select a target.")

serv:Channel("by dawid#7205")

win:Server("Main", "http://www.roblox.com/asset/?id=6031075938")

-- Aim Viewer Functionality

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local selectedPlayer = nil
local beamPart, beam = nil, nil

-- Function to create a beam
local function createBeam()
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.Size = Vector3.new(0.1, 0.1, 0.1)
    part.Transparency = 1
    part.Parent = game.Workspace

    local attachment0 = Instance.new("Attachment", part)
    local attachment1 = Instance.new("Attachment", part)

    local beam = Instance.new("Beam")
    beam.Attachment0 = attachment0
    beam.Attachment1 = attachment1
    beam.FaceCamera = true
    beam.Color = ColorSequence.new(Color3.new(1, 0, 0))
    beam.Width0 = 0.1
    beam.Width1 = 0.1
    beam.Parent = part

    return part, beam
end

-- Start Aim Viewer
function startAimViewer()
    beamPart, beam = createBeam()
    RunService.RenderStepped:Connect(function()
        if selectedPlayer and selectedPlayer.Character then
            local head = selectedPlayer.Character:FindFirstChild("Head")
            if head then
                beamPart.Position = head.Position
                beam.Attachment0.WorldPosition = head.Position
                local cameraCFrame = workspace.CurrentCamera.CFrame
                beam.Attachment1.WorldPosition = cameraCFrame.Position + cameraCFrame.LookVector * 500
            end
        end
    end)
end

-- Stop Aim Viewer
function stopAimViewer()
    if beamPart then
        beamPart:Destroy()
        beamPart = nil
        beam = nil
    end
    selectedPlayer = nil
end

-- Handle player selection
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.H and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local mouse = LocalPlayer:GetMouse()
        local target = mouse.Target
        if target and target.Parent and Players:GetPlayerFromCharacter(target.Parent) then
            selectedPlayer = Players:GetPlayerFromCharacter(target.Parent)
            DiscordLib:Notification("Notification", "Activated Aim Viewer on " .. selectedPlayer.Name, "Okay!")
        else
            selectedPlayer = nil
            DiscordLib:Notification("Notification", "Deactivated Aim Viewer", "Okay!")
        end
    end
end)
