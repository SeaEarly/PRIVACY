local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Create UI elements
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.ResetOnSpawn = false

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0.1, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Text = "Auth - Aim Viewer"
titleLabel.TextScaled = true
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.BackgroundTransparency = 1
titleLabel.Parent = screenGui

-- Start Button
local startButton = Instance.new("TextButton")
startButton.Size = UDim2.new(0.2, 0, 0.1, 0)
startButton.Position = UDim2.new(0.4, 0, 0.45, 0)
startButton.Text = "Start"
startButton.TextScaled = true
startButton.TextColor3 = Color3.new(1, 1, 1)
startButton.BackgroundColor3 = Color3.new(0, 0, 0)
startButton.Parent = screenGui

-- Main UI (initially hidden)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.Position = UDim2.new(0, 0, 0, 0)
mainFrame.Visible = false
mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
mainFrame.Parent = screenGui

local userLabel = Instance.new("TextLabel")
userLabel.Size = UDim2.new(1, 0, 0.1, 0)
userLabel.Position = UDim2.new(0, 0, 0, 0)
userLabel.Text = "User: N/A"
userLabel.TextScaled = true
userLabel.TextColor3 = Color3.new(1, 1, 1)
userLabel.BackgroundTransparency = 1
userLabel.Parent = mainFrame

local avatarImage = Instance.new("ImageLabel")
avatarImage.Size = UDim2.new(0.2, 0, 0.4, 0)
avatarImage.Position = UDim2.new(0.4, 0, 0.3, 0)
avatarImage.BackgroundTransparency = 1
avatarImage.Parent = mainFrame

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

local beamPart, beam = createBeam()

local selectedPlayer = nil

-- Update the beam position and direction
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

-- Handle start button click
startButton.MouseButton1Click:Connect(function()
    startButton.Visible = false
    titleLabel.Visible = false
    mainFrame.Visible = true
end)

-- Handle player selection
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.H and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local mouse = LocalPlayer:GetMouse()
        local target = mouse.Target
        if target and target.Parent and Players:GetPlayerFromCharacter(target.Parent) then
            selectedPlayer = Players:GetPlayerFromCharacter(target.Parent)
            userLabel.Text = "User: " .. selectedPlayer.Name
            avatarImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. selectedPlayer.UserId .. "&w=420&h=420"
            game.StarterGui:SetCore("SendNotification", {
                Title = "Aim Viewer",
                Text = "Activated on " .. selectedPlayer.Name,
                Duration = 5
            })
        else
            selectedPlayer = nil
            userLabel.Text = "User: N/A"
            avatarImage.Image = ""
            game.StarterGui:SetCore("SendNotification", {
                Title = "Aim Viewer",
                Text = "Deactivated",
                Duration = 5
            })
        end
    end
end)
