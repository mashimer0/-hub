local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService") -- ★アニメーション用のサービスを追加

local player = Players.LocalPlayer

-- ==========================================
-- GUI作成 & レインボーデザイン
-- ==========================================
local gui = Instance.new("ScreenGui")
gui.Name = "MashumeloAutoChatGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- メインフレーム
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 160)
frame.Position = UDim2.new(0.5, -110, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- ★グラデーションを映えさせるためにベースを白に
frame.BorderSizePixel = 0
frame.Active = true 
frame.ClipsDescendants = true
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = frame

-- ★【重要】背景用の動くレインボーグラデーション
local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 128)),   -- ビビッドピンク
	ColorSequenceKeypoint.new(0.2, Color3.fromRGB(128, 0, 255)), -- パープル
	ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 128, 255)), -- ブルー
	ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 128)), -- グリーン
	ColorSequenceKeypoint.new(0.8, Color3.fromRGB(255, 255, 0)),   -- イエロー
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 128))    -- ループ用ピンク
})
bgGradient.Parent = frame

-- ★グラデーションを「キラッと動かす」アニメーション処理
task.spawn(function()
	while true do
		-- グラデーションのOffset（位置）を0から1へ1.5秒かけて滑らかに移動させる
		local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
		local tween = TweenService:Create(bgGradient, tweenInfo, {Offset = Vector2.new(-1, 0)})
		tween:Play()
		tween.Completed:Wait()
		
		-- 1周したら位置を瞬時に戻して無限ループ
		bgGradient.Offset = Vector2.new(1, 0)
	end
end)

-- タイトルレーベル（背景が派手なので文字を白にして、少し暗い影を付けて見やすくしました）
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 150, 0, 28)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.Text = "ましゅめろ💫👾⭐️"
titleLabel.TextSize = 13
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.FredokaOne
titleLabel.BackgroundTransparency = 1
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Active = false
titleLabel.Parent = frame

local titleShadow = Instance.new("UIStroke") -- 文字の輪郭（影）
titleShadow.Thickness = 1.5
titleShadow.Color = Color3.fromRGB(0, 0, 0)
titleShadow.Parent = titleLabel

-- メッセージ入力ボックス（背景に馴染むよう半透明のダークに）
local msgBox = Instance.new("TextBox")
msgBox.Size = UDim2.new(0.9, 0, 0, 28)
msgBox.Position = UDim2.new(0.05, 0, 0.24, 0)
msgBox.Text = ""
msgBox.PlaceholderText = "メッセージを入力..."
msgBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
msgBox.TextSize = 12
msgBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
msgBox.BackgroundTransparency = 0.2 -- ★少し透けさせて後ろのレインボーをうっすら見せる
msgBox.TextColor3 = Color3.fromRGB(255, 255, 255)
msgBox.Active = true
local msgCorner = Instance.new("UICorner")
msgCorner.CornerRadius = UDim.new(0, 4)
msgCorner.Parent = msgBox
msgBox.Parent = frame

-- 秒数入力用の説明ラベル
local secLabel = Instance.new("TextLabel")
secLabel.Size = UDim2.new(0.4, 0, 0, 18)
secLabel.Position = UDim2.new(0.05, 0, 0.48, 0)
secLabel.Text = "間隔 (秒):"
secLabel.TextSize = 12
secLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
secLabel.BackgroundTransparency = 1
secLabel.TextXAlignment = Enum.TextXAlignment.Left
secLabel.Active = false
secLabel.Parent = frame

local secLabelShadow = Instance.new("UIStroke")
secLabelShadow.Thickness = 1.5
secLabelShadow.Color = Color3.fromRGB(0, 0, 0)
secLabelShadow.Parent = secLabel

-- 秒数入力ボックス
local secBox = Instance.new("TextBox")
secBox.Size = UDim2.new(0.35, 0, 0, 24)
secBox.Position = UDim2.new(0.45, 0, 0.45, 0)
secBox.Text = "5"
secBox.TextSize = 12
secBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
secBox.BackgroundTransparency = 0.2
secBox.TextColor3 = Color3.fromRGB(0, 255, 200) -- ネオンエメラルド
secBox.Active = true
local secCorner = Instance.new("UICorner")
secCorner.CornerRadius = UDim.new(0, 4)
secCorner.Parent = secBox
secBox.Parent = frame

-- 開始ボタン
local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(0.42, 0, 0, 30)
startBtn.Position = UDim2.new(0.05, 0, 0.74, 0)
startBtn.Text = "開始"
startBtn.TextSize = 13
startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 216)
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.Font = Enum.Font.SourceSansBold
startBtn.Parent = frame

local startCorner = Instance.new("UICorner")
startCorner.CornerRadius = UDim.new(0, 4)
startCorner.Parent = startBtn

-- 停止ボタン
local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0.42, 0, 0, 30)
stopBtn.Position = UDim2.new(0.53, 0, 0.74, 0)
stopBtn.Text = "停止"
stopBtn.TextSize = 13
stopBtn.BackgroundColor3 = Color3.fromRGB(194, 36, 93)
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.Font = Enum.Font.SourceSansBold
stopBtn.Parent = frame

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 4)
stopCorner.Parent = stopBtn

-- ==========================================
-- 折りたたみ（最小化）ボタン
-- ==========================================
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 24, 0, 20)
toggleBtn.Position = UDim2.new(1, -29, 0, 4)
toggleBtn.Text = "➖"
toggleBtn.TextSize = 10
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleBtn.BackgroundTransparency = 0.3
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.Parent = frame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 4)
toggleCorner.Parent = toggleBtn

local isMinimized = false
local originalSize = frame.Size
local minimizedSize = UDim2.new(0, 220, 0, 28)

local function setContentVisible(visible)
	msgBox.Visible = visible
	secLabel.Visible = visible
	secBox.Visible = visible
	startBtn.Visible = visible
	stopBtn.Visible = visible
end

toggleBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	if isMinimized then
		frame.Size = minimizedSize
		toggleBtn.Text = "⬜"
		setContentVisible(false)
	else
		frame.Size = originalSize
		toggleBtn.Text = "➖"
		setContentVisible(true)
	end
end)

-- ==========================================
-- GUIドラッグ移動のスクリプト
-- ==========================================
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		local target = gui:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)[1]
		if target and (target:IsA("TextBox") or target:IsA("TextButton")) then
			return
		end
		
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- ==========================================
-- ロジック部分（自動チャット）
-- ==========================================
local running = false

local function autoChat()
	while running do
		local message = msgBox.Text
		local seconds = tonumber(secBox.Text)

		if not seconds or seconds < 1 then
			seconds = 5
			secBox.Text = "5"
		end

		if message ~= "" then
			pcall(function()
				local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
				if channel then
					channel:SendAsync(message)
				end
			end)
		end

		task.wait(math.max(seconds, 1))
	end
end

startBtn.MouseButton1Click:Connect(function()
	if running then return end
	
	running = true
	startBtn.AutoButtonColor = false
	startBtn.Text = "実行中..."
	startBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 190)
	
	task.spawn(autoChat)
end)

stopBtn.MouseButton1Click:Connect(function()
	running = false
	startBtn.AutoButtonColor = true
	startBtn.Text = "開始"
	startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 216)
end)
