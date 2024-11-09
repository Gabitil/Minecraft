local monitor = peripheral.find("monitor")
local chests = {}
local line = 1

-- Função para transferir itens de um baú para outro
local function transferirItens(chest1, chest2)
    if not chest1 or not chest2 then
        return
    end

    -- Tabela dos itens do baú 1 para evitar acessar slots repetidamente
    local itemsChest1 = chest1.list()
    local itemsChest2 = chest2.list()

    -- Itera sobre os itens do baú 1
    for slot1, item1 in pairs(itemsChest1) do 
        -- Itera sobre os itens do baú 2
        for slot2, item2 in pairs(itemsChest2) do
            -- Se os itens forem iguais, transfere a quantidade máxima possível
            if item1.name == item2.name then
                -- Calcula o espaço no baú 1
                local espacoNoBau1 = 64 - item1.count
                -- Calcula a quantidade a ser transferida
                local quantidadeTransferir = math.min(espacoNoBau1, item2.count)
                
                -- Se a quantidade a ser transferida for maior que 0, transfere
                if quantidadeTransferir > 0 then
                    
                    -- Atualiza o monitor
                    monitor.setCursorPos(1, line)
                    monitor.write("Transferindo " .. quantidadeTransferir .. " " .. item1.name .. " de " .. peripheral.getName(chest1) .. " para " .. peripheral.getName(chest2))
                    line = line + 1

                    -- Transfere os itens
                    chest2.pushItems(peripheral.getName(chest1), slot2, quantidadeTransferir)
                    item1.count = item1.count + quantidadeTransferir
                    item2.count = item2.count - quantidadeTransferir
                end
            end
        end
    end
end

if monitor then
    monitor.clear()
    monitor.setCursorPos(1, 1)

    -- Itera sobre os perifericos conectados
    for _, name in ipairs(peripheral.getNames()) do --
        if peripheral.hasType(name, "minecraft:chest") then -- Se o periférico for um baú, adiciona na tabela
            table.insert(chests, peripheral.wrap(name)) -- dentro da tabela os dados são: {peripheral.wrap(name), name}
        end
    end

    -- Itera sobre os baús
    for i = 1, #chests - 1 do
        for j = i + 1, #chests do
            transferirItens(chests[i], chests[j])
        end
    end

else
    print("Monitor nao encontrado!")
end
