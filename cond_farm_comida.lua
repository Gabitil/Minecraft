-- Desc: Controla o funcionamento do plantador de comida

local esquerda = "left" -- Saída do sinal de redstone
local direita = "right" -- Entrada do sinal de redstone
local atras = "back" -- Entrada do sinal de redstone
while true do
  -- Verifica o sinal de redstone atrás
  local sinalAtras = redstone.getInput(atras)

  -- Verifica o sinal de redstone à direita
  local sinalDireita = redstone.getInput(direita)

  -- Atualiza o estado do flip-flop com base nos sinais
  if sinalAtras then
    redstone.setOutput(esquerda, false)  -- Desliga o sinal à esquerda
  elseif sinalDireita then
    redstone.setOutput(esquerda, true)  -- Liga o sinal à esquerda
  end

  -- Aguarda um curto período antes de verificar novamente
  os.sleep(0.1)
end
