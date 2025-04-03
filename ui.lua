--
local KeyGuardLibrary = loadstring(game:HttpGet("https://cdn.keyguardian.org/library/v1.0.0.lua"))()
local trueData = "32a8738d7e644ad2b469d530b6943449"
local falseData = "6335f41a8d1a475fb973d0bbfe0f20f7"

KeyGuardLibrary.Set({
    publicToken = "d0469cbce3ac4d349882f93d41a284ce",
    privateToken = "7998f6adb25a40d2a8e0af60902318ac",
    trueData = trueData,
    falseData = falseData,
})

local SGLoginUI = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()

-- Tạo ScreenGui
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

-- Màu sắc chủ đạo
local colors = {
    background = Color3.fromRGB(25, 25, 35),
    primary = Color3.fromRGB(30, 100, 200),
    secondary = Color3.fromRGB(50, 50, 70),
    text = Color3.fromRGB(255, 255, 255),
    success = Color3.fromRGB(0, 200, 100),
    error = Color3.fromRGB(220, 53, 69),
    warning = Color3.fromRGB(255, 193, 7)
}

-- Hiệu ứng shadow
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

-- Tạo hiệu ứng
local function CreateTween(instance, properties, duration, easingStyle, easingDirection)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration or 0.3, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out),
        properties
    )
    return tween
end

-- Tạo icon cho thông báo
local function CreateIcon(parent, image, position, size)
    local icon = Instance.new("ImageLabel")
    icon.BackgroundTransparency = 1
    icon.Position = position or UDim2.new(0, 0, 0, 0)
    icon.Size = size or UDim2.new(0, 20, 0, 20)
    icon.Image = image
    icon.Parent = parent
    return icon
end

-- Tạo cửa sổ chính
local function CreateWindow(title)
    -- Container chính
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    mainFrame.BackgroundColor3 = colors.background
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = SGGui
    mainFrame.ZIndex = 10
    
    -- Bo tròn cạnh
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Thêm shadow
    CreateShadow(mainFrame, 0.5)
    
    -- Thanh tiêu đề
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
    
    -- Chỉ bo tròn phía trên
    local titleBottomBar = Instance.new("Frame")
    titleBottomBar.Name = "TitleBottomCover"
    titleBottomBar.Size = UDim2.new(1, 0, 0, 10)
    titleBottomBar.Position = UDim2.new(0, 0, 1, -10)
    titleBottomBar.BackgroundColor3 = colors.primary
    titleBottomBar.BorderSizePixel = 0
    titleBottomBar.ZIndex = 11
    titleBottomBar.Parent = titleBar
    
    -- Tiêu đề
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
    
    -- Nút đóng
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "✕"
    closeButton.TextSize = 18
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
    
    -- Nội dung chính
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, -20, 1, -60)
    contentFrame.Position = UDim2.new(0, 10, 0, 50)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = 3
    contentFrame.ScrollBarImageColor3 = colors.primary
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentFrame.ZIndex = 11
    contentFrame.Parent = mainFrame
    
    -- Layout cho nội dung
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.Parent = contentFrame
    
    -- Tự động điều chỉnh kích thước canvas
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Hiệu ứng xuất hiện
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    local openTween = CreateTween(mainFrame, {Size = UDim2.new(0, 400, 0, 300), Position = UDim2.new(0.5, -200, 0.5, -150)}, 0.5)
    openTween:Play()
    
    -- Kéo cửa sổ
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
    
    -- Các hàm tạo thành phần
    local window = {}
    window.ContentFrame = contentFrame
    window.MainFrame = mainFrame
    
    -- Tạo Label
    function window:CreateLabel(text)
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, -20, 0, 30)
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
    
    -- Tạo Button
    function window:CreateButton(text, callback)
        local buttonFrame = Instance.new("Frame")
        buttonFrame.Name = "ButtonFrame"
        buttonFrame.Size = UDim2.new(1, -20, 0, 40)
        buttonFrame.BackgroundTransparency = 1
        buttonFrame.ZIndex = 11
        buttonFrame.Parent = contentFrame
        
        local button = Instance.new("TextButton")
        button.Name = "Button"
        button.Size = UDim2.new(1, 0, 1, 0)
        button.BackgroundColor3 = colors.primary
        button.BorderSizePixel = 0
        button.Text = text
        button.TextSize = 15
        button.Font = Enum.Font.GothamBold
        button.TextColor3 = colors.text
        button.ZIndex = 12
        button.Parent = buttonFrame
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button
        
        -- Hiệu ứng hover
        button.MouseEnter:Connect(function()
            CreateTween(button, {BackgroundColor3 = Color3.fromRGB(70, 130, 220)}, 0.2):Play()
        end)
        
        button.MouseLeave:Connect(function()
            CreateTween(button, {BackgroundColor3 = colors.primary}, 0.2):Play()
        end)
        
        -- Hiệu ứng nhấn
        button.MouseButton1Down:Connect(function()
            CreateTween(button, {BackgroundColor3 = Color3.fromRGB(50, 100, 180)}, 0.1):Play()
        end)
        
        button.MouseButton1Up:Connect(function()
            CreateTween(button, {BackgroundColor3 = Color3.fromRGB(70, 130, 220)}, 0.1):Play()
        end)
        
        -- Callback
        button.MouseButton1Click:Connect(function()
            if callback then
                callback()
            end
        end)
        
        return button
    end
    
    -- Tạo Toggle
    function window:CreateToggle(text, default, callback)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = "ToggleFrame"
        toggleFrame.Size = UDim2.new(1, -20, 0, 40)
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.ZIndex = 11
        toggleFrame.Parent = contentFrame
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Name = "ToggleButton"
        toggleButton.Size = UDim2.new(0, 50, 0, 25)
        toggleButton.Position = UDim2.new(1, -50, 0.5, -12.5)
        toggleButton.BackgroundColor3 = default and colors.success or colors.secondary
        toggleButton.BorderSizePixel = 0
        toggleButton.Text = ""
        toggleButton.ZIndex = 12
        toggleButton.Parent = toggleFrame
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 25)
        toggleCorner.Parent = toggleButton
        
        local toggleCircle = Instance.new("Frame")
        toggleCircle.Name = "Circle"
        toggleCircle.Size = UDim2.new(0, 21, 0, 21)
        toggleCircle.Position = default and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
        toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleCircle.BorderSizePixel = 0
        toggleCircle.ZIndex = 13
        toggleCircle.Parent = toggleButton
        
        local circleCorner = Instance.new("UICorner")
        circleCorner.CornerRadius = UDim.new(1, 0)
        circleCorner.Parent = toggleCircle
        
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Name = "Label"
        toggleLabel.Size = UDim2.new(1, -60, 1, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = text
        toggleLabel.TextSize = 14
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.TextColor3 = colors.text
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.ZIndex = 12
        toggleLabel.Parent = toggleFrame
        
        local toggled = default or false
        
        local function updateToggle()
            if toggled then
                CreateTween(toggleButton, {BackgroundColor3 = colors.success}, 0.2):Play()
                CreateTween(toggleCircle, {Position = UDim2.new(1, -23, 0.5, -10.5)}, 0.2):Play()
            else
                CreateTween(toggleButton, {BackgroundColor3 = colors.secondary}, 0.2):Play()
                CreateTween(toggleCircle, {Position = UDim2.new(0, 2, 0.5, -10.5)}, 0.2):Play()
            end
            
            if callback then
                callback(toggled)
            end
        end
        
        toggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            updateToggle()
        end)
        
        return {
            Frame = toggleFrame,
            Set = function(value)
                toggled = value
                updateToggle()
            end,
            Get = function()
                return toggled
            end
        }
    end
    
    -- Tạo Slider
    function window:CreateSlider(text, min, max, default, callback)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = "SliderFrame"
        sliderFrame.Size = UDim2.new(1, -20, 0, 50)
        sliderFrame.BackgroundTransparency = 1
        sliderFrame.ZIndex = 11
        sliderFrame.Parent = contentFrame
        
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Name = "Label"
        sliderLabel.Size = UDim2.new(1, 0, 0, 20)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = text
        sliderLabel.TextSize = 14
        sliderLabel.Font = Enum.Font.Gotham
        sliderLabel.TextColor3 = colors.text
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.ZIndex = 12
        sliderLabel.Parent = sliderFrame
        
        local sliderValue = Instance.new("TextLabel")
        sliderValue.Name = "Value"
        sliderValue.Size = UDim2.new(0, 50, 0, 20)
        sliderValue.Position = UDim2.new(1, -50, 0, 0)
        sliderValue.BackgroundTransparency = 1
        sliderValue.Text = tostring(default)
        sliderValue.TextSize = 14
        sliderValue.Font = Enum.Font.GothamBold
        sliderValue.TextColor3 = colors.text
        sliderValue.TextXAlignment = Enum.TextXAlignment.Right
        sliderValue.ZIndex = 12
        sliderValue.Parent = sliderFrame
        
        local sliderOuter = Instance.new("Frame")
        sliderOuter.Name = "SliderOuter"
        sliderOuter.Size = UDim2.new(1, 0, 0, 6)
        sliderOuter.Position = UDim2.new(0, 0, 0, 30)
        sliderOuter.BackgroundColor3 = colors.secondary
        sliderOuter.BorderSizePixel = 0
        sliderOuter.ZIndex = 12
        sliderOuter.Parent = sliderFrame
        
        local sliderOuterCorner = Instance.new("UICorner")
        sliderOuterCorner.CornerRadius = UDim.new(0, 3)
        sliderOuterCorner.Parent = sliderOuter
        
        local sliderInner = Instance.new("Frame")
        sliderInner.Name = "SliderInner"
        sliderInner.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        sliderInner.BackgroundColor3 = colors.primary
        sliderInner.BorderSizePixel = 0
        sliderInner.ZIndex = 13
        sliderInner.Parent = sliderOuter
        
        local sliderInnerCorner = Instance.new("UICorner")
        sliderInnerCorner.CornerRadius = UDim.new(0, 3)
        sliderInnerCorner.Parent = sliderInner
        
        local sliderThumb = Instance.new("Frame")
        sliderThumb.Name = "SliderThumb"
        sliderThumb.Size = UDim2.new(0, 14, 0, 14)
        sliderThumb.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
        sliderThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderThumb.BorderSizePixel = 0
        sliderThumb.ZIndex = 14
        sliderThumb.Parent = sliderOuter
        
        local thumbCorner = Instance.new("UICorner")
        thumbCorner.CornerRadius = UDim.new(1, 0)
        thumbCorner.Parent = sliderThumb
        
        local value = default
        
        local function updateSlider(input)
            local posX = math.clamp(input.Position.X - sliderOuter.AbsolutePosition.X, 0, sliderOuter.AbsoluteSize.X)
            local percentage = posX / sliderOuter.AbsoluteSize.X
            
            value = math.floor(min + (max - min) * percentage)
            value = math.clamp(value, min, max)
            
            sliderValue.Text = tostring(value)
            sliderInner.Size = UDim2.new(percentage, 0, 1, 0)
            sliderThumb.Position = UDim2.new(percentage, -7, 0.5, -7)
            
            if callback then
                callback(value)
            end
        end
        
        local dragging = false
        
        sliderOuter.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                updateSlider(input)
            end
        end)
        
        sliderOuter.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        sliderThumb.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        sliderThumb.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)
        
        return {
            Frame = sliderFrame,
            Set = function(newValue)
                value = math.clamp(newValue, min, max)
                local percentage = (value - min) / (max - min)
                sliderValue.Text = tostring(value)
                sliderInner.Size = UDim2.new(percentage, 0, 1, 0)
                sliderThumb.Position = UDim2.new(percentage, -7, 0.5, -7)
                
                if callback then
                    callback(value)
                end
            end,
            Get = function()
                return value
            end
        }
    end
    
    -- Tạo TextBox
    function window:CreateTextbox(text, placeholder, callback)
        local textboxFrame = Instance.new("Frame")
        textboxFrame.Name = "TextboxFrame"
        textboxFrame.Size = UDim2.new(1, -20, 0, 50)
        textboxFrame.BackgroundTransparency = 1
        textboxFrame.ZIndex = 11
        textboxFrame.Parent = contentFrame
        
        local textboxLabel = Instance.new("TextLabel")
        textboxLabel.Name = "Label"
        textboxLabel.Size = UDim2.new(1, 0, 0, 20)
        textboxLabel.BackgroundTransparency = 1
        textboxLabel.Text = text
        textboxLabel.TextSize = 14
        textboxLabel.Font = Enum.Font.Gotham
        textboxLabel.TextColor3 = colors.text
        textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
        textboxLabel.ZIndex = 12
        textboxLabel.Parent = textboxFrame
        
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
        
        -- Hiệu ứng focus
        textbox.Focused:Connect(function()
            CreateTween(textboxContainer, {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}, 0.2):Play()
        end)
        
        textbox.FocusLost:Connect(function(enterPressed)
            CreateTween(textboxContainer, {BackgroundColor3 = colors.secondary}, 0.2):Play()
            if enterPressed and callback then
                callback(textbox.Text)
            end
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
    
    -- Hiển thị thông báo
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
    
    return window
end

-- Khởi tạo giao diện người dùng
local function InitializeUI()
    -- Khởi tạo window
    local mainWindow = CreateWindow("LOGIN HACK")
    
    -- Tạo label thông tin
    mainWindow:CreateLabel("[+] https://discord.com/invite/gtQ54c43G3")
    
    -- Tạo textbox cho key
    local keyTextbox = mainWindow:CreateTextbox("KEY:", "NHAP KEY TAI DAY...", function(text)
        _G.EnteredKey = text
    end)
    
    -- Tạo button xác nhận
    local verifyButton = mainWindow:CreateButton("====== XAC NHAN KEY HACK ======", function()
        if _G.EnteredKey and _G.EnteredKey ~= "" then
            local response = KeyGuardLibrary.validateDefaultKey(_G.EnteredKey)
            
            if response == trueData then
                mainWindow:Notify("THANH CONG !!!", "LOAD SCRIPT CDVN - DEV BY KDZ...", 4483362458, 3.5)
                LoadMainScript()
                SGGui:Destroy()
            else
                mainWindow:Notify("KHONG THANH CONG", "Key cua ban khong hop le.", 4483362458, 3.5)
            end
        else
            mainWindow:Notify("THONG BAO", "Hay nhap key roi an nut XAC MINH", 4483362458, 3.5)
        end
    end)
    
    -- Các thành phần demo bổ sung (Toggle, Slider)
    local autoToggle = mainWindow:CreateToggle("Auto Farm", false, function(value)
        -- Callback khi toggle thay đổi
    end)
    
    local speedSlider = mainWindow:CreateSlider("Toc Do", 1, 100, 50, function(value)
        -- Callback khi slider thay đổi
    end)
    
    -- Tạo thêm label hướng dẫn
    mainWindow:CreateLabel("Luu y: Chi nhap key duoc cung cap tu Discord.")
    
    -- Hiệu ứng loading
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
        loadingText.Text = "Loading ServiceGame"
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
        loadingSubText.Text = "by SG_TEAM"
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
        
        -- Hiệu ứng loading
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
    
    return mainWindow
end

SGLoginUI.CreateWindow = CreateWindow
SGLoginUI.InitializeUI = InitializeUI

local mainInterface = SGLoginUI.InitializeUI()

return SGLoginUI
