local monitor = peripheral.find("monitor")
local chests = {}
local line = 1

local function transferirItens(chest1, chest2)
    -- Verifica se os baús são válidos
    if not chest1 or not chest2 then
        print("Um ou ambos os baús não são válidos.")
        return
    end

    -- Percorrer os slots dos baús
    for slot1, item1 in pairs(chest1.list()) do
        -- Verificar se há itens de mesmo tipo no segundo baú
        for slot2, item2 in pairs(chest2.list()) do
            if item1.name == item2.name then
                local espacoNoBau1 = 64 - item1.count
                local espacoNoBau2 = 64 - item2.count

                -- Caso o baú1 tenha espaço, mova os itens do baú2 para o baú1
                if espacoNoBau1 > 0 and item2.count > 0 then
                    local quantidadeTransferir = math.min(espacoNoBau1, item2.count)
                    chest2.pushItems(peripheral.getName(chest1), slot2, quantidadeTransferir, slot1)-- 
                    print("Transferindo " .. quantidadeTransferir .. " " .. item2.name .. " de Bau 2 para Bau 1")
                end
            end
        end
    end
end

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

    -- Exemplo: transferindo itens entre baús
    for i = 1, #chests - 1 do
        transferirItens(chests[i], chests[i + 1])
    end

    -- Exemplo: acessando itens de todos os baús
    for i, chest in ipairs(chests) do
        local items = chest.list()



        monitor.write("Bau " .. i .. ":")
        line = line + 1
        monitor.setCursorPos(1, line)
        
        -- Exibe os itens de cada baú
        for slot, item in pairs(items) do
            monitor.write("Slot " .. slot .. ": " .. item.name .. " x" .. item.count)
            line = line + 1
            monitor.setCursorPos(1, line)

            -- Checa se o monitor alcançou o limite de linhas, e limpa para a próxima página se necessário
            local width, height = monitor.getSize()
            if line > height then
                monitor.clear()
                line = 1
                monitor.setCursorPos(1, line)
            end
        end
    end
else
    print("Monitor nao encontrado!")
end
