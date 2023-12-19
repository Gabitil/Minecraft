-- Programa para verificar continuamente se o sinal de redstone e o baú estão vazios

-- Defina o lado em que o sinal de redstone está chegando e o lado em que o baú está conectado
local ladoRedstone = "left"  -- Substitua com o lado correto
local ladoBau = "right"      -- Substitua com o lado correto

-- Função para verificar se o sinal do pulso de redstone está ativo (true) ou não (false)
local function redstoneAtivo()
  return redstone.getInput(ladoRedstone)
end

-- Função para verificar se o armazem está vazio (true) ou não (false)
local function bauVazio()
  return redstone.getInput(ladoBau)
end

-- Loop infinito
while true do
  -- Lógica AND: A ação só ocorre se ambos os sinais estiverem ativos
  if redstoneAtivo() and bauVazio() then
    -- Coloque aqui a lógica para ligar a máquina
    redstone.setOutput("back", true)
  else
    redstone.setOutput("back", false)
  end

  os.sleep(0.5)  -- Aguarda 0.5 segundos
end