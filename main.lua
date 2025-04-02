local startArgs = {...} or {}

if not game.Loaded then
    repeat game.Loaded:Wait() until game:IsLoaded()
end

local Lib = {}

do
    Lib = {
        IsOpen = true,
        Categories = {},
        Sections = {},
        Flags = {},
        UnnamedFlags = 0,
        Notifications = {},
        AccentObjects = {},
        Moderators = {},
        VisValues = {},
        Keybinds = {
            [Enum.KeyCode.Space] = "Space",
            [Enum.KeyCode.Zero] = "0",
            [Enum.KeyCode.One] = "1",
            [Enum.KeyCode.Two] = "2",
            [Enum.KeyCode.Three] = "3",
            [Enum.KeyCode.Four] = "4",
            [Enum.KeyCode.Five] = "5",
            [Enum.KeyCode.Six] = "6",
            [Enum.KeyCode.Seven] = "7",
            [Enum.KeyCode.Eight] = "8",
            [Enum.KeyCode.Nine] = "9",
            [Enum.KeyCode.BackSlash] = "Backslash",
            [Enum.KeyCode.QuotedDouble] = '"',
            [Enum.KeyCode.Hash] = "#",
            [Enum.KeyCode.Quote] = "'",
            [Enum.KeyCode.Plus] = "+",
            [Enum.KeyCode.Minus] = "-",
            [Enum.KeyCode.Comma] = ",",
            [Enum.KeyCode.Period] = ".",
            [Enum.KeyCode.Colon] = ":",
            [Enum.KeyCode.Semicolon] = ";",
            [Enum.KeyCode.Equals] = "=",
            [Enum.KeyCode.LeftBracket] = "[",
            [Enum.KeyCode.RightBracket] = "]",
            [Enum.KeyCode.LeftAlt] = "LAlt",
            [Enum.KeyCode.RightAlt] = "RAlt",
            [Enum.KeyCode.Backquote] = "`",
            [Enum.KeyCode.Tilde] = "~",
            [Enum.KeyCode.Delete] = "Del",
            [Enum.KeyCode.CapsLock] = "Caps",
            [Enum.KeyCode.LeftControl] = "LCtrl",
            [Enum.KeyCode.RightControl] = "RCtrl",
            [Enum.KeyCode.LeftShift] = "LShift",
            [Enum.KeyCode.RightShift] = "RShift",
            [Enum.UserInputType.MouseButton1] = "MB1",
            [Enum.UserInputType.MouseButton2] = "MB2",
            [Enum.UserInputType.MouseButton3] = "MB3",
        },
        watermark = nil,
        fileext = startArgs.fileext or ".cfg",
        Blur = nil,
        ScreenGui = nil,
        Main = nil,
        DropdownOpen = false,
        FontSize = 14,
        Font = Font.new("rbxassetid://11702779409", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
        DescFont = Font.new("rbxassetid://11702779409", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
        UIOpenKey = Enum.KeyCode.RightShift,
        CheatName = "VaporWave",
        FolderName = "VaporWave",
        Game = startArgs.Game or "FallenSurvival",
        Logo = "75179054628039",
        Accent = Color3.fromRGB(88, 89, 195),
        SuccessIcon = "rbxassetid://91044822637599",
        ErrorIcon = "rbxassetid://4458805208",
        WarningIcon = "rbxassetid://18638286567",
        SuccessColor = Color3.fromRGB(134, 255, 97),
        ErrorColor = Color3.fromRGB(255, 106, 108),
        WarningColor = Color3.fromRGB(255, 106, 108)
    }

    if not isfolder(Lib.FolderName) then
        makefolder(Lib.FolderName)
    end

    if not isfolder(Lib.FolderName .. "/Configs") then
        makefolder(Lib.FolderName .. "/Configs")
    end

    if not isfolder(Lib.FolderName .. "/Configs/" .. Lib.Game) then
        makefolder(Lib.FolderName .. "/Configs/" .. Lib.Game)
    end

    local Flags = {}

    Lib.__index = Lib
    Lib.Categories.__index = Lib.Categories
    Lib.Sections.__index = Lib.Sections
    local TweenService = cloneref(game:GetService("TweenService"))
    local RunService = cloneref(game:GetService("RunService"))
    local Players = cloneref(game:GetService("Players"))
    local UserInputService = cloneref(game:GetService("UserInputService"))
    local Lighting = cloneref(game:GetService("Lighting"))
    local LocalPlayer = Players.LocalPlayer
    local Mouse = LocalPlayer:GetMouse()

    do
        --
        function Lib:Connection(signal, callback)
            local connection = signal:Connect(callback)
            return connection
        end
        --
        function Lib:RGBA(r,g,b,alpha)
            local rgb = Color3.fromRGB(r,g,b)
            local mt = table.clone(getrawmetatable(rgb))

            setreadonly(mt, false)
            local old = mt.__index

            mt.__index = newcclosure(function(self, key)
                if key:lower() == "transparency" then
                    return alpha
                end
                return old(self, key)
            end)

            setrawmetatable(rgb, mt)
            return rgb
        end
        --
        function Lib:Disconnection(connection)
            connection:Disconnect()
        end
        --
        function Lib.NextFlag()
            Lib.UnnamedFlags = Lib.UnnamedFlags + 1
            return string.format("%.14g", Lib.UnnamedFlags)
        end
        --
        function Lib:Round(num, float)
            return float * math.floor(num / float)
        end
        --
        function Lib:SetConfig(file)
            local Config = readfile(file)
            local table = string.split(Config, "\n")
            local table2 = {}

            for i,v in pairs(table) do
                local table3 = string.split(v, ":")

                if table3[1] ~= "Config_List" and #table3 >= 2 then
                    local value = table3[2]:sub(2, #table3[2])

                    if value:sub(1,3) == "rgb" then
                        local table4 = string.split(value:sub(5, #value - 1), ",")

                        value = table4
                    elseif value:sub(1,3) == "key" then
                        local table4 = string.split(value:sub(5, #value - 1), ",")

                        if table4[1] == "nil" and table4[2] == "nil" then
                            table4[1] = nil
                            table4[2] = nil
                        end

                        value = table4
                    elseif value:sub(1,4) == "bool" then
                        local bool = value:sub(6, #value - 1)

                        value = bool == "true"
                    elseif value:sub(1,5) == "table" then
                        local table4 = string.split(value:sub(7, #value - 1), ",")
                        
                        value = table4
                    elseif value:sub(1,6) == "string" then
                        local string = value:sub(8, #value-1)

                        value = string
                    elseif value:sub(1,6) == "number" then
                        local number = value:sub(8, #value - 1)

                        value = number
                    end

                    table2[table3[1]] = value
                end
            end

            for i,v in pairs(table2) do
                if Flags[i] then
                    if typeof(Flags[i]) == "table" then
                        Flags[i]:Set(v)
                    else
                        Flags[i](v)
                    end
                end
            end
        end
        --
        function Lib:GetConfig()
            local Config = ""

            for i,v in pairs(self.Flags) do
                if i ~= "Config_List" and i ~= "Config_Load" and i ~= "Config_Save" then
                    local v2 = v
                    local final = ""

                    if typeof(v2) == "Color3" then
                        local hue,sat,val = v2:ToHSV()

                        final = ("rgb(%s,%s,%s,%s)"):format(hue, sat, val, 1)
                    elseif typeof(v2) == "table" and v2.Color and v2.Transparency then
                        local hue,sat,val = v2.Color:ToHSV()

                        final = ("rgb(%s,%s,%s,%s)"):format(hue, sat, val, v2.Transparency)
                    elseif typeof(v2) == "table" and v.Mode then
                        local values = v.current
                        
                        final = ("key(%s,%s,%s)"):format(values[1] or "nil", values[2] or nil, v.Mode)
                    elseif v2 ~= nil then
                        if typeof(v2) == "boolean" then
                            v2 = ("bool(%s)"):format(tostring(v2))
                        elseif typeof(v2) == "table" then
                            local new = "table("

                            for ii,vv in pairs(v2) do
                                new = new .. vv .. ","

                            end

                            if new:sub(#new) == "," then
                                new = new:sub(0, #new - 1)
                            end

                            v2 = new .. ")"
                        elseif typeof(v2) == "string" then
                            v2 = ("string(%s)"):format(v2)
                        elseif typeof(v2) == "number" then
                            v2 = ("number(%s)"):format(v2)
                        end

                        final = v2
                    end

                    Config = Config .. i .. ": " .. tostring(final) .. "\n"
                end
            end

            return Config
        end
        --
        function Lib:MouseOverUI(UI)
            local pos, size = UI.AbsolutePosition, UI.AbsoluteSize

            if Mouse.X >= pos.X and Mouse.X <= pos.x + size.x and Mouse.Y >= pos.Y and Mouse.Y <= pos.Y + size.Y then
                return true
            end

            return false
        end
        --
        do
            function Lib:NewPicker(name, default, parent, count, flag, callback)
                -- // Instances
                local ColorpickerFrame = Instance.new("ImageButton")
                ColorpickerFrame.Name = "Colorpicker_frame"
                ColorpickerFrame.BackgroundColor3 = default
                ColorpickerFrame.BackgroundTransparency = 1
                ColorpickerFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ColorpickerFrame.BorderSizePixel = 0
                ColorpickerFrame.ImageTransparency = 1
                ColorpickerFrame.Position = UDim2.new(0, 155, 0, 12)
                ColorpickerFrame.Size = UDim2.new(0, 13, 0, 13)
                ColorpickerFrame.AnchorPoint = Vector2.new(0.5,0.5)
                ColorpickerFrame.Image = "rbxassetid://79916232031953"
                ColorpickerFrame.ImageColor3 = Color3.fromRGB(200, 200, 200)
                ColorpickerFrame.AutoButtonColor = false
    
                ColorpickerFrame.Parent = parent
    
                local Colorpicker = Instance.new("TextButton")
                Colorpicker.Name = "Colorpicker"
                Colorpicker.BackgroundColor3 = Color3.fromRGB(25, 25, 33)
                Colorpicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Colorpicker.BorderSizePixel = 0
                Colorpicker.Position = UDim2.new(0, ColorpickerFrame.AbsolutePosition.X - 100, 0, ColorpickerFrame.AbsolutePosition.Y - 50)
                Colorpicker.Size = UDim2.new(0, 180, 0, 195)
                Colorpicker.Parent = Lib.ScreenGui
                Colorpicker.ZIndex = 100
                Colorpicker.Visible = false
                Colorpicker.Text = ""
                Colorpicker.AutoButtonColor = false

                local H,S,V = default:ToHSV()
                local ImageLabel = Instance.new("ImageLabel")
                ImageLabel.Name = "ImageLabel"
                ImageLabel.Image = "rbxassetid://11970108040"
                ImageLabel.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
                ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ImageLabel.BorderSizePixel = 0
                ImageLabel.Position = UDim2.new(0.0556, 0, 0.026, 0)
                ImageLabel.Size = UDim2.new(0, 160, 0, 154)
                ImageLabel.Parent = Colorpicker
    
                local UICorner = Instance.new("UICorner")
                UICorner.Name = "UICorner"
                UICorner.CornerRadius = UDim.new(0, 6)
                UICorner.Parent = Colorpicker
    
                local ImageButton = Instance.new("ImageButton")
                ImageButton.Name = "ImageButton"
                ImageButton.Image = "rbxassetid://14684562507"
                ImageButton.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
                ImageButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ImageButton.BorderSizePixel = 0
                ImageButton.Position = UDim2.new(0.056, 0, 0.026, 0)
                ImageButton.Size = UDim2.new(0, 160, 0, 154)
                ImageButton.AutoButtonColor = false
    
                local SVSlider = Instance.new("Frame")
                SVSlider.Name = "SV_slider"
                SVSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SVSlider.BackgroundTransparency = 1
                SVSlider.ClipsDescendants = true
                SVSlider.Position = UDim2.new(0.855, 0, 0.0966, 0)
                SVSlider.Size = UDim2.new(0,7,0,7)
                SVSlider.ZIndex = 3
    
                local Val = Instance.new("ImageLabel")
                Val.Name = "Val"
                Val.Image = "http://www.roblox.com/asset/?id=14684563800"
                Val.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Val.BackgroundTransparency = 1
                Val.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Val.BorderSizePixel = 0
                Val.Size = UDim2.new(1, 0, 1, 0)
                Val.Parent = ImageButton
    
                local UICorner1 = Instance.new("UICorner")
                UICorner1.Name = "UICorner"
                UICorner1.CornerRadius = UDim.new(0, 100)
                UICorner1.Parent = SVSlider
    
                local UIStroke = Instance.new("UIStroke")
                UIStroke.Name = "UIStroke"
                UIStroke.Color = Color3.fromRGB(255, 255, 255)
                UIStroke.Parent = SVSlider
    
                SVSlider.Parent = ImageButton

                local Alpha = Instance.new("ImageButton")
                Alpha.Name = "Alpha"
                Alpha.AutoButtonColor = false
                Alpha.BackgroundTransparency = 1
                Alpha.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Alpha.Image = "rbxassetid://99404426619313"
                Alpha.BorderColor3 = Color3.fromRGB(17,17,17)
                Alpha.BorderSizePixel = 0
                Alpha.AnchorPoint = Vector2.new(0.5,0)
                Alpha.Position = UDim2.new(0.5, 0,0, 180)
                Alpha.Size = UDim2.new(0, 160,0, 8)
                Alpha.Parent = Colorpicker

                local UICorner4 = Instance.new("UICorner")
                UICorner4.Name = "UICorner"
                UICorner4.Parent = Alpha

                local Frame2 = Instance.new("Frame")
                Frame2.Name = "Frame"
                Frame2.BackgroundColor3 = Color3.fromRGB(254, 254, 254)
                Frame2.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Frame2.BorderSizePixel = 0
                Frame2.Position = UDim2.new(0.926, 0,0.5, 0)
                Frame2.Size = UDim2.new(0, 12,0, 12)
                Frame2.AnchorPoint = Vector2.new(0,0.5)
                Frame2.ZIndex = 45
    
                local UICorner2 = Instance.new("UICorner")
                UICorner2.Name = "UICorner"
                UICorner2.Parent = Frame2
                UICorner2.CornerRadius = UDim.new(1,0)

                Frame2.Parent = Alpha
    
                ImageButton.Parent = Colorpicker
    
                local ImageButton1 = Instance.new("ImageButton")
                ImageButton1.Name = "ImageButton"
                ImageButton1.Image = "http://www.roblox.com/asset/?id=16789872274"
                ImageButton1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ImageButton1.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ImageButton1.BorderSizePixel = 0
                ImageButton1.Position = UDim2.new(0.5, 0,0, 165)
                ImageButton1.Size = UDim2.new(0, 160,0, 8)
                ImageButton1.AutoButtonColor = false
                ImageButton1.AnchorPoint = Vector2.new(0.5,0)
                ImageButton1.BackgroundTransparency = 1
    
                local Frame = Instance.new("Frame")
                Frame.Name = "Frame"
                Frame.BackgroundColor3 = Color3.fromRGB(254, 254, 254)
                Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Frame.BorderSizePixel = 0
                Frame.Position = UDim2.new(0.926, 0,0.5, 0)
                Frame.Size = UDim2.new(0, 12,0, 12)
                Frame.AnchorPoint = Vector2.new(0,0.5)
                Frame.ZIndex = 45
    
                local UICorner2 = Instance.new("UICorner")
                UICorner2.Name = "UICorner"
                UICorner2.Parent = Frame
                UICorner2.CornerRadius = UDim.new(1,0)
    
                local UICorner3 = Instance.new("UICorner")
                UICorner3.Name = "UICorner"
                UICorner3.Parent = ImageButton1

                local UIScale = Instance.new("UIScale")
                UIScale.Parent = Colorpicker
    
                Frame.Parent = ImageButton1
    
                ImageButton1.Parent = Colorpicker
    
                -- // Connections
                local mouseover = false
                local hue, sat, val = default:ToHSV()
                local hsv = default:ToHSV()
                local alpha = 0
                local oldcolor = hsv
                local slidingsaturation = false
                local slidinghue = false
                local slidingalpha = false
    
                local function update()
                    local real_pos = game:GetService("UserInputService"):GetMouseLocation()
                    local mouse_position = Vector2.new(real_pos.X - 3, real_pos.Y - 60)
                    local relative_palette = (mouse_position - ImageButton.AbsolutePosition)
                    local relative_hue     = (mouse_position - ImageButton1.AbsolutePosition)
                    local relative_alpha   = (mouse_position - Alpha.AbsolutePosition)
                    --
                    if slidingsaturation then
                        sat = math.clamp(1 - relative_palette.X / ImageButton.AbsoluteSize.X, 0, 1)
                        val = math.clamp(1 - relative_palette.Y / ImageButton.AbsoluteSize.Y, 0, 1)
                    elseif slidinghue then
                        hue = math.clamp(relative_hue.X / ImageButton.AbsoluteSize.X, 0, 1)
                    elseif slidingalpha then
                        alpha = math.clamp(relative_alpha.X / Alpha.AbsoluteSize.X, 0, 1)
                    end
    
                    hsv = Color3.fromHSV(hue, sat, val)
                    TweenService:Create(SVSlider, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(math.clamp(1 - sat, 0.000, 1 - 0.055), 0, math.clamp(1 - val, 0.000, 1 - 0.045), 0)}):Play()
                    ImageButton.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                    --[[ColorpickerFrame.BackgroundColor3 = hsv
                    ColorpickerFrame.ImageColor3 = hsv
                    ColorpickerFrame.ImageTransparency = math.clamp(1 - alpha, 0.5, 1)]]
                    Alpha.ImageColor3 = hsv
                    --ColorpickerFrame.BackgroundTransparency = alpha
    
                    TweenService:Create(Frame, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(math.clamp(hue, 0.000, 0.982),-5,0.5,0)}):Play()
                    TweenService:Create(Frame2, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(math.clamp(alpha, 0.000, 0.982),-5,0.5,0)}):Play()
    
                    if flag then
                        Lib.Flags[flag] = Lib:RGBA(hsv.r * 255, hsv.g * 255, hsv.b * 255, alpha)
                    end
    
                    callback(Lib:RGBA(hsv.r * 255, hsv.g * 255, hsv.b * 255, alpha))
                end
    
                local function set(color, a)
                    if type(color) == "table" then
                        a = color[4]
                        color = Color3.fromHSV(color[1], color[2], color[3])
                    end
                    if type(color) == "string" then
                        color = Color3.fromHex(color)
                    end
    
                    local oldcolor = hsv
                    local oldalpha = a
    
                    hue, sat, val = color:ToHSV()
                    alpha = a or 1
                    hsv = Color3.fromHSV(hue, sat, val)
    
                    if hsv ~= oldcolor then
                        --[[ColorpickerFrame.BackgroundColor3 = hsv
                        ColorpickerFrame.ImageColor3 = hsv
                        ColorpickerFrame.ImageTransparency = math.clamp(1 - alpha, 0.5, 1)]]
                        Alpha.ImageColor3 = hsv
                        --ColorpickerFrame.BackgroundTransparency = alpha
                        TweenService:Create(SVSlider, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(math.clamp(1 - sat, 0.000, 1 - 0.055), 0, math.clamp(1 - val, 0.000, 1 - 0.045), 0)}):Play()
                        ImageButton.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                        TweenService:Create(Frame, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(math.clamp(hue, 0.000, 0.982),-5,0.5,0)}):Play()
                        TweenService:Create(Frame2, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(math.clamp(alpha, 0.000, 0.982),-5,0.5,0)}):Play()
    
                        if flag then
                            Lib.Flags[flag] = Lib:RGBA(hsv.r * 255, hsv.g * 255, hsv.b * 255, alpha)
                        end
    
                        callback(Lib:RGBA(hsv.r * 255, hsv.g * 255, hsv.b * 255, alpha))
                    end
                end
    
                Flags[flag] = set
    
                set(default, 0)
    
                ImageButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        slidingsaturation = true
                        update()
                    end
                end)
    
                ImageButton.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        slidingsaturation = false
                        update()
                    end
                end)
    
                ImageButton1.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        slidinghue = true
                        update()
                    end
                end)
    
                ImageButton1.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        slidinghue = false
                        update()
                    end
                end)

                Alpha.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        slidingalpha = true
                        update()
                    end
                end)
    
                Alpha.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        slidingalpha = false
                        update()
                    end
                end)
    
                Lib:Connection(game:GetService("UserInputService").InputChanged, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        if slidinghue then
                            update()
                        end
    
                        if slidingsaturation then
                            update()
                        end

                        if slidingalpha then
                            update()
                        end
                    end
                end)
    
                local colorpickertypes = {}
    
                function colorpickertypes:Set(color, newalpha)
                    set(color, newalpha)
                end
    
                Lib:Connection(game:GetService("UserInputService").InputBegan, function(Input)
                    if Colorpicker.Visible and Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if not Lib:MouseOverUI(Colorpicker) and not Lib:MouseOverUI(ColorpickerFrame) then
                            Colorpicker.Position = UDim2.new(0, ColorpickerFrame.AbsolutePosition.X - 100, 0, ColorpickerFrame.AbsolutePosition.Y + 25)
                            TweenService:Create(Colorpicker, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = UDim2.new(0, ColorpickerFrame.AbsolutePosition.X - 100, 0, ColorpickerFrame.AbsolutePosition.Y)}):Play()
                            task.spawn(function()
                                task.wait(0.1)
                                Colorpicker.Visible = false
                                parent.ZIndex = 1
                                Lib.Cooldown = false
                            end)
                        end
                    elseif Colorpicker.Visible and Input.KeyCode == Lib.UIOpenKey then
                        Colorpicker.Position = UDim2.new(0, ColorpickerFrame.AbsolutePosition.X - 100, 0, ColorpickerFrame.AbsolutePosition.Y + 25)
                        TweenService:Create(Colorpicker, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = UDim2.new(0, ColorpickerFrame.AbsolutePosition.X - 100, 0, ColorpickerFrame.AbsolutePosition.Y)}):Play()
                        task.spawn(function()
                            task.wait(0.1)
                            Colorpicker.Visible = false
                            parent.ZIndex = 1
                            Lib.Cooldown = false
                        end)
                    end
                end)
    
                ColorpickerFrame.MouseButton1Down:Connect(function()
                    if Colorpicker.Visible == false then
                        Colorpicker.Position = UDim2.new(0, ColorpickerFrame.AbsolutePosition.X - 100, 0, ColorpickerFrame.AbsolutePosition.Y)
                        TweenService:Create(Colorpicker, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, ColorpickerFrame.AbsolutePosition.X - 100, 0, ColorpickerFrame.AbsolutePosition.Y + 25)}):Play()
                    end
                    Colorpicker.Visible = true
                    parent.ZIndex = 100
                    Lib.Cooldown = true
    
                    if slidinghue then
                        slidinghue = false
                    end
    
                    if slidingsaturation then
                        slidingsaturation = false
                    end

                    if slidingalpha then
                        slidingalpha = false
                    end
                end)
    
                return colorpickertypes, Colorpicker
            end
        end
        --
        function Lib:SetUIOpen(bool)
            if typeof(bool) == 'boolean' then
                Lib.IsOpen = bool
                if Lib.IsOpen then
                    if Lib.watermark then
                        Lib.watermark.Interactable = true
                    end
                    Lib.Main.Interactable = true
                    Lib.Main.Visible = true
                    Lib.Blur.Enabled = true
                    TweenService:Create(Lib.Blur, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = 10}):Play()
                    TweenService:Create(Lib.Main, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
                    TweenService:Create(Lib.Main.UIScale, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Scale = 1}):Play()
                    for i,v in pairs(Lib.Main:GetDescendants()) do
                        if v:IsA("ImageLabel") and v.Name ~= "Depth" then
                            TweenService:Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
                        elseif v:IsA("ImageLabel") and v.Name == "Depth" then
                            TweenService:Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = 0.65}):Play()
                        elseif v:IsA("Frame") and v.Name == "Line1" then
                            TweenService:Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
                        elseif v:IsA("TextLabel") then
                            TweenService:Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
                        end
                    end
                else
                    TweenService:Create(Lib.Blur, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = 0}):Play()
                    TweenService:Create(Lib.Main, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
                    TweenService:Create(Lib.Main.UIScale, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Scale = 0.8}):Play()
                    for i,v in pairs(Lib.Main:GetDescendants()) do
                        if v:IsA("ImageLabel") then
                            TweenService:Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
                        elseif v:IsA("Frame") and v.Name == "Line1" then
                            TweenService:Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
                        elseif v:IsA("TextLabel") then
                            TweenService:Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
                        end
                    end
                    task.wait(0.15)
                    if Lib.watermark then
                        Lib.watermark.Interactable = false
                    end
                    Lib.Blur.Enabled = false
                    Lib.Main.Visible = false
                    Lib.Main.Interactable = false
                end
            end
        end
        --
    end

    function Lib:UpdateNotifs(pos, offset)
        for i,v in pairs(Lib.Notifications) do
            TweenService:Create(v.Container, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {Position = UDim2.new(0,pos.X,0,pos.Y + (i * offset))}):Play()
        end
    end

    function Lib:Notificate(msg, type, dur)
        local notif = {Objects = {}, Container = nil}

        local spawnPos = Vector2.new(50,40)
        local offset = 40

        local NewIndex = Instance.new("Frame")
        NewIndex.Size = UDim2.fromOffset(0,28)
        NewIndex.Name = "NewInd"
        NewIndex.BackgroundColor3 = Color3.fromRGB(25, 25, 33)
        NewIndex.BackgroundTransparency = 1
        NewIndex.AutomaticSize = Enum.AutomaticSize.X
        NewIndex.Parent = Lib.ScreenGui
        notif.Container = NewIndex

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0,6)
        UICorner.Parent = NewIndex

        local UIStroke = Instance.new("UIStroke")
        UIStroke.Color = Color3.fromRGB(58, 57, 74)
        UIStroke.Thickness = 1.25
        UIStroke.Parent = NewIndex

        local Line = Instance.new("Frame")
        Line.Position = UDim2.new(0,30,0.121,0)
        Line.Size = UDim2.new(0,1,0.75,0)
        Line.BackgroundColor3 = Color3.fromRGB(58, 57, 74)
        Line.Name = "Line"
        Line.BackgroundTransparency = 1
        Line.Parent = NewIndex

        local Holder = Instance.new("Frame")
        Holder.BackgroundTransparency = 1
        Holder.Size = UDim2.new(1,5,1,0)
        Holder.Name = "Holder"
        Holder.Parent = NewIndex

        local Title = Instance.new("TextLabel")
        Title.Name = "Title"
        Title.AutomaticSize = Enum.AutomaticSize.X
        Title.AnchorPoint = Vector2.new(0,0.5)
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0,40,0.5,0)
        Title.Size = UDim2.new(0,0,0.579,0)
        Title.FontFace = Lib.Font
        Title.TextColor3 = Color3.fromRGB(255,255,255)
        Title.RichText = true
        Title.TextSize = Lib.FontSize
        Title.Text = msg
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.TextTransparency = 1
        Title.Parent = Holder

        local Icon = Instance.new("ImageLabel")
        Icon.BackgroundTransparency = 1
        Icon.Name = "Icon"
        Icon.Position = UDim2.new(0,15,0.5,0)
        Icon.Size = UDim2.new(0,18,0,18)
        Icon.AnchorPoint = Vector2.new(0.5,0.5)
        Icon.Image = Lib[type.."Icon"]
        Icon.ImageColor3 = Lib[type.."Color"]
        Icon.ImageTransparency = 1
        Icon.Parent = NewIndex

        function notif:remove()
            table.remove(Lib.Notifications, table.find(Lib.Notifications, notif))
            Lib:UpdateNotifs(spawnPos, offset)
            task.wait(0.5)
            NewIndex:Destroy()
        end

        task.spawn(function()
            TweenService:Create(NewIndex, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(0,35)}):Play()
            TweenService:Create(NewIndex, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
            for i,v in pairs(NewIndex:GetDescendants()) do
                if v:IsA("Frame") and v.Name ~= "Holder" then
                    TweenService:Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
                elseif v:IsA("ImageLabel") then
                    TweenService:Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
                elseif v:IsA("TextLabel") then
                    TweenService:Create(v, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
                end
            end

            task.wait(dur)

            TweenService:Create(NewIndex, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(0,28)}):Play()

            for i,v in pairs(NewIndex:GetDescendants()) do
                if v:IsA("Frame") and v.Name ~= "Holder" then
                    TweenService:Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
                elseif v:IsA("ImageLabel") then
                    TweenService:Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
                elseif v:IsA("TextLabel") then
                    TweenService:Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
                end
            end
            TweenService:Create(NewIndex, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
        end)

        task.delay(dur + 0.1,function()
            notif:remove()
        end)


        table.insert(Lib.Notifications, notif)
        Lib:UpdateNotifs(spawnPos, offset)
        NewIndex.Position = UDim2.new(0,spawnPos.X,0,spawnPos.Y + table.find(Lib.Notifications, notif) * offset)
        
        return notif
    end

    do
        local Categories = Lib.Categories
        local Sections = Lib.Sections

        function Lib:Create(args)
            if not args then args = {} end

            local window = {
                Size = args.Size or UDim2.new(0,600,0,400),
                categories = {},
                dragging = {false, UDim2.new(0,0,0,0)},
                elements = {},
            }
            local ScreenGui = cloneref(Instance.new("ScreenGui", gethui()))
            local Main = Instance.new("Frame")
            local UIStroke = Instance.new("UIStroke")
            local UIGradient = Instance.new("UIGradient")
            local UICorner = Instance.new("UICorner")
            local Glow = Instance.new("ImageLabel")
            local Categories = Instance.new("Frame")
            local UIListLayout = Instance.new("UIListLayout")
            local Logo = Instance.new("ImageLabel")
            local Line1 = Instance.new("Frame")
            local Line2 = Instance.new("Frame")
            local UIScale = Instance.new("UIScale")
            local Drag = Instance.new("TextButton")
            local PageTitle = Instance.new("TextLabel")

            Main.Name = "Main"
            Main.AnchorPoint = Vector2.new(0.5,0.5)
            Main.Parent = ScreenGui
            Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Main.BackgroundTransparency = 1
            Main.BorderSizePixel = 0
            Main.Position = UDim2.new(0.5,0,0.5,0)
            Main.Size = window.Size
            Main.ZIndex = 1

            Lib.Main = Main

            UIGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(31, 31, 44)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 25, 33)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(31, 31, 44)),
            }

            PageTitle.Name = "PageTitle"
            PageTitle.Text = ""
            PageTitle.TextColor3 = Color3.fromRGB(255,255,255)
            PageTitle.BackgroundTransparency = 1
            PageTitle.Position = UDim2.fromOffset(164, 10)
            PageTitle.Size = UDim2.fromOffset(115, 20)
            PageTitle.TextSize = Lib.FontSize
            PageTitle.FontFace = Lib.Font
            PageTitle.TextXAlignment = Enum.TextXAlignment.Left
            PageTitle.Parent = Main

            UIGradient.Rotation = 90
            UIGradient.Parent = Main

            UIStroke.Color = Color3.fromRGB(58, 57, 74)
            UIStroke.Thickness = 1.25
            UIStroke.Parent = Main

            UIScale.Scale = 0.8
            UIScale.Parent = Main

            UICorner.Parent = Main

            Glow.Name = "Glow"
            Glow.Parent = Main
            Glow.AnchorPoint = Vector2.new(0.5, 0.5)
            Glow.BackgroundTransparency = 1.000
            Glow.BorderSizePixel = 0
            Glow.Position = UDim2.new(0.5, 0, 0.5, 0)
            Glow.ImageTransparency = 1
            Glow.Size = UDim2.new(1, 30, 1, 30)
            Glow.Image = "rbxassetid://5028857084"
            Glow.ImageColor3 = Color3.fromRGB(0,0,0)
            Glow.ScaleType = Enum.ScaleType.Slice
            Glow.SliceCenter = Rect.new(24, 24, 276, 276)

            Categories.Name = "Categories"
            Categories.Parent = Main
            Categories.BackgroundTransparency = 1
            Categories.BorderSizePixel = 0
            Categories.Position = UDim2.new(0, 0, 0, 75)
            Categories.Size = UDim2.new(0, 150, 0, 250)

            UIListLayout.Parent = Categories
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIListLayout.Padding = UDim.new(0, 10)

            Logo.Name = "Logo"
            Logo.BackgroundTransparency = 1
            Logo.ImageTransparency = 1
            Logo.BorderSizePixel = 0
            Logo.Position = UDim2.new(0, 25, 0, 25)
            Logo.Image = "rbxassetid://"..Lib.Logo
            Logo.ScaleType = Enum.ScaleType.Crop
            Logo.Size = UDim2.new(0, 100, 0, 35)

            Logo.Parent = Main

            Line1.Name = "Line1"
            Line1.Parent = Main
            Line1.BackgroundColor3 = Color3.fromRGB(58, 57, 74)
            Line1.BorderSizePixel = 0
            Line1.BackgroundTransparency = 1
            Line1.Position = UDim2.new(0, 150, 0, 0)
            Line1.Size = UDim2.new(0, 1, 1, 0)

            Line2.Name = "Line2"
            Line2.Parent = Main
            Line2.BackgroundColor3 = Color3.fromRGB(58, 57, 74)
            Line2.BorderSizePixel = 0
            Line2.BackgroundTransparency = 1
            Line2.Position = UDim2.new(0, 150, 0, 40)
            Line2.Size = UDim2.new(0, 450, 0, 1)

            Drag.Name = "Drag"
            Drag.Size = UDim2.new(0, 450, 0, 40)
            Drag.Position = UDim2.fromOffset(150,0)
            Drag.BackgroundTransparency = 1
            Drag.TextTransparency = 1
            Drag.Parent = Main
            
            local Blur = Instance.new("BlurEffect", Lighting)
            Blur.Name = "UIBlur"
            Blur.Enabled = true
            Blur.Size = 0

            Lib.Blur = Blur

            ScreenGui.DisplayOrder = 1000
            ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            Lib.ScreenGui = ScreenGui

            window.elements = {
                CategoriesHolder = Categories,
                Main = Main,
            }

            --connections
            Lib:Connection(Drag.MouseButton1Down, function()
                local location = UserInputService:GetMouseLocation()
                window.dragging[1] = true
                window.dragging[2] = UDim2.new(0, location.X - Main.AbsolutePosition.X, 0, location.Y - Main.AbsolutePosition.Y)
            end)
            --stop drag
            Lib:Connection(UserInputService.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    window.dragging[1] = false
                    window.dragging[2] = UDim2.new(0,0,0,0)
                end
            end)
            --drag
            Lib:Connection(UserInputService.InputChanged, function(input)
                local location = UserInputService:GetMouseLocation()
                local actual = nil

                if window.dragging[1] then
                    TweenService:Create(Main, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, location.X - window.dragging[2].X.Offset + (Main.Size.X.Offset * Main.AnchorPoint.X), 0,location.Y - window.dragging[2].Y.Offset + (Main.Size.Y.Offset * Main.AnchorPoint.Y))}):Play()
                end
            end)

            Lib:Connection(UserInputService.InputBegan, function(input)
                if input.KeyCode == Lib.UIOpenKey then
                    Lib:SetUIOpen(not Lib.IsOpen)
                    if not Lib.IsOpen == false then
                        window.dragging[1] = false
                        window.dragging[2] = UDim2.new(0,0,0,0)
                    end
                end
            end)

            function window:UpdateCategories()
                for index, page in pairs(window.categories) do
                    page:Turn(page.open)
                end
            end

            TweenService:Create(Lib.Blur, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = 10}):Play()
            TweenService:Create(Main, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
            TweenService:Create(Main.UIScale, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Scale = 1}):Play()
            for i,v in pairs(Lib.Main:GetDescendants()) do
                if v:IsA("ImageLabel") then
                    TweenService:Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
                elseif v:IsA("Frame") and (v.Name == "Line1" or v.Name == "Line2") then
                    TweenService:Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
                elseif v:IsA("TextLabel") then
                    TweenService:Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
                end
            end

            Lib.IsOpen = true

            return setmetatable(window, Lib)
        end

        function Lib:Page(args)
            if not args then args = {} end

            local page = {
                name = args.name or "Page",
                icon = args.icon or "rbxassetid://6022668955",
                window = self,
                open = false,
                sections = {},
                elements = {}
            }

            local NewPage = Instance.new("Frame")
            local ScrollingFrame = Instance.new("ScrollingFrame")
            local TabButton = Instance.new("TextButton")
            local Title = Instance.new("TextLabel")
            local Icon = Instance.new("ImageLabel")
            local UICorner = Instance.new("UICorner")
            local UIPadding = Instance.new("UIPadding")
            local ScrollingPadding = Instance.new("UIPadding")
            local UIStroke = Instance.new("UIStroke")
            local Left = Instance.new("Frame")
            local Right = Instance.new("Frame")
            local LeftLayout = Instance.new("UIListLayout")
            local RightLayout = Instance.new("UIListLayout")
            local LeftPadding = Instance.new("UIPadding")
            local RightPadding = Instance.new("UIPadding")

            TabButton.Name = page.name
            TabButton.Parent = page.window.elements.CategoriesHolder
            TabButton.BackgroundColor3 = Color3.fromRGB(58, 57, 74)
            TabButton.BackgroundTransparency = 1
            TabButton.BorderSizePixel = 0
            TabButton.AutoButtonColor = false
            TabButton.Size = UDim2.new(0, 130, 0, 25)
            TabButton.TextTransparency = 1.000

            Title.Name = "Title"
            Title.Parent = TabButton
            Title.BackgroundTransparency = 1
            Title.BorderSizePixel = 0
            Title.Position = UDim2.new(0, 32, 0, 2)
            Title.Size = UDim2.new(0, 89, 0, 20)
            Title.FontFace = Lib.Font
            Title.Text = page.name
            Title.TextSize = Lib.FontSize

            Icon.Name = "Icon"
            Icon.Parent = TabButton
            Icon.BackgroundTransparency = 1
            Icon.BorderSizePixel = 0
            Icon.Position = UDim2.new(0, 10, 0, 5)
            Icon.Size = UDim2.new(0, 15, 0, 15)
            Icon.Image = page.icon

            UIPadding.Parent = TabButton

            UICorner.CornerRadius = UDim.new(0,2)
            UICorner.Parent = TabButton

            UIStroke.Color = Color3.fromRGB(58, 57, 74)
            UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UIStroke.Thickness = 0
            UIStroke.Parent = TabButton

            NewPage.Name = "Page"
            NewPage.ZIndex = 49
            NewPage.Parent = page.window.elements.Main
            NewPage.BackgroundTransparency = 1
            NewPage.Visible = false
            NewPage.BorderSizePixel = 0
            NewPage.Position = UDim2.new(0, 150, 0, 40)
            NewPage.Size = UDim2.new(0, 450, 0, 360)

            ScrollingFrame.Parent = NewPage
            ScrollingFrame.ZIndex = 49
            ScrollingFrame.Active = true
            ScrollingFrame.BackgroundTransparency = 1
            ScrollingFrame.BorderSizePixel = 0
            ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
            ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
            ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
            ScrollingFrame.ScrollBarThickness = 0

            ScrollingPadding.Name = "ScrollingPadding"
            ScrollingPadding.PaddingBottom = UDim.new(0, -15)
            ScrollingPadding.PaddingLeft = UDim.new(0, 7)
            ScrollingPadding.PaddingRight = UDim.new(0, 7)
            ScrollingPadding.PaddingTop = UDim.new(0, 7)
            ScrollingPadding.Parent = ScrollingFrame

            Left.Name = "Left"
            Left.Size = UDim2.new(0.485, -4, 1, 0)
            Left.BackgroundTransparency = 1
            Left.ZIndex = 50
            Left.Parent = ScrollingFrame

            LeftPadding.Name = "LeftPadding"
            LeftPadding.PaddingLeft = UDim.new(0,2)
            LeftPadding.PaddingTop = UDim.new(0,5)
            LeftPadding.PaddingBottom = UDim.new(0, 30)
            LeftPadding.Parent = Left

            LeftLayout.Name = "LeftLayout"
            LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
            LeftLayout.Padding = UDim.new(0,7)
            LeftLayout.Parent = Left

            Right.Name = "Right"
            Right.Size = UDim2.new(0.485, -4, 1, 0)
            Right.Position = UDim2.new(0.5, 4,0,0)
            Right.BackgroundTransparency = 1
            Right.ZIndex = 50
            Right.Parent = ScrollingFrame

            RightPadding.Name = "RightPadding"
            RightPadding.PaddingRight = UDim.new(0,2)
            RightPadding.PaddingTop = UDim.new(0,5)
            RightPadding.PaddingBottom = UDim.new(0, 30)
            RightPadding.Parent = Right

            RightLayout.Name = "RightLayout"
            RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
            RightLayout.Padding = UDim.new(0,7)
            RightLayout.Parent = Right

            function page:Turn(bool)
                page.open = bool
                task.spawn(function()
                    NewPage.Visible = page.open
                end)

                TweenService:Create(TabButton, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = page.open and 0.75 or 1}):Play()
                TweenService:Create(UIStroke, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Thickness = page.open and 1.25 or 0}):Play()
                TweenService:Create(Icon, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageColor3 = page.open and Lib.Accent or Color3.fromRGB(255,255,255)}):Play()
                TweenService:Create(Title, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = page.open and Lib.Accent or Color3.fromRGB(255,255,255)}):Play()
                if page.open == true then
                    Lib.Main.PageTitle.Text = Title.Text
                end
            end

            --connections
            Lib:Connection(TabButton.MouseButton1Click, function()
                if not page.open then
                    page:Turn(true)
                    for _, pages in pairs(page.window.categories) do
                        if pages.open and pages ~= page then
                            pages:Turn(false)
                        end
                    end
                end
            end)

            page.elements = {
                Left = Left,
                Right = Right,
                TabButton = TabButton
            }

            if #page.window.categories == 0 then
                page:Turn(true)
            end
            page.window.categories[#page.window.categories + 1] = page
            page.window:UpdateCategories()

            return setmetatable(page, Lib.Categories)
        end

        function Categories:Section(args)
            if not args then args = {} end

            local section = {
                name = args.name or "Section",
                page = self,
                side = (args.side or "left"):lower(),
                elements = {},
                content = {}
            }

            local NewSection = Instance.new("Frame")
            local Holder = Instance.new("Frame")
            local UIListLayout = Instance.new("UIListLayout")
            local UIPadding = Instance.new("UIPadding")
            local Title = Instance.new("TextLabel")
            local UIPadding_2 = Instance.new("UIPadding")
            local UIStroke = Instance.new("UIStroke")
            local UICorner = Instance.new("UICorner")

            NewSection.Name = "NewSection"
            NewSection.Parent = section.side == "left" and section.page.elements.Left or section.side == "right" and section.page.elements.Right
            NewSection.BackgroundTransparency = 1
            NewSection.AutomaticSize = Enum.AutomaticSize.Y
            NewSection.BorderSizePixel = 0
            NewSection.Size = UDim2.new(1,0,0,0)
            NewSection.ZIndex = 55

            UIStroke.Color = Color3.fromRGB(58, 57, 74)
            UIStroke.Thickness = 1.25
            UIStroke.Parent = NewSection

            UIPadding.PaddingBottom = UDim.new(0, 10)
            UIPadding.Parent = NewSection

            Holder.Name = "Holder"
            Holder.Parent = NewSection
            Holder.BackgroundTransparency = 1
            Holder.Position = UDim2.new(0,0,0,35)
            Holder.BorderSizePixel = 0
            Holder.AutomaticSize = Enum.AutomaticSize.Y
            Holder.Size = UDim2.new(1, 0, 0, 0)

            UIListLayout.Parent = Holder
            UIListLayout.Padding = UDim.new(0,6)
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

            Title.Name = "Title"
            Title.TextColor3 = Color3.fromRGB(255,255,255)
            Title.AutomaticSize = Enum.AutomaticSize.X
            Title.Parent = NewSection
            Title.BackgroundTransparency = 1
            Title.BorderSizePixel = 0
            Title.Position = UDim2.fromOffset(5, 10)
            Title.Size = UDim2.new(0, 0, 0, 15)
            Title.ZIndex = 55
            Title.FontFace = Lib.Font
            Title.Text = section.name
            Title.TextSize = Lib.FontSize

            UIPadding_2.Parent = Title
            UIPadding_2.PaddingLeft = UDim.new(0, 3)
            UIPadding_2.PaddingRight = UDim.new(0, 3)

            UICorner.CornerRadius = UDim.new(0,4)
            UICorner.Parent = NewSection

            section.elements = {
                Holder = Holder
            }
            
            section.page.sections[#section.page.sections + 1] = section
            return setmetatable(section, Lib.Sections)
        end

        function Sections:Toggle(args)
            if not args then args = {} end

            local Toggle = {
                window = self.window,
                page = self.page,
                section = self,
                name = args.name or "Toggle",
                desc = args.desc or "",
                isColored = args.color or false,
                Other = args.other or {},
                state = (
                    args.state or args.State or args.default or false
                ),
                callback = (
                    args.callback or function()end
                ),
                flag = (
                    args.flag or Lib.NextFlag()
                ),
                Main = nil,
                Toggled = false,
                PRNT = args.prnt or nil
            }

            local Colorpicker = {
                pickerName = args.pickername or "Colorpicker",
                pickerState = args.pickerstate or Lib.Accent,
                pickerFlag = args.pickerflag or Lib.NextFlag(),
                colorpickers = 0,
                pickerOpen = false,
                callback = (
                    args.callback or function()end
                ),
            }

            local ToggleFrame = Instance.new("TextButton")
            local UIPadding = Instance.new("UIPadding")
            local Desc = Instance.new("TextLabel")
            local Title = Instance.new("TextLabel")
            local ToggleButton = Instance.new("TextButton")
            local UIPadding_2 = Instance.new("UIPadding")
            local Circle = Instance.new("Frame")
            local UICorner = Instance.new("UICorner")
            local UICorner_2 = Instance.new("UICorner")

            ToggleFrame.Name = Toggle.name
            if Toggle.PRNT ~= nil then
                local HolderFrame = Instance.new("Frame")
                HolderFrame.Visible = false
                HolderFrame.Name = Toggle.name
                HolderFrame.Parent = Toggle.section.elements.Holder
                HolderFrame.ClipsDescendants = true
                HolderFrame.BackgroundTransparency = 1
                HolderFrame.BorderSizePixel = 0
                HolderFrame.Size = UDim2.new(1, 0, 0, 28)
                ToggleFrame.Parent = HolderFrame
                ToggleFrame.Position = UDim2.new(0,0,-1,0)
                ToggleFrame.Size = UDim2.new(1,0,1,0)
            else
                ToggleFrame.Parent = Toggle.section.elements.Holder
                ToggleFrame.Size = UDim2.new(1,0,0,28)
            end
            ToggleFrame.BackgroundTransparency = 1
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.TextTransparency = 1
            ToggleFrame.AutoButtonColor = false

            Toggle.Main = ToggleFrame

            if Toggle.isColored == true then
                Colorpicker.colorpickers = Colorpicker.colorpickers + 1
                local colorpickertypes = Lib:NewPicker(
                    Colorpicker.pickerName,
                    Colorpicker.pickerState,
                    ToggleFrame,
                    Colorpicker.colorpickers,
                    Colorpicker.pickerFlag,
                    Colorpicker.callback
                )
    
                function Toggle:Set(color)
                    colorpickertypes:Set(color, false, true)
                end
    
                setmetatable(Toggle, Colorpicker)
            end

            UIPadding.Parent = ToggleFrame
            UIPadding.PaddingLeft = UDim.new(0, 3)

            Desc.Name = "Desc"
            Desc.Parent = ToggleFrame
            Desc.BackgroundTransparency = 1
            Desc.BorderSizePixel = 0
            Desc.Position = UDim2.new(0, 6, 0.5, 0)
            Desc.Size = UDim2.new(0, 120, 0.5, 0)
            Desc.FontFace = Lib.DescFont
            Desc.Text = Toggle.desc
            Desc.TextColor3 = Color3.fromRGB(108, 108, 108)
            Desc.TextSize = 13.000
            Desc.TextXAlignment = Enum.TextXAlignment.Left

            Title.Name = "Title"
            Title.TextColor3 = Color3.fromRGB(255,255,255)
            Title.Parent = ToggleFrame
            Title.BackgroundTransparency = 1
            Title.BorderSizePixel = 0
            Title.Position = UDim2.new(0, 5, 0, 0)
            Title.Size = UDim2.new(0, 120, 0.5, 0)
            Title.FontFace = Lib.Font
            Title.Text = Toggle.name
            Title.TextSize = Lib.FontSize
            Title.TextXAlignment = Enum.TextXAlignment.Left

            ToggleButton.Name = "ToggleButton"
            ToggleButton.Parent = ToggleFrame
            ToggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            ToggleButton.BorderSizePixel = 0
            ToggleButton.AutoButtonColor = false
            ToggleButton.Position = UDim2.new(0, 165, 0, 2)
            ToggleButton.Size = UDim2.new(0, 36, 0, 20)
            ToggleButton.TextTransparency = 1
            ToggleButton.ZIndex = 1

            UIPadding_2.Parent = ToggleButton
            UIPadding_2.PaddingBottom = UDim.new(0, 3)
            UIPadding_2.PaddingLeft = UDim.new(0, 3)
            UIPadding_2.PaddingRight = UDim.new(0, 3)
            UIPadding_2.PaddingTop = UDim.new(0, 3)

            Circle.Name = "Circle"
            Circle.Parent = ToggleButton
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Circle.BorderSizePixel = 0
            Circle.Size = UDim2.new(0, 14, 0, 14)

            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = Circle

            UICorner_2.CornerRadius = UDim.new(0, 10)
            UICorner_2.Parent = ToggleButton

            local function setEnabled()
                Toggle.Toggled = not Toggle.Toggled
                if Toggle.Toggled then 
                    TweenService:Create(ToggleButton, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Lib.Accent}):Play()
                    TweenService:Create(Circle, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
                    TweenService:Create(Circle, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0, 0)}):Play()
                    for i, v in Toggle.Other do
                        local childobj = Toggle.section.elements.Holder:FindFirstChild(v)
                        if v and childobj then
                            childobj.Visible = true
                            local childobjchild = childobj:FindFirstChildWhichIsA("Frame") or childobj:FindFirstChildWhichIsA("TextButton")
                            if childobjchild then
                                TweenService:Create(childobjchild, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0,0,0,0)}):Play()
                                task.wait(0.1)
                                if childobjchild:FindFirstChild("ToggleFrame") and childobjchild:FindFirstChild("ToggleFrame"):FindFirstChild("DropdownFrame") then
                                    childobj.ClipsDescendants = false
                                end
                            end
                        end
                    end
                else
                    TweenService:Create(ToggleButton, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(70,70,70)}):Play()
                    TweenService:Create(Circle, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
                    TweenService:Create(Circle, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(150,150,150)}):Play()
                    for i, v in Toggle.Other do
                        local childobj = Toggle.section.elements.Holder:FindFirstChild(v)
                        if v and childobj then
                            local childobjchild = childobj:FindFirstChildWhichIsA("Frame") or childobj:FindFirstChildWhichIsA("TextButton")
                            if childobjchild then
                                if childobjchild:FindFirstChild("ToggleFrame") and childobjchild:FindFirstChild("ToggleFrame"):FindFirstChild("DropdownFrame") then
                                    childobj.ClipsDescendants = true
                                end
                                TweenService:Create(childobjchild, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0,0,-1,0)}):Play()
                                task.wait(0.15)
                                childobj.Visible = false
                            end
                        end
                    end
                end
                Lib.Flags[Toggle.flag] = Toggle.Toggled
                Toggle.callback(Toggle.Toggled)
            end

            function Toggle.Set(bool)
                bool = type(bool) == "boolean" and bool or false
                if Toggle.Toggled ~= bool then
                    setEnabled()
                end
            end
            Toggle.Set(Toggle.state)
            Lib.Flags[Toggle.flag] = Toggle.state
            Flags[Toggle.flag] = Toggle.Set

            Lib:Connection(ToggleButton.MouseButton1Click, setEnabled)

            Lib:Connection(ToggleFrame.MouseEnter, function()
                if Toggle.isColored == true then
                    TweenService:Create(ToggleFrame.Colorpicker_frame, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
                end
            end)

            Lib:Connection(ToggleFrame.MouseLeave, function()
                if Toggle.isColored == true then
                    TweenService:Create(ToggleFrame.Colorpicker_frame, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
                end
            end)

            return Toggle
        end

        function Sections:Separator()
            local Separator = {
                window = self.window,
                page = self.page,
                section = self,
            }

            local NewSeparator = Instance.new("Frame")

            NewSeparator.Name = "NewSeparator"
            NewSeparator.BackgroundColor3 = Color3.fromRGB(58, 57, 74)
            NewSeparator.Size = UDim2.new(0.92, 0, 0, 1)
            NewSeparator.BorderSizePixel = 0
            NewSeparator.Parent = Separator.section.elements.Holder
        end

        function Sections:Slider(args)
            if not args then args = {} end

            local Slider = {
                name = args.name or "Slider",
                Window = self.window,
                Page = self.page,
                Section = self,
                Desc = args.desc,
                Min = args.min or 0,
                State = args.state or 10,
                Max = args.max or 100,
                Sub = args.sub or "",
                Decimals = args.decimals or 1,
                callback = args.callback or function()end,
                flag = args.flag or Lib.NextFlag(),
                Main = nil,
                PRNT = args.prnt or nil
            }
            local TextValue = ("[value]" .. Slider.Sub)

            local NewSlider = Instance.new("Frame")
            local Title = Instance.new("TextLabel")
            local Value = Instance.new("TextLabel")
            local UIPadding = Instance.new("UIPadding")
            local FillFrame = Instance.new("TextButton")
            local Fill = Instance.new("Frame")
            local Circle = Instance.new("TextButton")
            local UICorner = Instance.new("UICorner")

            NewSlider.Name = Slider.name
            if Slider.PRNT ~= nil then
                local HolderFrame = Instance.new("Frame")
                HolderFrame.Name = Slider.name
                HolderFrame.Visible = false
                HolderFrame.Parent = Slider.Section.elements.Holder
                HolderFrame.ClipsDescendants = true
                HolderFrame.BackgroundTransparency = 1
                HolderFrame.BorderSizePixel = 0
                HolderFrame.Size = UDim2.new(1, 0, 0, 28)
                NewSlider.Parent = HolderFrame
                NewSlider.Position = UDim2.new(0,0,-1,0)
                NewSlider.Size = UDim2.new(1,0,1,0)
            else
                NewSlider.Parent = Slider.Section.elements.Holder
                NewSlider.Size = UDim2.new(1,0,0,28)
            end
            NewSlider.BackgroundTransparency = 1
            NewSlider.BorderSizePixel = 0

            Slider.Main = NewSlider

            Title.Name = "Title"
            Title.AutomaticSize = Enum.AutomaticSize.X
            Title.Parent = NewSlider
            Title.TextColor3 = Color3.fromRGB(255,255,255)
            Title.BackgroundTransparency = 1
            Title.BorderSizePixel = 0
            Title.Position = UDim2.new(0, 5, 0, 0)
            Title.Size = UDim2.new(0, 0, 0.5, 0)
            Title.FontFace = Lib.Font
            Title.Text = Slider.name
            Title.TextSize = Lib.FontSize
            Title.TextXAlignment = Enum.TextXAlignment.Left

            Value.Name = "Value"
            Value.Parent = NewSlider
            Value.TextColor3 = Color3.fromRGB(255, 255, 255)
            Value.BackgroundTransparency = 1
            Value.BorderSizePixel = 0
            Value.Position = UDim2.new(0, 160, 0, 0)
            Value.Size = UDim2.new(0, 40, 0.5, 0)
            Value.FontFace = Lib.Font
            Value.Text = ""
            Value.TextSize = Lib.FontSize
            Value.TextXAlignment = Enum.TextXAlignment.Right

            UIPadding.Parent = NewSlider
            UIPadding.PaddingLeft = UDim.new(0, 3)

            FillFrame.Name = "FillFrame"
            FillFrame.Parent = NewSlider
            FillFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            FillFrame.BorderSizePixel = 0
            FillFrame.Position = UDim2.new(0, 6, 0.699999988, 0)
            FillFrame.Size = UDim2.new(0.920000017, 0, 0.150000006, 0)
            FillFrame.AutoButtonColor = false
            FillFrame.Text = ""

            Fill.Name = "Fill"
            Fill.Parent = FillFrame
            Fill.BackgroundColor3 = Lib.Accent
            Fill.BorderSizePixel = 0
            Fill.Size = UDim2.new(0.5, 0, 1, 0)

            Circle.Name = "Circle"
            Circle.Parent = Fill
            Circle.BackgroundColor3 = Lib.Accent
            Circle.AutoButtonColor = false
            Circle.Text = ""
            Circle.BorderSizePixel = 0
            Circle.Position = UDim2.new(1, -6, 0, -4)
            Circle.Size = UDim2.new(0, 12, 0, 12)

            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = Circle    

            local Sliding = false
            local Val = Slider.State
            local function Set(value)
                value = math.clamp(Lib:Round(value, Slider.Decimals), Slider.Min, Slider.Max)

                local sizeX = (value - Slider.Min) / (Slider.Max - Slider.Min)
                TweenService:Create(Fill, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(sizeX, 0, 1, 0)}):Play()
                Value.Text = TextValue:gsub("%[value%]", string.format("%.14g", value))
                Val = value

                Lib.Flags[Slider.flag] = value
                Slider.callback(value)
            end

            local function Slide(input)
                local sizeX = (input.Position.X - FillFrame.AbsolutePosition.X) / FillFrame.AbsoluteSize.X
                local value = ((Slider.Max - Slider.Min) * sizeX) + Slider.Min
                Set(value)
            end

            Lib:Connection(FillFrame.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Sliding = true
                    Slide(input)
                end
            end)

            Lib:Connection(FillFrame.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Sliding = false
                end
            end)

            Lib:Connection(Circle.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Sliding = true
                    Slide(input)
                end
            end)

            Lib:Connection(Circle.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Sliding = false
                end
            end)

            Lib:Connection(UserInputService.InputChanged, function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    if Sliding then
                        Slide(input)
                    end
                end
            end)

            function Slider:Set(Value)
                Set(Value)
            end
            Flags[Slider.flag] = Set
            Lib.Flags[Slider.flag] = Slider.State
            Set(Slider.State)

            return Slider
        end

        function Sections:List(args)
            if not args then args = {} end
            
            local Dropdown = {
                window = self.window,
                page = self.page,
                section = self,
                isOpen = false,
                desc = args.desc or "",
                name = args.name or "List",
                options = args.options or {"1", "2", "3"},
                max = args.max or nil,
                state = args.state or nil,
                callback = args.callback or function() end,
                flag = args.flag or Lib.NextFlag(),
                currentbiggest = 0,
                optionInstances = {},
                Main = nil,
                PRNT = args.prnt or nil
            }

            local NewDropdown = Instance.new("Frame")
            local Title = Instance.new("TextLabel")
            local Desc = Instance.new("TextLabel")
            local UIPadding = Instance.new("UIPadding")
            local ToggleFrame = Instance.new("TextButton")
            local UIStroke = Instance.new("UIStroke")
            local UIStroke2 = Instance.new("UIStroke")
            local Icon = Instance.new("ImageLabel")
            local UICorner = Instance.new("UICorner")
            local UICorner2 = Instance.new("UICorner")
            local DropdownTitle = Instance.new("TextLabel")
            local DropdownFrame = Instance.new("Frame")
            local UIListLayout = Instance.new("UIListLayout")
            local UIPadding_2 = Instance.new("UIPadding")

            NewDropdown.Name = Dropdown.name
            if Dropdown.PRNT ~= nil then
                local HolderFrame = Instance.new("Frame")
                HolderFrame.Name = Dropdown.name
                HolderFrame.Visible = false
                HolderFrame.Parent = Dropdown.section.elements.Holder
                HolderFrame.ClipsDescendants = true
                HolderFrame.BackgroundTransparency = 1
                HolderFrame.BorderSizePixel = 0
                HolderFrame.Size = UDim2.new(1, 0, 0, 28)
                HolderFrame.ZIndex = 512
                NewDropdown.Parent = HolderFrame
                NewDropdown.Position = UDim2.new(0,0,-1,0)
                NewDropdown.Size = UDim2.new(1,0, 1, 0)
            else
                NewDropdown.Parent = Dropdown.section.elements.Holder
                NewDropdown.Size = UDim2.new(1,0,0, 28)
            end
            NewDropdown.BackgroundTransparency = 1
            NewDropdown.BorderSizePixel = 0
            NewDropdown.ZIndex = 512

            Dropdown.Main = NewDropdown

            Title.Name = "Title"
            Title.Parent = NewDropdown
            Title.BackgroundTransparency = 1
            Title.BorderSizePixel = 0
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.Position = UDim2.new(0, 5, 0, 0)
            Title.Size = UDim2.new(0, 120, 0.5, 0)
            Title.FontFace = Lib.Font
            Title.Text = Dropdown.name
            Title.TextSize = Lib.FontSize
            Title.TextXAlignment = Enum.TextXAlignment.Left

            Desc.Name = "Desc"
            Desc.Parent = NewDropdown
            Desc.BackgroundTransparency = 1
            Desc.BorderSizePixel = 0
            Desc.Position = UDim2.new(0,6,0.5,0)
            Desc.Size = UDim2.new(0,120,0.5,0)
            Desc.FontFace = Lib.DescFont
            Desc.TextSize = 13
            Desc.Text = Dropdown.desc
            Desc.TextColor3 = Color3.fromRGB(108, 108, 108)

            UIPadding.Parent = NewDropdown
            UIPadding.PaddingLeft = UDim.new(0, 3)

            ToggleFrame.Name = "ToggleFrame"
            ToggleFrame.Parent = NewDropdown
            ToggleFrame.BackgroundTransparency = 1
            ToggleFrame.AnchorPoint = Vector2.new(0, 0.5)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Position = UDim2.new(0, 130, 0.500002086, 0)
            ToggleFrame.Size = UDim2.new(0,70,0, 20)
            ToggleFrame.AutoButtonColor = false
            ToggleFrame.Text = ""
            ToggleFrame.ZIndex = 512

            UIStroke.Color = Color3.fromRGB(58, 57, 74)
            UIStroke.Thickness = 1.25
            UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UIStroke.Parent = ToggleFrame

            Icon.Name = "Icon"
            Icon.Parent = ToggleFrame
            Icon.BackgroundTransparency = 1
            Icon.BorderSizePixel = 0
            Icon.AnchorPoint = Vector2.new(0, 0.5)
            Icon.Position = UDim2.new(0, 55, 0.5, 0)
            Icon.Size = UDim2.new(0, 12, 0, 12)
            Icon.Image = "rbxassetid://139757010660912" 

            UICorner.CornerRadius = UDim.new(0, 3)
            UICorner.Parent = ToggleFrame

            DropdownTitle.Name = "DropdownTitle"
            DropdownTitle.AnchorPoint = Vector2.new(0, 0.5)
            DropdownTitle.Parent = ToggleFrame
            DropdownTitle.BackgroundTransparency = 1
            DropdownTitle.BorderSizePixel = 0
            DropdownTitle.Position = UDim2.new(0, 5, 0.5, 0)
            DropdownTitle.Size = UDim2.new(0, 50, 0.6, 0)
            DropdownTitle.FontFace = Font.new("rbxassetid://11702779409", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            DropdownTitle.TextScaled = true
            DropdownTitle.Text = ""
            DropdownTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
            DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left

            DropdownFrame.Name = "DropdownFrame"
            DropdownFrame.AnchorPoint = Vector2.new(0.5,0)
            DropdownFrame.Parent = ToggleFrame
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 33)
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.Position = UDim2.new(0.5, 0, 1.15, 0)
            DropdownFrame.Size = UDim2.new(0, 84, 0, 0)
            DropdownFrame.AutomaticSize = Enum.AutomaticSize.X
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.ZIndex = 4

            UIListLayout.Parent = DropdownFrame
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Padding = UDim.new(0, 3)

            UICorner2.CornerRadius = UDim.new(0, 6)
            UICorner2.Parent = DropdownFrame
            
            UIPadding_2.Parent = DropdownFrame
            UIPadding_2.PaddingTop = UDim.new(0, 2)
            UIPadding_2.PaddingLeft = UDim.new(0, 2)
            UIPadding_2.PaddingRight = UDim.new(0, 2)
            UIPadding_2.PaddingBottom = UDim.new(0, 2)

            UIStroke2.Color = Color3.fromRGB(58, 57, 74)
            UIStroke2.Thickness = 0
            UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UIStroke2.Parent = DropdownFrame

            local Toggled = false
            local Count = 0

            Lib:Connection(ToggleFrame.MouseButton1Click, function()
                Toggled = not Toggled
                Lib.DropdownOpen = Toggled
                if Toggled then
                    TweenService:Create(Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 180}):Play()
                    TweenService:Create(Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(200,200,200)}):Play()
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0,84,0,(Count * 15) + 10)}):Play()
                    TweenService:Create(UIStroke2, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Thickness = 1.25}):Play()
                else
                    TweenService:Create(Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0}):Play()
                    TweenService:Create(Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(150,150,150)}):Play()
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0,84,0,0)}):Play()
                    TweenService:Create(UIStroke2, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Thickness = 0}):Play()
                end
            end)

            Lib:Connection(UserInputService.InputBegan, function(input)
                if DropdownFrame.Visible and input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not Lib:MouseOverUI(DropdownFrame) and not Lib:MouseOverUI(ToggleFrame) then
                        Toggled = false
                        Lib.DropdownOpen = false
                        TweenService:Create(Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0}):Play()
                        TweenService:Create(Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(150,150,150)}):Play()
                        TweenService:Create(DropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0,84,0,0)}):Play() 
                        TweenService:Create(UIStroke2, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Thickness = 0}):Play()
                    end
                end
            end)

            local Chosen = Dropdown.max and {} or nil

            local function optionClick(option, button, text, tick)
                button.MouseButton1Click:Connect(function()
                    if Dropdown.max then
                        if table.find(Chosen, option) then
                            table.remove(Chosen, table.find(Chosen, option))

                            local textchosen = {}
                            local cutobject = false

                            for _,opti in next, Chosen do
                                table.insert(textchosen, opti)
                            end
                            
                            DropdownTitle.Text = #Chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")
                            TweenService:Create(button, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
                            TweenService:Create(tick, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()

                            Lib.Flags[Dropdown.flag] = Chosen
                            Dropdown.callback(Chosen)
                        else
                            if #Chosen == Dropdown.max then
                                TweenService:Create(button, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
                                TweenService:Create(tick, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
                                table.remove(Chosen, 1)
                            end
                            
                            table.insert(Chosen, option)

                            local textchosen = {}
                            local cutobject = false

                            for _,opti in next, Chosen do
                                table.insert(textchosen, opti)
                            end

                            DropdownTitle.Text = #Chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")
                            TweenService:Create(button, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.965}):Play()
                            TweenService:Create(tick, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()

                            Lib.Flags[Dropdown.flag] = Chosen
                            Dropdown.callback(Chosen)
                        end
                    else
                        for opti, tbl in next, Dropdown.optionInstances do
                            if opti ~= option then
                                TweenService:Create(tbl.button, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
                                TweenService:Create(tbl.tick, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
                            end
                        end
                        Chosen = option
                        DropdownTitle.Text = option
                        TweenService:Create(button, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.965}):Play()
                        TweenService:Create(tick, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
                        Lib.Flags[Dropdown.flag] = option
                        Dropdown.callback(option)
                    end
                end)
            end

            local function createopts(tbl)
                for _, option in next, tbl do
                    Dropdown.optionInstances[option] = {}

                    local TextButton = Instance.new("TextButton")
                    local UICorner = Instance.new("UICorner")
                    local Title = Instance.new("TextLabel")
                    local UIPadding = Instance.new("UIPadding")
                    local Tick = Instance.new("ImageLabel")

                    TextButton.Parent = DropdownFrame
                    TextButton.BackgroundTransparency = 1
                    TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    TextButton.BorderSizePixel = 0
                    TextButton.Size = UDim2.new(1, 0, 0, 15)
                    TextButton.Text = ""
                    TextButton.AutoButtonColor = false
                    TextButton.ZIndex = 4
                    Dropdown.optionInstances[option].button = TextButton

                    UICorner.CornerRadius = UDim.new(0, 4)
                    UICorner.Parent = TextButton

                    Title.Name = "Title"
                    Title.Parent = TextButton
                    Title.AnchorPoint = Vector2.new(0, 0.5)
                    Title.BackgroundTransparency = 1
                    Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    Title.BorderSizePixel = 0
                    Title.Position = UDim2.new(0, 0, 0.5, 0)
                    Title.Size = UDim2.new(0, 40, 0, 14)
                    Title.FontFace = Font.new("rbxassetid://11702779409", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                    Title.TextXAlignment = Enum.TextXAlignment.Left
                    Title.AutomaticSize = Enum.AutomaticSize.X
                    Title.Text = option
                    Title.ZIndex = 4
                    Title.TextScaled = true
                    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Title.TextSize = Lib.FontSize
                    Dropdown.optionInstances[option].text = Title

                    UIPadding.Parent = TextButton
                    UIPadding.PaddingLeft = UDim.new(0, 5)
                    UIPadding.PaddingRight = UDim.new(0, 5)

                    Tick.Name = "Tick"
                    Tick.ZIndex = 4
                    Tick.Parent = TextButton
                    Tick.ImageTransparency = 1
                    Tick.Image = "rbxassetid://98830532951053"
                    Tick.AnchorPoint = Vector2.new(0, 0.5)
                    Tick.BackgroundTransparency = 1.000
                    Tick.BorderSizePixel = 0
                    Tick.Position = UDim2.new(0, 59, 0.45, 0)
                    Tick.Size = UDim2.new(0, 12, 0, 12)
                    Dropdown.optionInstances[option].tick = Tick
                    
                    Count = Count + 1

                    optionClick(option, TextButton, Title, Tick)
                end
            end

            createopts(Dropdown.options)

            local set
            set = function(option)
                if Dropdown.max then
                    table.clear(Chosen)
                    option = type(option) == table and option or {}

                    for opt, tbl in next, Dropdown.optionInstances do
                        if not table.find(option, opt) then
                            TweenService:Create(tbl.button, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
                            TweenService:Create(tbl.tick, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
                        end
                    end

                    for i, opt in next, option do
                        if table.find(Dropdown.options, opt) and #Chosen < Dropdown.max then
                            table.insert(Chosen, opt)
                            TweenService:Create(Dropdown.optionInstances[opt].button, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.965}):Play()
                            TweenService:Create(Dropdown.optionInstances[opt].tick, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
                        end
                    end

                    local textchosen = {}
                    local cutobject = false

                    for _, opt in next, Chosen do
                        table.insert(textchosen, opt)
                    end

                    DropdownTitle.Text = #Chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")

                    Lib.Flags[Dropdown.flag] = Chosen
                    Dropdown.callback(Chosen)
                end
            end

            function Dropdown:Set(option)
                if Dropdown.max then
                    set(option)
                else
                    for opt, tbl in next, Dropdown.optionInstances do
                        if opt ~= option then
                            TweenService:Create(tbl.button, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
                            TweenService:Create(tbl.tick, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
                        end
                    end
                    if table.find(Dropdown.options, option) then
                        Chosen = option
                        DropdownTitle.Text = option
                        TweenService:Create(Dropdown.optionInstances[option].button, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.965}):Play()
                        TweenService:Create(Dropdown.optionInstances[option].tick, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
                        Lib.Flags[Dropdown.flag] = Chosen
                        Dropdown.callback(Chosen)
                    else
                        Chosen = nil
                        DropdownTitle.Text = ""
                        Lib.Flags[Dropdown.flag] = Chosen
                        Dropdown.callback(Chosen)
                    end
                end
            end

            function Dropdown:Refresh(tbl)
                Count = 0
                for _, opt in next, Dropdown.optionInstances do
                    coroutine.wrap(function()
                        opt.button:Destroy()
                    end)()
                end
                table.clear(Dropdown.optionInstances)

                createopts(tbl)
                Chosen = nil

                Lib.Flags[Dropdown.flag] = Chosen
                Dropdown.callback(Chosen)
            end

            if Dropdown.max then
                Flags[Dropdown.flag] = set
            else
                Flags[Dropdown.flag] = Dropdown
            end
            Dropdown:Set(Dropdown.state)
            return Dropdown
        end

        function Sections:Keybind(args)
            if not args then args = {} end
            
            local Keybind = {
                section = self,
                name = args.name or "Keybind",
                state = args.state or "None",
                flag = args.flag or Lib.NextFlag(),
                desc = args.desc or "",
                mode = args.mode or "Toggle",
                useKey = args.usekey or false,
                callback = args.callback or function() end,
                binding = nil,
                Main = nil,
                PRNT = args.prnt or nil
            }

            local Key
            local state = false

            local NewKeybind = Instance.new("Frame")
            local Desc = Instance.new("TextLabel")
            local Title = Instance.new("TextLabel")
            local UIPadding = Instance.new("UIPadding")
            local ToggleFrame = Instance.new("TextButton")
            local UIPadding_2 = Instance.new("UIPadding")
            local Icon = Instance.new("ImageLabel")
            local Keycode = Instance.new("TextLabel")
            local UICorner = Instance.new("UICorner")

            NewKeybind.Name = Keybind.name
            if Keybind.PRNT ~= nil then
                local HolderFrame = Instance.new("Frame")
                HolderFrame.Name = Keybind.name
                HolderFrame.Visible = false
                HolderFrame.Parent = Keybind.section.elements.Holder
                HolderFrame.ClipsDescendants = true
                HolderFrame.BackgroundTransparency = 1
                HolderFrame.BorderSizePixel = 0
                HolderFrame.Size = UDim2.new(1, 0, 0, 28)
                NewKeybind.Parent = HolderFrame
                NewKeybind.Position = UDim2.new(0,0,-1,0)
                NewKeybind.Size = UDim2.new(1,0,1,0)
            else
                NewKeybind.Parent = Keybind.section.elements.Holder
                NewKeybind.Size = UDim2.new(1,0,0,28)
            end
            NewKeybind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            NewKeybind.BackgroundTransparency = 1.000
            NewKeybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
            NewKeybind.BorderSizePixel = 0

            Keybind.Main = NewKeybind

            Desc.Name = "Desc"
            Desc.Parent = NewKeybind
            Desc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Desc.BackgroundTransparency = 1.000
            Desc.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Desc.BorderSizePixel = 0
            Desc.Position = UDim2.new(0, 5, 0.5, 0)
            Desc.Size = UDim2.new(0, 73, 0.5, 0)
            Desc.FontFace = Lib.DescFont
            Desc.Text = Keybind.desc
            Desc.TextColor3 = Color3.fromRGB(108, 108, 108)
            Desc.TextSize = 13.000
            Desc.TextXAlignment = Enum.TextXAlignment.Left

            Title.Name = "Title"
            Title.Parent = NewKeybind
            Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            Title.BackgroundTransparency = 1.000
            Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Title.BorderSizePixel = 0
            Title.Position = UDim2.new(0, 5, 0, 0)
            Title.Size = UDim2.new(0, 140, 0.5, 0)
            Title.FontFace = Lib.Font
            Title.Text = Keybind.name
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 14.000
            Title.TextXAlignment = Enum.TextXAlignment.Left

            UIPadding.Parent = NewKeybind
            UIPadding.PaddingLeft = UDim.new(0, 3)

            ToggleFrame.Name = "ToggleFrame"
            ToggleFrame.Parent = NewKeybind
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 33)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Position = UDim2.new(0, 145, 0, 2)
            ToggleFrame.Size = UDim2.new(0, 55, 0, 20)
            ToggleFrame.AutoButtonColor = false
            ToggleFrame.Text = ""

            local ToggleStroke = Instance.new("UIStroke")
            ToggleStroke.Name = "ToggleStroke"
            ToggleStroke.Color = Color3.fromRGB(58, 57, 74)
            ToggleStroke.Parent = ToggleFrame

            UIPadding_2.Parent = ToggleFrame
            UIPadding_2.PaddingBottom = UDim.new(0, 3)
            UIPadding_2.PaddingLeft = UDim.new(0, 3)
            UIPadding_2.PaddingRight = UDim.new(0, 3)
            UIPadding_2.PaddingTop = UDim.new(0, 3)

            Icon.Name = "Icon"
            Icon.Parent = ToggleFrame
            Icon.BackgroundTransparency = 1.000
            Icon.AnchorPoint = Vector2.new(0.5,0.5)
            Icon.Position = UDim2.new(0,5,0,7)
            Icon.BorderSizePixel = 0
            Icon.ImageColor3 = Color3.fromRGB(200, 200, 200)
            Icon.Size = UDim2.new(0, 10, 0, 10)
            Icon.Image = "http://www.roblox.com/asset/?id=129755497682251"

            Keycode.Name = "Keycode"
            Keycode.Parent = ToggleFrame
            Keycode.BackgroundTransparency = 1.000
            Keycode.BorderSizePixel = 0
            Keycode.Position = UDim2.new(0, 12, 0, -2)
            Keycode.Size = UDim2.new(0, 38, 0, 20)
            Keycode.FontFace = Lib.Font
            Keycode.Text = "None"
            Keycode.TextColor3 = Color3.fromRGB(255, 255, 255)
            Keycode.TextSize = 13.000
            Keycode.TextXAlignment = Enum.TextXAlignment.Left

            UICorner.CornerRadius = UDim.new(0, 5)
            UICorner.Parent = ToggleFrame

            local function set(newkey)
                if string.find(tostring(newkey), "Enum") then
                    if c then
                        c:Disconnect()
                        if Keybind.flag then
                            Lib.Flags[Keybind.flag] = false
                        end
                        Keybind.callback(false)
                    end
                    if tostring(newkey):find("Enum.Keycode.") then
                        newkey = Enum.KeyCode[tostring(newkey):gsub("Enum.KeyCode.", "")]
                    elseif tostring(newkey):find("Enum.UserInputType.") then
                        newkey = Enum.UserInputType[tostring(newkey):gsub("Enum.UserInputType.", "")]
                    end
                    if newkey == Enum.KeyCode.Backspace then
                        Key = nil
                        if Keybind.useKey then
                            if Keybind.flag then
                                Lib.Flags[Keybind.flag] = Key
                            end
                            Keybind.callback(Key)
                        end
                        Keycode.Text = "None"
                    elseif newkey ~= nil then
                        Key = newkey
                        if Keybind.useKey then
                            if Keybind.flag then
                                Lib.Flags[Keybind.flag] = Key
                            end
                            Keybind.callback(Key)
                        end
                        Keycode.Text = (Lib.Keybinds[newkey] or tostring(newkey):gsub("Enum.KeyCode.", ""))
                    end

                    Lib.Flags[Keybind.flag.."_KEY"] = newkey
                elseif table.find({"Always", "Toggle", "Hold"}, newkey) then
                    if not Keybind.useKey then
                        Lib.Flags[Keybind.flag.."_KEYSTATE"] = newkey
                        Keybind.mode = newkey
                        if Keybind.mode == "Always" then
                            state = true
                            if Keybind.flag then
                                Lib.Flags[Keybind.flag] = state
                            end
                            Keybind.callback(true)
                        end
                    end
                else
                    state = newkey
                    if Keybind.flag then
                        Lib.Flags[Keybind.flag] = newkey
                    end
                    Keybind.callback(newkey)
                end
            end

            set(Keybind.state)
            set(Keybind.mode)

            ToggleFrame.MouseButton1Click:Connect(function()
                if not Keybind.binding then
                    Keycode.Text = "..."
                    TweenService:Create(Keycode, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Lib.Accent}):Play()
                    Lib.Main.Interactable = false

                    Keybind.binding = Lib:Connection(
                        UserInputService.InputBegan,
                        function(input,gpe)
                            if gpe then return end
                            if input.UserInputType == Enum.UserInputType.Touch then return end

                            set(
                                input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
                            )

                            Lib:Disconnection(Keybind.binding)
                            task.wait()
                            Keybind.binding = nil

                            Lib.Main.Interactable = true
                            TweenService:Create(Keycode, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(200,200,200)}):Play()
                        end
                    )
                end
            end)

            Lib:Connection(UserInputService.InputBegan, function(input, gpe)
                if gpe then return end

                if (input.KeyCode == Key or input.UserInputType == Key) and not Keybind.binding and not Keybind.useKey then
                    if Keybind.mode == "Hold" then
                        if Keybind.flag then
                            Lib.Flags[Keybind.flag] = true
                        end
                        c = Lib:Connection(RunService.RenderStepped, function()
                            if Keybind.callback then
                                Keybind.callback(true)
                            end
                        end)
                    elseif Keybind.mode == "Toggle" then
                        state = not state
                        if Keybind.flag then
                            Lib.Flags[Keybind.flag] = state
                        end
                        Keybind.callback(state)
                    end
                end
            end)

            Lib:Connection(UserInputService.InputEnded, function(inp, gpe)
                if gpe then return end

                if Keybind.mode == "Hold" and not Keybind.useKey then
                    if Key ~= "" or Key ~= "nil" then
                        if inp.KeyCode == Key or inp.UserInputType == Key then
                            if c then
                                c:Disconnect()
                                if Keybind.flag then
                                    Lib.Flags[Keybind.flag] = false
                                end
                                if Keybind.callback then
                                    Keybind.callback(false)
                                end
                            end
                        end
                    end
                end
            end)

            Lib:Connection(ToggleFrame.MouseEnter, function()
                TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Lib.Accent}):Play()
            end)

            Lib:Connection(ToggleFrame.MouseLeave, function()
                TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(25, 25, 33)}):Play()
            end)

            Lib.Flags[Keybind.flag.."_KEY"] = Keybind.state
            Lib.Flags[Keybind.flag.."_KEYSTATE"] = Keybind.mode

            Flags[Keybind.flag] = set
            Flags[Keybind.flag.."_KEY"] = set
            Flags[Keybind.flag.."_KEYSTATE"] = set

            function Keybind:Set(Key)
                set(Key)
            end

            return Keybind
        end

        function Sections:Button(args)
            if not args then args = {} end

            local button = {
                window = self.window,
                page = self.page,
                section = self,
                name = args.name or "button",
                callback = (args.callback or function() end)
            }

            local ButtonHolder = Instance.new("Frame")
            local UIPadding = Instance.new("UIPadding")
            local Button = Instance.new("TextButton")
            local UICorner = Instance.new("UICorner")
            local UIScale = Instance.new("UIScale")

            ButtonHolder.Name = "ButtonHolder"
            ButtonHolder.Parent = button.section.elements.Holder
            ButtonHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ButtonHolder.BackgroundTransparency = 1.000
            ButtonHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ButtonHolder.BorderSizePixel = 0
            ButtonHolder.Size = UDim2.new(1, 0, 0, 22)

            UIPadding.Parent = ButtonHolder

            Button.Name = "Button"
            Button.Parent = ButtonHolder
            Button.AnchorPoint = Vector2.new(0.5, 0.5)
            Button.BackgroundColor3 = Color3.fromRGB(25, 25, 33)
            Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Button.BorderSizePixel = 0
            Button.Position = UDim2.new(0.5, 0, 0.5, 0)
            Button.Size = UDim2.new(0, 170, 0, 17)
            Button.AutoButtonColor = false
            Button.FontFace = Lib.Font
            Button.Text = args.name
            Button.TextColor3 = Color3.fromRGB(210, 210, 210)
            Button.TextSize = Lib.FontSize

            UICorner.CornerRadius = UDim.new(0, 4)
            UICorner.Parent = Button

            UIScale.Parent = Button

            Lib:Connection(Button.MouseButton1Down, function()
                button.callback()
                TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
                TweenService:Create(UIScale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0.95}):Play()
            end)

            Lib:Connection(Button.MouseButton1Up, function()
                TweenService:Create(UIScale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1}):Play()
            end)
        end

        function Sections:Textbox(args)
            if not args then args = {} end
            
            local textbox = {
                window = self.window,
                page = self.page,
                section = self,
                placeholder = args.placeholder or "enter ur text here",
                state = args.state or "",
                callback = args.callback or function() end,
                flag = args.flag or Lib.NextFlag()
            }

            local TextboxHolder = Instance.new("Frame")
            local UIPadding = Instance.new("UIPadding")
            local TextBox = Instance.new("TextBox")
            local UICorner = Instance.new("UICorner")

            TextboxHolder.Name = "TextboxHolder"
            TextboxHolder.Parent = textbox.section.elements.Holder
            TextboxHolder.BackgroundTransparency = 1.000
            TextboxHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
            TextboxHolder.BorderSizePixel = 0
            TextboxHolder.Size = UDim2.new(1, 0, 0, 22)

            UIPadding.Parent = TextboxHolder

            TextBox.Parent = TextboxHolder
            TextBox.AnchorPoint = Vector2.new(0.5, 0.5)
            TextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 33)
            TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
            TextBox.BorderSizePixel = 0
            TextBox.Position = UDim2.new(0.5, 0, 0.5, 0)
            TextBox.Size = UDim2.new(0, 170, 0, 17)
            TextBox.FontFace = Lib.Font
            TextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
            TextBox.PlaceholderText = textbox.placeholder
            TextBox.Text = textbox.state
            TextBox.TextColor3 = Color3.fromRGB(210, 210, 210)
            TextBox.TextSize = Lib.FontSize

            UICorner.CornerRadius = UDim.new(0, 4)
            UICorner.Parent = TextBox

            TextBox.FocusLost:Connect(function()
                textbox.callback(TextBox.Text)
                Lib.Flags[textbox.flag] = TextBox.Text
            end)

            local function set(str)
                TextBox.Text = str
                Lib.Flags[textbox.flag] = str
                textbox.callback(str)
            end

            Flags[textbox.flag] = set
            Lib.Flags[textbox.flag] = TextBox.Text

            return textbox
        end

        function Lib:Watermark(args)
            if not args then args = {} end

            local watermark = {
                name = args.name or Lib.CheatName,
                game = args.game or Lib.Game,
                dragging = {false, UDim2.new(0,0,0,0)},
            }

            local NewWatermark = Instance.new("ImageButton")
            local UICorner = Instance.new("UICorner")
            local UIPadding = Instance.new("UIPadding")
            local Icon = Instance.new("ImageLabel")
            local line = Instance.new("Frame")
            local UIListLayout = Instance.new("UIListLayout")
            local cheatname = Instance.new("TextLabel")
            local line_2 = Instance.new("Frame")
            local gamename = Instance.new("TextLabel")
            local line_3 = Instance.new("Frame")
            local currenttime = Instance.new("TextLabel")

            NewWatermark.Name = "NewWatermark"
            NewWatermark.Parent = Lib.ScreenGui
            NewWatermark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            NewWatermark.BackgroundTransparency = 0.600
            NewWatermark.BorderColor3 = Color3.fromRGB(0, 0, 0)
            NewWatermark.AutomaticSize = Enum.AutomaticSize.X
            NewWatermark.AutoButtonColor = false
            NewWatermark.BorderSizePixel = 0
            NewWatermark.Position = UDim2.new(0, 30, 0, 31)
            NewWatermark.Size = UDim2.new(0, 0, 0, 30)
            NewWatermark.ZIndex = 1000
            NewWatermark.Interactable = true
            NewWatermark.Image = "rbxassetid://124125436867574"
            NewWatermark.ImageTransparency = 0.900

            UICorner.CornerRadius = UDim.new(0, 10)
            UICorner.Parent = NewWatermark

            UIPadding.Parent = NewWatermark
            UIPadding.PaddingLeft = UDim.new(0, 5)
            UIPadding.PaddingRight = UDim.new(0, 5)

            UIListLayout.Parent = NewWatermark
            UIListLayout.FillDirection = Enum.FillDirection.Horizontal
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            UIListLayout.Padding = UDim.new(0, 5)
            
            Icon.Name = "Icon"
            Icon.Parent = NewWatermark
            Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Icon.BackgroundTransparency = 1.000
            Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Icon.BorderSizePixel = 0
            Icon.Size = UDim2.new(0, 20, 0, 20)
            Icon.Image = "rbxassetid://89762329827268"

            line.Name = "line"
            line.Parent = NewWatermark
            line.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
            line.BorderSizePixel = 0
            line.Size = UDim2.new(0, 1, 0, 14)
                
            cheatname.Name = "cheatname"
            cheatname.Parent = NewWatermark
            cheatname.BackgroundTransparency = 1.000
            cheatname.AutomaticSize = Enum.AutomaticSize.X
            cheatname.FontFace = Lib.Font
            cheatname.Text = watermark.name
            cheatname.TextColor3 = Color3.fromRGB(255, 255, 255)
            cheatname.TextSize = Lib.FontSize

            line_2.Name = "line"
            line_2.Parent = NewWatermark
            line_2.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
            line_2.BorderSizePixel = 0
            line_2.Size = UDim2.new(0, 1, 0, 14)

            gamename.Name = "gamename"
            gamename.Parent = NewWatermark
            gamename.BackgroundTransparency = 1.000
            gamename.AutomaticSize = Enum.AutomaticSize.X
            gamename.FontFace = Lib.Font
            gamename.Text = watermark.game
            gamename.TextColor3 = Color3.fromRGB(255, 255, 255)
            gamename.TextSize = Lib.FontSize

            line_3.Name = "line"
            line_3.Parent = NewWatermark
            line_3.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
            line_3.BorderSizePixel = 0
            line_3.Size = UDim2.new(0, 1, 0, 14)

            currenttime.Name = "currenttime"
            currenttime.Parent = NewWatermark
            currenttime.BackgroundTransparency = 1.000
            currenttime.AutomaticSize = Enum.AutomaticSize.X
            currenttime.FontFace = Lib.Font
            currenttime.Text = tostring(os.date("%X"))
            currenttime.TextColor3 = Color3.fromRGB(255, 255, 255)
            currenttime.TextSize = Lib.FontSize

            task.spawn(function()
                if NewWatermark.Visible == true then
                    while task.wait(1) do
                        currenttime.Text = tostring(os.date("%X"))
                    end
                end
            end)

            function watermark:SetVisible(state)
                NewWatermark.Visible = state
            end

            Lib:Connection(NewWatermark.MouseButton1Down, function()
                if Lib.IsOpen == true then
                    local location = UserInputService:GetMouseLocation()
                    watermark.dragging[1] = true
                    watermark.dragging[2] = UDim2.new(0, location.X - NewWatermark.AbsolutePosition.X, 0, location.Y - NewWatermark.AbsolutePosition.Y)
                end
            end)
            --stop drag
            Lib:Connection(UserInputService.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    watermark.dragging[1] = false
                    watermark.dragging[2] = UDim2.new(0,0,0,0)
                end
            end)
            --drag
            Lib:Connection(UserInputService.InputChanged, function(input)
                local location = UserInputService:GetMouseLocation()
                local actual = nil

                if watermark.dragging[1] and Lib.IsOpen == true then
                    TweenService:Create(NewWatermark, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, location.X - watermark.dragging[2].X.Offset + (NewWatermark.Size.X.Offset * NewWatermark.AnchorPoint.X), 0,location.Y - watermark.dragging[2].Y.Offset + (NewWatermark.Size.Y.Offset * NewWatermark.AnchorPoint.Y))}):Play()
                end
            end)

            Lib.watermark = NewWatermark

            return watermark
        end

        function Lib:Configs(tab)
            local cfgs = tab:Section({name = "Config", side = "Left"})
            local window = tab:Section({name = "Menu", side = "Left"})
            local game = tab:Section({name = "Game", side = "Right"})

            local cfg_list = cfgs:List({name = "Config list", flag = "configuration_list", options = {}})
            cfgs:Textbox({flag = "configuration_name", placeholder = "Config name"})

            local current_list = {}

            local function update_cfg_list()
                local list = {}

                for idx, file in listfiles(Lib.FolderName .. "/Configs/" .. Lib.Game) do
                    local filename = file:match("([^\\/]+)$"):gsub(Lib.fileext, "")
                    list[#list + 1] = filename
                end

                local is_new = #list ~= #current_list

                if not is_new then
                    for idx = 1, #list do
                        if list[idx] ~= current_list[idx] then
                            is_new = true
                            break
                        end
                    end
                end

                if is_new then
                    current_list = list
                    cfg_list:Refresh(current_list)
                end
            end

            cfgs:Button({name = "Create", callback = function()
                local config_name = Lib.Flags.configuration_name
                if config_name == "" or isfile(Lib.FolderName .. "/Configs/" .. Lib.Game .. "/" .. config_name .. Lib.fileext) then
                    return
                end
                if not isfile(Lib.FolderName .. "/Configs/" .. Lib.Game .. "/" .. config_name .. Lib.fileext) then
                    writefile(Lib.FolderName .. "/Configs/" .. Lib.Game .. "/" .. config_name .. Lib.fileext, Lib:GetConfig())
                end
                update_cfg_list()
            end})

            cfgs:Button({name = "Save", callback = function()
                local selected_config = Lib.Flags.configuration_list
                if selected_config then
                    if isfile(Lib.FolderName .. "/Configs/" .. Lib.Game .. "/" .. selected_config .. Lib.fileext) then
                        writefile(Lib.FolderName .. "/Configs/" .. Lib.Game .. "/" .. selected_config .. Lib.fileext, Lib:GetConfig())
                    end
                end
            end})

            cfgs:Button({name = "Load", callback = function()
                local selected_config = Lib.Flags.configuration_list
                if selected_config then
                    if isfile(Lib.FolderName .. "/Configs/" .. Lib.Game .. "/" .. selected_config .. Lib.fileext) then
                        Lib:SetConfig(Lib.FolderName .. "/Configs/" .. Lib.Game .. "/" .. selected_config .. Lib.fileext)
                    end
                end
            end})

            cfgs:Button({name = "Refresh", callback = function()
                update_cfg_list()
            end})

            update_cfg_list()
        end
    end
end

return Lib
