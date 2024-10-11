-- Lados conectados
local sideButton = "right"  -- Lado onde o botão está conectado (direito)
local sideDoor = "left"     -- Lado onde a porta está conectada (esquerdo)

-- Função principal para alternar o estado da porta
while true do
    -- Verifica se o botão foi pressionado
    if redstone.getInput(sideButton) then
        -- Alterna o estado da porta (true/false)
        local currentState = redstone.getOutput(sideDoor)
        redstone.setOutput(sideDoor, not currentState)

        -- Espera o botão ser solto para evitar múltiplas alternâncias
        while redstone.getInput(sideButton) do
            sleep(0.1)
        end
    end
    
    -- Pequeno delay para não sobrecarregar a CPU do computador
    sleep(1)
end
