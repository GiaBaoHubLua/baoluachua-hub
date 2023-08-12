

    if not game:IsLoaded() then repeat game.Loaded:Wait() until game:IsLoaded() end
    
    if game:GetService("Players").LocalPlayer.PlayerGui.Main:FindFirstChild("ChooseTeam") then
        repeat wait()
            if game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("Main").ChooseTeam.Visible == true then
                if _G.Team == "Pirate" then
                    for i, v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton.Activated)) do                                                                                                
                        v.Function()
                    end
                elseif _G.Team == "Marine" then
                    for i, v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Marines.Frame.ViewportFrame.TextButton.Activated)) do                                                                                                
                        v.Function()
                    end
                else
                    for i, v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton.Activated)) do                                                                                                
                        v.Function()
                    end
                end
            end
        until game.Players.LocalPlayer.Team ~= nil and game:IsLoaded()
    end

if game.CoreGui:FindFirstChild("MUKURO GUI") then
    game.CoreGui:FindFirstChild("MUKURO GUI"):Destroy()
end

local ScreenGui1 = Instance.new("ScreenGui")
local ImageButton1 = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")

ScreenGui1.Name = "ImageButton"
ScreenGui1.Parent = game.CoreGui
ScreenGui1.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ImageButton1.Parent = ScreenGui1
ImageButton1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ImageButton1.BorderSizePixel = 0
ImageButton1.Position = UDim2.new(0.120833337, 0, 0.0952890813, 0)
ImageButton1.Size = UDim2.new(0, 50, 0, 50)
ImageButton1.Draggable = true
ImageButton1.Image = "rbxassetid://14176817863"
ImageButton1.MouseButton1Down:connect(function()
  game:GetService("VirtualInputManager"):SendKeyEvent(true,305,false,game)
  game:GetService("VirtualInputManager"):SendKeyEvent(false,305,false,game)
end)
UICorner.Parent = ImageButton1

if game:GetService("CoreGui"):FindFirstChild("MUKURO GUI") then
	game:GetService("CoreGui"):FindFirstChild("MUKURO GUI"):Destroy()
end
local DiscordLib = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")
local pfp
local user
local tag
local userinfo = {}

pcall(function()
	userinfo = HttpService:JSONDecode(readfile("discordlibinfo.txt"))
end)

pfp = userinfo["pfp"] or "https://www.roblox.com/headshot-thumbnail/image?userId=" .. game.Players.LocalPlayer.UserId .. "&width=420&height=420&format=png"
user = userinfo["user"] or game.Players.LocalPlayer.DisplayName
tag = userinfo["tag"] or tostring(math.random(0001, 9999))

local function SaveInfo()
	userinfo["pfp"] = pfp
	userinfo["user"] = user
	userinfo["tag"] = tag
	writefile("discordlibinfo.txt", HttpService:JSONEncode(userinfo))
end

local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		local Tween = TweenService:Create(object, TweenInfo.new(0.15), {Position = pos})
		Tween:Play()
	end

	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPosition = object.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	topbarobject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			Update(input)
		end
	end)
end

local function RippleEffect(object)
	spawn(function()
		local Ripple = Instance.new("ImageLabel")

		Ripple.Name = "Ripple"
		Ripple.Parent = object
		Ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Ripple.BackgroundTransparency = 1.000
		Ripple.ZIndex = 8
		Ripple.Image = "rbxassetid://2708891598"
		Ripple.ImageTransparency = 0.800
		Ripple.ScaleType = Enum.ScaleType.Fit

		Ripple.Position = UDim2.new((Mouse.X) / object.AbsoluteSize.Y, 0, (Mouse.Y) / object.AbsoluteSize.X, 0)
		TweenService:Create(Ripple, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out),{Position = UDim2.new(-5.5, 0, -5.5, 0), Size = UDim2.new(3, 0, 3, 0)}):Play()

		wait(0.5)
		TweenService:Create(Ripple, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()

		wait(1)
		Ripple:Destroy()
	end)
end

local Discord = Instance.new("ScreenGui")
Discord.Name = "MUKURO GUI"
Discord.Parent = game:GetService("CoreGui")
Discord.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

function DiscordLib:Window(text,mainclr,cls)
	local PresetColor = mainclr or Color3.fromRGB(0,255,255) or _G.Color
	local CloseBind = cls or Enum.KeyCode.RightControl or _G.Toggle
	local currentservertoggled = ""
	local minimized = false
	local fs = false
	local settingsopened = false
	local MainFrame = Instance.new("Frame")
	local MainFrameGradient = Instance.new("UIGradient")
	local TopFrame = Instance.new("Frame")
	local Title = Instance.new("TextLabel")
	local CloseIcon = Instance.new("ImageLabel")
	local MinimizeBtn = Instance.new("TextButton")
	local MinimizeIcon = Instance.new("ImageLabel")
	local ServersHolder = Instance.new("Folder")
	local Userpad = Instance.new("Frame")
	local UserpadCorner = Instance.new("UICorner")
	local UserIcon = Instance.new("Frame")
	local UserIconCorner = Instance.new("UICorner")
	local UserImage = Instance.new("ImageLabel")
	local UserImageCorner = Instance.new("UICorner")
	local UserCircleImage = Instance.new("ImageLabel")
	local UserName = Instance.new("TextLabel")
	local UserTag = Instance.new("TextLabel")
	local ServersHoldFrame = Instance.new("Frame")
	local ServersHold = Instance.new("ScrollingFrame")
	local ServersHoldLayout = Instance.new("UIListLayout")
	local ServersHoldPadding = Instance.new("UIPadding")
	local TopFrameHolder = Instance.new("Frame")
	local GlowFrame = Instance.new("Frame")
	local Glow = Instance.new("ImageLabel")
	local GlowFrameCorner = Instance.new("UICorner")

	MainFrame.Name = "MainFrame"
	MainFrame.Parent = Discord
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.BackgroundColor3 = Color3.fromRGB(32, 34, 37)
	MainFrame.BackgroundTransparency = 1
	MainFrame.BorderSizePixel = 0
	MainFrame.ClipsDescendants = true
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.Size = UDim2.new(0, 618, 0, 407)

	local uitoggled = false
	UserInputService.InputBegan:Connect(function(io, p)
		pcall(function()
			if io.KeyCode == CloseBind then
				if uitoggled == false then
					MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true)
					wait(.3)
					Discord.Enabled = false
					uitoggled = true
				else
					Discord.Enabled = true
					MainFrame:TweenSize(UDim2.new(0, 618, 0, 407), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true)
					uitoggled = false
				end
			end
		end)
	end)

	GlowFrame.Name = "GlowFrame"
	GlowFrame.Parent = MainFrame
	GlowFrame.BackgroundTransparency = 1
	GlowFrame.Position = UDim2.new(0, 0.5, 0, 17.5)
	GlowFrame.Size = UDim2.new(0.625, 0,0.763, 0)
	GlowFrame.BackgroundColor3 = PresetColor

	GlowFrameCorner.CornerRadius = UDim.new(0, 7)
	GlowFrameCorner.Name = "GlowFrameCorner"
	GlowFrameCorner.Parent = GlowFrame

	Glow.Name = "Glow"
	Glow.Parent = GlowFrame
	Glow.BackgroundColor3 = PresetColor
	Glow.BackgroundTransparency = 1
	Glow.BorderSizePixel = 0
	Glow.Size = UDim2.new(0.625, 0,0.763, 0)
	Glow.ZIndex = 2
	Glow.Image = "rbxassetid://5028857084"
	Glow.ImageColor3 = PresetColor
	Glow.ScaleType = Enum.ScaleType.Slice

	TopFrame.Name = "TopFrame"
	TopFrame.Parent = MainFrame
	TopFrame.BackgroundColor3 = Color3.fromRGB(32, 34, 37)
	TopFrame.BackgroundTransparency = 1.000
	TopFrame.BorderSizePixel = 0
	TopFrame.Position = UDim2.new(-0.000658480625, 0, 0, 0)
	TopFrame.Size = UDim2.new(0, 681, 0, 65)

	TopFrameHolder.Name = "TopFrameHolder"
	TopFrameHolder.Parent = TopFrame
	TopFrameHolder.BackgroundColor3 = Color3.fromRGB(32, 34, 37)
	TopFrameHolder.BackgroundTransparency = 1.000
	TopFrameHolder.BorderSizePixel = 0
	TopFrameHolder.Position = UDim2.new(-0.000658480625, 0, 0, 0)
	TopFrameHolder.Size = UDim2.new(0, 681, 0, 22)

	Title.Name = "Title"
	Title.Parent = TopFrame
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.Position = UDim2.new(0.0102790017, 0, 0, 0)
	Title.Size = UDim2.new(0, 192, 0, 23)
	Title.Font = Enum.Font.Gotham
	Title.Text = text
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 13.000
	Title.TextXAlignment = Enum.TextXAlignment.Left

	ServersHolder.Name = "ServersHolder"
	ServersHolder.Parent = TopFrameHolder

	Userpad.Name = "Userpad"
	Userpad.Parent = TopFrameHolder
	Userpad.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Userpad.BackgroundTransparency = 1
	Userpad.BorderSizePixel = 0
	Userpad.Position = UDim2.new(0.0010243297, 0, 15.8807148, 0)
	Userpad.Size = UDim2.new(0, 179, 0, 43)

	UserIcon.Name = "UserIcon"
	UserIcon.Parent = Userpad
	UserIcon.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
	UserIcon.BackgroundTransparency = 1
	UserIcon.BorderSizePixel = 0
	UserIcon.Position = UDim2.new(0.0340000018, 0, 0.123999998, 0)
	UserIcon.Size = UDim2.new(0, 32, 0, 32)

	UserImage.Name = "UserImage"
	UserImage.Parent = UserIcon
	UserImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	UserImage.BackgroundTransparency = 1.000
	UserImage.Size = UDim2.new(0, 32, 0, 32)
	UserImage.Image = pfp

	UserCircleImage.Name = "UserImage"
	UserCircleImage.Parent = UserImage
	UserCircleImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	UserCircleImage.BackgroundTransparency = 1.000
	UserCircleImage.ImageColor3 = Color3.fromRGB(23, 23, 23)
	UserCircleImage.Size = UDim2.new(0, 32, 0, 32)
	UserCircleImage.Image = "rbxassetid://4031889928"
	UserCircleImage.ImageColor3 = Color3.fromRGB(27, 27, 27)

	UserName.Name = "UserName"
	UserName.Parent = Userpad
	UserName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	UserName.BackgroundTransparency = 1.000
	UserName.BorderSizePixel = 0
	UserName.Position = UDim2.new(0.230000004, 0, 0.115999997, 0)
	UserName.Size = UDim2.new(0, 98, 0, 17)
	UserName.Font = Enum.Font.GothamSemibold
	UserName.TextColor3 = PresetColor
	UserName.TextSize = 13.000
	UserName.TextXAlignment = Enum.TextXAlignment.Left
	UserName.ClipsDescendants = true

	UserTag.Name = "UserTag"
	UserTag.Parent = Userpad
	UserTag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	UserTag.BackgroundTransparency = 1.000
	UserTag.BorderSizePixel = 0
	UserTag.Position = UDim2.new(0.230000004, 0, 0.455000013, 0)
	UserTag.Size = UDim2.new(0, 95, 0, 17)
	UserTag.Font = Enum.Font.Gotham
	UserTag.TextColor3 = PresetColor
	UserTag.TextSize = 13.000
	UserTag.TextTransparency = 0.300
	UserTag.TextXAlignment = Enum.TextXAlignment.Left

	UserName.Text = user
	UserTag.Text = "#" .. tag

	ServersHoldFrame.Name = "ServersHoldFrame"
	ServersHoldFrame.Parent = MainFrame
	ServersHoldFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ServersHoldFrame.BackgroundTransparency = 1.000
	ServersHoldFrame.BorderColor3 = PresetColor
	ServersHoldFrame.Size = UDim2.new(0, 71, 0, 396)

	ServersHold.Name = "ServersHold"
	ServersHold.Parent = ServersHoldFrame
	ServersHold.Active = true
	ServersHold.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ServersHold.BackgroundTransparency = 1.000
	ServersHold.BorderSizePixel = 0
	ServersHold.Position = UDim2.new(-0.000359333731, 0, 0.0580808073, 0)
	ServersHold.Size = UDim2.new(0, 71, 0, 373)
	ServersHold.ScrollBarThickness = 1
	ServersHold.ScrollBarImageTransparency = 1
	ServersHold.CanvasSize = UDim2.new(0, 0, 0, 0)

	ServersHoldLayout.Name = "ServersHoldLayout"
	ServersHoldLayout.Parent = ServersHold
	ServersHoldLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ServersHoldLayout.Padding = UDim.new(0, 7)

	ServersHoldPadding.Name = "ServersHoldPadding"
	ServersHoldPadding.Parent = ServersHold

	function DiscordLib:Notification(titletext, desctext, btntext)
		local NotificationHolderMain = Instance.new("Frame")
		local NotificationHolderMainCorner = Instance.new("UICorner")
		local Notification = Instance.new("Frame")
		local NotificationCorner = Instance.new("UICorner")
		local UnderBar = Instance.new("Frame")
		local UnderBarCorner = Instance.new("UICorner")
		local UnderBarFrame = Instance.new("Frame")
		local Text1 = Instance.new("TextLabel")
		local Text2 = Instance.new("TextLabel")
		local AlrightBtn = Instance.new("TextButton")
		local AlrightCorner = Instance.new("UICorner")

		NotificationHolderMain.Name = "NotificationHolderMain"
		NotificationHolderMain.Parent = MainFrame
		NotificationHolderMain.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		NotificationHolderMain.BackgroundTransparency = 1
		NotificationHolderMain.BorderSizePixel = 0
		NotificationHolderMain.Position = UDim2.new(0, -1, 0.0460000017, 0)
		NotificationHolderMain.Size = UDim2.new(0, 676, 0, 374)
		TweenService:Create(
			NotificationHolderMain,
			TweenInfo.new(.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
			{BackgroundTransparency = 0.1}
		):Play()

		NotificationHolderMainCorner.CornerRadius = UDim.new(0, 7)
		NotificationHolderMainCorner.Name = "NotificationHolderMainCorner"
		NotificationHolderMainCorner.Parent = NotificationHolderMain

		Notification.Name = "Notification"
		Notification.Parent = NotificationHolderMain
		Notification.AnchorPoint = Vector2.new(0.5, 0.5)
		Notification.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
		Notification.ClipsDescendants = true
		Notification.Position = UDim2.new(0.524819076, 0, 0.469270051, 0)
		Notification.Size = UDim2.new(0, -43, 0, 0)
		Notification.BackgroundTransparency = 1

		Notification:TweenSize(UDim2.new(0, 346, 0, 176), Enum.EasingDirection.Out, Enum.EasingStyle.Back, .2, true)

		TweenService:Create(
			Notification,
			TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundTransparency = 0}
		):Play()

		NotificationCorner.CornerRadius = UDim.new(0, 5)
		NotificationCorner.Name = "NotificationCorner"
		NotificationCorner.Parent = Notification

		UnderBar.Name = "UnderBar"
		UnderBar.Parent = Notification
		UnderBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
		UnderBar.Position = UDim2.new(-0.000297061284, 0, 0.945048928, 0)
		UnderBar.Size = UDim2.new(0, 346, 0, 10)

		UnderBarCorner.CornerRadius = UDim.new(0, 5)
		UnderBarCorner.Name = "UnderBarCorner"
		UnderBarCorner.Parent = UnderBar

		UnderBarFrame.Name = "UnderBarFrame"
		UnderBarFrame.Parent = UnderBar
		UnderBarFrame.BackgroundColor3 = Color3.fromRGB(14,14,14)
		UnderBarFrame.BorderSizePixel = 0
		UnderBarFrame.Position = UDim2.new(-0.000297061284, 0, -3.76068449, 0)
		UnderBarFrame.Size = UDim2.new(0, 346, 0, 40)

		Text1.Name = "Text1"
		Text1.Parent = Notification
		Text1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Text1.BackgroundTransparency = 1.000
		Text1.Position = UDim2.new(-0.000594122568, 0, 0.0202020202, 0)
		Text1.Size = UDim2.new(0, 346, 0, 68)
		Text1.Font = Enum.Font.GothamSemibold
		Text1.Text = titletext
		Text1.TextColor3 = PresetColor
		Text1.TextSize = 20.000

		Text2.Name = "Text2"
		Text2.Parent = Notification
		Text2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Text2.BackgroundTransparency = 1.000
		Text2.Position = UDim2.new(0.106342293, 0, 0.317724228, 0)
		Text2.Size = UDim2.new(0, 272, 0, 63)
		Text2.Font = Enum.Font.Gotham
		Text2.Text = desctext
		Text2.TextColor3 = PresetColor
		Text2.TextSize = 14.000
		Text2.TextWrapped = true

		AlrightBtn.Name = "AlrightBtn"
		AlrightBtn.Parent = Notification
		AlrightBtn.BackgroundColor3 = PresetColor
		AlrightBtn.Position = UDim2.new(0.0332369953, 0, 0.789141417, 0)
		AlrightBtn.Size = UDim2.new(0, 322, 0, 27)
		AlrightBtn.Font = Enum.Font.Gotham
		AlrightBtn.Text = btntext
		AlrightBtn.TextColor3 = Color3.fromRGB(23, 23, 23)
		AlrightBtn.TextSize = 13.000
		AlrightBtn.AutoButtonColor = false

		AlrightCorner.CornerRadius = UDim.new(0, 4)
		AlrightCorner.Name = "AlrightCorner"
		AlrightCorner.Parent = AlrightBtn

		AlrightBtn.MouseButton1Click:Connect(function()
			TweenService:Create(
				NotificationHolderMain,
				TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundTransparency = 1}
			):Play()
			Notification:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
			TweenService:Create(
				Notification,
				TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundTransparency = 1}
			):Play()
			wait()
			NotificationHolderMain:Destroy()
		end)

		AlrightBtn.MouseEnter:Connect(function()
			TweenService:Create(
				AlrightBtn,
				TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundColor3 = Color3.fromRGB(23, 23, 23), TextColor3 = PresetColor}
			):Play()
		end)

		AlrightBtn.MouseLeave:Connect(function()
			TweenService:Create(
				AlrightBtn,
				TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundColor3 = PresetColor, TextColor3 = Color3.fromRGB(23, 23, 23)}
			):Play()
		end)
	end

	MakeDraggable(TopFrame, MainFrame)
	ServersHoldPadding.PaddingLeft = UDim.new(0, 14)
	local ServerHold = {}
	function ServerHold:Server(text, img)
		local fc = false
		local currentchanneltoggled = ""
		local Server = Instance.new("TextButton")
		local ServerBtnCorner = Instance.new("UICorner")
		local ServerIco = Instance.new("ImageLabel")
		local ServerWhiteFrame = Instance.new("Frame")
		local ServerWhiteFrameCorner = Instance.new("UICorner")

		Server.Name = text .. "Server"
		Server.Parent = ServersHold
		Server.BackgroundColor3 = Color3.fromRGB(20,20,20)
		Server.Position = UDim2.new(0.125, 0, 0, 0)
		Server.Size = UDim2.new(0, 47, 0, 47)
		Server.AutoButtonColor = false
		Server.Font = Enum.Font.Gotham
		Server.Text = ""
		Server.BackgroundTransparency = 1
		Server.TextTransparency = 1
		Server.TextColor3 = Color3.fromRGB(233, 25, 42)
		Server.TextSize = 18.000

		ServerBtnCorner.CornerRadius = UDim.new(1, 0)
		ServerBtnCorner.Name = "ServerCorner"
		ServerBtnCorner.Parent = Server

		ServerWhiteFrame.Name = "ServerWhiteFrame"
		ServerWhiteFrame.Parent = Server
		ServerWhiteFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		ServerWhiteFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ServerWhiteFrame.BackgroundTransparency = 1
		ServerWhiteFrame.Position = UDim2.new(-0.347378343, 0, 0.502659559, 0)
		ServerWhiteFrame.Size = UDim2.new(0, 11, 0, 10)

		ServerWhiteFrameCorner.CornerRadius = UDim.new(1, 0)
		ServerWhiteFrameCorner.Name = "ServerWhiteFrameCorner"
		ServerWhiteFrameCorner.Parent = ServerWhiteFrame
		ServersHold.CanvasSize = UDim2.new(0, 0, 0, ServersHoldLayout.AbsoluteContentSize.Y)

		local ServerFrame = Instance.new("Frame")
		local ServerTitleFrame = Instance.new("Frame")
		local ServerTitle = Instance.new("TextLabel")
		local GlowFrame = Instance.new("Frame")
		local Glow = Instance.new("ImageLabel")
		local ServerContentFrame = Instance.new("Frame")
		local ServerCorner = Instance.new("UICorner")
		local ChannelTitleFrame = Instance.new("Frame")
		local ChannelTitleFrameCorner = Instance.new("UICorner")
		local Hashtag = Instance.new("TextLabel")
		local ChannelTitle = Instance.new("TextLabel")
		local ChannelContentFrame = Instance.new("Frame")
		local ChannelContentFrameCorner = Instance.new("UICorner")
		local GlowChannel = Instance.new("ImageLabel")
		local ServerChannelHolder = Instance.new("ScrollingFrame")
		local ServerChannelHolderLayout = Instance.new("UIListLayout")
		local ServerChannelHolderPadding = Instance.new("UIPadding")
		local ServerTitleButtom = Instance.new("TextLabel")
		local TimeGlobal = Instance.new("TextLabel")
		local GameImage = Instance.new("ImageLabel")

		ServerFrame.Name = "ServerFrame"
		ServerFrame.Parent = ServersHolder
		ServerFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		ServerFrame.BorderSizePixel = 0
		ServerFrame.ClipsDescendants = true
		ServerFrame.Position = UDim2.new(0.005356875, 0, 0.32262593, 13)
		ServerFrame.Size = UDim2.new(0, 609, 0, 373)
		ServerFrame.Visible = false

		ServerTitleFrame.Name = "ServerTitleFrame"
		ServerTitleFrame.Parent = ServerFrame
		ServerTitleFrame.BackgroundColor3 = Color3.fromRGB(47, 49, 54)
		ServerTitleFrame.BackgroundTransparency = 1.000
		ServerTitleFrame.BorderSizePixel = 0
		ServerTitleFrame.Position = UDim2.new(-0.0010054264, 0, -0.000900391256, 0)
		ServerTitleFrame.Size = UDim2.new(0, 180, 0, 40)

		ServerTitle.Name = "ServerTitle"
		ServerTitle.Parent = ServerTitleFrame
		ServerTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ServerTitle.BackgroundTransparency = 1.000
		ServerTitle.BorderSizePixel = 0
		ServerTitle.Position = UDim2.new(0.0851359761, 0, 0, 0)
		ServerTitle.Size = UDim2.new(0, 97, 0, 39)
		ServerTitle.Font = Enum.Font.GothamSemibold
		ServerTitle.Text = text
		ServerTitle.TextColor3 = PresetColor
		ServerTitle.TextSize = 15.000
		ServerTitle.TextXAlignment = Enum.TextXAlignment.Left

		GlowFrame.Name = "GlowFrame"
		GlowFrame.Parent = ServerFrame
		GlowFrame.BackgroundColor3 = Color3.fromRGB(47, 49, 54)
		GlowFrame.BackgroundTransparency = 1.000
		GlowFrame.BorderSizePixel = 0
		GlowFrame.Position = UDim2.new(-0.0010054264, 0, -0.000900391256, 0)
		GlowFrame.Size = UDim2.new(0, 609, 0, 40)

		Glow.Name = "Glow"
		Glow.Parent = GlowFrame
		Glow.BackgroundColor3 = PresetColor
		Glow.BackgroundTransparency = 1.000
		Glow.BorderSizePixel = 0
		Glow.Position = UDim2.new(0, -15, 0, -15)
		Glow.Size = UDim2.new(1, 30, 1, 30)
		Glow.ZIndex = 0
		Glow.Image = "rbxassetid://4996891970"
		Glow.ImageColor3 = Color3.fromRGB(15, 15, 15)
		Glow.ScaleType = Enum.ScaleType.Slice
		Glow.SliceCenter = Rect.new(20, 20, 280, 280)

		ServerContentFrame.Name = "ServerContentFrame"
		ServerContentFrame.Parent = ServerFrame
		ServerContentFrame.BackgroundColor3 = Color3.fromRGB(47, 49, 54)
		ServerContentFrame.BackgroundTransparency = 1.000
		ServerContentFrame.BorderSizePixel = 0
		ServerContentFrame.Position = UDim2.new(-0.0010054264, 0, 0.106338218, 0)
		ServerContentFrame.Size = UDim2.new(0, 180, 0, 333)

		ServerCorner.CornerRadius = UDim.new(0, 7)
		ServerCorner.Name = "ServerCorner"
		ServerCorner.Parent = ServerFrame

		ChannelTitleFrame.Name = "ChannelTitleFrame"
		ChannelTitleFrame.Parent = ServerFrame
		ChannelTitleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		ChannelTitleFrame.BorderSizePixel = 0
		ChannelTitleFrame.Position = UDim2.new(0.294561088, 0, -0.000900391256, 0)
		ChannelTitleFrame.Size = UDim2.new(0, 429, 0, 40)

		ChannelTitleFrameCorner.CornerRadius = UDim.new(0, 7)
		ChannelTitleFrameCorner.Name = "ChannelTitleFrameCorner"
		ChannelTitleFrameCorner.Parent = ChannelTitleFrame

		TimeGlobal.Name = "TimeGlobal"
		TimeGlobal.Parent = ChannelTitleFrame
		TimeGlobal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TimeGlobal.Position = UDim2.new(0.7062470865, 0, 0, 0)
		TimeGlobal.Size = UDim2.new(0, 95, 0, 39)
		TimeGlobal.BackgroundTransparency = 1
		TimeGlobal.ZIndex = 3
		TimeGlobal.Font = Enum.Font.GothamSemibold
		TimeGlobal.Text = "TIME | N/A"
		TimeGlobal.TextColor3 = PresetColor
		TimeGlobal.TextSize = 15.000
		TimeGlobal.TextXAlignment = Enum.TextXAlignment.Left

		spawn(function()
			while wait() do
				TimeGlobal.Text = "TIME | "..os.date("%H")..":"..os.date("%M")..":"..os.date("%S")
			end
		end)

		ChannelTitle.Name = "ChannelTitle"
		ChannelTitle.Parent = ChannelTitleFrame
		ChannelTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ChannelTitle.BackgroundTransparency = 1.000
		ChannelTitle.BorderSizePixel = 0
		ChannelTitle.Position = UDim2.new(0.0662470865, 0, 0, 0)
		ChannelTitle.Size = UDim2.new(0, 95, 0, 39)
		ChannelTitle.Font = Enum.Font.GothamSemibold
		ChannelTitle.Text = ""
		ChannelTitle.TextColor3 = PresetColor
		ChannelTitle.TextSize = 15.000
		ChannelTitle.TextXAlignment = Enum.TextXAlignment.Left

		ChannelContentFrame.Name = "ChannelContentFrame"
		ChannelContentFrame.Parent = ServerFrame
		ChannelContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		ChannelContentFrame.BorderSizePixel = 0
		ChannelContentFrame.ClipsDescendants = true
		ChannelContentFrame.Position = UDim2.new(0.294561088, 0, 0.106338218, 0)
		ChannelContentFrame.Size = UDim2.new(0, 429, 0, 333)

		ChannelContentFrameCorner.CornerRadius = UDim.new(0, 7)
		ChannelContentFrameCorner.Name = "ChannelContentFrameCorner"
		ChannelContentFrameCorner.Parent = ChannelContentFrame

		GlowChannel.Name = "GlowChannel"
		GlowChannel.Parent = ChannelContentFrame
		GlowChannel.BackgroundColor3 = PresetColor
		GlowChannel.BackgroundTransparency = 1.000
		GlowChannel.BorderSizePixel = 0
		GlowChannel.Position = UDim2.new(0, -33, 0, -91)
		GlowChannel.Size = UDim2.new(1.06396091, 30, 0.228228226, 30)
		GlowChannel.ZIndex = 0
		GlowChannel.Image = "rbxassetid://4996891970"
		GlowChannel.ImageColor3 = Color3.fromRGB(15, 15, 15)
		GlowChannel.ScaleType = Enum.ScaleType.Slice
		GlowChannel.SliceCenter = Rect.new(20, 20, 280, 280)

		ServerChannelHolder.Name = "ServerChannelHolder"
		ServerChannelHolder.Parent = ServerContentFrame
		ServerChannelHolder.Active = true
		ServerChannelHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ServerChannelHolder.BackgroundTransparency = 1.000
		ServerChannelHolder.BorderSizePixel = 0
		ServerChannelHolder.Position = UDim2.new(0.00535549596, 0, 0.0241984241, 0)
		ServerChannelHolder.Selectable = false
		ServerChannelHolder.Size = UDim2.new(0, 179, 0, 278)
		ServerChannelHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
		ServerChannelHolder.ScrollBarThickness = 4
		ServerChannelHolder.ScrollBarImageColor3 = PresetColor
		ServerChannelHolder.ScrollBarImageTransparency = 1

		ServerChannelHolderLayout.Name = "ServerChannelHolderLayout"
		ServerChannelHolderLayout.Parent = ServerChannelHolder
		ServerChannelHolderLayout.SortOrder = Enum.SortOrder.LayoutOrder
		ServerChannelHolderLayout.Padding = UDim.new(0, 4)

		ServerChannelHolderPadding.Name = "ServerChannelHolderPadding"
		ServerChannelHolderPadding.Parent = ServerChannelHolder
		ServerChannelHolderPadding.PaddingLeft = UDim.new(0, 9)

		ServerChannelHolder.MouseEnter:Connect(function()
			ServerChannelHolder.ScrollBarImageTransparency = 0
		end)

		ServerChannelHolder.MouseLeave:Connect(function()
			ServerChannelHolder.ScrollBarImageTransparency = 1
		end)

		Server.MouseEnter:Connect(function()
			if currentservertoggled ~= Server.Name then
				TweenService:Create(
					Server,
					TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{BackgroundColor3 = Color3.fromRGB(23, 23, 23)}
				):Play()
				TweenService:Create(
					ServerBtnCorner,
					TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{CornerRadius = UDim.new(0, 15)}
				):Play()
				ServerWhiteFrame:TweenSize(
					UDim2.new(0, 11, 0, 27),
					Enum.EasingDirection.Out,
					Enum.EasingStyle.Quart,
					.3,
					true
				)
			end
		end)

		Server.MouseLeave:Connect(function()
			if currentservertoggled ~= Server.Name then
				TweenService:Create(
					Server,
					TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{BackgroundColor3 = Color3.fromRGB(47, 49, 54)}
				):Play()
				TweenService:Create(
					ServerBtnCorner,
					TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{CornerRadius = UDim.new(1, 0)}
				):Play()
				ServerWhiteFrame:TweenSize(
					UDim2.new(0, 11, 0, 10),
					Enum.EasingDirection.Out,
					Enum.EasingStyle.Quart,
					.3,
					true
				)
			end
		end)

		Server.MouseButton1Click:Connect(function()
			currentservertoggled = Server.Name
			for i, v in next, ServersHolder:GetChildren() do
				if v.Name == "ServerFrame" then
					v.Visible = false
				end
				ServerFrame.Visible = true
			end
			for i, v in next, ServersHold:GetChildren() do
				if v.ClassName == "TextButton" then
					TweenService:Create(
						v,
						TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{BackgroundColor3 = Color3.fromRGB(47, 49, 54)}
					):Play()
					TweenService:Create(
						Server,
						TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{BackgroundColor3 = Color3.fromRGB(23, 23, 23)}
					):Play()
					TweenService:Create(
						v.ServerCorner,
						TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{CornerRadius = UDim.new(1, 0)}
					):Play()
					TweenService:Create(
						ServerBtnCorner,
						TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{CornerRadius = UDim.new(0, 15)}
					):Play()
					v.ServerWhiteFrame:TweenSize(
						UDim2.new(0, 11, 0, 10),
						Enum.EasingDirection.Out,
						Enum.EasingStyle.Quart,
						.3,
						true
					)
					ServerWhiteFrame:TweenSize(
						UDim2.new(0, 11, 0, 46),
						Enum.EasingDirection.Out,
						Enum.EasingStyle.Quart,
						.3,
						true
					)
				end
			end
		end)

		if img == "" then
			Server.Text = string.sub(text, 1, 1)
		else
			ServerIco.Image = img
		end

		if fs == false then
			TweenService:Create(
				Server,
				TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundColor3 = Color3.fromRGB(23, 23, 23)}
			):Play()
			TweenService:Create(
				ServerBtnCorner,
				TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{CornerRadius = UDim.new(0, 15)}
			):Play()
			ServerWhiteFrame:TweenSize(
				UDim2.new(0, 11, 0, 46),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quart,
				.3,
				true
			)
			ServerFrame.Visible = true
			Server.Name = text .. "Server"
			currentservertoggled = Server.Name
			fs = true
		end

		local ChannelHold = {}
		function ChannelHold:Channel(text,ico)
			local Icon = ico or ""
			local ChannelIcon = Instance.new("ImageLabel")
			local ChannelBtnOutline = Instance.new("Frame")
			local ChannelBtnOutlineCorner = Instance.new("UICorner")
			local ChannelBtn = Instance.new("TextButton")
			local ChannelBtnCorner = Instance.new("UICorner")
			local ChannelBtnHashtag = Instance.new("TextLabel")
			local ChannelBtnTitle = Instance.new("TextLabel")

			ChannelBtnOutline.Name = text.."ChannelBtn"
			ChannelBtnOutline.Parent = ServerChannelHolder
			ChannelBtnOutline.Position = UDim2.new(0.24118948, 0, 0.578947365, 0)
			ChannelBtnOutline.Size = UDim2.new(0, 162, 0, 32)
			ChannelBtnOutline.BackgroundColor3 = PresetColor

			ChannelBtnOutlineCorner.CornerRadius = UDim.new(0, 6)
			ChannelBtnOutlineCorner.Name = "ChannelBtnOutlineCorner"
			ChannelBtnOutlineCorner.Parent = ChannelBtnOutline

			ChannelBtn.Name = text .. "ChannelBtn"
			ChannelBtn.Parent = ChannelBtnOutline
			ChannelBtn.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
			ChannelBtn.BorderSizePixel = 0
			ChannelBtn.Position = UDim2.new(0.002761, 0, 0.02761, 0)
			ChannelBtn.Size = UDim2.new(0, 160, 0, 30)
			ChannelBtn.AutoButtonColor = false
			ChannelBtn.Font = Enum.Font.SourceSans
			ChannelBtn.Text = ""
			ChannelBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
			ChannelBtn.TextSize = 14.000

			ChannelBtnCorner.CornerRadius = UDim.new(0, 6)
			ChannelBtnCorner.Name = "ChannelBtnCorner"
			ChannelBtnCorner.Parent = ChannelBtn

			ChannelIcon.Name = "TabIcon"
			ChannelIcon.Parent = ChannelBtn
			ChannelIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ChannelIcon.BackgroundTransparency = 1.000
			ChannelIcon.Position = UDim2.new(0.0234146333, 0, 0.12, 0)
			ChannelIcon.Size = UDim2.new(0, 20, 0, 20)
			ChannelIcon.Image = Icon
			ChannelIcon.ImageTransparency = 0

			ChannelBtnTitle.Name = "ChannelBtnTitle"
			ChannelBtnTitle.Parent = ChannelBtn
			ChannelBtnTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ChannelBtnTitle.BackgroundTransparency = 1.000
			ChannelBtnTitle.BorderSizePixel = 0
			ChannelBtnTitle.Position = UDim2.new(0.163747092, 0, -0.166666672, 0)
			ChannelBtnTitle.Size = UDim2.new(0, 95, 0, 39)
			ChannelBtnTitle.Font = Enum.Font.Gotham
			ChannelBtnTitle.Text = text
			ChannelBtnTitle.TextColor3 = PresetColor
			ChannelBtnTitle.TextSize = 14.000
			ChannelBtnTitle.TextXAlignment = Enum.TextXAlignment.Left
			ServerChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ServerChannelHolderLayout.AbsoluteContentSize.Y)

			local ChannelHolder = Instance.new("ScrollingFrame")
			local ChannelHolderLayout = Instance.new("UIListLayout")

			ChannelHolder.Name = "ChannelHolder"
			ChannelHolder.Parent = ChannelContentFrame
			ChannelHolder.Active = true
			ChannelHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ChannelHolder.BackgroundTransparency = 1.000
			ChannelHolder.BorderSizePixel = 0
			ChannelHolder.Position = UDim2.new(0.0360843192, 0, 0.0241984241, 0)
			ChannelHolder.Size = UDim2.new(0, 412, 0, 314)
			ChannelHolder.ScrollBarThickness = 6
			ChannelHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
			ChannelHolder.ScrollBarImageTransparency = 0
			ChannelHolder.ScrollBarImageColor3 = PresetColor
			ChannelHolder.Visible = false
			ChannelHolder.ClipsDescendants = false

			ChannelHolderLayout.Name = "ChannelHolderLayout"
			ChannelHolderLayout.Parent = ChannelHolder
			ChannelHolderLayout.SortOrder = Enum.SortOrder.LayoutOrder
			ChannelHolderLayout.Padding = UDim.new(0, 6)

			ChannelBtn.MouseEnter:Connect(function()
				if currentchanneltoggled ~= ChannelBtn.Name then
					ChannelBtn.BackgroundColor3 = PresetColor
					ChannelBtnTitle.TextColor3 = Color3.fromRGB(27, 27, 27)
				end
			end)

			ChannelBtn.MouseLeave:Connect(function()
				if currentchanneltoggled ~= ChannelBtn.Name then
					ChannelBtn.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
					ChannelBtnTitle.TextColor3 = PresetColor
				end
			end)

			ChannelBtn.MouseEnter:Connect(function()
				if currentchanneltoggled == ChannelBtn.Name then
					ChannelBtn.BackgroundColor3 = PresetColor
					ChannelBtnTitle.TextColor3 = Color3.fromRGB(27, 27, 27)
				end
			end)

			ChannelBtn.MouseLeave:Connect(function()
				if currentchanneltoggled == ChannelBtn.Name then
					ChannelBtn.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
					ChannelBtnTitle.TextColor3 = PresetColor
				end
			end)

			ChannelBtn.MouseButton1Click:Connect(function()
				for i, v in next, ChannelContentFrame:GetChildren() do
					if v.Name == "ChannelHolder" then
						v.Visible = false
					end
					ChannelHolder.Visible = true
				end
				for i, v in next, ServerChannelHolder:GetChildren() do
					if v.ClassName == "TextButton" then
						v.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
						v.ChannelBtnTitle.TextColor3 = PresetColor
					end
					ServerFrame.Visible = true
				end
				ChannelTitle.Text = text
				ChannelBtn.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
				ChannelBtnTitle.TextColor3 = PresetColor
				currentchanneltoggled = ChannelBtn.Name
			end)

			if fc == false then
				fc = true
				ChannelTitle.Text = text
				ChannelBtn.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
				ChannelBtnTitle.TextColor3 = PresetColor
				currentchanneltoggled = ChannelBtn.Name
				ChannelHolder.Visible = true
			end

			local ChannelContent = {}
			function ChannelContent:Button(text, callback)
				local Button = Instance.new("TextButton")
				local ButtonCorner = Instance.new("UICorner")

				Button.Name = "Button"
				Button.Parent = ChannelHolder
				Button.BackgroundColor3 = Color3.fromRGB(23, 23, 23)
				Button.Size = UDim2.new(0, 401, 0, 30)
				Button.AutoButtonColor = false
				Button.Font = Enum.Font.Gotham
				Button.TextColor3 = PresetColor
				Button.TextSize = 14.000
				Button.Text = text

				ButtonCorner.CornerRadius = UDim.new(0, 4)
				ButtonCorner.Name = "ButtonCorner"
				ButtonCorner.Parent = Button

				Button.MouseEnter:Connect(function()
					TweenService:Create(
						Button,
						TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{BackgroundColor3 = PresetColor, TextColor3 = Color3.fromRGB(23, 23, 23)}
					):Play()
				end)

				Button.MouseButton1Click:Connect(function()
					pcall(callback)
					Button.TextSize = 0
					TweenService:Create(
						Button,
						TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{TextSize = 14}
					):Play()
				end)

				Button.MouseLeave:Connect(function()
					TweenService:Create(
						Button,
						TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{BackgroundColor3 = Color3.fromRGB(23, 23, 23), TextColor3 = PresetColor}
					):Play()
				end)
				ChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)
			end

            function ChannelContent:Toggle(text, default, callback)
                local toggled = false
                local Toggle = Instance.new("TextButton")
                local ToggleTitle = Instance.new("TextLabel")
                local ToggleFrame = Instance.new("Frame")
                local ToggleFrameCorner = Instance.new("UICorner")
                local ToggleFrameCircle = Instance.new("Frame")
                local ToggleFrameCircleCorner = Instance.new("UICorner")
                local ToggleFrameOutline = Instance.new("Frame")
                local ToggleFrameOutlineCorner = Instance.new("UICorner")
                local Icon = Instance.new("ImageLabel")

                Toggle.Name = "Toggle"
                Toggle.Parent = ChannelHolder
                Toggle.BackgroundColor3 = Color3.fromRGB(23, 23, 23)
                Toggle.BorderSizePixel = 0
                Toggle.Position = UDim2.new(0.261979163, 0, 0.190789461, 0)
                Toggle.Size = UDim2.new(0, 401, 0, 30)
                Toggle.AutoButtonColor = false
                Toggle.Font = Enum.Font.Gotham
                Toggle.Text = ""
                Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
                Toggle.TextSize = 14.000

                ToggleTitle.Name = "ToggleTitle"
                ToggleTitle.Parent = Toggle
                ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleTitle.BackgroundTransparency = 1.000
                ToggleTitle.Position = UDim2.new(0, 5, 0, 0)
                ToggleTitle.Size = UDim2.new(0, 200, 0, 30)
                ToggleTitle.Font = Enum.Font.Gotham
                ToggleTitle.Text = text
                ToggleTitle.TextColor3 = PresetColor
                ToggleTitle.TextSize = 14.000
                ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

                ToggleFrameOutline.Name = "ToggleFrameOutline"
                ToggleFrameOutline.Parent = Toggle
                ToggleFrameOutline.BackgroundColor3 = PresetColor
                ToggleFrameOutline.Position = UDim2.new(0.900481343, -5, 0.16300018, 0)
                ToggleFrameOutline.Size = UDim2.new(0, 41, 0, 22)

                ToggleFrameOutlineCorner.CornerRadius = UDim.new(1, 8)
                ToggleFrameOutlineCorner.Name = "ToggleFrameOutlineCorner"
                ToggleFrameOutlineCorner.Parent = ToggleFrameOutline

                ToggleFrame.Name = "ToggleFrame"
                ToggleFrame.Parent = ToggleFrameOutline
                ToggleFrame.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
                ToggleFrame.Size = UDim2.new(0, 39, 0, 20)
                ToggleFrame.Position = UDim2.new(0, 1, 0.03761, 0)

                ToggleFrameCorner.CornerRadius = UDim.new(1, 8)
                ToggleFrameCorner.Name = "ToggleFrameCorner"
                ToggleFrameCorner.Parent = ToggleFrame

                ToggleFrameCircle.Name = "ToggleFrameCircle"
                ToggleFrameCircle.Parent = ToggleFrame
                ToggleFrameCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleFrameCircle.Position = UDim2.new(0.234999999, -5, 0.133000001, 0)
                ToggleFrameCircle.Size = UDim2.new(0, 15, 0, 15)

                ToggleFrameCircleCorner.CornerRadius = UDim.new(1, 0)
                ToggleFrameCircleCorner.Name = "ToggleFrameCircleCorner"
                ToggleFrameCircleCorner.Parent = ToggleFrameCircle

                Icon.Name = "Icon"
                Icon.Parent = ToggleFrameCircle
                Icon.AnchorPoint = Vector2.new(0.5, 0.5)
                Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Icon.BackgroundTransparency = 1.000
                Icon.BorderColor3 = Color3.fromRGB(27, 42, 53)
                Icon.Position = UDim2.new(0, 8, 0, 8)
                Icon.Size = UDim2.new(0, 13, 0, 13)
                Icon.Image = "http://www.roblox.com/asset/?id=6035047409"
                Icon.ImageColor3 = Color3.fromRGB(31, 31, 31)

                if default == true then
                    TweenService:Create(
                        Icon,
                        TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {ImageColor3 = PresetColor}
                    ):Play()
                    TweenService:Create(
                        ToggleFrame,
                        TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = PresetColor}
                    ):Play()
                    ToggleFrameCircle:TweenPosition(UDim2.new(0.655, -5, 0.133000001, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3,true)
                    TweenService:Create(
                        Icon,
                        TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {ImageTransparency = 1}
                    ):Play()
                    Icon.Image = "http://www.roblox.com/asset/?id=6023426926"
                    wait(.1)
                    TweenService:Create(
                        Icon,
                        TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {ImageTransparency = 0}
                    ):Play()
                    toggled = not toggled
                    pcall(callback, toggled)
                end
                 
                Toggle.MouseButton1Click:Connect(function()
                    if toggled == false then
                        TweenService:Create(
                            Icon,
                            TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {ImageColor3 = PresetColor}
                        ):Play()
                        TweenService:Create(
                            ToggleFrame,
                            TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundColor3 = PresetColor}
                        ):Play()
                        ToggleFrameCircle:TweenPosition(UDim2.new(0.655, -5, 0.133000001, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true)
                        TweenService:Create(
                            Icon,
                            TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {ImageTransparency = 1}
                        ):Play()
                        Icon.Image = "http://www.roblox.com/asset/?id=6023426926"
                        wait(.1)
                        TweenService:Create(
                            Icon,
                            TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {ImageTransparency = 0}
                        ):Play()
                    else
                        TweenService:Create(
                            Icon,
                            TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {ImageColor3 = Color3.fromRGB(31, 31, 31)}
                        ):Play()
                        TweenService:Create(
                            ToggleFrame,
                            TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundColor3 = Color3.fromRGB(31, 31, 31)}
                        ):Play()
                        ToggleFrameCircle:TweenPosition(UDim2.new(0.234999999, -5, 0.133000001, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true)
                        TweenService:Create(
                            Icon,
                            TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {ImageTransparency = 1}
                        ):Play()
                        Icon.Image = "http://www.roblox.com/asset/?id=6035047409"
                        wait(.1)
                        TweenService:Create(
                            Icon,
                            TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {ImageTransparency = 0}
                        ):Play()
                    end
                    toggled = not toggled
                    pcall(callback, toggled)
                end)

                ChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)
            end

			function ChannelContent:Slider(text, min, max, start, callback)
				local SliderFunc = {}
				local dragging = false
				local Slider = Instance.new("TextButton")
				local SliderTitle = Instance.new("TextLabel")
				local SliderFrame = Instance.new("Frame")
				local SliderFrameCorner = Instance.new("UICorner")
				local CurrentValueFrame = Instance.new("Frame")
				local CurrentValueFrameCorner = Instance.new("UICorner")
				local Zip = Instance.new("Frame")
				local ZipCorner = Instance.new("UICorner")
				local ValueBubble = Instance.new("Frame")
				local ValueBubbleCorner = Instance.new("UICorner")
				local SquareBubble = Instance.new("Frame")
				local GlowBubble = Instance.new("ImageLabel")
				local ValueLabel = Instance.new("TextLabel")

				Slider.Name = "Slider"
				Slider.Parent = ChannelHolder
				Slider.BackgroundColor3 = Color3.fromRGB(23, 23, 23)
				Slider.BorderSizePixel = 0
				Slider.Position = UDim2.new(0, 0, 0.216560602, 0)
				Slider.Size = UDim2.new(0, 401, 0, 38)
				Slider.AutoButtonColor = false
				Slider.Font = Enum.Font.Gotham
				Slider.Text = ""
				Slider.TextColor3 = Color3.fromRGB(255, 255, 255)
				Slider.TextSize = 14.000

				SliderTitle.Name = "SliderTitle"
				SliderTitle.Parent = Slider
				SliderTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderTitle.BackgroundTransparency = 1.000
				SliderTitle.Position = UDim2.new(0, 5, 0, -4)
				SliderTitle.Size = UDim2.new(0, 200, 0, 27)
				SliderTitle.Font = Enum.Font.Gotham
				SliderTitle.Text = text
				SliderTitle.TextColor3 = PresetColor
				SliderTitle.TextSize = 14.000
				SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

				SliderFrame.Name = "SliderFrame"
				SliderFrame.Parent = Slider
				SliderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
				SliderFrame.BackgroundColor3 = Color3.fromRGB(79, 84, 92)
				SliderFrame.Position = UDim2.new(0.497999996, 0, 0.757000029, 0)
				SliderFrame.Size = UDim2.new(0, 385, 0, 8)

				SliderFrameCorner.Name = "SliderFrameCorner"
				SliderFrameCorner.Parent = SliderFrame

				CurrentValueFrame.Name = "CurrentValueFrame"
				CurrentValueFrame.Parent = SliderFrame
				CurrentValueFrame.BackgroundColor3 = PresetColor
				CurrentValueFrame.Size = UDim2.new((start or 0) / max, 0, 0, 8)

				CurrentValueFrameCorner.Name = "CurrentValueFrameCorner"
				CurrentValueFrameCorner.Parent = CurrentValueFrame

				Zip.Name = "Zip"
				Zip.Parent = SliderFrame
				Zip.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Zip.Position = UDim2.new((start or 0) / max, -6, -0.644999981, 0)
				Zip.Size = UDim2.new(0, 10, 0, 18)
				ZipCorner.CornerRadius = UDim.new(0, 3)
				ZipCorner.Name = "ZipCorner"
				ZipCorner.Parent = Zip

				ValueBubble.Name = "ValueBubble"
				ValueBubble.Parent = Zip
				ValueBubble.AnchorPoint = Vector2.new(0.5, 0.5)
				ValueBubble.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
				ValueBubble.Position = UDim2.new(0.5, 0, -1.00800002, 0)
				ValueBubble.Size = UDim2.new(0, 36, 0, 21)
				ValueBubble.Visible = false

				Zip.MouseEnter:Connect(function()
					if dragging == false then
						ValueBubble.Visible = true
					end
				end)

				Zip.MouseLeave:Connect(function()
					if dragging == false then
						ValueBubble.Visible = false
					end
				end)

				ValueBubbleCorner.CornerRadius = UDim.new(0, 3)
				ValueBubbleCorner.Name = "ValueBubbleCorner"
				ValueBubbleCorner.Parent = ValueBubble

				SquareBubble.Name = "SquareBubble"
				SquareBubble.Parent = ValueBubble
				SquareBubble.AnchorPoint = Vector2.new(0.5, 0.5)
				SquareBubble.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
				SquareBubble.BorderSizePixel = 0
				SquareBubble.Position = UDim2.new(0.493000001, 0, 0.637999971, 0)
				SquareBubble.Rotation = 45.000
				SquareBubble.Size = UDim2.new(0, 19, 0, 19)

				GlowBubble.Name = "GlowBubble"
				GlowBubble.Parent = ValueBubble
				GlowBubble.BackgroundColor3 = PresetColor
				GlowBubble.BackgroundTransparency = 1.000
				GlowBubble.BorderSizePixel = 0
				GlowBubble.Position = UDim2.new(0, -15, 0, -15)
				GlowBubble.Size = UDim2.new(1, 30, 1, 30)
				GlowBubble.ZIndex = 0
				GlowBubble.Image = "rbxassetid://4996891970"
				GlowBubble.ImageColor3 = Color3.fromRGB(15, 15, 15)
				GlowBubble.ScaleType = Enum.ScaleType.Slice
				GlowBubble.SliceCenter = Rect.new(20, 20, 280, 280)

				ValueLabel.Name = "ValueLabel"
				ValueLabel.Parent = ValueBubble
				ValueLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ValueLabel.BackgroundTransparency = 1.000
				ValueLabel.Size = UDim2.new(0, 36, 0, 21)
				ValueLabel.Font = Enum.Font.Gotham
				ValueLabel.Text = tostring(start and math.floor((start / max) * (max - min) + min) or 0)
				ValueLabel.TextColor3 = PresetColor
				ValueLabel.TextSize = 10.000

				local function move(input)
					local pos = UDim2.new(math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0 , 1), -6, -0.644999981, 0)
					local pos1 = UDim2.new(math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1), 0, 0, 8)
					CurrentValueFrame.Size = pos1
					Zip.Position = pos
					local value = math.floor(((pos.X.Scale * max) / max) * (max - min) + min)
					ValueLabel.Text = tostring(value)
					pcall(callback, value)
				end

				Zip.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = true
						ValueBubble.Visible = true
					end
				end)

				Zip.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
						ValueBubble.Visible = false
					end
				end)

				game:GetService("UserInputService").InputChanged:Connect(function(input)
					if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						move(input)
					end
				end)

				function SliderFunc:Change(tochange)
					CurrentValueFrame.Size = UDim2.new((tochange or 0) / max, 0, 0, 8)
					Zip.Position = UDim2.new((tochange or 0) / max, -6, -0.644999981, 0)
					ValueLabel.Text = tostring(tochange and math.floor((tochange / max) * (max - min) + min) or 0)
					pcall(callback, tochange)
				end

				ChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)
				return SliderFunc
			end

			function ChannelContent:Line()
				local Line1 = Instance.new("Frame")
				local Line2 = Instance.new("Frame")

				Line1.Name = "Line1"
				Line1.Parent = ChannelHolder
				Line1.BackgroundColor3 = PresetColor
				Line1.BackgroundTransparency = 1.000
				Line1.Position = UDim2.new(0, 0, 0.350318581, 0)
				Line1.Size = UDim2.new(0, 100, 0, 8)

				Line2.Name = "Line2"
				Line2.Parent = Line1
				Line2.BackgroundColor3 = PresetColor
				Line2.BorderSizePixel = 0
				Line2.Position = UDim2.new(0, 0, 0, 4)
				Line2.Size = UDim2.new(0, 401, 0, 1)
				ChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)
			end

			function ChannelContent:Dropdown(text, list, callback)
				local DropFunc = {}
				local itemcount = 0
				local framesize = 0
				local DropTog = false
				local Dropdown = Instance.new("Frame")
				local DropdownTitle = Instance.new("TextLabel")
				local DropdownFrameOutline = Instance.new("Frame")
				local DropdownFrameOutlineCorner = Instance.new("UICorner")
				local DropdownFrame = Instance.new("Frame")
				local DropdownFrameCorner = Instance.new("UICorner")
				local CurrentSelectedText = Instance.new("TextLabel")
				local ArrowImg = Instance.new("ImageLabel")
				local DropdownFrameBtn = Instance.new("TextButton")

				Dropdown.Name = "Dropdown"
				Dropdown.Parent = ChannelHolder
				Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Dropdown.BackgroundTransparency = 1.000
				Dropdown.Position = UDim2.new(0.0796874985, 0, 0.445175439, 0)
				Dropdown.Size = UDim2.new(0, 403, 0, 60)

				DropdownTitle.Name = "DropdownTitle"
				DropdownTitle.Parent = Dropdown
				DropdownTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownTitle.BackgroundTransparency = 1.000
				DropdownTitle.Position = UDim2.new(0, 5, 0, 0)
				DropdownTitle.Size = UDim2.new(0, 200, 0, 29)
				DropdownTitle.Font = Enum.Font.Gotham
				DropdownTitle.Text = ""
				DropdownTitle.TextColor3 = PresetColor
				DropdownTitle.TextSize = 14.000
				DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left

				DropdownFrameOutline.Name = "DropdownFrameOutline"
				DropdownFrameOutline.Parent = DropdownTitle
				DropdownFrameOutline.AnchorPoint = Vector2.new(0.5, 0.5)
				DropdownFrameOutline.BackgroundColor3 = PresetColor
				DropdownFrameOutline.Position = UDim2.new(0.988442957, 0, 1.0197437, 0)
				DropdownFrameOutline.Size = UDim2.new(0, 396, 0, 36)

				DropdownFrameOutlineCorner.CornerRadius = UDim.new(0, 3)
				DropdownFrameOutlineCorner.Name = "DropdownFrameOutlineCorner"
				DropdownFrameOutlineCorner.Parent = DropdownFrameOutline

				DropdownFrame.Name = "DropdownFrame"
				DropdownFrame.Parent = DropdownTitle
				DropdownFrame.BackgroundColor3 = Color3.fromRGB(23, 23, 23)
				DropdownFrame.ClipsDescendants = true
				DropdownFrame.Position = UDim2.new(0.00899999978, 0, 0.46638527, 0)
				DropdownFrame.Selectable = true
				DropdownFrame.Size = UDim2.new(0, 392, 0, 32)

				DropdownFrameCorner.CornerRadius = UDim.new(0, 3)
				DropdownFrameCorner.Name = "DropdownFrameCorner"
				DropdownFrameCorner.Parent = DropdownFrame

				CurrentSelectedText.Name = "CurrentSelectedText"
				CurrentSelectedText.Parent = DropdownFrame
				CurrentSelectedText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				CurrentSelectedText.BackgroundTransparency = 1.000
				CurrentSelectedText.Position = UDim2.new(0.0178571437, 0, 0, 0)
				CurrentSelectedText.Size = UDim2.new(0, 193, 0, 32)
				CurrentSelectedText.Font = Enum.Font.Gotham
				CurrentSelectedText.Text = text
				CurrentSelectedText.TextTransparency = 0.250
				CurrentSelectedText.TextColor3 = PresetColor
				CurrentSelectedText.TextSize = 14.000
				CurrentSelectedText.TextXAlignment = Enum.TextXAlignment.Left

				ArrowImg.Name = "ArrowImg"
				ArrowImg.Parent = CurrentSelectedText
				ArrowImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ArrowImg.BackgroundTransparency = 1.000
				ArrowImg.Position = UDim2.new(1.84974098, 0, 0.167428851, 0)
				ArrowImg.Size = UDim2.new(0, 22, 0, 22)
				ArrowImg.Image = "http://www.roblox.com/asset/?id=6034818372"
				ArrowImg.ImageColor3 = PresetColor

				DropdownFrameBtn.Name = "DropdownFrameBtn"
				DropdownFrameBtn.Parent = DropdownFrame
				DropdownFrameBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownFrameBtn.BackgroundTransparency = 1.000
				DropdownFrameBtn.Size = UDim2.new(0, 392, 0, 32)
				DropdownFrameBtn.Font = Enum.Font.SourceSans
				DropdownFrameBtn.Text = ""
				DropdownFrameBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
				DropdownFrameBtn.TextSize = 14.000

				local DropdownFrameMainOutline = Instance.new("Frame")
				local DropdownFrameMainOutlineCorner = Instance.new("UICorner")
				local DropdownFrameMain = Instance.new("Frame")
				local DropdownFrameMainCorner = Instance.new("UICorner")
				local DropItemHolderLabel = Instance.new("TextLabel")
				local DropItemHolder = Instance.new("ScrollingFrame")
				local DropItemHolderLayout = Instance.new("UIListLayout")

				DropdownFrameMainOutline.Name = "DropdownFrameMainOutline"
				DropdownFrameMainOutline.Parent = DropdownTitle
				DropdownFrameMainOutline.BackgroundColor3 = PresetColor
				DropdownFrameMainOutline.Position = UDim2.new(-0.00155700743, 0, 1.66983342, 0)
				DropdownFrameMainOutline.Size = UDim2.new(0, 396, 0, 81)
				DropdownFrameMainOutline.Visible = false

				DropdownFrameMainOutlineCorner.CornerRadius = UDim.new(0, 3)
				DropdownFrameMainOutlineCorner.Name = "DropdownFrameMainOutlineCorner"
				DropdownFrameMainOutlineCorner.Parent = DropdownFrameMainOutline

				DropdownFrameMain.Name = "DropdownFrameMain"
				DropdownFrameMain.Parent = DropdownTitle
				DropdownFrameMain.BackgroundColor3 = Color3.fromRGB(23, 23, 23)
				DropdownFrameMain.ClipsDescendants = true
				DropdownFrameMain.Position = UDim2.new(0.00799999978, 0, 1.7468965, 0)
				DropdownFrameMain.Selectable = true
				DropdownFrameMain.Size = UDim2.new(0, 392, 0, 77)
				DropdownFrameMain.Visible = false

				DropdownFrameMainCorner.CornerRadius = UDim.new(0, 3)
				DropdownFrameMainCorner.Name = "DropdownFrameMainCorner"
				DropdownFrameMainCorner.Parent = DropdownFrameMain

				DropItemHolderLabel.Name = "ItemHolderLabel"
				DropItemHolderLabel.Parent = DropdownFrameMain
				DropItemHolderLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropItemHolderLabel.BackgroundTransparency = 1.000
				DropItemHolderLabel.Position = UDim2.new(0.0178571437, 0, 0, 0)
				DropItemHolderLabel.Size = UDim2.new(0, 193, 0, 13)
				DropItemHolderLabel.Font = Enum.Font.Gotham
				DropItemHolderLabel.Text = ""
				DropItemHolderLabel.TextColor3 = PresetColor
				DropItemHolderLabel.TextSize = 14.000
				DropItemHolderLabel.TextXAlignment = Enum.TextXAlignment.Left

				DropItemHolder.Name = "ItemHolder"
				DropItemHolder.Parent = DropItemHolderLabel
				DropItemHolder.Active = true
				DropItemHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropItemHolder.BackgroundTransparency = 1.000
				DropItemHolder.Position = UDim2.new(0, 0, 0.215384638, 0)
				DropItemHolder.Size = UDim2.new(0, 385, 0, 0)
				DropItemHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
				DropItemHolder.ScrollBarThickness = 6
				DropItemHolder.BorderSizePixel = 0
				DropItemHolder.ScrollBarImageColor3 = PresetColor

				DropItemHolderLayout.Name = "ItemHolderLayout"
				DropItemHolderLayout.Parent = DropItemHolder
				DropItemHolderLayout.SortOrder = Enum.SortOrder.LayoutOrder
				DropItemHolderLayout.Padding = UDim.new(0, 0)

				DropdownFrameBtn.MouseButton1Click:Connect(function()
					if DropTog == false then
						DropdownFrameMain.Visible = true
						DropdownFrameMainOutline.Visible = true
						TweenService:Create(
							Dropdown,
							TweenInfo.new(.5, Enum.EasingStyle.Quart),
							{Size = UDim2.new(0, 403, 0, 60 + DropdownFrameMainOutline.AbsoluteSize.Y)}
						):Play()
						TweenService:Create(
							ChannelHolder,
							TweenInfo.new(.5, Enum.EasingStyle.Quart),
							{CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)}
						):Play()
					else
						DropdownFrameMain.Visible = false
						DropdownFrameMainOutline.Visible = false
						TweenService:Create(
							Dropdown,
							TweenInfo.new(.5, Enum.EasingStyle.Quart),
							{Size = UDim2.new(0, 403, 0, 60)}
						):Play()
						TweenService:Create(
							ChannelHolder,
							TweenInfo.new(.5, Enum.EasingStyle.Quart),
							{CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)}
						):Play()
						wait(.2)
					end
					DropTog = not DropTog
				end)

				for i, v in next, list do
					itemcount = itemcount + 1

					if itemcount == 1 then
						framesize = 29
					elseif itemcount == 2 then
						framesize = 58
					elseif itemcount >= 3 then
						framesize = 87
					end

					local Item = Instance.new("TextButton")
					local ItemCorner = Instance.new("UICorner")
					local ItemText = Instance.new("TextLabel")

					Item.Name = "Item"
					Item.Parent = DropItemHolder
					Item.BackgroundColor3 = Color3.fromRGB(42, 44, 48)
					Item.Size = UDim2.new(0, 379, 0, 29)
					Item.AutoButtonColor = false
					Item.Font = Enum.Font.SourceSans
					Item.Text = ""
					Item.TextColor3 = Color3.fromRGB(0, 0, 0)
					Item.TextSize = 14.000
					Item.BackgroundTransparency = 1

					ItemCorner.CornerRadius = UDim.new(0, 4)
					ItemCorner.Name = "ItemCorner"
					ItemCorner.Parent = Item

					ItemText.Name = "ItemText"
					ItemText.Parent = Item
					ItemText.BackgroundColor3 = Color3.fromRGB(42, 44, 48)
					ItemText.BackgroundTransparency = 1.000
					ItemText.Position = UDim2.new(0.0211081803, 0, 0, 0)
					ItemText.Size = UDim2.new(0, 192, 0, 29)
					ItemText.Font = Enum.Font.Gotham
					ItemText.TextColor3 = PresetColor
					ItemText.TextSize = 14.000
					ItemText.TextXAlignment = Enum.TextXAlignment.Left
					ItemText.Text = v

					Item.MouseEnter:Connect(function()
						ItemText.TextColor3 = Color3.fromRGB(255, 255, 255)
						Item.BackgroundTransparency = 0
					end)

					Item.MouseLeave:Connect(function()
						ItemText.TextColor3 = PresetColor
						Item.BackgroundTransparency = 1
					end)

					Item.MouseButton1Click:Connect(function()
						CurrentSelectedText.Text = v
						CurrentSelectedText.TextTransparency = 0.250
						pcall(callback, v)
						DropdownFrameMain.Visible = false
						DropdownFrameMainOutline.Visible = false
						TweenService:Create(
							Dropdown,
							TweenInfo.new(.5, Enum.EasingStyle.Quart),
							{Size = UDim2.new(0, 403, 0, 60)}
						):Play()
						TweenService:Create(
							ChannelHolder,
							TweenInfo.new(.5, Enum.EasingStyle.Quart),
							{CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)}
						):Play()
						wait(.2)
						DropTog = not DropTog
					end)

					DropItemHolder.CanvasSize = UDim2.new(0, 0, 0, DropItemHolderLayout.AbsoluteContentSize.Y)

					DropItemHolder.Size = UDim2.new(0, 385, 0, framesize)
					DropdownFrameMain.Size = UDim2.new(0, 392, 0, framesize + 6)
					DropdownFrameMainOutline.Size = UDim2.new(0, 396, 0, framesize + 10)
				end

				ChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)

				function DropFunc:Clear()
					for i, v in next, DropItemHolder:GetChildren() do
						if v.Name == "Item" then
							v:Destroy()
						end
					end

					CurrentSelectedText.Text = text
					CurrentSelectedText.TextTransparency = 0.250

					itemcount = 0
					framesize = 0
					DropItemHolder.Size = UDim2.new(0, 385, 0, 0)
					DropdownFrameMain.Size = UDim2.new(0, 392, 0, 0)
					DropdownFrameMainOutline.Size = UDim2.new(0, 396, 0, 0)
					Dropdown.Size = UDim2.new(0, 403, 0, 60)
					DropdownFrameMain.Visible = false
					DropdownFrameMainOutline.Visible = false
					ChannelHolder.CanvasSize = UDim2.new(0,0,0,ChannelHolderLayout.AbsoluteContentSize.Y)
				end

				function DropFunc:Add(textadd)
					itemcount = itemcount + 1

					if itemcount == 1 then
						framesize = 29
					elseif itemcount == 2 then
						framesize = 58
					elseif itemcount >= 3 then
						framesize = 87
					end

					local Item = Instance.new("TextButton")
					local ItemCorner = Instance.new("UICorner")
					local ItemText = Instance.new("TextLabel")

					Item.Name = "Item"
					Item.Parent = DropItemHolder
					Item.BackgroundColor3 = Color3.fromRGB(42, 44, 48)
					Item.Size = UDim2.new(0, 379, 0, 29)
					Item.AutoButtonColor = false
					Item.Font = Enum.Font.SourceSans
					Item.Text = ""
					Item.TextColor3 = Color3.fromRGB(0, 0, 0)
					Item.TextSize = 14.000
					Item.BackgroundTransparency = 1

					ItemCorner.CornerRadius = UDim.new(0, 4)
					ItemCorner.Name = "ItemCorner"
					ItemCorner.Parent = Item

					ItemText.Name = "ItemText"
					ItemText.Parent = Item
					ItemText.BackgroundColor3 = Color3.fromRGB(42, 44, 48)
					ItemText.BackgroundTransparency = 1.000
					ItemText.Position = UDim2.new(0.0211081803, 0, 0, 0)
					ItemText.Size = UDim2.new(0, 192, 0, 29)
					ItemText.Font = Enum.Font.Gotham
					ItemText.TextColor3 = PresetColor
					ItemText.TextSize = 14.000
					ItemText.TextXAlignment = Enum.TextXAlignment.Left
					ItemText.Text = textadd

					Item.MouseEnter:Connect(function()
						ItemText.TextColor3 = Color3.fromRGB(255, 255, 255)
						Item.BackgroundTransparency = 0
					end)

					Item.MouseLeave:Connect(function()
						ItemText.TextColor3 = PresetColor
						Item.BackgroundTransparency = 1
					end)

					Item.MouseButton1Click:Connect(function()
						CurrentSelectedText.Text = textadd
						CurrentSelectedText.TextTransparency = 0.250
						pcall(callback, textadd)
						DropdownFrameMain.Visible = false
						DropdownFrameMainOutline.Visible = false
						TweenService:Create(
							Dropdown,
							TweenInfo.new(.5, Enum.EasingStyle.Quart),
							{Size = UDim2.new(0, 403, 0, 60)}
						):Play()
						TweenService:Create(
							ChannelHolder,
							TweenInfo.new(.5, Enum.EasingStyle.Quart),
							{CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)}
						):Play()
						wait(.2)
						DropTog = not DropTog
					end)

					DropItemHolder.CanvasSize = UDim2.new(0, 0, 0, DropItemHolderLayout.AbsoluteContentSize.Y)

					DropItemHolder.Size = UDim2.new(0, 385, 0, framesize)
					DropdownFrameMain.Size = UDim2.new(0, 392, 0, framesize + 6)
					DropdownFrameMainOutline.Size = UDim2.new(0, 396, 0, framesize + 10)
				end
				return DropFunc
			end

			function ChannelContent:Colorpicker(text, preset, callback)
				local OldToggleColor = Color3.fromRGB(0, 0, 0)
				local OldColor = Color3.fromRGB(0, 0, 0)
				local OldColorSelectionPosition = nil
				local OldHueSelectionPosition = nil
				local ColorH, ColorS, ColorV = 1, 1, 1
				local RainbowColorPicker = false
				local ColorPickerInput = nil
				local ColorInput = nil
				local HueInput = nil

				local Colorpicker = Instance.new("Frame")
				local ColorpickerTitle = Instance.new("TextLabel")
				local ColorpickerFrameOutline = Instance.new("Frame")
				local ColorpickerFrameOutlineCorner = Instance.new("UICorner")
				local ColorpickerFrame = Instance.new("Frame")
				local ColorpickerFrameCorner = Instance.new("UICorner")
				local Color = Instance.new("ImageLabel")
				local ColorCorner = Instance.new("UICorner")
				local ColorSelection = Instance.new("ImageLabel")
				local Hue = Instance.new("ImageLabel")
				local HueCorner = Instance.new("UICorner")
				local HueGradient = Instance.new("UIGradient")
				local HueSelection = Instance.new("ImageLabel")
				local PresetClr = Instance.new("Frame")
				local PresetClrCorner = Instance.new("UICorner")

				Colorpicker.Name = "Colorpicker"
				Colorpicker.Parent = ChannelHolder
				Colorpicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Colorpicker.BackgroundTransparency = 1.000
				Colorpicker.Position = UDim2.new(0.0895741582, 0, 0.474232763, 0)
				Colorpicker.Size = UDim2.new(0, 403, 0, 175)

				ColorpickerTitle.Name = "ColorpickerTitle"
				ColorpickerTitle.Parent = Colorpicker
				ColorpickerTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ColorpickerTitle.BackgroundTransparency = 1.000
				ColorpickerTitle.Position = UDim2.new(0, 5, 0, 0)
				ColorpickerTitle.Size = UDim2.new(0, 200, 0, 29)
				ColorpickerTitle.Font = Enum.Font.Gotham
				ColorpickerTitle.Text = "Colorpicker"
				ColorpickerTitle.TextColor3 = PresetColor
				ColorpickerTitle.TextSize = 14.000
				ColorpickerTitle.TextXAlignment = Enum.TextXAlignment.Left

				ColorpickerFrameOutline.Name = "ColorpickerFrameOutline"
				ColorpickerFrameOutline.Parent = ColorpickerTitle
				ColorpickerFrameOutline.BackgroundColor3 = PresetColor
				ColorpickerFrameOutline.Position = UDim2.new(-0.00100000005, 0, 0.991999984, 0)
				ColorpickerFrameOutline.Size = UDim2.new(0, 238, 0, 139)

				ColorpickerFrameOutlineCorner.CornerRadius = UDim.new(0, 3)
				ColorpickerFrameOutlineCorner.Name = "ColorpickerFrameOutlineCorner"
				ColorpickerFrameOutlineCorner.Parent = ColorpickerFrameOutline

				ColorpickerFrame.Name = "ColorpickerFrame"
				ColorpickerFrame.Parent = ColorpickerTitle
				ColorpickerFrame.BackgroundColor3 = Color3.fromRGB(23, 23, 23)
				ColorpickerFrame.ClipsDescendants = true
				ColorpickerFrame.Position = UDim2.new(0.00899999978, 0, 1.06638515, 0)
				ColorpickerFrame.Selectable = true
				ColorpickerFrame.Size = UDim2.new(0, 234, 0, 135)

				ColorpickerFrameCorner.CornerRadius = UDim.new(0, 3)
				ColorpickerFrameCorner.Name = "ColorpickerFrameCorner"
				ColorpickerFrameCorner.Parent = ColorpickerFrame

				Color.Name = "Color"
				Color.Parent = ColorpickerFrame
				Color.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
				Color.Position = UDim2.new(0, 10, 0, 10)
				Color.Size = UDim2.new(0, 154, 0, 118)
				Color.ZIndex = 10
				Color.Image = "rbxassetid://4155801252"

				ColorCorner.CornerRadius = UDim.new(0, 3)
				ColorCorner.Name = "ColorCorner"
				ColorCorner.Parent = Color

				ColorSelection.Name = "ColorSelection"
				ColorSelection.Parent = Color
				ColorSelection.AnchorPoint = Vector2.new(0.5, 0.5)
				ColorSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ColorSelection.BackgroundTransparency = 1.000
				ColorSelection.Position = UDim2.new(preset and select(3, Color3.toHSV(preset)))
				ColorSelection.Size = UDim2.new(0, 18, 0, 18)
				ColorSelection.Image = "http://www.roblox.com/asset/?id=4805639000"
				ColorSelection.ScaleType = Enum.ScaleType.Fit

				Hue.Name = "Hue"
				Hue.Parent = ColorpickerFrame
				Hue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Hue.Position = UDim2.new(0, 171, 0, 10)
				Hue.Size = UDim2.new(0, 18, 0, 118)

				HueCorner.CornerRadius = UDim.new(0, 3)
				HueCorner.Name = "HueCorner"
				HueCorner.Parent = Hue

				HueGradient.Color = ColorSequence.new {ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(234, 255, 0)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(21, 255, 0)), ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.80, Color3.fromRGB(0, 17, 255)), ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 251)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))}
				HueGradient.Rotation = 270
				HueGradient.Name = "HueGradient"
				HueGradient.Parent = Hue

				HueSelection.Name = "HueSelection"
				HueSelection.Parent = Hue
				HueSelection.AnchorPoint = Vector2.new(0.5, 0.5)
				HueSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				HueSelection.BackgroundTransparency = 1.000
				HueSelection.Position = UDim2.new(0.48, 0, 1 - select(1, Color3.toHSV(preset)))
				HueSelection.Size = UDim2.new(0, 18, 0, 18)
				HueSelection.Image = "http://www.roblox.com/asset/?id=4805639000"

				PresetClr.Name = "PresetClr"
				PresetClr.Parent = ColorpickerFrame
				PresetClr.BackgroundColor3 = preset
				PresetClr.Position = UDim2.new(0.846153855, 0, 0.0740740746, 0)
				PresetClr.Size = UDim2.new(0, 25, 0, 25)

				PresetClrCorner.CornerRadius = UDim.new(0, 3)
				PresetClrCorner.Name = "PresetClrCorner"
				PresetClrCorner.Parent = PresetClr

				local function UpdateColorPicker(nope)
					PresetClr.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
					Color.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
					pcall(callback, PresetClr.BackgroundColor3)
				end

				ColorH = 1 - (math.clamp(HueSelection.AbsolutePosition.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
				ColorS = (math.clamp(ColorSelection.AbsolutePosition.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
				ColorV = 1 - (math.clamp(ColorSelection.AbsolutePosition.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)

				PresetClr.BackgroundColor3 = preset
				Color.BackgroundColor3 = preset
				pcall(callback, PresetClr.BackgroundColor3)

				Color.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if ColorInput then
							ColorInput:Disconnect()
						end

						ColorInput = RunService.RenderStepped:Connect(function()
							local ColorX = (math.clamp(Mouse.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
							local ColorY = (math.clamp(Mouse.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)
							ColorSelection.Position = UDim2.new(ColorX, 0, ColorY, 0)
							ColorS = ColorX
							ColorV = 1 - ColorY

							UpdateColorPicker(true)
						end)
					end
				end)

				Color.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if ColorInput then
							ColorInput:Disconnect()
						end
					end
				end)

				Hue.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if HueInput then
							HueInput:Disconnect()
						end

						HueInput = RunService.RenderStepped:Connect(function()
							local HueY = (math.clamp(Mouse.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
							HueSelection.Position = UDim2.new(0.48, 0, HueY, 0)
							ColorH = 1 - HueY

							UpdateColorPicker(true)
						end)
					end
				end)

				Hue.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if HueInput then
							HueInput:Disconnect()
						end
					end
				end)

				ChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)
			end

			function ChannelContent:Textbox(text, placetext, disapper, callback)
				local Textbox = Instance.new("Frame")
				local TextboxTitle = Instance.new("TextLabel")
				local TextboxFrameOutline = Instance.new("Frame")
				local TextboxFrameOutlineCorner = Instance.new("UICorner")
				local TextboxFrame = Instance.new("Frame")
				local TextboxFrameCorner = Instance.new("UICorner")
				local TextBox = Instance.new("TextBox")

				Textbox.Name = "Textbox"
				Textbox.Parent = ChannelHolder
				Textbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Textbox.BackgroundTransparency = 1.000
				Textbox.Position = UDim2.new(0.0796874985, 0, 0.445175439, 0)
				Textbox.Size = UDim2.new(0, 403, 0, 73)

				TextboxTitle.Name = "TextboxTitle"
				TextboxTitle.Parent = Textbox
				TextboxTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextboxTitle.BackgroundTransparency = 1.000
				TextboxTitle.Position = UDim2.new(0, 5, 0, 0)
				TextboxTitle.Size = UDim2.new(0, 200, 0, 29)
				TextboxTitle.Font = Enum.Font.Gotham
				TextboxTitle.Text = text
				TextboxTitle.TextColor3 = PresetColor
				TextboxTitle.TextSize = 14.000
				TextboxTitle.TextXAlignment = Enum.TextXAlignment.Left

				TextboxFrameOutline.Name = "TextboxFrameOutline"
				TextboxFrameOutline.Parent = TextboxTitle
				TextboxFrameOutline.AnchorPoint = Vector2.new(0.5, 0.5)
				TextboxFrameOutline.BackgroundColor3 = PresetColor
				TextboxFrameOutline.Position = UDim2.new(0.988442957, 0, 1.6197437, 0)
				TextboxFrameOutline.Size = UDim2.new(0, 396, 0, 36)

				TextboxFrameOutlineCorner.CornerRadius = UDim.new(0, 3)
				TextboxFrameOutlineCorner.Name = "TextboxFrameOutlineCorner"
				TextboxFrameOutlineCorner.Parent = TextboxFrameOutline

				TextboxFrame.Name = "TextboxFrame"
				TextboxFrame.Parent = TextboxTitle
				TextboxFrame.BackgroundColor3 = Color3.fromRGB(23, 23, 23)
				TextboxFrame.ClipsDescendants = true
				TextboxFrame.Position = UDim2.new(0.00899999978, 0, 1.06638527, 0)
				TextboxFrame.Selectable = true
				TextboxFrame.Size = UDim2.new(0, 392, 0, 32)

				TextboxFrameCorner.CornerRadius = UDim.new(0, 3)
				TextboxFrameCorner.Name = "TextboxFrameCorner"
				TextboxFrameCorner.Parent = TextboxFrame

				TextBox.Parent = TextboxFrame
				TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextBox.BackgroundTransparency = 1.000
				TextBox.Position = UDim2.new(0.0178571437, 0, 0, 0)
				TextBox.Size = UDim2.new(0, 377, 0, 32)
				TextBox.Font = Enum.Font.Gotham
				TextBox.PlaceholderColor3 = PresetColor
				TextBox.PlaceholderText = placetext
				TextBox.Text = ""
				TextBox.TextColor3 = PresetColor
				TextBox.TextSize = 14.000
				TextBox.TextXAlignment = Enum.TextXAlignment.Left

				TextBox.Focused:Connect(function()
					TweenService:Create(
						TextboxFrameOutline,
						TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{BackgroundColor3 = Color3.fromRGB(23, 23, 23)}
					):Play()
				end)

				TextBox.FocusLost:Connect(function(ep)
					TweenService:Create(
						TextboxFrameOutline,
						TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{BackgroundColor3 = PresetColor}
					):Play()
					if ep then
						if #TextBox.Text > 0 then
							pcall(callback, TextBox.Text)
							if disapper then
								TextBox.Text = ""
							end
						end
					end
				end)

				ChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)
			end

			function ChannelContent:AddImage(image)
				local gamepng = "https://www.roblox.com/asset-thumbnail/image?assetId="..game.PlaceId.."&width=768&height=432&format=png"
				local img = gamepng or image
				local ImageFrame = Instance.new("Frame")
				local gameImageOutline = Instance.new("Frame")
				local gameImage = Instance.new("ImageLabel")

				ImageFrame.Name = "ImageFrame"
				ImageFrame.Parent = ChannelHolder
				ImageFrame.Position = UDim2.new(0.261979163, 0, 0.190789461, 0)
				ImageFrame.Size = UDim2.new(0, 401, 0, 105)
				ImageFrame.BackgroundTransparency = 1.000

				gameImage.Name = "gameImageOutline"
				gameImage.Parent = ImageFrame
				gameImage.Size = UDim2.new(0, 401 * 2/4, 0, 125 * 3/4)
				gameImage.Position = UDim2.new(0.125, 0, 0, 0)
				gameImage.BackgroundTransparency = 1.000
				gameImage.Image = img

				ChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)
			end

			function ChannelContent:AddImage(image)
				local imagePlayer = "www.roblox.com/avatar-thumbnail/image?userId="..game.Players.LocalPlayer.UserId.."&width=420&height=420&format=png"
				local gamepng = "https://www.roblox.com/asset-thumbnail/image?assetId="..game.PlaceId.."&width=768&height=432&format=png"
				local img = gamepng or image
				local ImageFrame = Instance.new("Frame")
				local gameImageOutline = Instance.new("Frame")
				local gameImage = Instance.new("ImageLabel")

				ImageFrame.Name = "ImageFrame"
				ImageFrame.Parent = ChannelHolder
				ImageFrame.Position = UDim2.new(0.261979163, 0, 0.190789461, 0)
				ImageFrame.Size = UDim2.new(0, 401, 0, 105)
				ImageFrame.BackgroundTransparency = 1.000

				gameImage.Name = "gameImageOutline"
				gameImage.Parent = ImageFrame
				gameImage.Size = UDim2.new(0, 401 * 2/4, 0, 125 * 3/4)
				gameImage.Position = UDim2.new(0.125, 0, 0, 0)
				gameImage.BackgroundTransparency = 1.000
				gameImage.Image = img

				ChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)
			end

			function ChannelContent:Label(text)
				local Label = Instance.new("TextButton")
				local LabelTitle = Instance.new("TextLabel")
				local labelfunc = {}
				Label.Name = "Label"

				Label.Parent = ChannelHolder
				Label.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
				Label.BorderSizePixel = 0
				Label.Position = UDim2.new(0.261979163, 0, 0.190789461, 0)
				Label.Size = UDim2.new(0, 401, 0, 30)
				Label.AutoButtonColor = false
				Label.Font = Enum.Font.Gotham
				Label.Text = ""
				Label.TextColor3 = PresetColor
				Label.TextSize = 14.000

				LabelTitle.Name = "LabelTitle"
				LabelTitle.Parent = Label
				LabelTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				LabelTitle.BackgroundTransparency = 1.000
				LabelTitle.Position = UDim2.new(0, 5, 0, 0)
				LabelTitle.Size = UDim2.new(0, 200, 0, 30)
				LabelTitle.Font = Enum.Font.Gotham
				LabelTitle.Text = text
				LabelTitle.TextColor3 = PresetColor
				LabelTitle.TextSize = 14.000
				LabelTitle.TextXAlignment = Enum.TextXAlignment.Left

				ChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)

				function labelfunc:Refresh(tochange)
					Label.Text = tochange
				end
				return labelfunc
			end

			function ChannelContent:Bind(text, presetbind, callback)
				local Key = presetbind.Name
				local Keybind = Instance.new("TextButton")
				local KeybindTitle = Instance.new("TextLabel")
				local KeybindText = Instance.new("TextLabel")

				Keybind.Name = "Keybind"
				Keybind.Parent = ChannelHolder
				Keybind.BackgroundColor3 = Color3.fromRGB(23, 23, 23)
				Keybind.BorderSizePixel = 0
				Keybind.Position = UDim2.new(0.261979163, 0, 0.190789461, 0)
				Keybind.Size = UDim2.new(0, 401, 0, 30)
				Keybind.AutoButtonColor = false
				Keybind.Font = Enum.Font.Gotham
				Keybind.Text = ""
				Keybind.TextColor3 = Color3.fromRGB(255, 255, 255)
				Keybind.TextSize = 14.000

				KeybindTitle.Name = "KeybindTitle"
				KeybindTitle.Parent = Keybind
				KeybindTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				KeybindTitle.BackgroundTransparency = 1.000
				KeybindTitle.Position = UDim2.new(0, 5, 0, 0)
				KeybindTitle.Size = UDim2.new(0, 200, 0, 30)
				KeybindTitle.Font = Enum.Font.Gotham
				KeybindTitle.Text = text
				KeybindTitle.TextColor3 = PresetColor
				KeybindTitle.TextSize = 14.000
				KeybindTitle.TextXAlignment = Enum.TextXAlignment.Left

				KeybindText.Name = "KeybindText"
				KeybindText.Parent = Keybind
				KeybindText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				KeybindText.BackgroundTransparency = 1.000
				KeybindText.Position = UDim2.new(0, 316, 0, 0)
				KeybindText.Size = UDim2.new(0, 85, 0, 30)
				KeybindText.Font = Enum.Font.Gotham
				KeybindText.Text = presetbind.Name
				KeybindText.TextColor3 = PresetColor
				KeybindText.TextSize = 14.000
				KeybindText.TextXAlignment = Enum.TextXAlignment.Right

				Keybind.MouseButton1Click:Connect(function()
					KeybindText.Text = "..."
					local inputwait = game:GetService("UserInputService").InputBegan:wait()
					if inputwait.KeyCode.Name ~= "Unknown" then
						KeybindText.Text = inputwait.KeyCode.Name
						Key = inputwait.KeyCode.Name
					end
				end)

				game:GetService("UserInputService").InputBegan:connect(function(current, pressed)
					if not pressed then
						if current.KeyCode.Name == Key then
							pcall(callback)
						end
					end
				end)
				ChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)
			end
			return ChannelContent
		end
		return ChannelHold
	end
	return ServerHold
end

_G.Remove_Effect = true

spawn(function()
    game:GetService('RunService').Stepped:Connect(function()
        if _G.Remove_Effect then
            for i, v in pairs(game:GetService("ReplicatedStorage").Effect.Container:GetChildren()) do
                if v.Name == "Death" then
                    v:Destroy() 
                end
            end
        end
    end)
    end)


---------------------------------
	

----------------
if game.PlaceId == 2753915549 then
    World1 = true
elseif game.PlaceId == 4442272183 then
    World2 = true
elseif game.PlaceId == 7449423635 then
    World3 = true
end

function CheckQuest() 
    MyLevel = game:GetService("Players").LocalPlayer.Data.Level.Value
    if World1 then
        if MyLevel == 1 or MyLevel <= 9 then
            Mon = "Bandit [Lv. 5]"
            LevelQuest = 1
            NameQuest = "BanditQuest1"
            NameMon = "Bandit"
            CFrameQuest = CFrame.new(1059.37195, 15.4495068, 1550.4231, 0.939700544, -0, -0.341998369, 0, 1, -0, 0.341998369, 0, 0.939700544)
            CFrameMon = CFrame.new(1045.962646484375, 27.00250816345215, 1560.8203125)
        elseif MyLevel == 10 or MyLevel <= 14 then
            Mon = "Monkey [Lv. 14]"
            LevelQuest = 1
            NameQuest = "JungleQuest"
            NameMon = "Monkey"
            CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, -0, -1, 0, 0)
            CFrameMon = CFrame.new(-1448.51806640625, 67.85301208496094, 11.46579647064209)
        elseif MyLevel == 15 or MyLevel <= 29 then
            Mon = "Gorilla [Lv. 20]"
            LevelQuest = 2
            NameQuest = "JungleQuest"
            NameMon = "Gorilla"
            CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, -0, -1, 0, 0)
            CFrameMon = CFrame.new(-1129.8836669921875, 40.46354675292969, -525.4237060546875)
        elseif MyLevel == 30 or MyLevel <= 39 then
            Mon = "Pirate [Lv. 35]"
            LevelQuest = 1
            NameQuest = "BuggyQuest1"
            NameMon = "Pirate"
            CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627)
            CFrameMon = CFrame.new(-1103.513427734375, 13.752052307128906, 3896.091064453125)
        elseif MyLevel == 40 or MyLevel <= 59 then
            Mon = "Brute [Lv. 45]"
            LevelQuest = 2
            NameQuest = "BuggyQuest1"
            NameMon = "Brute"
            CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627)
            CFrameMon = CFrame.new(-1140.083740234375, 14.809885025024414, 4322.92138671875)
        elseif MyLevel == 60 or MyLevel <= 74 then
            Mon = "Desert Bandit [Lv. 60]"
            LevelQuest = 1
            NameQuest = "DesertQuest"
            NameMon = "Desert Bandit"
            CFrameQuest = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, -0, -0.573571265, 0, 1, -0, 0.573571265, 0, 0.819155693)
            CFrameMon = CFrame.new(924.7998046875, 6.44867467880249, 4481.5859375)
        elseif MyLevel == 75 or MyLevel <= 89 then
            Mon = "Desert Officer [Lv. 70]"
            LevelQuest = 2
            NameQuest = "DesertQuest"
            NameMon = "Desert Officer"
            CFrameQuest = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, -0, -0.573571265, 0, 1, -0, 0.573571265, 0, 0.819155693)
            CFrameMon = CFrame.new(1608.2822265625, 8.614224433898926, 4371.00732421875)
        elseif MyLevel == 90 or MyLevel <= 99 then
            Mon = "Snow Bandit [Lv. 90]"
            LevelQuest = 1
            NameQuest = "SnowQuest"
            NameMon = "Snow Bandit"
            CFrameQuest = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0, -0.342042685)
            CFrameMon = CFrame.new(1354.347900390625, 87.27277374267578, -1393.946533203125)
        elseif MyLevel == 100 or MyLevel <= 119 then
            Mon = "Snowman [Lv. 100]"
            LevelQuest = 2
            NameQuest = "SnowQuest"
            NameMon = "Snowman"
            CFrameQuest = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0, -0.342042685)
            CFrameMon = CFrame.new(1201.6412353515625, 144.57958984375, -1550.0670166015625)
        elseif MyLevel == 120 or MyLevel <= 149 then
            Mon = "Chief Petty Officer [Lv. 120]"
            LevelQuest = 1
            NameQuest = "MarineQuest2"
            NameMon = "Chief Petty Officer"
            CFrameQuest = CFrame.new(-5039.58643, 27.3500385, 4324.68018, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            CFrameMon = CFrame.new(-4881.23095703125, 22.65204429626465, 4273.75244140625)
        elseif MyLevel == 150 or MyLevel <= 174 then
            Mon = "Sky Bandit [Lv. 150]"
            LevelQuest = 1
            NameQuest = "SkyQuest"
            NameMon = "Sky Bandit"
            CFrameQuest = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
            CFrameMon = CFrame.new(-4953.20703125, 295.74420166015625, -2899.22900390625)
        elseif MyLevel == 175 or MyLevel <= 189 then
            Mon = "Dark Master [Lv. 175]"
            LevelQuest = 2
            NameQuest = "SkyQuest"
            NameMon = "Dark Master"
            CFrameQuest = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
            CFrameMon = CFrame.new(-5259.8447265625, 391.3976745605469, -2229.035400390625)
        elseif MyLevel == 190 or MyLevel <= 209 then
            Mon = "Prisoner [Lv. 190]"
            LevelQuest = 1
            NameQuest = "PrisonerQuest"
            NameMon = "Prisoner"
            CFrameQuest = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918e-09, -0.995993316, 1.60817859e-09, 1, -5.16744869e-09, 0.995993316, -2.06384709e-09, -0.0894274712)
            CFrameMon = CFrame.new(5098.9736328125, -0.3204058110713959, 474.2373352050781)
        elseif MyLevel == 210 or MyLevel <= 249 then
            Mon = "Dangerous Prisoner [Lv. 210]"
            LevelQuest = 2
            NameQuest = "PrisonerQuest"
            NameMon = "Dangerous Prisoner"
            CFrameQuest = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918e-09, -0.995993316, 1.60817859e-09, 1, -5.16744869e-09, 0.995993316, -2.06384709e-09, -0.0894274712)
            CFrameMon = CFrame.new(5654.5634765625, 15.633401870727539, 866.2991943359375)
        elseif MyLevel == 250 or MyLevel <= 274 then
            Mon = "Toga Warrior [Lv. 250]"
            LevelQuest = 1
            NameQuest = "ColosseumQuest"
            NameMon = "Toga Warrior"
            CFrameQuest = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, 0, -0.857167721, 0, 1, 0, 0.857167721, 0, -0.515037298)
            CFrameMon = CFrame.new(-1820.21484375, 51.68385696411133, -2740.6650390625)
        elseif MyLevel == 275 or MyLevel <= 299 then
            Mon = "Gladiator [Lv. 275]"
            LevelQuest = 2
            NameQuest = "ColosseumQuest"
            NameMon = "Gladiator"
            CFrameQuest = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, 0, -0.857167721, 0, 1, 0, 0.857167721, 0, -0.515037298)
            CFrameMon = CFrame.new(-1292.838134765625, 56.380882263183594, -3339.031494140625)
        elseif MyLevel == 300 or MyLevel <= 324 then
            Mon = "Military Soldier [Lv. 300]"
            LevelQuest = 1
            NameQuest = "MagmaQuest"
            NameMon = "Military Soldier"
            CFrameQuest = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469)
            CFrameMon = CFrame.new(-5411.16455078125, 11.081554412841797, 8454.29296875)
        elseif MyLevel == 325 or MyLevel <= 374 then
            Mon = "Military Spy [Lv. 325]"
            LevelQuest = 2
            NameQuest = "MagmaQuest"
            NameMon = "Military Spy"
            CFrameQuest = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469)
            CFrameMon = CFrame.new(-5802.8681640625, 86.26241302490234, 8828.859375)
        elseif MyLevel == 375 or MyLevel <= 399 then
            Mon = "Fishman Warrior [Lv. 375]"
            LevelQuest = 1
            NameQuest = "FishmanQuest"
            NameMon = "Fishman Warrior"
            CFrameQuest = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
            CFrameMon = CFrame.new(60878.30078125, 18.482830047607422, 1543.7574462890625)
            if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
            end
        elseif MyLevel == 400 or MyLevel <= 449 then
            Mon = "Fishman Commando [Lv. 400]"
            LevelQuest = 2
            NameQuest = "FishmanQuest"
            NameMon = "Fishman Commando"
            CFrameQuest = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
            CFrameMon = CFrame.new(61922.6328125, 18.482830047607422, 1493.934326171875)
            if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
            end
        elseif MyLevel == 450 or MyLevel <= 474 then
            Mon = "God's Guard [Lv. 450]"
            LevelQuest = 1
            NameQuest = "SkyExp1Quest"
            NameMon = "God's Guard"
            CFrameQuest = CFrame.new(-4721.88867, 843.874695, -1949.96643, 0.996191859, -0, -0.0871884301, 0, 1, -0, 0.0871884301, 0, 0.996191859)
            CFrameMon = CFrame.new(-4710.04296875, 845.2769775390625, -1927.3079833984375)
            if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-4607.82275, 872.54248, -1667.55688))
            end
        elseif MyLevel == 475 or MyLevel <= 524 then
            Mon = "Shanda [Lv. 475]"
            LevelQuest = 2
            NameQuest = "SkyExp1Quest"
            NameMon = "Shanda"
            CFrameQuest = CFrame.new(-7859.09814, 5544.19043, -381.476196, -0.422592998, 0, 0.906319618, 0, 1, 0, -0.906319618, 0, -0.422592998)
            CFrameMon = CFrame.new(-7678.48974609375, 5566.40380859375, -497.2156066894531)
            if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
            end
        elseif MyLevel == 525 or MyLevel <= 549 then
            Mon = "Royal Squad [Lv. 525]"
            LevelQuest = 1
            NameQuest = "SkyExp2Quest"
            NameMon = "Royal Squad"
            CFrameQuest = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            CFrameMon = CFrame.new(-7624.25244140625, 5658.13330078125, -1467.354248046875)
        elseif MyLevel == 550 or MyLevel <= 624 then
            Mon = "Royal Soldier [Lv. 550]"
            LevelQuest = 2
            NameQuest = "SkyExp2Quest"
            NameMon = "Royal Soldier"
            CFrameQuest = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            CFrameMon = CFrame.new(-7836.75341796875, 5645.6640625, -1790.6236572265625)
        elseif MyLevel == 625 or MyLevel <= 649 then
            Mon = "Galley Pirate [Lv. 625]"
            LevelQuest = 1
            NameQuest = "FountainQuest"
            NameMon = "Galley Pirate"
            CFrameQuest = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381)
            CFrameMon = CFrame.new(5551.02197265625, 78.90135192871094, 3930.412841796875)
        elseif MyLevel >= 650 then
            Mon = "Galley Captain [Lv. 650]"
            LevelQuest = 2
            NameQuest = "FountainQuest"
            NameMon = "Galley Captain"
            CFrameQuest = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381)
            CFrameMon = CFrame.new(5441.95166015625, 42.50205993652344, 4950.09375)
        end
    elseif World2 then
        if MyLevel == 700 or MyLevel <= 724 then
            Mon = "Raider [Lv. 700]"
            LevelQuest = 1
            NameQuest = "Area1Quest"
            NameMon = "Raider"
            CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985)
            CFrameMon = CFrame.new(-728.3267211914062, 52.779319763183594, 2345.7705078125)
        elseif MyLevel == 725 or MyLevel <= 774 then
            Mon = "Mercenary [Lv. 725]"
            LevelQuest = 2
            NameQuest = "Area1Quest"
            NameMon = "Mercenary"
            CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985)
            CFrameMon = CFrame.new(-1004.3244018554688, 80.15886688232422, 1424.619384765625)
        elseif MyLevel == 775 or MyLevel <= 799 then
            Mon = "Swan Pirate [Lv. 775]"
            LevelQuest = 1
            NameQuest = "Area2Quest"
            NameMon = "Swan Pirate"
            CFrameQuest = CFrame.new(638.43811, 71.769989, 918.282898, 0.139203906, 0, 0.99026376, 0, 1, 0, -0.99026376, 0, 0.139203906)
            CFrameMon = CFrame.new(1068.664306640625, 137.61428833007812, 1322.1060791015625)
        elseif MyLevel == 800 or MyLevel <= 874 then
            Mon = "Factory Staff [Lv. 800]"
            NameQuest = "Area2Quest"
            LevelQuest = 2
            NameMon = "Factory Staff"
            CFrameQuest = CFrame.new(632.698608, 73.1055908, 918.666321, -0.0319722369, 8.96074881e-10, -0.999488771, 1.36326533e-10, 1, 8.92172336e-10, 0.999488771, -1.07732087e-10, -0.0319722369)
            CFrameMon = CFrame.new(73.07867431640625, 81.86344146728516, -27.470672607421875)
        elseif MyLevel == 875 or MyLevel <= 899 then
            Mon = "Marine Lieutenant [Lv. 875]"
            LevelQuest = 1
            NameQuest = "MarineQuest3"
            NameMon = "Marine Lieutenant"
            CFrameQuest = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
            CFrameMon = CFrame.new(-2821.372314453125, 75.89727783203125, -3070.089111328125)
        elseif MyLevel == 900 or MyLevel <= 949 then
            Mon = "Marine Captain [Lv. 900]"
            LevelQuest = 2
            NameQuest = "MarineQuest3"
            NameMon = "Marine Captain"
            CFrameQuest = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
            CFrameMon = CFrame.new(-1861.2310791015625, 80.17658233642578, -3254.697509765625)
        elseif MyLevel == 950 or MyLevel <= 974 then
            Mon = "Zombie [Lv. 950]"
            LevelQuest = 1
            NameQuest = "ZombieQuest"
            NameMon = "Zombie"
            CFrameQuest = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146)
            CFrameMon = CFrame.new(-5657.77685546875, 78.96973419189453, -928.68701171875)
        elseif MyLevel == 975 or MyLevel <= 999 then
            Mon = "Vampire [Lv. 975]"
            LevelQuest = 2
            NameQuest = "ZombieQuest"
            NameMon = "Vampire"
            CFrameQuest = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146)
            CFrameMon = CFrame.new(-6037.66796875, 32.18463897705078, -1340.6597900390625)
        elseif MyLevel == 1000 or MyLevel <= 1049 then
            Mon = "Snow Trooper [Lv. 1000]"
            LevelQuest = 1
            NameQuest = "SnowMountainQuest"
            NameMon = "Snow Trooper"
            CFrameQuest = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, 0.92718488, 0, 1, 0, -0.92718488, 0, -0.374604106)
            CFrameMon = CFrame.new(549.1473388671875, 427.3870544433594, -5563.69873046875)
        elseif MyLevel == 1050 or MyLevel <= 1099 then
            Mon = "Winter Warrior [Lv. 1050]"
            LevelQuest = 2
            NameQuest = "SnowMountainQuest"
            NameMon = "Winter Warrior"
            CFrameQuest = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, 0.92718488, 0, 1, 0, -0.92718488, 0, -0.374604106)
            CFrameMon = CFrame.new(1142.7451171875, 475.6398010253906, -5199.41650390625)
        elseif MyLevel == 1100 or MyLevel <= 1124 then
            Mon = "Lab Subordinate [Lv. 1100]"
            LevelQuest = 1
            NameQuest = "IceSideQuest"
            NameMon = "Lab Subordinate"
            CFrameQuest = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, -0, -0.891015649, 0, 1, -0, 0.891015649, 0, 0.453972578)
            CFrameMon = CFrame.new(-5707.4716796875, 15.951709747314453, -4513.39208984375)
        elseif MyLevel == 1125 or MyLevel <= 1174 then
            Mon = "Horned Warrior [Lv. 1125]"
            LevelQuest = 2
            NameQuest = "IceSideQuest"
            NameMon = "Horned Warrior"
            CFrameQuest = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, -0, -0.891015649, 0, 1, -0, 0.891015649, 0, 0.453972578)
            CFrameMon = CFrame.new(-6341.36669921875, 15.951770782470703, -5723.162109375)
        elseif MyLevel == 1175 or MyLevel <= 1199 then
            Mon = "Magma Ninja [Lv. 1175]"
            LevelQuest = 1
            NameQuest = "FireSideQuest"
            NameMon = "Magma Ninja"
            CFrameQuest = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
            CFrameMon = CFrame.new(-5449.6728515625, 76.65874481201172, -5808.20068359375)
        elseif MyLevel == 1200 or MyLevel <= 1249 then
            Mon = "Lava Pirate [Lv. 1200]"
            LevelQuest = 2
            NameQuest = "FireSideQuest"
            NameMon = "Lava Pirate"
            CFrameQuest = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
            CFrameMon = CFrame.new(-5213.33154296875, 49.73788070678711, -4701.451171875)
        elseif MyLevel == 1250 or MyLevel <= 1274 then
            Mon = "Ship Deckhand [Lv. 1250]"
            LevelQuest = 1
            NameQuest = "ShipQuest1"
            NameMon = "Ship Deckhand"
            CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016)         
            CFrameMon = CFrame.new(1212.0111083984375, 150.79205322265625, 33059.24609375)    
            if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif MyLevel == 1275 or MyLevel <= 1299 then
            Mon = "Ship Engineer [Lv. 1275]"
            LevelQuest = 2
            NameQuest = "ShipQuest1"
            NameMon = "Ship Engineer"
            CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016)   
            CFrameMon = CFrame.new(919.4786376953125, 43.54401397705078, 32779.96875)   
            if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end             
        elseif MyLevel == 1300 or MyLevel <= 1324 then
            Mon = "Ship Steward [Lv. 1300]"
            LevelQuest = 1
            NameQuest = "ShipQuest2"
            NameMon = "Ship Steward"
            CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125)         
            CFrameMon = CFrame.new(919.4385375976562, 129.55599975585938, 33436.03515625)      
            if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif MyLevel == 1325 or MyLevel <= 1349 then
            Mon = "Ship Officer [Lv. 1325]"
            LevelQuest = 2
            NameQuest = "ShipQuest2"
            NameMon = "Ship Officer"
            CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125)
            CFrameMon = CFrame.new(1036.0179443359375, 181.4390411376953, 33315.7265625)
            if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif MyLevel == 1350 or MyLevel <= 1374 then
            Mon = "Arctic Warrior [Lv. 1350]"
            LevelQuest = 1
            NameQuest = "FrostQuest"
            NameMon = "Arctic Warrior"
            CFrameQuest = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909)
            CFrameMon = CFrame.new(5966.24609375, 62.97002029418945, -6179.3828125)
            if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-6508.5581054688, 5000.034996032715, -132.83953857422))
            end
        elseif MyLevel == 1375 or MyLevel <= 1424 then
            Mon = "Snow Lurker [Lv. 1375]"
            LevelQuest = 2
            NameQuest = "FrostQuest"
            NameMon = "Snow Lurker"
            CFrameQuest = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909)
            CFrameMon = CFrame.new(5407.07373046875, 69.19437408447266, -6880.88037109375)
        elseif MyLevel == 1425 or MyLevel <= 1449 then
            Mon = "Sea Soldier [Lv. 1425]"
            LevelQuest = 1
            NameQuest = "ForgottenQuest"
            NameMon = "Sea Soldier"
            CFrameQuest = CFrame.new(-3054.44458, 235.544281, -10142.8193, 0.990270376, -0, -0.13915664, 0, 1, -0, 0.13915664, 0, 0.990270376)
            CFrameMon = CFrame.new(-3028.2236328125, 64.67451477050781, -9775.4267578125)
        elseif MyLevel >= 1450 then
            Mon = "Water Fighter [Lv. 1450]"
            LevelQuest = 2
            NameQuest = "ForgottenQuest"
            NameMon = "Water Fighter"
            CFrameQuest = CFrame.new(-3054.44458, 235.544281, -10142.8193, 0.990270376, -0, -0.13915664, 0, 1, -0, 0.13915664, 0, 0.990270376)
            CFrameMon = CFrame.new(-3352.9013671875, 285.01556396484375, -10534.841796875)
        end
    elseif World3 then
        if MyLevel == 1500 or MyLevel <= 1524 then
            Mon = "Pirate Millionaire [Lv. 1500]"
            LevelQuest = 1
            NameQuest = "PiratePortQuest"
            NameMon = "Pirate Millionaire"
            CFrameQuest = CFrame.new(-290.074677, 42.9034653, 5581.58984, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627)
            CFrameMon = CFrame.new(-245.9963836669922, 47.30615234375, 5584.1005859375)
        elseif MyLevel == 1525 or MyLevel <= 1574 then
            Mon = "Pistol Billionaire [Lv. 1525]"
            LevelQuest = 2
            NameQuest = "PiratePortQuest"
            NameMon = "Pistol Billionaire"
            CFrameQuest = CFrame.new(-290.074677, 42.9034653, 5581.58984, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627)
            CFrameMon = CFrame.new(-187.3301544189453, 86.23987579345703, 6013.513671875)
        elseif MyLevel == 1575 or MyLevel <= 1599 then
            Mon = "Dragon Crew Warrior [Lv. 1575]"
            LevelQuest = 1
            NameQuest = "AmazonQuest"
            NameMon = "Dragon Crew Warrior"
            CFrameQuest = CFrame.new(5832.83594, 51.6806107, -1101.51563, 0.898790359, -0, -0.438378751, 0, 1, -0, 0.438378751, 0, 0.898790359)
            CFrameMon = CFrame.new(6141.140625, 51.35136413574219, -1340.738525390625)
        elseif MyLevel == 1600 or MyLevel <= 1624 then 
            Mon = "Dragon Crew Archer [Lv. 1600]"
            NameQuest = "AmazonQuest"
            LevelQuest = 2
            NameMon = "Dragon Crew Archer"
            CFrameQuest = CFrame.new(5833.1147460938, 51.60498046875, -1103.0693359375)
            CFrameMon = CFrame.new(6616.41748046875, 441.7670593261719, 446.0469970703125)
        elseif MyLevel == 1625 or MyLevel <= 1649 then
            Mon = "Female Islander [Lv. 1625]"
            NameQuest = "AmazonQuest2"
            LevelQuest = 1
            NameMon = "Female Islander"
            CFrameQuest = CFrame.new(5446.8793945313, 601.62945556641, 749.45672607422)
            CFrameMon = CFrame.new(4685.25830078125, 735.8078002929688, 815.3425903320312)
        elseif MyLevel == 1650 or MyLevel <= 1699 then 
            Mon = "Giant Islander [Lv. 1650]"
            NameQuest = "AmazonQuest2"
            LevelQuest = 2
            NameMon = "Giant Islander"
            CFrameQuest = CFrame.new(5446.8793945313, 601.62945556641, 749.45672607422)
            CFrameMon = CFrame.new(4729.09423828125, 590.436767578125, -36.97627639770508)
        elseif MyLevel == 1700 or MyLevel <= 1724 then
            Mon = "Marine Commodore [Lv. 1700]"
            LevelQuest = 1
            NameQuest = "MarineTreeIsland"
            NameMon = "Marine Commodore"
            CFrameQuest = CFrame.new(2180.54126, 27.8156815, -6741.5498, -0.965929747, 0, 0.258804798, 0, 1, 0, -0.258804798, 0, -0.965929747)
            CFrameMon = CFrame.new(2286.0078125, 73.13391876220703, -7159.80908203125)
        elseif MyLevel == 1725 or MyLevel <= 1774 then
            Mon = "Marine Rear Admiral [Lv. 1725]"
            NameMon = "Marine Rear Admiral"
            NameQuest = "MarineTreeIsland"
            LevelQuest = 2
            CFrameQuest = CFrame.new(2179.98828125, 28.731239318848, -6740.0551757813)
            CFrameMon = CFrame.new(3656.773681640625, 160.52406311035156, -7001.5986328125)
        elseif MyLevel == 1775 or MyLevel <= 1799 then
            Mon = "Fishman Raider [Lv. 1775]"
            LevelQuest = 1
            NameQuest = "DeepForestIsland3"
            NameMon = "Fishman Raider"
            CFrameQuest = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)   
            CFrameMon = CFrame.new(-10407.5263671875, 331.76263427734375, -8368.5166015625)
        elseif MyLevel == 1800 or MyLevel <= 1824 then
            Mon = "Fishman Captain [Lv. 1800]"
            LevelQuest = 2
            NameQuest = "DeepForestIsland3"
            NameMon = "Fishman Captain"
            CFrameQuest = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)   
            CFrameMon = CFrame.new(-10994.701171875, 352.38140869140625, -9002.1103515625) 
        elseif MyLevel == 1825 or MyLevel <= 1849 then
            Mon = "Forest Pirate [Lv. 1825]"
            LevelQuest = 1
            NameQuest = "DeepForestIsland"
            NameMon = "Forest Pirate"
            CFrameQuest = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247)
            CFrameMon = CFrame.new(-13274.478515625, 332.3781433105469, -7769.58056640625)
        elseif MyLevel == 1850 or MyLevel <= 1899 then
            Mon = "Mythological Pirate [Lv. 1850]"
            LevelQuest = 2
            NameQuest = "DeepForestIsland"
            NameMon = "Mythological Pirate"
            CFrameQuest = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247)   
            CFrameMon = CFrame.new(-13680.607421875, 501.08154296875, -6991.189453125)
        elseif MyLevel == 1900 or MyLevel <= 1924 then
            Mon = "Jungle Pirate [Lv. 1900]"
            LevelQuest = 1
            NameQuest = "DeepForestIsland2"
            NameMon = "Jungle Pirate"
            CFrameQuest = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002)
            CFrameMon = CFrame.new(-12256.16015625, 331.73828125, -10485.8369140625)
        elseif MyLevel == 1925 or MyLevel <= 1974 then
            Mon = "Musketeer Pirate [Lv. 1925]"
            LevelQuest = 2
            NameQuest = "DeepForestIsland2"
            NameMon = "Musketeer Pirate"
            CFrameQuest = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002)
            CFrameMon = CFrame.new(-13457.904296875, 391.545654296875, -9859.177734375)
        elseif MyLevel == 1975 or MyLevel <= 1999 then
            Mon = "Reborn Skeleton [Lv. 1975]"
            LevelQuest = 1
            NameQuest = "HauntedQuest1"
            NameMon = "Reborn Skeleton"
            CFrameQuest = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, -0, -1, 0, 0)
            CFrameMon = CFrame.new(-8763.7236328125, 165.72299194335938, 6159.86181640625)
        elseif MyLevel == 2000 or MyLevel <= 2024 then
            Mon = "Living Zombie [Lv. 2000]"
            LevelQuest = 2
            NameQuest = "HauntedQuest1"
            NameMon = "Living Zombie"
            CFrameQuest = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, -0, -1, 0, 0)
            CFrameMon = CFrame.new(-10144.1318359375, 138.62667846679688, 5838.0888671875)
        elseif MyLevel == 2025 or MyLevel <= 2049 then
            Mon = "Demonic Soul [Lv. 2025]"
            LevelQuest = 1
            NameQuest = "HauntedQuest2"
            NameMon = "Demonic Soul"
            CFrameQuest = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0) 
            CFrameMon = CFrame.new(-9505.8720703125, 172.10482788085938, 6158.9931640625)
        elseif MyLevel == 2050 or MyLevel <= 2074 then
            Mon = "Posessed Mummy [Lv. 2050]"
            LevelQuest = 2
            NameQuest = "HauntedQuest2"
            NameMon = "Posessed Mummy"
            CFrameQuest = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            CFrameMon = CFrame.new(-9582.0224609375, 6.251527309417725, 6205.478515625)
        elseif MyLevel == 2075 or MyLevel <= 2099 then
            Mon = "Peanut Scout [Lv. 2075]"
            LevelQuest = 1
            NameQuest = "NutsIslandQuest"
            NameMon = "Peanut Scout"
            CFrameQuest = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            CFrameMon = CFrame.new(-2143.241943359375, 47.72198486328125, -10029.9951171875)
        elseif MyLevel == 2100 or MyLevel <= 2124 then
            Mon = "Peanut President [Lv. 2100]"
            LevelQuest = 2
            NameQuest = "NutsIslandQuest"
            NameMon = "Peanut President"
            CFrameQuest = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            CFrameMon = CFrame.new(-1859.35400390625, 38.10316848754883, -10422.4296875)
        elseif MyLevel == 2125 or MyLevel <= 2149 then
            Mon = "Ice Cream Chef [Lv. 2125]"
            LevelQuest = 1
            NameQuest = "IceCreamIslandQuest"
            NameMon = "Ice Cream Chef"
            CFrameQuest = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            CFrameMon = CFrame.new(-872.24658203125, 65.81957244873047, -10919.95703125)
        elseif MyLevel == 2150 or MyLevel <= 2199 then
            Mon = "Ice Cream Commander [Lv. 2150]"
            LevelQuest = 2
            NameQuest = "IceCreamIslandQuest"
            NameMon = "Ice Cream Commander"
            CFrameQuest = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            CFrameMon = CFrame.new(-558.06103515625, 112.04895782470703, -11290.7744140625)
        elseif MyLevel == 2200 or MyLevel <= 2224 then
            Mon = "Cookie Crafter [Lv. 2200]"
            LevelQuest = 1
            NameQuest = "CakeQuest1"
            NameMon = "Cookie Crafter"
            CFrameQuest = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931)
            CFrameMon = CFrame.new(-2374.13671875, 37.79826354980469, -12125.30859375)
        elseif MyLevel == 2225 or MyLevel <= 2249 then
            Mon = "Cake Guard [Lv. 2225]"
            LevelQuest = 2
            NameQuest = "CakeQuest1"
            NameMon = "Cake Guard"
            CFrameQuest = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931)
            CFrameMon = CFrame.new(-1598.3070068359375, 43.773197174072266, -12244.5810546875)
        elseif MyLevel == 2250 or MyLevel <= 2274 then
            Mon = "Baking Staff [Lv. 2250]"
            LevelQuest = 1
            NameQuest = "CakeQuest2"
            NameMon = "Baking Staff"
            CFrameQuest = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-08, 0.250778586, 4.74911062e-08, 1, 1.49904711e-08, -0.250778586, 2.64211941e-08, -0.96804446)
            CFrameMon = CFrame.new(-1887.8099365234375, 77.6185073852539, -12998.3505859375)
        elseif MyLevel == 2275 or MyLevel <= 2299 then
            Mon = "Head Baker [Lv. 2275]"
            LevelQuest = 2
            NameQuest = "CakeQuest2"
            NameMon = "Head Baker"
            CFrameQuest = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-08, 0.250778586, 4.74911062e-08, 1, 1.49904711e-08, -0.250778586, 2.64211941e-08, -0.96804446)
            CFrameMon = CFrame.new(-2216.188232421875, 82.884521484375, -12869.2939453125)
        elseif MyLevel == 2300 or MyLevel <= 2324 then
            Mon = "Cocoa Warrior [Lv. 2300]"
            LevelQuest = 1
            NameQuest = "ChocQuest1"
            NameMon = "Cocoa Warrior"
            CFrameQuest = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375)
            CFrameMon = CFrame.new(-21.55328369140625, 80.57499694824219, -12352.3876953125)
        elseif MyLevel == 2325 or MyLevel <= 2349 then
            Mon = "Chocolate Bar Battler [Lv. 2325]"
            LevelQuest = 2
            NameQuest = "ChocQuest1"
            NameMon = "Chocolate Bar Battler"
            CFrameQuest = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375)
            CFrameMon = CFrame.new(582.590576171875, 77.18809509277344, -12463.162109375)
        elseif MyLevel == 2350 or MyLevel <= 2374 then
            Mon = "Sweet Thief [Lv. 2350]"
            LevelQuest = 1
            NameQuest = "ChocQuest2"
            NameMon = "Sweet Thief"
            CFrameQuest = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875)
            CFrameMon = CFrame.new(165.1884765625, 76.05885314941406, -12600.8369140625)
        elseif MyLevel == 2375 or MyLevel <= 2399 then
            Mon = "Candy Rebel [Lv. 2375]"
            LevelQuest = 2
            NameQuest = "ChocQuest2"
            NameMon = "Candy Rebel"
            CFrameQuest = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875)
            CFrameMon = CFrame.new(134.86563110351562, 77.2476806640625, -12876.5478515625)
        elseif MyLevel == 2400 or MyLevel <= 2449 then
            Mon = "Candy Pirate [Lv. 2400]"
            LevelQuest = 1
            NameQuest = "CandyQuest1"
            NameMon = "Candy Pirate"
            CFrameQuest = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375)
            CFrameMon = CFrame.new(-1310.5003662109375, 26.016523361206055, -14562.404296875)
        elseif MyLevel <= 2450 then
            Mon = "Snow Demon [Lv. 2425]"
            LevelQuest = 2
            NameQuest = "CandyQuest1"
            NameMon = "Snow Demon"
            CFrameQuest = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375)
            CFrameMon = CFrame.new(-880.2006225585938, 71.24776458740234, -14538.609375)
        end
    end
end

function checkselect() 

	local MyLevel = game.Players.LocalPlayer.Data.Level.Value

    if World1 then

		if MyLevel == 1 or MyLevel <= 9 or SelectMonster == "Bandit [Lv. 5]" then -- Bandit

			Mon = "Bandit [Lv. 5]"

			--NameQuest = "BanditQuest1"

			LevelQuest = 1

			NameMon = "Bandit"

			--CFrameQuest = CFrame.new(1061.66699, 16.5166187, 1544.52905, -0.942978859, -3.33851502e-09, 0.332852632, 7.04340497e-09, 1, 2.99841325e-08, -0.332852632, 3.06188177e-08, -0.942978859)

			CFrameMon = CFrame.new(1199.31287, 52.2717781, 1536.91516, -0.929782331, 6.60215846e-08, -0.368109822, 3.9077392e-08, 1, 8.06501603e-08, 0.368109822, 6.06023249e-08, -0.929782331)

			--Spawn = "Default"

        elseif MyLevel == 10 or MyLevel <= 14 or SelectMonster == "Monkey [Lv. 14]" then -- Monkey

			Mon = "Monkey [Lv. 14]"

			--NameQuest = "JungleQuest"

			LevelQuest = 1

			NameMon = "Monkey"

			--CFrameQuest = CFrame.new(-1604.12012, 36.8521118, 154.23732, 0.0648873374, -4.70858913e-06, -0.997892559, 1.41431883e-07, 1, -4.70933674e-06, 0.997892559, 1.64442184e-07, 0.0648873374)

			CFrameMon = CFrame.new(-1502.74609, 98.5633316, 90.6417007, 0.836947978, 0, 0.547282517, -0, 1, -0, -0.547282517, 0, 0.836947978)

			--Spawn = "Jungle"

		elseif MyLevel == 15 or MyLevel <= 29 or SelectMonster == "Gorilla [Lv. 20]" then -- Gorilla

			Mon = "Gorilla [Lv. 20]"

			--NameQuest = "JungleQuest"

			LevelQuest = 2

			NameMon = "Gorilla"

			--CFrameQuest = CFrame.new(-1604.12012, 36.8521118, 154.23732, 0.0648873374, -4.70858913e-06, -0.997892559, 1.41431883e-07, 1, -4.70933674e-06, 0.997892559, 1.64442184e-07, 0.0648873374)

			CFrameMon = CFrame.new(-1223.52808, 6.27936459, -502.292664, 0.310949147, -5.66602516e-08, 0.950426519, -3.37275488e-08, 1, 7.06501808e-08, -0.950426519, -5.40241736e-08, 0.310949147)

			--Spawn = "Jungle"

		elseif MyLevel == 30 or MyLevel <= 39 or SelectMonster == "Pirate [Lv. 35]" then -- Pirate

			Mon = "Pirate [Lv. 35]"

			--NameQuest = "BuggyQuest1"

			LevelQuest = 1

			NameMon = "Pirate"

			--CFrameQuest = CFrame.new(-1139.59717, 4.75205183, 3825.16211, -0.959730506, -7.5857054e-09, 0.280922383, -4.06310328e-08, 1, -1.11807175e-07, -0.280922383, -1.18718916e-07, -0.959730506)

			CFrameMon = CFrame.new(-1219.32324, 4.75205183, 3915.63452, -0.966492832, -6.91238853e-08, 0.25669381, -5.21195496e-08, 1, 7.3047012e-08, -0.25669381, 5.72206496e-08, -0.966492832)

			--Spawn = "Pirate"

		elseif MyLevel == 40 or MyLevel <= 59 or SelectMonster == "Brute [Lv. 45]" then -- Brute

			Mon = "Brute [Lv. 45]"

			--NameQuest = "BuggyQuest1"

			LevelQuest = 2

			NameMon = "Brute"

			--CFrameQuest = CFrame.new(-1139.59717, 4.75205183, 3825.16211, -0.959730506, -7.5857054e-09, 0.280922383, -4.06310328e-08, 1, -1.11807175e-07, -0.280922383, -1.18718916e-07, -0.959730506)

			CFrameMon = CFrame.new(-1146.49646, 96.0936813, 4312.1333, -0.978175163, -1.53222057e-08, 0.207781896, -3.33316912e-08, 1, -8.31738873e-08, -0.207781896, -8.82843523e-08, -0.978175163)

			--Spawn = "Pirate"

		elseif MyLevel == 60 or MyLevel <= 74 or SelectMonster == "Desert Bandit [Lv. 60]" then -- Desert Bandit

			Mon = "Desert Bandit [Lv. 60]"

			--NameQuest = "DesertQuest"

			LevelQuest = 1

			NameMon = "Desert Bandit"

			--CFrameQuest = CFrame.new(897.031128, 6.43846416, 4388.97168, -0.804044724, 3.68233266e-08, 0.594568789, 6.97835176e-08, 1, 3.24365246e-08, -0.594568789, 6.75715199e-08, -0.804044724)

			CFrameMon = CFrame.new(932.788818, 6.4503746, 4488.24609, -0.998625934, 3.08948351e-08, 0.0524050146, 2.79967303e-08, 1, -5.60361286e-08, -0.0524050146, -5.44919629e-08, -0.998625934)

			--Spawn = "Desert"

		elseif MyLevel == 75 or MyLevel <= 89 or SelectMonster == "Desert Officer [Lv. 70]" then -- Desert Officre

			Mon = "Desert Officer [Lv. 70]"

			--NameQuest = "DesertQuest"

			LevelQuest = 2

			NameMon = "Desert Officer"

			--CFrameQuest = CFrame.new(897.031128, 6.43846416, 4388.97168, -0.804044724, 3.68233266e-08, 0.594568789, 6.97835176e-08, 1, 3.24365246e-08, -0.594568789, 6.75715199e-08, -0.804044724)

			CFrameMon = CFrame.new(1580.03198, 4.61375761, 4366.86426, 0.135744005, -6.44280718e-08, -0.990743816, 4.35738308e-08, 1, -5.90598574e-08, 0.990743816, -3.51534837e-08, 0.135744005)

			--Spawn = "Desert"

		elseif MyLevel == 90 or MyLevel <= 99 or SelectMonster == "Snow Bandit [Lv. 90]" then -- Snow Bandits

			Mon = "Snow Bandit [Lv. 90]"

			--NameQuest = "SnowQuest"

			LevelQuest = 1

			NameMon = "Snow Bandits"

			--CFrameQuest = CFrame.new(1384.14001, 87.272789, -1297.06482, 0.348555952, -2.53947841e-09, -0.937287986, 1.49860568e-08, 1, 2.86358204e-09, 0.937287986, -1.50443711e-08, 0.348555952)

			CFrameMon = CFrame.new(1370.24316, 102.403511, -1411.52905, 0.980274439, -1.12995728e-08, 0.197641045, -9.57343449e-09, 1, 1.04655214e-07, -0.197641045, -1.04482936e-07, 0.980274439)

			--Spawn = "Ice"

		elseif MyLevel == 100 or MyLevel <= 119 or SelectMonster == "Snowman [Lv. 100]"  then -- Snowman

			Mon = "Snowman [Lv. 100]"

			--NameQuest = "SnowQuest"

			LevelQuest = 2

			NameMon = "Snowman"

			--CFrameQuest = CFrame.new(1384.14001, 87.272789, -1297.06482, 0.348555952, -2.53947841e-09, -0.937287986, 1.49860568e-08, 1, 2.86358204e-09, 0.937287986, -1.50443711e-08, 0.348555952)

			CFrameMon = CFrame.new(1370.24316, 102.403511, -1411.52905, 0.980274439, -1.12995728e-08, 0.197641045, -9.57343449e-09, 1, 1.04655214e-07, -0.197641045, -1.04482936e-07, 0.980274439)

			--Spawn = "Ice"

		elseif MyLevel == 120 or MyLevel <= 149 or SelectMonster == "Chief Petty Officer [Lv. 120]" then -- Chief Petty Officer

			Mon = "Chief Petty Officer [Lv. 120]"

			--NameQuest = "MarineQuest2"

			LevelQuest = 1

			NameMon = "Chief Petty Officer"

			--CFrameQuest = CFrame.new(-5035.0835, 28.6520386, 4325.29443, 0.0243340395, -7.08064647e-08, 0.999703884, -6.36926814e-08, 1, 7.23777944e-08, -0.999703884, -6.54350671e-08, 0.0243340395)

			CFrameMon = CFrame.new(-4882.8623, 22.6520386, 4255.53516, 0.273695946, -5.40380647e-08, -0.96181643, 4.37720793e-08, 1, -4.37274998e-08, 0.96181643, -3.01326679e-08, 0.273695946)

			--Spawn = "MarineBase"

		elseif MyLevel == 150 or MyLevel <= 174 or SelectMonster == "Sky Bandit [Lv. 150]" then -- Sky Bandit

			Mon = "Sky Bandit [Lv. 150]"

			--NameQuest = "SkyQuest"

			LevelQuest = 1

			NameMon = "Sky Bandit"

			--CFrameQuest = CFrame.new(-4841.83447, 717.669617, -2623.96436, -0.875942111, 5.59710216e-08, -0.482416272, 3.04023082e-08, 1, 6.08195947e-08, 0.482416272, 3.86078725e-08, -0.875942111)

			CFrameMon = CFrame.new(-4970.74219, 294.544342, -2890.11353, -0.994874597, -8.61311236e-08, -0.101116329, -9.10836206e-08, 1, 4.43614923e-08, 0.101116329, 5.33441664e-08, -0.994874597)

			--Spawn = "Sky"

		elseif MyLevel == 175 or MyLevel <= 189 or SelectMonster == "Dark Master [Lv. 175]" then -- Dark Master

			Mon = "Dark Master [Lv. 175]"

			--NameQuest = "SkyQuest"

			LevelQuest = 2

			NameMon = "Dark Master"

			--CFrameQuest = CFrame.new(-4841.83447, 717.669617, -2623.96436, -0.875942111, 5.59710216e-08, -0.482416272, 3.04023082e-08, 1, 6.08195947e-08, 0.482416272, 3.86078725e-08, -0.875942111)

			CFrameMon = CFrame.new(-5220.58594, 430.693298, -2278.17456, -0.925375521, 1.12086873e-08, 0.379051805, -1.05115507e-08, 1, -5.52320891e-08, -0.379051805, -5.50948407e-08, -0.925375521)

			--Spawn = "Sky"

		elseif MyLevel == 190 or MyLevel <= 209 or SelectMonster == "Prisoner [Lv. 190]" then

			Mon = "Prisoner [Lv. 190]"

			--NameQuest = "PrisonerQuest"

			LevelQuest = 1

			NameMon = "Prisoner"

			--CFrameQuest = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918e-09, -0.995993316, 1.60817859e-09, 1, -5.16744869e-09, 0.995993316, -2.06384709e-09, -0.0894274712)

			CFrameMon = CFrame.new(5433.39307, 88.678093, 514.986877, 0.879988372, 0, -0.474995494, 0, 1, 0, 0.474995494, 0, 0.879988372)

			--Spawn = "Prison"

		elseif MyLevel == 210 or MyLevel <= 249 or SelectMonster == "Dangerous Prisoner [Lv. 210]" then

			Mon = "Dangerous Prisoner [Lv. 210]"

			--NameQuest = "PrisonerQuest"

			LevelQuest = 2

			NameMon = "Dangerous Prisoner"

			--CFrameQuest = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918e-09, -0.995993316, 1.60817859e-09, 1, -5.16744869e-09, 0.995993316, -2.06384709e-09, -0.0894274712)

			CFrameMon = CFrame.new(5433.39307, 88.678093, 514.986877, 0.879988372, 0, -0.474995494, 0, 1, 0, 0.474995494, 0, 0.879988372)

			--Spawn = "Prison"

		elseif MyLevel == 250 or MyLevel <= 274 or SelectMonster == "Toga Warrior [Lv. 225]" then -- Toga Warrior

			Mon = "Toga Warrior [Lv. 250]"

			--NameQuest = "ColosseumQuest"

			LevelQuest = 1

			NameMon = "Toga Warrior"

			--CFrameQuest = CFrame.new(-1576.11743, 7.38933945, -2983.30762, 0.576966345, 1.22114863e-09, 0.816767931, -3.58496594e-10, 1, -1.24185606e-09, -0.816767931, 4.2370063e-10, 0.576966345)

			CFrameMon = CFrame.new(-1779.97583, 44.6077499, -2736.35474, 0.984437346, 4.10396339e-08, 0.175734788, -3.62286876e-08, 1, -3.05844168e-08, -0.175734788, 2.3741821e-08, 0.984437346)

			--Spawn = "Colosseum"

		elseif MyLevel == 275 or MyLevel <= 299 or SelectMonster == "Gladiator [Lv. 275]" then -- Gladiato

			Mon = "Gladiator [Lv. 275]"

			--NameQuest = "ColosseumQuest"

			LevelQuest = 2

			NameMon = "Gladiato"

			--CFrameQuest = CFrame.new(-1576.11743, 7.38933945, -2983.30762, 0.576966345, 1.22114863e-09, 0.816767931, -3.58496594e-10, 1, -1.24185606e-09, -0.816767931, 4.2370063e-10, 0.576966345)

			CFrameMon = CFrame.new(-1274.75903, 58.1895943, -3188.16309, 0.464524001, 6.21005611e-08, 0.885560572, -4.80449414e-09, 1, -6.76054768e-08, -0.885560572, 2.71497012e-08, 0.464524001)

			--Spawn = "Colosseum"

		elseif MyLevel == 300 or MyLevel <= 324 or SelectMonster == "Military Soldier [Lv. 300]" then -- Military Soldier

			Mon = "Military Soldier [Lv. 300]"

			--NameQuest = "MagmaQuest"

			LevelQuest = 1

			NameMon = "Military Soldier"

			--CFrameQuest = CFrame.new(-5316.55859, 12.2370615, 8517.2998, 0.588437557, -1.37880001e-08, -0.808542669, -2.10116209e-08, 1, -3.23446478e-08, 0.808542669, 3.60215964e-08, 0.588437557)

			CFrameMon = CFrame.new(-5363.01123, 41.5056877, 8548.47266, -0.578253984, -3.29503091e-10, 0.815856814, 9.11209668e-08, 1, 6.498761e-08, -0.815856814, 1.11920997e-07, -0.578253984)

			--Spawn = "Magma"

		elseif MyLevel == 325 or MyLevel <= 374 or SelectMonster == "Military Spy [Lv. 330]" then -- Military Spy

			Mon = "Military Spy [Lv. 325]"

			--NameQuest = "MagmaQuest"

			LevelQuest = 2

			NameMon = "Military Spy"

			--CFrameQuest = CFrame.new(-5316.55859, 12.2370615, 8517.2998, 0.588437557, -1.37880001e-08, -0.808542669, -2.10116209e-08, 1, -3.23446478e-08, 0.808542669, 3.60215964e-08, 0.588437557)

			CFrameMon = CFrame.new(-5787.99023, 120.864456, 8762.25293, -0.188358366, -1.84706277e-08, 0.982100308, -1.23782129e-07, 1, -4.93306951e-09, -0.982100308, -1.22495649e-07, -0.188358366)

			--Spawn = "Magma"

		elseif MyLevel == 375 or MyLevel <= 399 or SelectMonster == "Fishman Warrior [Lv. 375]" then -- Fishman Warrior

			Mon = "Fishman Warrior [Lv. 375]"

			--NameQuest = "FishmanQuest"

			LevelQuest = 1

			NameMon = "Fishman Warrior"

			--CFrameQuest = CFrame.new(61122.5625, 18.4716396, 1568.16504, 0.893533468, 3.95251609e-09, 0.448996574, -2.34327455e-08, 1, 3.78297464e-08, -0.448996574, -4.43233645e-08, 0.893533468)

			CFrameMon = CFrame.new(60946.6094, 48.6735229, 1525.91687, -0.0817126185, 8.90751153e-08, 0.996655822, 2.00889794e-08, 1, -8.77269599e-08, -0.996655822, 1.28533992e-08, -0.0817126185)

			--Spawn = "Fountain"

        elseif MyLevel == 400 or MyLevel <= 449 or SelectMonster == "Fishman Commando [Lv. 400]" then -- Fishman Commando

			Mon = "Fishman Commando [Lv. 400]"

			--NameQuest = "FishmanQuest"

			LevelQuest = 2

			NameMon = "Fishman Commando"

			--CFrameQuest = CFrame.new(61122.5625, 18.4716396, 1568.16504, 0.893533468, 3.95251609e-09, 0.448996574, -2.34327455e-08, 1, 3.78297464e-08, -0.448996574, -4.43233645e-08, 0.893533468)

			CFrameMon = CFrame.new(61885.5039, 18.4828243, 1504.17896, 0.577502489, 0, -0.816389024, -0, 1.00000012, -0, 0.816389024, 0, 0.577502489)

			--Spawn = "Fountain"

        elseif MyLevel == 450 or MyLevel <= 474 or SelectMonster == "God's Guard [Lv. 450]" then -- God's Guards

			Mon = "God's Guard [Lv. 450]"

			--NameQuest = "SkyExp1Quest"

			LevelQuest = 1

			NameMon = "God's Guards"

			--CFrameQuest = CFrame.new(-4721.71436, 845.277161, -1954.20105, -0.999277651, -5.56969759e-09, 0.0380011722, -4.14751478e-09, 1, 3.75035256e-08, -0.0380011722, 3.73188307e-08, -0.999277651)

			CFrameMon = CFrame.new(-4716.95703, 853.089722, -1933.92542, -0.93441087, -6.77488776e-09, -0.356197298, 1.12145182e-08, 1, -4.84390199e-08, 0.356197298, -4.92565206e-08, -0.93441087)

			--Spawn = "Sky"

        elseif MyLevel == 475 or MyLevel <= 524 or SelectMonster == "Shanda [Lv. 475]" then -- Shandas

            sky = false

			Mon = "Shanda [Lv. 475]"

			--NameQuest = "SkyExp1Quest"

			LevelQuest = 2

			NameMon = "Shandas"

			--CFrameQuest = CFrame.new(-7863.63672, 5545.49316, -379.826324, 0.362120807, -1.98046344e-08, -0.93213129, 4.05822291e-08, 1, -5.48095125e-09, 0.93213129, -3.58431969e-08, 0.362120807)

			CFrameMon = CFrame.new(-7685.12354, 5601.05127, -443.171509, 0.150056243, 1.79768236e-08, -0.988677442, 6.67798661e-09, 1, 1.91962481e-08, 0.988677442, -9.48289181e-09, 0.150056243)

			--Spawn = "Sky"

        elseif MyLevel == 525 or MyLevel <= 549 or SelectMonster == "Royal Squad [Lv. 525]" then -- Royal Squad

            sky = true

			Mon = "Royal Squad [Lv. 525]"

			--NameQuest = "SkyExp2Quest"

			LevelQuest = 1

			NameMon = "Royal Squad"

			--CFrameQuest = CFrame.new(-7902.66895, 5635.96387, -1411.71802, 0.0504222959, 2.5710392e-08, 0.998727977, 1.12541557e-07, 1, -3.14249675e-08, -0.998727977, 1.13982921e-07, 0.0504222959)

			CFrameMon = CFrame.new(-7685.02051, 5606.87842, -1442.729, 0.561947823, 7.69527464e-09, -0.827172697, -4.24974544e-09, 1, 6.41599973e-09, 0.827172697, -9.01838604e-11, 0.561947823)

			--Spawn = "Sky2"

		elseif MyLevel == 550 or MyLevel <= 624 or SelectMonster == "Royal Soldier [Lv. 550]" then -- Royal Soldier

            Dis = 240

            sky = true

			Mon = "Royal Soldier [Lv. 550]"

			--NameQuest = "SkyExp2Quest"

			LevelQuest = 2

			NameMon = "Royal Soldier"

			--CFrameQuest = CFrame.new(-7902.66895, 5635.96387, -1411.71802, 0.0504222959, 2.5710392e-08, 0.998727977, 1.12541557e-07, 1, -3.14249675e-08, -0.998727977, 1.13982921e-07, 0.0504222959)

			CFrameMon = CFrame.new(-7864.44775, 5661.94092, -1708.22351, 0.998389959, 2.28686137e-09, -0.0567218624, 1.99431383e-09, 1, 7.54200258e-08, 0.0567218624, -7.54117195e-08, 0.998389959)

			--Spawn = "Sky2"

		elseif MyLevel == 625 or MyLevel <= 649 or SelectMonster == "Galley Pirate [Lv. 625]" then -- Galley Pirate

            Dis = 240

            sky = false

			Mon = "Galley Pirate [Lv. 625]"

			--NameQuest = "FountainQuest"

			LevelQuest = 1

			NameMon = "Galley Pirate"

			--CFrameQuest = CFrame.new(5254.60156, 38.5011406, 4049.69678, -0.0504891425, -3.62066501e-08, -0.998724639, -9.87921389e-09, 1, -3.57534553e-08, 0.998724639, 8.06145284e-09, -0.0504891425)

			CFrameMon = CFrame.new(5595.06982, 41.5013695, 3961.47095, -0.992138803, -2.11610267e-08, -0.125142589, -1.34249509e-08, 1, -6.26613996e-08, 0.125142589, -6.04887518e-08, -0.992138803)

			--Spawn = "Fountain"

		elseif MyLevel >= 650 or SelectMonster == "Galley Captain [Lv. 650]" then -- Galley Captain

            Dis = 240

			Mon = "Galley Captain [Lv. 650]"

			--NameQuest = "FountainQuest"

			LevelQuest = 2

			NameMon = "Galley Captain"

			--CFrameQuest = CFrame.new(5254.60156, 38.5011406, 4049.69678, -0.0504891425, -3.62066501e-08, -0.998724639, -9.87921389e-09, 1, -3.57534553e-08, 0.998724639, 8.06145284e-09, -0.0504891425)

			CFrameMon = CFrame.new(5658.5752, 38.5361786, 4928.93506, -0.996873081, 2.12391046e-06, -0.0790185928, 2.16989656e-06, 1, -4.96097414e-07, 0.0790185928, -6.66008248e-07, -0.996873081)

			--Spawn = "Fountain"

		end

    elseif World2 then

		if MyLevel == 700 or MyLevel <= 724 or SelectMonster == "Raider [Lv. 700]" then -- Raider [Lv. 700]

			Mon = "Raider [Lv. 700]"

			--NameQuest = "Area1Quest"

			LevelQuest = 1

			NameMon = "Raider"

			--CFrameQuest = CFrame.new(-424.080078, 73.0055847, 1836.91589, 0.253544956, -1.42165932e-08, 0.967323601, -6.00147771e-08, 1, 3.04272909e-08, -0.967323601, -6.5768397e-08, 0.253544956)

			CFrameMon = CFrame.new(-737.026123, 39.1748352, 2392.57959, 0.272128761, 0, -0.962260842, -0, 1, -0, 0.962260842, 0, 0.272128761)

			--Spawn = "DressTown"

		elseif MyLevel == 725 or MyLevel <= 774 or SelectMonster == "Mercenary [Lv. 725]" then -- Mercenary [Lv. 725]

			Mon = "Mercenary [Lv. 725]"

			--NameQuest = "Area1Quest"

			LevelQuest = 2

			NameMon = "Mercenary"

			--CFrameQuest = CFrame.new(-424.080078, 73.0055847, 1836.91589, 0.253544956, -1.42165932e-08, 0.967323601, -6.00147771e-08, 1, 3.04272909e-08, -0.967323601, -6.5768397e-08, 0.253544956)

			CFrameMon = CFrame.new(-973.731995, 95.8733215, 1836.46936, 0.999135971, 2.02326991e-08, -0.0415605344, -1.90767793e-08, 1, 2.82094952e-08, 0.0415605344, -2.73922804e-08, 0.999135971)

			--Spawn = "DressTown"

		elseif MyLevel == 775 or MyLevel <= 799 or SelectMonster == "Swan Pirate [Lv. 775]" then -- Swan Pirate [Lv. 775]

			Mon = "Swan Pirate [Lv. 775]"

			--NameQuest = "Area2Quest"

			LevelQuest = 1

			NameMon = "Swan Pirate"

			--CFrameQuest = CFrame.new(632.698608, 73.1055908, 918.666321, -0.0319722369, 8.96074881e-10, -0.999488771, 1.36326533e-10, 1, 8.92172336e-10, 0.999488771, -1.07732087e-10, -0.0319722369)

			CFrameMon = CFrame.new(970.369446, 142.653198, 1217.3667, 0.162079468, -4.85452638e-08, -0.986777723, 1.03357589e-08, 1, -4.74980872e-08, 0.986777723, -2.50063148e-09, 0.162079468)

			--Spawn = "DressTown"

		elseif MyLevel == 800 or MyLevel <= 874 or SelectMonster == "Factory Staff [Lv. 800]" then -- Factory Staff [Lv. 800]

			Mon = "Factory Staff [Lv. 800]"

			--NameQuest = "Area2Quest"

			LevelQuest = 2

			NameMon = "Factory Staff"

			--CFrameQuest = CFrame.new(632.698608, 73.1055908, 918.666321, -0.0319722369, 8.96074881e-10, -0.999488771, 1.36326533e-10, 1, 8.92172336e-10, 0.999488771, -1.07732087e-10, -0.0319722369)

			CFrameMon = CFrame.new(296.786499, 72.9948196, -57.1298141, -0.876037002, -5.32364979e-08, 0.482243896, -3.87658332e-08, 1, 3.99718729e-08, -0.482243896, 1.63222538e-08, -0.876037002)

			--Spawn = "DressTown"

		elseif MyLevel == 875 or MyLevel <= 899 or SelectMonster == "Marine Lieutenant [Lv. 875]" then -- Marine Lieutenant [Lv. 875]

			Mon = "Marine Lieutenant [Lv. 875]"

			--NameQuest = "MarineQuest3"

			LevelQuest = 1

			NameMon = "Marine Lieutenant"

			--CFrameQuest = CFrame.new(-2442.65015, 73.0511475, -3219.11523, -0.873540044, 4.2329841e-08, -0.486752301, 5.64383384e-08, 1, -1.43220786e-08, 0.486752301, -3.99823996e-08, -0.873540044)

			CFrameMon = CFrame.new(-2913.26367, 73.0011826, -2971.64282, 0.910507619, 0, 0.413492233, 0, 1.00000012, 0, -0.413492233, 0, 0.910507619)

			--Spawn = "Greenb"

		elseif MyLevel == 900 or MyLevel <= 949 or SelectMonster == "Marine Captain [Lv. 900]" then -- Marine Captain [Lv. 900]

			Mon = "Marine Captain [Lv. 900]"

			--NameQuest = "MarineQuest3"

			LevelQuest = 2

			NameMon = "Marine Captain"

			--CFrameQuest = CFrame.new(-2442.65015, 73.0511475, -3219.11523, -0.873540044, 4.2329841e-08, -0.486752301, 5.64383384e-08, 1, -1.43220786e-08, 0.486752301, -3.99823996e-08, -0.873540044)

			CFrameMon = CFrame.new(-1868.67688, 73.0011826, -3321.66333, -0.971402287, 1.06502087e-08, 0.237439692, 3.68856199e-08, 1, 1.06050372e-07, -0.237439692, 1.11775684e-07, -0.971402287)

			--Spawn = "Greenb"

		elseif MyLevel == 950 or MyLevel <= 974 or SelectMonster == "Zombie [Lv. 950]" then -- Zombie [Lv. 950]

			Mon = "Zombie [Lv. 950]"

			--NameQuest = "ZombieQuest"

			LevelQuest = 1

			NameMon = "Zombie"

			--CFrameQuest = CFrame.new(-5492.79395, 48.5151672, -793.710571, 0.321800292, -6.24695815e-08, 0.946807742, 4.05616092e-08, 1, 5.21931227e-08, -0.946807742, 2.16082796e-08, 0.321800292)

			CFrameMon = CFrame.new(-5634.83838, 126.067039, -697.665039, -0.992770672, 6.77618939e-09, 0.120025545, 1.65461245e-08, 1, 8.04023372e-08, -0.120025545, 8.18070234e-08, -0.992770672)

			--Spawn = "Graveyard"

		elseif MyLevel == 975 or MyLevel <= 999 or SelectMonster == "Vampire [Lv. 975]" then -- Vampire [Lv. 975]

			Mon = "Vampire [Lv. 975]"

			--NameQuest = "ZombieQuest"

			LevelQuest = 2

			NameMon = "Vampire"

			--CFrameQuest = CFrame.new(-5492.79395, 48.5151672, -793.710571, 0.321800292, -6.24695815e-08, 0.946807742, 4.05616092e-08, 1, 5.21931227e-08, -0.946807742, 2.16082796e-08, 0.321800292)

			CFrameMon = CFrame.new(-6030.32031, 6.4377408, -1313.5564, -0.856965423, 3.9138893e-08, -0.515373945, -1.12178942e-08, 1, 9.45958547e-08, 0.515373945, 8.68467822e-08, -0.856965423)

			--Spawn = "Graveyard"

		elseif MyLevel == 1000 or MyLevel <= 1049 or SelectMonster == "Snow Trooper [Lv. 1000]" then -- Snow Trooper [Lv. 1000] **

			Mon = "Snow Trooper [Lv. 1000]"

			--NameQuest = "SnowMountainQuest"

			LevelQuest = 1

			NameMon = "Snow Trooper"

			--CFrameQuest = CFrame.new(604.964966, 401.457062, -5371.69287, 0.353063971, 1.89520435e-08, -0.935599446, -5.81846002e-08, 1, -1.70033754e-09, 0.935599446, 5.50377841e-08, 0.353063971)

			CFrameMon = CFrame.new(535.893433, 401.457062, -5329.6958, -0.999524176, 0, 0.0308452044, 0, 1, -0, -0.0308452044, 0, -0.999524176)

			--Spawn = "Snowy"

		elseif MyLevel == 1050 or MyLevel <= 1099 or SelectMonster == "Winter Warrior [Lv. 1050]" then -- Winter Warrior [Lv. 1050]

			Mon = "Winter Warrior [Lv. 1050]"

			--NameQuest = "SnowMountainQuest"

			LevelQuest = 2

			NameMon = "Winter Warrior"

			--CFrameQuest = CFrame.new(604.964966, 401.457062, -5371.69287, 0.353063971, 1.89520435e-08, -0.935599446, -5.81846002e-08, 1, -1.70033754e-09, 0.935599446, 5.50377841e-08, 0.353063971)

			CFrameMon = CFrame.new(1223.7417, 454.575226, -5170.02148, 0.473996818, 2.56845354e-08, 0.880526543, -5.62456428e-08, 1, 1.10811016e-09, -0.880526543, -5.00510211e-08, 0.473996818)

			--Spawn = "Snowy"

		elseif MyLevel == 1100 or MyLevel <= 1124 or SelectMonster == "Lab Subordinate [Lv. 1100]" then -- Lab Subordinate [Lv. 1100]

			Mon = "Lab Subordinate [Lv. 1100]"

			--NameQuest = "IceSideQuest"

			LevelQuest = 1

			NameMon = "Lab Subordinate"

			--CFrameQuest = CFrame.new(-6060.10693, 15.9868021, -4904.7876, -0.411000341, -5.06538868e-07, 0.91163528, 1.26306062e-07, 1, 6.12581289e-07, -0.91163528, 3.66916197e-07, -0.411000341)

			CFrameMon = CFrame.new(-5769.2041, 37.9288292, -4468.38721, -0.569419742, -2.49055017e-08, 0.822046936, -6.96206541e-08, 1, -1.79282633e-08, -0.822046936, -6.74401548e-08, -0.569419742)

			--Spawn = "CircleIslandIce"

		elseif MyLevel == 1125 or MyLevel <= 1174 or SelectMonster == "Horned Warrior [Lv. 1125]" then -- Horned Warrior [Lv. 1125]

			Mon = "Horned Warrior [Lv. 1125]"

			--NameQuest = "IceSideQuest"

			LevelQuest = 2

			NameMon = "Horned Warrior"

			--CFrameQuest = CFrame.new(-6060.10693, 15.9868021, -4904.7876, -0.411000341, -5.06538868e-07, 0.91163528, 1.26306062e-07, 1, 6.12581289e-07, -0.91163528, 3.66916197e-07, -0.411000341)

			CFrameMon = CFrame.new(-6400.85889, 24.7645149, -5818.63574, -0.964845479, 8.65926566e-08, -0.262817472, 3.98261392e-07, 1, -1.13260398e-06, 0.262817472, -1.19745812e-06, -0.964845479)

			--Spawn = "CircleIslandIce"

		elseif MyLevel == 1175 or MyLevel <= 1199 or SelectMonster == "Magma Ninja [Lv. 1175]" then -- Magma Ninja [Lv. 1175]

			Mon = "Magma Ninja [Lv. 1175]"

			--NameQuest = "FireSideQuest"

			LevelQuest = 1

			NameMon = "Magma Ninja"

			--CFrameQuest = CFrame.new(-5431.09473, 15.9868021, -5296.53223, 0.831796765, 1.15322464e-07, -0.555080295, -1.10814341e-07, 1, 4.17010995e-08, 0.555080295, 2.68240168e-08, 0.831796765)

			CFrameMon = CFrame.new(-5496.65576, 58.6890411, -5929.76855, -0.885073781, 0, -0.465450764, 0, 1.00000012, -0, 0.465450764, 0, -0.885073781)

			--Spawn = "CircleIslandFire"

		elseif MyLevel == 1200 or MyLevel <= 1249 or SelectMonster == "Lava Pirate [Lv. 1200]" then -- Lava Pirate [Lv. 1200]

			Mon = "Lava Pirate [Lv. 1200]"

			--NameQuest = "FireSideQuest"

			LevelQuest = 2

			NameMon = "Lava Pirate"

			--CFrameQuest = CFrame.new(-5431.09473, 15.9868021, -5296.53223, 0.831796765, 1.15322464e-07, -0.555080295, -1.10814341e-07, 1, 4.17010995e-08, 0.555080295, 2.68240168e-08, 0.831796765)

			CFrameMon = CFrame.new(-5169.71729, 34.1234779, -4669.73633, -0.196780294, 0, 0.98044765, 0, 1.00000012, -0, -0.98044765, 0, -0.196780294)

			--Spawn = "CircleIslandFire"

		elseif MyLevel == 1250 or MyLevel <= 1274 or SelectMonster == "Ship Deckhand [Lv. 1250]" then -- Ship Deckhand [Lv. 1250]

			Mon = "Ship Deckhand [Lv. 1250]"

			--NameQuest = "ShipQuest1"

			LevelQuest = 1

			NameMon = "Ship Deckhand"

			--CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016, -0.244533166, -0, -0.969640911, -0, 1.00000012, -0, 0.96964103, 0, -0.244533136)

			CFrameMon = CFrame.new(1163.80872, 138.288452, 33058.4258, -0.998580813, 5.49076979e-08, -0.0532564968, 5.57436763e-08, 1, -1.42118655e-08, 0.0532564968, -1.71604082e-08, -0.998580813)

			--Spawn = "Ship"

        elseif MyLevel == 1275 or MyLevel <= 1299 or SelectMonster == "Ship Engineer [Lv. 1275]"  then -- Ship Engineer [Lv. 1275]

			Mon = "Ship Engineer [Lv. 1275]"

			--NameQuest = "ShipQuest1"

			LevelQuest = 2

			NameMon = "Ship Engineer"

			--CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016, -0.244533166, -0, -0.969640911, -0, 1.00000012, -0, 0.96964103, 0, -0.244533136)

			CFrameMon = CFrame.new(916.666504, 44.0920448, 32917.207, -0.99746871, -4.85034697e-08, -0.0711069331, -4.8925461e-08, 1, 4.19294288e-09, 0.0711069331, 7.66126895e-09, -0.99746871)

			--Spawn = "Ship"

        elseif MyLevel == 1300 or MyLevel <= 1324 or SelectMonster == "Ship Steward [Lv. 1300]" then -- Ship Steward [Lv. 1300]

			Mon = "Ship Steward [Lv. 1300]"

			--NameQuest = "ShipQuest2"

			LevelQuest = 1

			NameMon = "Ship Steward"

			--CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125, -0.869560242, 1.51905191e-08, -0.493826836, 1.44108379e-08, 1, 5.38534195e-09, 0.493826836, -2.43357912e-09, -0.869560242)

			CFrameMon = CFrame.new(918.743286, 129.591064, 33443.4609, -0.999792814, -1.7070947e-07, -0.020350717, -1.72559169e-07, 1, 8.91351277e-08, 0.020350717, 9.2628369e-08, -0.999792814)

			--Spawn = "Ship"

        elseif MyLevel == 1325 or MyLevel <= 1349 or SelectMonster == "Ship Officer [Lv. 1325]" then -- Ship Officer [Lv. 1325]

			Mon = "Ship Officer [Lv. 1325]"

			--NameQuest = "ShipQuest2"

			LevelQuest = 2

			NameMon = "Ship Officer"

			--CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125, -0.869560242, 1.51905191e-08, -0.493826836, 1.44108379e-08, 1, 5.38534195e-09, 0.493826836, -2.43357912e-09, -0.869560242)

			CFrameMon = CFrame.new(786.051941, 181.474106, 33303.2969, 0.999285698, -5.32193063e-08, 0.0377905183, 5.68968588e-08, 1, -9.62386864e-08, -0.0377905183, 9.83201005e-08, 0.999285698)

			--Spawn = "Ship"

        elseif MyLevel == 1350 or MyLevel <= 1374 or SelectMonster == "Arctic Warrior [Lv. 1350]" then -- Arctic Warrior [Lv. 1350]

			Mon = "Arctic Warrior [Lv. 1350]"

			--NameQuest = "FrostQuest"

			LevelQuest = 1

			NameMon = "Arctic Warrior"

			--CFrameQuest = CFrame.new(5669.43506, 28.2117786, -6482.60107, 0.888092756, 1.02705066e-07, 0.459664226, -6.20391774e-08, 1, -1.03572376e-07, -0.459664226, 6.34646895e-08, 0.888092756)

			CFrameMon = CFrame.new(5995.07471, 57.3188477, -6183.47314, 0.702747107, -1.53454167e-07, -0.711440146, -1.08168464e-07, 1, -3.22542007e-07, 0.711440146, 3.03620908e-07, 0.702747107)

			--Spawn = "IceCastle"

        elseif MyLevel == 1375 or MyLevel <= 1424 or SelectMonster == "Snow Lurker [Lv. 1375]" then -- Snow Lurker [Lv. 1375]

			Mon = "Snow Lurker [Lv. 1375]"

			--NameQuest = "FrostQuest"

			LevelQuest = 2

			NameMon = "Snow Lurker"

			--CFrameQuest = CFrame.new(5669.43506, 28.2117786, -6482.60107, 0.888092756, 1.02705066e-07, 0.459664226, -6.20391774e-08, 1, -1.03572376e-07, -0.459664226, 6.34646895e-08, 0.888092756)

			CFrameMon = CFrame.new(5518.00684, 60.5559731, -6828.80518, -0.650781393, -3.64292951e-08, 0.759265184, -4.07668654e-09, 1, 4.44854642e-08, -0.759265184, 2.58550248e-08, -0.650781393)

			--Spawn = "IceCastle"

		elseif MyLevel == 1425 or MyLevel <= 1449 or SelectMonster == "Sea Soldier [Lv. 1425]" then -- Sea Soldier [Lv. 1425]

			Mon = "Sea Soldier [Lv. 1425]"

			--NameQuest = "ForgottenQuest"

			LevelQuest = 1

			NameMon = "Sea Soldier"

			--CFrameQuest = CFrame.new(-3052.99097, 236.881363, -10148.1943, -0.997911751, 4.42321983e-08, 0.064591676, 4.90968759e-08, 1, 7.37270085e-08, -0.064591676, 7.67442998e-08, -0.997911751)

			CFrameMon = CFrame.new(-3029.78467, 66.944252, -9777.38184, -0.998552859, 1.09555076e-08, 0.0537791774, 7.79564235e-09, 1, -5.89660658e-08, -0.0537791774, -5.84614881e-08, -0.998552859)

			--Spawn = "ForgottenIsland"

		elseif MyLevel >= 1450 or SelectMonster == "Water Fighter [Lv. 1450]" then -- Water Fighter [Lv. 1450]

			Mon = "Water Fighter [Lv. 1450]"

			--NameQuest = "ForgottenQuest"

			LevelQuest = 2

			NameMon = "Water Fighter"

			--CFrameQuest = CFrame.new(-3052.99097, 236.881363, -10148.1943, -0.997911751, 4.42321983e-08, 0.064591676, 4.90968759e-08, 1, 7.37270085e-08, -0.064591676, 7.67442998e-08, -0.997911751)

			CFrameMon = CFrame.new(-3262.00098, 298.699615, -10553.6943, -0.233570755, -4.57538185e-08, 0.972339869, -5.80986068e-08, 1, 3.30992194e-08, -0.972339869, -4.87605725e-08, -0.233570755)

			--Spawn = "ForgottenIsland"

		end

	elseif World3 then

		if MyLevel == 1500 or MyLevel <= 1524 or SelectMonster == "Pirate Millionaire [Lv. 1500]" then

			Mon = "Pirate Millionaire [Lv. 1500]"

			--NameQuest = "PiratePortQuest"

			LevelQuest = 1

			NameMon = "Pirate Millionaire"

			--CFrameQuest = CFrame.new(-290.074677, 42.9034653, 5581.58984, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627)

			CFrameMon = CFrame.new(81.164993286133, 43.755737304688, 5724.7021484375)

			--Spawn = "Default"

		elseif MyLevel == 1525 or MyLevel <= 1574 or SelectMonster == "Pistol Billionaire [Lv. 1525]" then

			Mon = "Pistol Billionaire [Lv. 1525]"

			--NameQuest = "PiratePortQuest"

			LevelQuest = 2

			NameMon = "Pistol Billionaire"

			--CFrameQuest = CFrame.new(-290.074677, 42.9034653, 5581.58984, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627)

			CFrameMon = CFrame.new(81.164993286133, 43.755737304688, 5724.7021484375)

			--Spawn = "Default"

		elseif MyLevel == 1575 or MyLevel <= 1599 or SelectMonster == "Dragon Crew Warrior [Lv. 1575]" then

			Mon = "Dragon Crew Warrior [Lv. 1575]"

			--NameQuest = "AmazonQuest"

			LevelQuest = 1

			NameMon = "Dragon Crew Warrior"

			--CFrameQuest = CFrame.new(5832.83594, 51.6806107, -1101.51563, 0.898790359, -0, -0.438378751, 0, 1, -0, 0.438378751, 0, 0.898790359)

			CFrameMon = CFrame.new(6241.9951171875, 51.522083282471, -1243.9771728516)

			--Spawn = "Hydra3"

		elseif MyLevel == 1600 or MyLevel <= 1624 or SelectMonster == "Dragon Crew Archer [Lv. 1600]" then

			Mon = "Dragon Crew Archer [Lv. 1600]"

			--NameQuest = "AmazonQuest"

			LevelQuest = 2

			NameMon = "Dragon Crew Archer"

			--CFrameQuest = CFrame.new(5832.83594, 51.6806107, -1101.51563, 0.898790359, -0, -0.438378751, 0, 1, -0, 0.438378751, 0, 0.898790359)

			CFrameMon = CFrame.new(6488.9155273438, 383.38375854492, -110.66246032715)

			--Spawn = "Hydra3"

		elseif MyLevel == 1625 or MyLevel <= 1649 or SelectMonster == "Female Islander [Lv. 1625]" then

			Mon = "Female Islander [Lv. 1625]"

			--NameQuest = "AmazonQuest2"

			LevelQuest = 1

			NameMon = "Female Islander"

			--CFrameQuest = CFrame.new(5448.86133, 601.516174, 751.130676, 0, 0, 1, 0, 1, -0, -1, 0, 0)

			CFrameMon = CFrame.new(4770.4990234375, 758.95520019531, 1069.8680419922)

			--Spawn = "Hydra1"

		elseif MyLevel == 1650 or MyLevel <= 1699 or SelectMonster == "Giant Islander [Lv. 1650]" then

			Mon = "Giant Islander [Lv. 1650]"

			--NameQuest = "AmazonQuest2"

			LevelQuest = 2

			NameMon = "Giant Islander"

			--CFrameQuest = CFrame.new(5448.86133, 601.516174, 751.130676, 0, 0, 1, 0, 1, -0, -1, 0, 0)

			CFrameMon = CFrame.new(4530.3540039063, 656.75695800781, -131.60952758789)

			--Spawn = "Hydra1"

		elseif MyLevel == 1700 or MyLevel <= 1724 or SelectMonster == "Marine Commodore [Lv. 1700]" then

			Mon = "Marine Commodore [Lv. 1700]"

			--NameQuest = "MarineTreeIsland"

			LevelQuest = 1

			NameMon = "Marine Commodore"

			--CFrameQuest = CFrame.new(2180.54126, 27.8156815, -6741.5498, -0.965929747, 0, 0.258804798, 0, 1, 0, -0.258804798, 0, -0.965929747)

			CFrameMon = CFrame.new(2490.0844726563, 190.4232635498, -7160.0502929688)

			--Spawn = "GreatTree"

		elseif MyLevel == 1725 or MyLevel <= 1774 or SelectMonster == "Marine Rear Admiral [Lv. 1725]" then

			Mon = "Marine Rear Admiral [Lv. 1725]"

			--NameQuest = "MarineTreeIsland"

			LevelQuest = 2

			NameMon = "Marine Rear Admiral"

			--CFrameQuest = CFrame.new(2180.54126, 27.8156815, -6741.5498, -0.965929747, 0, 0.258804798, 0, 1, 0, -0.258804798, 0, -0.965929747)

			CFrameMon = CFrame.new(3951.3903808594, 229.11549377441, -6912.81640625)

			--Spawn = "GreatTree"

		elseif MyLevel == 1775 or MyLevel <= 1799 or SelectMonster == "Fishman Raider [Lv. 1775]" then

			Mon = "Fishman Raider [Lv. 1775]"

			--NameQuest = "DeepForestIsland3"

			LevelQuest = 1

			NameMon = "Fishman Raider"

			--CFrameQuest = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)

			CFrameMon = CFrame.new(-10322.400390625, 390.94473266602, -8580.0908203125)

			--Spawn = "PineappleTown"

		elseif MyLevel == 1800 or MyLevel <= 1824 or SelectMonster == "Fishman Captain [Lv. 1800]" then

			Mon = "Fishman Captain [Lv. 1800]"

			--NameQuest = "DeepForestIsland3"

			LevelQuest = 2

			NameMon = "Fishman Captain"

			--CFrameQuest = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)

			CFrameMon = CFrame.new(-11194.541992188, 442.02795410156, -8608.806640625)

			--Spawn = "PineappleTown"

		elseif MyLevel == 1825 or MyLevel <= 1849 or SelectMonster == "Forest Pirate [Lv. 1825]" then

			Mon = "Forest Pirate [Lv. 1825]"

			--NameQuest = "DeepForestIsland"

			LevelQuest = 1

			NameMon = "Forest Pirate"

			--CFrameQuest = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247)

			CFrameMon = CFrame.new(-13225.809570313, 428.19387817383, -7753.1245117188)

			--Spawn = "BigMansion"

		elseif MyLevel == 1850 or MyLevel <= 1899 or SelectMonster == "Mythological Pirate [Lv. 1850]" then

			Mon = "Mythological Pirate [Lv. 1850]"

			--NameQuest = "DeepForestIsland"

			LevelQuest = 2

			NameMon = "Mythological Pirate"

			--CFrameQuest = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247)

			CFrameMon = CFrame.new(-13869.172851563, 564.95251464844, -7084.4135742188)

			--Spawn = "BigMansion"

		elseif MyLevel == 1900 or MyLevel <= 1924 or SelectMonster == "Jungle Pirate [Lv. 1900]" then

			Mon = "Jungle Pirate [Lv. 1900]"

			--NameQuest = "DeepForestIsland2"

			LevelQuest = 1

			NameMon = "Jungle Pirate"

			--CFrameQuest = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002)

			CFrameMon = CFrame.new(-11982.221679688, 376.32522583008, -10451.415039063)

			--Spawn = "PineappleTown"

		elseif MyLevel == 1925 or MyLevel <= 1974 or SelectMonster == "Musketeer Pirate [Lv. 1925]" then

			Mon = "Musketeer Pirate [Lv. 1925]"

			--NameQuest = "DeepForestIsland2"

			LevelQuest = 2

			NameMon = "Musketeer Pirate"

			--CFrameQuest = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002)

			CFrameMon = CFrame.new(-13282.3046875, 496.23684692383, -9565.150390625)

			--Spawn = "PineappleTown"

		elseif MyLevel == 1975 or MyLevel <= 1999 or SelectMonster == "Reborn Skeleton [Lv. 1975]" then

			Mon = "Reborn Skeleton [Lv. 1975]"

			--NameQuest = "HauntedQuest1"

			LevelQuest = 1

			NameMon = "Reborn Skeleton"

			--CFrameQuest = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, -0, -1, 0, 0)

			CFrameMon = CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813)

			--Spawn = "HauntedCastle"

		elseif MyLevel == 2000 or MyLevel <= 2024 or SelectMonster == "Living Zombie [Lv. 2000]" then

			Mon = "Living Zombie [Lv. 2000]"

			--NameQuest = "HauntedQuest1"

			LevelQuest = 2

			NameMon = "Living Zombie"

			--CFrameQuest = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, -0, -1, 0, 0)

			CFrameMon = CFrame.new(-10093.930664063, 237.38233947754, 6180.5654296875)

			--Spawn = "HauntedCastle"

		elseif MyLevel == 2025 or MyLevel <= 2049 or SelectMonster == "Demonic Soul [Lv. 2025]" then

			Mon = "Demonic Soul [Lv. 2025]"

			--NameQuest = "HauntedQuest2"

			LevelQuest = 1

			NameMon = "Demonic Soul"

			--CFrameQuest = CFrame.new(-9514.78027, 171.162918, 6078.82373, 0.301918149, 7.4535027e-09, 0.953333855, -3.22802141e-09, 1, -6.79604995e-09, -0.953333855, -1.02553133e-09, 0.301918149)

			CFrameMon = CFrame.new(-9466.72949, 171.162918, 6132.01514)

			--Spawn = "HauntedCastle"

		elseif MyLevel == 2050 or MyLevel <= 2074 or SelectMonster == "Posessed Mummy [Lv. 2050]" then

			Mon = "Posessed Mummy [Lv. 2050]" 

			--NameQuest = "HauntedQuest2"

			LevelQuest = 2

			NameMon = "Posessed Mummy"

			--CFrameQuest = CFrame.new(-9514.78027, 171.162918, 6078.82373, 0.301918149, 7.4535027e-09, 0.953333855, -3.22802141e-09, 1, -6.79604995e-09, -0.953333855, -1.02553133e-09, 0.301918149)

			CFrameMon = CFrame.new(-9589.93848, 4.85058546, 6190.27197)

			--Spawn = "HauntedCastle"

		elseif MyLevel == 2075 or MyLevel <= 2099 or SelectMonster == "Peanut Scout [Lv. 2075]" then

            Mon = "Peanut Scout [Lv. 2075]"

            --NameQuest = "NutsIslandQuest"

            LevelQuest = 1

            NameMon = "Peanut Scout"

            --CFrameQuest = CFrame.new(-2103.9375, 38.139019012451, -10192.702148438)

            CFrameMon = CFrame.new(-2150.587890625, 122.49767303467, -10358.994140625)

			--Spawn = "Peanut"

		elseif MyLevel == 2100 or MyLevel <= 2124 or SelectMonster == "Peanut President [Lv. 2100]" then

            Mon = "Peanut President [Lv. 2100]"

            --NameQuest = "NutsIslandQuest"

            LevelQuest = 2

            NameMon = "Peanut President"

            --CFrameQuest = CFrame.new(-2103.9375, 38.139019012451, -10192.702148438)

            CFrameMon = CFrame.new(-2150.587890625, 122.49767303467, -10358.994140625)

			--Spawn = "Peanut"

		elseif MyLevel == 2125 or MyLevel <= 2149 or SelectMonster == "Ice Cream Chef [Lv. 2125]" then

            Mon = "Ice Cream Chef [Lv. 2125]"

            --NameQuest = "IceCreamIslandQuest"

            LevelQuest = 1

            NameMon = "Ice Cream Chef"

            --CFrameQuest = CFrame.new(-819.84533691406, 65.845329284668, -10965.487304688)

            CFrameMon = CFrame.new(-890.55895996094, 186.34135437012, -11127.306640625)

			--Spawn = "IceCream"

		elseif MyLevel == 2150 or MyLevel <= 2199 or SelectMonster == "Ice Cream Commander [Lv. 2150]" then

            Mon = "Ice Cream Commander [Lv. 2150]"

            --NameQuest = "IceCreamIslandQuest"

            LevelQuest = 2

            NameMon = "Ice Cream Commander"

            --CFrameQuest = CFrame.new(-819.84533691406, 65.845329284668, -10965.487304688)

            CFrameMon = CFrame.new(-890.55895996094, 186.34135437012, -11127.306640625)

			--Spawn = "IceCream"

		elseif MyLevel == 2200 or MyLevel <= 2224 or SelectMonster == "Cookie Crafter [Lv. 2200]" then

            Mon = "Cookie Crafter [Lv. 2200]"

            --NameQuest = "CakeQuest1"

            LevelQuest = 1

            NameMon = "Cookie Crafter"

            --CFrameQuest = CFrame.new(-2021.5509033203125, 37.798221588134766, -12028.103515625)

            CFrameMon = CFrame.new(-2273.00244140625, 90.22590637207031, -12151.62109375)

			--Spawn = "Loaf"

		elseif MyLevel == 2225 or MyLevel <= 2249 or SelectMonster == "Cake Guard [Lv. 2225]" then

            Mon = "Cake Guard [Lv. 2225]"

            --NameQuest = "CakeQuest1"

            LevelQuest = 2

            NameMon = "Cake Guard"

            --CFrameQuest = CFrame.new(-2021.5509033203125, 37.798221588134766, -12028.103515625)

            CFrameMon = CFrame.new(-1442.373046875, 158.14111328125, -12277.37109375)

			--Spawn = "Loaf"

		elseif MyLevel == 2250 or MyLevel <= 2274 or SelectMonster == "Baking Staff [Lv. 2250]" then

            Mon = "Baking Staff [Lv. 2250]"

            --NameQuest = "CakeQuest2"

            LevelQuest = 1

            NameMon = "Baking Staff"

            --CFrameQuest = CFrame.new(-1927.9107666015625, 37.79813003540039, -12843.78515625)

            CFrameMon = CFrame.new(-1837.2803955078125, 129.0594482421875, -12934.5498046875)

			--Spawn = "Loaf"

		elseif MyLevel == 2275 or MyLevel <= 2299 or SelectMonster == "Head Baker [Lv. 2275]" then

            Mon = "Head Baker [Lv. 2275]"

            --NameQuest = "CakeQuest2"

            LevelQuest = 2

            NameMon = "Head Baker"

            --CFrameQuest = CFrame.new(-1927.9107666015625, 37.79813003540039, -12843.78515625)

            CFrameMon = CFrame.new(-2203.302490234375, 109.90937042236328, -12788.7333984375)

			--Spawn = "Loaf"

		elseif MyLevel == 2300 or MyLevel <= 2324 or SelectMonster == "Cocoa Warrior [Lv. 2300]" then

            Mon = "Cocoa Warrior [Lv. 2300]"

            --NameQuest = "ChocQuest1"

            LevelQuest = 1

            NameMon = "Cocoa Warrior"

            --CFrameQuest = CFrame.new(231.13571166992188, 24.734268188476562, -12195.1162109375)

            CFrameMon = CFrame.new(231.13571166992188, 24.734268188476562, -12195.1162109375)

			--Spawn = "Chocolate"

		elseif MyLevel == 2325 or MyLevel <= 2349 or SelectMonster == "Chocolate Bar Battler [Lv. 2325]" then

            Mon = "Chocolate Bar Battler [Lv. 2325]"

            --NameQuest = "ChocQuest1"

            LevelQuest = 2

            NameMon = "Chocolate Bar Battler"

            --CFrameQuest = CFrame.new(231.13571166992188, 24.734268188476562, -12195.1162109375)

            CFrameMon = CFrame.new(231.13571166992188, 24.734268188476562, -12195.1162109375)

			--Spawn = "Chocolate"

		elseif MyLevel == 2350 or MyLevel <= 2374 or SelectMonster == "Sweet Thief [Lv. 2350]" then

            Mon = "Sweet Thief [Lv. 2350]"

            --NameQuest = "ChocQuest2"

            LevelQuest = 1

            NameMon = "Sweet Thief"

            --CFrameQuest = CFrame.new(147.52256774902344, 24.793832778930664, -12775.3583984375)

            CFrameMon = CFrame.new(147.52256774902344, 24.793832778930664, -12775.3583984375)

			--Spawn = "Chocolate"

		elseif MyLevel == 2375 or MyLevel <= 2400 or SelectMonster == "Candy Rebel [Lv. 2375]" then

            Mon = "Candy Rebel [Lv. 2375]"

            --NameQuest = "ChocQuest2"

            LevelQuest = 2

            NameMon = "Candy Rebel"

            --CFrameQuest = CFrame.new(147.52256774902344, 24.793832778930664, -12775.3583984375)

            CFrameMon = CFrame.new(147.52256774902344, 24.793832778930664, -12775.3583984375)

			--Spawn = "Chocolate"

elseif MyLevel == 2400 or MyLevel <= 2424 or SelectMonster == "Candy Pirate [Lv. 2400]" then



            Mon = "Candy Pirate [Lv. 2400]"

            QuestName = "CandyQuest1"



            LevelQuest = 1

            NameMon = "Candy Pirate"



            CFrameMon = CFrame.new(-1476, 52, -14638)

            VectorMon = Vector3.new(-1476, 52, -14638)



            CFrameQuest = CFrame.new(-1149, 13, -14445)

            VectorQuest = Vector3.new(-1149, 13, -14445)

        elseif MyLevel >= 2425 or SelectMonster == "Snow Demon [Lv. 2425]" then





            Mon = "Snow Demon [Lv. 2425]"

            QuestName = "CandyQuest1"



            LevelQuest = 2

            NameMon = "Snow Demon"

            

            CFrameMon = CFrame.new(-948, 62, -14551)

            VectorMon = CFrame.new(-948, 62, -14551)



            CFrameQuest = CFrame.new(-1149, 13, -14445)

            VectorQuest = Vector3.new(-1149, 13, -14445)

		end

    end

end

function Hop()
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.date("!*t").hour
    local Deleted = false
    function TPReturner()
        local Site;
        if foundAnything == "" then
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
        else
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
        end
        local ID = ""
        if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
            foundAnything = Site.nextPageCursor
        end
        local num = 0;
        for i,v in pairs(Site.data) do
            local Possible = true
            ID = tostring(v.id)
            if tonumber(v.maxPlayers) > tonumber(v.playing) then
                for _,Existing in pairs(AllIDs) do
                    if num ~= 0 then
                        if ID == tostring(Existing) then
                            Possible = false
                        end
                    else
                        if tonumber(actualHour) ~= tonumber(Existing) then
                            local delFile = pcall(function()
                                AllIDs = {}
                                table.insert(AllIDs, actualHour)
                            end)
                        end
                    end
                    num = num + 1
                end
                if Possible == true then
                    table.insert(AllIDs, ID)
                    wait()
                    pcall(function()
                        wait()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                    end)
                    wait(4)
                end
            end
        end
    end
    function Teleport() 
        while wait() do
            pcall(function()
                TPReturner()
                if foundAnything ~= "" then
                    TPReturner()
                end
            end)
        end
    end
    Teleport()
end       

function UpdateIslandESP() 
    for i,v in pairs(game:GetService("Workspace")["_WorldOrigin"].Locations:GetChildren()) do
        pcall(function()
            if IslandESP then 
                if v.Name ~= "Sea" then
                    if not v:FindFirstChild('NameEsp') then
                        local bill = Instance.new('BillboardGui',v)
                        bill.Name = 'NameEsp'
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel',bill)
                        name.Font = "GothamBold"
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(7, 236, 240)
                    else
                        v['NameEsp'].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                    end
                end
            else
                if v:FindFirstChild('NameEsp') then
                    v:FindFirstChild('NameEsp'):Destroy()
                end
            end
        end)
    end
end

function isnil(thing)
return (thing == nil)
end
local function round(n)
return math.floor(tonumber(n) + 0.5)
end
Number = math.random(1, 1000000)
function UpdatePlayerChams()
for i,v in pairs(game:GetService'Players':GetChildren()) do
    pcall(function()
        if not isnil(v.Character) then
            if ESPPlayer then
                if not isnil(v.Character.Head) and not v.Character.Head:FindFirstChild('NameEsp'..Number) then
                    local bill = Instance.new('BillboardGui',v.Character.Head)
                    bill.Name = 'NameEsp'..Number
                    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                    bill.Size = UDim2.new(1,200,1,30)
                    bill.Adornee = v.Character.Head
                    bill.AlwaysOnTop = true
                    local name = Instance.new('TextLabel',bill)
                    name.Font = Enum.Font.GothamSemibold
                    name.FontSize = "Size14"
                    name.TextWrapped = true
                    name.Text = (v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude/3) ..' Distance')
                    name.Size = UDim2.new(1,0,1,0)
                    name.TextYAlignment = 'Top'
                    name.BackgroundTransparency = 1
                    name.TextStrokeTransparency = 0.5
                    if v.Team == game.Players.LocalPlayer.Team then
                        name.TextColor3 = Color3.new(0,255,0)
                    else
                        name.TextColor3 = Color3.new(255,0,0)
                    end
                else
                    v.Character.Head['NameEsp'..Number].TextLabel.Text = (v.Name ..' | '.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude/3) ..' Distance\nHealth : ' .. round(v.Character.Humanoid.Health*100/v.Character.Humanoid.MaxHealth) .. '%')
                end
            else
                if v.Character.Head:FindFirstChild('NameEsp'..Number) then
                    v.Character.Head:FindFirstChild('NameEsp'..Number):Destroy()
                end
            end
        end
    end)
end
end
function UpdateChestChams() 
for i,v in pairs(game.Workspace:GetChildren()) do
    pcall(function()
        if string.find(v.Name,"Chest") then
            if ChestESP then
                if string.find(v.Name,"Chest") then
                    if not v:FindFirstChild('NameEsp'..Number) then
                        local bill = Instance.new('BillboardGui',v)
                        bill.Name = 'NameEsp'..Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel',bill)
                        name.Font = Enum.Font.GothamSemibold
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        if v.Name == "Chest1" then
                            name.TextColor3 = Color3.fromRGB(109, 109, 109)
                            name.Text = ("Chest 1" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                        end
                        if v.Name == "Chest2" then
                            name.TextColor3 = Color3.fromRGB(173, 158, 21)
                            name.Text = ("Chest 2" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                        end
                        if v.Name == "Chest3" then
                            name.TextColor3 = Color3.fromRGB(85, 255, 255)
                            name.Text = ("Chest 3" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                        end
                    else
                        v['NameEsp'..Number].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                    end
                end
            else
                if v:FindFirstChild('NameEsp'..Number) then
                    v:FindFirstChild('NameEsp'..Number):Destroy()
                end
            end
        end
    end)
end
end
function UpdateDevilChams() 
for i,v in pairs(game.Workspace:GetChildren()) do
    pcall(function()
        if DevilFruitESP then
            if string.find(v.Name, "Fruit") then   
                if not v.Handle:FindFirstChild('NameEsp'..Number) then
                    local bill = Instance.new('BillboardGui',v.Handle)
                    bill.Name = 'NameEsp'..Number
                    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                    bill.Size = UDim2.new(1,200,1,30)
                    bill.Adornee = v.Handle
                    bill.AlwaysOnTop = true
                    local name = Instance.new('TextLabel',bill)
                    name.Font = Enum.Font.GothamSemibold
                    name.FontSize = "Size14"
                    name.TextWrapped = true
                    name.Size = UDim2.new(1,0,1,0)
                    name.TextYAlignment = 'Top'
                    name.BackgroundTransparency = 1
                    name.TextStrokeTransparency = 0.5
                    name.TextColor3 = Color3.fromRGB(255, 255, 255)
                    name.Text = (v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' Distance')
                else
                    v.Handle['NameEsp'..Number].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' Distance')
                end
            end
        else
            if v.Handle:FindFirstChild('NameEsp'..Number) then
                v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
            end
        end
    end)
end
end
function UpdateFlowerChams() 
for i,v in pairs(game.Workspace:GetChildren()) do
    pcall(function()
        if v.Name == "Flower2" or v.Name == "Flower1" then
            if FlowerESP then 
                if not v:FindFirstChild('NameEsp'..Number) then
                    local bill = Instance.new('BillboardGui',v)
                    bill.Name = 'NameEsp'..Number
                    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                    bill.Size = UDim2.new(1,200,1,30)
                    bill.Adornee = v
                    bill.AlwaysOnTop = true
                    local name = Instance.new('TextLabel',bill)
                    name.Font = Enum.Font.GothamSemibold
                    name.FontSize = "Size14"
                    name.TextWrapped = true
                    name.Size = UDim2.new(1,0,1,0)
                    name.TextYAlignment = 'Top'
                    name.BackgroundTransparency = 1
                    name.TextStrokeTransparency = 0.5
                    name.TextColor3 = Color3.fromRGB(255, 0, 0)
                    if v.Name == "Flower1" then 
                        name.Text = ("Blue Flower" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                        name.TextColor3 = Color3.fromRGB(0, 0, 255)
                    end
                    if v.Name == "Flower2" then
                        name.Text = ("Red Flower" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                        name.TextColor3 = Color3.fromRGB(255, 0, 0)
                    end
                else
                    v['NameEsp'..Number].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                end
            else
                if v:FindFirstChild('NameEsp'..Number) then
                v:FindFirstChild('NameEsp'..Number):Destroy()
                end
            end
        end   
    end)
end
end
function UpdateRealFruitChams() 
for i,v in pairs(game.Workspace.AppleSpawner:GetChildren()) do
    if v:IsA("Tool") then
        if RealFruitESP then 
            if not v.Handle:FindFirstChild('NameEsp'..Number) then
                local bill = Instance.new('BillboardGui',v.Handle)
                bill.Name = 'NameEsp'..Number
                bill.ExtentsOffset = Vector3.new(0, 1, 0)
                bill.Size = UDim2.new(1,200,1,30)
                bill.Adornee = v.Handle
                bill.AlwaysOnTop = true
                local name = Instance.new('TextLabel',bill)
                name.Font = Enum.Font.GothamSemibold
                name.FontSize = "Size14"
                name.TextWrapped = true
                name.Size = UDim2.new(1,0,1,0)
                name.TextYAlignment = 'Top'
                name.BackgroundTransparency = 1
                name.TextStrokeTransparency = 0.5
                name.TextColor3 = Color3.fromRGB(255, 0, 0)
                name.Text = (v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' Distance')
            else
                v.Handle['NameEsp'..Number].TextLabel.Text = (v.Name ..' '.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' Distance')
            end
        else
            if v.Handle:FindFirstChild('NameEsp'..Number) then
                v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
            end
        end 
    end
end
for i,v in pairs(game.Workspace.PineappleSpawner:GetChildren()) do
    if v:IsA("Tool") then
        if RealFruitESP then 
            if not v.Handle:FindFirstChild('NameEsp'..Number) then
                local bill = Instance.new('BillboardGui',v.Handle)
                bill.Name = 'NameEsp'..Number
                bill.ExtentsOffset = Vector3.new(0, 1, 0)
                bill.Size = UDim2.new(1,200,1,30)
                bill.Adornee = v.Handle
                bill.AlwaysOnTop = true
                local name = Instance.new('TextLabel',bill)
                name.Font = Enum.Font.GothamSemibold
                name.FontSize = "Size14"
                name.TextWrapped = true
                name.Size = UDim2.new(1,0,1,0)
                name.TextYAlignment = 'Top'
                name.BackgroundTransparency = 1
                name.TextStrokeTransparency = 0.5
                name.TextColor3 = Color3.fromRGB(255, 174, 0)
                name.Text = (v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' Distance')
            else
                v.Handle['NameEsp'..Number].TextLabel.Text = (v.Name ..' '.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' Distance')
            end
        else
            if v.Handle:FindFirstChild('NameEsp'..Number) then
                v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
            end
        end 
    end
end
for i,v in pairs(game.Workspace.BananaSpawner:GetChildren()) do
    if v:IsA("Tool") then
        if RealFruitESP then 
            if not v.Handle:FindFirstChild('NameEsp'..Number) then
                local bill = Instance.new('BillboardGui',v.Handle)
                bill.Name = 'NameEsp'..Number
                bill.ExtentsOffset = Vector3.new(0, 1, 0)
                bill.Size = UDim2.new(1,200,1,30)
                bill.Adornee = v.Handle
                bill.AlwaysOnTop = true
                local name = Instance.new('TextLabel',bill)
                name.Font = Enum.Font.GothamSemibold
                name.FontSize = "Size14"
                name.TextWrapped = true
                name.Size = UDim2.new(1,0,1,0)
                name.TextYAlignment = 'Top'
                name.BackgroundTransparency = 1
                name.TextStrokeTransparency = 0.5
                name.TextColor3 = Color3.fromRGB(251, 255, 0)
                name.Text = (v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' Distance')
            else
                v.Handle['NameEsp'..Number].TextLabel.Text = (v.Name ..' '.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' Distance')
            end
        else
            if v.Handle:FindFirstChild('NameEsp'..Number) then
                v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
            end
        end 
    end
end
end

function UpdateIslandESP() 
    for i,v in pairs(game:GetService("Workspace")["_WorldOrigin"].Locations:GetChildren()) do
        pcall(function()
            if IslandESP then 
                if v.Name ~= "Sea" then
                    if not v:FindFirstChild('NameEsp') then
                        local bill = Instance.new('BillboardGui',v)
                        bill.Name = 'NameEsp'
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel',bill)
                        name.Font = "GothamBold"
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(7, 236, 240)
                    else
                        v['NameEsp'].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                    end
                end
            else
                if v:FindFirstChild('NameEsp') then
                    v:FindFirstChild('NameEsp'):Destroy()
                end
            end
        end)
    end
end

function isnil(thing)
return (thing == nil)
end
local function round(n)
return math.floor(tonumber(n) + 0.5)
end
Number = math.random(1, 1000000)
function UpdatePlayerChams()
for i,v in pairs(game:GetService'Players':GetChildren()) do
    pcall(function()
        if not isnil(v.Character) then
            if ESPPlayer then
                if not isnil(v.Character.Head) and not v.Character.Head:FindFirstChild('NameEsp'..Number) then
                    local bill = Instance.new('BillboardGui',v.Character.Head)
                    bill.Name = 'NameEsp'..Number
                    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                    bill.Size = UDim2.new(1,200,1,30)
                    bill.Adornee = v.Character.Head
                    bill.AlwaysOnTop = true
                    local name = Instance.new('TextLabel',bill)
                    name.Font = Enum.Font.GothamSemibold
                    name.FontSize = "Size14"
                    name.TextWrapped = true
                    name.Text = (v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude/3) ..' Distance')
                    name.Size = UDim2.new(1,0,1,0)
                    name.TextYAlignment = 'Top'
                    name.BackgroundTransparency = 1
                    name.TextStrokeTransparency = 0.5
                    if v.Team == game.Players.LocalPlayer.Team then
                        name.TextColor3 = Color3.new(0,255,0)
                    else
                        name.TextColor3 = Color3.new(255,0,0)
                    end
                else
                    v.Character.Head['NameEsp'..Number].TextLabel.Text = (v.Name ..' | '.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude/3) ..' Distance\nHealth : ' .. round(v.Character.Humanoid.Health*100/v.Character.Humanoid.MaxHealth) .. '%')
                end
            else
                if v.Character.Head:FindFirstChild('NameEsp'..Number) then
                    v.Character.Head:FindFirstChild('NameEsp'..Number):Destroy()
                end
            end
        end
    end)
end
end
function UpdateChestChams() 
for i,v in pairs(game.Workspace:GetChildren()) do
    pcall(function()
        if string.find(v.Name,"Chest") then
            if ChestESP then
                if string.find(v.Name,"Chest") then
                    if not v:FindFirstChild('NameEsp'..Number) then
                        local bill = Instance.new('BillboardGui',v)
                        bill.Name = 'NameEsp'..Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel',bill)
                        name.Font = Enum.Font.GothamSemibold
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        if v.Name == "Chest1" then
                            name.TextColor3 = Color3.fromRGB(109, 109, 109)
                            name.Text = ("Chest 1" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                        end
                        if v.Name == "Chest2" then
                            name.TextColor3 = Color3.fromRGB(173, 158, 21)
                            name.Text = ("Chest 2" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                        end
                        if v.Name == "Chest3" then
                            name.TextColor3 = Color3.fromRGB(85, 255, 255)
                            name.Text = ("Chest 3" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                        end
                    else
                        v['NameEsp'..Number].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                    end
                end
            else
                if v:FindFirstChild('NameEsp'..Number) then
                    v:FindFirstChild('NameEsp'..Number):Destroy()
                end
            end
        end
    end)
end
end
function UpdateDevilChams() 
for i,v in pairs(game.Workspace:GetChildren()) do
    pcall(function()
        if DevilFruitESP then
            if string.find(v.Name, "Fruit") then   
                if not v.Handle:FindFirstChild('NameEsp'..Number) then
                    local bill = Instance.new('BillboardGui',v.Handle)
                    bill.Name = 'NameEsp'..Number
                    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                    bill.Size = UDim2.new(1,200,1,30)
                    bill.Adornee = v.Handle
                    bill.AlwaysOnTop = true
                    local name = Instance.new('TextLabel',bill)
                    name.Font = Enum.Font.GothamSemibold
                    name.FontSize = "Size14"
                    name.TextWrapped = true
                    name.Size = UDim2.new(1,0,1,0)
                    name.TextYAlignment = 'Top'
                    name.BackgroundTransparency = 1
                    name.TextStrokeTransparency = 0.5
                    name.TextColor3 = Color3.fromRGB(255, 255, 255)
                    name.Text = (v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' Distance')
                else
                    v.Handle['NameEsp'..Number].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' Distance')
                end
            end
        else
            if v.Handle:FindFirstChild('NameEsp'..Number) then
                v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
            end
        end
    end)
end
end
function UpdateFlowerChams() 
for i,v in pairs(game.Workspace:GetChildren()) do
    pcall(function()
        if v.Name == "Flower2" or v.Name == "Flower1" then
            if FlowerESP then 
                if not v:FindFirstChild('NameEsp'..Number) then
                    local bill = Instance.new('BillboardGui',v)
                    bill.Name = 'NameEsp'..Number
                    bill.ExtentsOffset = Vector3.new(0, 1, 0)
                    bill.Size = UDim2.new(1,200,1,30)
                    bill.Adornee = v
                    bill.AlwaysOnTop = true
                    local name = Instance.new('TextLabel',bill)
                    name.Font = Enum.Font.GothamSemibold
                    name.FontSize = "Size14"
                    name.TextWrapped = true
                    name.Size = UDim2.new(1,0,1,0)
                    name.TextYAlignment = 'Top'
                    name.BackgroundTransparency = 1
                    name.TextStrokeTransparency = 0.5
                    name.TextColor3 = Color3.fromRGB(255, 0, 0)
                    if v.Name == "Flower1" then 
                        name.Text = ("Blue Flower" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                        name.TextColor3 = Color3.fromRGB(0, 0, 255)
                    end
                    if v.Name == "Flower2" then
                        name.Text = ("Red Flower" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                        name.TextColor3 = Color3.fromRGB(255, 0, 0)
                    end
                else
                    v['NameEsp'..Number].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' Distance')
                end
            else
                if v:FindFirstChild('NameEsp'..Number) then
                v:FindFirstChild('NameEsp'..Number):Destroy()
                end
            end
        end   
    end)
end
end
function UpdateRealFruitChams() 
for i,v in pairs(game.Workspace.AppleSpawner:GetChildren()) do
    if v:IsA("Tool") then
        if RealFruitESP then 
            if not v.Handle:FindFirstChild('NameEsp'..Number) then
                local bill = Instance.new('BillboardGui',v.Handle)
                bill.Name = 'NameEsp'..Number
                bill.ExtentsOffset = Vector3.new(0, 1, 0)
                bill.Size = UDim2.new(1,200,1,30)
                bill.Adornee = v.Handle
                bill.AlwaysOnTop = true
                local name = Instance.new('TextLabel',bill)
                name.Font = Enum.Font.GothamSemibold
                name.FontSize = "Size14"
                name.TextWrapped = true
                name.Size = UDim2.new(1,0,1,0)
                name.TextYAlignment = 'Top'
                name.BackgroundTransparency = 1
                name.TextStrokeTransparency = 0.5
                name.TextColor3 = Color3.fromRGB(255, 0, 0)
                name.Text = (v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' Distance')
            else
                v.Handle['NameEsp'..Number].TextLabel.Text = (v.Name ..' '.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' Distance')
            end
        else
            if v.Handle:FindFirstChild('NameEsp'..Number) then
                v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
            end
        end 
    end
end
for i,v in pairs(game.Workspace.PineappleSpawner:GetChildren()) do
    if v:IsA("Tool") then
        if RealFruitESP then 
            if not v.Handle:FindFirstChild('NameEsp'..Number) then
                local bill = Instance.new('BillboardGui',v.Handle)
                bill.Name = 'NameEsp'..Number
                bill.ExtentsOffset = Vector3.new(0, 1, 0)
                bill.Size = UDim2.new(1,200,1,30)
                bill.Adornee = v.Handle
                bill.AlwaysOnTop = true
                local name = Instance.new('TextLabel',bill)
                name.Font = Enum.Font.GothamSemibold
                name.FontSize = "Size14"
                name.TextWrapped = true
                name.Size = UDim2.new(1,0,1,0)
                name.TextYAlignment = 'Top'
                name.BackgroundTransparency = 1
                name.TextStrokeTransparency = 0.5
                name.TextColor3 = Color3.fromRGB(255, 174, 0)
                name.Text = (v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' Distance')
            else
                v.Handle['NameEsp'..Number].TextLabel.Text = (v.Name ..' '.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' Distance')
            end
        else
            if v.Handle:FindFirstChild('NameEsp'..Number) then
                v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
            end
        end 
    end
end
for i,v in pairs(game.Workspace.BananaSpawner:GetChildren()) do
    if v:IsA("Tool") then
        if RealFruitESP then 
            if not v.Handle:FindFirstChild('NameEsp'..Number) then
                local bill = Instance.new('BillboardGui',v.Handle)
                bill.Name = 'NameEsp'..Number
                bill.ExtentsOffset = Vector3.new(0, 1, 0)
                bill.Size = UDim2.new(1,200,1,30)
                bill.Adornee = v.Handle
                bill.AlwaysOnTop = true
                local name = Instance.new('TextLabel',bill)
                name.Font = Enum.Font.GothamSemibold
                name.FontSize = "Size14"
                name.TextWrapped = true
                name.Size = UDim2.new(1,0,1,0)
                name.TextYAlignment = 'Top'
                name.BackgroundTransparency = 1
                name.TextStrokeTransparency = 0.5
                name.TextColor3 = Color3.fromRGB(251, 255, 0)
                name.Text = (v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' Distance')
            else
                v.Handle['NameEsp'..Number].TextLabel.Text = (v.Name ..' '.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' Distance')
            end
        else
            if v.Handle:FindFirstChild('NameEsp'..Number) then
                v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
            end
        end 
    end
end
end

spawn(function()
while wait() do
    pcall(function()
        if MobESP then
            for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                if v:FindFirstChild('HumanoidRootPart') then
                    if not v:FindFirstChild("MobEap") then
                        local BillboardGui = Instance.new("BillboardGui")
                        local TextLabel = Instance.new("TextLabel")

                        BillboardGui.Parent = v
                        BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                        BillboardGui.Active = true
                        BillboardGui.Name = "MobEap"
                        BillboardGui.AlwaysOnTop = true
                        BillboardGui.LightInfluence = 1.000
                        BillboardGui.Size = UDim2.new(0, 200, 0, 50)
                        BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)

                        TextLabel.Parent = BillboardGui
                        TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        TextLabel.BackgroundTransparency = 1.000
                        TextLabel.Size = UDim2.new(0, 200, 0, 50)
                        TextLabel.Font = Enum.Font.GothamBold
                        TextLabel.TextColor3 = Color3.fromRGB(7, 236, 240)
                        TextLabel.Text.Size = 35
                    end
                    local Dis = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude)
                    v.MobEap.TextLabel.Text = v.Name.." - "..Dis.." Distance"
                end
            end
        else
            for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                if v:FindFirstChild("MobEap") then
                    v.MobEap:Destroy()
                end
            end
        end
    end)
end
end)

spawn(function()
while wait() do
    pcall(function()
        if SeaESP then
            for i,v in pairs(game:GetService("Workspace").SeaBeasts:GetChildren()) do
                if v:FindFirstChild('HumanoidRootPart') then
                    if not v:FindFirstChild("Seaesps") then
                        local BillboardGui = Instance.new("BillboardGui")
                        local TextLabel = Instance.new("TextLabel")

                        BillboardGui.Parent = v
                        BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                        BillboardGui.Active = true
                        BillboardGui.Name = "Seaesps"
                        BillboardGui.AlwaysOnTop = true
                        BillboardGui.LightInfluence = 1.000
                        BillboardGui.Size = UDim2.new(0, 200, 0, 50)
                        BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)

                        TextLabel.Parent = BillboardGui
                        TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        TextLabel.BackgroundTransparency = 1.000
                        TextLabel.Size = UDim2.new(0, 200, 0, 50)
                        TextLabel.Font = Enum.Font.GothamBold
                        TextLabel.TextColor3 = Color3.fromRGB(7, 236, 240)
                        TextLabel.Text.Size = 35
                    end
                    local Dis = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude)
                    v.Seaesps.TextLabel.Text = v.Name.." - "..Dis.." Distance"
                end
            end
        else
            for i,v in pairs (game:GetService("Workspace").SeaBeasts:GetChildren()) do
                if v:FindFirstChild("Seaesps") then
                    v.Seaesps:Destroy()
                end
            end
        end
    end)
end
end)

spawn(function()
while wait() do
    pcall(function()
        if NpcESP then
            for i,v in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
                if v:FindFirstChild('HumanoidRootPart') then
                    if not v:FindFirstChild("NpcEspes") then
                        local BillboardGui = Instance.new("BillboardGui")
                        local TextLabel = Instance.new("TextLabel")

                        BillboardGui.Parent = v
                        BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                        BillboardGui.Active = true
                        BillboardGui.Name = "NpcEspes"
                        BillboardGui.AlwaysOnTop = true
                        BillboardGui.LightInfluence = 1.000
                        BillboardGui.Size = UDim2.new(0, 200, 0, 50)
                        BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)

                        TextLabel.Parent = BillboardGui
                        TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        TextLabel.BackgroundTransparency = 1.000
                        TextLabel.Size = UDim2.new(0, 200, 0, 50)
                        TextLabel.Font = Enum.Font.GothamBold
                        TextLabel.TextColor3 = Color3.fromRGB(7, 236, 240)
                        TextLabel.Text.Size = 35
                    end
                    local Dis = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude)
                    v.NpcEspes.TextLabel.Text = v.Name.." - "..Dis.." Distance"
                end
            end
        else
            for i,v in pairs (game:GetService("Workspace").NPCs:GetChildren()) do
                if v:FindFirstChild("NpcEspes") then
                    v.NpcEspes:Destroy()
                end
            end
        end
    end)
end
end)


function InfAb()
    if InfAbility then
        if not game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility") then
            local inf = Instance.new("ParticleEmitter")
            inf.Acceleration = Vector3.new(0,0,0)
            inf.Archivable = true
            inf.Drag = 20
            inf.EmissionDirection = Enum.NormalId.Top
            inf.Enabled = true
            inf.Lifetime = NumberRange.new(0,0)
            inf.LightInfluence = 0
            inf.LockedToPart = true
            inf.Name = "Agility"
            inf.Rate = 500
            local numberKeypoints2 = {
                NumberSequenceKeypoint.new(0, 0);
                NumberSequenceKeypoint.new(1, 4); 
            }
            inf.Size = NumberSequence.new(numberKeypoints2)
            inf.RotSpeed = NumberRange.new(9999, 99999)
            inf.Rotation = NumberRange.new(0, 0)
            inf.Speed = NumberRange.new(30, 30)
            inf.SpreadAngle = Vector2.new(0,0,0,0)
            inf.Texture = ""
            inf.VelocityInheritance = 0
            inf.ZOffset = 2
            inf.Transparency = NumberSequence.new(0)
            inf.Color = ColorSequence.new(Color3.fromRGB(0,0,0),Color3.fromRGB(0,0,0))
            inf.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
        end
    else
        if game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility") then
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility"):Destroy()
        end
    end
end

local LocalPlayer = game:GetService'Players'.LocalPlayer
local originalstam = LocalPlayer.Character.Energy.Value
function infinitestam()
    LocalPlayer.Character.Energy.Changed:connect(function()
        if InfiniteEnergy then
            LocalPlayer.Character.Energy.Value = originalstam
        end 
    end)
end

spawn(function()
    pcall(function()
        while wait(.1) do
            if InfiniteEnergy then
                wait(0.1)
                originalstam = LocalPlayer.Character.Energy.Value
                infinitestam()
            end
        end
    end)
end)

function NoDodgeCool()
    if nododgecool then
        for i,v in next, getgc() do
            if game:GetService("Players").LocalPlayer.Character.Dodge then
                if typeof(v) == "function" and getfenv(v).script == game:GetService("Players").LocalPlayer.Character.Dodge then
                    for i2,v2 in next, getupvalues(v) do
                        if tostring(v2) == "0.1" then
                        repeat wait(.1)
                            setupvalue(v,i2,0)
                        until not nododgecool
                        end
                    end
                end
            end
        end
    end
end

function fly()
    local mouse=game:GetService("Players").LocalPlayer:GetMouse''
    localplayer=game:GetService("Players").LocalPlayer
    game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    local torso = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
    local speedSET=25
    local keys={a=false,d=false,w=false,s=false}
    local e1
    local e2
    local function start()
        local pos = Instance.new("BodyPosition",torso)
        local gyro = Instance.new("BodyGyro",torso)
        pos.Name="EPIXPOS"
        pos.maxForce = Vector3.new(math.huge, math.huge, math.huge)
        pos.position = torso.Position
        gyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        gyro.CFrame = torso.CFrame
        repeat
                wait()
                localplayer.Character.Humanoid.PlatformStand=true
                local new=gyro.CFrame - gyro.CFrame.p + pos.position
                if not keys.w and not keys.s and not keys.a and not keys.d then
                speed=1
                end
                if keys.w then
                new = new + workspace.CurrentCamera.CoordinateFrame.lookVector * speed
                speed=speed+speedSET
                end
                if keys.s then
                new = new - workspace.CurrentCamera.CoordinateFrame.lookVector * speed
                speed=speed+speedSET
                end
                if keys.d then
                new = new * CFrame.new(speed,0,0)
                speed=speed+speedSET
                end
                if keys.a then
                new = new * CFrame.new(-speed,0,0)
                speed=speed+speedSET
                end
                if speed>speedSET then
                speed=speedSET
                end
                pos.position=new.p
                if keys.w then
                gyro.CFrame = workspace.CurrentCamera.CoordinateFrame*CFrame.Angles(-math.rad(speed*15),0,0)
                elseif keys.s then
                gyro.CFrame = workspace.CurrentCamera.CoordinateFrame*CFrame.Angles(math.rad(speed*15),0,0)
                else
                gyro.CFrame = workspace.CurrentCamera.CoordinateFrame
                end
        until not Fly
        if gyro then 
                gyro:Destroy() 
        end
        if pos then 
                pos:Destroy() 
        end
        flying=false
        localplayer.Character.Humanoid.PlatformStand=false
        speed=0
    end
    e1=mouse.KeyDown:connect(function(key)
        if not torso or not torso.Parent then 
                flying=false e1:disconnect() e2:disconnect() return 
        end
        if key=="w" then
            keys.w=true
        elseif key=="s" then
            keys.s=true
        elseif key=="a" then
            keys.a=true
        elseif key=="d" then
            keys.d=true
        end
    end)
    e2=mouse.KeyUp:connect(function(key)
        if key=="w" then
            keys.w=false
        elseif key=="s" then
            keys.s=false
        elseif key=="a" then
            keys.a=false
        elseif key=="d" then
            keys.d=false
        end
    end)
    start()
end

function Click()
    game:GetService'VirtualUser':CaptureController()
    game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
end

function AutoHaki()
    if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HasBuso") then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
    end
end

function UnEquipWeapon(Weapon)
    if game.Players.LocalPlayer.Character:FindFirstChild(Weapon) then
        _G.NotAutoEquip = true
        wait(.5)
        game.Players.LocalPlayer.Character:FindFirstChild(Weapon).Parent = game.Players.LocalPlayer.Backpack
        wait(.1)
        _G.NotAutoEquip = false
    end
end

function EquipWeapon(ToolSe)
    if not _G.NotAutoEquip then
        if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe) then
            Tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
            wait(.1)
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(Tool)
        end
    end
end

spawn(function()
while wait() do
    for i,v in pairs(game:GetService("Workspace")["_WorldOrigin"]:GetChildren()) do
        pcall(function()
            if v.Name == ("CurvedRing") or v.Name == ("SlashHit") or v.Name == ("SwordSlash") or v.Name == ("SlashTail") or v.Name == ("Sounds") then
                v:Destroy()
            end
        end)
    end
end
end)

function GetDistance(target)
    return math.floor((target.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
end

function BTP(P)
repeat wait(1)
    game.Players.LocalPlayer.Character.Humanoid:ChangeState(15)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = P
    task.wait()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = P
until (P.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 1500
end

function TelePPlayer(P)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = P
end

function TP(Pos)
Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
if Distance < 25 then
    Speed = 10000
elseif Distance < 50 then
    Speed = 2000
elseif Distance < 150 then
    Speed = 800
elseif Distance < 250 then
    Speed = 600
elseif Distance < 500 then
    Speed = 400
elseif Distance < 750 then
    Speed = 250
elseif Distance >= 1000 then
    Speed = 200
end
game:GetService("TweenService"):Create(
    game.Players.LocalPlayer.Character.HumanoidRootPart,
    TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
    {CFrame = Pos}
):Play()
end

function TP1(Pos)
    Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if Distance < 25 then
        Speed = 5000
    elseif Distance < 50 then
        Speed = 2000
    elseif Distance < 150 then
        Speed = 800
    elseif Distance < 250 then
        Speed = 600
    elseif Distance < 500 then
        Speed = 300
    elseif Distance < 750 then
        Speed = 250
    elseif Distance >= 1000 then
        Speed = 200
    end
    game:GetService("TweenService"):Create(
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart,
        TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
        {CFrame = Pos}
    ):Play()
end

function topos(Pos)
    Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if Distance < 25 then
        Speed = 5000
    elseif Distance < 50 then
        Speed = 2000
    elseif Distance < 150 then
        Speed = 800
    elseif Distance < 250 then
        Speed = 600
    elseif Distance < 500 then
        Speed = 300
    elseif Distance < 750 then
        Speed = 250
    elseif Distance >= 1000 then
        Speed = 200
    end
    game:GetService("TweenService"):Create(
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart,
        TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
        {CFrame = Pos}
    ):Play()
end

function BTP(P1)
game.Players.LocalPlayer.Character.Head:Destroy()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = P1
wait(1)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = P1
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
end

getgenv().ToTargets = function(p)
task.spawn(function()
    pcall(function()
        if game:GetService("Players").LocalPlayer:DistanceFromCharacter(p.Position) <= 250 then 
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = p
        elseif not game.Players.LocalPlayer.Character:FindFirstChild("Root")then 
            local K = Instance.new("Part",game.Players.LocalPlayer.Character)
            K.Size = Vector3.new(1,0.5,1)
            K.Name = "Root"
            K.Anchored = true
            K.Transparency = 1
            K.CanCollide = false
            K.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,20,0)
        end
        local U = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-p.Position).Magnitude
        local z = game:service("TweenService")
        local B = TweenInfo.new((p.Position-game.Players.LocalPlayer.Character.Root.Position).Magnitude/300,Enum.EasingStyle.Linear)
        local S,g = pcall(function()
        local q = z:Create(game.Players.LocalPlayer.Character.Root,B,{CFrame = p})
        q:Play()
    end)
    if not S then 
        return g
    end
    game.Players.LocalPlayer.Character.Root.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        if S and game.Players.LocalPlayer.Character:FindFirstChild("Root") then 
            pcall(function()
                if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-p.Position).Magnitude >= 20 then 
                    spawn(function()
                        pcall(function()
                            if (game.Players.LocalPlayer.Character.Root.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 150 then 
                                game.Players.LocalPlayer.Character.Root.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                            else 
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=game.Players.LocalPlayer.Character.Root.CFrame
                            end
                        end)
                    end)
                elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-p.Position).Magnitude >= 10 and(game.Players.LocalPlayer.Character.HumanoidRootPart.Position-p.Position).Magnitude < 20 then 
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p
                elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-p.Position).Magnitude < 10 then 
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p
                end
            end)
        end
    end)
end)
end


spawn(function()
game:GetService("RunService").Heartbeat:Connect(function()
    if _G.AutoAdvanceDungeon or _G.AutoDoughtBoss or _G.Auto_DungeonMobAura or _G.AutoFarmChest or _G.AutoFactory or _G.AutoFarmBossHallow or _G.AutoFarmSwanGlasses or _G.AutoLongSword or _G.AutoBlackSpikeycoat or _G.AutoElectricClaw or _G.AutoFarmGunMastery or _G.AutoHolyTorch or _G.AutoLawRaid or _G.AutoFarmBoss or _G.Auto_Quest_Boss or _G.AutoTwinHooks or _G.AutoOpenSwanDoor or _G.AutoDragon_Trident or _G.AutoSaber or _G.NOCLIP or _G.AutoFarmFruitMastery or _G.AutoFarmGunMastery or _G.TeleportIsland or _G.Auto_EvoRace or _G.AutoFarmAllMsBypassType or _G.AutoObservationv2 or _G.AutoMusketeerHat or _G.AutoEctoplasm or _G.AutoRengoku or _G.Auto_Rainbow_Haki or _G.AutoObservation or _G.AutoDarkDagger or _G.Safe_Mode or _G.MasteryFruit or _G.AutoBudySword or _G.AutoOderSword or _G.AutoBounty or _G.AutoAllBoss or _G.Auto_Bounty or _G.AutoSharkman or _G.Auto_Mastery_Fruit or _G.Auto_Mastery_Gun or _G.Auto_Dungeon or _G.Auto_Cavender or _G.Auto_Pole or _G.Auto_Kill_Ply or _G.Auto_Factory or _G.AutoSecondSea or _G.TeleportPly or _G.AutoBartilo or _G.Auto_DarkBoss or _G.GrabChest or _G.AutoFarmBounty or _G.Holy_Torch or _G.AutoFarm or _G.Clip or _G.AutoElitehunter or _G.AutoThirdSea or _G.Auto_Bone or _G.Autoheart or _G.Autodoughking or _G.AutoFarmMaterial or _G.AutoNevaSoulGuitar or _G.Auto_Dragon_Trident or _G.Autotushita or _G.d or _G.Autowaden or _G.Autogay or _G.Autopole or _G.Autosaw or _G.AutoObservationHakiV2 or _G.AutoFarmNearest or AutoFarmChest or _G.AutoCarvender or _G.AutoTwinHook or AutoMobAura or _G.Tweenfruit or _G.AutoKai or _G.TeleportNPC or _G.Leather or _G.Auto_Wing or _G.Umm or _G.Makori_gay or Radioactive or Fish or Gunpowder or Dragon_Scale or Cocoafarm or Scrap or MiniHee or _G.AutoFarmSeabaest or Auto_Cursed_Dual_Katana or _G.AutoFarmMob or _G.AutoMysticIsland or _G.AutoFarmDungeon or _G.AutoRaidPirate or _G.AutoQuestRace or _G.TweenMGear or getgenv().AutoFarm or _G.AutoPlayerHunter or _G.AutoFactory or Grab_Chest then
        if not game:GetService("Workspace"):FindFirstChild("LOL") then
            local LOL = Instance.new("Part")
            LOL.Name = "LOL"
            LOL.Parent = game.Workspace
            LOL.Anchored = true
            LOL.Transparency = 1
            LOL.Size = Vector3.new(30,-0.5,30)
        elseif game:GetService("Workspace"):FindFirstChild("LOL") then
            game.Workspace["LOL"].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -3.6, 0)
        end
    else
        if game:GetService("Workspace"):FindFirstChild("LOL") then
            game:GetService("Workspace"):FindFirstChild("LOL"):Destroy()
        end
    end
end)
end)

spawn(function()
    pcall(function()
        while wait() do
            if _G.AutoAdvanceDungeon or _G.AutoDoughtBoss or _G.Auto_DungeonMobAura or _G.AutoFarmChest or _G.AutoFactory or _G.AutoFarmBossHallow or _G.AutoFarmSwanGlasses or _G.AutoLongSword or _G.AutoBlackSpikeycoat or _G.AutoElectricClaw or _G.AutoFarmGunMastery or _G.AutoHolyTorch or _G.AutoLawRaid or _G.AutoFarmBoss or _G.Auto_Quest_Boss or _G.AutoTwinHooks or _G.AutoOpenSwanDoor or _G.AutoDragon_Trident or _G.AutoSaber or _G.AutoFarmFruitMastery or _G.AutoFarmGunMastery or _G.TeleportIsland or _G.Auto_EvoRace or _G.AutoFarmAllMsBypassType or _G.AutoObservationv2 or _G.AutoMusketeerHat or _G.AutoEctoplasm or _G.AutoRengoku or _G.Auto_Rainbow_Haki or _G.AutoObservation or _G.AutoDarkDagger or _G.Safe_Mode or _G.MasteryFruit or _G.AutoBudySword or _G.AutoOderSword or _G.AutoBounty or _G.AutoAllBoss or _G.Auto_Bounty or _G.AutoSharkman or _G.Auto_Mastery_Fruit or _G.Auto_Mastery_Gun or _G.Auto_Dungeon or _G.Auto_Cavender or _G.Auto_Pole or _G.Auto_Kill_Ply or _G.Auto_Factory or _G.AutoSecondSea or _G.TeleportPly or _G.AutoBartilo or _G.Auto_DarkBoss or _G.GrabChest or _G.AutoFarmBounty or _G.Holy_Torch or _G.AutoFarm or _G.Clip or FarmBoss or _G.AutoElitehunter or _G.AutoThirdSea or _G.Auto_Bone or _G.Autoheart or _G.Autodoughking or _G.AutoFarmMaterial or _G.AutoNevaSoulGuitar or _G.Auto_Dragon_Trident or _G.Autotushita or _G.d or _G.Autowaden or _G.Autogay or _G.Autopole or _G.Autosaw or _G.AutoObservationHakiV2 or _G.AutoFarmNearest or AutoFarmChest or _G.AutoCarvender or _G.AutoTwinHook or AutoMobAura or _G.Tweenfruit or _G.TeleportNPC or _G.Leather or _G.Auto_Wing or _G.Umm or _G.Makori_gay or Radioactive or Fish or Gunpowder or Dragon_Scale or Cocoafarm or Scrap or MiniHee or _G.AutoFarmSeabaest or Auto_Cursed_Dual_Katana or _G.AutoFarmMob or _G.AutoMysticIsland or _G.AutoFarmDungeon or _G.AutoRaidPirate or _G.AutoQuestRace or _G.TweenMGear or getgenv().AutoFarm or _G.AutoPlayerHunter or _G.AutoFactory or Grab_Chest == true then
                if not game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                    local Noclip = Instance.new("BodyVelocity")
                    Noclip.Name = "BodyClip"
                    Noclip.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
                    Noclip.MaxForce = Vector3.new(100000,100000,100000)
                    Noclip.Velocity = Vector3.new(0,0,0)
                end
            end
        end
    end)
end)

spawn(function()
    pcall(function()
        game:GetService("RunService").Stepped:Connect(function()
            if _G.AutoAdvanceDungeon or _G.AutoDoughtBoss or _G.Auto_DungeonMobAura or _G.AutoFarmChest or _G.AutoFactory or _G.AutoFarmBossHallow or _G.AutoFarmSwanGlasses or _G.AutoLongSword or _G.AutoBlackSpikeycoat or _G.AutoElectricClaw or _G.AutoFarmGunMastery or _G.AutoHolyTorch or _G.AutoLawRaid or _G.AutoFarmBoss or _G.Auto_Quest_Boss or _G.AutoTwinHooks or _G.AutoOpenSwanDoor or _G.AutoDragon_Trident or _G.AutoSaber or _G.NOCLIP or _G.AutoFarmFruitMastery or _G.AutoFarmGunMastery or _G.TeleportIsland or _G.Auto_EvoRace or _G.AutoFarmAllMsBypassType or _G.AutoObservationv2 or _G.AutoMusketeerHat or _G.AutoEctoplasm or _G.AutoRengoku or _G.Auto_Rainbow_Haki or _G.AutoObservation or _G.AutoDarkDagger or _G.Safe_Mode or _G.MasteryFruit or _G.AutoBudySword or _G.AutoOderSword or _G.AutoBounty or _G.AutoAllBoss or _G.Auto_Bounty or _G.AutoSharkman or _G.Auto_Mastery_Fruit or _G.Auto_Mastery_Gun or _G.Auto_Dungeon or _G.Auto_Cavender or _G.Auto_Pole or _G.Auto_Kill_Ply or _G.Auto_Factory or _G.AutoSecondSea or _G.TeleportPly or _G.AutoBartilo or _G.Auto_DarkBoss or _G.GrabChest or _G.AutoFarmBounty or _G.Holy_Torch or _G.AutoFarm or _G.Clip or _G.AutoElitehunter or _G.AutoThirdSea or _G.Auto_Bone or _G.Autoheart or _G.Autodoughking or _G.AutoFarmMaterial or _G.AutoNevaSoulGuitar or _G.Auto_Dragon_Trident or _G.Autotushita or _G.Autowaden or _G.Autogay or _G.Autopole or _G.Autosaw or _G.AutoObservationHakiV2 or _G.AutoFarmNearest or AutoFarmChest or _G.AutoCarvender or _G.AutoTwinHook or AutoMobAura or _G.Tweenfruit or _G.TeleportNPC or _G.AutoKai or _G.Leather or _G.Auto_Wing or _G.Umm or _G.Makori_gay or Radioactive or Fish or Gunpowder or Dragon_Scale or Cocoafarm or Scrap or MiniHee or _G.AutoFarmSeabaest or Auto_Cursed_Dual_Katana or _G.AutoFarmMob or _G.AutoMysticIsland or _G.AutoFarmDungeon or _G.AutoRaidPirate or _G.AutoQuestRace or _G.TweenMGear or getgenv().AutoFarm or _G.AutoPlayerHunter or _G.AutoFactory or Grab_Chest == true then
                for _, v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false    
                    end
                end
            end
        end)
    end)
end)

spawn(function()
    while wait() do
        if _G.AutoDoughtBoss or _G.Auto_DungeonMobAura or _G.AutoFarmChest or _G.AutoFarmBossHallow or _G.AutoFactory or _G.AutoFarmSwanGlasses or _G.AutoLongSword or _G.AutoBlackSpikeycoat or _G.AutoElectricClaw or _G.AutoFarmGunMastery or _G.AutoHolyTorch or _G.AutoLawRaid or _G.AutoFarmBoss or _G.Auto_Quest_Boss or _G.AutoTwinHooks or _G.AutoOpenSwanDoor or _G.AutoDragon_Trident or _G.AutoSaber or _G.NOCLIP or _G.AutoFarmFruitMastery or _G.AutoFarmGunMastery or _G.TeleportIsland or _G.Auto_EvoRace or _G.AutoFarmAllMsBypassType or _G.AutoObservationv2 or _G.AutoMusketeerHat or _G.AutoEctoplasm or _G.AutoRengoku or _G.Auto_Rainbow_Haki or _G.AutoObservation or _G.AutoDarkDagger or _G.Safe_Mode or _G.MasteryFruit or _G.AutoBudySword or _G.AutoOderSword or _G.AutoAllBoss or _G.Auto_Bounty or _G.AutoSharkman or _G.Auto_Mastery_Fruit or _G.Auto_Mastery_Gun or _G.Auto_Dungeon or _G.Auto_Cavender or _G.Auto_Pole or _G.Auto_Kill_Ply or _G.Auto_Factory or _G.AutoSecondSea or _G.TeleportPly or _G.AutoBartilo or _G.Auto_DarkBoss or _G.AutoFarm or _G.Clip or _G.AutoElitehunter or _G.AutoThirdSea or _G.Auto_Bone or _G.Autoheart or _G.Autodoughking or _G.d or _G.Autowaden or _G.Autogay or _G.AutoObservationHakiV2 or _G.AutoFarmMaterial or _G.AutoFarmNearest or _G.AutoCarvender or _G.AutoTwinHook or AutoMobAura or _G.Leather or _G.Auto_Wing or _G.Umm or _G.Makori_gay or Radioactive or Fish or Gunpowder or Dragon_Scale or Cocoafarm or Scrap or MiniHee or _G.AutoFarmSeabaest or Auto_Cursed_Dual_Katana or _G.AutoFarmMob or _G.AutoRaidPirate or getgenv().AutoFarm or _G.AutoPlayerHunter or _G.AutoFactory == true then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("Ken",true)
            end)
        end    
    end
end)

spawn(function()
game:GetService("RunService").RenderStepped:Connect(function()
    if _G.AutoClick or Fastattack then
         pcall(function()
            game:GetService'VirtualUser':CaptureController()
            game:GetService'VirtualUser':Button1Down(Vector2.new(0,1,0,1))
        end)
    end
end)
end)

function StopTween(target)
    if not target then
        _G.StopTween = true
        wait()
        topos(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
        wait()
        if game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy()
        end
        _G.StopTween = false
        _G.Clip = false
    end
end

spawn(function()
    pcall(function()
        while wait() do
            for i,v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do  
                if v:IsA("Tool") then
                    if v:FindFirstChild("RemoteFunctionShoot") then 
                        SelectWeaponGun = v.Name
                    end
                end
            end
        end
    end)
end)

game:GetService("Players").LocalPlayer.Idled:connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)
----Bring Mob
spawn(function()
    while task.wait() do
        pcall(function()
            if _G.BringMonster then
                CheckQuest()
                for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if _G.AutoFarm and StartMagnet and v.Name == Mon and (Mon == "Factory Staff [Lv. 800]" or Mon == "Monkey [Lv. 14]" or Mon == "Dragon Crew Warrior [Lv. 1575]" or Mon == "Dragon Crew Archer [Lv. 1600]") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 250 then
                        v.HumanoidRootPart.Size = Vector3.new(150,150,150)
                        v.HumanoidRootPart.CFrame = PosMon
                        v.Humanoid:ChangeState(14)
                        v.HumanoidRootPart.CanCollide = false
                        v.Head.CanCollide = false
                        if v.Humanoid:FindFirstChild("Animator") then
                            v.Humanoid.Animator:Destroy()
                        end
                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                    elseif _G.AutoFarm and StartMagnet and v.Name == Mon and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= _G.BringMode then
                        v.HumanoidRootPart.Size = Vector3.new(150,150,150)
                        v.HumanoidRootPart.CFrame = PosMon
                        v.Humanoid:ChangeState(14)
                        v.HumanoidRootPart.CanCollide = false
                        v.Head.CanCollide = false
                        if v.Humanoid:FindFirstChild("Animator") then
                            v.Humanoid.Animator:Destroy()
                        end
                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                    end
                    if _G.AutoEctoplasm and StartEctoplasmMagnet then
                        if string.find(v.Name, "Ship") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position - EctoplasmMon.Position).Magnitude <= _G.BringMode then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.HumanoidRootPart.CFrame = EctoplasmMon
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AutoRengoku and StartRengokuMagnet then
                        if (v.Name == "Snow Lurker [Lv. 1375]" or v.Name == "Arctic Warrior [Lv. 1350]") and (v.HumanoidRootPart.Position - RengokuMon.Position).Magnitude <= _G.BringMode and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(1500,1500,1500)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = RengokuMon
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AutoMusketeerHat and StartMagnetMusketeerhat then
                        if v.Name == "Forest Pirate [Lv. 1825]" and (v.HumanoidRootPart.Position - MusketeerHatMon.Position).Magnitude <= _G.BringMode and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = MusketeerHatMon
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AutoObservationHakiV2 and Mangnetcitzenmon then
                        if v.Name == "Forest Pirate [Lv. 1825]" and (v.HumanoidRootPart.Position - MusketeerHatMon.Position).Magnitude <= _G.BringMode and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosHee
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.Auto_EvoRace and StartEvoMagnet then
                        if v.Name == "Zombie [Lv. 950]" and (v.HumanoidRootPart.Position - PosMonEvo.Position).Magnitude <= _G.BringMode and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosMonEvo
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AutoBartilo and AutoBartiloBring then
                        if v.Name == "Swan Pirate [Lv. 775]" and (v.HumanoidRootPart.Position - PosMonBarto.Position).Magnitude <= _G.BringMode and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosMonBarto
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AutoFarmFruitMastery and StartMasteryFruitMagnet then
                        if v.Name == "Monkey [Lv. 14]" then
                            if (v.HumanoidRootPart.Position - PosMonMasteryFruit.Position).Magnitude <= _G.BringMode and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                v.Humanoid:ChangeState(14)
                                v.HumanoidRootPart.CanCollide = false
                                v.Head.CanCollide = false
                                v.HumanoidRootPart.CFrame = PosMonMasteryFruit
                                if v.Humanoid:FindFirstChild("Animator") then
                                    v.Humanoid.Animator:Destroy()
                                end
                                sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                            end
                        elseif v.Name == "Factory Staff [Lv. 800]" then
                            if (v.HumanoidRootPart.Position - PosMonMasteryFruit.Position).Magnitude <= _G.BringMode and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                v.Humanoid:ChangeState(14)
                                v.HumanoidRootPart.CanCollide = false
                                v.Head.CanCollide = false
                                v.HumanoidRootPart.CFrame = PosMonMasteryFruit
                                if v.Humanoid:FindFirstChild("Animator") then
                                    v.Humanoid.Animator:Destroy()
                                end
                                sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                            end
                        elseif v.Name == Mon then
                            if (v.HumanoidRootPart.Position - PosMonMasteryFruit.Position).Magnitude <= _G.BringMode and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                v.Humanoid:ChangeState(14)
                                v.HumanoidRootPart.CanCollide = false
                                v.Head.CanCollide = false
                                v.HumanoidRootPart.CFrame = PosMonMasteryFruit
                                if v.Humanoid:FindFirstChild("Animator") then
                                    v.Humanoid.Animator:Destroy()
                                end
                                sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                            end
                        end
                    end
                    if _G.AutoFarmGunMastery and StartMasteryGunMagnet then
                        if v.Name == "Monkey [Lv. 14]" then
                            if (v.HumanoidRootPart.Position - PosMonMasteryGun.Position).Magnitude <= _G.BringMode and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                v.Humanoid:ChangeState(14)
                                v.HumanoidRootPart.CanCollide = false
                                v.Head.CanCollide = false
                                v.HumanoidRootPart.CFrame = PosMonMasteryGun
                                if v.Humanoid:FindFirstChild("Animator") then
                                    v.Humanoid.Animator:Destroy()
                                end
                                sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                            end
                        elseif v.Name == "Factory Staff [Lv. 800]" then
                            if (v.HumanoidRootPart.Position - PosMonMasteryGun.Position).Magnitude <= _G.BringMode and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                v.Humanoid:ChangeState(14)
                                v.HumanoidRootPart.CanCollide = false
                                v.Head.CanCollide = false
                                v.HumanoidRootPart.CFrame = PosMonMasteryGun
                                if v.Humanoid:FindFirstChild("Animator") then
                                    v.Humanoid.Animator:Destroy()
                                end
                                sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                            end
                        elseif v.Name == Mon then
                            if (v.HumanoidRootPart.Position - PosMonMasteryGun.Position).Magnitude <= _G.BringMode and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                v.Humanoid:ChangeState(14)
                                v.HumanoidRootPart.CanCollide = false
                                v.Head.CanCollide = false
                                v.HumanoidRootPart.CFrame = PosMonMasteryGun
                                if v.Humanoid:FindFirstChild("Animator") then
                                    v.Humanoid.Animator:Destroy()
                                end
                                sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                            end
                        end
                    end
                    if _G.Auto_Bone and StartMagnetBoneMon then
                        if (v.Name == "Reborn Skeleton [Lv. 1975]" or v.Name == "Living Zombie [Lv. 2000]" or v.Name == "Demonic Soul [Lv. 2025]" or v.Name == "Posessed Mummy [Lv. 2050]") and (v.HumanoidRootPart.Position - PosMonBone.Position).Magnitude <= _G.BringMode and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosMonBone
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AutoFarmCandy and StartCandyMagnet then
                        if (v.Name == "Ice Cream Chef [Lv. 2125]" or v.Name == "Ice Cream Commander [Lv. 2150]") and (v.HumanoidRootPart.Position - CandyMon.Position).Magnitude <= _G.BringMode and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = CandyMon
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AutoDoughtBoss and MagnetDought then
                        if (v.Name == "Cookie Crafter [Lv. 2200]" or v.Name == "Cake Guard [Lv. 2225]" or v.Name == "Baking Staff [Lv. 2250]" or v.Name == "Head Baker [Lv. 2275]") and (v.HumanoidRootPart.Position - PosMonDoughtOpenDoor.Position).Magnitude <= _G.BringMode and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosMonDoughtOpenDoor
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                end
            end
        end)
  end
end)

task.spawn(function()
while true do wait()
    if setscriptable then
        setscriptable(game.Players.LocalPlayer, "SimulationRadius", true)
    end
    if sethiddenproperty then
        sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
    end
end
end)

--BringMobNearrest

function InMyNetWork(object)
if isnetworkowner then
    return isnetworkowner(object)
else
    if (object.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= _G.BringMode then 
        return true
    end
    return false
end
end

task.spawn(function()
while task.wait() do
    pcall(function()
        if MakoriGayMag and _G.BringMonster then
            for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
                if not string.find(v.Name,"Boss") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= _G.BringMode then
                    if InMyNetWork(v.HumanoidRootPart) then
                        v.HumanoidRootPart.CFrame = PosGay
                        v.Humanoid.JumpPower = 0
                        v.Humanoid.WalkSpeed = 0
                        v.HumanoidRootPart.Size = Vector3.new(60,60,60)
                        v.HumanoidRootPart.Transparency = 1
                        v.HumanoidRootPart.CanCollide = false
                        v.Head.CanCollide = false
                        if v.Humanoid:FindFirstChild("Animator") then
                            v.Humanoid.Animator:Destroy()
                        end
                        v.Humanoid:ChangeState(11)
                        v.Humanoid:ChangeState(14)
                    end
                end
            end
        end
    end)
end
end)


function InMyNetWork(object)
if isnetworkowner then
    return isnetworkowner(object)
else
    if (object.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= _G.BringMode then 
        return true
    end
    return false
end
end

task.spawn(function()
while task.wait() do
    pcall(function()
        if _G.AutoFarmNearest and AutoFarmNearestMagnet or SelectMag and _G.BringMonster then
            for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
                if not string.find(v.Name,"Boss") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= _G.BringMode then
                    if InMyNetWork(v.HumanoidRootPart) then
                        v.HumanoidRootPart.CFrame = PosMon
                        v.Humanoid.JumpPower = 0
                        v.Humanoid.WalkSpeed = 0
                        v.HumanoidRootPart.Size = Vector3.new(60,60,60)
                        v.HumanoidRootPart.Transparency = 1
                        v.HumanoidRootPart.CanCollide = false
                        v.Head.CanCollide = false
                        if v.Humanoid:FindFirstChild("Animator") then
                            v.Humanoid.Animator:Destroy()
                        end
                        v.Humanoid:ChangeState(11)
                        v.Humanoid:ChangeState(14)
                    end
                end
            end
        end
    end)
end
end)


---------------------

local win = DiscordLib:Window("Blox Fruits", _G.Color, _G.Toggle)

local serv = win:Server("GBao Hub","rbxassetid://14176817863")

local Main = serv:Channel("Main")
local Setting = serv:Channel("Setting")
local Items = serv:Channel("Automatics")
local R = serv:Channel("Race V4")
local Stats = serv:Channel("Stats")
local Pvp = serv:Channel("Combat")
local Island = serv:Channel("Teleport")
local Raid = serv:Channel("Raid")
local Fruit = serv:Channel("Fruit + ESP")
local S = serv:Channel("Shop")
local Misc = serv:Channel("Miscellaneous")

Time = Main:Label("Server Time")

function UpdateTime()
    local GameTime = math.floor(workspace.DistributedGameTime+0.5)
    local Hour = math.floor(GameTime/(60^2))%24
    local Minute = math.floor(GameTime/(60^1))%60
    local Second = math.floor(GameTime/(60^0))%60
    Time:Refresh("Hour : "..Hour.." Minute : "..Minute.." Second : "..Second)
end

spawn(function()
    while true do
        UpdateTime()
        wait()
    end
end)

 local WeaponList = {"Melee","Sword","Fruit","Gun"}
_G.SelectWeapon = "Melee"
Main:Dropdown("Select Weapon",WeaponList,function(value)
_G.SelectWeapon = value
end)

task.spawn(function()
	while wait() do
		pcall(function()
			if _G.SelectWeapon == "Melee" then
				for i ,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
					if v.ToolTip == "Melee" then
						if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
							_G.SelectWeapon = v.Name
						end
					end
				end
			elseif _G.SelectWeapon == "Sword" then
				for i ,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
					if v.ToolTip == "Sword" then
						if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
							_G.SelectWeapon = v.Name
						end
					end
				end
			elseif _G.SelectWeapon == "Gun" then
				for i ,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
					if v.ToolTip == "Gun" then
						if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
							_G.SelectWeapon = v.Name
						end
					end
				end
			elseif _G.SelectWeapon == "Fruit" then
				for i ,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
					if v.ToolTip == "Blox Fruit" then
						if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
							_G.SelectWeapon = v.Name
						end
					end
				end
			end
		end)
	end
    end)


	Main:Label("   \\\\ AutoFarm //")

	Main:Toggle("Auto Farm Level",_G.AutoFarm,function(value)
        _G.AutoFarm = value
        StopTween(_G.AutoFarm)
    end)
    
    spawn(function()
        while wait() do
            if _G.AutoFarm then
                pcall(function()
                    local QuestTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                    if not string.find(QuestTitle, NameMon) then
                        StartMagnet = false
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                    end
                    if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                        StartMagnet = false
                        CheckQuest()
                        if BypassTP then
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude > 1500 then
						BTP(CFrameQuest)
					else
						TP1(CFrameQuest)
					end
					if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude <= 20 then
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest",NameQuest,LevelQuest)
                        end
                    elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                        CheckQuest()
                        if game:GetService("Workspace").Enemies:FindFirstChild(Mon) then
                            for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                    if v.Name == Mon then
                                        if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) then
                                            repeat task.wait()
                                                EquipWeapon(_G.SelectWeapon)
                                                AutoHaki()                                            
                                                PosMon = v.HumanoidRootPart.CFrame
                                                TP1(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
                                                v.HumanoidRootPart.CanCollide = false
                                                v.Humanoid.WalkSpeed = 0
                                                v.Head.CanCollide = false
                                                v.HumanoidRootPart.Size = Vector3.new(70,70,70)
                                                StartMagnet = true
                                                game:GetService'VirtualUser':CaptureController()
                                                game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
                                            until not _G.AutoFarm or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                        else
                                            StartMagnet = false
                                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                        end
                                    end
                                end
                            end
                        else
                            TP1(CFrameMon)
                            StartMagnet = false
                            if game:GetService("ReplicatedStorage"):FindFirstChild(Mon) then
                             TP1(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame * CFrame.new(15,10,2))
                            end
                        end
                    end
                end)
            end
        end
    end)


	Main:Toggle("Auto Nearest Mob",_G.AutoFarmNearest,function(value)
		_G.AutoFarmNearest = value
    StopTween(_G.AutoFarmNearest)
  end)
    
 spawn(function()
     while wait() do
         if _G.AutoFarmNearest then
             for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                 if v.Name and v:FindFirstChild("Humanoid") then
                     if v.Humanoid.Health > 0 then
                         repeat wait()
                           EquipWeapon(_G.SelectWeapon)
                             if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
                                 local args = {
                                     [1] = "Buso"
                                 }
                                 game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                                end
                             topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
                             v.HumanoidRootPart.CanCollide = false
                             Fastattack = true
                             v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                             game:GetService("VirtualUser"):CaptureController()
                                game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672), game.Workspace.CurrentCamera.CFrame)
                                AutoFarmNearestMagnet = true
                                PosMon = v.HumanoidRootPart.CFrame
                         until not _G.AutoFarmNearest or not v.Parent or v.Humanoid.Health <= 0 
                         AutoFarmNearestMagnet = false
                         Fastattack = false
                     end
                 end
             end
         end
     end
     end)



		 Main:Label("   \\\\ Bone & dought kinh //")

Main:Toggle("Auto Bone",_G.Auto_Bone,function(value)
	_G.Auto_Bone = value
	StopTween(_G.Auto_Bone)
end)
local BonePos = CFrame.new(-9712.8642578125, 204.6700439453125, 6040.923828125)
spawn(function()
	while wait() do 
		if _G.Auto_Bone and World3 then
			pcall(function()
				if game:GetService("Workspace").Enemies:FindFirstChild("Reborn Skeleton [Lv. 1975]") or game:GetService("Workspace").Enemies:FindFirstChild("Living Zombie [Lv. 2000]") or game:GetService("Workspace").Enemies:FindFirstChild("Demonic Soul [Lv. 2025]") or game:GetService("Workspace").Enemies:FindFirstChild("Posessed Mummy [Lv. 2050]") then
					for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
						if v.Name == "Reborn Skeleton [Lv. 1975]" or v.Name == "Living Zombie [Lv. 2000]" or v.Name == "Demonic Soul [Lv. 2025]" or v.Name == "Posessed Mummy [Lv. 2050]" then
						   if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
							   repeat task.wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									v.HumanoidRootPart.CanCollide = false
									v.Humanoid.WalkSpeed = 0
									v.Head.CanCollide = false 
									StartMagnetBoneMon = true
									PosMonBone = v.HumanoidRootPart.CFrame
									topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
									game:GetService("VirtualUser"):CaptureController()
									game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
								until not _G.Auto_Bone or not v.Parent or v.Humanoid.Health <= 0
							end
						end
					end
				else
				if BypassTP then
				wait(2.5)
					elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - BonePos.Position).Magnitude > 1500 then
					BTP(BonePos)
				else
					topos(BonePos)
				end


                if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - BonePos.Position).Magnitude > 2000 then
                    BTP(BonePos)
                    elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - BonePos.Position).Magnitude < 2000 then
                    topos(BonePos)
                    end

					StartMagnetBoneMon = false
					topos(CFrame.new(-9506.234375, 172.130615234375, 6117.0771484375))
					for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do 
						if v.Name == "Reborn Skeleton [Lv. 1975]" then
							topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
						elseif v.Name == "Living Zombie [Lv. 2000]" then
							topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
						elseif v.Name == "Demonic Soul [Lv. 2025]" then
							topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
						elseif v.Name == "Posessed Mummy [Lv. 2050]" then
							topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
						end
					end
				end
			end)
		end
	end
end)    

Main:Toggle("Auto Random Bone",_G.Auto_Random_Bone,function(value)
	_G.Auto_Random_Bone = value
end)

spawn(function()
	pcall(function()
		while wait(.000000000000000000000001) do
			if _G.Auto_Random_Bone then    
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones","Buy",1,1)
			end
		end
	end)
end)

        local MobKilled = Main:Label("Status")
    
    spawn(function()
        while wait() do
            pcall(function()
                if string.len(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")) == 88 then
                    MobKilled:Refresh("Defeat : "..string.sub(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner"),39,41))
                elseif string.len(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")) == 87 then
                    MobKilled:Refresh("Defeat : "..string.sub(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner"),39,40))
                elseif string.len(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")) == 86 then
                    MobKilled:Refresh("Defeat : "..string.sub(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner"),39,39))
                else
                    MobKilled:Refresh("Boss Is Spawning")
                end
            end)
        end
    end)

Main:Toggle("Auto Cake Prince",_G.AutoDoughtBoss,function(value)
	_G.AutoDoughtBoss = value
	StopTween(_G.AutoDoughtBoss)
end)

spawn(function()
	while wait() do
		pcall(function()
			if string.len(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")) == 88 then
				KillMob = (tonumber(string.sub(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner"),39,41)) - 500)
			elseif string.len(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")) == 87 then
				KillMob = (tonumber(string.sub(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner"),40,41)) - 500)
			elseif string.len(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")) == 86 then
				KillMob = (tonumber(string.sub(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner"),41,41)) - 500)
			end
		end)
	end
end)

local CakePos = CFrame.new(-1891.74169921875, 272.5708312988281, -11915.3212890625)
spawn(function()
	while wait() do
		if _G.AutoDoughtBoss then
			pcall(function()
				if game:GetService("Workspace").Enemies:FindFirstChild("Cake Prince [Lv. 2300] [Raid Boss]") then
					for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
						if v.Name == "Cake Prince [Lv. 2300] [Raid Boss]" then
							if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
								repeat task.wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									v.HumanoidRootPart.CanCollide = false
									v.Humanoid.WalkSpeed = 0
									v.HumanoidRootPart.Size = Vector3.new(50,50,50)
									topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
									game:GetService("VirtualUser"):CaptureController()
									game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
									sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
								until not _G.AutoDoughtBoss or not v.Parent or v.Humanoid.Health <= 0
							end
						end
					end
				else
					if game:GetService("ReplicatedStorage"):FindFirstChild("Cake Prince [Lv. 2300] [Raid Boss]") then
						topos(game:GetService("ReplicatedStorage"):FindFirstChild("Cake Prince [Lv. 2300] [Raid Boss]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
					else
						if KillMob == 0 then
						end                    
						if game:GetService("Workspace").Map.CakeLoaf.BigMirror.Other.Transparency == 1 then
							if game:GetService("Workspace").Enemies:FindFirstChild("Cookie Crafter [Lv. 2200]") or game:GetService("Workspace").Enemies:FindFirstChild("Cake Guard [Lv. 2225]") or game:GetService("Workspace").Enemies:FindFirstChild("Baking Staff [Lv. 2250]") or game:GetService("Workspace").Enemies:FindFirstChild("Head Baker [Lv. 2275]") then
								for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
									if v.Name == "Cookie Crafter [Lv. 2200]" or v.Name == "Cake Guard [Lv. 2225]" or v.Name == "Baking Staff [Lv. 2250]" or v.Name == "Head Baker [Lv. 2275]" then
										if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
											repeat task.wait()
												AutoHaki()
												EquipWeapon(_G.SelectWeapon)
												v.HumanoidRootPart.CanCollide = false
												v.Humanoid.WalkSpeed = 0
												v.Head.CanCollide = false 
												v.HumanoidRootPart.Size = Vector3.new(50,50,50)
												MagnetDought = true
												PosMonDoughtOpenDoor = v.HumanoidRootPart.CFrame
												topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
												game:GetService("VirtualUser"):CaptureController()
												game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
											until not _G.AutoDoughtBoss or not v.Parent or v.Humanoid.Health <= 0 or game:GetService("Workspace").Map.CakeLoaf.BigMirror.Other.Transparency == 0 or game:GetService("ReplicatedStorage"):FindFirstChild("Cake Prince [Lv. 2300] [Raid Boss]") or game:GetService("Workspace").Enemies:FindFirstChild("Cake Prince [Lv. 2300] [Raid Boss]") or KillMob == 0
										end
									end
								end
							else
							if BypassTP then
							wait(1)
							elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CakePos.Position).Magnitude > 1500 then
							BTP(CakePos)
						else
							 topos(CakePos)
						end
								MagnetDought = false
								topos(CFrame.new(-2091.911865234375, 70.00884246826172, -12142.8359375))
								if game:GetService("ReplicatedStorage"):FindFirstChild("Cookie Crafter [Lv. 2200]") then
									topos(game:GetService("ReplicatedStorage"):FindFirstChild("Cookie Crafter [Lv. 2200]").HumanoidRootPart.CFrame * CFrame.new(2,20,2)) 
								else
									if game:GetService("ReplicatedStorage"):FindFirstChild("Cake Guard [Lv. 2225]") then
										topos(game:GetService("ReplicatedStorage"):FindFirstChild("Cake Guard [Lv. 2225]").HumanoidRootPart.CFrame * CFrame.new(2,20,2)) 
									else
										if game:GetService("ReplicatedStorage"):FindFirstChild("Baking Staff [Lv. 2250]") then
											topos(game:GetService("ReplicatedStorage"):FindFirstChild("Baking Staff [Lv. 2250]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
										else
											if game:GetService("ReplicatedStorage"):FindFirstChild("Head Baker [Lv. 2275]") then
												topos(game:GetService("ReplicatedStorage"):FindFirstChild("Head Baker [Lv. 2275]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
											end
										end
									end
								end                       
							end
						else
							if game:GetService("Workspace").Enemies:FindFirstChild("Cake Prince [Lv. 2300] [Raid Boss]") then
								topos(game:GetService("Workspace").Enemies:FindFirstChild("Cake Prince [Lv. 2300] [Raid Boss]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
							else
								if game:GetService("ReplicatedStorage"):FindFirstChild("Cake Prince [Lv. 2300] [Raid Boss]") then
									topos(game:GetService("ReplicatedStorage"):FindFirstChild("Cake Prince [Lv. 2300] [Raid Boss]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
								end
							end
						end
					end
				end
			end)
		end
	end
end)    

Main:Toggle("Auto Spawn CakePrince",false,function(value)
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner",value)
end)

Main:Label("\\\\\ Other //")

if World3 then	
local Elite_Hunter_Status = Main:Label("Status")


	spawn(function()
		while wait() do
			pcall(function()
				if game:GetService("ReplicatedStorage"):FindFirstChild("Diablo [Lv. 1750]") or game:GetService("ReplicatedStorage"):FindFirstChild("Deandre [Lv. 1750]") or game:GetService("ReplicatedStorage"):FindFirstChild("Urban [Lv. 1750]") or game:GetService("Workspace").Enemies:FindFirstChild("Diablo [Lv. 1750]") or game:GetService("Workspace").Enemies:FindFirstChild("Deandre [Lv. 1750]") or game:GetService("Workspace").Enemies:FindFirstChild("Urban [Lv. 1750]") then
					Elite_Hunter_Status:Refresh("Elite Hunter : ✅")	
				else
					Elite_Hunter_Status:Refresh("Elite Hunter : ❌")
				end
			end)
		end
	end)

	spawn(function()
		while wait() do
			Total_Elite_Hunter:Refresh("Total Elite Hunter : "..game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter","Progress"))
		end
	end)
	end
	
	if World3 then
	Main:Toggle("Auto Elite Hunter",_G.AutoElitehunter,function(value)
         _G.AutoElitehunter = value
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
        StopTween(_G.AutoElitehunter)
    end)
    
    spawn(function()
        while wait() do
            if _G.AutoElitehunter and World3 then
                pcall(function()
                    if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
						if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,"Diablo") or string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,"Deandre") or string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,"Urban") then
							if game:GetService("Workspace").Enemies:FindFirstChild("Diablo [Lv. 1750]") or game:GetService("Workspace").Enemies:FindFirstChild("Deandre [Lv. 1750]") or game:GetService("Workspace").Enemies:FindFirstChild("Urban [Lv. 1750]") then
								for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
									if v.Name == "Diablo [Lv. 1750]" or v.Name == "Deandre [Lv. 1750]" or v.Name == "Urban [Lv. 1750]" then
										if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
											repeat wait()
												AutoHaki()
                                                EquipWeapon(_G.SelectWeapon)
                                                v.HumanoidRootPart.CanCollide = false
                                                v.Humanoid.WalkSpeed = 0
                                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                                topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
                                                game:GetService("VirtualUser"):CaptureController()
                                                game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
                                                sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                            until _G.AutoElitehunter == false or v.Humanoid.Health <= 0 or not v.Parent
										end
									end
								end
							else
								if game:GetService("ReplicatedStorage"):FindFirstChild("Diablo [Lv. 1750]") then
                                    topos(game:GetService("ReplicatedStorage"):FindFirstChild("Diablo [Lv. 1750]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                                elseif game:GetService("ReplicatedStorage"):FindFirstChild("Deandre [Lv. 1750]") then
                                    topos(game:GetService("ReplicatedStorage"):FindFirstChild("Deandre [Lv. 1750]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                                elseif game:GetService("ReplicatedStorage"):FindFirstChild("Urban [Lv. 1750]") then
                                    topos(game:GetService("ReplicatedStorage"):FindFirstChild("Urban [Lv. 1750]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
								end
							end                    
						end
					else

						if _G.AutoEliteHunterHop and game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("EliteHunter") == "I don't have anything for you right now. Come back later." then
							hop()
						else
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter")
						end
					end
				end)
			end
		end
	end)
	end 

if World3 then
    Main:Toggle("Auto Pirate Raid", _G.AutoCarvender,function(value)
     _G.AutoRaidPirate = value
    StopTween( _G.AutoRaidPirate)
    end)
    
    spawn(function()
	while wait() do
		if _G.AutoRaidPirate then
			pcall(function()
				local CFrameBoss = CFrame.new(-5496.17432, 313.768921, -2841.53027, 0.924894512, 7.37058015e-09, 0.380223751, 3.5881019e-08, 1, -1.06665446e-07, -0.380223751, 1.12297109e-07, 0.924894512)
				if (CFrame.new(-5539.3115234375, 313.800537109375, -2972.372314453125).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 500 then
					for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
						if _G.AutoRaidPirate and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
							if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 2000 then
								repeat wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									FastA()
									Fastattack = true
									MakoriGayMag = true
									v.HumanoidRootPart.CanCollide = false
									v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
									topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
								until v.Humanoid.Health <= 0 or not v.Parent or _G.AutoRaidPirate == false
								Fastattack = false
								MakoriGayMag = false
							end
						end
					end
				else
					if ((CFrameBoss).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 1500 then
						topos(CFrameBoss)
					else
						TelePBoss(CFrameBoss)
					end
				end
			end)
		end
	end
    end)
end 

Sec = 40
Main:Slider("Set Delay", 1,600,Sec, function(Value)
	Sec = Value
end)

spawn(function()
	while wait() do wait(Sec)
		pcall(function()
			if _G.AutoObservation and not game.Players.LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") then
				game:GetService('VirtualUser'):CaptureController()
				game:GetService('VirtualUser'):SetKeyDown('0x65')
				wait(2)
				game:GetService('VirtualUser'):SetKeyUp('0x65')
			end
		end)
	end
end)

    Main:Toggle("Auto Farm Observation",_G.AutoObservation,function(value)
        _G.AutoObservation = value
        StopTween(_G.AutoObservation)
    end)
    
    spawn(function()
        while wait() do
            pcall(function()
                if _G.AutoObservation then
                    repeat task.wait()
                        if not game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") then
                            game:GetService('VirtualUser'):CaptureController()
                            game:GetService('VirtualUser'):SetKeyDown('0x65')
                            wait(2)
                            game:GetService('VirtualUser'):SetKeyUp('0x65')
                        end
                    until game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") or not _G.AutoObservation
                end
            end)
        end
    end)

local ObservationLevel = Main:Label("")

spawn(function()
	while game:GetService("RunService").Heartbeat:wait() do
		if game.Players.LocalPlayer.VisionRadius.Value == 5000 then
			Value = "Max"
		else
			Value = math.round(game.Players.LocalPlayer.VisionRadius.Value)
		end
		ObservationLevel:Refresh("Observation Haki Level : "..tostring(Value))
	end
end)   

    
    spawn(function()
        pcall(function()
            while wait() do
                if _G.AutoObservation then
                    if game:GetService("Players").LocalPlayer.VisionRadius.Value >= 3000 then
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Icon = "rbxassetid://0";
                            Title = "Observation", 
                            Text = "You Have Max Points"
                        })
                        wait(2)
                    else
                        if World2 then
                            if game:GetService("Workspace").Enemies:FindFirstChild("Lava Pirate [Lv. 1200]") then
                                if game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") then
                                    repeat task.wait()
                                        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Enemies:FindFirstChild("Lava Pirate [Lv. 1200]").HumanoidRootPart.CFrame * CFrame.new(3,0,0)
                                    until _G.AutoObservation == false or not game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("ImageLabel")
                                else
                                    repeat task.wait()
                                        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Enemies:FindFirstChild("Lava Pirate [Lv. 1200]").HumanoidRootPart.CFrame * CFrame.new(0,50,0)+
                                            wait(1)
                                        if not game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") and _G.AutoObservation_Hop == true then
                                            game:GetService("TeleportService"):Teleport(game.PlaceId,game:GetService("Players").LocalPlayer)
                                        end
                                    until _G.AutoObservation == false or game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("ImageLabel")
                                end
                            else
                                topos(CFrame.new(-5478.39209, 15.9775667, -5246.9126))
                            end
                        elseif World1 then
                            if game:GetService("Workspace").Enemies:FindFirstChild("Galley Captain [Lv. 650]") then
                                if game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") then
                                    repeat task.wait()
                                        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Enemies:FindFirstChild("Galley Captain [Lv. 650]").HumanoidRootPart.CFrame * CFrame.new(3,0,0)
                                    until _G.AutoObservation == false or not game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("ImageLabel")
                                else
                                    repeat task.wait()
                                        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Enemies:FindFirstChild("Galley Captain [Lv. 650]").HumanoidRootPart.CFrame * CFrame.new(0,50,0)
                                        wait(1)
                                        if not game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") and _G.AutoObservation_Hop == true then
                                            game:GetService("TeleportService"):Teleport(game.PlaceId,game:GetService("Players").LocalPlayer)
                                        end
                                    until _G.AutoObservation == false or game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("ImageLabel")
                                end
                            else
                                topos(CFrame.new(5533.29785, 88.1079102, 4852.3916))
                            end
                        elseif World3 then
                            if game:GetService("Workspace").Enemies:FindFirstChild("Giant Islander [Lv. 1650]") then
                                if game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") then
                                    repeat task.wait()
                                        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Enemies:FindFirstChild("Giant Islander [Lv. 1650]").HumanoidRootPart.CFrame * CFrame.new(3,0,0)
                                    until _G.AutoObservation == false or not game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("ImageLabel")
                                else
                                    repeat task.wait()
                                        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Enemies:FindFirstChild("Giant Islander [Lv. 1650]").HumanoidRootPart.CFrame * CFrame.new(0,50,0)
                                        wait(1)
                                        if not game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") and _G.AutoObservation_Hop == true then
                                            game:GetService("TeleportService"):Teleport(game.PlaceId,game:GetService("Players").LocalPlayer)
                                        end
                                    until _G.AutoObservation == false or game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("ImageLabel")
                                end
                            else
                                topos(CFrame.new(4530.3540039063, 656.75695800781, -131.60952758789))
                            end
                        end
                    end
                end
            end
        end)
    end)

	Main:Toggle("Auto Mastery Fruit",_G.AutoFarmFruitMastery,function(value)
        _G.AutoFarmFruitMastery = value
        StopTween(_G.AutoFarmFruitMastery)
        if _G.AutoFarmFruitMastery == false then
            UseSkill = false 
        end
    end)
    
    spawn(function()
        while wait() do
            if _G.AutoFarmFruitMastery then
                pcall(function()
                    local QuestTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                    if not string.find(QuestTitle, NameMon) then
                        Magnet = false
                        UseSkill = false
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                    end
                    if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                        StartMasteryFruitMagnet = false
                        UseSkill = false
                        CheckQuest()
                        repeat wait()
                            TP1(CFrameQuest)
                        until (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.AutoFarmFruitMastery
                        if (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 5 then
                            wait(0.1)
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest",NameQuest,LevelQuest)
                            wait(0.1)
                        end
                    elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                        CheckQuest()
                        if game:GetService("Workspace").Enemies:FindFirstChild(Mon) then
                            for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                    if v.Name == Mon then
                                        if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) then
                                            HealthMs = v.Humanoid.MaxHealth * _G.Kill_At/100
                                            repeat task.wait()
                                                if v.Humanoid.Health <= HealthMs then
                                                    AutoHaki()
                                                    EquipWeapon(game:GetService("Players").LocalPlayer.Data.DevilFruit.Value)
                                                    TP1(v.HumanoidRootPart.CFrame * CFrame.new(0,10,0))
                                                    v.HumanoidRootPart.CanCollide = false
                                                    PosMonMasteryFruit = v.HumanoidRootPart.CFrame
                                                    v.Humanoid.WalkSpeed = 0
                                                    v.Head.CanCollide = false
                                                    UseSkill = true
                                                else           
                                                    UseSkill = false 
                                                    AutoHaki()
                                                    EquipWeapon(_G.SelectWeapon)
                                                    TP1(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
                                                    v.HumanoidRootPart.CanCollide = false
                                                    v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                                    PosMonMasteryFruit = v.HumanoidRootPart.CFrame
                                                    v.Humanoid.WalkSpeed = 0
                                                    v.Head.CanCollide = false
                                                end
                                                StartMasteryFruitMagnet = true
                                                game:GetService'VirtualUser':CaptureController()
                                                game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
                                            until not _G.AutoFarmFruitMastery or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                        else
                                            UseSkill = false
                                            StartMasteryFruitMagnet = false
                                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                        end
                                    end
                                end
                            end
                        else
                            TP1(CFrameMon)
                            StartMasteryFruitMagnet = false   
                            UseSkill = false 
                            local Mob = game:GetService("ReplicatedStorage"):FindFirstChild(Mon) 
                            if Mob then
                                TP1(Mob.HumanoidRootPart.CFrame * CFrame.new(0,0,10))
                            else
                                if game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame.Y <= 1 then
                                    game:GetService("Players").LocalPlayer.Character.Humanoid.Jump = true
                                    task.wait()
                                    game:GetService("Players").LocalPlayer.Character.Humanoid.Jump = false
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)
    
    spawn(function()
        while wait() do
            if UseSkill then
                pcall(function()
                    CheckQuest()
                    for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if game:GetService("Players").LocalPlayer.Character:FindFirstChild(game:GetService("Players").LocalPlayer.Data.DevilFruit.Value) then
                            MasBF = game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Data.DevilFruit.Value].Level.Value
                        elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(game:GetService("Players").LocalPlayer.Data.DevilFruit.Value) then
                            MasBF = game:GetService("Players").LocalPlayer.Backpack[game:GetService("Players").LocalPlayer.Data.DevilFruit.Value].Level.Value
                        end
                        if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dragon-Dragon") then                      
                            if _G.SkillZ then
                                local args = {
                                    [1] = PosMonMasteryFruit.Position
                                }
                                game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))                        
                                game:GetService("VirtualInputManager"):SendKeyEvent(true,"Z",false,game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false,"Z",false,game)
                            end
                            if _G.SkillX then          
                                local args = {
                                    [1] = PosMonMasteryFruit.Position
                                }
                                game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))               
                                game:GetService("VirtualInputManager"):SendKeyEvent(true,"X",false,game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false,"X",false,game)
                            end
                            if _G.SkillC then
                                local args = {
                                    [1] = PosMonMasteryFruit.Position
                                }
                                game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))                          
                                game:GetService("VirtualInputManager"):SendKeyEvent(true,"C",false,game)
                                wait(2)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false,"C",false,game)
                            end
                        elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("Venom-Venom") then   
                            if _G.SkillZ then
                                local args = {
                                    [1] = PosMonMasteryFruit.Position
                                }
                                game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))                        
                                game:GetService("VirtualInputManager"):SendKeyEvent(true,"Z",false,game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false,"Z",false,game)
                            end
                            if _G.SkillX then        
                                local args = {
                                    [1] = PosMonMasteryFruit.Position
                                }
                                game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))               
                                game:GetService("VirtualInputManager"):SendKeyEvent(true,"X",false,game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false,"X",false,game)
                            end
                            if _G.SkillC then 
                                local args = {
                                    [1] = PosMonMasteryFruit.Position
                                }
                                game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))                          
                                game:GetService("VirtualInputManager"):SendKeyEvent(true,"C",false,game)
                                wait(2)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false,"C",false,game)
                            end
                        elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("Human-Human: Buddha") then
                            if _G.SkillZ and game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Size == Vector3.new(2, 2.0199999809265, 1) then
                                local args = {
                                    [1] = PosMonMasteryFruit.Position
                                }
                                game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))                         
                                game:GetService("VirtualInputManager"):SendKeyEvent(true,"Z",false,game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false,"Z",false,game)
                            end
                            if _G.SkillX then
                                local args = {
                                    [1] = PosMonMasteryFruit.Position
                                }
                                game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))                           
                                game:GetService("VirtualInputManager"):SendKeyEvent(true,"X",false,game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false,"X",false,game)
                            end
                            if _G.SkillC then
                                local args = {
                                    [1] = PosMonMasteryFruit.Position
                                }
                                game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))                           
                                game:GetService("VirtualInputManager"):SendKeyEvent(true,"C",false,game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false,"C",false,game)
                            end
                            if _G.SkillV then
                                local args = {
                                    [1] = PosMonMasteryFruit.Position
                                }
                                game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))
                                game:GetService("VirtualInputManager"):SendKeyEvent(true,"V",false,game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false,"V",false,game)
                            end
                        elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild(game:GetService("Players").LocalPlayer.Data.DevilFruit.Value) then
                            if _G.SkillZ then 
                                local args = {
                                    [1] = PosMonMasteryFruit.Position
                                }
                                game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))                         
                                game:GetService("VirtualInputManager"):SendKeyEvent(true,"Z",false,game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false,"Z",false,game)
                            end
                            if _G.SkillX then
                                local args = {
                                    [1] = PosMonMasteryFruit.Position
                                }
                                game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))                           
                                game:GetService("VirtualInputManager"):SendKeyEvent(true,"X",false,game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false,"X",false,game)
                            end
                            if _G.SkillC then
                                local args = {
                                    [1] = PosMonMasteryFruit.Position
                                }
                                game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))                           
                                game:GetService("VirtualInputManager"):SendKeyEvent(true,"C",false,game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false,"C",false,game)
                            end
                            if _G.SkillV then
                                local args = {
                                    [1] = PosMonMasteryFruit.Position
                                }
                                game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))
                                game:GetService("VirtualInputManager"):SendKeyEvent(true,"V",false,game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false,"V",false,game)
                            end
                        end
                    end
                end)
            end
        end
    end)
    
    spawn(function()
        game:GetService("RunService").RenderStepped:Connect(function()
            pcall(function()
                if UseSkill then
                    for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Notifications:GetChildren()) do
                        if v.Name == "NotificationTemplate" then
                            if string.find(v.Text,"Skill locked!") then
                                v:Destroy()
                            end
                        end
                    end
                end
            end)
        end)
    end)
    
    spawn(function()
        pcall(function()
            game:GetService("RunService").RenderStepped:Connect(function()
                if UseSkill then
                    local args = {
                        [1] = PosMonMasteryFruit.Position
                    }
                    game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Data.DevilFruit.Value].RemoteEvent:FireServer(unpack(args))
                end
            end)
        end)
    end)

	Main:Toggle("Auto Mastery Gun",_G.AutoFarmGunMastery,function(value)
        _G.AutoFarmGunMastery = value
        StopTween(_G.AutoFarmGunMastery)
        if _G.AutoFarmGunMastery == false then
            UseSkill = false 
        end
    end)

    spawn(function()
        pcall(function()
            while wait() do
                if _G.AutoFarmGunMastery then
                    local QuestTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                    if not string.find(QuestTitle, NameMon) then
                        Magnet = false                                      
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                    end
                    if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                        StartMasteryGunMagnet = false
                        CheckQuest()
                        TP1(CFrameQuest)
                        if (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 10 then
                            wait(0.1)
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LevelQuest)
                        end
                    elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                        CheckQuest()
                        if game:GetService("Workspace").Enemies:FindFirstChild(Mon) then
                            pcall(function()
                                for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                    if v.Name == Mon then
                                        repeat task.wait()
                                            if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) then
                                                HealthMin = v.Humanoid.MaxHealth * _G.Kill_At/100
                                                if v.Humanoid.Health <= HealthMin then                                                
                                                    EquipWeapon(SelectWeaponGun)
                                                    TP1(v.HumanoidRootPart.CFrame * CFrame.new(0,10,0))
                                                    v.Humanoid.WalkSpeed = 0
                                                    v.HumanoidRootPart.CanCollide = false
                                                    v.HumanoidRootPart.Size = Vector3.new(2,2,1)
                                                    v.Head.CanCollide = false                                                
                                                    local args = {
                                                        [1] = v.HumanoidRootPart.Position,
                                                        [2] = v.HumanoidRootPart
                                                    }
                                                    game:GetService("Players").LocalPlayer.Character[SelectWeaponGun].RemoteFunctionShoot:InvokeServer(unpack(args))
                                                else
                                                    AutoHaki()
                                                    EquipWeapon(_G.SelectWeapon)
                                                    v.Humanoid.WalkSpeed = 0
                                                    v.HumanoidRootPart.CanCollide = false
                                                    v.Head.CanCollide = false               
                                                    v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                                    TP1(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
                                                    game:GetService'VirtualUser':CaptureController()
                                                    game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
                                                end
                                                StartMasteryGunMagnet = true 
                                                PosMonMasteryGun = v.HumanoidRootPart.CFrame
                                            else
                                                StartMasteryGunMagnet = false
                                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                            end
                                        until v.Humanoid.Health <= 0 or _G.MasterGun == false or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                        StartMasteryGunMagnet = false
                                    end
                                end
                            end)
                        else
                           TP1(CFrameMon)
                            AutoFarmNearestMagnet = false
                            local Mob = game:GetService("ReplicatedStorage"):FindFirstChild(Mon) 
                            if Mob then
                                TP1(Mob.HumanoidRootPart.CFrame * CFrame.new(0,0,10))
                            else
                                if game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame.Y <= 1 then
                                    game:GetService("Players").LocalPlayer.Character.Humanoid.Jump = true
                                    task.wait()
                                    game:GetService("Players").LocalPlayer.Character.Humanoid.Jump = false
                                end
                            end
                        end 
                    end
                end
            end
        end)
    end)

	_G.Kill_At = 35

    Main:Slider("Kill At %",1,100,35,function(value)

        _G.Kill_At = value
    end)

    Main:Toggle("Skill Z",true,function(value)
        _G.SkillZ = value
    end)
 
    
    Main:Toggle("Skill X",true,function(value)
        _G.SkillX = value
    end)
    
    Main:Toggle("Skill C",true,function(value)
        _G.SkillC = value
    end)
    
     Main:Toggle("Skill V",true,function(value)
        _G.SkillV = value
    end)
	
-- Farm_Monster

if World1 then

tableMon = {

 "Bandit [Lv. 5]","Monkey [Lv. 14]","Gorilla [Lv. 20]","Pirate [Lv. 35]","Brute [Lv. 45]","Desert Bandit [Lv. 60]","Desert Officer [Lv. 70]","Snow Bandit [Lv. 90]","Snowman [Lv. 100]","Chief Petty Officer [Lv. 120]","Sky Bandit [Lv. 150]","Dark Master [Lv. 175]","Prisoner [Lv. 190]", "Dangerous Prisoner [Lv. 210]","Toga Warrior [Lv. 250]","Gladiator [Lv. 275]","Military Soldier [Lv. 300]","Military Spy [Lv. 325]","Fishman Warrior [Lv. 375]","Fishman Commando [Lv. 400]","God's Guard [Lv. 450]","Shanda [Lv. 475]","Royal Squad [Lv. 525]","Royal Soldier [Lv. 550]","Galley Pirate [Lv. 625]","Galley Captain [Lv. 650]"

} elseif World2 then

tableMon = {

 "Raider [Lv. 700]","Mercenary [Lv. 725]","Swan Pirate [Lv. 775]","Factory Staff [Lv. 800]","Marine Lieutenant [Lv. 875]","Marine Captain [Lv. 900]","Zombie [Lv. 950]","Vampire [Lv. 975]","Snow Trooper [Lv. 1000]","Winter Warrior [Lv. 1050]","Lab Subordinate [Lv. 1100]","Horned Warrior [Lv. 1125]","Magma Ninja [Lv. 1175]","Lava Pirate [Lv. 1200]","Ship Deckhand [Lv. 1250]","Ship Engineer [Lv. 1275]","Ship Steward [Lv. 1300]","Ship Officer [Lv. 1325]","Arctic Warrior [Lv. 1350]","Snow Lurker [Lv. 1375]","Sea Soldier [Lv. 1425]","Water Fighter [Lv. 1450]"

} elseif World3 then

tableMon = {

 "Pirate Millionaire [Lv. 1500]","Dragon Crew Warrior [Lv. 1575]","Dragon Crew Archer [Lv. 1600]","Female Islander [Lv. 1625]","Giant Islander [Lv. 1650]","Marine Commodore [Lv. 1700]","Marine Rear Admiral [Lv. 1725]","Fishman Raider [Lv. 1775]","Fishman Captain [Lv. 1800]","Forest Pirate [Lv. 1825]","Mythological Pirate [Lv. 1850]","Jungle Pirate [Lv. 1900]","Musketeer Pirate [Lv. 1925]","Reborn Skeleton [Lv. 1975]","Living Zombie [Lv. 2000]","Demonic Soul [Lv. 2025]","Posessed Mummy [Lv. 2050]", "Peanut Scout [Lv. 2075]", "Peanut President [Lv. 2100]", "Ice Cream Chef [Lv. 2125]", "Ice Cream Commander [Lv. 2150]", "Cookie Crafter [Lv. 2200]", "Cake Guard [Lv. 2225]", "Baking Staff [Lv. 2250]", "Head Baker [Lv. 2275]", "Cocoa Warrior [Lv. 2300]", "Chocolate Bar Battler [Lv. 2325]", "Sweet Thief [Lv. 2350]", "Candy Rebel [Lv. 2375]", "Candy Pirate [Lv. 2400]", "Snow Demon [Lv. 2425]"

}

end
	
Main:Dropdown("Select Monster", tableMon, function(vu)

 SelectMonster = vu

 end)



Main:Toggle("Farm Monster",_G.AutoFarmSelectMonster,function(vu)

 _G.AutoFarmSelectMonster = vu

end)



spawn(function()

 while wait(.1) do

 if _G.AutoFarmSelectMonster then

 pcall(function()

  checkselect(SelectMonster)

  if game:GetService("Workspace").Enemies:FindFirstChild(SelectMonster) then

  for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do

  if v.Name == SelectMonster then

  if v:FindFirstChild("Humanoid") then

  if v.Humanoid.Health > 0 then

  repeat game:GetService("RunService").Heartbeat:wait()

  EquipWeapon(_G.SelectWeapon)

  if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then

  local args = {

   [1] = "Buso"

  }

  game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))

  end

  topos(v.HumanoidRootPart.CFrame * CFrame.new(0,30,0))

  v.HumanoidRootPart.CanCollide = false

  v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)

  game:GetService("VirtualUser"):CaptureController()

  game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672), game.Workspace.CurrentCamera.CFrame)

  PosMonSelectMonster = v.HumanoidRootPart.CFrame

  SelectMonsterMagnet = true

  until not _G.AutoFarmSelectMonster or not v.Parent or v.Humanoid.Health == 0 or not game:GetService("Workspace").Enemies:FindFirstChild(v.Name)

  end

  end

  end

  end

  else

   checkselect(SelectMonster)

  SelectMonsterMagnet = false

  topos(CFrameMon)

  end

  end)

 end

 end

end)

local Boss = {}
    
for i, v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
	if string.find(v.Name, "Boss") then
		if v.Name == "Ice Admiral [Lv. 700] [Boss]" then
			else
			table.insert(Boss, v.Name)
		end
	end
end

local BossName = Main:Dropdown("Boss List",Boss,function(value)
	_G.SelectBoss = value
end)

Main:Button("Refresh",function()
	BossName:Clear()
		for i, v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
		if string.find(v.Name, "Boss") then
			BossName:Add(v.Name) 
		end
	end
end)

Main:Toggle("Auto Farm Boss",_G.AutoFarmBoss,function(value)
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
	_G.AutoFarmBoss = value
	StopTween(_G.AutoFarmBoss)
end)

spawn(function()
	while wait() do
		if _G.AutoFarmBoss then
			pcall(function()
				if game:GetService("Workspace").Enemies:FindFirstChild(_G.SelectBoss) then
					for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
						if v.Name == _G.SelectBoss then
							if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
								repeat task.wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									v.HumanoidRootPart.CanCollide = false
									v.Humanoid.WalkSpeed = 0
									v.HumanoidRootPart.Size = Vector3.new(80,80,80)                             
									topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
									game:GetService("VirtualUser"):CaptureController()
									game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
									sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
								until not _G.AutoFarmBoss or not v.Parent or v.Humanoid.Health <= 0
							end
						end
					end
				else
					if game:GetService("ReplicatedStorage"):FindFirstChild(_G.SelectBoss) then
						topos(game:GetService("ReplicatedStorage"):FindFirstChild(_G.SelectBoss).HumanoidRootPart.CFrame * CFrame.new(5,10,2))
					end
				end
			end)
		end
	end
end)	


---------Setting


	local AttackList = {"Slow", "Fast", "Super"}
_G.FastAttackDelay = "Fast"
Setting:Dropdown("FastAttack List", AttackList,function(MakoGay)
    _G.FastAttackDelay = MakoGay
end)
spawn(function()
    while wait(.1) do
        if _G.FastAttackDelay then
            pcall(function()
                if _G.FastAttackDelay == "0" then
                    _G.FastAttackDelay = 0
                elseif _G.FastAttackDelay == "Super" then
                    _G.FastAttackDelay = 0.1
                elseif _G.FastAttackDelay == "Fast" then
                    _G.FastAttackDelay = 0.15
                elseif _G.FastAttackDelay == "Slow" then
                    _G.FastAttackDelay = 0.2
                elseif _G.FastAttackDelay == "0.16" then
                    _G.FastAttackDelay = 0.16
                elseif _G.FastAttackDelay == "0.165" then
                    _G.FastAttackDelay = 0.165
                elseif _G.FastAttackDelay == "0.17" then
                    _G.FastAttackDelay = 0.17
                elseif _G.FastAttackDelay == "0.175" then
                    _G.FastAttackDelay = 0.175
                elseif _G.FastAttackDelay == "0.18" then
                    _G.FastAttackDelay = 0.18
                elseif _G.FastAttackDelay == "0.185" then
                    _G.FastAttackDelay = 0.185
                end
            end)
        end
    end
end)


    
local Bring = {"Low", "Normal", "Super"}
_G.BringMode = "Normal"
Setting:Dropdown("BringMob List", Bring,function(value)
    _G.BringMode = value
end)
spawn(function()
    while wait(.1) do
        if _G.BringMode then
            pcall(function()
                if _G.BringMode == "Low" then
                    _G.BringMode = 250
                elseif _G.BringMode == "Normal" then
                    _G.BringMode = 300
                elseif _G.BringMode == "Super" then
                    _G.BringMode = 350
                end
            end)
        end
    end
end)



Setting:Toggle("Fast Attack ",true,function(value)
	_G.FastAttack = value
end)      

local CameraShaker = require(game.ReplicatedStorage.Util.CameraShaker)
CombatFrameworkR = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
y = debug.getupvalues(CombatFrameworkR)[2]
spawn(function()
game:GetService("RunService").RenderStepped:Connect(function()
	if _G.FastAttack then
		if typeof(y) == "table" then
			pcall(function()
				CameraShaker:Stop()
				y.activeController.timeToNextAttack = (math.huge^math.huge^math.huge)
				y.activeController.timeToNextAttack = 0
				y.activeController.hitboxMagnitude = 60
				y.activeController.active = false
				y.activeController.timeToNextBlock = 0
				y.activeController.focusStart = 1655503339.0980349
				y.activeController.increment = 1
				y.activeController.blocking = false
				y.activeController.attacking = false
				y.activeController.humanoid.AutoRotate = true
			end)
		end
	end
end)
end)
spawn(function()
game:GetService("RunService").RenderStepped:Connect(function()
	if _G.FastAttack == true then
		game.Players.LocalPlayer.Character.Stun.Value = 0
		game.Players.LocalPlayer.Character.Busy.Value = false        
	end
end)
end)

local Client = game.Players.LocalPlayer
local STOP = require(Client.PlayerScripts.CombatFramework.Particle)
local STOPRL = require(game:GetService("ReplicatedStorage").CombatFramework.RigLib)
spawn(function()
	while task.wait() do
		pcall(function()
			if not shared.orl then shared.orl = STOPRL.wrapAttackAnimationAsync end
			if not shared.cpc then shared.cpc = STOP.play end
				STOPRL.wrapAttackAnimationAsync = function(a,b,c,d,func)
				local Hits = STOPRL.getBladeHits(b,c,d)
				if Hits then
					if _G.FastAttack then
						STOP.play = function() end
						a:Play(0.01,0.01,0.01)
						func(Hits)
						STOP.play = shared.cpc
						wait(a.length * 0.5)
						a:Stop()
					else
						a:Play()
					end
				end
			end
		end)
	end
end)

function GetBladeHit()
local CombatFrameworkLib = debug.getupvalues(require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework))
local CmrFwLib = CombatFrameworkLib[2]
local p13 = CmrFwLib.activeController
local weapon = p13.blades[1]
if not weapon then 
	return weapon
end
while weapon.Parent ~= game.Players.LocalPlayer.Character do
	weapon = weapon.Parent 
end
return weapon
end
function AttackHit()
local CombatFrameworkLib = debug.getupvalues(require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework))
local CmrFwLib = CombatFrameworkLib[2]
local plr = game.Players.LocalPlayer
for i = 1, 1 do
	local bladehit = require(game.ReplicatedStorage.CombatFramework.RigLib).getBladeHits(plr.Character,{plr.Character.HumanoidRootPart},60)
	local cac = {}
	local hash = {}
	for k, v in pairs(bladehit) do
		if v.Parent:FindFirstChild("HumanoidRootPart") and not hash[v.Parent] then
			table.insert(cac, v.Parent.HumanoidRootPart)
			hash[v.Parent] = true
		end
	end
	bladehit = cac
	if #bladehit > 0 then
		pcall(function()
			CmrFwLib.activeController.timeToNextAttack = 1
			CmrFwLib.activeController.attacking = false
			CmrFwLib.activeController.blocking = false
			CmrFwLib.activeController.timeToNextBlock = 0
			CmrFwLib.activeController.increment = 3
			CmrFwLib.activeController.hitboxMagnitude = 60
			CmrFwLib.activeController.focusStart = 0
			game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("weaponChange",tostring(GetBladeHit()))
			game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("hit", bladehit, i, "")
		end)
	end
end
end
spawn(function()
while wait(.1) do
	if _G.FastAttack then
		pcall(function()
			repeat task.wait(_G.FastAttackDelay)
				AttackHit()
			until not _G.FastAttack
		end)
	end
end
end)

local CamShake = require(game.ReplicatedStorage.Util.CameraShaker)
CamShake:Stop()


Setting:Toggle("Bring Mob",true,function(Mag)
    _G.BringMonster = Mag
    end)
    spawn(function()
        while task.wait() do
            pcall(function()
                if _G.BringMonster then
                    CheckQuest()
                    for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if _G.AutoFarm and StartMagnet and v.Name == Mon and (Mon == "Factory Staff [Lv. 800]" or Mon == "Monkey [Lv. 14]" or Mon == "Dragon Crew Warrior [Lv. 1575]" or Mon == "Dragon Crew Archer [Lv. 1600]") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 220 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.HumanoidRootPart.CFrame = PosMon
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                        elseif _G.AutoFarm and StartMagnet and v.Name == Mon and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= _G.BringMode then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.HumanoidRootPart.CFrame = PosMon
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                        end
                    end
                end
            end)
        end
    end)

	Setting:Toggle("Auto Haki",true,function(value)
		_G.AUTOHAKI = value
		end)
		spawn(function()
			while wait(.1) do
				if _G.AUTOHAKI then 
					if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
						local args = {
							[1] = "Buso"
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					end
				end
			end
		end)


    PosX = 1
    Setting:Slider("Pos X",0,50,1,function(value)
    PosX = value
    end)

    PosY = 40
    Setting:Slider("Pos Y",0,50,40,function(value)
    PosY = value
    end)

    PosZ = 40
    Setting:Slider("Pos Z",0,50,40,function(value)
    PosZ = value
    end)

			Items:Label("\\\\ Items //")

			Items:Toggle("Auto Superhuman",_G.AutoSuperhuman,function(value)
				_G.AutoSuperhuman = value
			end)
			
			spawn(function()
				pcall(function()
					while wait() do 
						if _G.AutoSuperhuman then
							if game.Players.LocalPlayer.Backpack:FindFirstChild("Combat") or game.Players.LocalPlayer.Character:FindFirstChild("Combat") and game:GetService("Players")["LocalPlayer"].Data.Beli.Value >= 150000 then
								UnEquipWeapon("Combat")
								wait(.1)
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBlackLeg")
							end   
							if game.Players.LocalPlayer.Character:FindFirstChild("Superhuman") or game.Players.LocalPlayer.Backpack:FindFirstChild("Superhuman") then
								_G.SelectWeapon = "Superhuman"
							end  
							if game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg") or game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") or game.Players.LocalPlayer.Backpack:FindFirstChild("Electro") or game.Players.LocalPlayer.Character:FindFirstChild("Electro") or game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate") or game.Players.LocalPlayer.Character:FindFirstChild("Fishman Karate") or game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw") or game.Players.LocalPlayer.Character:FindFirstChild("Dragon Claw") then
								if game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg").Level.Value <= 299 then
									_G.SelectWeapon = "Black Leg"
								end
								if game.Players.LocalPlayer.Backpack:FindFirstChild("Electro") and game.Players.LocalPlayer.Backpack:FindFirstChild("Electro").Level.Value <= 299 then
									_G.SelectWeapon = "Electro"
								end
								if game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate") and game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate").Level.Value <= 299 then
									_G.SelectWeapon = "Fishman Karate"
								end
								if game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw") and game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw").Level.Value <= 299 then
									_G.SelectWeapon = "Dragon Claw"
								end
								if game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg").Level.Value >= 300 and game:GetService("Players")["LocalPlayer"].Data.Beli.Value >= 300000 then
									UnEquipWeapon("Black Leg")
									wait(.1)
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectro")
								end
								if game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Character:FindFirstChild("Black Leg").Level.Value >= 300 and game:GetService("Players")["LocalPlayer"].Data.Beli.Value >= 300000 then
									UnEquipWeapon("Black Leg")
									wait(.1)
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectro")
								end
								if game.Players.LocalPlayer.Backpack:FindFirstChild("Electro") and game.Players.LocalPlayer.Backpack:FindFirstChild("Electro").Level.Value >= 300 and game:GetService("Players")["LocalPlayer"].Data.Beli.Value >= 750000 then
									UnEquipWeapon("Electro")
									wait(.1)
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyFishmanKarate")
								end
								if game.Players.LocalPlayer.Character:FindFirstChild("Electro") and game.Players.LocalPlayer.Character:FindFirstChild("Electro").Level.Value >= 300 and game:GetService("Players")["LocalPlayer"].Data.Beli.Value >= 750000 then
									UnEquipWeapon("Electro")
									wait(.1)
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyFishmanKarate")
								end
								if game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate") and game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate").Level.Value >= 300 and game:GetService("Players")["Localplayer"].Data.Fragments.Value >= 1500 then
									UnEquipWeapon("Fishman Karate")
									wait(.1)
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","1")
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","2") 
								end
								if game.Players.LocalPlayer.Character:FindFirstChild("Fishman Karate") and game.Players.LocalPlayer.Character:FindFirstChild("Fishman Karate").Level.Value >= 300 and game:GetService("Players")["Localplayer"].Data.Fragments.Value >= 1500 then
									UnEquipWeapon("Fishman Karate")
									wait(.1)
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","1")
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","2") 
								end
								if game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw") and game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw").Level.Value >= 300 and game:GetService("Players")["LocalPlayer"].Data.Beli.Value >= 3000000 then
									UnEquipWeapon("Dragon Claw")
									wait(.1)
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySuperhuman")
								end
								if game.Players.LocalPlayer.Character:FindFirstChild("Dragon Claw") and game.Players.LocalPlayer.Character:FindFirstChild("Dragon Claw").Level.Value >= 300 and game:GetService("Players")["LocalPlayer"].Data.Beli.Value >= 3000000 then
									UnEquipWeapon("Dragon Claw")
									wait(.1)
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySuperhuman")
								end 
							end
						end
					end
				end)
			end)
			
			Items:Toggle("Auto DeathStep",_G.AutoDeathStep,function(value)
				_G.AutoDeathStep = value
			end)
			
			spawn(function()
				while wait() do wait()
					if _G.AutoDeathStep then
						if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Black Leg") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Black Leg") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Death Step") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Death Step") then
							if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Black Leg") and game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Black Leg").Level.Value >= 450 then
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep")
								_G.SelectWeapon = "Death Step"
							end  
							if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Black Leg") and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Black Leg").Level.Value >= 450 then
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep")
								_G.SelectWeapon = "Death Step"
							end  
							if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Black Leg") and game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Black Leg").Level.Value <= 449 then
								_G.SelectWeapon = "Black Leg"
							end 
						else 
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBlackLeg")
						end
					end
				end
			end)
			
			Items:Toggle("Auto Sharkman Karate",_G.AutoSharkman,function(value)
				_G.AutoSharkman = value
			end)
			
			spawn(function()
				pcall(function()
					while wait() do
						if _G.AutoSharkman then
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyFishmanKarate")
							if string.find(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate"), "keys") then  
								if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Water Key") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Water Key") then
									topos(CFrame.new(-2604.6958, 239.432526, -10315.1982, 0.0425701365, 0, -0.999093413, 0, 1, 0, 0.999093413, 0, 0.0425701365))
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate")
								elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("Fishman Karate") and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Fishman Karate").Level.Value >= 400 then
								else 
									Ms = "Tide Keeper [Lv. 1475] [Boss]"
									if game:GetService("Workspace").Enemies:FindFirstChild(Ms) then   
										for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
											if v.Name == Ms then    
												OldCFrameShark = v.HumanoidRootPart.CFrame
												repeat task.wait()
													AutoHaki()
													EquipWeapon(_G.SelectWeapon)
													v.Head.CanCollide = false
													v.Humanoid.WalkSpeed = 0
													v.HumanoidRootPart.CanCollide = false
													v.HumanoidRootPart.Size = Vector3.new(50,50,50)
													v.HumanoidRootPart.CFrame = OldCFrameShark
													topos(v.HumanoidRootPart.CFrame*CFrame.new(2,20,2))
													game:GetService("VirtualUser"):CaptureController()
													game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 670))
													sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
												until not v.Parent or v.Humanoid.Health <= 0 or _G.AutoSharkman == false or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Water Key") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Water Key")
											end
										end
									else
										topos(CFrame.new(-3570.18652, 123.328949, -11555.9072, 0.465199202, -1.3857326e-08, 0.885206044, 4.0332897e-09, 1, 1.35347511e-08, -0.885206044, -2.72606271e-09, 0.465199202))
										wait(3)
									end
								end
							else 
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate")
							end
						end
					end
				end)
			end)
			
			Items:Toggle("Auto Electric Claw",_G.AutoElectricClaw,function(value)
				_G.AutoElectricClaw = value
				StopTween(_G.AutoElectricClaw)
			end)
			
			spawn(function()
				pcall(function()
					while wait() do 
						if _G.AutoElectricClaw then
							if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Electro") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Electro") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Electric Claw") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Electric Claw") then
								if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Electro") and game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Electro").Level.Value >= 400 then
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw")
									_G.SelectWeapon = "Electric Claw"
								end  
								if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Electro") and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Electro").Level.Value >= 400 then
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw")
									_G.SelectWeapon = "Electric Claw"
								end  
								if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Electro") and game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Electro").Level.Value <= 399 then
									_G.SelectWeapon = "Electro"
								end 
							else
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectro")
							end
						end
						if _G.AutoElectricClaw then
							if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Electro") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Electro") then
								if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Electro") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Electro") and game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Electro").Level.Value >= 400 or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Electro").Level.Value >= 400 then
									if _G.AutoFarm == false then
										repeat task.wait()
											topos(CFrame.new(-10371.4717, 330.764496, -10131.4199))
										until not _G.AutoElectricClaw or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - CFrame.new(-10371.4717, 330.764496, -10131.4199).Position).Magnitude <= 10
										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw","Start")
										wait(2)
										repeat task.wait()
											topos(CFrame.new(-12550.532226563, 336.22631835938, -7510.4233398438))
										until not _G.AutoElectricClaw or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - CFrame.new(-12550.532226563, 336.22631835938, -7510.4233398438).Position).Magnitude <= 10
										wait(1)
										repeat task.wait()
											topos(CFrame.new(-10371.4717, 330.764496, -10131.4199))
										until not _G.AutoElectricClaw or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - CFrame.new(-10371.4717, 330.764496, -10131.4199).Position).Magnitude <= 10
										wait(1)
										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw")
									elseif _G.AutoFarm == true then
										_G.AutoFarm = false
										wait(1)
										repeat task.wait()
											topos(CFrame.new(-10371.4717, 330.764496, -10131.4199))
										until not _G.AutoElectricClaw or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - CFrame.new(-10371.4717, 330.764496, -10131.4199).Position).Magnitude <= 10
										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw","Start")
										wait(2)
										repeat task.wait()
											topos(CFrame.new(-12550.532226563, 336.22631835938, -7510.4233398438))
										until not _G.AutoElectricClaw or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - CFrame.new(-12550.532226563, 336.22631835938, -7510.4233398438).Position).Magnitude <= 10
										wait(1)
										repeat task.wait()
											topos(CFrame.new(-10371.4717, 330.764496, -10131.4199))
										until not _G.AutoElectricClaw or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - CFrame.new(-10371.4717, 330.764496, -10131.4199).Position).Magnitude <= 10
										wait(1)
										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw")
										_G.SelectWeapon = "Electric Claw"
										wait(.1)
										_G.AutoFarm = true
									end
								end
							end
						end
					end
				end)
			end)
			
			Items:Toggle("Auto Dragon Talon",_G.AutoDragonTalon,function(value)
				_G.AutoDragonTalon = value
			end)
			
			spawn(function()
				while wait() do
					if _G.AutoDragonTalon then
						if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dragon Claw") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dragon Claw") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dragon Talon") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dragon Talon") then
							if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dragon Claw") and game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dragon Claw").Level.Value >= 400 then
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon")
								_G.SelectWeapon = "Dragon Talon"
							end  
							if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dragon Claw") and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dragon Claw").Level.Value >= 400 then
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon")
								_G.SelectWeapon = "Dragon Talon"
							end  
							if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dragon Claw") and game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dragon Claw").Level.Value <= 399 then
								_G.SelectWeapon = "Dragon Claw"
							end 
						else 
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","2")
						end
					end
				end
			end)
			
			Items:Toggle("Auto GodHuman",_G.Auto_God_Human,function(value)
		 _G.Auto_God_Human = value
		end)
		spawn(function()
			while task.wait() do
				if _G.Auto_God_Human then
					pcall(function()
						if game.Players.LocalPlayer.Character:FindFirstChild("Superhuman") or game.Players.LocalPlayer.Backpack:FindFirstChild("Superhuman") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Black Leg") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Black Leg") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Death Step") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Death Step") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Fishman Karate") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Fishman Karate") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Sharkman Karate") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Sharkman Karate") or game.Players.LocalPlayer.Backpack:FindFirstChild("Electro") or game.Players.LocalPlayer.Character:FindFirstChild("Electro") or game.Players.LocalPlayer.Backpack:FindFirstChild("Electric Claw") or game.Players.LocalPlayer.Character:FindFirstChild("Electric Claw") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dragon Claw") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dragon Claw") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dragon Talon") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dragon Talon") or game.Players.LocalPlayer.Character:FindFirstChild("Godhuman") or game.Players.LocalPlayer.Backpack:FindFirstChild("Godhuman") then
							if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySuperhuman",true) == 1 then
								if game.Players.LocalPlayer.Backpack:FindFirstChild("Superhuman") and game.Players.LocalPlayer.Backpack:FindFirstChild("Superhuman").Level.Value >= 400 or game.Players.LocalPlayer.Character:FindFirstChild("Superhuman") and game.Players.LocalPlayer.Character:FindFirstChild("Superhuman").Level.Value >= 400 then
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep")
								end
							else
								game.StarterGui:SetCore("SendNotification", {
									Title = "Notification", 
									Text = "Not Have Superhuman" ,
									Icon = "http://www.roblox.com/asset/?id=",
									Duration = 2.5
								})
							end
							if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep",true) == 1 then
								if game.Players.LocalPlayer.Backpack:FindFirstChild("Death Step") and game.Players.LocalPlayer.Backpack:FindFirstChild("Death Step").Level.Value >= 400 or game.Players.LocalPlayer.Character:FindFirstChild("Death Step") and game.Players.LocalPlayer.Character:FindFirstChild("Death Step").Level.Value >= 400 then
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate")
								end
							else
								game.StarterGui:SetCore("SendNotification", {
									Title = "Notification", 
									Text = "Not Have Death Step" ,
									Icon = "http://www.roblox.com/asset/?id=",
									Duration = 2.5
								})
							end
							if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate",true) == 1 then
								if game.Players.LocalPlayer.Backpack:FindFirstChild("Sharkman Karate") and game.Players.LocalPlayer.Backpack:FindFirstChild("Sharkman Karate").Level.Value >= 400 or game.Players.LocalPlayer.Character:FindFirstChild("Sharkman Karate") and game.Players.LocalPlayer.Character:FindFirstChild("Sharkman Karate").Level.Value >= 400 then
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw")
								end
							else
								game.StarterGui:SetCore("SendNotification", {
									Title = "Notification", 
									Text = "Not Have SharkMan Karate" ,
									Icon = "http://www.roblox.com/asset/?id=",
									Duration = 2.5
								})
							end
							if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw",true) == 1 then
								if game.Players.LocalPlayer.Backpack:FindFirstChild("Electric Claw") and game.Players.LocalPlayer.Backpack:FindFirstChild("Electric Claw").Level.Value >= 400 or game.Players.LocalPlayer.Character:FindFirstChild("Electric Claw") and game.Players.LocalPlayer.Character:FindFirstChild("Electric Claw").Level.Value >= 400 then
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon")
								end
							else
								game.StarterGui:SetCore("SendNotification", {
									Title = "Notification", 
									Text = "Not Have Electric Claw" ,
									Icon = "http://www.roblox.com/asset/?id=",
									Duration = 2.5
								})
							end
							if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon",true) == 1 then
								if game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Talon") and game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Talon").Level.Value >= 400 or game.Players.LocalPlayer.Character:FindFirstChild("Dragon Talon") and game.Players.LocalPlayer.Character:FindFirstChild("Dragon Talon").Level.Value >= 400 then
									if string.find(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman",true), "Bring") then
										game.StarterGui:SetCore("SendNotification", {
											Title = "Notification", 
											Text = "Not Have Enough Material" ,
											Icon = "http://www.roblox.com/asset/?id=",
											Duration = 2.5
										})
									else
										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman")
									end
								end
							else
								game.StarterGui:SetCore("SendNotification", {
									Title = "Notification", 
									Text = "Not Have Dragon Talon" ,
									Icon = "http://www.roblox.com/asset/?id=",
									Duration = 2.5
								})
							end
						else
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySuperhuman")
						end
					end)
				end
			end
		end)


		Items:Label("\\\\ Material //")

		Items:Toggle("Auto Radioactive Material",false,function(value)
			Radioactive = value
			StopTween(Radioactive)
			end)
			
			local MaterialsPos1 = CFrame.new(-507.7895202636719, 72.99479675292969, -126.45632934570312)
			spawn(function()
					while wait() do
						if Radioactive and World2 then
							pcall(function()
								if game:GetService("Workspace").Enemies:FindFirstChild("Factory Staff [Lv. 800]") then
									for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
										if v.Name == "Factory Staff [Lv. 800]" then
											if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
												repeat task.wait()
													AutoHaki()
													EquipWeapon(_G.SelectWeapon)
													v.HumanoidRootPart.CanCollide = false
													v.Humanoid.WalkSpeed = 0
													v.Head.CanCollide = false 
													MakoriGayMag = true
													PosGay = v.HumanoidRootPart.CFrame
													topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
													game:GetService("VirtualUser"):CaptureController()
													game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
												until not Radioactive or not v.Parent or v.Humanoid.Health <= 0
												MakoriGayMag = false
											end
										end
									end
								else
								if BypassTP then
									elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - MaterialsPos1.Position).Magnitude > 1500 then
									BTP(MaterialsPos1)
								else
									topos(MaterialsPos1)
								end
								topos(CFrame.new(-507.7895202636719, 72.99479675292969, -126.45632934570312))
									if game:GetService("ReplicatedStorage"):FindFirstChild("Factory Staff [Lv. 800]") then
										topos(game:GetService("ReplicatedStorage"):FindFirstChild("Factory Staff [Lv. 800]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
									else
										if _G.StardHop then
											Hop()
										end
									end
								end
							end)
						end
					end
				end)
				
				Items:Toggle("Auto Mystic Droplet",false,function(value)
			_G.Makori_gay = value
			StopTween(_G.Makori_gay)
			end)
			
			local MaterialsPos2 = CFrame.new(-3352.9013671875, 285.01556396484375, -10534.841796875)
			spawn(function()
					while wait() do
						if _G.Makori_gay and World2 then
							pcall(function()
								if game:GetService("Workspace").Enemies:FindFirstChild("Water Fighter [Lv. 1450]") then
									for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
										if v.Name == "Water Fighter [Lv. 1450]" then
											if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
												repeat task.wait()
													AutoHaki()
													EquipWeapon(_G.SelectWeapon)
													v.HumanoidRootPart.CanCollide = false
													v.Humanoid.WalkSpeed = 0
													v.Head.CanCollide = false 
													MakoriGayMag = true
													PosGay = v.HumanoidRootPart.CFrame
													topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
													game:GetService("VirtualUser"):CaptureController()
													game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
												until not _G.Makori_gay or not v.Parent or v.Humanoid.Health <= 0
												MakoriGayMag = false
											end
										end
									end
								else
								if BypassTP then
									elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - MaterialsPos2.Position).Magnitude > 1500 then
									BTP(MaterialsPos2)
								else
									topos(MaterialsPos2)
								end
								topos(CFrame.new(-3352.9013671875, 285.01556396484375, -10534.841796875))
									if game:GetService("ReplicatedStorage"):FindFirstChild("Water Fighter [Lv. 1450]") then
										topos(game:GetService("ReplicatedStorage"):FindFirstChild("Water Fighter [Lv. 1450]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
									else
										if _G.StardHop then
											Hop()
										end
									end
								end
							end)
						end
					end
				end)
				
				Items:Toggle("Auto Magma Ore",_G.Makori_gay,function(value)
			_G.Umm = value
			StopTween(_G.Umm)
			end)
			
			local MaterialsPos3 = CFrame.new(-5850.2802734375, 77.28675079345703, 8848.6748046875)
			spawn(function()
					while wait() do
						if _G.Umm and World1 then
							pcall(function()
								if game:GetService("Workspace").Enemies:FindFirstChild("Military Spy [Lv. 325]") then
									for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
										if v.Name == "Military Spy [Lv. 325]" then
											if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
												repeat task.wait()
													AutoHaki()
													EquipWeapon(_G.SelectWeapon)
													v.HumanoidRootPart.CanCollide = false
													v.Humanoid.WalkSpeed = 0
													v.Head.CanCollide = false 
													MakoriGayMag = true
													PosGay = v.HumanoidRootPart.CFrame
													topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
													game:GetService("VirtualUser"):CaptureController()
													game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
												until not _G.Umm or not v.Parent or v.Humanoid.Health <= 0
												MakoriGayMag = false
											end
										end
									end
								else
								if BypassTP then
									elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - MaterialsPos3.Position).Magnitude > 1500 then
									BTP(MaterialsPos3)
								else
									topos(MaterialsPos3)
								end
								topos(CFrame.new(-5850.2802734375, 77.28675079345703, 8848.6748046875))
									if game:GetService("ReplicatedStorage"):FindFirstChild("Military Spy [Lv. 325]") then
										topos(game:GetService("ReplicatedStorage"):FindFirstChild("Military Spy [Lv. 325]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
									else
										if _G.StardHop then
											Hop()
										end
									end
								end
							end)
						end
					end
				end)
			   
			local MaterialsPos4 = CFrame.new(-5234.60595703125, 51.953372955322266, -4732.27880859375)
			spawn(function()
					while wait() do
						if _G.Umm and World2 then
							pcall(function()
								if game:GetService("Workspace").Enemies:FindFirstChild("Lava Pirate [Lv. 1200]") then
									for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
										if v.Name == "Lava Pirate [Lv. 1200]" then
											if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
												repeat task.wait()
													AutoHaki()
													EquipWeapon(_G.SelectWeapon)
													v.HumanoidRootPart.CanCollide = false
													v.Humanoid.WalkSpeed = 0
													v.Head.CanCollide = false 
													MakoriGayMag = true
													PosGay = v.HumanoidRootPart.CFrame
													topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
													game:GetService("VirtualUser"):CaptureController()
													game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
												until not _G.Umm or not v.Parent or v.Humanoid.Health <= 0
												MakoriGayMag = false
											end
										end
									end
								else
								if BypassTP then
									elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - MaterialsPos4.Position).Magnitude > 1500 then
									BTP(MaterialsPos4)
								else
									topos(MaterialsPos4)
								end
								topos(CFrame.new(-5234.60595703125, 51.953372955322266, -4732.27880859375))
									if game:GetService("ReplicatedStorage"):FindFirstChild("Lava Pirate [Lv. 1200]") then
										topos(game:GetService("ReplicatedStorage"):FindFirstChild("Lava Pirate [Lv. 1200]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
									else
										if _G.StardHop then
											Hop()
										end
									end
								end
							end)
						end
					end
				end)
				
				Items:Toggle("Auto Angel Wing",_G.Makori_gay,function(value)
			_G.Auto_Wing = value
			StopTween(_G.Auto_Wing)
			end)
			
			local MaterialsPos5 = CFrame.new(-7827.15625, 5606.912109375, -1705.5833740234375)
			spawn(function()
					while wait() do
						if _G.Auto_Wing and World1 then
							pcall(function()
								if game:GetService("Workspace").Enemies:FindFirstChild("Royal Soldier [Lv. 550]") then
									for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
										if v.Name == "Royal Soldier [Lv. 550]" then
											if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
												repeat task.wait()
													AutoHaki()
													EquipWeapon(_G.SelectWeapon)
													v.HumanoidRootPart.CanCollide = false
													v.Humanoid.WalkSpeed = 0
													v.Head.CanCollide = false 
													MakoriGayMag = true
													PosGay = v.HumanoidRootPart.CFrame
													topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
													game:GetService("VirtualUser"):CaptureController()
													game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
												until not _G.Auto_Wing or not v.Parent or v.Humanoid.Health <= 0
												MakoriGayMag = false
											end
										end
									end
								else
								if BypassTP then
									elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - MaterialsPos5.Position).Magnitude > 1500 then
									BTP(MaterialsPos5)
								else
									topos(MaterialsPos5)
								end
								topos(CFrame.new(-7827.15625, 5606.912109375, -1705.5833740234375))
									if game:GetService("ReplicatedStorage"):FindFirstChild("Royal Soldier [Lv. 550]") then
										topos(game:GetService("ReplicatedStorage"):FindFirstChild("Royal Soldier [Lv. 550]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
									else
										if _G.StardHop then
											Hop()
										end
									end
								end
							end)
						end
					end
				end)
				
				Items:Toggle("Auto Leather",_G.Makori_gay,function(value)
			_G.Leather = value
			StopTween(_G.Leather)
			end)
			
			local MaterialsPos6 = CFrame.new(-1211.8792724609375, 4.787090301513672, 3916.83056640625)
			spawn(function()
					while wait() do
						if _G.Leather and World1 then
							pcall(function()
								if game:GetService("Workspace").Enemies:FindFirstChild("Pirate [Lv. 36]") then
									for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
										if v.Name == "Pirate [Lv. 36]" then
											if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
												repeat task.wait()
													AutoHaki()
													EquipWeapon(_G.SelectWeapon)
													v.HumanoidRootPart.CanCollide = false
													v.Humanoid.WalkSpeed = 0
													v.Head.CanCollide = false 
													MakoriGayMag = true
													PosGay = v.HumanoidRootPart.CFrame
													topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
													game:GetService("VirtualUser"):CaptureController()
													game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
												until not _G.Leather or not v.Parent or v.Humanoid.Health <= 0
												MakoriGayMag = false
											end
										end
									end
								else
								if BypassTP then
									elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - MaterialsPos6.Position).Magnitude > 1500 then
									BTP(MaterialsPos6)
								else
									topos(MaterialsPos6)
								end
								topos(CFrame.new(-1211.8792724609375, 4.787090301513672, 3916.83056640625))
									if game:GetService("ReplicatedStorage"):FindFirstChild("Pirate [Lv. 36]") then
										topos(game:GetService("ReplicatedStorage"):FindFirstChild("Pirate [Lv. 36]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
									else
										if _G.StardHop then
											Hop()
										end
									end
								end
							end)
						end
					end
				end)
				
				local MaterialsPos7 = CFrame.new(-2010.5059814453125, 73.00115966796875, -3326.620849609375)
				spawn(function()
					while wait() do
						if _G.Leather and World2 then
							pcall(function()
								if game:GetService("Workspace").Enemies:FindFirstChild("Marine Captain [Lv. 900]") then
									for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
										if v.Name == "Marine Captain [Lv. 900]" then
											if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
												repeat task.wait()
													AutoHaki()
													EquipWeapon(_G.SelectWeapon)
													v.HumanoidRootPart.CanCollide = false
													v.Humanoid.WalkSpeed = 0
													v.Head.CanCollide = false 
													MakoriGayMag = true
													PosGay = v.HumanoidRootPart.CFrame
													topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
													game:GetService("VirtualUser"):CaptureController()
													game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
												until not _G.Leather or not v.Parent or v.Humanoid.Health <= 0
												MakoriGayMag = false
											end
										end
									end
								else
								if BypassTP then
									elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - MaterialsPos7.Position).Magnitude > 1500 then
									BTP(MaterialsPos7)
								else
									topos(MaterialsPos7)
								end
								topos(CFrame.new(-2010.5059814453125, 73.00115966796875, -3326.620849609375))
									if game:GetService("ReplicatedStorage"):FindFirstChild("Marine Captain [Lv. 900]") then
										topos(game:GetService("ReplicatedStorage"):FindFirstChild("Marine Captain [Lv. 900]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
									else
										if _G.StardHop then
											Hop()
										end
									end
								end
							end)
						end
					end
				end)
				
				local MaterialsPos8 = CFrame.new(-11975.78515625, 331.7734069824219, -10620.0302734375)
				spawn(function()
					while wait() do
						if _G.Leather and World3 then
							pcall(function()
								if game:GetService("Workspace").Enemies:FindFirstChild("Jungle Pirate [Lv. 1900]") then
									for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
										if v.Name == "Jungle Pirate [Lv. 1900]" then
											if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
												repeat task.wait()
													AutoHaki()
													EquipWeapon(_G.SelectWeapon)
													v.HumanoidRootPart.CanCollide = false
													v.Humanoid.WalkSpeed = 0
													v.Head.CanCollide = false 
													MakoriGayMag = true
													PosGay = v.HumanoidRootPart.CFrame
													topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
													game:GetService("VirtualUser"):CaptureController()
													game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
												until not _G.Leather or not v.Parent or v.Humanoid.Health <= 0
												MakoriGayMag = false
											end
										end
									end
								else
								if BypassTP then
									elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - MaterialsPos8.Position).Magnitude > 1500 then
									BTP(MaterialsPos8)
								else
									topos(MaterialsPos8)
								end
								topos(CFrame.new(-11975.78515625, 331.7734069824219, -10620.0302734375))
									if game:GetService("ReplicatedStorage"):FindFirstChild("Jungle Pirate [Lv. 1900]") then
										topos(game:GetService("ReplicatedStorage"):FindFirstChild("Jungle Pirate [Lv. 1900]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
									else
										if _G.StardHop then
											Hop()
										end
									end
								end
							end)
						end
					end
				end)
				
				Items:Toggle("Auto Scrap Metal",false,function(value)
			Scrap = value
			StopTween(Scrap)
			end)
			
			local MaterialsPos9 = CFrame.new(-1132.4202880859375, 14.844913482666016, 4293.30517578125)
			spawn(function()
					while wait() do
						if Scrap and World1 then
							pcall(function()
								if game:GetService("Workspace").Enemies:FindFirstChild("Brute [Lv. 45]") then
									for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
										if v.Name == "Brute [Lv. 45]" then
											if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
												repeat task.wait()
													AutoHaki()
													EquipWeapon(_G.SelectWeapon)
													v.HumanoidRootPart.CanCollide = false
													v.Humanoid.WalkSpeed = 0
													v.Head.CanCollide = false 
													MakoriGayMag = true
													PosGay = v.HumanoidRootPart.CFrame
													topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
													game:GetService("VirtualUser"):CaptureController()
													game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
												until not Scrap or not v.Parent or v.Humanoid.Health <= 0
												MakoriGayMag = false
											end
										end
									end
								else
								if BypassTP then
									elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - MaterialsPos9.Position).Magnitude > 1500 then
									BTP(MaterialsPos9)
								else
									topos(MaterialsPos9)
								end
								topos(CFrame.new(-1132.4202880859375, 14.844913482666016, 4293.30517578125))
									if game:GetService("ReplicatedStorage"):FindFirstChild("Brute [Lv. 45]") then
										topos(game:GetService("ReplicatedStorage"):FindFirstChild("Brute [Lv. 45]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
									else
										if _G.StardHop then
											Hop()
										end
									end
								end
							end)
						end
					end
				end)
				
				local MaterialsPos10 = CFrame.new(-972.307373046875, 73.04473876953125, 1419.2901611328125)
				spawn(function()
					while wait() do
						if Scrap and World2 then
							pcall(function()
								if game:GetService("Workspace").Enemies:FindFirstChild("Mercenary [Lv. 725]") then
									for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
										if v.Name == "Mercenary [Lv. 725]" then
											if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
												repeat task.wait()
													AutoHaki()
													EquipWeapon(_G.SelectWeapon)
													v.HumanoidRootPart.CanCollide = false
													v.Humanoid.WalkSpeed = 0
													v.Head.CanCollide = false 
													MakoriGayMag = true
													PosGay = v.HumanoidRootPart.CFrame
													topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
													game:GetService("VirtualUser"):CaptureController()
													game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
												until not Scrap or not v.Parent or v.Humanoid.Health <= 0
												MakoriGayMag = false
											end
										end
									end
								else
								if BypassTP then
									elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - MaterialsPos10.Position).Magnitude > 1500 then
									BTP(MaterialsPos10)
								else
									topos(MaterialsPos10)
								end
								topos(CFrame.new(-972.307373046875, 73.04473876953125, 1419.2901611328125))
									if game:GetService("ReplicatedStorage"):FindFirstChild("Mercenary [Lv. 725]") then
										topos(game:GetService("ReplicatedStorage"):FindFirstChild("Mercenary [Lv. 725]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
									else
										if _G.StardHop then
											Hop()
										end
									end
								end
							end)
						end
					end
				end)
				
				local MaterialsPos11 = CFrame.new(-289.6311950683594, 43.8282470703125, 5583.66357421875)
				spawn(function()
					while wait() do
						if Scrap and World3 then
							pcall(function()
								if game:GetService("Workspace").Enemies:FindFirstChild("Pirate Millionaire [Lv. 1500]") then
									for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
										if v.Name == "Pirate Millionaire [Lv. 1500]" then
											if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
												repeat task.wait()
													AutoHaki()
													EquipWeapon(_G.SelectWeapon)
													v.HumanoidRootPart.CanCollide = false
													v.Humanoid.WalkSpeed = 0
													v.Head.CanCollide = false 
													MakoriGayMag = true
													PosGay = v.HumanoidRootPart.CFrame
													topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
													game:GetService("VirtualUser"):CaptureController()
													game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
												until not Scrap or not v.Parent or v.Humanoid.Health <= 0
												MakoriGayMag = false
											end
										end
									end
								else
								if BypassTP then
									elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - MaterialsPos11.Position).Magnitude > 1500 then
									BTP(MaterialsPos11)
								else
									topos(MaterialsPos11)
								end
								topos(CFrame.new(-289.6311950683594, 43.8282470703125, 5583.66357421875))
									if game:GetService("ReplicatedStorage"):FindFirstChild("Pirate Millionaire [Lv. 1500]") then
										topos(game:GetService("ReplicatedStorage"):FindFirstChild("Pirate Millionaire [Lv. 1500]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
									else
										if _G.StardHop then
											Hop()
										end
									end
								end
							end)
						end
					end
				end)
				
				Items:Toggle("Auto Cocoa",false,function(value)
			Cocoafarm = value
			StopTween(Cocoafarm)
			end)
			
			local MaterialsPos12 = CFrame.new(744.7930908203125, 24.76934242248535, -12637.7255859375)
			spawn(function()
					while wait() do
						if Cocoafarm and World3 then
							pcall(function()
								if game:GetService("Workspace").Enemies:FindFirstChild("Chocolate Bar Battler [Lv. 2325]") then
									for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
										if v.Name == "Chocolate Bar Battler [Lv. 2325]" then
											if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
												repeat task.wait()
													AutoHaki()
													EquipWeapon(_G.SelectWeapon)
													v.HumanoidRootPart.CanCollide = false
													v.Humanoid.WalkSpeed = 0
													v.Head.CanCollide = false 
													MakoriGayMag = true
													PosGay = v.HumanoidRootPart.CFrame
													topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
													game:GetService("VirtualUser"):CaptureController()
													game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
												until not Cocoafarm or not v.Parent or v.Humanoid.Health <= 0
												MakoriGayMag = false
											end
										end
									end
								else
								if BypassTP then
								wait(3)
									elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - MaterialsPos12.Position).Magnitude > 1500 then
									BTP(MaterialsPos12)
								else
									topos(MaterialsPos12)
								end
								topos(CFrame.new(744.7930908203125, 24.76934242248535, -12637.7255859375))
									if game:GetService("ReplicatedStorage"):FindFirstChild("Chocolate Bar Battler [Lv. 2325]") then
										topos(game:GetService("ReplicatedStorage"):FindFirstChild("Chocolate Bar Battler [Lv. 2325]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
									else
										if _G.StardHop then
											Hop()
										end
									end
								end
							end)
						end
					end
				end)
				
				Items:Toggle("Auto Dragon Scale",false,function(value)
			Dragon_Scale = value
			StopTween(Dragon_Scale)
			end)
			
			local MaterialsPos13 = CFrame.new(5824.06982421875, 51.38640213012695, -1106.694580078125)
			spawn(function()
					while wait() do
						if Dragon_Scale and World3 then
							pcall(function()
								if game:GetService("Workspace").Enemies:FindFirstChild("Dragon Crew Warrior [Lv. 1575]") then
									for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
										if v.Name == "Dragon Crew Warrior [Lv. 1575]" then
											if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
												repeat task.wait()
													AutoHaki()
													EquipWeapon(_G.SelectWeapon)
													v.HumanoidRootPart.CanCollide = false
													v.Humanoid.WalkSpeed = 0
													v.Head.CanCollide = false 
													MakoriGayMag = true
													PosGay = v.HumanoidRootPart.CFrame
													topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
													game:GetService("VirtualUser"):CaptureController()
													game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
												until not Dragon_Scale or not v.Parent or v.Humanoid.Health <= 0
												MakoriGayMag = false
											end
										end
									end
								else
								if BypassTP then
								wait(3)
									elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - MaterialsPos13.Position).Magnitude > 1500 then
									BTP(MaterialsPos13)
								else
									topos(MaterialsPos13)
								end
								topos(CFrame.new(5824.06982421875, 51.38640213012695, -1106.694580078125))
									if game:GetService("ReplicatedStorage"):FindFirstChild("Dragon Crew Warrior [Lv. 1575]") then
										topos(game:GetService("ReplicatedStorage"):FindFirstChild("Dragon Crew Warrior [Lv. 1575]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
									else
										if _G.StardHop then
											Hop()
										end
									end
								end
							end)
						end
					end
				end)
				
				Items:Toggle("Auto Gunpowder",false,function(value)
			Gunpowder = value
			StopTween(Gunpowder)
			end)
			
			local MaterialsPos14 = CFrame.new(-379.6134338378906, 73.84449768066406, 5928.5263671875)
			spawn(function()
					while wait() do
						if Gunpowder and World3 then
							pcall(function()
								if game:GetService("Workspace").Enemies:FindFirstChild("Pistol Billionaire [Lv. 1525]") then
									for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
										if v.Name == "Pistol Billionaire [Lv. 1525]" then
											if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
												repeat task.wait()
													AutoHaki()
													EquipWeapon(_G.SelectWeapon)
													v.HumanoidRootPart.CanCollide = false
													v.Humanoid.WalkSpeed = 0
													v.Head.CanCollide = false 
													MakoriGayMag = true
													PosGay = v.HumanoidRootPart.CFrame
													topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
													game:GetService("VirtualUser"):CaptureController()
													game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
												until not Gunpowder or not v.Parent or v.Humanoid.Health <= 0
												MakoriGayMag = false
											end
										end
									end
								else
								if BypassTP then
									elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - MaterialsPos14.Position).Magnitude > 1500 then
									BTP(MaterialsPos14)
								else
									topos(MaterialsPos14)
								end
								topos(CFrame.new(-379.6134338378906, 73.84449768066406, 5928.5263671875))
									if game:GetService("ReplicatedStorage"):FindFirstChild("Pistol Billionaire [Lv. 1525]") then
										topos(game:GetService("ReplicatedStorage"):FindFirstChild("Pistol Billionaire [Lv. 1525]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
									else
										if _G.StardHop then
											Hop()
										end
									end
								end
							end)
						end
					end
				end)
				
				Items:Toggle("Auto Fish Tail",false,function(value)
			Fish = value
			StopTween(Fish)
			end)
			
			local MaterialsPos15 = CFrame.new(-10961.0126953125, 331.7977600097656, -8914.29296875)
			spawn(function()
					while wait() do
						if Fish and World3 then
							pcall(function()
								if game:GetService("Workspace").Enemies:FindFirstChild("Fishman Captain [Lv. 1800]") then
									for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
										if v.Name == "Fishman Captain [Lv. 1800]" then
											if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
												repeat task.wait()
													AutoHaki()
													EquipWeapon(_G.SelectWeapon)
													v.HumanoidRootPart.CanCollide = false
													v.Humanoid.WalkSpeed = 0
													v.Head.CanCollide = false 
													MakoriGayMag = true
													PosGay = v.HumanoidRootPart.CFrame
													topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
													game:GetService("VirtualUser"):CaptureController()
													game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
												until not Fish or not v.Parent or v.Humanoid.Health <= 0
												MakoriGayMag = false
											end
										end
									end
								else
								if BypassTP then
								wait(3)
									elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - MaterialsPos15.Position).Magnitude > 1500 then
									BTP(MaterialsPos15)
								else
									topos(MaterialsPos15)
								end
								topos(CFrame.new(-10961.0126953125, 331.7977600097656, -8914.29296875))
									if game:GetService("ReplicatedStorage"):FindFirstChild("Fishman Captain [Lv. 1800]") then
										topos(game:GetService("ReplicatedStorage"):FindFirstChild("Fishman Captain [Lv. 1800]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
									else
										if _G.StardHop then
											Hop()
										end
									end
								end
							end)
						end
					end
				end)
				
				Items:Toggle("Auto Mini Tusk",false,function(value)
			MiniHee = value
			StopTween(MiniHee)
			end)
			
			local MaterialsPos16 = CFrame.new(-13516.0458984375, 469.8182373046875, -6899.16064453125)
			spawn(function()
					while wait() do
						if MiniHee and World3 then
							pcall(function()
								if game:GetService("Workspace").Enemies:FindFirstChild("Mythological Pirate [Lv. 1850]") then
									for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
										if v.Name == "Mythological Pirate [Lv. 1850]" then
											if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
												repeat task.wait()
													AutoHaki()
													EquipWeapon(_G.SelectWeapon)
													v.HumanoidRootPart.CanCollide = false
													v.Humanoid.WalkSpeed = 0
													v.Head.CanCollide = false 
													MakoriGayMag = true
													PosGay = v.HumanoidRootPart.CFrame
													topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
													game:GetService("VirtualUser"):CaptureController()
													game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
												until not MiniHee or not v.Parent or v.Humanoid.Health <= 0
												MakoriGayMag = false
											end
										end
									end
								else
								if BypassTP then
									elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - MaterialsPos16.Position).Magnitude > 1500 then
									BTP(MaterialsPos16)
								else
									topos(MaterialsPos16)
								end
								topos(CFrame.new(-13516.0458984375, 469.8182373046875, -6899.16064453125))
									if game:GetService("ReplicatedStorage"):FindFirstChild("Mythological Pirate [Lv. 1850]") then
										topos(game:GetService("ReplicatedStorage"):FindFirstChild("Mythological Pirate [Lv. 1850]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
									else
										if _G.StardHop then
											Hop()
										end
									end
								end
							end)
						end
					end
				end)

Items:Label("\\\\ Auto Sea Beast //")

if World2 or World3 then 
    Items:Toggle('Auto Summon Sea Beast (Beta)',false, function(value)
		_G.dao1 = value
    
    
		if _G.dao1 then
		local args = {
			[1] = "requestEntrance",
			[2] = Vector3.new(-12463.6025390625, 378.3270568847656, -7566.0830078125)
		}
		
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		wait(1)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5411.22021, 778.609863, -2682.27759, 0.927179396, 0, 0.374617696, 0, 1, 0, -0.374617696, 0, 0.927179396)
		wait(0)
		-- Script generated by SimpleSpy - credits to exx#9394
		
		local args = {
			[1] = "BuyBoat",
			[2] = "PirateBrigade"
		}
		
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		
		function two(gotoCFrame) --- Tween
			  pcall(function()
				  game.Players.LocalPlayer.Character.Humanoid.Sit = false
				  game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
			  end)
			  if (game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart.Position - gotoCFrame.Position).Magnitude <= 200 then
				  pcall(function() 
					  tweenz:Cancel()
				  end)
				  game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart.CFrame = gotoCFrame
			  else
				  local tween_s = game:service"TweenService"
				  local info = TweenInfo.new((game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart.Position - gotoCFrame.Position).Magnitude/325, Enum.EasingStyle.Linear)
				   tween, err = pcall(function()
					  tweenz = tween_s:Create(game.Players.LocalPlayer.Character["HumanoidRootPart"], info, {CFrame = gotoCFrame})
					  tweenz:Play()
				  end)
				  if not tween then return err end
			  end
			  function _TweenCanCle()
				  tweenz:Cancel()
			  end
		  
		end
		two(CFrame.new(-5100.7085, 29.968586, -6792.45459, -0.33648631, -0.0396691673, 0.940852463, -6.40461678e-07, 0.999112308, 0.0421253517, -0.941688359, 0.0141740013, -0.336187631))
		
		wait(13)
		for _,v in next, workspace.Boats.PirateBrigade:GetDescendants() do
			if v.Name:find("VehicleSeat") then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
			 if game:GetService("Workspace").Map:FindFirstChild("MysticIsland") then
								   topos(game:GetService("Workspace").Map:FindFirstChild("MysticIsland").HumanoidRootPart.CFrame * CFrame.new(0,500,-100))
		   
			end
			end
		end
		end
		end)
end		

Items:Label("\\\\ Items/Quest //")

if World3 then
Items:Toggle("Auto Buddy Sword",_G.AutoBudySword,function(value)
        _G.AutoBudySword = value
        StopTween(_G.AutoBudySword)
    end)
    

    
    local BigMomPos = CFrame.new(-731.2034301757812, 381.5658874511719, -11198.4951171875)
    spawn(function()
        while wait() do
            if _G.AutoBudySword and World3 then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Cake Queen [Lv. 2175] [Boss]") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Cake Queen [Lv. 2175] [Boss]" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.AutoBudySword or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                    if BypassTP then
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - BigMomPos.Position).Magnitude > 1500 then
						BTP(BigMomPos)
					else
						topos(BigMomPos)
					end
                    topos(CFrame.new(-731.2034301757812, 381.5658874511719, -11198.4951171875))
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Cake Queen [Lv. 2175] [Boss]") then
                            topos(game:GetService("ReplicatedStorage"):FindFirstChild("Cake Queen [Lv. 2175] [Boss]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                        else
                            if _G.AutoBudySwordHop then
                                Hop()
                            end
                        end
                    end
                end)
            end
        end
    end)
	end
    
    if World3 then
    Items:Toggle("Auto Soul Guitar",_G.AutoNevaSoulGuitar,function(value)
  _G.AutoNevaSoulGuitar = value    
 StopTween(_G.AutoNevaSoulGuitar)
 end)

spawn(function()
		while wait() do
			pcall(function()
				if _G.AutoNevaSoulGuitar then
					if GetWeaponInventory("Soul Guitar") == false then
						if (CFrame.new(-9681.458984375, 6.139880657196045, 6341.3720703125).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 5000 then
							if game:GetService("Workspace").NPCs:FindFirstChild("Skeleton Machine") then
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("soulGuitarBuy",true)
							else
								if game:GetService("Workspace").Map["Haunted Castle"].Candle1.Transparency == 0 then
									if game:GetService("Workspace").Map["Haunted Castle"].Placard1.Left.Part.Transparency == 0 then
										Quest2 = true
										repeat wait() topos(CFrame.new(-8762.69140625, 176.84783935546875, 6171.3076171875)) until (CFrame.new(-8762.69140625, 176.84783935546875, 6171.3076171875).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.AutoNevaSoulGuitar
										wait(1)
										fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Placard7.Left.ClickDetector)
										wait(1)
										fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Placard6.Left.ClickDetector)
										wait(1)
										fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Placard5.Left.ClickDetector)
										wait(1)
										fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Placard4.Right.ClickDetector)
										wait(1)
										fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Placard3.Left.ClickDetector)
										wait(1)
										fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Placard2.Right.ClickDetector)
										wait(1)
										fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Placard1.Right.ClickDetector)
										wait(1)
									elseif game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment1:FindFirstChild("ClickDetector") then
										if game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part1:FindFirstChild("ClickDetector") then
											Quest4 = true
											repeat wait() topos(CFrame.new(-9553.5986328125, 65.62338256835938, 6041.58837890625)) until (CFrame.new(-9553.5986328125, 65.62338256835938, 6041.58837890625).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.AutoNevaSoulGuitar
											wait(1)
											topos(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part3.CFrame)
											wait(1)
											fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part3.ClickDetector)
											wait(1)
											topos(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.CFrame)
											wait(1)
											fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.ClickDetector)
											wait(1)
											fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.ClickDetector)
											wait(1)
											fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.ClickDetector)
											wait(1)
											topos(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part6.CFrame)
											wait(1)
											fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part6.ClickDetector)
											wait(1)
											fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part6.ClickDetector)
											wait(1)
											topos(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part8.CFrame)
											wait(1)
											fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part8.ClickDetector)
											wait(1)
											topos(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.CFrame)
											wait(1)
											fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.ClickDetector)
											wait(1)
											fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.ClickDetector)
											wait(1)
											fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.ClickDetector)
										else
											Quest3 = true
											--Not Work Yet
										end
									else
										if game:GetService("Workspace").NPCs:FindFirstChild("Ghost") then
											local args = {
												[1] = "GuitarPuzzleProgress",
												[2] = "Ghost"
											}

											game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
										end
										if game.Workspace.Enemies:FindFirstChild("Living Zombie [Lv. 2000]") then
											for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
												if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
													if v.Name == "Living Zombie [Lv. 2000]" then
														EquipWeapon(_G.SelectWeapon)
														v.HumanoidRootPart.Size = Vector3.new(60,60,60)
														v.HumanoidRootPart.Transparency = 1
														v.Humanoid.JumpPower = 0
														v.Humanoid.WalkSpeed = 0
														v.HumanoidRootPart.CanCollide = false
														v.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,20,0)
														topos(CFrame.new(-10160.787109375, 138.6616973876953, 5955.03076171875))
														game:GetService'VirtualUser':CaptureController()
														game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
													end
												end
											end
										else
											topos(CFrame.new(-10160.787109375, 138.6616973876953, 5955.03076171875))
										end
									end
								else    
									if string.find(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("gravestoneEvent",2), "Error") then
										print("Go to Grave")
										topos(CFrame.new(-8653.2060546875, 140.98487854003906, 6160.033203125))
									elseif string.find(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("gravestoneEvent",2), "Nothing") then
										print("Wait Next Night")
									else
										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("gravestoneEvent",2,true)
									end
								end
							end
						else
							topos(CFrame.new(-9681.458984375, 6.139880657196045, 6341.3720703125))
	end
	else
if _G.soulGuitarhop then
hop()
end
						end
					end
			end)
		end
end)
end 

if World3 then
 Items:Toggle("Auto CDK",_G.AutoCdk,function(value)
 Auto_Cursed_Dual_Katana = value
StopTween(Auto_Cursed_Dual_Katana)
end)

spawn(function()
		while wait() do
			pcall(function()
				if Auto_Cursed_Dual_Katana then
					if GetMaterial("Alucard Fragment") == 0 then
						Auto_Quest_Yama_1 = true
						Auto_Quest_Yama_2 = false
						Auto_Quest_Yama_3 = false
						Auto_Quest_Tushita_1 = false
						Auto_Quest_Tushita_2 = false
						Auto_Quest_Tushita_3 = false
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","Progress","Evil")
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Evil")
					elseif GetMaterial("Alucard Fragment") == 1 then
						Auto_Quest_Yama_1 = false
						Auto_Quest_Yama_2 = true
						Auto_Quest_Yama_3 = false
						Auto_Quest_Tushita_1 = false
						Auto_Quest_Tushita_2 = false
						Auto_Quest_Tushita_3 = false
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","Progress","Evil")
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Evil")
					elseif GetMaterial("Alucard Fragment") == 2 then
						Auto_Quest_Yama_1 = false
						Auto_Quest_Yama_2 = false
						Auto_Quest_Yama_3 = true
						Auto_Quest_Tushita_1 = false
						Auto_Quest_Tushita_2 = false
						Auto_Quest_Tushita_3 = false
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","Progress","Evil")
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Evil")
					elseif GetMaterial("Alucard Fragment") == 3 then
						Auto_Quest_Yama_1 = false
						Auto_Quest_Yama_2 = false
						Auto_Quest_Yama_3 = false
						Auto_Quest_Tushita_1 = true
						Auto_Quest_Tushita_2 = false
						Auto_Quest_Tushita_3 = false
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","Progress","Good")
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Good")
					elseif GetMaterial("Alucard Fragment") == 4 then
						Auto_Quest_Yama_1 = false
						Auto_Quest_Yama_2 = false
						Auto_Quest_Yama_3 = false
						Auto_Quest_Tushita_1 = false
						Auto_Quest_Tushita_2 = true
						Auto_Quest_Tushita_3 = false
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","Progress","Good")
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Good")
					elseif GetMaterial("Alucard Fragment") == 5 then
						Auto_Quest_Yama_1 = false
						Auto_Quest_Yama_2 = false
						Auto_Quest_Yama_3 = false
						Auto_Quest_Tushita_1 = false
						Auto_Quest_Tushita_2 = false
						Auto_Quest_Tushita_3 = true
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","Progress","Good")
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Good")
					elseif GetMaterial("Alucard Fragment") == 6 then
						if game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton Boss [Lv. 2025] [Boss]") or game:GetService("Workspace").ReplicatedStorage:FindFirstChild("Cursed Skeleton Boss [Lv. 2025] [Boss]") then
							Auto_Quest_Yama_1 = false
							Auto_Quest_Yama_2 = false
							Auto_Quest_Yama_3 = false
							Auto_Quest_Tushita_1 = false
							Auto_Quest_Tushita_2 = false
							Auto_Quest_Tushita_3 = false
							if game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton Boss [Lv. 2025] [Boss]") or game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton [Lv. 2200]") then
								for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
									if v.Name == "Cursed Skeleton Boss [Lv. 2025] [Boss]" or v.Name == "Cursed Skeleton [Lv. 2200]" then
										if v.Humanoid.Health > 0 then
											v.HumanoidRootPart.CanCollide = false
											v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
											topos(v.HumanoidRootPart.CFrame * CFrame.new(0,50,0))
											game:GetService'VirtualUser':CaptureController()
											game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
										end
									end
								end
							end
						else
							if (CFrame.new(-12361.7060546875, 603.3547973632812, -6550.5341796875).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 then
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","Progress","Good")
								wait(1)
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","Progress","Evil")
								wait(1)
								topos(CFrame.new(-12361.7060546875, 603.3547973632812, -6550.5341796875))
								wait(1.5)
								game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
								wait(1.5)
								topos(CFrame.new(-12253.5419921875, 598.8999633789062, -6546.8388671875))
							else
								topos(CFrame.new(-12361.7060546875, 603.3547973632812, -6550.5341796875))
							end   
						end
					end
				end
			end)
		end
	end)

	spawn(function()
		while wait() do
			if Auto_Quest_Yama_1 then
				pcall(function()
					if game:GetService("Workspace").Enemies:FindFirstChild("Mythological Pirate [Lv. 1850]") then
						for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if v.Name == "Mythological Pirate [Lv. 1850]" then
								repeat wait()
									topos(v.HumanoidRootPart.CFrame * CFrame.new(0,0,-2))
								until Auto_Cursed_Dual_Katana == false or Auto_Cursed_Dual_Katana == false or Auto_Quest_Yama_1 == false
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Evil")
							end
						end
					else
						topos(CFrame.new(-13451.46484375, 543.712890625, -6961.0029296875))
					end
				end)
			end
		end
	end)

	spawn(function()
		while wait() do
			pcall(function()
				if Auto_Quest_Yama_2 then
					for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
						if v:FindFirstChild("HazeESP") then
							v.HazeESP.Size = UDim2.new(50,50,50,50)
							v.HazeESP.MaxDistance = "inf"
						end
					end
					for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
						if v:FindFirstChild("HazeESP") then
							v.HazeESP.Size = UDim2.new(50,50,50,50)
							v.HazeESP.MaxDistance = "inf"
						end
					end
				end
			end)
		end
	end)

	spawn(function()
		while wait() do
			pcall(function()
				for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
					if Auto_Quest_Yama_2 and v:FindFirstChild("HazeESP") and (v.HumanoidRootPart.Position - PosMonsEsp.Position).magnitude <= 300 then
						v.HumanoidRootPart.CFrame = PosMonsEsp
						v.HumanoidRootPart.CanCollide = false
						v.HumanoidRootPart.Size = Vector3.new(50,50,50)
						if not v.HumanoidRootPart:FindFirstChild("BodyVelocity") then
							local vc = Instance.new("BodyVelocity", v.HumanoidRootPart)
							vc.MaxForce = Vector3.new(1, 1, 1) * math.huge
							vc.Velocity = Vector3.new(0, 0, 0)
						end
					end
				end
			end)
		end
	end)

	spawn(function()
		while wait() do
			if Auto_Quest_Yama_2 then 
				pcall(function() 
					for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
						if v:FindFirstChild("HazeESP") then
							repeat wait()
								if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 2000 then
									topos(y.HumanoidRootPart.CFrameMon * CFrame.new(0,20,0))
								else
									StartMagnet = true
									FastAttack = true
									if Auto_Buso then
										if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
											game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
										end
									end
									if not game.Players.LocalPlayer.Character:FindFirstChild(_G.SelectWeapon) then
										wait()
										EquipWeapon(_G.SelectWeapon)
									end
									PosMonsEsp = v.HumanoidRootPart.CFrame
									if not FastAttack then
										game:GetService'VirtualUser':CaptureController()
										game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
									end
									v.HumanoidRootPart.Size = Vector3.new(60,60,60)
									if _G.Configs["Show Hitbox"] then
										v.HumanoidRootPart.Transparency = _G.Hitbox_LocalTransparency
									else
										v.HumanoidRootPart.Transparency = 1
									end
									v.Humanoid.JumpPower = 0
									v.Humanoid.WalkSpeed = 0
									v.HumanoidRootPart.CanCollide = false
									v.Humanoid:ChangeState(11)
									topos(v.HumanoidRootPart.CFrame * CFrame.new(0,20,0))								
								end      
							until Auto_Cursed_Dual_Katana == false or Auto_Quest_Yama_2 == false or not v.Parent or v.Humanoid.Health <= 0 or not v:FindFirstChild("HazeESP")
						else
							for x,y in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
								if y:FindFirstChild("HazeESP") then
									if (y.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 2000 then
										topos(y.HumanoidRootPart.CFrameMon* CFrame.new(0,20,0))
									else
										topos(y.HumanoidRootPart.CFrame * CFrame.new(0,20,0))
									end
								end
							end
						end
					end
				end)
			end
		end
	end)

	spawn(function()
		while wait() do
			if Auto_Quest_Yama_3 then
				pcall(function()
					if game.Players.LocalPlayer.Backpack:FindFirstChild("Hallow Essence") then         
						_G.Auto_Bone = false           
						topos(game:GetService("Workspace").Map["Haunted Castle"].Summoner.Detection.CFrame)
					elseif game:GetService("Workspace").Map:FindFirstChild("HellDimension") then
						repeat wait()
							if game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton [Lv. 2200]") or game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton [Lv. 2200] [Boss]") or game:GetService("Workspace").Enemies:FindFirstChild("Hell's Messenger [Lv. 2200] [Boss]") then
								for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
									if v.Name == "Cursed Skeleton [Lv. 2200]" or v.Name == "Cursed Skeleton [Lv. 2200] [Boss]" or v.Name == "Hell's Messenger [Lv. 2200] [Boss]" then
										if v.Humanoid.Health > 0 then
											repeat wait()
												StartMagnet = true
												FastAttack = true
												if Auto_Buso then
													if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
														game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
													end
												end
												if not game.Players.LocalPlayer.Character:FindFirstChild(_G.SelectWeapon) then
													wait()
													EquipWeapon(_G.SelectWeapon)
												end
												PosMonsEsp = v.HumanoidRootPart.CFrame
												if not FastAttack then
													game:GetService'VirtualUser':CaptureController()
													game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
												end
												v.HumanoidRootPart.Size = Vector3.new(60,60,60)
												if _G.Configs["Show Hitbox"] then
													v.HumanoidRootPart.Transparency = _G.Hitbox_LocalTransparency
												else
													v.HumanoidRootPart.Transparency = 1
												end
												v.Humanoid.JumpPower = 0
												v.Humanoid.WalkSpeed = 0
												v.HumanoidRootPart.CanCollide = false
												v.Humanoid:ChangeState(11)
												topos(v.HumanoidRootPart.CFrame * CFrame.new(0,50,0))
											until v.Humanoid.Health <= 0 or not v.Parent or Auto_Quest_Yama_3 == false
										end
									end
								end
							else
								wait(5)
								topos(game:GetService("Workspace").Map.HellDimension.Torch1.CFrame)
								wait(1.5)
								game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
								wait(1.5)        
								topos(game:GetService("Workspace").Map.HellDimension.Torch2.CFrame)
								wait(1.5)
								game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
								wait(1.5)     
								topos(game:GetService("Workspace").Map.HellDimension.Torch3.CFrame)
								wait(1.5)
								game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
								wait(1.5)     
								topos(game:GetService("Workspace").Map.HellDimension.Exit.CFrame)
							end
						until Auto_Cursed_Dual_Katana == false or Auto_Quest_Yama_3 == false or GetMaterial("Alucard Fragment") == 3
					else
						if game:GetService("Workspace").Enemies:FindFirstChild("Soul Reaper [Lv. 2100] [Raid Boss]") or game.ReplicatedStorage:FindFirstChild("Soul Reaper [Lv. 2100] [Raid Boss]") then
							if game:GetService("Workspace").Enemies:FindFirstChild("Soul Reaper [Lv. 2100] [Raid Boss]") then
								for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
									if v.Name == "Soul Reaper [Lv. 2100] [Raid Boss]" then
										if v.Humanoid.Health > 0 then
											repeat wait()
												topos(v.HumanoidRootPart.CFrame * CFrame.new(0,0,-2))
											until Auto_Cursed_Dual_Katana == false or Auto_Quest_Yama_3 == false or game:GetService("Workspace").Map:FindFirstChild("HellDimension")
										end
									end
								end
							else
								topos(CFrame.new(-9570.033203125, 315.9346923828125, 6726.89306640625))
							end
						else
							_G.Auto_Bone = true
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones","Buy",1,1)
						end
					end
				end)
			end
		end
	end)

	spawn(function() 
		while wait() do
			if Auto_Quest_Tushita_1 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","BoatQuest",workspace.NPCs:FindFirstChild("Luxury Boat Dealer"))
			end
		end
	end)

	spawn(function()
		while wait() do
			if Auto_Quest_Tushita_1 then
				topos(CFrame.new(-9546.990234375, 21.139892578125, 4686.1142578125))
				wait(5)
				topos(CFrame.new(-6120.0576171875, 16.455780029296875, -2250.697265625))
				wait(5)
				topos(CFrame.new(-9533.2392578125, 7.254445552825928, -8372.69921875))    
			end
		end
	end)

	spawn(function()
		while wait() do
			if Auto_Quest_Tushita_2 then
				pcall(function()
					if (CFrame.new(-5539.3115234375, 313.800537109375, -2972.372314453125).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 500 then
						for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if Auto_Quest_Tushita_2 and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
								if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 2000 then
									repeat wait()
										v.HumanoidRootPart.CanCollide = false
										v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
										topos(v.HumanoidRootPart.CFrame * CFrame.new(0,50,0))
										game:GetService'VirtualUser':CaptureController()
										game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
									until v.Humanoid.Health <= 0 or not v.Parent or Auto_Quest_Tushita_2 == false
								end
							end
						end
					else
						topos(CFrame.new(-5545.1240234375, 313.800537109375, -2976.616455078125))
					end
				end)
			end
		end
	end)

	spawn(function()
		while wait() do
			if Auto_Quest_Tushita_3 then
				pcall(function()
					if game:GetService("Workspace").Enemies:FindFirstChild("Cake Queen [Lv. 2175] [Boss]") or game.ReplicatedStorage:FindFirstChild("Cake Queen [Lv. 2175] [Boss]") then
						if game:GetService("Workspace").Enemies:FindFirstChild("Cake Queen [Lv. 2175] [Boss]") then
							for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
								if v.Name == "Cake Queen [Lv. 2175] [Boss]" then
									if v.Humanoid.Health > 0 then
										repeat wait()
											if Auto_Buso then
												if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
													game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
												end
											end
											if not game.Players.LocalPlayer.Character:FindFirstChild(_G.Select_Weapon) then
												wait()
												EquipWeapon(_G.SelectWeapon)
											end
											if not FastAttack then
												game:GetService'VirtualUser':CaptureController()
												game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
											end
											v.HumanoidRootPart.Size = Vector3.new(60,60,60)
											if _G.Configs["Show Hitbox"] then
												v.HumanoidRootPart.Transparency = _G.Hitbox_LocalTransparency
											else
												v.HumanoidRootPart.Transparency = 1
											end
											v.Humanoid.JumpPower = 0
											v.Humanoid.WalkSpeed = 0
											v.HumanoidRootPart.CanCollide = false
											v.Humanoid:ChangeState(11)
											topos(v.HumanoidRootPart.CFrame * CFrame.new(0,50,0))
										until Auto_Cursed_Dual_Katana == false or Auto_Quest_Tushita_3 == false or game:GetService("Workspace").Map:FindFirstChild("HeavenlyDimension")
									end
								end
							end
						else
							topos(CFrame.new(-709.3132934570312, 381.6005859375, -11011.396484375))
						end
					elseif game:GetService("Workspace").Map:FindFirstChild("HeavenlyDimension") then
						repeat wait()
							if game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton [Lv. 2200]") or game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton [Lv. 2200] [Boss]") or game:GetService("Workspace").Enemies:FindFirstChild("Heaven's Guardian [Lv. 2200] [Boss]") then
								for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
									if v.Name == "Cursed Skeleton [Lv. 2200]" or v.Name == "Cursed Skeleton [Lv. 2200] [Boss]" or v.Name == "Heaven's Guardian [Lv. 2200] [Boss]" then
										if v.Humanoid.Health > 0 then
											repeat wait()
												if Auto_Buso then
													if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
														game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
													end
												end
												if not game.Players.LocalPlayer.Character:FindFirstChild(_G.Select_Weapon) then
													wait()
													EquipWeapon(_G.Select_Weapon)
												end
												if not FastAttack then
													game:GetService'VirtualUser':CaptureController()
													game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
												end
												v.HumanoidRootPart.Size = Vector3.new(60,60,60)
												if _G.Configs["Show Hitbox"] then
													v.HumanoidRootPart.Transparency = _G.Hitbox_LocalTransparency
												else
													v.HumanoidRootPart.Transparency = 1
												end
												v.Humanoid.JumpPower = 0
												v.Humanoid.WalkSpeed = 0
												v.HumanoidRootPart.CanCollide = false
												v.Humanoid:ChangeState(11)
											until v.Humanoid.Health <= 0 or not v.Parent or Auto_Quest_Tushita_3 == false
										end
									end
								end
							else
								wait(5)
								topos(game:GetService("Workspace").Map.HeavenlyDimension.Torch1.CFrame)
								wait(1.5)
								game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
								wait(1.5)        
								topos(game:GetService("Workspace").Map.HeavenlyDimension.Torch2.CFrame)
								wait(1.5)
								game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
								wait(1.5)     
								topos(game:GetService("Workspace").Map.HeavenlyDimension.Torch3.CFrame)
								wait(1.5)
								game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
								wait(1.5)     
								topos(game:GetService("Workspace").Map.HeavenlyDimension.Exit.CFrame)
							end
						until Auto_Cursed_Dual_Katana == false or Auto_Quest_Tushita_3 == false or GetMaterial("Alucard Fragment") == 6
					else
						hop()
					end
				end)
			end
		end
 end)
end

    if World3 then
	Items:Toggle("Auto Tushita", _G.Autotushita,function(value)
         _G.Autotushita = value
        StopTween( _G.Autotushita)
    end)
    

    
    local TushitaPos = CFrame.new(-10238.875976563, 389.7912902832, -9549.7939453125)
    spawn(function()
        while wait() do
            if  _G.Autotushita and World3 then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Longma [Lv. 2000] [Boss]") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Longma [Lv. 2000] [Boss]" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not  _G.Autotushita or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                    if BypassTP then
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - TushitaPos.Position).Magnitude > 1500 then
						BTP(TushitaPos)
					else
						topos(TushitaPos)
					end
                    topos(CFrame.new(-10238.875976563, 389.7912902832, -9549.7939453125))
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Longma [Lv. 2000] [Boss]") then
                            topos(game:GetService("ReplicatedStorage"):FindFirstChild("Longma [Lv. 2000] [Boss]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                        else
                            if  _G.Autotushitahop then
                                Hop()
                            end
                        end
                    end
                end)
            end
        end
    end)
	end


if World3 then
    Items:Toggle("Auto Cavander", _G.AutoCarvender,function(value)
         _G.AutoCarvender = value
        StopTween( _G.AutoCarvender)
    end)
    

    
    local CavandisPos = CFrame.new(5311.07421875, 426.0243835449219, 165.12762451171875)
    spawn(function()
        while wait() do
            if  _G.AutoCarvender and World3 then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Beautiful Pirate [Lv. 1950] [Boss]") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Beautiful Pirate [Lv. 1950] [Boss]" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not  _G.AutoCarvender or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                    if BypassTP then
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CavandisPos.Position).Magnitude > 1500 then
						BTP(CavandisPos)
					else
						topos(CavandisPos)
					end
                    topos(CFrame.new(5311.07421875, 426.0243835449219, 165.12762451171875))
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Beautiful Pirate [Lv. 1950] [Boss]") then
                            topos(game:GetService("ReplicatedStorage"):FindFirstChild("Beautiful Pirate [Lv. 1950] [Boss]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                        else
                            if  _G.AutoCavanderhop then
                                Hop()
                            end
                        end
                    end
                end)
            end
        end
    end)
end

if World3 then
    Items:Toggle("Auto Twin Hook", _G.AutoTwinHook,function(value)
         _G.AutoTwinHook = value
        StopTween( _G.AutoTwinHook)
    end)
    

    
    local ElephantPos = CFrame.new(-13348.0654296875, 405.8904113769531, -8570.62890625)
    spawn(function()
        while wait() do
            if  _G.AutoTwinHook and World3 then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Captain Elephant [Lv. 1875] [Boss]") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Captain Elephant [Lv. 1875] [Boss]" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not  _G.AutoTwinHook or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                    if BypassTP then
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - ElephantPos.Position).Magnitude > 1500 then
						BTP(ElephantPos)
					else
						topos(ElephantPos)
					end
                    topos(CFrame.new(-13348.0654296875, 405.8904113769531, -8570.62890625))
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Captain Elephant [Lv. 1875] [Boss]") then
                            topos(game:GetService("ReplicatedStorage"):FindFirstChild("Captain Elephant [Lv. 1875] [Boss]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                        else
                            if  _G.AutoTwinHook_Hop then
                                Hop()
                            end
                        end
                    end
                end)
            end
        end
    end)
end 
    
if World3 then  
    Items:Toggle("Auto Hallow Scythe",_G.AutoFarmBossHallow,function(value)
        _G.AutoFarmBossHallow = value
        StopTween(_G.AutoFarmBossHallow)
    end)
    
    spawn(function()
        while wait() do
            if _G.AutoFarmBossHallow then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Soul Reaper [Lv. 2100] [Raid Boss]") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if string.find(v.Name , "Soul Reaper") then
                                repeat task.wait()
                                    EquipWeapon(_G.SelectWeapon)
                                    AutoHaki()
                                    v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                    topos(v.HumanoidRootPart.CFrame*CFrame.new(PosX,PosY,PosZ))
                                    game:GetService("VirtualUser"):CaptureController()
                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 670))
                                    v.HumanoidRootPart.Transparency = 1
                                    sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                until v.Humanoid.Health <= 0 or _G.AutoFarmBossHallow == false
                            end
                        end
                    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Hallow Essence") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Hallow Essence") then
                        repeat topos(CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125)) wait() until (CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 8                        
                        EquipWeapon("Hallow Essence")
                    else
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Soul Reaper [Lv. 2100] [Raid Boss]") then
                            topos(game:GetService("ReplicatedStorage"):FindFirstChild("Soul Reaper [Lv. 2100] [Raid Boss]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                        else
                            if _G.AutoFarmBossHallowHop then
                                Hop()
                            end
                        end
                    end
                end)
            end
        end
    end)
end

if World3 then
    Items:Toggle("Auto Dark Danger",_G.AutoDarkDagger,function(value)
        _G.AutoDarkDagger = value
        StopTween(_G.AutoDarkDagger)
    end)
        
    local AdminPos = CFrame.new(-5344.822265625, 423.98541259766, -2725.0930175781)
    spawn(function()
        pcall(function()
            while wait() do
                if _G.AutoDarkDagger then
                    if game:GetService("Workspace").Enemies:FindFirstChild("rip_indra True Form [Lv. 5000] [Raid Boss]") or game:GetService("Workspace").Enemies:FindFirstChild("rip_indra [Lv. 5000] [Raid Boss]") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == ("rip_indra True Form [Lv. 5000] [Raid Boss]" or v.Name == "rip_indra [Lv. 5000] [Raid Boss]") and v.Humanoid.Health > 0 and v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                                repeat task.wait()
                                    pcall(function()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 670),workspace.CurrentCamera.CFrame)
                                    end)
                                until _G.AutoDarkDagger == false or v.Humanoid.Health <= 0
                            end
                        end
                    else
                    if BypassTP then
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - AdminPos.Position).Magnitude > 1500 then
						BTP(AdminPos)
					else
						topos(AdminPos)
					end
                        topos(CFrame.new(-5344.822265625, 423.98541259766, -2725.0930175781))
                    end
                end
            end
        end)
    end)
    
    spawn(function()
        pcall(function()
            while wait() do
                if (_G.AutoDarkDagger_Hop and _G.AutoDarkDagger) and World3 and not game:GetService("ReplicatedStorage"):FindFirstChild("rip_indra True Form [Lv. 5000] [Raid Boss]") and not game:GetService("Workspace").Enemies:FindFirstChild("rip_indra True Form [Lv. 5000] [Raid Boss]") then
                    Hop()
                end
            end
        end)
    end)
end
   
    
if World2 then
	Items:Toggle("Auto Dragon Trident", _G.Auto_Dragon_Trident,function(value)
         _G.Auto_Dragon_Trident = value
        StopTween(_G.Auto_Dragon_Trident)
    end)
    

    
    local TridentPos = CFrame.new(-3914.830322265625, 123.29389190673828, -11516.8642578125)
    spawn(function()
        while wait() do
            if  _G.Auto_Dragon_Trident and World2 then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Tide Keeper [Lv. 1475] [Boss]") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Tide Keeper [Lv. 1475] [Boss]" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not  _G.Auto_Dragon_Trident or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                    if BypassTP then
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - TridentPos.Position).Magnitude > 1500 then
						BTP(TridentPos)
					else
						topos(TridentPos)
					end
                    topos(CFrame.new(-3914.830322265625, 123.29389190673828, -11516.8642578125))
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Tide Keeper [Lv. 1475] [Boss]") then
                            topos(game:GetService("ReplicatedStorage"):FindFirstChild("Tide Keeper [Lv. 1475] [Boss]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                        else
                            if  _G.Auto_Dragon_Trident_Hop then
                                Hop()
                            end
                        end
                    end
                end)
            end
        end
    end)
end

if World2 then
	Items:Toggle("Auto Waden Sword", _G.Autowaden,function(value)
         _G.Autowaden = value
        StopTween( _G.Autowaden)
    end)

    
    local NamfonPos = CFrame.new(5186.14697265625, 24.86684226989746, 832.1885375976562)
    spawn(function()
        while wait() do
            if  _G.Autowaden and World1 then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Chief Warden [Lv. 230] [Boss]") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Chief Warden [Lv. 230] [Boss]" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not  _G.Autowaden or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                    if BypassTP then
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - NamfonPos.Position).Magnitude > 1500 then
						BTP(NamfonPos)
					else
						topos(NamfonPos)
					end
                    topos(CFrame.new(5186.14697265625, 24.86684226989746, 832.1885375976562))
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Chief Warden [Lv. 230] [Boss]") then
                            topos(game:GetService("ReplicatedStorage"):FindFirstChild("Chief Warden [Lv. 230] [Boss]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                        else
                            if  _G.Autowadenhop then
                                Hop()
                            end
                        end
                    end
                end)
            end
        end
    end)
end

if World2 then
    Items:Toggle("Auto Darkness", _G.Autodoughking,function(value)
         _G.Autogay = value
        StopTween( _G.Autogay)
    end)
    

    
    local GayMakPos = CFrame.new(-5023.38330078125, 28.65203285217285, 4332.3818359375)
    spawn(function()
        while wait() do
            if  _G.Autogay and World1 then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Greybeard [Lv. 750] [Raid Boss]") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Greybeard [Lv. 750] [Raid Boss]" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not  _G.Autogay or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                    if BypassTP then
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - GayMakPos.Position).Magnitude > 1500 then
						BTP(GayMakPos)
					else
						topos(GayMakPos)
					end
                    topos(CFrame.new(-5023.38330078125, 28.65203285217285, 4332.3818359375))
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Greybeard [Lv. 750] [Raid Boss]") then
                            topos(game:GetService("ReplicatedStorage"):FindFirstChild("Greybeard [Lv. 750] [Raid Boss]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                        else
                            if  _G.Autogayhop then
                                Hop()
                            end
                        end
                    end
                end)
            end
        end
    end)
end   

if World1 then
    Items:Toggle("Auto Pole v1", _G.Autodoughking,function(value)
         _G.Autopole = value
        StopTween( _G.Autopole)
    end)
    
   
    
    local PolePos = CFrame.new(-7748.0185546875, 5606.80615234375, -2305.898681640625)
    spawn(function()
        while wait() do
            if  _G.Autopole and World1 then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Thunder God [Lv. 575] [Boss]") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Thunder God [Lv. 575] [Boss]" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not  _G.Autopole or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                    if BypassTP then
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - PolePos.Position).Magnitude > 1500 then
						BTP(PolePos)
					else
						topos(PolePos)
					end
                    topos(CFrame.new(-7748.0185546875, 5606.80615234375, -2305.898681640625))
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Thunder God [Lv. 575] [Boss]") then
                            topos(game:GetService("ReplicatedStorage"):FindFirstChild("Thunder God [Lv. 575] [Boss]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                        else
                            if  _G.Autopolehop then
                                Hop()
                            end
                        end
                    end
                end)
            end
        end
    end)
end   

if World2 then
    Items:Toggle("Auto Swan Glasses",_G.AutoFarmSwanGlasses,function(value)
        _G.AutoFarmSwanGlasses = value
        StopTween(_G.AutoFarmSwanGlasses)
    end)
    
    spawn(function()
        pcall(function()
            while wait() do
                if _G.AutoFarmSwanGlasses then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Don Swan [Lv. 1000] [Boss]") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Don Swan [Lv. 1000] [Boss]" and v.Humanoid.Health > 0 and v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                                repeat task.wait()
                                    pcall(function()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 670))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                    end)
                                until _G.AutoFarmSwanGlasses == false or v.Humanoid.Health <= 0
                            end
                        end
                    else 
                        repeat task.wait()
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(2284.912109375, 15.537666320801, 905.48291015625)) 
                        until (CFrame.new(2284.912109375, 15.537666320801, 905.48291015625).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 4 or _G.AutoFarmSwanGlasses == false
                    end
                end
            end
        end)
    end)
end   

    

if world1 then 
    Items:Toggle("Auto Sharks Saw", _G.Autodoughking,function(value)
         _G.Autosaw = value
        StopTween( _G.Autosaw)
    end)
    

    
    local SharkPos = CFrame.new(-690.33081054688, 15.09425163269, 1582.2380371094)
    spawn(function()
        while wait() do
            if  _G.Autosaw and World1 then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("The Saw [Lv. 100] [Boss]") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "The Saw [Lv. 100] [Boss]" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not  _G.Autosaw or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                    if BypassTP then
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - SharkPos.Position).Magnitude > 1500 then
						BTP(SharkPos)
					else
						topos(SharkPos)
					end
                    topos(CFrame.new(-690.33081054688, 15.09425163269, 1582.2380371094))
                        if game:GetService("ReplicatedStorage"):FindFirstChild("The Saw [Lv. 100] [Boss]") then
                            topos(game:GetService("ReplicatedStorage"):FindFirstChild("The Saw [Lv. 100] [Boss]").HumanoidRootPart.CFrame * CFrame.new(2,40,2))
                        else
                            if  _G.Autosawhop then
                                Hop()
                            end
                        end
                    end
                end)
            end
        end
    end)
    
    
    spawn(function()
        pcall(function()
            while wait(.1) do
                if (_G.AutoFarmSwanGlasses and _G.AutoFarmSwanGlasses_Hop) and World2 and not game:GetService("ReplicatedStorage"):FindFirstChild("Don Swan [Lv. 1000] [Boss]") and not game:GetService("Workspace").Enemies:FindFirstChild("Don Swan [Lv. 1000] [Boss]") then
                    Hop()
                end
            end
        end)
    end)
end   

if World1 then
    Items:Toggle("Auto Saber",_G.AutoSaber,function(value)
				_G.AutoSaber = value
			end)
			
		
			
 spawn(function()
            while wait() do
                if _G.AutoSaber then
                    if game.Players.localPlayer.Data.Level.Value < 200 then
                    else
                        if game.Workspace.Map.Jungle.Final.Part.CanCollide == false then
                            if _G.AutoSaber and game.ReplicatedStorage:FindFirstChild("Saber Expert [Lv. 200] [Boss]") or game.Workspace.Enemies:FindFirstChild("Saber Expert [Lv. 200] [Boss]") then
                                if game.Workspace.Enemies:FindFirstChild("Saber Expert [Lv. 200] [Boss]") then
                                    for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
                                        if v.Name == "Saber Expert [Lv. 200] [Boss]" and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                            repeat wait()
                                                if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 300 then
                                                    Farmtween = topos(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame)
                                                elseif (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
                                                    if Farmtween then
                                                        Farmtween:Stop()
                                                    end
                                                    AutoHaki()
                                                    EquipWeapon(_G.SelectWeapon)
                                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                                                    game:GetService'VirtualUser':CaptureController()
                                                    game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
                                                end
                                            until not _G.Auto_Saber or not v.Parent or v.Humanoid.Health <= 0
                                        end
                                    end
                                else
                                    Questtween = topos(CFrame.new(-1405.41956, 29.8519993, 5.62435055).Position,CFrame.new(-1405.41956, 29.8519993, 5.62435055))
                                    if (CFrame.new(-1405.41956, 29.8519993, 5.62435055).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
                                        if Questtween then
                                            Questtween:Stop()
                                        end
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1405.41956, 29.8519993, 5.62435055, 0.885240912, 3.52892613e-08, 0.465132833, -6.60881128e-09, 1, -6.32913171e-08, -0.465132833, 5.29540891e-08, 0.885240912)
                                    end
                                end
                            else
                                if _G.AutoSaberHop then
                                    Hop()
                                end
                            end
                        elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Relic") or game.Players.LocalPlayer.Character:FindFirstChild("Relic") and game.Players.localPlayer.Data.Level.Value >= 200 then
                            EquipWeapon("Relic")
                            wait(0.5)
                            Questtween = topos(CFrame.new(-1405.41956, 29.8519993, 5.62435055).Position,CFrame.new(-1405.41956, 29.8519993, 5.62435055))
                            if (CFrame.new(-1405.41956, 29.8519993, 5.62435055).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
                                if Questtween then
                                    Questtween:Stop()
                                end
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1405.41956, 29.8519993, 5.62435055, 0.885240912, 3.52892613e-08, 0.465132833, -6.60881128e-09, 1, -6.32913171e-08, -0.465132833, 5.29540891e-08, 0.885240912)
                            end
                        else
                            if Workspace.Map.Jungle.QuestPlates.Door.CanCollide == false then
                                if game.Workspace.Map.Desert.Burn.Part.CanCollide == false then
                                    if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress","SickMan") == 0 then
                                        if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress","RichSon") == 0 then
                                            if game.Workspace.Enemies:FindFirstChild("Mob Leader [Lv. 120] [Boss]") then
                                                for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
                                                    if _G.AutoSaber and v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and v.Name == "Mob Leader [Lv. 120] [Boss]" then
                                                        repeat
                                                            pcall(function() wait() 
                                                                if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 300 then
                                                                    Farmtween = topos(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame)
                                                                elseif (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
                                                                    if Farmtween then
                                                                        Farmtween:Stop()
                                                                    end
                                                                    AutoHaki()
                                                                    EquipWeapon(_G.SelectWeapon)
                                                                    if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
                                                                        local args = {
                                                                            [1] = "Buso"
                                                                        }
                                                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                                                                    end
                                                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                                                                    game:GetService'VirtualUser':CaptureController()
                                                                    game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
                                                                end
                                                            end)
                                                        until not _G.AutoSaber or not v.Parent or v.Humanoid.Health <= 0
                                                    end
                                                end
                                            else
                                                Questtween = topos(CFrame.new(-2848.59399, 7.4272871, 5342.44043).Position,CFrame.new(-2848.59399, 7.4272871, 5342.44043))
                                                if (CFrame.new(-2848.59399, 7.4272871, 5342.44043).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
                                                    if Questtween then
                                                        Questtween:Stop()
                                                    end
                                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2848.59399, 7.4272871, 5342.44043, -0.928248107, -8.7248246e-08, 0.371961564, -7.61816636e-08, 1, 4.44474857e-08, -0.371961564, 1.29216433e-08, -0.928248107)
                                                end
                                            end
                                        elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress","RichSon") == 1 then
                                            if game.Players.LocalPlayer.Backpack:FindFirstChild("Relic") or game.Players.LocalPlayer.Character:FindFirstChild("Relic") then
                                                EquipWeapon("Relic")
                                                wait(0.5)
                                                Questtween = topos(CFrame.new(-1405.41956, 29.8519993, 5.62435055).Position,CFrame.new(-1405.41956, 29.8519993, 5.62435055))
                                                if (CFrame.new(-1405.41956, 29.8519993, 5.62435055).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
                                                    if Questtween then
                                                        Questtween:Stop()
                                                    end
                                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1405.41956, 29.8519993, 5.62435055)
                                                end
                                            else
                                                Questtween = topos(CFrame.new(-910.979736, 13.7520342, 4078.14624).Position,CFrame.new(-910.979736, 13.7520342, 4078.14624))
                                                if (CFrame.new(-910.979736, 13.7520342, 4078.14624).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
                                                    if Questtween then
                                                        Questtween:Stop()
                                                    end
                                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-910.979736, 13.7520342, 4078.14624, 0.00685182028, -1.53155766e-09, -0.999976516, 9.15205245e-09, 1, -1.46888401e-09, 0.999976516, -9.14177267e-09, 0.00685182028)
                                                    wait(.5)
                                                    local args = {
                                                        [1] = "ProQuestProgress",
                                                        [2] = "RichSon"
                                                    }
                                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                                                end
                                            end
                                        else
                                            Questtween = topos(CFrame.new(-910.979736, 13.7520342, 4078.14624).Position,CFrame.new(-910.979736, 13.7520342, 4078.14624))
                                            if (CFrame.new(-910.979736, 13.7520342, 4078.14624).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
                                                if Questtween then
                                                    Questtween:Stop()
                                                end
                                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-910.979736, 13.7520342, 4078.14624)
                                                local args = {
                                                    [1] = "ProQuestProgress",
                                                    [2] = "RichSon"
                                                }
                                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                                            end
                                        end
                                    else
                                        if game.Players.LocalPlayer.Backpack:FindFirstChild("Cup") or game.Players.LocalPlayer.Character:FindFirstChild("Cup") then
                                            EquipWeapon("Cup")
                                            if game.Players.LocalPlayer.Character.Cup.Handle:FindFirstChild("TouchInterest") then
                                                Questtween = topos(CFrame.new(1397.229, 37.3480148, -1320.85217).Position,CFrame.new(1397.229, 37.3480148, -1320.85217))
                                                if (CFrame.new(1397.229, 37.3480148, -1320.85217).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
                                                    if Questtween then
                                                        Questtween:Stop()
                                                    end
                                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1397.229, 37.3480148, -1320.85217, -0.11285457, 2.01368788e-08, 0.993611455, 1.91641178e-07, 1, 1.50028845e-09, -0.993611455, 1.90586206e-07, -0.11285457)
                                                end
                                            else
                                                wait(0.5)
                                                if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress","SickMan") ~= 0 then
                                                    local args = {
                                                        [1] = "ProQuestProgress",
                                                        [2] = "SickMan"
                                                    }
                                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                                                end
                                            end
                                        else
                                            Questtween = topos(game.Workspace.Map.Desert.Cup.Position,game.Workspace.Map.Desert.Cup.CFrame)
                                            if (game.Workspace.Map.Desert.Cup.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
                                                if Questtween then
                                                    Questtween:Stop()
                                                end
                                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Map.Desert.Cup.CFrame
                                            end
                                            firetouchinterest(game.Workspace.Map.Desert.Cup.TouchInterest,game.Players.LocalPlayer.Character.Head, 1)
                                        end
                                    end
                                else
                                    if game.Players.LocalPlayer.Backpack:FindFirstChild("Torch") or game.Players.LocalPlayer.Character:FindFirstChild("Torch") then
                                        EquipWeapon("Torch")
                                        Questtween = topos(CFrame.new(1114.87708, 4.9214654, 4349.8501).Position,CFrame.new(1114.87708, 4.9214654, 4349.8501))
                                        if (CFrame.new(1114.87708, 4.9214654, 4349.8501).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
                                            if Questtween then
                                                Questtween:Stop()
                                            end
                                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1114.87708, 4.9214654, 4349.8501, -0.612586915, -9.68697833e-08, 0.790403247, -1.2634203e-07, 1, 2.4638446e-08, -0.790403247, -8.47679615e-08, -0.612586915)
                                        end
                                    else
                                        Questtween = topos(CFrame.new(-1610.00757, 11.5049858, 164.001587).Position,CFrame.new(-1610.00757, 11.5049858, 164.001587))
                                        if (CFrame.new(-1610.00757, 11.5049858, 164.001587).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
                                            if Questtween then
                                                Questtween:Stop()
                                            end
                                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1610.00757, 11.5049858, 164.001587, 0.984807551, -0.167722285, -0.0449818149, 0.17364943, 0.951244235, 0.254912198, 3.42372805e-05, -0.258850515, 0.965917408)
                                        end
                                    end
                                end
                            else
                                for i,v in pairs(Workspace.Map.Jungle.QuestPlates:GetChildren()) do
                                    if v:IsA("Model") then wait()
                                        if v.Button.BrickColor ~= BrickColor.new("Camo") then
                                            repeat wait()
                                                Questtween = topos(v.Button.Position,v.Button.CFrame)
                                                if (v.Button.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
                                                    if Questtween then
                                                        Questtween:Stop()
                                                    end
                                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Button.CFrame
                                                end
                                            until not _G.AutoSaber or v.Button.BrickColor == BrickColor.new("Camo")
                                        end
                                    end
                                end    
                            end
                        end
                    end 
                end
            end
        end)
end    

if World3 then
    Items:Toggle("Auto Musketeer Hat",_G.AutoMusketeerHat,function(value)
        _G.AutoMusketeerHat = value
        StopTween(_G.AutoMusketeerHat)
    end)
    
    spawn(function()
        pcall(function()
            while wait(.1) do
                if _G.AutoMusketeerHat then
                    if game:GetService("Players").LocalPlayer.Data.Level.Value >= 1800 and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress").KilledBandits == false then
                        if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Forest Pirate") and string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") and game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                            if game:GetService("Workspace").Enemies:FindFirstChild("Forest Pirate [Lv. 1825]") then
                                for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                    if v.Name == "Forest Pirate [Lv. 1825]" then
                                        repeat task.wait()
                                            pcall(function()
                                                EquipWeapon(_G.SelectWeapon)
                                                AutoHaki()
                                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                                topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
                                                v.HumanoidRootPart.CanCollide = false
                                                game:GetService'VirtualUser':CaptureController()
                                                game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
                                                MusketeerHatMon = v.HumanoidRootPart.CFrame
                                                StartMagnetMusketeerhat = true
                                            end)
                                        until _G.AutoMusketeerHat == false or not v.Parent or v.Humanoid.Health <= 0 or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                        StartMagnetMusketeerhat = false
                                    end
                                end
                            else
                                StartMagnetMusketeerhat = false
                                topos(CFrame.new(-13206.452148438, 425.89199829102, -7964.5537109375))
                            end
                        else
                            topos(CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125))
                            if (Vector3.new(-12443.8671875, 332.40396118164, -7675.4892578125) - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 30 then
                                wait(1.5)
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest","CitizenQuest",1)
                            end
                        end
                    elseif game:GetService("Players").LocalPlayer.Data.Level.Value >= 1800 and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress").KilledBoss == false then
                        if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible and string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Captain Elephant") and game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                            if game:GetService("Workspace").Enemies:FindFirstChild("Captain Elephant [Lv. 1875] [Boss]") then
                                for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                    if v.Name == "Captain Elephant [Lv. 1875] [Boss]" then
                                        OldCFrameElephant = v.HumanoidRootPart.CFrame
                                        repeat task.wait()
                                            pcall(function()
                                                EquipWeapon(_G.SelectWeapon)
                                                AutoHaki()
                                                v.HumanoidRootPart.CanCollide = false
                                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                                                v.HumanoidRootPart.CanCollide = false
                                                v.HumanoidRootPart.CFrame = OldCFrameElephant
                                                game:GetService("VirtualUser"):CaptureController()
                                                game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                                sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                            end)
                                        until _G.AutoMusketeerHat == false or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                    end
                                end
                            else
                                topos(CFrame.new(-13374.889648438, 421.27752685547, -8225.208984375))
                            end
                        else
                            topos(CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125))
                            if (CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 4 then
                                wait(1.5)
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress","Citizen")
                            end
                        end
                    elseif game:GetService("Players").LocalPlayer.Data.Level.Value >= 1800 and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress","Citizen") == 2 then
                        topos(CFrame.new(-12512.138671875, 340.39279174805, -9872.8203125))
                    end
                end
            end
        end)
    end)
end    

if World3 then
	Items:Toggle("Auto Rainbow Haki",_G.Auto_Rainbow_Haki,function(value)
        _G.Auto_Rainbow_Haki = value
        StopTween(_G.Auto_Rainbow_Haki)
    end)
    
    spawn(function()
        pcall(function()
            while wait(.1) do
                if _G.Auto_Rainbow_Haki then
                    if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                        topos(CFrame.new(-11892.0703125, 930.57672119141, -8760.1591796875))
                        if (Vector3.new(-11892.0703125, 930.57672119141, -8760.1591796875) - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 30 then
                            wait(1.5)
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("HornedMan","Bet")
                        end
                    elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true and string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Stone") then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Stone [Lv. 1550] [Boss]") then
                            for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v.Name == "Stone [Lv. 1550] [Boss]" then
                                    OldCFrameRainbow = v.HumanoidRootPart.CFrame
                                    repeat task.wait()
                                        EquipWeapon(_G.SelectWeapon)
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
                                        v.HumanoidRootPart.CanCollide = false
                                        v.HumanoidRootPart.CFrame = OldCFrameRainbow
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                    until _G.Auto_Rainbow_Haki == false or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                end
                            end
                        else
                            topos(CFrame.new(-1086.11621, 38.8425903, 6768.71436, 0.0231462717, -0.592676699, 0.805107772, 2.03251839e-05, 0.805323839, 0.592835128, -0.999732077, -0.0137055516, 0.0186523199))
                        end
                    elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true and string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Island Empress") then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Island Empress [Lv. 1675] [Boss]") then
                            for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v.Name == "Island Empress [Lv. 1675] [Boss]" then
                                    OldCFrameRainbow = v.HumanoidRootPart.CFrame
                                    repeat task.wait()
                                        EquipWeapon(_G.SelectWeapon)
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
                                        v.HumanoidRootPart.CanCollide = false
                                        v.HumanoidRootPart.CFrame = OldCFrameRainbow
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                    until _G.Auto_Rainbow_Haki == false or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                end
                            end
                        else
                            topos(CFrame.new(5713.98877, 601.922974, 202.751251, -0.101080291, -0, -0.994878292, -0, 1, -0, 0.994878292, 0, -0.101080291))
                        end
                    elseif string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Kilo Admiral") then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Kilo Admiral [Lv. 1750] [Boss]") then
                            for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v.Name == "Kilo Admiral [Lv. 1750] [Boss]" then
                                    OldCFrameRainbow = v.HumanoidRootPart.CFrame
                                    repeat task.wait()
                                        EquipWeapon(_G.SelectWeapon)
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
                                        v.HumanoidRootPart.CanCollide = false
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                        v.HumanoidRootPart.CFrame = OldCFrameRainbow
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                    until _G.Auto_Rainbow_Haki == false or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                end
                            end
                        else
                            topos(CFrame.new(2877.61743, 423.558685, -7207.31006, -0.989591599, -0, -0.143904909, -0, 1.00000012, -0, 0.143904924, 0, -0.989591479))
                        end
                    elseif string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Captain Elephant") then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Captain Elephant [Lv. 1875] [Boss]") then
                            for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v.Name == "Captain Elephant [Lv. 1875] [Boss]" then
                                    OldCFrameRainbow = v.HumanoidRootPart.CFrame
                                    repeat task.wait()
                                        EquipWeapon(_G.SelectWeapon)
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
                                        v.HumanoidRootPart.CanCollide = false
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                        v.HumanoidRootPart.CFrame = OldCFrameRainbow
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                    until _G.Auto_Rainbow_Haki == false or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                end
                            end
                        else
                            topos(CFrame.new(-13485.0283, 331.709259, -8012.4873, 0.714521289, 7.98849911e-08, 0.69961375, -1.02065748e-07, 1, -9.94383065e-09, -0.69961375, -6.43015241e-08, 0.714521289))
                        end
                    elseif string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Beautiful Pirate") then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Beautiful Pirate [Lv. 1950] [Boss]") then
                            for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v.Name == "Beautiful Pirate [Lv. 1950] [Boss]" then
                                    OldCFrameRainbow = v.HumanoidRootPart.CFrame
                                    repeat task.wait()
                                        EquipWeapon(_G.SelectWeapon)
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
                                        v.HumanoidRootPart.CanCollide = false
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                        v.HumanoidRootPart.CFrame = OldCFrameRainbow
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                    until _G.Auto_Rainbow_Haki == false or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                end
                            end
                        else
                            topos(CFrame.new(5312.3598632813, 20.141201019287, -10.158538818359))
                        end
                    else
                        topos(CFrame.new(-11892.0703125, 930.57672119141, -8760.1591796875))
                        if (Vector3.new(-11892.0703125, 930.57672119141, -8760.1591796875) - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 30 then
                            wait(1.5)
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("HornedMan","Bet")
                        end
                    end
                end
            end
        end)
    end)
end 

if World3 then
    Items:Toggle("Auto Citizen Quest",_G.AutoObservationHakiV2,function(x)
		_G.AutoObservationHakiV2 = x
	end)

	spawn(function()
		while wait() do
			if _G.AutoObservationHakiV2 then
				if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
					repeat 
						topos(CFrame.new(-12444.78515625, 332.40396118164, -7673.1806640625)) 
						wait() 
					until _G.StopTween == true or not _G.AutoObservationHakiV2 or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-12444.78515625, 332.40396118164, -7673.1806640625)).Magnitude <= 10
					wait(.5)
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress","Citizen")
					wait(1)
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest","CitizenQuest",1)
				else
					if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,"Defeat 50 Forest Pirates") then
						if game:GetService("Workspace").Enemies:FindFirstChild("Forest Pirate [Lv. 1825]") then
							for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
								if v.Name == "Forest Pirate [Lv. 1825]" then
									repeat wait()
										if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
											game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
										end
										EquipWeapon(_G.SelectWeapon)
										topos(v.HumanoidRootPart.CFrame * CFrame.new(1,20,1))
										PosHee =  v.HumanoidRootPart.CFrame
										v.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
										v.HumanoidRootPart.CanCollide = false
										v.HumanoidRootPart.Size = Vector3.new(50,50,50)
										game:GetService'VirtualUser':CaptureController()
										game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
										Mangnetcitzenmon = true
									until _G.AutoObservationHakiV2 == false or v.Humanoid.Health <= 0
									Mangnetcitzenmon = false
								end
							end
						else
							repeat 
								topos(CFrame.new(-13277.568359375, 370.34185791016, -7821.1572265625)) 
								wait() 
							until _G.StopTween == true or not _G.AutoObservationHakiV2 or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-13277.568359375, 370.34185791016, -7821.1572265625)).Magnitude <= 10
						end
					elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text ==  "Defeat  Captain Elephant (0/1)" then 
						if game:GetService("Workspace").Enemies:FindFirstChild("Captain Elephant [Lv. 1875] [Boss]") then
							for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
								if v.Name == "Captain Elephant [Lv. 1875] [Boss]" then
									repeat wait()
										if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
											game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
										end
										EquipWeapon(_G.SelectWeapon)
										topos(v.HumanoidRootPart.CFrame * CFrame.new(1,20,1))										
										if sethiddenproperty then
											sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
										end
										v.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
										v.HumanoidRootPart.CanCollide = false
										v.HumanoidRootPart.Size = Vector3.new(50,50,50)
										game:GetService'VirtualUser':CaptureController()
										game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
									until _G.AutoObservationHakiV2 == false or v.Humanoid.Health <= 0
								end
							end
						else
							repeat 
								topos(CFrame.new(-13493.12890625, 318.89553833008, -8373.7919921875)) 
								wait() 
							until _G.StopTween == true or not _G.AutoObservationHakiV2 or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-13493.12890625, 318.89553833008, -8373.7919921875)).Magnitude <= 10
						end        
					end
				end
				if game.Players.LocalPlayer.Backpack:FindFirstChild("Banana") and  game.Players.LocalPlayer.Backpack:FindFirstChild("Apple") and game.Players.LocalPlayer.Backpack:FindFirstChild("Pineapple") then
					repeat 
						topos(CFrame.new(-12444.78515625, 332.40396118164, -7673.1806640625)) 
						wait() 
					until _G.StopTween == true or not _G.AutoObservationHakiV2 or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-12444.78515625, 332.40396118164, -7673.1806640625)).Magnitude <= 10
					wait(.5)
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress","Citizen")
				elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Fruit Bowl") or game.Players.LocalPlayer.Character:FindFirstChild("Fruit Bowl") then
					repeat 
						topos(CFrame.new(-10920.125, 624.20275878906, -10266.995117188)) 
						wait() 
					until _G.StopTween == true or not _G.AutoObservationHakiV2 or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-10920.125, 624.20275878906, -10266.995117188)).Magnitude <= 10
					wait(.5)
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("KenTalk2","Start")
					wait(1)
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("KenTalk2","Buy")
				else
					for i,v in pairs(game.Workspace:GetDescendants()) do
						if v.Name == "Apple" or v.Name == "Banana" or v.Name == "Pineapple" then
							v.Handle.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,10)
							wait()
							firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart,v.Handle,0)    
							wait()
						end
					end   
				end
			end
		end
	end)

	spawn(function()
		while wait() do
			pcall(function()
				if _G.AutoObservationHakiV2 then
					if sethiddenproperty then
						sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
					end
				end
			end)
			game:GetService("RunService").Heartbeat:Wait()
		end
	end)

	spawn(function()
		game:GetService("RunService").Heartbeat:connect(function()
			pcall(function()
				if _G.AutoObservationHakiV2 then
					if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") then
						game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
					end
				end
			end)
		end)
	end)

	spawn(function()
		pcall(function()
			game:GetService("RunService").Heartbeat:Connect(function()
				game:GetService("RunService").Heartbeat:Wait()
				if _G.AutoObservationHakiV2 and StatrMagnet then
					for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
						if v.Name == "Forest Pirate [Lv. 1825]" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
							if v.Name == "Forest Pirate [Lv. 1825]" then
								v.HumanoidRootPart.CanCollide = false
								v.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
								v.HumanoidRootPart.CFrame = PosHee
							end
						end
					end
				end
			end)
		end)
	end)

	spawn(function()
		game:GetService("RunService").Heartbeat:connect(function()
			game:GetService("RunService").Heartbeat:Wait()
			pcall(function()
				if _G.AutoObservationHakiV2 and StatrMagnet then
					CheckQuest()
					for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
						if v.Name == Ms then
							v.Humanoid:ChangeState(11)
						end
					end
				end
			end)
			game:GetService("RunService").Heartbeat:Wait()
		end)
	end)
end    

if World2 then
    Items:Toggle("Auto Rengoku",_G.AutoRengoku,function(value)
        _G.AutoRengoku = value
        StopTween(_G.AutoRengoku)
    end)
    
    spawn(function()
        pcall(function()
            while wait() do
                if _G.AutoRengoku then
                    if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Hidden Key") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Hidden Key") then
                        EquipWeapon("Hidden Key")
                        topos(CFrame.new(6571.1201171875, 299.23028564453, -6967.841796875))
                    elseif game:GetService("Workspace").Enemies:FindFirstChild("Snow Lurker [Lv. 1375]") or game:GetService("Workspace").Enemies:FindFirstChild("Arctic Warrior [Lv. 1350]") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if (v.Name == "Snow Lurker [Lv. 1375]" or v.Name == "Arctic Warrior [Lv. 1350]") and v.Humanoid.Health > 0 then
                                repeat task.wait()
                                    EquipWeapon(_G.SelectWeapon)
                                    AutoHaki()
                                    v.HumanoidRootPart.CanCollide = false
                                    v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                    RengokuMon = v.HumanoidRootPart.CFrame
                                    topos(v.HumanoidRootPart.CFrame * CFrame.new(PosX,PosY,PosZ))
                                    game:GetService'VirtualUser':CaptureController()
                                    game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
                                    StartRengokuMagnet = true
                                until game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Hidden Key") or _G.AutoRengoku == false or not v.Parent or v.Humanoid.Health <= 0
                                StartRengokuMagnet = false
                            end
                        end
                    else
                        StartRengokuMagnet = false
                        topos(CFrame.new(5439.716796875, 84.420944213867, -6715.1635742188))
                    end
                end
            end
        end)
    end)
end   

if World2 then
    Items:Toggle("Auto Ectoplasm",_G.AutoEctoplasm,function(value)
        _G.AutoEctoplasm = value
        StopTween(_G.AutoEctoplasm)
    end)
    
    spawn(function()
        pcall(function()
            while wait() do
                if _G.AutoEctoplasm then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Ship Deckhand [Lv. 1250]") or game:GetService("Workspace").Enemies:FindFirstChild("Ship Engineer [Lv. 1275]") or game:GetService("Workspace").Enemies:FindFirstChild("Ship Steward [Lv. 1300]") or game:GetService("Workspace").Enemies:FindFirstChild("Ship Officer [Lv. 1325]") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if string.find(v.Name, "Ship") then
                                repeat task.wait()
                                    EquipWeapon(_G.SelectWeapon)
                                    AutoHaki()
                                    if string.find(v.Name,"Ship") then
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Head.CanCollide = false
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                                        game:GetService'VirtualUser':CaptureController()
                                        game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
                                        EctoplasmMon = v.HumanoidRootPart.CFrame
                                        StartEctoplasmMagnet = true
                                    else
                                        StartEctoplasmMagnet = false
                                        topos(CFrame.new(911.35827636719, 125.95812988281, 33159.5390625))
                                    end
                                until _G.AutoEctoplasm == false or not v.Parent or v.Humanoid.Health <= 0
                            end
                        end
                    else
                        StartEctoplasmMagnet = false
                        local Distance = (Vector3.new(911.35827636719, 125.95812988281, 33159.5390625) - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if Distance > 18000 then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
                        end
                        topos(CFrame.new(911.35827636719, 125.95812988281, 33159.5390625))
                    end
                end
            end
        end)
    end)
end    

if World3 then
    Items:Toggle("Auto Yama",_G.AutoYama,function(value)
        _G.AutoYama = value
        StopTween(_G.AutoYama)
    end)
    
    spawn(function()
        while wait() do
            if _G.AutoYama then
                if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter","Progress") >= 30 then
                    repeat wait(.1)
                        fireclickdetector(game:GetService("Workspace").Map.Waterfall.SealedKatana.Handle.ClickDetector)
                    until game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Yama") or not _G.AutoYama
                end
            end
        end
    end)
end
    
if World3 then    
    Items:Toggle("Auto Holy Torch",_G.AutoHolyTorch,function(value)
        _G.AutoHolyTorch = value
        StopTween(_G.AutoHolyTorch)
    end)
    
    spawn(function()
        while wait() do
            if _G.AutoHolyTorch then
                pcall(function()
                    wait(1)
                    TP1(CFrame.new(-10752, 417, -9366))
                    wait(1)
                    TP1(CFrame.new(-11672, 334, -9474))
                    wait(1)
                    TP1(CFrame.new(-12132, 521, -10655))
                    wait(1)
                    TP1(CFrame.new(-13336, 486, -6985))
                    wait(1)
                    TP1(CFrame.new(-13489, 332, -7925))
                end)
            end
        end
    end)
end 

Items:Label("\\\\ Auto Buy //")
	
if World2 then	
		Items:Toggle("Auto Legendary Sword",_G.AutoBuyLegendarySword,function(value)
        _G.AutoBuyLegendarySword = value
    end)
    
    spawn(function()
        while wait() do
            if _G.AutoBuyLegendarySword then
                pcall(function()
                    local args = {
                        [1] = "LegendarySwordDealer",
                        [2] = "1"
                    }
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                    local args = {
                        [1] = "LegendarySwordDealer",
                        [2] = "2"
                    }
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                    local args = {
                        [1] = "LegendarySwordDealer",
                        [2] = "3"
                    }
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                    if _G.AutoBuyLegendarySword_Hop and _G.AutoBuyLegendarySword and World2 then
                        wait(10)
                        Hop()
                    end
                end)
            end 
        end
    end)
end  
    
    Items:Toggle("Auto Enchancement Colour",_G.AutoBuyEnchancementColour,function(value)
        _G.AutoBuyEnchancementColour = value
    end)
    
   
    spawn(function()
        while wait() do
            if _G.AutoBuyEnchancementColour then
                local args = {
                    [1] = "ColorsDealer",
                    [2] = "2"
                }
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                if _G.AutoBuyEnchancementColour_Hop and _G.AutoBuyEnchancementColour and not World1 then
                    wait(10)
                    Hop()
                end
            end 
        end
    end)

--------Race V4

if World1 or World2 then
    R:Label("Only Available At Sea 3")
end

R:Label("\\\\ Status //")

    local FM = R:Label('Full Moon')
local Mirragecheck = R:Label('Mirage Island')
task.spawn(function()
            while task.wait() do
                pcall(function()
                    if  game:GetService("Lighting").Sky.MoonTextureId=="http://www.roblox.com/asset/?id=9709149431" then
                        FM:Refresh("🌕 :  8/8")
                    elseif game:GetService("Lighting").Sky.MoonTextureId=="http://www.roblox.com/asset/?id=9709149052" then
                        FM:Refresh("🌖 :  7/8")
                    elseif game:GetService("Lighting").Sky.MoonTextureId=="http://www.roblox.com/asset/?id=9709143733" then
                        FM:Refresh("🌗 :  6/8")
                    elseif game:GetService("Lighting").Sky.MoonTextureId=="http://www.roblox.com/asset/?id=9709150401" then
                        FM:Refresh("🌘 :  5/8")
                    elseif game:GetService("Lighting").Sky.MoonTextureId=="http://www.roblox.com/asset/?id=9709135895" then
                        FM:Refresh("🌑 :  4/8")
                    elseif game:GetService("Lighting").Sky.MoonTextureId=="http://www.roblox.com/asset/?id=9709139597" then
                        FM:Refresh("🌒 :  3/8")
                    elseif game:GetService("Lighting").Sky.MoonTextureId=="http://www.roblox.com/asset/?id=9709150086" then
                        FM:Refresh("🌓 :  2/8")
                    elseif game:GetService("Lighting").Sky.MoonTextureId=="http://www.roblox.com/asset/?id=9709149680" then
                        FM:Refresh("🌔 :  1/8")
                    end
                end)
            end
    end)
	
spawn(function()
        pcall(function()
            while wait() do
    if game.Workspace._WorldOrigin.Locations:FindFirstChild('Mirage Island') then
    Mirragecheck:Refresh('🏝 :  ✅')
    else
     Mirragecheck:Refresh('🏝 :  ❌')end
            end
        end)
end)

R:Label("\\\\ Mirage Island //")

R:Toggle("Auto Mirage Island ( Beta )",_G.dao,function(Value)
	

    _G.dao = Value
    
    if _G.dao then
    local args = {
        [1] = "requestEntrance",
        [2] = Vector3.new(-12463.6025390625, 378.3270568847656, -7566.0830078125)
    }
    
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    wait(1)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5411.22021, 778.609863, -2682.27759, 0.927179396, 0, 0.374617696, 0, 1, 0, -0.374617696, 0, 0.927179396)
    wait(0)
    
    local args = {
        [1] = "BuyBoat",
        [2] = "PirateBrigade"
    }
    
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    
    function two(gotoCFrame) --- Tween
          pcall(function()
              game.Players.LocalPlayer.Character.Humanoid.Sit = false
              game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
          end)
          if (game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart.Position - gotoCFrame.Position).Magnitude <= 200 then
              pcall(function() 
                  tweenz:Cancel()
              end)
              game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart.CFrame = gotoCFrame
          else
              local tween_s = game:service"TweenService"
              local info = TweenInfo.new((game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart.Position - gotoCFrame.Position).Magnitude/325, Enum.EasingStyle.Linear)
               tween, err = pcall(function()
                  tweenz = tween_s:Create(game.Players.LocalPlayer.Character["HumanoidRootPart"], info, {CFrame = gotoCFrame})
                  tweenz:Play()
              end)
              if not tween then return err end
          end
          function _TweenCanCle()
              tweenz:Cancel()
          end
      
    end
    two(CFrame.new(-5100.7085, 29.968586, -6792.45459, -0.33648631, -0.0396691673, 0.940852463, -6.40461678e-07, 0.999112308, 0.0421253517, -0.941688359, 0.0141740013, -0.336187631))
    
    wait(13)
    for _,v in next, workspace.Boats.PirateBrigade:GetDescendants() do
        if v.Name:find("VehicleSeat") then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
         if game:GetService("Workspace").Map:FindFirstChild("MysticIsland") then
                               topos(game:GetService("Workspace").Map:FindFirstChild("MysticIsland").HumanoidRootPart.CFrame * CFrame.new(0,500,-100))
       
        end
        end
    end
    end
    end) 



    

R:Toggle("Teleport To Mirage Island",_G.Mirage,function(Value)
    _G.Mirage = Value
end)

    spawn(function()
        pcall(function()
            while wait() do
             if _G.Mirage then
              if game:GetService("Workspace").Map:FindFirstChild("MysticIsland") then
                function toTargetWait(a)local b=(a.p-game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude;tweenrach=game:GetService('TweenService'):Create(game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"),TweenInfo.new(b/250,Enum.EasingStyle.Linear),{CFrame=a})tweenrach:Play()end;toTargetWait(workspace.Map.MysticIsland.PrimaryPart.CFrame*CFrame.new(0,250,0))
                else
    game.StarterGui:SetCore("SendNotification", {
        Title = "Qwerty Hub"; -- the title (ofc)
        Text = "Mirage Island Not Summon"; -- what the text says (ofc)
        Icon = ""; -- the image if u want. 
        Duration = 3; -- how long the notification should in secounds
        })
                if _G.MirageHop then
                wait(6)
                Hop()
                end          
            end
    end
    end
    end)
    end)
    

    
    
    
    R:Button("Teleport To Gear",function()
            topos(game:GetService("Workspace").Map.MysticIsland:FindFirstChildOfClass("MeshPart").CFrame)
          end)



			R:Button("Remove Fog", function ()
				game:GetService("Lighting").LightingLayers:Destroy()
				game:GetService("Lighting").Sky:Destroy()
			end)

R:Label("\\\\ Teleport Trial Door //")

R:Button("Teleport To Top Of Great Tree",function()
  topos(CFrame.new(2947.556884765625, 2281.630615234375, -7213.54931640625))
    end)

    R:Button("Teleport To Timple Of Time",function()
  Game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
    end)
    
R:Button("Teleport To Lever Pull",function()
  topos(CFrame.new(28575.181640625, 14936.6279296875, 72.31636810302734))
end)

R:Button("Teleport To Acient One",function()
  topos(CFrame.new(28981.552734375, 14888.4267578125, -120.245849609375))
end)
  
  R:Button("Teleport Trial Door",function()
  if game:GetService("Players").LocalPlayer.Data.Race.Value == "Fishman" then
  Game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
  wait(0.6)
  topos(CFrame.new(28224.056640625, 14889.4267578125, -210.5872039794922))
  elseif game:GetService("Players").LocalPlayer.Data.Race.Value == "Human" then
  Game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
  wait(0.6)
  topos(CFrame.new(29237.294921875, 14889.4267578125, -206.94955444335938))
  elseif game:GetService("Players").LocalPlayer.Data.Race.Value == "Cyborg" then
  Game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
  wait(0.6)
  topos(CFrame.new(28492.4140625, 14894.4267578125, -422.1100158691406))
  elseif game:GetService("Players").LocalPlayer.Data.Race.Value == "Skypiea" then
  Game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
  wait(0.6)
  topos(CFrame.new(28967.408203125, 14918.0751953125, 234.31198120117188))
  elseif game:GetService("Players").LocalPlayer.Data.Race.Value == "Ghoul" then
  Game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
  wait(0.6)
  topos(CFrame.new(28672.720703125, 14889.1279296875, 454.5961608886719))
  elseif game:GetService("Players").LocalPlayer.Data.Race.Value == "Mink" then
  Game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
  wait(0.6)
  topos(CFrame.new(29020.66015625, 14889.4267578125, -379.2682800292969))
  end
  end)

R:Button("Stop Teleport",function()
 topos(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
  _G.Clip = false
end)

R:Label("\\\\ Finish Train Quest ( Beta ) ///")

R:Toggle("Auto Awe V4 ",false,function(v)
	_G.Rv4 = v    
end)

spawn(function()
    while wait() do
		pcall(function()
			if _G.Rv4 then
				game:GetService("VirtualInputManager"):SendKeyEvent(true,"Y",false,game)
                game:GetService("VirtualInputManager"):SendKeyEvent(false,"Y",false,game)
			end
		end)
    end
end)

R:Toggle("Auto Buy Gear",_G.Auto_Farm_Bone4,function(value)
 _G.Auto_Farm_Bone4 = value
 StopTween(_G.Auto_Farm_Bone4)
end)
spawn(function()
    pcall(function()
        while wait(0.1) do
            if _G.Auto_Farm_Bone4 then
    local args = {
    [1] = true
}

local args = {
    [1] = "UpgradeRace",
    [2] = "Buy"
}

game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
            end
end 
end)  
end)

R:Label("\\\\ Trial Pvp ///")

R:Toggle("Kill Players Trial ( Beta )",nil,function(value)
    local SuperFastMode = value -- เปลี่ยนเป็นจริงถ้าคุณต้องการโจมตี Super Super Super Fast (เช่นการฆ่าทันที) แต่จะทำให้เกมเตะคุณมากกว่าโหมดปกติ
             _G.aothatday = value


local plr = game.Players.LocalPlayer

local CbFw = debug.getupvalues(require(plr.PlayerScripts.CombatFramework))
local CbFw2 = CbFw[2]

function GetCurrentBlade() 
    local p13 = CbFw2.activeController
    local ret = p13.blades[1]
    if not ret then return end
    while ret.Parent~=game.Players.LocalPlayer.Character do ret=ret.Parent end
    return ret
end
function AttackNoCD() 
    local AC = CbFw2.activeController
    for i = 1, 1 do 
        local bladehit = require(game.ReplicatedStorage.CombatFramework.RigLib).getBladeHits(
            plr.Character,
            {plr.Character.HumanoidRootPart},
            60
        )
        local cac = {}
        local hash = {}
        for k, v in pairs(bladehit) do
            if v.Parent:FindFirstChild("HumanoidRootPart") and not hash[v.Parent] then
                table.insert(cac, v.Parent.HumanoidRootPart)
                hash[v.Parent] = true
            end
        end
        bladehit = cac
        if #bladehit > 0 then
            local u8 = debug.getupvalue(AC.attack, 5)
            local u9 = debug.getupvalue(AC.attack, 6)
            local u7 = debug.getupvalue(AC.attack, 4)
            local u10 = debug.getupvalue(AC.attack, 7)
            local u12 = (u8 * 798405 + u7 * 727595) % u9
            local u13 = u7 * 798405
            (function()
                u12 = (u12 * u9 + u13) % 1099511627776
                u8 = math.floor(u12 / u9)
                u7 = u12 - u8 * u9
            end)()
            u10 = u10 + 1
            debug.setupvalue(AC.attack, 5, u8)
            debug.setupvalue(AC.attack, 6, u9)
            debug.setupvalue(AC.attack, 4, u7)
            debug.setupvalue(AC.attack, 7, u10)
            pcall(function()
                for k, v in pairs(AC.animator.anims.basic) do
                    v:Play()
                end                  
            end)
            if plr.Character:FindFirstChildOfClass("Tool") and AC.blades and AC.blades[1] then 
                game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("weaponChange",tostring(GetCurrentBlade()))
                game.ReplicatedStorage.Remotes.Validator:FireServer(math.floor(u12 / 1099511627776 * 16777215), u10)
                game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("hit", bladehit, i, "") 
            end
        end
    end
end
local cac
if SuperFastMode then 
	cac=task.wait
else
	cac=wait
end
while cac() do 
	AttackNoCD()
end

    end)
  
  R:Button("Teleport To Safe Zone When Pvp",function()
  topos(CFrame.new(28273.0859375, 14896.5078125, 157.42063903808594))
  end)
  
  R:Button("Teleport Pvp Zone",function()
  topos(CFrame.new(28766.681640625, 14967.1455078125, -164.13290405273438))
  end)

R:Label("\\\\ Trial Race V4 //")
  
  R:Toggle("Auto Complete Trial Human/Ghoul",_G.Kill_Aura,function(value)
 _G.Kill_Aura = value  
end)

spawn(function()
    while wait() do
        if _G.Kill_Aura then
            for i,v in pairs(game.Workspace.Enemies:GetDescendants()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                    pcall(function()
                        repeat wait(.1)
                            v.Humanoid.Health = 0
                            v.HumanoidRootPart.CanCollide = false
							sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                        until not _G.Kill_Aura  or not v.Parent or v.Humanoid.Health <= 0
                    end)
                end
            end
        end
    end
end)

  R:Button("Auto Complete Trial Mink",function(t)
  topos(game:GetService("Workspace").Map.MinkTrial.Ceiling.CFrame * CFrame.new(0,-5,0))
  end)
  
  R:Button("Auto Complete Cyborg Trial",function(t)
  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,300,0)
  end)
  
  R:Button("Auto Complete Angel Trial",function(t)
  topos(game.Workspace.Map.SkyTrial.Model.FinishPart.CFrame)
  end)
		
----------------Stats


spawn(function()
	while wait() do
		pcall(function()
			Melee:Set("Melee : "..game.Players.localPlayer.Data.Stats.Melee.Level.Value)
		end)
	end
end)

spawn(function()
	while wait() do
		pcall(function()
			Defense:Set("Defense : "..game.Players.localPlayer.Data.Stats.Defense.Level.Value)
		end)
	end
end)

spawn(function()
	while wait() do
		pcall(function()
			Sword:Set("Sword : "..game.Players.localPlayer.Data.Stats.Sword.Level.Value)
		end)
	end
end)

spawn(function()
	while wait() do
		pcall(function()
			Gun:Set("Gun : "..game.Players.localPlayer.Data.Stats.Gun.Level.Value)
		end)
	end
end)

spawn(function()
	while wait() do
		pcall(function()
			Fruit:Set("Fruit : "..game.Players.localPlayer.Data.Stats["Demon Fruit"].Level.Value)
		end)
	end
end)
   
Stats:Toggle("Auto Stats Kaitun",_G.Auto_Stats_Kaitun,function(value)
_G.Auto_Stats_Kaitun = value
end)


spawn(function()
while wait() do
	pcall(function()
		if _G.Auto_Stats_Kaitun then
			if World1 then
				local args = {
					[1] = "AddPoint",
					[2] = "Melee",
					[3] = _G.Point
					}
					
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			elseif World2 then
				local args = {
					[1] = "AddPoint",
					[2] = "Melee",
					[3] = _G.Point
					}
					
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
				local args = {
					[1] = "AddPoint",
					[2] = "Defense",
					[3] = _G.Point
					}
					
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			end
		end
	end)
end
end)

Stats:Toggle("Melee",false,function(Value)
melee = Value    
end)
Stats:Toggle("Defense",false,function(value)
defense = value
end)
Stats:Toggle("Sword",false,function(value)
sword = value
end)
Stats:Toggle("Gun",false,function(value)
gun = value
end)
Stats:Toggle("Devil Fruit",false,function(value)
demonfruit = value
end)

PointStats = 1
Stats:Slider("Point",1,100,PointStats,nil,function(value)
PointStats = value
end)

spawn(function()
	while wait() do
		if game.Players.localPlayer.Data.Points.Value >= PointStats then
			if melee then
				local args = {
					[1] = "AddPoint",
					[2] = "Melee",
					[3] = PointStats
				}
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			end 
			if defense then
				local args = {
					[1] = "AddPoint",
					[2] = "Defense",
					[3] = PointStats
				}
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			end 
			if sword then
				local args = {
					[1] = "AddPoint",
					[2] = "Sword",
					[3] = PointStats
				}
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			end 
			if gun then
				local args = {
					[1] = "AddPoint",
					[2] = "Gun",
					[3] = PointStats
				}
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			end 
			if demonfruit then
				local args = {
					[1] = "AddPoint",
					[2] = "Demon Fruit",
					[3] = PointStats
				}
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			end
		end
	end
end)


----------------------Pvp



Pvp:Label("\\\\ Player //")
Playerslist = {}
    
for i,v in pairs(game:GetService("Players"):GetChildren()) do
	table.insert(Playerslist,v.Name)
end

local SelectedPly = Pvp:Dropdown("Player List",Playerslist,function(value)
	_G.SelectPly = value
end)

Pvp:Button("Refresh Player",function()
	Playerslist = {}
	SelectedPly:Clear()
	for i,v in pairs(game:GetService("Players"):GetChildren()) do  
		SelectedPly:Add(v.Name)
	end
end)

Pvp:Toggle("Spectate Player",false,function(value)
	SpectatePlys = value
	local plr1 = game:GetService("Players").LocalPlayer.Character.Humanoid
	local plr2 = game:GetService("Players"):FindFirstChild(_G.SelectPly)
	repeat wait(.1)
		game:GetService("Workspace").Camera.CameraSubject = game:GetService("Players"):FindFirstChild(_G.SelectPly).Character.Humanoid
	until SpectatePlys == false 
	game:GetService("Workspace").Camera.CameraSubject = game:GetService("Players").LocalPlayer.Character.Humanoid
end)

Pvp:Toggle("Teleport to Player",false,function(value)
	_G.TeleportPly = value
	pcall(function()
		if _G.TeleportPly then
			repeat topos(game:GetService("Players")[_G.SelectPly].Character.HumanoidRootPart.CFrame) wait() until _G.TeleportPly == false
		end
		StopTween(_G.TeleportPly)
	end)
end)

Pvp:Label("\\\\ Aimbot (Working) //")


Pvp:Toggle("Auto Aimbot Full SKill",false,function(value)
	_G.Aimbot_Skill_Fov = value
end)
local lp = game:GetService('Players').LocalPlayer
local mouse = lp:GetMouse()
spawn(function()
	while wait() do
		if _G.Aimbot_Skill_Fov then
			pcall(function()
				local MaxDist, Closest = math.huge
				for i,v in pairs(game:GetService("Players"):GetChildren()) do 
					local Head = v.Character:FindFirstChild("HumanoidRootPart")
					local Pos, Vis = game.Workspace.CurrentCamera.WorldToScreenPoint(game.Workspace.CurrentCamera, Head.Position)
					local MousePos, TheirPos = Vector2.new(mouse.X, mouse.Y), Vector2.new(Pos.X, Pos.Y)
					local Dist = (TheirPos - MousePos).Magnitude
					if Dist < MaxDist and Dist <= _G.Select_Size_Fov and v.Name ~= game.Players.LocalPlayer.Name then
						MaxDist = Dist
						_G.Aim_Players = v
					end
				end
			end)
		end
	end
end)
spawn(function()
	local gg = getrawmetatable(game)
	local old = gg.__namecall
	setreadonly(gg,false)
	gg.__namecall = newcclosure(function(...)
		local method = getnamecallmethod()
		local args = {...}
		if tostring(method) == "FireServer" then
			if tostring(args[1]) == "RemoteEvent" then
				if tostring(args[2]) ~= "true" and tostring(args[2]) ~= "false" then
					if _G.Aimbot_Skill_Fov then
						args[2] = _G.Aim_Players.Character.HumanoidRootPart.Position
						return old(unpack(args))
					end
				end
			end
		end
		return old(...)
	end)
end)


Pvp:Label("\\\\ Buff //")


Pvp:Toggle("Auto Active Race v3",false,function(v)
	_G.Rv3 = v    
end)
Pvp:Toggle("Auto Active Race v4",false,function(v)
	_G.Rv4 = v    
end)
Pvp:Toggle("Super Speed",true,function(v)
	_G.GsE = v    
end)
Pvp:Toggle("Dame Aura",false,function(v)
	_G.AccsF = v    
end)


Pvp:Toggle("Walk on Water",false,function(value)
	_G.WalkWater = value
end)

spawn(function()
		while task.wait() do
			pcall(function()
				if _G.WalkWater then
					game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000,112,1000)
				else
					game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000,80,1000)
				end
			end)
		end
	end)

Pvp:Toggle("Teleport to Save Place",false,function(v)
	_G.SaveModeSS = v    
end)
spawn(function()
    while wait() do
		pcall(function()
			if _G.SaveModeSS then
                local MeIs = game.Players.LocalPlayer.Name
				local MePosIs = game:GetService("Players")[MeIs].Character.HumanoidRootPart.CFrame
                topos(MePosIs*CFrame.new(0,30,0))
            end
		end)
    end
end)
spawn(function()
    while wait() do
		pcall(function()
			if _G.AccsF then
				Attack()
			end
		end)
    end
end)
spawn(function()
    while wait() do
		pcall(function()
			if _G.Rv3 then
				game:GetService("VirtualInputManager"):SendKeyEvent(true,"T",false,game)
                game:GetService("VirtualInputManager"):SendKeyEvent(false,"T",false,game)
			end
		end)
    end
end)
spawn(function()
    while wait() do
		pcall(function()
			if _G.Rv4 then
				game:GetService("VirtualInputManager"):SendKeyEvent(true,"Y",false,game)
                game:GetService("VirtualInputManager"):SendKeyEvent(false,"Y",false,game)
			end
		end)
    end
end)
spawn(function()
    while wait() do
		pcall(function()
			if _G.GsE then
				game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = 300
				game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = 300
				game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = 300
			end
		end)
    end
end)


---------Island

Island:Button("Teleport To Old World",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelMain")
end)

Island:Button("Teleport To Second Sea",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
end)

Island:Button("Teleport To Third Sea",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
end)

if World1 then
	Island:Dropdown("Island List",{
		"WindMill",
		"Marine",
		"Middle Town",
		"Jungle",
		"Pirate Village",
		"Desert",
		"Snow Island",
		"MarineFord",
		"Colosseum",
		"Sky Island 1",
		"Sky Island 2",
		"Sky Island 3",
		"Prison",
		"Magma Village",
		"Under Water Island",
		"Fountain City",
		"Shank Room",
		"Mob Island"
		},function(value)
		_G.SelectIsland = value
	end)
end

if World2 then
	Island:Dropdown("Island List",{
		"The Cafe",
		"Frist Spot",
		"Dark Area",
		"Flamingo Mansion",
		"Flamingo Room",
		"Green Zone",
		"Factory",
		"Colossuim",
		"Zombie Island",
		"Two Snow Mountain",
		"Punk Hazard",
		"Cursed Ship",
		"Ice Castle",
		"Forgotten Island",
		"Ussop Island",
		"Mini Sky Island"
		},function(value)
		_G.SelectIsland = value
	end)
end

if World3 then
	Island:Dropdown("Island List",{
		"Mansion",
		"Port Town",
		"Great Tree",
		"Castle On The Sea",
		"MiniSky", 
		"Hydra Island",
		"Floating Turtle",
		"Haunted Castle",
		"Ice Cream Island",
		"Peanut Island",
		"Cake Island",
		"Cocoa Island",
		"Candy Island New⛄"
		},function(value)
		_G.SelectIsland = value
	end)
end

Island:Toggle("Teleport",false,function(value)
	_G.TeleportIsland = value
	if _G.TeleportIsland == true then
		repeat wait()
			if _G.SelectIsland == "WindMill" then
				topos(CFrame.new(979.79895019531, 16.516613006592, 1429.0466308594))
			elseif _G.SelectIsland == "Marine" then
				topos(CFrame.new(-2566.4296875, 6.8556680679321, 2045.2561035156))
			elseif _G.SelectIsland == "Middle Town" then
				topos(CFrame.new(-690.33081054688, 15.09425163269, 1582.2380371094))
			elseif _G.SelectIsland == "Jungle" then
				topos(CFrame.new(-1612.7957763672, 36.852081298828, 149.12843322754))
			elseif _G.SelectIsland == "Pirate Village" then
				topos(CFrame.new(-1181.3093261719, 4.7514905929565, 3803.5456542969))
			elseif _G.SelectIsland == "Desert" then
				topos(CFrame.new(944.15789794922, 20.919729232788, 4373.3002929688))
			elseif _G.SelectIsland == "Snow Island" then
				topos(CFrame.new(1347.8067626953, 104.66806030273, -1319.7370605469))
			elseif _G.SelectIsland == "MarineFord" then
				topos(CFrame.new(-4914.8212890625, 50.963626861572, 4281.0278320313))
			elseif _G.SelectIsland == "Colosseum" then
				topos( CFrame.new(-1427.6203613281, 7.2881078720093, -2792.7722167969))
			elseif _G.SelectIsland == "Sky Island 1" then
				topos(CFrame.new(-4869.1025390625, 733.46051025391, -2667.0180664063))
			elseif _G.SelectIsland == "Sky Island 2" then  
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-4607.82275, 872.54248, -1667.55688))
			elseif _G.SelectIsland == "Sky Island 3" then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
			elseif _G.SelectIsland == "Prison" then
				topos( CFrame.new(4875.330078125, 5.6519818305969, 734.85021972656))
			elseif _G.SelectIsland == "Magma Village" then
				topos(CFrame.new(-5247.7163085938, 12.883934020996, 8504.96875))
			elseif _G.SelectIsland == "Under Water Island" then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
			elseif _G.SelectIsland == "Fountain City" then
				topos(CFrame.new(5127.1284179688, 59.501365661621, 4105.4458007813))
			elseif _G.SelectIsland == "Shank Room" then
				topos(CFrame.new(-1442.16553, 29.8788261, -28.3547478))
			elseif _G.SelectIsland == "Mob Island" then
				topos(CFrame.new(-2850.20068, 7.39224768, 5354.99268))
			elseif _G.SelectIsland == "The Cafe" then
				topos(CFrame.new(-380.47927856445, 77.220390319824, 255.82550048828))
			elseif _G.SelectIsland == "Frist Spot" then
				topos(CFrame.new(-11.311455726624, 29.276733398438, 2771.5224609375))
			elseif _G.SelectIsland == "Dark Area" then
				topos(CFrame.new(3780.0302734375, 22.652164459229, -3498.5859375))
			elseif _G.SelectIsland == "Flamingo Mansion" then
				topos(CFrame.new(-483.73370361328, 332.0383605957, 595.32708740234))
			elseif _G.SelectIsland == "Flamingo Room" then
				topos(CFrame.new(2284.4140625, 15.152037620544, 875.72534179688))
			elseif _G.SelectIsland == "Green Zone" then
				topos( CFrame.new(-2448.5300292969, 73.016105651855, -3210.6306152344))
			elseif _G.SelectIsland == "Factory" then
				topos(CFrame.new(424.12698364258, 211.16171264648, -427.54049682617))
			elseif _G.SelectIsland == "Colossuim" then
				topos( CFrame.new(-1503.6224365234, 219.7956237793, 1369.3101806641))
			elseif _G.SelectIsland == "Zombie Island" then
				topos(CFrame.new(-5622.033203125, 492.19604492188, -781.78552246094))
			elseif _G.SelectIsland == "Two Snow Mountain" then
				topos(CFrame.new(753.14288330078, 408.23559570313, -5274.6147460938))
			elseif _G.SelectIsland == "Punk Hazard" then
				topos(CFrame.new(-6127.654296875, 15.951762199402, -5040.2861328125))
			elseif _G.SelectIsland == "Cursed Ship" then
				topos(CFrame.new(923.40197753906, 125.05712890625, 32885.875))
			elseif _G.SelectIsland == "Ice Castle" then
				topos(CFrame.new(6148.4116210938, 294.38687133789, -6741.1166992188))
			elseif _G.SelectIsland == "Forgotten Island" then
				topos(CFrame.new(-3032.7641601563, 317.89672851563, -10075.373046875))
			elseif _G.SelectIsland == "Ussop Island" then
				topos(CFrame.new(4816.8618164063, 8.4599885940552, 2863.8195800781))
			elseif _G.SelectIsland == "Mini Sky Island" then
				topos(CFrame.new(-288.74060058594, 49326.31640625, -35248.59375))
			elseif _G.SelectIsland == "Great Tree" then
				topos(CFrame.new(2681.2736816406, 1682.8092041016, -7190.9853515625))
			elseif _G.SelectIsland == "Castle On The Sea" then
				topos(CFrame.new(-5074.45556640625, 314.5155334472656, -2991.054443359375))
			elseif _G.SelectIsland == "MiniSky" then
				topos(CFrame.new(-260.65557861328, 49325.8046875, -35253.5703125))
			elseif _G.SelectIsland == "Port Town" then
				topos(CFrame.new(-290.7376708984375, 6.729952812194824, 5343.5537109375))
			elseif _G.SelectIsland == "Hydra Island" then
				topos(CFrame.new(5228.8842773438, 604.23400878906, 345.0400390625))
			elseif _G.SelectIsland == "Floating Turtle" then
				topos(CFrame.new(-13274.528320313, 531.82073974609, -7579.22265625))
			elseif _G.SelectIsland == "Mansion" then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))
			elseif _G.SelectIsland == "Haunted Castle" then
				topos(CFrame.new(-9515.3720703125, 164.00624084473, 5786.0610351562))
			elseif _G.SelectIsland == "Ice Cream Island" then
				topos(CFrame.new(-902.56817626953, 79.93204498291, -10988.84765625))
			elseif _G.SelectIsland == "Peanut Island" then
				topos(CFrame.new(-2062.7475585938, 50.473892211914, -10232.568359375))
			elseif _G.SelectIsland == "Cake Island" then
				topos(CFrame.new(-1884.7747802734375, 19.327526092529297, -11666.8974609375))
			elseif _G.SelectIsland == "Cocoa Island" then
				topos(CFrame.new(87.94276428222656, 73.55451202392578, -12319.46484375))
			elseif _G.SelectIsland == "Candy Island New⛄" then
				topos(CFrame.new(-1014.4241943359375, 149.11068725585938, -14555.962890625))
			end
		until not _G.TeleportIsland
	end
	StopTween(_G.TeleportIsland)
end)


--------------Raid
if World1 then
    Raid:Label("Dungeon Raid Only Available At Sea 2 and 3")
end

if World2 or World3 then
Raid:Label("Use in Dungeon Only!")

chip = {
	"Flame", 
	"Ice", 
	"Quake", 
	"Light",
	"Dark",
	"String",
	"Rumble",
	"Magma",
	"Human: Buddha",
	"Sand",
	"Bird: Phoenix"
}

Raid:Dropdown("Select Dungeon",chip,function(value)
 _G.Select_Dungeon = value
end)
 
Raid:Button("Auto Buy Chip",function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaidsNpc","Select",_G.Select_Dungeon)
end)

Raid:Button("Auto Start Raid",function()
    if World2 then
        fireclickdetector(game:GetService("Workspace").Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)
    elseif World3 then
        fireclickdetector(game:GetService("Workspace").Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector)
     end
 end)
 
    if World2 then
        Raid:Button("Teleport to Lab",function()
            TP(CFrame.new(-6438.73535, 250.645355, -4501.50684))
            end)
    elseif World3 then
        Raid:Button("Teleport to Lab",function()
            TP(CFrame.new(-5017.40869, 314.844055, -2823.0127, -0.925743818, 4.48217499e-08, -0.378151238, 4.55503146e-09, 1, 1.07377559e-07, 0.378151238, 9.7681621e-08, -0.925743818))
        end)
        end
		
Raid:Toggle("Auto Buy Chip Raid",_G.Auto_Buy_Chips_Dungeon,function(value)
 _G.Auto_Buy_Chips_Dungeon = value
end)


spawn(function()
    while wait() do
		if _G.Auto_Buy_Chips_Dungeon then
			pcall(function()
				local args = {
					[1] = "RaidsNpc",
					[2] = "Select",
					[3] = _G.Select_Dungeon
				}
				
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			end)
		end
    end
end)


Raid:Toggle("Auto Start Raid",_G.Auto_StartRaid,function(value)
 _G.Auto_StartRaid = value
end)

spawn(function()
    while wait(.1) do
        pcall(function()
            if _G.Auto_StartRaid then
                if game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Timer.Visible == false then
                    if not game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1") and game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Special Microchip") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Special Microchip") then
                        if World2 then
                            fireclickdetector(game:GetService("Workspace").Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)
                        elseif World3 then
                            fireclickdetector(game:GetService("Workspace").Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector)
                        end
                    end
                end
            end
        end)
    end
    end)

Raid:Toggle("Auto Next Island",_G.Auto_Next_Island,function(value)
 _G.Auto_Next_Island = value
end)

spawn(function()
    while wait() do
        if _G.Auto_Next_Island then
			if not game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == false then
				if game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 5") then
					topos(game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 5").CFrame * CFrame.new(0,70,100))
				elseif game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 4") then
					topos(game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 4").CFrame * CFrame.new(0,70,100))
				elseif game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 3") then
					topos(game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 3").CFrame * CFrame.new(0,70,100))
				elseif game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 2") then
					topos(game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 2").CFrame * CFrame.new(0,70,100))
				elseif game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1") then
					topos(game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1").CFrame * CFrame.new(0,70,100))
				end
			end
        end
    end
end)

Raid:Toggle("Kill Aura",_G.Kill_Aura,function(value)
 _G.Kill_Aura = value  
end)

spawn(function()
    while wait() do
        if _G.Kill_Aura then
            for i,v in pairs(game.Workspace.Enemies:GetDescendants()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                    pcall(function()
                        repeat wait(.1)
                            v.Humanoid.Health = 0
                            v.HumanoidRootPart.CanCollide = false
							sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                        until not _G.Kill_Aura  or not v.Parent or v.Humanoid.Health <= 0
                    end)
                end
            end
        end
    end
end)

Raid:Toggle("Auto Awake",_G.Auto_Awake,function(value)
 _G.Auto_Awake = value 
end)


spawn(function()
	while wait(.1) do
		if _G.Auto_Awake then
			pcall(function()
				local args = {
					[1] = "Awakener",
					[2] = "Check"
				}
				
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
				local args = {
					[1] = "Awakener",
					[2] = "Awaken"
				}
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			end)
		end
	end
end)
end


----------------Fruit
Fruit:Label("\\\\ Fruit //")
 


Fruit:Toggle("Auto Random Fruit",_G.Random_Auto,function(value)
	_G.Random_Auto = value
end)

spawn(function()
	pcall(function()
		while wait(.1) do
			if _G.Random_Auto then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin","Buy")
			end 
		end
	end)
end)




Fruit:Toggle("Auto Store Fruit",_G.AutoStoreFruit,function(value)
	_G.AutoStoreFruit = value
end)

function DropFruit()
pcall(function()
	game.Players.LocalPlayer.PlayerGui.Main.FruitInventory.Position = UDim2.new(10.100, 0, 0.100, 0) -- HideUi
	game.Players.LocalPlayer.PlayerGui.Main.FruitInventory.Visible = true -- เปิดไว้ถึงจะเช็คได้
	local invenfruit = game.Players.LocalPlayer.PlayerGui.Main.FruitInventory.Container.Stored.ScrollingFrame.Frame
	wait(.3)
	for i,v in pairs(invenfruit:GetChildren()) do
		if string.find(v.Name,"-") then
			for _,Backpack in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
				FruitStoreF = string.split(Backpack.Name, " ")[1]
				FruitStoreR = FruitStoreF.."-"..FruitStoreF
				if v.Name == FruitStoreR then
					game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(Backpack.Name):Destroy()
				end												
			end
		end
	end
	for i,v in pairs(invenfruit:GetChildren()) do
		if string.find(v.Name,"-") then
			for _,Character in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
				FruitStoreF = string.split(Character.Name, " ")[1]
				FruitStoreR = FruitStoreF.."-"..FruitStoreF
				if v.Name == FruitStoreR then
					game:GetService("Players").LocalPlayer.Character:FindFirstChild(Character.Name):Destroy()
				end												
			end
		end
	end
end)
end

spawn(function()
while wait() do
	if _G.AutoStoreFruit then
		pcall(function()
			DropFruit()
			wait()
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Bomb Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Bomb Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Bomb-Bomb",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Bomb Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Bomb Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Spike Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spike Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Spike-Spike",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Spike Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spike Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Chop Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Chop Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Chop-Chop",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Chop Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Chop Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Spring Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spring Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Spring-Spring",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Spring Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spring Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Kilo Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Kilo Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Kilo-Kilo",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Kilo Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Kilo Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Smoke Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Smoke Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Smoke-Smoke",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Smoke Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Smoke Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Spin Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spin Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Spin-Spin",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Spin Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Spin Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Flame Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Flame Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Flame-Flame",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Flame Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Flame Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Bird: Falcon Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Bird: Falcon Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Bird-Bird: Falcon",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Bird: Falcon Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Bird: Falcon Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Ice Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Ice Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Ice-Ice",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Ice Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Ice Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Sand Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Sand Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Sand-Sand",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Sand Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Sand Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dark Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dark Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Dark-Dark",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dark Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dark Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Revive Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Revive Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Revive-Revive",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Revive Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Revive Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Diamond Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Diamond Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Diamond-Diamond",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Diamond Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Diamond Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Light Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Light Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Light-Light",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Light Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Light Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Love Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Love Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Love-Love",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Love Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Love Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Rubber Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Rubber Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Rubber-Rubber",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Rubber Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Rubber Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Barrier Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Barrier Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Barrier-Barrier",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Barrier Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Barrier Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Magma Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Magma Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Magma-Magma",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Magma Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Magma Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Portal Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Door Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Portal-Portal",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Door Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Door Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Quake Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Quake Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Quake-Quake",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Quake Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Quake Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Human-Human: Buddha Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Human-Human: Buddha Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Human-Human: Buddha",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Human-Human: Buddha Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Human-Human: Buddha Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Spider Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("String Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Spider-Spider",game:GetService("Players").LocalPlayer.Character:FindFirstChild("String Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("String Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Bird: Phoenix Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Bird: Phoenix Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Bird-Bird: Phoenix",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Bird: Phoenix Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Bird: Phoenix Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Rumble Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Rumble Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Rumble-Rumble",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Rumble Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Rumble Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Paw Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Paw Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Paw-Paw",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Paw Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Paw Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Gravity Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Gravity Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Gravity-Gravity",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Gravity Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Gravity Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dough Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dough Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Dough-Dough",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dough Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dough Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Shadow Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Shadow Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Shadow-Shadow",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Shadow Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Shadow Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Venom Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Venom Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Venom-Venom",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Venom Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Venom Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Control Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Control Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Control-Control",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Control Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Control Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dragon Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dragon Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Dragon-Dragon",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dragon Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Dragon Fruit"))
			end
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Leopard Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Leopard Fruit") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit","Leopard-Leopard",game:GetService("Players").LocalPlayer.Character:FindFirstChild("Leopard Fruit") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Leopard Fruit"))
			end
		end)
	 end
   end
end)


 Fruit:Toggle("Teleport To Fruit",false,function(value)
 _G.Grabfruit = value
end)

spawn(function()
			while wait(.1) do
				if _G.Grabfruit then
					for i,v in pairs(game.Workspace:GetChildren()) do
						if string.find(v.Name, "Fruit") then
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
						end
					end
				end
end
end)





Fruit:Label("\\\\ ESP //")

Fruit:Toggle("ESP Player",false,function(a)
	ESPPlayer = a
UpdatePlayerChams()
end)

Fruit:Toggle("ESP Chest",false,function(a)
	ChestESP = a
UpdateChestChams() 
end)

Fruit:Toggle("ESP Fruit",false,function(a)
	DevilFruitESP = a
	while DevilFruitESP do wait()
		UpdateDevilChams() 
	end
end)


Fruit:Toggle("ESP Flower",false,function(a)
	FlowerESP = a
UpdateFlowerChams() 
end)
spawn(function()
	while wait(2) do
		if FlowerESP then
			UpdateFlowerChams() 
		end
		if DevilFruitESP then
			UpdateDevilChams() 
		end
		if ChestESP then
			UpdateChestChams() 
		end
		if ESPPlayer then
			UpdatePlayerChams()
		end
		if RealFruitESP then
			UpdateRealFruitChams()
		end
	end
end)
Fruit:Toggle("ESP Island",IslandESP,function(value)
	IslandESP = value
	while IslandESP do wait()
		UpdateIslandESP() 
	end
end)







-------------shop


S:Label("\\\\ Abilities //")
    
S:Button("Buy Geppo",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Geppo")
end)

S:Button("Buy Buso Haki",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Buso")
end)

S:Button("Buy Soru",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Soru")
end)

S:Button("Buy Observation Haki",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("KenTalk","Buy")
end)

S:Toggle("Auto Buy Abilities", false, function(t)
Abilities = t
while Abilities do wait(.1)
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Geppo")
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Buso")
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Soru")
end
end)



S:Label("\\\\ Fighting Style //")
    
S:Button("Buy Black Leg [ $150,000 Beli ]",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBlackLeg")
end)

S:Button("Buy Electro [ $550,000 Beli ]",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectro")
end)

S:Button("Buy Fishman Karate [ $750,000 Beli ]",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyFishmanKarate")
end)

S:Button("Buy Dragon Claw [ $1,500 Fragments ]",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","1")
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","2")
end)

S:Button("Buy Superhuman [ $3,000,000 Beli ]",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySuperhuman")
end)

S:Button("Buy Death Step [ $5,000 Fragments $5,000,000 Beli ]",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep")
end)

S:Button("Buy Sharkman Karate [ $5,000 Fragments $2,500,000 Beli ]",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate",true)
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate")
end)

S:Button("Buy Electric Claw [ $5,000 Fragments $3,000,000 Beli ]",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw")
end)

S:Button("Buy Dragon Talon [ $5,000 Fragments $3,000,000 Beli ]",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon")
end)

S:Button("Buy God Human [ $5,000 Fragments $5,000,000 Beli ]",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman")
end)
-----Shop----------------

S:Label("\\\\ Sword //")

S:Button("Cutlass [ $1,000 Beli ]",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Cutlass")
end)

S:Button("Katana [ $1,000 Beli ]",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Katana")
end)

S:Button("Iron Mace [ $25,000 Beli ]",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Iron Mace")
end)

S:Button("Dual Katana [ $12,000 Beli ]",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Duel Katana")
end)

S:Button("Triple Katana [ $60,000 Beli ]", function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Triple Katana")
end)

S:Button("Pipe [ $100,000 Beli ]",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Pipe")
end)

S:Button("Dual-Headed Blade [ $400,000 Beli ]",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Dual-Headed Blade")
end)

S:Button("Bisento [ $1,200,000 Beli ]",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Bisento")
end)

S:Button("Soul Cane [ $750,000 Beli ]",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Soul Cane")
end)


S:Label("\\\\ Gun //")

S:Button("Slingshot [ $5,000 Beli ]",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Slingshot")
end)

S:Button("Musket [ $8,000 Beli ]",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Musket")
end)

S:Button("Flintlock [ $10,500 Beli ]",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Flintlock")
end)

S:Button("Refined Slingshot [ $30,000 Beli ]",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Refined Flintlock")
end)

S:Button("Refined Flintlock [ $65,000 Beli ]",function()
	local args = {
		[1] = "BuyItem",
		[2] = "Refined Flintlock"
	}
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end)

S:Button("Cannon [ $100,000 Beli ]",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Cannon")
end)

S:Button("Kabucha [ 1,500 Fragments]",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Slingshot","1")
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Slingshot","2")
end)

	  S:Button("Bizarre Rifle [ 250 Ectoplasm ]", function()
								local A_1 = "Ectoplasm"
								local A_2 = "Buy"
								local A_3 = 1
								local Event = game:GetService("ReplicatedStorage").Remotes["CommF_"]
								Event:InvokeServer(A_1, A_2, A_3) 
								local A_1 = "Ectoplasm"
								local A_2 = "Buy"
								local A_3 = 1
								local Event = game:GetService("ReplicatedStorage").Remotes["CommF_"]
								Event:InvokeServer(A_1, A_2, A_3)
							end)


------------Stat------------------

S:Label("\\\\ Stats //")

S:Button("Reset Stats (Use 2.5K Fragments)", function()
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Refund","1")
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Refund","2")
end)

S:Button("Random Race (Use 3K Fragments)", function()
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Reroll","1")
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Reroll","2")
end)
--------------Accessories-----------------
	S:Label("\\\\ Accessories //")
S:Button("Black Cape [ $50,000 Beli ]",function()
	local args = {
		[1] = "BuyItem",
		[2] = "Black Cape"
	}
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end)
S:Button("Swordsman Hat [ 150k Beli ]",function()
	local args = {
		[1] = "BuyItem",
		[2] = "Swordsman Hat"
	}
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end)
S:Button("Tomoe Ring [ $500k Beli ]",function()
	local args = {
		[1] = "BuyItem",
		[2] = "Tomoe Ring"
	}
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end)

-----Misc


Misc:Label("\\\\ Server //")
    
Misc:Button("Rejoin Server",function()
	game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
end)

Misc:Button("Server Hop",function()
	Hop()
end)

Misc:Button("Hop To Lower Player",function()
	getgenv().AutoTeleport = true
	getgenv().DontTeleportTheSameNumber = true 
	getgenv().CopytoClipboard = false
	if not game:IsLoaded() then
		print("Game is loading waiting...")
	end
	local maxplayers = math.huge
	local serversmaxplayer;
	local goodserver;
	local gamelink = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100" 
	function serversearch()
		for _, v in pairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync(gamelink)).data) do
			if type(v) == "table" and v.playing ~= nil and maxplayers > v.playing then
				serversmaxplayer = v.maxPlayers
				maxplayers = v.playing
				goodserver = v.id
			end
		end       
	end
	function getservers()
		serversearch()
		for i,v in pairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync(gamelink))) do
			if i == "nextPageCursor" then
				if gamelink:find("&cursor=") then
					local a = gamelink:find("&cursor=")
					local b = gamelink:sub(a)
					gamelink = gamelink:gsub(b, "")
				end
				gamelink = gamelink .. "&cursor=" ..v
				getservers()
			end
		end
	end 
	getservers()
	if AutoTeleport then
		if DontTeleportTheSameNumber then 
			if #game:GetService("Players"):GetPlayers() - 4  == maxplayers then
				return warn("It has same number of players (except you)")
			elseif goodserver == game.JobId then
				return warn("Your current server is the most empty server atm") 
			end
		end
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, goodserver)
	end
end)



Misc:Label("\\\\ Open Ui //")
    
Misc:Button("Open Devil Shop",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits")
	game:GetService("Players").LocalPlayer.PlayerGui.Main.FruitShop.Visible = true
end)



Misc:Button("Title Name",function()
local args = {
	[1] = "getTitles"
}
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
game.Players.localPlayer.PlayerGui.Main.Titles.Visible = true
end)

Misc:Button("Color Haki",function()
game.Players.localPlayer.PlayerGui.Main.Colors.Visible = true
end)
  
Misc:Label("\\\\ Teams //")

Misc:Button("Join Pirates Team",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam","Pirates") 
end)

Misc:Button("Join Marines Team",function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam","Marines") 
end)


Misc:Label("\\\\ Misc //")

Misc:Toggle("Anti AFK", true, function()
local vu = game:GetService("VirtualUser")
repeat wait() until game:IsLoaded() 
	game:GetService("Players").LocalPlayer.Idled:connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
		vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
		wait(1)
		vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   end)
end)

	Misc:Toggle("Auto Rejoin",true,function(value)
		_G.AutoRejoin = value
	end)

	spawn(function()
	    while wait() do
	        if _G.AutoRejoin then
	                getgenv().rejoin = game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
                        if child.Name == 'ErrorPrompt' and child:FindFirstChild('MessageArea') and child.MessageArea:FindFirstChild("ErrorFrame") then
                            game:GetService("TeleportService"):Teleport(game.PlaceId)
                        end
                     end)
	            end
	        end
	    end)


		Misc:Button("Boost Fps", function()
			for i,v in pairs(game.Workspace.Map:GetDescendants()) do
				if v.Name == "Tavern" or v.Name == "SmileFactory" or v.Name == "Tree" or v.Name == "Rocks" or v.Name == "PartHouse" or v.Name == "Hotel" or v.Name == "WallPiece" or v.Name == "MiddlePillars" or v.Name == "Cloud" or v.Name == "PluginGrass" or v.Name == "BigHouse" or v.Name == "SmallHouse" or v.Name == "Detail" then
					v:Destroy()
				end
			end 
			for i,v in pairs(game.ReplicatedStorage.Unloaded:GetDescendants()) do
				if v.Name == "Tavern" or v.Name == "SmileFactory" or v.Name == "Tree" or v.Name == "Rocks" or v.Name == "PartHouse" or v.Name == "Hotel" or v.Name == "WallPiece" or v.Name == "MiddlePillars" or v.Name == "Cloud" or v.Name == "PluginGrass" or v.Name == "BigHouse" or v.Name == "SmallHouse" or v.Name == "Detail" then
					v:Destroy()
				end
			end
			for i,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
				if v:IsA("Accessory") or v.Name == "Pants" or v.Name == "Shirt" then
					v:Destroy()
				end
			end
			local decalsyeeted = true -- Leaving this on makes games look shitty but the fps goes up by at least 20.
			local g = game
			local w = g.Workspace
			local l = g.Lighting
			local t = w.Terrain
			t.WaterWaveSize = 0
			t.WaterWaveSpeed = 0
			t.WaterReflectance = 0
			t.WaterTransparency = 0
			l.GlobalShadows = false
			l.FogEnd = 9e9
			l.Brightness = 0
			settings().Rendering.QualityLevel = "Level01"
			for i, v in pairs(g:GetDescendants()) do
				if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
					v.Material = "Plastic"
					v.Reflectance = 0
				elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
					v.Transparency = 1
				elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
					v.Lifetime = NumberRange.new(0)
				elseif v:IsA("Explosion") then
					v.BlastPressure = 1
					v.BlastRadius = 1
				elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
					v.Enabled = false
				elseif v:IsA("MeshPart") then
					v.Material = "Plastic"
					v.Reflectance = 0
					v.TextureID = 10385902758728957
				end
			end
			for i, e in pairs(l:GetChildren()) do
				if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
					e.Enabled = false
				end
			end
			end)
 
