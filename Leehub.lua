local LeehHub = { Themes = {}, Icons = {}, CurrentTheme = nil, Windows = {} }

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")

local DefaultIcons = {
	["home"] = "rbxassetid://10723407389",
	["user"] = "rbxassetid://10747373176",
	["settings"] = "rbxassetid://10734950309",
	["search"] = "rbxassetid://10734934585",
	["bell"] = "rbxassetid://10723045999",
	["chevron-down"] = "rbxassetid://10709790948",
	["check"] = "rbxassetid://10709790644",
	["minus"] = "rbxassetid://10747384394",
	["arrow-up-right"] = "rbxassetid://10709790487",
	["plus"] = "rbxassetid://10709791437",
	["x"] = "rbxassetid://10747384394",
	["play"] = "rbxassetid://10734897102",
	["pause"] = "rbxassetid://10734896341",
	["stop"] = "rbxassetid://10734897820",
	["folder"] = "rbxassetid://10723415324",
	["file"] = "rbxassetid://10723415324",
	["image"] = "rbxassetid://10734919131",
	["video"] = "rbxassetid://10734897102",
	["key"] = "rbxassetid://10734950309",
	["lock"] = "rbxassetid://10734950309",
	["star"] = "rbxassetid://10734919131",
	["heart"] = "rbxassetid://10734919131",
	["code"] = "rbxassetid://10734950309",
	["terminal"] = "rbxassetid://10734950309",
	["gamepad"] = "rbxassetid://10747373176",
	["sword"] = "rbxassetid://10734919131",
	["shield"] = "rbxassetid://10734919131",
	["zap"] = "rbxassetid://10734919131",
	["eye"] = "rbxassetid://10734934585",
	["eye-off"] = "rbxassetid://10734934585",
	["trash"] = "rbxassetid://10747384394",
	["edit"] = "rbxassetid://10734950309",
	["copy"] = "rbxassetid://10734950309",
	["download"] = "rbxassetid://10734950309",
	["upload"] = "rbxassetid://10734950309",
	["refresh"] = "rbxassetid://10734950309",
	["info"] = "rbxassetid://10723045999",
	["warning"] = "rbxassetid://10723045999",
	["error"] = "rbxassetid://10723045999",
	["success"] = "rbxassetid://10709790644",
}

local success, result = pcall(function()
	return game:HttpGet("https://gist.githubusercontent.com/Styx-ui/326e7d2471fca9e908649a19d829f9e3/raw/d037c62a10765eb4f890d8983c27c626630657fd/Icons")
end)
if success and result and result ~= "" then
	local loadSuccess, loadedIcons = pcall(function()
		return loadstring(result)()
	end)
	if loadSuccess and type(loadedIcons) == "table" then
		for k, v in pairs(loadedIcons) do
			DefaultIcons[k] = v
		end
	end
end

LeehHub.Icons = DefaultIcons

local function GetUrlExtension(url, allowed, fallback)
	local clean = string.match(url, "^[^%?#]+") or url
	local ext = string.match(clean, "%.([%a%d]+)$")
	if ext then
		ext = string.lower(ext)
		for _, a in ipairs(allowed) do
			if a == ext then return ext end
		end
	end
	return fallback
end

local function NormalizeImageSource(input)
	if input == nil then return "" end
	if type(input) == "number" then return "rbxassetid://" .. tostring(input) end
	if type(input) ~= "string" or input == "" then return "" end
	if string.match(input, "^rbxassetid://") or string.match(input, "^rbxthumb://") or string.match(input, "^rbxasset://") then return input end
	if string.match(input, "^%d+$") then return "rbxassetid://" .. input end
	if string.match(input, "^https?://") then
		local url = input
		local ghUser, ghPath = string.match(url, "github%.com/([^/]+/[^/]+)/blob/(.+)$")
		if ghUser and ghPath then
			url = "https://raw.githubusercontent.com/" .. ghUser .. "/" .. ghPath
		end
		if writefile and isfile and getcustomasset then
			local ext = GetUrlExtension(url, {"png", "jpg", "jpeg", "gif", "webp", "bmp"}, "png")
			local safeName = string.gsub(url, "[^%w]", "_")
			local cacheFolder = "LeehHub_Cache"
			local cachePath = cacheFolder .. "/" .. safeName .. "." .. ext
			local ok = pcall(function()
				if makefolder and isfolder and not isfolder(cacheFolder) then makefolder(cacheFolder) end
				if not isfile(cachePath) then
					local data = game:HttpGet(url)
					writefile(cachePath, data)
				end
			end)
			if ok then
				local assetOk, assetId = pcall(function() return getcustomasset(cachePath) end)
				if assetOk and assetId then return assetId end
			end
		end
		return ""
	end
	return input
end

local function NormalizeVideoSource(input)
	if input == nil or input == "" then return "" end
	if type(input) == "number" then return "rbxassetid://" .. tostring(input) end
	if type(input) ~= "string" then return "" end
	if string.match(input, "^rbxassetid://") or string.match(input, "^rbxasset://") then return input end
	if string.match(input, "^%d+$") then return "rbxassetid://" .. input end
	if string.match(input, "^https?://") then
		if not (isfolder and makefolder and writefile and getcustomasset and isfile) then return input end

		local ext = GetUrlExtension(input, {"mp4", "webm", "mp3", "ogg", "wav", "gif"}, "mp4")
		local safeName = string.gsub(input, "[^%w]", "_")
		local cacheFolder = "LeehHub_Cache"
		local filePath = cacheFolder .. "/" .. safeName .. "." .. ext

		local ok = pcall(function()
			if not isfolder(cacheFolder) then makefolder(cacheFolder) end
			if isfile(filePath) then return end
			local data = game:HttpGet(input)
			if data and #data > 0 then
				writefile(filePath, data)
			end
		end)

		if ok and isfile(filePath) then
			local assetOk, assetId = pcall(function() return getcustomasset(filePath) end)
			if assetOk and assetId then return assetId end
		end
		return input
	end
	return input
end

function LeehHub:AddIcons(packName, iconsData)
	if type(packName) ~= "string" or type(iconsData) ~= "table" then return false end
	for key, value in pairs(iconsData) do
		if type(value) == "number" then
			LeehHub.Icons[key] = "rbxassetid://" .. tostring(value)
		elseif type(value) == "string" then
			LeehHub.Icons[key] = value
		elseif type(value) == "table" and value.Image then
			LeehHub.Icons[key] = NormalizeImageSource(value.Image)
		end
	end
	return true
end

function LeehHub:GetThemes()
	return LeehHub.Themes
end

function LeehHub:SetTheme(name)
	for _, window in ipairs(LeehHub.Windows) do
		if window and window.SetTheme then
			window:SetTheme(name)
		end
	end
end

local function AddCorner(radius, parent)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

local function AddStroke(parent, color, thickness, transparency)
	local s = Instance.new("UIStroke")
	s.Color = color or Color3.fromRGB(60, 60, 65)
	s.Thickness = thickness or 1
	s.Transparency = transparency or 0.3
	s.Parent = parent
	return s
end

local function AddGlassShine(parent, cornerRadius)
	parent.ClipsDescendants = true
	local shine = Instance.new("Frame")
	shine.Name = "GlassShine"
	shine.Size = UDim2.fromScale(1, 1)
	shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	shine.BorderSizePixel = 0
	shine.ZIndex = (parent.ZIndex or 1) + 1
	shine.Parent = parent
	local grad = Instance.new("UIGradient")
	grad.Rotation = 65
	grad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.82),
		NumberSequenceKeypoint.new(0.35, 0.96),
		NumberSequenceKeypoint.new(1, 1),
	})
	grad.Parent = shine
	if cornerRadius then AddCorner(cornerRadius, shine) end
	return shine
end

local function ApplyThemeValue(instance, prop, value)
	if type(value) == "table" and value.Type == "Gradient" then
		instance[prop] = Color3.fromRGB(255, 255, 255)
		local grad = instance:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")
		grad.Color = value.ColorSequence
		grad.Rotation = value.Rotation or 0
		grad.Parent = instance
	elseif typeof(value) == "Color3" then
		local grad = instance:FindFirstChildOfClass("UIGradient")
		if grad then grad:Destroy() end
		instance[prop] = value
	end
end

local function Elevate(color, amount)
	if typeof(color) ~= "Color3" then return Color3.fromRGB(24, 24, 27) end
	amount = amount or 0.07
	local luminance = 0.299 * color.R + 0.587 * color.G + 0.114 * color.B
	if luminance > 0.5 then
		return Color3.new(math.max(0, color.R - amount), math.max(0, color.G - amount), math.max(0, color.B - amount))
	end
	return Color3.new(math.min(1, color.R + amount), math.min(1, color.G + amount), math.min(1, color.B + amount))
end

local function TW(obj, t, props)
	local anim = TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
	anim:Play()
	return anim
end

function LeehHub:Gradient(keys, config)
	local keypoints = {}
	for pos, data in pairs(keys) do
		local p = tonumber(pos) / 100
		table.insert(keypoints, ColorSequenceKeypoint.new(p, data.Color))
	end
	table.sort(keypoints, function(a, b) return a.Time < b.Time end)
	return {
		Type = "Gradient",
		ColorSequence = ColorSequence.new(keypoints),
		Rotation = config and config.Rotation or 0,
	}
end

local function MakeTheme(name, accent, outline, toggle, slider)
	return {
		Name = name,
		Accent = Color3.fromHex(accent),
		Outline = Color3.fromHex(outline or accent),
		Text = Color3.fromHex("#F8FAFC"),
		Placeholder = Color3.fromHex("#A1A1AA"),
		Icon = Color3.fromHex(outline or accent),
		Toggle = Color3.fromHex(toggle or accent),
		Slider = Color3.fromHex(slider or accent),
		ElementBackground = Color3.fromRGB(18, 18, 22),
		Background = Color3.fromRGB(10, 10, 13),
	}
end

LeehHub.Themes.Aurora = MakeTheme("Aurora", "#22D3EE", "#A5F3FC", "#A78BFA", "#22D3EE")
LeehHub.Themes.NeonPurple = MakeTheme("NeonPurple", "#C026D3", "#F0ABFC", "#D946EF", "#A21CAF")
LeehHub.Themes.NeonCyan = MakeTheme("NeonCyan", "#06B6D4", "#67E8F9", "#22D3EE", "#0891B2")
LeehHub.Themes.NeonPink = MakeTheme("NeonPink", "#EC4899", "#F9A8D4", "#F472B6", "#DB2777")
LeehHub.Themes.NeonLime = MakeTheme("NeonLime", "#84CC16", "#D9F99D", "#A3E635", "#65A30D")
LeehHub.Themes.NeonOrange = MakeTheme("NeonOrange", "#F97316", "#FDBA74", "#FB923C", "#EA580C")
LeehHub.Themes.Synthwave = MakeTheme("Synthwave", "#F0299B", "#C084FC", "#8B5CF6", "#EC4899")
LeehHub.Themes.Cyberpunk = MakeTheme("Cyberpunk", "#FACC15", "#F472B6", "#FDE047", "#EAB308")
LeehHub.Themes.Toxic = MakeTheme("Toxic", "#39FF88", "#BBF7D0", "#4ADE80", "#16A34A")
LeehHub.Themes.GlassFrost = MakeTheme("GlassFrost", "#7DD3FC", "#E0F2FE", "#BAE6FD", "#38BDF8")
LeehHub.Themes.GlassObsidian = MakeTheme("GlassObsidian", "#A1A1AA", "#E4E4E7", "#D4D4D8", "#71717A")
LeehHub.Themes.GlassRose = MakeTheme("GlassRose", "#FDA4AF", "#FFE4E6", "#FECDD3", "#FB7185")
LeehHub.Themes.Bloodmoon = MakeTheme("Bloodmoon", "#DC2626", "#FCA5A5", "#EF4444", "#B91C1C")
LeehHub.Themes.EmeraldGlass = MakeTheme("EmeraldGlass", "#10B981", "#D1FAE5", "#34D399", "#059669")
LeehHub.Themes.Royal = MakeTheme("Royal", "#FBBF24", "#DDD6FE", "#8B5CF6", "#F59E0B")
LeehHub.Themes.Arctic = MakeTheme("Arctic", "#38BDF8", "#F0F9FF", "#7DD3FC", "#0EA5E9")
LeehHub.Themes.Vaporwave = MakeTheme("Vaporwave", "#F472B6", "#99F6E4", "#2DD4BF", "#EC4899")
LeehHub.Themes.Blackout = MakeTheme("Blackout", "#4ADE80", "#E5E7EB", "#22C55E", "#16A34A")

LeehHub.ThemeOrder = {"Aurora", "NeonPurple", "NeonCyan", "NeonPink", "NeonLime", "NeonOrange", "Synthwave", "Cyberpunk", "Toxic", "GlassFrost", "GlassObsidian", "GlassRose", "Bloodmoon", "EmeraldGlass", "Royal", "Arctic", "Vaporwave", "Blackout"}

local MainGui = Instance.new("ScreenGui")
MainGui.Name = "LeehHub"
MainGui.ResetOnSpawn = false
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainGui.Parent = (gethui and gethui()) or CoreGui

local NotificationHolder = Instance.new("Frame")
NotificationHolder.Size = UDim2.new(0, 260, 1, -20)
NotificationHolder.Position = UDim2.new(1, -270, 0, 10)
NotificationHolder.BackgroundTransparency = 1
NotificationHolder.ZIndex = 100
NotificationHolder.Parent = MainGui

local ActiveNotifications = {}

local NotifList = Instance.new("UIListLayout")
NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifList.Padding = UDim.new(0, 8)
NotifList.Parent = NotificationHolder

local function ResolveIconInfo(key)
	if not key then return "", false end
	if type(key) == "number" then return "rbxassetid://" .. tostring(key), true end
	if type(key) == "string" then
		if LeehHub.Icons[key] then return LeehHub.Icons[key], false end
		if string.match(key, "^rbxassetid://") or string.match(key, "^%d+$") then
			return NormalizeImageSource(key), true
		end
		return NormalizeImageSource(key), true
	end
	return "", false
end

local function ResolveIcon(key)
	local resolved = ResolveIconInfo(key)
	return resolved
end

local function TintIfAllowed(img, color)
	if img and not img:GetAttribute("LeehCustomIcon") then
		img.ImageColor3 = color
	end
end

local function NormalizeArgs(first, ...)
	if type(first) == "table" then return first end
	return nil, first, ...
end

local function AddImage(parent, source, size, color, transparency, z)
	local resolved, isCustom = ResolveIconInfo(source)
	if resolved == "" then return nil end
	local image = Instance.new("ImageLabel")
	image.Size = size or UDim2.fromOffset(18, 18)
	image.BackgroundTransparency = 1
	image.Image = resolved
	image.ScaleType = isCustom and Enum.ScaleType.Crop or Enum.ScaleType.Stretch
	image.ImageColor3 = isCustom and Color3.new(1, 1, 1) or (color or Color3.new(1, 1, 1))
	image.ImageTransparency = transparency or 0
	image.ZIndex = z or 8
	image.Parent = parent
	if isCustom then image:SetAttribute("LeehCustomIcon", true) end
	return image
end

local function SetThemeRole(instance, role)
	if instance then
		instance:SetAttribute("LeehThemeRole", role)
	end
	return instance
end

local function ColorNear(a, b, threshold)
	if typeof(a) ~= "Color3" or typeof(b) ~= "Color3" then return false end
	threshold = threshold or 0.02
	return math.abs(a.R - b.R) + math.abs(a.G - b.G) + math.abs(a.B - b.B) <= threshold
end

local function MarkThemeObjects(root, theme)
	if not root then return end
	local function mark(obj)
		if obj:GetAttribute("LeehThemeRole") then return end
		if obj:IsA("UIStroke") then
			if ColorNear(obj.Color, theme.Outline) then obj:SetAttribute("LeehThemeRole", "Outline") end
			return
		end
		if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
			if ColorNear(obj.TextColor3, theme.Text) then
				obj:SetAttribute("LeehThemeRole", "Text")
			elseif ColorNear(obj.TextColor3, theme.Placeholder) then
				obj:SetAttribute("LeehThemeRole", "Placeholder")
			end
		elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
			if ColorNear(obj.ImageColor3, theme.Icon) then obj:SetAttribute("LeehThemeRole", "Icon") end
		elseif obj:IsA("Frame") or obj:IsA("TextButton") then
			local c = obj.BackgroundColor3
			if ColorNear(c, theme.Background) then
				obj:SetAttribute("LeehThemeRole", "Background")
			elseif ColorNear(c, theme.ElementBackground) then
				obj:SetAttribute("LeehThemeRole", "ElementBackground")
			elseif ColorNear(c, Elevate(theme.ElementBackground)) then
				obj:SetAttribute("LeehThemeRole", "Elevated")
			elseif ColorNear(c, theme.Accent) then
				obj:SetAttribute("LeehThemeRole", "Accent")
			elseif ColorNear(c, theme.Toggle) then
				obj:SetAttribute("LeehThemeRole", "Toggle")
			elseif ColorNear(c, theme.Slider) then
				obj:SetAttribute("LeehThemeRole", "Slider")
			end
		end
	end
	mark(root)
	for _, obj in ipairs(root:GetDescendants()) do
		mark(obj)
	end
end

local function ApplyThemeRoles(root, theme)
	if not root then return end
	local function apply(obj)
		local role = obj:GetAttribute("LeehThemeRole")
		if not role then return end
		if role == "Outline" and obj:IsA("UIStroke") then
			obj.Color = theme.Outline
		elseif role == "Text" then
			if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
				obj.TextColor3 = theme.Text
			end
		elseif role == "Placeholder" then
			if obj:IsA("TextBox") then obj.PlaceholderColor3 = theme.Placeholder elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then obj.TextColor3 = theme.Placeholder end
		elseif role == "Icon" and (obj:IsA("ImageLabel") or obj:IsA("ImageButton")) then
			obj.ImageColor3 = theme.Icon
		elseif obj:IsA("GuiObject") then
			local map = {
				Background = theme.Background,
				ElementBackground = theme.ElementBackground,
				Elevated = Elevate(theme.ElementBackground),
				Accent = theme.Accent,
				Toggle = theme.Toggle,
				Slider = theme.Slider,
			}
			if map[role] then obj.BackgroundColor3 = map[role] end
		end
	end
	apply(root)
	for _, obj in ipairs(root:GetDescendants()) do
		apply(obj)
	end
end

local function AddElementIcon(row, icon, position, color)
	if not icon then return nil end
	local image = AddImage(row, icon, UDim2.fromOffset(17, 17), color, 0, 8)
	if not image then return nil end
	image.AnchorPoint = Vector2.new(position == "Right" and 1 or 0, 0.5)
	image.Position = position == "Right" and UDim2.new(1, -10, 0.5, 0) or UDim2.new(0, 10, 0.5, 0)
	return image
end

local function ConfigureElementIcon(row, config, label)
	local icon = config and config.Icon
	if not icon then return nil end
	local position = config.IconPosition or "Left"
	local image = AddElementIcon(row, icon, position, (LeehHub.CurrentTheme and LeehHub.CurrentTheme.Icon) or Color3.new(1, 1, 1))
	if image and label and position == "Left" then
		label.Position = UDim2.new(0, 34, label.Position.Y.Scale, label.Position.Y.Offset)
		label.Size = UDim2.new(label.Size.X.Scale, label.Size.X.Offset - 28, label.Size.Y.Scale, label.Size.Y.Offset)
	elseif image and label and position == "Right" then
		label.Size = UDim2.new(label.Size.X.Scale, label.Size.X.Offset - 28, label.Size.Y.Scale, label.Size.Y.Offset)
	end
	return image
end

function LeehHub:CreateWindow(config)
	config = config or {}
	local themeName = config.Theme or "Aurora"
	local title = config.Title or "LeehHub"
	local description = config.Description or ""
	local iconKey = config.Logo or config.WindowIcon or config.Icon or config.Image
	local size = config.Size or Vector2.new(600, 320)
	if typeof(size) == "UDim2" then size = Vector2.new(size.X.Offset, size.Y.Offset) end
	local toggleKey = config.ToggleKey or Enum.KeyCode.RightShift
	local showThemeSelector = config.ThemeSelector == true
	local bgImage = config.BackgroundImage
	local bgVideo = config.BackgroundVideo
	local bgTransparency = math.clamp(config.BackgroundImageTransparency or config.BackgroundTransparency or 0.5, 0, 1)
	local panelTransparency = math.clamp(config.Transparency or 0.3, 0.05, 0.8)
	local openButtonIcon = config.OpenButtonIcon or iconKey

	local Theme = LeehHub.Themes[themeName] or LeehHub.Themes.Aurora
	LeehHub.CurrentTheme = Theme
	local Registered = {}

	local OpenPopups = {}

	local function RegisterPopup(frame, trigger)
		table.insert(OpenPopups, { Frame = frame, Trigger = trigger })
	end

	local function CloseAllPopups(exceptTrigger)
		for _, p in ipairs(OpenPopups) do
			if p.Frame.Visible and p.Trigger ~= exceptTrigger then
				p.Frame.Visible = false
			end
		end
	end

	local resolvedIcon, resolvedIconIsCustom = ResolveIconInfo(iconKey)
	local resolvedBgImage = NormalizeImageSource(bgImage)
	local resolvedBgVideo = NormalizeVideoSource(bgVideo)
	local hasBgImage = resolvedBgImage ~= ""
	local hasBgVideo = resolvedBgVideo ~= ""
	local mainBgTrans = (hasBgImage or hasBgVideo) and 0.98 or panelTransparency

	local Window = {}
	Window.Tabs = {}
	Window.Connections = {}

	local function Track(conn)
		table.insert(Window.Connections, conn)
		return conn
	end

	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "Main"
	MainFrame.Size = UDim2.fromOffset(0, 0)
	MainFrame.Position = UDim2.fromScale(0.5, 0.5)
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.BackgroundColor3 = Theme.Background or Theme.ElementBackground
	MainFrame.BackgroundTransparency = panelTransparency
	MainFrame.ClipsDescendants = true
	local SizeConstraint = Instance.new("UISizeConstraint")
	SizeConstraint.MinSize = Vector2.new(420, 300)
	SizeConstraint.MaxSize = Vector2.new(1000, 720)
	SizeConstraint.Parent = MainFrame
	MainFrame.Visible = false
	MainFrame.Parent = MainGui
	AddCorner(12, MainFrame)
	local WindowStroke = AddStroke(MainFrame, Theme.Outline, 1.5, 0.25)

	local BgImageLabel = Instance.new("ImageLabel")
	BgImageLabel.Name = "BackgroundImage"
	BgImageLabel.Size = UDim2.fromScale(1, 1)
	BgImageLabel.BackgroundTransparency = 1
	BgImageLabel.Image = resolvedBgImage
	BgImageLabel.ImageTransparency = bgTransparency
	BgImageLabel.ScaleType = Enum.ScaleType.Crop
	BgImageLabel.ZIndex = 0
	BgImageLabel.Visible = hasBgImage and not hasBgVideo
	BgImageLabel.Parent = MainFrame
	AddCorner(12, BgImageLabel)

	local BgVideoFrame = Instance.new("VideoFrame")
	BgVideoFrame.Name = "BackgroundVideo"
	BgVideoFrame.Size = UDim2.fromScale(1, 1)
	BgVideoFrame.BackgroundTransparency = 1
	BgVideoFrame.Video = resolvedBgVideo
	BgVideoFrame.Looped = true
	BgVideoFrame.Volume = 0
	BgVideoFrame.ZIndex = 0
	BgVideoFrame.Visible = hasBgVideo
	BgVideoFrame.Parent = MainFrame
	AddCorner(12, BgVideoFrame)
	if hasBgVideo then
		pcall(function() BgVideoFrame:Play() end)
	end

	local Overlay = Instance.new("Frame")
	Overlay.Size = UDim2.fromScale(1, 1)
	Overlay.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
	Overlay.BackgroundTransparency = (hasBgImage or hasBgVideo) and 0.45 or 1
	Overlay.BorderSizePixel = 0
	Overlay.ZIndex = 1
	Overlay.Parent = MainFrame
	AddCorner(12, Overlay)

	AddGlassShine(MainFrame, 12)

	local TOP_H = description ~= "" and 56 or 50
	local SIDE_W = math.clamp(math.floor(size.X * 0.30), 165, 190)

	local Topbar = Instance.new("Frame")
	Topbar.Size = UDim2.new(1, 0, 0, TOP_H)
	Topbar.BackgroundTransparency = 1
	Topbar.ZIndex = 5
	Topbar.Parent = MainFrame

	local TitleRow = Instance.new("Frame")
	TitleRow.Size = UDim2.new(1, -(showThemeSelector and 175 or 90), 0, 20)
	TitleRow.Position = UDim2.new(0, 14, 0, description ~= "" and 8 or 10)
	TitleRow.BackgroundTransparency = 1
	TitleRow.ZIndex = 6
	TitleRow.Parent = Topbar

	local TitleLayout = Instance.new("UIListLayout")
	TitleLayout.FillDirection = Enum.FillDirection.Horizontal
	TitleLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	TitleLayout.Padding = UDim.new(0, 8)
	TitleLayout.Parent = TitleRow

	if resolvedIcon ~= "" then
		local TitleIcon = Instance.new("ImageLabel")
		TitleIcon.Size = UDim2.fromOffset(18, 18)
		TitleIcon.BackgroundTransparency = 1
		TitleIcon.Image = resolvedIcon
		TitleIcon.ScaleType = resolvedIconIsCustom and Enum.ScaleType.Crop or Enum.ScaleType.Stretch
		TitleIcon.ImageColor3 = resolvedIconIsCustom and Color3.new(1, 1, 1) or Theme.Icon
		TitleIcon.ZIndex = 6
		TitleIcon.Parent = TitleRow
		if resolvedIconIsCustom then
			AddCorner(4, TitleIcon)
			TitleIcon:SetAttribute("LeehCustomIcon", true)
		end
	end

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Text = title
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextSize = 15
	TitleLabel.TextColor3 = Theme.Text
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Size = UDim2.new(1, -26, 0, 20)
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.ZIndex = 6
	TitleLabel.Parent = TitleRow

	local DescLabel = Instance.new("TextLabel")
	DescLabel.Text = description
	DescLabel.Font = Enum.Font.Gotham
	DescLabel.TextSize = 11
	DescLabel.TextColor3 = Theme.Placeholder
	DescLabel.Position = UDim2.new(0, 14, 0, 30)
	DescLabel.Size = UDim2.new(1, -28, 0, 16)
	DescLabel.BackgroundTransparency = 1
	DescLabel.TextXAlignment = Enum.TextXAlignment.Left
	DescLabel.Visible = description ~= ""
	DescLabel.ZIndex = 6
	DescLabel.Parent = Topbar

	local Controls = Instance.new("Frame")
	Controls.Size = UDim2.fromOffset(showThemeSelector and 150 or 60, 24)
	Controls.Position = UDim2.new(1, -(showThemeSelector and 160 or 70), 0, description ~= "" and 10 or 8)
	Controls.BackgroundTransparency = 1
	Controls.ZIndex = 6
	Controls.Parent = Topbar

	local ControlsLayout = Instance.new("UIListLayout")
	ControlsLayout.FillDirection = Enum.FillDirection.Horizontal
	ControlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	ControlsLayout.Padding = UDim.new(0, 6)
	ControlsLayout.Parent = Controls

	local ThemeBtn
	if showThemeSelector then
		ThemeBtn = Instance.new("TextButton")
		ThemeBtn.Size = UDim2.fromOffset(86, 24)
		ThemeBtn.BackgroundColor3 = Elevate(Theme.ElementBackground)
		ThemeBtn.BackgroundTransparency = 0.12
		ThemeBtn.AutoButtonColor = false
		ThemeBtn.Text = themeName
		ThemeBtn.Font = Enum.Font.GothamSemibold
		ThemeBtn.TextSize = 11
		ThemeBtn.TextColor3 = Theme.Text
		ThemeBtn.ZIndex = 7
		ThemeBtn.Parent = Controls
		AddCorner(7, ThemeBtn)
	end

	local MinBtn = Instance.new("ImageButton")
	MinBtn.Size = UDim2.fromOffset(22, 22)
	MinBtn.BackgroundTransparency = 1
	MinBtn.Image = ResolveIcon("minus")
	MinBtn.ImageColor3 = Theme.Icon
	MinBtn.ZIndex = 7
	MinBtn.Parent = Controls

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Size = UDim2.fromOffset(22, 22)
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.Text = "X"
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.TextSize = 16
	CloseBtn.TextColor3 = Theme.Accent
	CloseBtn.ZIndex = 7
	CloseBtn.Parent = Controls

	local ThemePopup = Instance.new("Frame")
	ThemePopup.Size = UDim2.fromOffset(178, 232)
	ThemePopup.Position = UDim2.new(1, -186, 0, TOP_H - 2)
	ThemePopup.BackgroundColor3 = Theme.ElementBackground
	ThemePopup.BackgroundTransparency = 0.22
	ThemePopup.Visible = false
	ThemePopup.ZIndex = 50
	ThemePopup.Parent = MainGui
	AddCorner(8, ThemePopup)
	AddStroke(ThemePopup, Theme.Outline, 1, 0.3)
	AddGlassShine(ThemePopup, 8)

	local ThemeScroll = Instance.new("ScrollingFrame")
	ThemeScroll.Size = UDim2.new(1, -8, 1, -8)
	ThemeScroll.Position = UDim2.new(0, 4, 0, 4)
	ThemeScroll.BackgroundTransparency = 1
	ThemeScroll.ScrollBarThickness = 3
	ThemeScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	ThemeScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ThemeScroll.ZIndex = 51
	ThemeScroll.Parent = ThemePopup

	local ThemeListLayout = Instance.new("UIListLayout")
	ThemeListLayout.Padding = UDim.new(0, 4)
	ThemeListLayout.Parent = ThemeScroll

	local Sidebar = Instance.new("Frame")
	Sidebar.Size = UDim2.new(0, SIDE_W, 1, -(TOP_H + 8))
	Sidebar.Position = UDim2.new(0, 0, 0, TOP_H)
	Sidebar.BackgroundTransparency = 1
	Sidebar.ZIndex = 5
	Sidebar.Parent = MainFrame

	local TabContainer = Instance.new("ScrollingFrame")
	TabContainer.Size = UDim2.new(1, -12, 1, -12)
	TabContainer.Position = UDim2.new(0, 6, 0, 6)
	TabContainer.BackgroundTransparency = 1
	TabContainer.ScrollBarThickness = 0
	TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
	TabContainer.ZIndex = 5
	TabContainer.Parent = Sidebar

	local TabList = Instance.new("UIListLayout")
	TabList.Padding = UDim.new(0, 7)
	TabList.Parent = TabContainer

	local Divider = Instance.new("Frame")
	Divider.Size = UDim2.new(0, 1, 1, -(TOP_H + 12))
	Divider.Position = UDim2.new(0, SIDE_W, 0, TOP_H + 4)
	Divider.BackgroundColor3 = Theme.Outline
	Divider.BackgroundTransparency = 0.5
	Divider.BorderSizePixel = 0
	Divider.ZIndex = 5
	Divider.Parent = MainFrame

	local ContentArea = Instance.new("Frame")
	ContentArea.Size = UDim2.new(1, -(SIDE_W + 4), 1, -(TOP_H + 8))
	ContentArea.Position = UDim2.new(0, SIDE_W + 4, 0, TOP_H)
	ContentArea.BackgroundTransparency = 1
	ContentArea.ZIndex = 5
	ContentArea.Parent = MainFrame

	local FloatBtn = Instance.new("TextButton")
	FloatBtn.Size = UDim2.fromOffset(58, 58)
	FloatBtn.Position = UDim2.new(0, 18, 0.5, -29)
	FloatBtn.BackgroundColor3 = Theme.ElementBackground
	FloatBtn.BackgroundTransparency = 0.15
	FloatBtn.Text = ""
	FloatBtn.Visible = false
	FloatBtn.ZIndex = 10
	FloatBtn.Parent = MainGui
	AddCorner(14, FloatBtn)
	local FloatStroke = AddStroke(FloatBtn, Theme.Accent, 2.5, 0.05)
	AddGlassShine(FloatBtn, 14)

	local resolvedOpenIcon, resolvedOpenIconIsCustom = ResolveIconInfo(openButtonIcon)
	if resolvedOpenIcon ~= "" then
		local fIconHolder = Instance.new("Frame")
		fIconHolder.Name = "IconHolder"
		fIconHolder.Size = UDim2.fromScale(1, 1)
		fIconHolder.Position = UDim2.fromScale(0.5, 0.5)
		fIconHolder.AnchorPoint = Vector2.new(0.5, 0.5)
		fIconHolder.BackgroundTransparency = 1
		fIconHolder.ClipsDescendants = true
		fIconHolder.ZIndex = 11
		fIconHolder.Parent = FloatBtn
		AddCorner(14, fIconHolder)

		local fIcon = Instance.new("ImageLabel")
		fIcon.Name = "Icon"
		fIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		fIcon.Position = UDim2.fromScale(0.5, 0.5)
		fIcon.Size = resolvedOpenIconIsCustom and UDim2.fromScale(1, 1) or UDim2.fromScale(0.55, 0.55)
		fIcon.BackgroundTransparency = 1
		fIcon.Image = resolvedOpenIcon
		fIcon.ScaleType = resolvedOpenIconIsCustom and Enum.ScaleType.Crop or Enum.ScaleType.Fit
		fIcon.ImageColor3 = resolvedOpenIconIsCustom and Color3.new(1, 1, 1) or Theme.Icon
		fIcon.ZIndex = 12
		fIcon.Parent = fIconHolder
		if resolvedOpenIconIsCustom then fIcon:SetAttribute("LeehCustomIcon", true) end
	else
		local fTxt = Instance.new("TextLabel")
		fTxt.Size = UDim2.fromScale(1, 1)
		fTxt.BackgroundTransparency = 1
		fTxt.Text = string.sub(title, 1, 1):upper()
		fTxt.Font = Enum.Font.GothamBold
		fTxt.TextSize = 22
		fTxt.TextColor3 = Theme.Toggle or Theme.Outline
		fTxt.ZIndex = 11
		fTxt.Parent = FloatBtn
	end

	local winOpen = true
	local isAnimating = false

	local function OpenWindow()
		if isAnimating then return end
		isAnimating = true
		FloatBtn.Visible = false
		MainFrame.Visible = true
		MainFrame.Size = UDim2.fromOffset(0, 0)
		MainFrame.BackgroundTransparency = 1
		local t = TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.fromOffset(size.X, size.Y),
			BackgroundTransparency = mainBgTrans
		})
		t:Play()
		t.Completed:Connect(function() isAnimating = false end)
		winOpen = true
	end

	local function CloseWindow()
		if isAnimating then return end
		isAnimating = true
		CloseAllPopups()
		local t = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
			Size = UDim2.fromOffset(0, 0),
			BackgroundTransparency = 1
		})
		t:Play()
		t.Completed:Connect(function()
			MainFrame.Visible = false
			FloatBtn.Visible = true
			isAnimating = false
		end)
		winOpen = false
	end

	local function ToggleWindow()
		if winOpen then CloseWindow() else OpenWindow() end
	end

	MinBtn.MouseButton1Click:Connect(CloseWindow)
	FloatBtn.MouseButton1Click:Connect(OpenWindow)
	CloseBtn.MouseButton1Click:Connect(function()
		Window:Destroy()
	end)

	Track(UserInputService.InputBegan:Connect(function(input, gpe)
		if not gpe and input.KeyCode == toggleKey then
			ToggleWindow()
		end
	end))

	Track(UserInputService.InputBegan:Connect(function(input, gpe)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
		task.defer(function()
			local pos = input.Position
			for _, p in ipairs(OpenPopups) do
				if p.Frame.Visible then
					local abs = p.Frame.AbsolutePosition
					local sz = p.Frame.AbsoluteSize
					local inFrame = pos.X >= abs.X and pos.X <= abs.X + sz.X and pos.Y >= abs.Y and pos.Y <= abs.Y + sz.Y
					local inTrigger = false
					if p.Trigger then
						local tabs = p.Trigger.AbsolutePosition
						local tsz = p.Trigger.AbsoluteSize
						inTrigger = pos.X >= tabs.X and pos.X <= tabs.X + tsz.X and pos.Y >= tabs.Y and pos.Y <= tabs.Y + tsz.Y
					end
					if not inFrame and not inTrigger then
						p.Frame.Visible = false
					end
				end
			end
		end)
	end))

	local function EnableDrag(handle, target)
		local dragging, startPos, startInput
		handle.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				startPos = target.Position
				startInput = input.Position
			end
		end)
		Track(UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local delta = input.Position - startInput
				target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end))
		handle.InputEnded:Connect(function() dragging = false end)
	end
	EnableDrag(Topbar, MainFrame)
	EnableDrag(FloatBtn, FloatBtn)

	local function UpdateTheme(name, animate)
		local T = LeehHub.Themes[name] or LeehHub.Themes.Aurora
		MarkThemeObjects(MainFrame, Theme)
		MarkThemeObjects(FloatBtn, Theme)
		LeehHub.CurrentTheme = T
		Theme = T

		local function Apply()
			ApplyThemeValue(WindowStroke, "Color", T.Outline)
			MainFrame.BackgroundColor3 = T.Background or T.ElementBackground
			ThemePopup.BackgroundColor3 = T.ElementBackground
			Divider.BackgroundColor3 = T.Outline
			TitleLabel.TextColor3 = T.Text
			DescLabel.TextColor3 = T.Placeholder
			CloseBtn.TextColor3 = T.Accent
			MinBtn.ImageColor3 = T.Icon
			if ThemeBtn then
				ThemeBtn.Text = T.Name
				ThemeBtn.TextColor3 = T.Text
				ThemeBtn.BackgroundColor3 = Elevate(T.ElementBackground)
			end
			local openImage = FloatBtn:FindFirstChildWhichIsA("ImageLabel", true)
			if openImage then
				TintIfAllowed(openImage, T.Icon)
			else
				local openText = FloatBtn:FindFirstChildOfClass("TextLabel")
				if openText then openText.TextColor3 = T.Icon end
			end
			if FloatStroke then FloatStroke.Color = T.Accent end
			ApplyThemeRoles(MainFrame, T)
			ApplyThemeRoles(FloatBtn, T)

			for _, item in ipairs(Registered) do
				if item.Type == "TabBtn" then
					if item.Active then
						item.Label.TextColor3 = T.Text
						item.Instance.BackgroundColor3 = T.Accent
						item.Instance.BackgroundTransparency = 0.1
						if item.Stroke then item.Stroke.Color = T.Accent end
						if item.Stroke then item.Stroke.Transparency = 0.05 end
						if item.Stroke then item.Stroke.Thickness = 1.8 end
						if item.Icon then TintIfAllowed(item.Icon, T.Icon) end
					else
						item.Label.TextColor3 = T.Placeholder
						item.Instance.BackgroundColor3 = Elevate(T.ElementBackground)
						item.Instance.BackgroundTransparency = 0.25
						if item.Stroke then item.Stroke.Color = T.Outline end
						if item.Stroke then item.Stroke.Transparency = 0.2 end
						if item.Stroke then item.Stroke.Thickness = 1.4 end
						if item.Icon then TintIfAllowed(item.Icon, T.Placeholder) end
					end
				elseif item.Type == "Element" then
					item.Instance.BackgroundColor3 = T.ElementBackground
					if item.Stroke then item.Stroke.Color = T.Outline end
					if item.Label then item.Label.TextColor3 = T.Text end
					if item.Icon then TintIfAllowed(item.Icon, T.Icon) end
					if item.SubColor then
						item.SubColor.BackgroundColor3 = item.SubRole == "Slider" and T.Slider or (item.State and item.State() and T.Toggle or Color3.fromRGB(60, 60, 65))
					end
					if item.SubBg then item.SubBg.BackgroundColor3 = Elevate(T.ElementBackground) end
					if item.SubText then
						item.SubText.TextColor3 = T.Text
						if item.SubText:IsA("TextBox") then item.SubText.PlaceholderColor3 = T.Placeholder end
					end
					if item.Extras then
						for _, extra in ipairs(item.Extras) do
							if extra.Kind == "Text" then extra.Object.TextColor3 = T.Text
							elseif extra.Kind == "Placeholder" and extra.Object:IsA("TextBox") then extra.Object.PlaceholderColor3 = T.Placeholder
							elseif extra.Kind == "Icon" then TintIfAllowed(extra.Object, T.Icon)
							elseif extra.Kind == "Background" then extra.Object.BackgroundColor3 = T.ElementBackground
							elseif extra.Kind == "Elevated" then extra.Object.BackgroundColor3 = Elevate(T.ElementBackground)
							elseif extra.Kind == "Outline" and extra.Object:IsA("UIStroke") then extra.Object.Color = T.Outline
							elseif extra.Kind == "Accent" then extra.Object.BackgroundColor3 = T.Accent end
						end
					end
				elseif item.Type == "Section" then
					item.Label.TextColor3 = T.Placeholder
					if item.Icon then TintIfAllowed(item.Icon, T.Icon) end
				end
			end
			for _, notification in ipairs(ActiveNotifications) do
				if notification.Frame and notification.Frame.Parent then
					notification.Frame.BackgroundColor3 = T.ElementBackground
					if notification.Stroke then notification.Stroke.Color = T.Outline end
					if notification.Icon then TintIfAllowed(notification.Icon, T.Icon) end
					if notification.Title then notification.Title.TextColor3 = T.Text end
					if notification.Content then notification.Content.TextColor3 = T.Placeholder end
				end
			end
		end

		if animate then
			local tweenTargets = {
				[MainFrame] = {BackgroundColor3 = T.Background},
				[WindowStroke] = {Color = T.Outline},
				[Divider] = {BackgroundColor3 = T.Outline},
			}
			for object, props in pairs(tweenTargets) do
				TW(object, 0.18, props)
			end
		end
		Apply()
	end

	if showThemeSelector then
		for _, tName in ipairs(LeehHub.ThemeOrder) do
			if LeehHub.Themes[tName] then
				local btn = Instance.new("TextButton")
				btn.Size = UDim2.new(1, -8, 0, 30)
				btn.BackgroundColor3 = LeehHub.Themes[tName].Accent
				btn.BackgroundTransparency = 0.78
				btn.AutoButtonColor = false
				btn.Text = tName
				btn.Font = Enum.Font.GothamMedium
				btn.TextSize = 12
				btn.TextColor3 = LeehHub.Themes[tName].Text
				btn.TextXAlignment = Enum.TextXAlignment.Left
				btn.ZIndex = 52
				btn.Parent = ThemeScroll
				AddCorner(7, btn)
				local pad = Instance.new("UIPadding")
				pad.PaddingLeft = UDim.new(0, 10)
				pad.Parent = btn
				btn.MouseEnter:Connect(function()
					TW(btn, 0.12, {BackgroundTransparency = 0.58})
				end)
				btn.MouseLeave:Connect(function()
					TW(btn, 0.12, {BackgroundTransparency = 0.78})
				end)
				btn.MouseButton1Click:Connect(function()
					UpdateTheme(tName, true)
					ThemePopup.Visible = false
				end)
			end
		end
		RegisterPopup(ThemePopup, ThemeBtn)
		ThemeBtn.MouseButton1Click:Connect(function()
			if ThemePopup.Visible then
				ThemePopup.Visible = false
				return
			end
			CloseAllPopups(ThemeBtn)
			local abs = ThemeBtn.AbsolutePosition
			local asz = ThemeBtn.AbsoluteSize
			local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
			local popupH = 232
			local x = math.clamp(abs.X + asz.X - 178, 6, math.max(6, viewport.X - 184))
			local belowY = abs.Y + asz.Y + 5
			local aboveY = abs.Y - popupH - 5
			local y = belowY + popupH <= viewport.Y - 6 and belowY or math.max(6, aboveY)
			ThemePopup.Position = UDim2.fromOffset(x, y)
			ThemePopup.Visible = true
		end)
	end

	function Window:SetSize(newSize)
		if typeof(newSize) == "Vector2" then
			size = Vector2.new(math.clamp(newSize.X, 360, 900), math.clamp(newSize.Y, 300, 720))
			MainFrame.Size = UDim2.fromOffset(size.X, size.Y)
		elseif typeof(newSize) == "UDim2" then
			MainFrame.Size = newSize
		end
	end

	function Window:SetBackgroundTransparency(value)
		panelTransparency = math.clamp(tonumber(value) or panelTransparency, 0.05, 0.8)
		if not hasBgImage and not hasBgVideo then
			mainBgTrans = panelTransparency
			MainFrame.BackgroundTransparency = panelTransparency
		end
	end

	function Window:SetBackgroundImageTransparency(value)
		bgTransparency = math.clamp(tonumber(value) or bgTransparency, 0, 1)
		BgImageLabel.ImageTransparency = bgTransparency
	end

	function Window:EditOpenButton(config)
		config = config or {}
		if config.Enabled ~= nil then
			FloatBtn.Visible = config.Enabled and not winOpen
		end
		if config.Icon ~= nil then
			local iconSource, iconIsCustom = ResolveIconInfo(config.Icon)
			local image = FloatBtn:FindFirstChildWhichIsA("ImageLabel", true)
			if image and iconSource ~= "" then
				image.Image = iconSource
				image.ScaleType = iconIsCustom and Enum.ScaleType.Crop or Enum.ScaleType.Fit
				image.ImageColor3 = iconIsCustom and Color3.new(1, 1, 1) or LeehHub.CurrentTheme.Icon
				image:SetAttribute("LeehCustomIcon", iconIsCustom or nil)
			end
		end
		if config.Size then
			FloatBtn.Size = typeof(config.Size) == "UDim2" and config.Size or UDim2.fromOffset(config.Size.X or 54, config.Size.Y or 54)
		end
		if config.Position then
			FloatBtn.Position = config.Position
		end
	end

	function Window:SetBackgroundImage(src, transparency)
		local resolved = NormalizeImageSource(src)
		BgImageLabel.Image = resolved
		BgImageLabel.Visible = resolved ~= "" and not hasBgVideo
		if transparency then BgImageLabel.ImageTransparency = transparency end
		hasBgImage = resolved ~= ""
		mainBgTrans = (hasBgImage or hasBgVideo) and 0.98 or panelTransparency
		MainFrame.BackgroundTransparency = mainBgTrans
		Overlay.BackgroundTransparency = (hasBgImage or hasBgVideo) and 0.45 or 1
	end

	function Window:SetBackgroundVideo(src)
		local resolved = NormalizeVideoSource(src)
		BgVideoFrame.Video = resolved
		BgVideoFrame.Visible = resolved ~= ""
		hasBgVideo = resolved ~= ""
		if hasBgVideo then
			BgImageLabel.Visible = false
			pcall(function() BgVideoFrame:Play() end)
		end
		mainBgTrans = (hasBgImage or hasBgVideo) and 0.98 or panelTransparency
		MainFrame.BackgroundTransparency = mainBgTrans
		Overlay.BackgroundTransparency = (hasBgImage or hasBgVideo) and 0.45 or 1
	end

	function Window:SetTheme(name)
		UpdateTheme(name, true)
	end

	function Window:Minimize()
		CloseWindow()
	end

	function Window:Restore()
		OpenWindow()
	end

	function Window:Destroy()
		for _, c in ipairs(self.Connections) do
			pcall(function() c:Disconnect() end)
		end
		for i, window in ipairs(LeehHub.Windows) do
			if window == self then
				table.remove(LeehHub.Windows, i)
				break
			end
		end
		MainGui:Destroy()
	end

	function Window:CreateTab(tabConfig, maybeIcon)
		local cfg = NormalizeArgs(tabConfig)
		local tabName, tabIcon
		if cfg then
			tabName = cfg.Name or cfg.Title or "Tab"
			tabIcon = cfg.Icon
		else
			tabName = tabConfig or "Tab"
			tabIcon = maybeIcon
		end

		local page = Instance.new("ScrollingFrame")
		page.Size = UDim2.fromScale(1, 1)
		page.BackgroundTransparency = 1
		page.Visible = false
		page.ScrollBarThickness = 3
		page.CanvasSize = UDim2.new(0, 0, 0, 0)
		page.AutomaticCanvasSize = Enum.AutomaticSize.Y
		page.ZIndex = 5
		page.Parent = ContentArea

		local pageLayout = Instance.new("UIListLayout")
		pageLayout.Padding = UDim.new(0, 10)
		pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		pageLayout.Parent = page

		local pagePad = Instance.new("UIPadding")
		pagePad.PaddingTop = UDim.new(0, 6)
		pagePad.PaddingBottom = UDim.new(0, 10)
		pagePad.PaddingLeft = UDim.new(0, 8)
		pagePad.PaddingRight = UDim.new(0, 8)
		pagePad.Parent = page

		local tabBtn = Instance.new("TextButton")
		tabBtn.Size = UDim2.new(1, -2, 0, 48)
		tabBtn.BackgroundColor3 = Elevate(Theme.ElementBackground)
		tabBtn.BackgroundTransparency = 0.25
		tabBtn.Text = ""
		tabBtn.ZIndex = 6
		tabBtn.Parent = TabContainer
		AddCorner(6, tabBtn)
		local tabStroke = AddStroke(tabBtn, Theme.Outline, 1.4, 0.2)
		AddGlassShine(tabBtn, 6)

		local tIcon
		local resolvedTabIcon, resolvedTabIconIsCustom = ResolveIconInfo(tabIcon)
		if resolvedTabIcon ~= "" then
			tIcon = Instance.new("ImageLabel")
			tIcon.Size = UDim2.fromOffset(22, 22)
			tIcon.Position = UDim2.new(0, 12, 0.5, -11)
			tIcon.BackgroundTransparency = 1
			tIcon.Image = resolvedTabIcon
			tIcon.ScaleType = resolvedTabIconIsCustom and Enum.ScaleType.Crop or Enum.ScaleType.Stretch
			tIcon.ImageColor3 = resolvedTabIconIsCustom and Color3.new(1, 1, 1) or Theme.Placeholder
			tIcon.ZIndex = 7
			tIcon.Parent = tabBtn
			if resolvedTabIconIsCustom then
				AddCorner(4, tIcon)
				tIcon:SetAttribute("LeehCustomIcon", true)
			end
		end

		local tLabel = Instance.new("TextLabel")
		tLabel.Size = UDim2.new(1, resolvedTabIcon ~= "" and -46 or -20, 1, 0)
		tLabel.Position = UDim2.new(0, resolvedTabIcon ~= "" and 42 or 12, 0, 0)
		tLabel.BackgroundTransparency = 1
		tLabel.Text = tabName
		tLabel.Font = Enum.Font.GothamMedium
		tLabel.TextSize = 14
		tLabel.TextColor3 = Theme.Placeholder
		tLabel.TextXAlignment = Enum.TextXAlignment.Left
		tLabel.ZIndex = 7
		tLabel.Parent = tabBtn

		local tabData = { Type = "TabBtn", Instance = tabBtn, Label = tLabel, Icon = tIcon, Stroke = tabStroke, Active = false, Page = page }
		table.insert(Registered, tabData)

		local function Activate()
			for _, item in ipairs(Registered) do
				if item.Type == "TabBtn" then
					item.Active = false
					item.Page.Visible = false
					TW(item.Instance, 0.15, { BackgroundColor3 = Elevate(Theme.ElementBackground), BackgroundTransparency = 0.25 })
					if item.Stroke then TW(item.Stroke, 0.15, { Color = Theme.Outline, Transparency = 0.2, Thickness = 1.4 }) end
					item.Label.TextColor3 = Theme.Placeholder
					if item.Icon then TintIfAllowed(item.Icon, Theme.Placeholder) end
				end
			end
			tabData.Active = true
			page.Visible = true
			TW(tabBtn, 0.15, { BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.1 })
			if tabStroke then TW(tabStroke, 0.15, { Color = Theme.Accent, Transparency = 0.05, Thickness = 1.8 }) end
			tLabel.TextColor3 = Theme.Text
			if tIcon then TintIfAllowed(tIcon, Theme.Icon) end
		end

		tabBtn.MouseButton1Click:Connect(Activate)

		if #Window.Tabs == 0 then
			Activate()
		end

		local Tab = {}
		Window.Tabs[tabName] = Tab

		local function RegisterRow(height)
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1, 0, 0, height or 42)
			frame.BackgroundColor3 = Theme.ElementBackground
			frame.BackgroundTransparency = 0.32
			frame.ZIndex = 6
			frame.Parent = page
			AddCorner(8, frame)
			local stroke = AddStroke(frame, Theme.Outline, 1.2, 0.3)
			AddGlassShine(frame, 8)
			return frame, stroke
		end

		function Tab:CreateSection(secConfig)
			local cfg = NormalizeArgs(secConfig)
			local name = cfg and (cfg.Name or cfg.Title) or secConfig or "Section"

			local container = Instance.new("Frame")
			container.Size = UDim2.new(1, 0, 0, 0)
			container.AutomaticSize = Enum.AutomaticSize.Y
			container.BackgroundTransparency = 1
			container.ZIndex = 6
			container.Parent = page

			local layout = Instance.new("UIListLayout")
			layout.Padding = UDim.new(0, 6)
			layout.Parent = container

			local header = Instance.new("Frame")
			header.Size = UDim2.new(1, 0, 0, 26)
			header.BackgroundColor3 = Elevate(Theme.ElementBackground)
			header.BackgroundTransparency = 0.3
			header.ZIndex = 6
			header.Parent = container
			AddCorner(6, header)

			local hLabel = Instance.new("TextLabel")
			hLabel.Size = UDim2.new(1, -12, 1, 0)
			hLabel.Position = UDim2.new(0, 10, 0, 0)
			hLabel.BackgroundTransparency = 1
			hLabel.Text = string.upper(tostring(name))
			hLabel.Font = Enum.Font.GothamBold
			hLabel.TextSize = 11
			hLabel.TextColor3 = Theme.Placeholder
			hLabel.TextXAlignment = Enum.TextXAlignment.Left
			hLabel.ZIndex = 7
			hLabel.Parent = header
			local sectionIcon = cfg and ConfigureElementIcon(header, cfg, hLabel)

			table.insert(Registered, { Type = "Section", Label = hLabel, Icon = sectionIcon })

			local Section = {}

			function Section:CreateToggle(tConfig)
				local c = NormalizeArgs(tConfig) or {}
				local name = c.Name or c.Title or "Toggle"
				local default = c.Default or c.Value or false
				local callback = c.Callback or function() end

				local row, stroke = RegisterRow(42)
				row.Parent = container

				local lbl = Instance.new("TextLabel")
				lbl.Size = UDim2.new(1, -70, 1, 0)
				lbl.Position = UDim2.new(0, 12, 0, 0)
				lbl.BackgroundTransparency = 1
				lbl.Text = name
				lbl.Font = Enum.Font.GothamMedium
				lbl.TextSize = 13
				lbl.TextColor3 = Theme.Text
				lbl.TextXAlignment = Enum.TextXAlignment.Left
				lbl.ZIndex = 7
				lbl.Parent = row
				local elementIcon = ConfigureElementIcon(row, c, lbl)

				local switch = Instance.new("Frame")
				switch.Size = UDim2.fromOffset(44, 22)
				switch.Position = UDim2.new(1, -54, 0.5, -11)
				switch.BackgroundColor3 = default and (Theme.Toggle or Color3.fromRGB(34, 197, 94)) or Color3.fromRGB(60, 60, 65)
				switch.ZIndex = 7
				switch.Parent = row
				AddCorner(11, switch)

				local knob = Instance.new("Frame")
				knob.Size = UDim2.fromOffset(16, 16)
				knob.Position = default and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
				knob.BackgroundColor3 = Color3.new(1, 1, 1)
				knob.ZIndex = 8
				knob.Parent = switch
				AddCorner(8, knob)

				local state = default
				local click = Instance.new("TextButton")
				click.Size = UDim2.fromScale(1, 1)
				click.BackgroundTransparency = 1
				click.Text = ""
				click.ZIndex = 9
				click.Parent = row

				click.MouseButton1Click:Connect(function()
					state = not state
					TW(switch, 0.18, { BackgroundColor3 = state and (Theme.Toggle or Color3.fromRGB(34, 197, 94)) or Color3.fromRGB(60, 60, 65) })
					TW(knob, 0.18, { Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8) })
					callback(state)
				end)

				table.insert(Registered, { Type = "Element", Instance = row, Stroke = stroke, Label = lbl, Icon = elementIcon, SubColor = switch, State = function() return state end })

				local obj = {}
				function obj:Set(v)
					state = v
					TW(switch, 0.18, { BackgroundColor3 = state and (Theme.Toggle or Color3.fromRGB(34, 197, 94)) or Color3.fromRGB(60, 60, 65) })
					TW(knob, 0.18, { Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8) })
					callback(state)
				end
				function obj:Get() return state end
				return obj
			end

			function Section:CreateSlider(sConfig)
				local c = NormalizeArgs(sConfig) or {}
				local name = c.Name or c.Title or "Slider"
				local min = c.Min or 0
				local max = c.Max or 100
				local default = c.Default or c.Value or min
				local callback = c.Callback or function() end

				local row, stroke = RegisterRow(58)
				row.Parent = container

				local lbl = Instance.new("TextLabel")
				lbl.Size = UDim2.new(1, -20, 0, 18)
				lbl.Position = UDim2.new(0, 12, 0, 4)
				lbl.BackgroundTransparency = 1
				lbl.Text = name
				lbl.Font = Enum.Font.GothamMedium
				lbl.TextSize = 12
				lbl.TextColor3 = Theme.Text
				lbl.TextXAlignment = Enum.TextXAlignment.Left
				lbl.ZIndex = 7
				lbl.Parent = row
				local elementIcon = ConfigureElementIcon(row, c, lbl)

				local track = Instance.new("Frame")
				track.Size = UDim2.new(1, -90, 0, 6)
				track.Position = UDim2.new(0, 12, 0, 32)
				track.BackgroundColor3 = Elevate(Theme.ElementBackground)
				track.ZIndex = 7
				track.Parent = row
				AddCorner(3, track)

				local fill = Instance.new("Frame")
				local t0 = (default - min) / math.max(max - min, 1)
				fill.Size = UDim2.new(t0, 0, 1, 0)
				fill.BackgroundColor3 = Theme.Slider or Theme.Toggle
				fill.ZIndex = 8
				fill.Parent = track
				AddCorner(3, fill)

				local valBox = Instance.new("Frame")
				valBox.Size = UDim2.fromOffset(50, 22)
				valBox.Position = UDim2.new(1, -62, 0, 26)
				valBox.BackgroundColor3 = Elevate(Theme.ElementBackground)
				valBox.ZIndex = 7
				valBox.Parent = row
				AddCorner(5, valBox)

				local valLbl = Instance.new("TextLabel")
				valLbl.Size = UDim2.fromScale(1, 1)
				valLbl.BackgroundTransparency = 1
				valLbl.Text = tostring(default)
				valLbl.Font = Enum.Font.GothamBold
				valLbl.TextSize = 12
				valLbl.TextColor3 = Theme.Text
				valLbl.ZIndex = 8
				valLbl.Parent = valBox

				local dragging = false
				local function apply(v)
					v = math.clamp(math.floor(v + 0.5), min, max)
					valLbl.Text = tostring(v)
					local t = (v - min) / math.max(max - min, 1)
					fill.Size = UDim2.new(t, 0, 1, 0)
					callback(v)
				end

				local function fromX(x)
					local abs = track.AbsolutePosition.X
					local sz = track.AbsoluteSize.X
					if sz <= 0 then return end
					local t = math.clamp((x - abs) / sz, 0, 1)
					apply(min + t * (max - min))
				end

				track.InputBegan:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						fromX(i.Position.X)
					end
				end)
				Track(UserInputService.InputChanged:Connect(function(i)
					if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
						fromX(i.Position.X)
					end
				end))
				Track(UserInputService.InputEnded:Connect(function() dragging = false end))

				table.insert(Registered, { Type = "Element", Instance = row, Stroke = stroke, Label = lbl, Icon = elementIcon, SubColor = fill, SubRole = "Slider" })

				local obj = {}
				function obj:Set(v) apply(v) end
				function obj:Get() return tonumber(valLbl.Text) end
				return obj
			end

			function Section:CreateButton(bConfig)
				local c = NormalizeArgs(bConfig) or {}
				local name = c.Name or c.Title or "Button"
				local callback = c.Callback or function() end

				local btn = Instance.new("TextButton")
				btn.Size = UDim2.new(1, 0, 0, 36)
				btn.BackgroundColor3 = Elevate(Theme.ElementBackground)
				btn.Text = name
				btn.Font = Enum.Font.GothamBold
				btn.TextSize = 13
				btn.TextColor3 = Theme.Text
				btn.ZIndex = 6
				btn.Parent = container
				local elementIcon = ConfigureElementIcon(btn, c, nil)
				if elementIcon and (c.IconPosition or "Left") == "Left" then
					btn.TextXAlignment = Enum.TextXAlignment.Left
					btn.Text = "   " .. name
				end
				AddCorner(8, btn)
				local stroke = AddStroke(btn, Theme.Outline, 1, 0.4)

				btn.MouseEnter:Connect(function()
					TW(btn, 0.12, { BackgroundColor3 = Theme.Toggle or Color3.fromRGB(220, 40, 40) })
				end)
				btn.MouseLeave:Connect(function()
					TW(btn, 0.12, { BackgroundColor3 = Elevate(Theme.ElementBackground) })
				end)
				btn.MouseButton1Click:Connect(function()
					callback()
				end)

				table.insert(Registered, { Type = "Element", Instance = btn, Stroke = stroke, Label = btn, Icon = elementIcon })
			end

			function Section:CreateDropdown(dConfig)
				local c = NormalizeArgs(dConfig) or {}
				local name = c.Name or c.Title or "Dropdown"
				local options = c.Options or {}
				local default = c.Default or c.Value
				local callback = c.Callback or function() end

				local row, stroke = RegisterRow(42)
				row.Parent = container

				local lbl = Instance.new("TextLabel")
				lbl.Size = UDim2.new(0.4, 0, 1, 0)
				lbl.Position = UDim2.new(0, 12, 0, 0)
				lbl.BackgroundTransparency = 1
				lbl.Text = name
				lbl.Font = Enum.Font.GothamMedium
				lbl.TextSize = 13
				lbl.TextColor3 = Theme.Text
				lbl.TextXAlignment = Enum.TextXAlignment.Left
				lbl.ZIndex = 7
				lbl.Parent = row
				local elementIcon = ConfigureElementIcon(row, c, lbl)

				local sel = Instance.new("TextButton")
				sel.Size = UDim2.new(0.55, -10, 0, 26)
				sel.Position = UDim2.new(0.42, 0, 0.5, -13)
				sel.BackgroundColor3 = Elevate(Theme.ElementBackground)
				sel.Text = ""
				sel.ZIndex = 7
				sel.Parent = row
				AddCorner(6, sel)

				local selLbl = Instance.new("TextLabel")
				selLbl.Size = UDim2.new(1, -28, 1, 0)
				selLbl.Position = UDim2.new(0, 8, 0, 0)
				selLbl.BackgroundTransparency = 1
				selLbl.Text = default and tostring(default) or "Select..."
				selLbl.Font = Enum.Font.Gotham
				selLbl.TextSize = 12
				selLbl.TextColor3 = Theme.Text
				selLbl.TextXAlignment = Enum.TextXAlignment.Left
				selLbl.TextTruncate = Enum.TextTruncate.AtEnd
				selLbl.ZIndex = 8
				selLbl.Parent = sel

				local chev = Instance.new("ImageLabel")
				chev.Size = UDim2.fromOffset(12, 12)
				chev.Position = UDim2.new(1, -18, 0.5, -6)
				chev.BackgroundTransparency = 1
				chev.Image = ResolveIcon("chevron-down")
				chev.ImageColor3 = Theme.Icon
				chev.ZIndex = 8
				chev.Parent = sel

				local list = Instance.new("ScrollingFrame")
				list.BackgroundColor3 = Theme.ElementBackground
				list.BackgroundTransparency = 0.18
				list.Visible = false
				list.ZIndex = 80
				list.ClipsDescendants = true
				list.BorderSizePixel = 0
				list.ScrollBarThickness = 3
				list.CanvasSize = UDim2.new(0, 0, 0, 0)
				list.AutomaticCanvasSize = Enum.AutomaticSize.Y
				list.Parent = MainGui
				AddCorner(6, list)
				AddStroke(list, Theme.Outline, 1, 0.3)
				AddGlassShine(list, 6)

				local listLayout = Instance.new("UIListLayout")
				listLayout.Padding = UDim.new(0, 2)
				listLayout.Parent = list

				local selected = default

				local function build()
					for _, ch in ipairs(list:GetChildren()) do
						if ch:IsA("TextButton") then ch:Destroy() end
					end
					for _, opt in ipairs(options) do
						local txt = type(opt) == "table" and (opt.Text or opt.Value) or tostring(opt)
						local val = type(opt) == "table" and (opt.Value or opt.Text) or opt
						local ob = Instance.new("TextButton")
						ob.Size = UDim2.new(1, -6, 0, 30)
						ob.BackgroundTransparency = 1
						ob.Text = txt
						ob.Font = Enum.Font.Gotham
						ob.TextSize = 12
						ob.TextColor3 = Theme.Text
						ob.ZIndex = 81
						ob.Parent = list
						ob.MouseEnter:Connect(function() ob.BackgroundTransparency = 0.85 end)
						ob.MouseLeave:Connect(function() ob.BackgroundTransparency = 1 end)
						ob.MouseButton1Click:Connect(function()
							selected = val
							selLbl.Text = txt
							list.Visible = false
							callback(val)
						end)
					end
				end
				build()

				RegisterPopup(list, sel)
				sel.MouseButton1Click:Connect(function()
					if list.Visible then
						list.Visible = false
						return
					end
					CloseAllPopups(sel)
					local abs = sel.AbsolutePosition
					local asz = sel.AbsoluteSize
					local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
					local listHeight = math.min(math.max(#options * 32 + 8, 38), 190)
					local x = math.clamp(abs.X, 6, math.max(6, viewport.X - asz.X - 6))
					local belowY = abs.Y + asz.Y + 4
					local aboveY = abs.Y - listHeight - 4
					local y = belowY + listHeight <= viewport.Y - 6 and belowY or math.max(6, aboveY)
					list.Size = UDim2.fromOffset(asz.X, listHeight)
					list.Position = UDim2.fromOffset(x, y)
					list.Visible = true
				end)

				table.insert(Registered, { Type = "Element", Instance = row, Stroke = stroke, Label = lbl, Icon = elementIcon, SubBg = sel, SubText = selLbl, Extras = {{Kind = "Background", Object = list}, {Kind = "Outline", Object = list:FindFirstChildOfClass("UIStroke")}} })

				local obj = {}
				function obj:Set(v)
					selected = v
					selLbl.Text = tostring(v)
				end
				function obj:Get() return selected end
				function obj:Refresh(opts)
					options = opts or {}
					build()
				end
				return obj
			end

			function Section:CreateColorPicker(cpConfig)
				local c = NormalizeArgs(cpConfig) or {}
				local name = c.Name or c.Title or "Color"
				local default = c.Default or c.Value or Color3.fromRGB(220, 40, 40)
				local callback = c.Callback or function() end

				local row, stroke = RegisterRow(42)
				row.Parent = container

				local lbl = Instance.new("TextLabel")
				lbl.Size = UDim2.new(1, -50, 1, 0)
				lbl.Position = UDim2.new(0, 12, 0, 0)
				lbl.BackgroundTransparency = 1
				lbl.Text = name
				lbl.Font = Enum.Font.GothamMedium
				lbl.TextSize = 13
				lbl.TextColor3 = Theme.Text
				lbl.TextXAlignment = Enum.TextXAlignment.Left
				lbl.ZIndex = 7
				lbl.Parent = row
				local elementIcon = ConfigureElementIcon(row, c, lbl)

				local swatch = Instance.new("Frame")
				swatch.Size = UDim2.fromOffset(28, 20)
				swatch.Position = UDim2.new(1, -40, 0.5, -10)
				swatch.BackgroundColor3 = default
				swatch.ZIndex = 7
				swatch.Parent = row
				AddCorner(5, swatch)
				AddStroke(swatch, Color3.fromRGB(0, 0, 0), 1, 0.3)

				local click = Instance.new("TextButton")
				click.Size = UDim2.fromScale(1, 1)
				click.BackgroundTransparency = 1
				click.Text = ""
				click.ZIndex = 8
				click.Parent = row

				local overlay = Instance.new("Frame")
				overlay.Size = UDim2.fromScale(1, 1)
				overlay.BackgroundColor3 = Color3.new(0, 0, 0)
				overlay.BackgroundTransparency = 0.45
				overlay.Visible = false
				overlay.ZIndex = 60
				overlay.Parent = MainFrame

				local overlayClose = Instance.new("TextButton")
				overlayClose.Size = UDim2.fromScale(1, 1)
				overlayClose.BackgroundTransparency = 1
				overlayClose.Text = ""
				overlayClose.ZIndex = 60
				overlayClose.Parent = overlay
				overlayClose.MouseButton1Click:Connect(function() overlay.Visible = false end)

				local popup = Instance.new("Frame")
				popup.Size = UDim2.fromOffset(240, 200)
				popup.Position = UDim2.fromScale(0.5, 0.5)
				popup.AnchorPoint = Vector2.new(0.5, 0.5)
				popup.BackgroundColor3 = Theme.ElementBackground
				popup.BackgroundTransparency = 0.15
				popup.ZIndex = 61
				popup.Parent = overlay
				AddCorner(10, popup)
				AddStroke(popup, Theme.Outline, 1, 0.3)
				AddGlassShine(popup, 10)

				local hue, sat, val = default:ToHSV()
				local selected = default

				local svBox = Instance.new("Frame")
				svBox.Size = UDim2.new(1, -24, 0, 110)
				svBox.Position = UDim2.new(0, 12, 0, 12)
				svBox.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
				svBox.ZIndex = 62
				svBox.Parent = popup
				AddCorner(6, svBox)

				local white = Instance.new("Frame")
				white.Size = UDim2.fromScale(1, 1)
				white.BackgroundColor3 = Color3.new(1, 1, 1)
				white.ZIndex = 62
				white.Parent = svBox
				local wg = Instance.new("UIGradient")
				wg.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
				wg.Parent = white

				local black = Instance.new("Frame")
				black.Size = UDim2.fromScale(1, 1)
				black.BackgroundColor3 = Color3.new(0, 0, 0)
				black.ZIndex = 63
				black.Parent = svBox
				local bg = Instance.new("UIGradient")
				bg.Rotation = 90
				bg.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
				bg.Parent = black

				local cursor = Instance.new("Frame")
				cursor.Size = UDim2.fromOffset(12, 12)
				cursor.AnchorPoint = Vector2.new(0.5, 0.5)
				cursor.Position = UDim2.new(sat, 0, 1 - val, 0)
				cursor.BackgroundColor3 = Color3.new(1, 1, 1)
				cursor.ZIndex = 64
				cursor.Parent = svBox
				AddCorner(6, cursor)
				AddStroke(cursor, Color3.new(0, 0, 0), 1.5, 0)

				local hueTrack = Instance.new("Frame")
				hueTrack.Size = UDim2.new(1, -24, 0, 14)
				hueTrack.Position = UDim2.new(0, 12, 0, 130)
				hueTrack.ZIndex = 62
				hueTrack.Parent = popup
				AddCorner(7, hueTrack)
				local hg = Instance.new("UIGradient")
				hg.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
					ColorSequenceKeypoint.new(0.166, Color3.fromHSV(0.166, 1, 1)),
					ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333, 1, 1)),
					ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
					ColorSequenceKeypoint.new(0.666, Color3.fromHSV(0.666, 1, 1)),
					ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833, 1, 1)),
					ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)),
				})
				hg.Parent = hueTrack

				local hueKnob = Instance.new("Frame")
				hueKnob.Size = UDim2.fromOffset(6, 18)
				hueKnob.AnchorPoint = Vector2.new(0.5, 0.5)
				hueKnob.Position = UDim2.new(hue, 0, 0.5, 0)
				hueKnob.BackgroundColor3 = Color3.new(1, 1, 1)
				hueKnob.ZIndex = 63
				hueKnob.Parent = hueTrack
				AddCorner(3, hueKnob)

				local prev = Instance.new("Frame")
				prev.Size = UDim2.fromOffset(30, 24)
				prev.Position = UDim2.new(0, 12, 0, 156)
				prev.BackgroundColor3 = selected
				prev.ZIndex = 62
				prev.Parent = popup
				AddCorner(5, prev)

				local closeCp = Instance.new("TextButton")
				closeCp.Size = UDim2.fromOffset(60, 24)
				closeCp.Position = UDim2.new(1, -72, 0, 156)
				closeCp.BackgroundColor3 = Elevate(Theme.ElementBackground)
				closeCp.Text = "Done"
				closeCp.Font = Enum.Font.GothamBold
				closeCp.TextSize = 12
				closeCp.TextColor3 = Theme.Text
				closeCp.ZIndex = 62
				closeCp.Parent = popup
				AddCorner(5, closeCp)

				local function recompute(fire)
					selected = Color3.fromHSV(hue, sat, val)
					svBox.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
					cursor.Position = UDim2.new(sat, 0, 1 - val, 0)
					hueKnob.Position = UDim2.new(hue, 0, 0.5, 0)
					swatch.BackgroundColor3 = selected
					prev.BackgroundColor3 = selected
					if fire then callback(selected) end
				end

				local dragSV, dragHue = false, false
				svBox.InputBegan:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
						dragSV = true
						local abs = svBox.AbsolutePosition
						local asz = svBox.AbsoluteSize
						sat = math.clamp((i.Position.X - abs.X) / asz.X, 0, 1)
						val = 1 - math.clamp((i.Position.Y - abs.Y) / asz.Y, 0, 1)
						recompute(true)
					end
				end)
				hueTrack.InputBegan:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
						dragHue = true
						local abs = hueTrack.AbsolutePosition
						local asz = hueTrack.AbsoluteSize
						hue = math.clamp((i.Position.X - abs.X) / asz.X, 0, 1)
						recompute(true)
					end
				end)
				Track(UserInputService.InputChanged:Connect(function(i)
					if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
					if dragSV then
						local abs = svBox.AbsolutePosition
						local asz = svBox.AbsoluteSize
						sat = math.clamp((i.Position.X - abs.X) / asz.X, 0, 1)
						val = 1 - math.clamp((i.Position.Y - abs.Y) / asz.Y, 0, 1)
						recompute(true)
					elseif dragHue then
						local abs = hueTrack.AbsolutePosition
						local asz = hueTrack.AbsoluteSize
						hue = math.clamp((i.Position.X - abs.X) / asz.X, 0, 1)
						recompute(true)
					end
				end))
				Track(UserInputService.InputEnded:Connect(function()
					dragSV = false
					dragHue = false
				end))

				click.MouseButton1Click:Connect(function() overlay.Visible = true end)
				closeCp.MouseButton1Click:Connect(function() overlay.Visible = false end)

				table.insert(Registered, { Type = "Element", Instance = row, Stroke = stroke, Label = lbl, Icon = elementIcon, Extras = {{Kind = "Background", Object = popup}, {Kind = "Outline", Object = popup:FindFirstChildOfClass("UIStroke")}, {Kind = "Text", Object = closeCp}} })

				local obj = {}
				function obj:Set(col)
					hue, sat, val = col:ToHSV()
					recompute(true)
				end
				function obj:Get() return selected end
				return obj
			end

			function Section:CreateInput(iConfig)
				local c = NormalizeArgs(iConfig) or {}
				local name = c.Name or c.Title or "Input"
				local placeholder = c.Placeholder or "Type..."
				local default = c.Default or c.Value or ""
				local callback = c.Callback or function() end

				local row, stroke = RegisterRow(42)
				row.Parent = container

				local lbl = Instance.new("TextLabel")
				lbl.Size = UDim2.new(0.4, 0, 1, 0)
				lbl.Position = UDim2.new(0, 12, 0, 0)
				lbl.BackgroundTransparency = 1
				lbl.Text = name
				lbl.Font = Enum.Font.GothamMedium
				lbl.TextSize = 13
				lbl.TextColor3 = Theme.Text
				lbl.TextXAlignment = Enum.TextXAlignment.Left
				lbl.ZIndex = 7
				lbl.Parent = row
				local elementIcon = ConfigureElementIcon(row, c, lbl)

				local boxFrame = Instance.new("Frame")
				boxFrame.Size = UDim2.new(0.55, -10, 0, 26)
				boxFrame.Position = UDim2.new(0.42, 0, 0.5, -13)
				boxFrame.BackgroundColor3 = Elevate(Theme.ElementBackground)
				boxFrame.ZIndex = 7
				boxFrame.Parent = row
				AddCorner(6, boxFrame)

				local box = Instance.new("TextBox")
				box.Size = UDim2.new(1, -12, 1, 0)
				box.Position = UDim2.new(0, 6, 0, 0)
				box.BackgroundTransparency = 1
				box.Text = default
				box.PlaceholderText = placeholder
				box.PlaceholderColor3 = Theme.Placeholder
				box.TextColor3 = Theme.Text
				box.Font = Enum.Font.Gotham
				box.TextSize = 12
				box.ClearTextOnFocus = false
				box.ZIndex = 8
				box.Parent = boxFrame

				box.FocusLost:Connect(function(enter)
					callback(box.Text, enter)
				end)

				table.insert(Registered, { Type = "Element", Instance = row, Stroke = stroke, Label = lbl, Icon = elementIcon, SubBg = boxFrame, SubText = box })

				local obj = {}
				function obj:Set(t) box.Text = t end
				function obj:Get() return box.Text end
				return obj
			end

			function Section:CreateKeybind(kConfig)
				local c = NormalizeArgs(kConfig) or {}
				local name = c.Name or c.Title or "Keybind"
				local default = c.Default or c.Value
				local callback = c.Callback or function() end

				local row, stroke = RegisterRow(42)
				row.Parent = container

				local lbl = Instance.new("TextLabel")
				lbl.Size = UDim2.new(1, -90, 1, 0)
				lbl.Position = UDim2.new(0, 12, 0, 0)
				lbl.BackgroundTransparency = 1
				lbl.Text = name
				lbl.Font = Enum.Font.GothamMedium
				lbl.TextSize = 13
				lbl.TextColor3 = Theme.Text
				lbl.TextXAlignment = Enum.TextXAlignment.Left
				lbl.ZIndex = 7
				lbl.Parent = row
				local elementIcon = ConfigureElementIcon(row, c, lbl)

				local keyBtn = Instance.new("TextButton")
				keyBtn.Size = UDim2.fromOffset(70, 24)
				keyBtn.Position = UDim2.new(1, -82, 0.5, -12)
				keyBtn.BackgroundColor3 = Elevate(Theme.ElementBackground)
				keyBtn.Text = default and default.Name or "None"
				keyBtn.Font = Enum.Font.GothamBold
				keyBtn.TextSize = 11
				keyBtn.TextColor3 = Theme.Text
				keyBtn.ZIndex = 7
				keyBtn.Parent = row
				AddCorner(5, keyBtn)

				local current = default
				local listening = false
				local conn

				keyBtn.MouseButton1Click:Connect(function()
					if listening then return end
					listening = true
					keyBtn.Text = "..."
					if conn then conn:Disconnect() end
					conn = Track(UserInputService.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.Keyboard then
							current = input.KeyCode
							keyBtn.Text = current.Name
							listening = false
							if conn then conn:Disconnect() end
							callback(current)
						end
					end))
				end)

				table.insert(Registered, { Type = "Element", Instance = row, Stroke = stroke, Label = lbl, Icon = elementIcon, SubBg = keyBtn, SubText = keyBtn })

				local obj = {}
				function obj:Set(k)
					current = k
					keyBtn.Text = k and k.Name or "None"
				end
				function obj:Get() return current end
				return obj
			end

			function Section:CreateLabel(text, iconConfig)
				if type(text) == "table" then
					iconConfig = text
					text = text.Text or text.Title or text.Desc or ""
				end
				local iconCfg = type(iconConfig) == "table" and iconConfig or {}
				local row = Instance.new("Frame")
				row.Size = UDim2.new(1, 0, 0, 28)
				row.BackgroundColor3 = Elevate(Theme.ElementBackground)
				row.BackgroundTransparency = 0.4
				row.ZIndex = 6
				row.Parent = container
				AddCorner(6, row)

				local lbl = Instance.new("TextLabel")
				lbl.Size = UDim2.new(1, -12, 1, 0)
				lbl.Position = UDim2.new(0, 10, 0, 0)
				lbl.BackgroundTransparency = 1
				lbl.Text = tostring(text)
				lbl.Font = Enum.Font.GothamMedium
				lbl.TextSize = 12
				lbl.TextColor3 = Theme.Placeholder
				lbl.TextXAlignment = Enum.TextXAlignment.Left
				lbl.ZIndex = 7
				lbl.Parent = row
				local labelIcon = ConfigureElementIcon(row, iconCfg, lbl)

				table.insert(Registered, { Type = "Section", Label = lbl, Icon = labelIcon })
			end

			function Section:CreateParagraph(text, iconConfig)
				if type(text) == "table" then
					iconConfig = text
					text = text.Text or text.Title or text.Desc or ""
				end
				local iconCfg = type(iconConfig) == "table" and iconConfig or {}
				local row = Instance.new("Frame")
				row.Size = UDim2.new(1, 0, 0, 0)
				row.AutomaticSize = Enum.AutomaticSize.Y
				row.BackgroundColor3 = Elevate(Theme.ElementBackground)
				row.BackgroundTransparency = 0.4
				row.ZIndex = 6
				row.Parent = container
				AddCorner(6, row)

				local pad = Instance.new("UIPadding")
				pad.PaddingTop = UDim.new(0, 8)
				pad.PaddingBottom = UDim.new(0, 8)
				pad.PaddingLeft = UDim.new(0, 10)
				pad.PaddingRight = UDim.new(0, 10)
				pad.Parent = row

				local lbl = Instance.new("TextLabel")
				lbl.Size = UDim2.new(1, 0, 0, 0)
				lbl.AutomaticSize = Enum.AutomaticSize.Y
				lbl.BackgroundTransparency = 1
				lbl.Text = tostring(text)
				lbl.Font = Enum.Font.Gotham
				lbl.TextSize = 12
				lbl.TextColor3 = Theme.Text
				lbl.TextWrapped = true
				lbl.TextXAlignment = Enum.TextXAlignment.Left
				lbl.ZIndex = 7
				lbl.Parent = row
				local labelIcon = ConfigureElementIcon(row, iconCfg, lbl)

				table.insert(Registered, { Type = "Section", Label = lbl, Icon = labelIcon })
			end

			return Section
		end

		function Tab:CreateToggle(...) return Tab:CreateSection(""):CreateToggle(...) end
		function Tab:CreateSlider(...) return Tab:CreateSection(""):CreateSlider(...) end
		function Tab:CreateButton(...) return Tab:CreateSection(""):CreateButton(...) end
		function Tab:CreateDropdown(...) return Tab:CreateSection(""):CreateDropdown(...) end
		function Tab:CreateColorPicker(...) return Tab:CreateSection(""):CreateColorPicker(...) end
		function Tab:CreateInput(...) return Tab:CreateSection(""):CreateInput(...) end
		function Tab:CreateKeybind(...) return Tab:CreateSection(""):CreateKeybind(...) end
		function Tab:CreateLabel(...) return Tab:CreateSection(""):CreateLabel(...) end
		function Tab:CreateParagraph(...) return Tab:CreateSection(""):CreateParagraph(...) end

		return Tab
	end

	UpdateTheme(themeName, false)
	OpenWindow()

	table.insert(LeehHub.Windows, Window)
	return Window
end

function LeehHub:Notify(config)
	config = config or {}
	local title = config.Title or "Notification"
	local content = config.Content or config.Text or ""
	local duration = config.Duration or 3.5
	local ntype = config.Type or "Info"
	local iconKey = config.Icon or ({
		Success = "success",
		Error = "error",
		Warning = "warning",
		Info = "info",
	})[ntype] or "info"

	local colors = {
		Success = Color3.fromRGB(34, 197, 94),
		Error = Color3.fromRGB(239, 68, 68),
		Warning = Color3.fromRGB(245, 158, 11),
		Info = Color3.fromRGB(59, 130, 246),
	}
	local accent = colors[ntype] or colors.Info
	local T = LeehHub.CurrentTheme or LeehHub.Themes.Aurora

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 0)
	frame.BackgroundColor3 = T.ElementBackground
	frame.BackgroundTransparency = 0.25
	frame.ClipsDescendants = true
	frame.Parent = NotificationHolder
	AddCorner(12, frame)
	local stroke = AddStroke(frame, T.Outline, 1, 0.55)
	AddGlassShine(frame, 12)

	local accentBar = Instance.new("Frame")
	accentBar.Size = UDim2.new(0, 3, 1, -14)
	accentBar.Position = UDim2.new(0, 5, 0, 7)
	accentBar.BackgroundColor3 = accent
	accentBar.ZIndex = 2
	accentBar.Parent = frame
	AddCorner(2, accentBar)

	local icon = AddImage(frame, iconKey, UDim2.fromOffset(20, 20), T.Icon, 0, 4)
	if icon then
		icon.Position = UDim2.new(0, 16, 0, 12)
	end

	local tLbl = Instance.new("TextLabel")
	tLbl.Text = title
	tLbl.Font = Enum.Font.GothamBold
	tLbl.TextSize = 13
	tLbl.TextColor3 = T.Text
	tLbl.Position = UDim2.new(0, 44, 0, 8)
	tLbl.Size = UDim2.new(1, -56, 0, 18)
	tLbl.BackgroundTransparency = 1
	tLbl.TextXAlignment = Enum.TextXAlignment.Left
	tLbl.Parent = frame

	local cLbl = Instance.new("TextLabel")
	cLbl.Text = content
	cLbl.Font = Enum.Font.Gotham
	cLbl.TextSize = 11
	cLbl.TextColor3 = T.Placeholder
	cLbl.Position = UDim2.new(0, 44, 0, 28)
	cLbl.Size = UDim2.new(1, -56, 0, 30)
	cLbl.BackgroundTransparency = 1
	cLbl.TextXAlignment = Enum.TextXAlignment.Left
	cLbl.TextYAlignment = Enum.TextYAlignment.Top
	cLbl.TextWrapped = true
	cLbl.Parent = frame

	table.insert(ActiveNotifications, {
		Frame = frame,
		Stroke = stroke,
		Icon = icon,
		Title = tLbl,
		Content = cLbl,
	})

	TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(1, 0, 0, 72)
	}):Play()

	task.delay(duration, function()
		if not frame.Parent then return end
		local out = TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
		})
		out:Play()
		out.Completed:Connect(function()
			for i, item in ipairs(ActiveNotifications) do
				if item.Frame == frame then
					table.remove(ActiveNotifications, i)
					break
				end
			end
			frame:Destroy()
		end)
	end)
end

return LeehHub
