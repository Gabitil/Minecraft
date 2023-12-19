local ladoRedstone = "right"  -- Substitua pelo lado em que você quer emitir o sinal

while true do
  redstone.setOutput(ladoRedstone, true)  -- Liga o sinal
  os.sleep(0.5)  -- Aguarda 0.5 segundos
  redstone.setOutput(ladoRedstone, false) -- Desliga o sinal
  os.sleep(0.5)  -- Aguarda 0.5 segundos
end
