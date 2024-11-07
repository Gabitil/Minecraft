local monitor = peripheral.find("monitor")
local chests = {}
local line = 1

-- Verifica se o monitor foi encontrado
if monitor then
    monitor.clear()  -- Limpa a tela do monitor
    monitor.setCursorPos(1, 1)  -- Inicia na posição (1,1)
    
    -- Procura por periféricos do tipo "minecraft:chest" e adiciona cada um à tabela 'chests'
    for _, name in ipairs(peripheral.getNames()) do
        if peripheral.hasType(name, "minecraft:chest") then
            table.insert(chests, peripheral.wrap(name))
        end
    end

    -- Exemplo: acessando itens de todos os baús
    for i, chest in ipairs(chests) do
        local items = chest.list()
        monitor.write("Baú " .. i .. ":")
        line = line + 1
        monitor.setCursorPos(1, line)
        
        for slot, item in pairs(items) do
            monitor.write("Slot " .. slot .. ": " .. item.name .. " x" .. item.count)
            line = line + 1
            monitor.setCursorPos(1, line)

            -- Checa se o monitor alcançou o limite de linhas, e limpa para a próxima página se necessário
            if line > monitor.getSize() then
                monitor.clear()
                line = 1
            end
        end
    end
else
    print("Monitor não encontrado!")
end
