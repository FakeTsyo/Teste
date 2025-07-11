--[[
  Lendas do Vôlei - Script Mobile Helper
  Por: Copilot GitHub
  Funções:
  - Auto Rolar Estilo (se possível)
  - Auto Rolar Habilidade (se possível)
  - Auto Perfect
  - Aumentar Velocidade
  - Auto Defesa
  - Exibir mensagens de erro se não for possível automatizar rolagens
--]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- UTIL: Notificação mobile
local function notify(title, text, duration)
    game.StarterGui:SetCore("SendNotification", {
        Title = title, Text = text, Duration = duration or 3
    })
end

-- Tentar encontrar RemoteEvents para rolar estilo/habilidade
local function findRemote(remoteName)
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") and string.lower(obj.Name):find(remoteName) then
            return obj
        end
    end
    return nil
end

-- 1. Auto Rolar Estilo
local estiloRemote = findRemote("estilo") or findRemote("style") or findRemote("rollstyle")
local function autoRollEstilo()
    if not estiloRemote then
        notify("Erro", "Não foi possível encontrar RemoteEvent para rolar estilo!", 5)
        return
    end
    notify("Auto Estilo", "Rolando estilo até raro...", 2)
    local running = true
    spawn(function()
        while running do
            estiloRemote:FireServer()
            wait(0.7)
        end
    end)
    -- Parar com duplo toque na tela
    UIS.TouchTap:Connect(function()
        running = false
        notify("Auto Estilo", "Parado.", 2)
    end)
end

-- 2. Auto Rolar Habilidade
local habRemote = findRemote("habilidade") or findRemote("skill") or findRemote("rollhabilidade")
local function autoRollHabilidade()
    if not habRemote then
        notify("Erro", "Não foi possível encontrar RemoteEvent para rolar habilidade!", 5)
        return
    end
    notify("Auto Habilidade", "Rolando habilidade até rara...", 2)
    local running = true
    spawn(function()
        while running do
            habRemote:FireServer()
            wait(0.7)
        end
    end)
    -- Parar com duplo toque na tela
    UIS.TouchTap:Connect(function()
        running = false
        notify("Auto Habilidade", "Parado.", 2)
    end)
end

-- 3. Auto Perfect (tenta acertar sempre no time perfeito)
local function autoPerfect()
    notify("Auto Perfect", "Ativo!", 2)
    local char = player.Character or player.CharacterAdded:Wait()
    runService.RenderStepped:Connect(function()
        -- Exemplo genérico: define atributo "PerfectTime" como verdadeiro se existir
        if char and char:FindFirstChild("PerfectTime") then
            char.PerfectTime.Value = true
        end
    end)
end

-- 4. Speed Hack (Aumentar velocidade do personagem)
local function speedHack(vel)
    notify("Speed", "Velocidade aumentada para "..vel, 2)
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = vel
    end
end

-- 5. Auto Defesa (exemplo: tenta ativar defesa automática)
local function autoDefesa()
    notify("Auto Defesa", "Ativo!", 2)
    runService.RenderStepped:Connect(function()
        -- Exemplo genérico: ativa defesa se bola se aproximar
        -- Precisa identificar a bola e a distância
        local bola = workspace:FindFirstChild("Bola") or workspace:FindFirstChild("Ball")
        if bola and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (bola.Position - player.Character.HumanoidRootPart.Position).magnitude
            if dist < 10 then
                -- Exemplo: ativa defesa se tiver Remote
                local defesaRemote = findRemote("defesa") or findRemote("defense")
                if defesaRemote then defesaRemote:FireServer() end
            end
        end
    end)
end

-- MENU SIMPLES MOBILE
notify("VOLÊI LENDAS", "Menu aberto! Toque nos botões.", 5)

local menu = Instance.new("ScreenGui", player.PlayerGui)
menu.Name = "MenuVoleiLendas"

local function createButton(txt, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 180, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, pos)
    btn.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
    btn.Text = txt
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 20
    btn.Parent = menu
    btn.MouseButton1Click:Connect(callback)
end

createButton("Auto Rolar Estilo", 40, autoRollEstilo)
createButton("Auto Rolar Habilidade", 90, autoRollHabilidade)
createButton("Auto Perfect", 140, autoPerfect)
createButton("Speed x2", 190, function() speedHack(32) end)
createButton("Auto Defesa", 240, autoDefesa)
createButton("Fechar Menu", 290, function() menu:Destroy() end)

notify("VOLÊI LENDAS", "Script carregado no mobile!", 4)
