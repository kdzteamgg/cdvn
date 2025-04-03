local KeyGuardLibrary = loadstring(game:HttpGet("https://cdn.keyguardian.org/library/v1.0.0.lua"))()
local trueData = "32a8738d7e644ad2b469d530b6943449"
local falseData = "6335f41a8d1a475fb973d0bbfe0f20f7"

KeyGuardLibrary.Set({
    publicToken = "d0469cbce3ac4d349882f93d41a284ce",
    privateToken = "7998f6adb25a40d2a8e0af60902318ac",
    trueData = trueData,
    falseData = falseData,
})

local KDZUI = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()

local SGGui = Instance.new("ScreenGui")
SGGui.Name = "SGLogin"
SGGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SGGui.ResetOnSpawn = false
SGGui.DisplayOrder = 999
if syn then
    syn.protect_gui(SGGui)
    SGGui.Parent = CoreGui
else
    SGGui.Parent = CoreGui
end

local colors = {
    background = Color3.fromRGB(30, 35, 40),
    primary = Color3.fromRGB(30, 35, 40),
    secondary = Color3.fromRGB(40, 45, 50),
    text = Color3.fromRGB(255, 255, 255),
    success = Color3.fromRGB(0, 200, 100),
    error = Color3.fromRGB(220, 53, 69),
    warning = Color3.fromRGB(255, 193, 7)
}

local function CreateShadow(frame, intensity)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.ZIndex = frame.ZIndex - 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 1 - intensity
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Parent = frame
    return shadow
end

local function CreateTween(instance, properties, duration, easingStyle, easingDirection)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration or 0.3, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out),
        properties
    )
    return tween
end

local function CreateIcon(parent, image, position, size)
    local icon = Instance.new("ImageLabel")
    icon.BackgroundTransparency = 1
    icon.Position = position or UDim2.new(0, 0, 0, 0)
    icon.Size = size or UDim2.new(0, 20, 0, 20)
    icon.Image = image
    icon.Parent = parent
    return icon
end

local function CreateWindow(title)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 346, 0, 113)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -60)
    mainFrame.BackgroundColor3 = colors.background
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = SGGui
    mainFrame.ZIndex = 10
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    CreateShadow(mainFrame, 0.5)
    
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = colors.primary
    titleBar.BorderSizePixel = 0
    titleBar.ZIndex = 11
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    local titleBottomBar = Instance.new("Frame")
    titleBottomBar.Name = "TitleBottomCover"
    titleBottomBar.Size = UDim2.new(1, 0, 0, 10)
    titleBottomBar.Position = UDim2.new(0, 0, 1, -10)
    titleBottomBar.BackgroundColor3 = colors.primary
    titleBottomBar.BorderSizePixel = 0
    titleBottomBar.ZIndex = 11
    titleBottomBar.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Size = UDim2.new(1, -20, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = title
    titleText.TextSize = 18
    titleText.Font = Enum.Font.GothamBold
    titleText.TextColor3 = colors.text
    titleText.TextXAlignment = Enum.TextXAlignment.Center
    titleText.ZIndex = 12
    titleText.Parent = titleBar
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "X"
    closeButton.TextSize = 16
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextColor3 = colors.text
    closeButton.ZIndex = 12
    closeButton.Parent = titleBar
    
    closeButton.MouseButton1Click:Connect(function()
        local closeTween = CreateTween(mainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.5)
        closeTween:Play()
        closeTween.Completed:Wait()
        SGGui:Destroy()
    end)
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, -20, 1, -60)
    contentFrame.Position = UDim2.new(0, 10, 0, 50)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ZIndex = 11
    contentFrame.Parent = mainFrame
    
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    local openTween = CreateTween(mainFrame, {Size = UDim2.new(0, 345, 0, 113), Position = UDim2.new(0.5, -172, 0.5, -56)}, 0.5)
    openTween:Play()

    local dragging, dragInput, dragStart, startPos
    
    local function updateDrag(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateDrag(input)
        end
    end)
    
    local window = {}
    window.ContentFrame = contentFrame
    window.MainFrame = mainFrame
    
    function window:CreateLabel(text)
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, 0, 0, 30)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextSize = 14
        label.Font = Enum.Font.Gotham
        label.TextColor3 = colors.text
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 11
        label.Parent = contentFrame
        
        return label
    end

    function window:CreateTextbox(text, placeholder)
        local textboxFrame = Instance.new("Frame")
        textboxFrame.Name = "TextboxFrame"
        textboxFrame.Size = UDim2.new(1, 0, 0, 50)
        textboxFrame.BackgroundTransparency = 1
        textboxFrame.ZIndex = 11
        textboxFrame.Parent = contentFrame
        
        if text and text ~= "" then
            local textboxLabel = Instance.new("TextLabel")
            textboxLabel.Name = "Label"
            textboxLabel.Size = UDim2.new(1, 0, 0, 15)
            textboxLabel.BackgroundTransparency = 1
            textboxLabel.Text = text
            textboxLabel.TextSize = 14
            textboxLabel.Font = Enum.Font.Gotham
            textboxLabel.TextColor3 = colors.text
            textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            textboxLabel.ZIndex = 12
            textboxLabel.Parent = textboxFrame
        end
        
        local textboxContainer = Instance.new("Frame")
        textboxContainer.Name = "Container"
        textboxContainer.Size = UDim2.new(1, 0, 0, 30)
        textboxContainer.Position = UDim2.new(0, 0, 0, 20)
        textboxContainer.BackgroundColor3 = colors.secondary
        textboxContainer.BorderSizePixel = 0
        textboxContainer.ZIndex = 12
        textboxContainer.Parent = textboxFrame
        
        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = UDim.new(0, 6)
        containerCorner.Parent = textboxContainer
        
        local textbox = Instance.new("TextBox")
        textbox.Name = "TextBox"
        textbox.Size = UDim2.new(1, -20, 1, 0)
        textbox.Position = UDim2.new(0, 10, 0, 0)
        textbox.BackgroundTransparency = 1
        textbox.PlaceholderText = placeholder
        textbox.Text = ""
        textbox.TextSize = 14
        textbox.Font = Enum.Font.Gotham
        textbox.TextColor3 = colors.text
        textbox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
        textbox.TextXAlignment = Enum.TextXAlignment.Left
        textbox.ClearTextOnFocus = false
        textbox.ZIndex = 13
        textbox.Parent = textboxContainer
        
        textbox.Focused:Connect(function()
            CreateTween(textboxContainer, {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}, 0.2):Play()
        end)
        
        textbox:GetPropertyChangedSignal("Text"):Connect(function()
            local keyText = textbox.Text
            _G.EnteredKey = keyText
            
            if #keyText > 30 then
                local response = KeyGuardLibrary.validateDefaultKey(keyText)
                
                if response == trueData then
                    window:Notify("THANH CONG KEY !", "LOAD SCRIPT...", 4483362458, 1.5)
                    
                    local shrinkTween = CreateTween(window.MainFrame, {
                        Size = UDim2.new(0, 0, 0, 0),
                        Position = UDim2.new(0.5, 0, 0.5, 0)
                    }, 1, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                    
                    task.delay(1.5, function()
                        window:Notify("BYPASS", "LOADING...", 4483362458, 2)
                        task.delay(0.5, function()
                            shrinkTween:Play()
                            shrinkTween.Completed:Connect(function()
                                task.delay(0.5, function()
                                    LoadMainScript()
                                    SGGui:Destroy()
                                end)
                            end)
                        end)
                    end)
                else
                    window:Notify("KHONG THANH CONG", "KEY CUA BAN KHONG HOP LE! VUI LONG PASTE KEY KHAC", 4483362458, 3)
                    task.delay(0.5, function()
                        textbox.Text = ""
                    end)
                end
            end
        end)
        
        textbox.FocusLost:Connect(function()
            CreateTween(textboxContainer, {BackgroundColor3 = colors.secondary}, 0.2):Play()
        end)
        
        return {
            Frame = textboxFrame,
            TextBox = textbox,
            Set = function(text)
                textbox.Text = text
            end,
            Get = function()
                return textbox.Text
            end
        }
    end
    
    function window:Notify(title, content, image, duration)
        duration = duration or 3
        
        local notifyFrame = Instance.new("Frame")
        notifyFrame.Name = "Notification"
        notifyFrame.Size = UDim2.new(0, 300, 0, 80)
        notifyFrame.Position = UDim2.new(1, 20, 0.5, -40)
        notifyFrame.BackgroundColor3 = colors.background
        notifyFrame.BorderSizePixel = 0
        notifyFrame.ZIndex = 100
        notifyFrame.Parent = SGGui
        
        local notifyCorner = Instance.new("UICorner")
        notifyCorner.CornerRadius = UDim.new(0, 8)
        notifyCorner.Parent = notifyFrame
        
        local notifyTitle = Instance.new("TextLabel")
        notifyTitle.Name = "Title"
        notifyTitle.Size = UDim2.new(1, -20, 0, 30)
        notifyTitle.Position = UDim2.new(0, 10, 0, 5)
        notifyTitle.BackgroundTransparency = 1
        notifyTitle.Text = title
        notifyTitle.TextSize = 16
        notifyTitle.Font = Enum.Font.GothamBold
        notifyTitle.TextColor3 = colors.text
        notifyTitle.TextXAlignment = Enum.TextXAlignment.Left
        notifyTitle.ZIndex = 101
        notifyTitle.Parent = notifyFrame
        
        local notifyContent = Instance.new("TextLabel")
        notifyContent.Name = "Content"
        notifyContent.Size = UDim2.new(1, -20, 0, 40)
        notifyContent.Position = UDim2.new(0, 10, 0, 35)
        notifyContent.BackgroundTransparency = 1
        notifyContent.Text = content
        notifyContent.TextSize = 14
        notifyContent.Font = Enum.Font.Gotham
        notifyContent.TextColor3 = colors.text
        notifyContent.TextXAlignment = Enum.TextXAlignment.Left
        notifyContent.TextWrapped = true
        notifyContent.ZIndex = 101
        notifyContent.Parent = notifyFrame
        
        if image then
            local notifyImage = Instance.new("ImageLabel")
            notifyImage.Name = "Image"
            notifyImage.Size = UDim2.new(0, 24, 0, 24)
            notifyImage.Position = UDim2.new(1, -34, 0, 10)
            notifyImage.BackgroundTransparency = 1
            notifyImage.Image = "rbxassetid://" .. image
            notifyImage.ZIndex = 101
            notifyImage.Parent = notifyFrame
        end
        
        CreateShadow(notifyFrame, 0.5)
        
        local inTween = CreateTween(notifyFrame, {Position = UDim2.new(1, -320, 0.5, -40)}, 0.5, Enum.EasingStyle.Back)
        inTween:Play()
        
        task.delay(duration, function()
            local outTween = CreateTween(notifyFrame, {Position = UDim2.new(1, 20, 0.5, -40)}, 0.5)
            outTween:Play()
            outTween.Completed:Wait()
            notifyFrame:Destroy()
        end)
    end

    local function ShowLoadingScreen()
        local loadingScreen = Instance.new("Frame")
        loadingScreen.Name = "LoadingScreen"
        loadingScreen.Size = UDim2.new(1, 0, 1, 0)
        loadingScreen.BackgroundColor3 = colors.background
        loadingScreen.BackgroundTransparency = 0.2
        loadingScreen.ZIndex = 150
        loadingScreen.Parent = SGGui
        
        local loadingText = Instance.new("TextLabel")
        loadingText.Name = "LoadingText"
        loadingText.Size = UDim2.new(0, 300, 0, 30)
        loadingText.Position = UDim2.new(0.5, -150, 0.5, -15)
        loadingText.BackgroundTransparency = 1
        loadingText.Text = "KDZ - CHOI GAME LA PHAI CH4AT!"
        loadingText.TextSize = 18
        loadingText.Font = Enum.Font.GothamBold
        loadingText.TextColor3 = colors.text
        loadingText.ZIndex = 151
        loadingText.Parent = loadingScreen
        
        local loadingSubText = Instance.new("TextLabel")
        loadingSubText.Name = "LoadingSubText"
        loadingSubText.Size = UDim2.new(0, 300, 0, 20)
        loadingSubText.Position = UDim2.new(0.5, -150, 0.5, 15)
        loadingSubText.BackgroundTransparency = 1
        loadingSubText.Text = "loading... wait to open menu ><"
        loadingSubText.TextSize = 14
        loadingSubText.Font = Enum.Font.Gotham
        loadingSubText.TextColor3 = colors.text
        loadingSubText.TextTransparency = 0.3
        loadingSubText.ZIndex = 151
        loadingSubText.Parent = loadingScreen
        
        local loadingBar = Instance.new("Frame")
        loadingBar.Name = "LoadingBar"
        loadingBar.Size = UDim2.new(0, 300, 0, 6)
        loadingBar.Position = UDim2.new(0.5, -150, 0.5, 40)
        loadingBar.BackgroundColor3 = colors.secondary
        loadingBar.BorderSizePixel = 0
        loadingBar.ZIndex = 151
        loadingBar.Parent = loadingScreen
        
        local loadingBarCorner = Instance.new("UICorner")
        loadingBarCorner.CornerRadius = UDim.new(0, 3)
        loadingBarCorner.Parent = loadingBar
        
        local loadingProgress = Instance.new("Frame")
        loadingProgress.Name = "Progress"
        loadingProgress.Size = UDim2.new(0, 0, 1, 0)
        loadingProgress.BackgroundColor3 = colors.primary
        loadingProgress.BorderSizePixel = 0
        loadingProgress.ZIndex = 152
        loadingProgress.Parent = loadingBar
        
        local progressCorner = Instance.new("UICorner")
        progressCorner.CornerRadius = UDim.new(0, 3)
        progressCorner.Parent = loadingProgress

        CreateTween(loadingProgress, {Size = UDim2.new(1, 0, 1, 0)}, 2, Enum.EasingStyle.Quad):Play()
        
        task.delay(2, function()
            CreateTween(loadingScreen, {BackgroundTransparency = 1}, 0.5):Play()
            CreateTween(loadingText, {TextTransparency = 1}, 0.5):Play()
            CreateTween(loadingSubText, {TextTransparency = 1}, 0.5):Play()
            CreateTween(loadingBar, {BackgroundTransparency = 1}, 0.5):Play()
            CreateTween(loadingProgress, {BackgroundTransparency = 1}, 0.5):Play()
            
            task.delay(0.5, function()
                loadingScreen:Destroy()
            end)
        end)
    end
    
    ShowLoadingScreen()
    wait(2)

    return window
end

local function InitializeUI()
    local mainWindow = CreateWindow("KDZ - LOGIN HACK")
    
    local keyTextbox = mainWindow:CreateTextbox("KEY:", "VD: SG_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
    
    
    task.delay(3, function()
        mainWindow:Notify("THONG BAO", "HAY PASTE KEY VAO O KEY.", 4483362458, 4)
    end)
    
    return mainWindow
end

KDZUI.CreateWindow = CreateWindow
KDZUI.InitializeUI = InitializeUI

local mainInterface = KDZUI.InitializeUI()

return KDZUI
