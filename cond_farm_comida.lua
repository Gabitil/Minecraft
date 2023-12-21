-- Desc: Controla o funcionamento do plantador de comida

while true do
  -- Verifica o sinal de redstone atrás
  local sinalAtras = redstone.getInput(back)

  -- Verifica o sinal de redstone à direita
  local sinalDireita = redstone.getInput(right)

  -- Atualiza o estado do flip-flop com base nos sinais
  if sinalAtras then
    redstone.setOutput(left, false)  -- Desliga o sinal à esquerda
  elseif sinalDireita then
    redstone.setOutput(left, true)  -- Liga o sinal à esquerda
  end

  -- Aguarda um curto período antes de verificar novamente
  os.sleep(0.1)
end
