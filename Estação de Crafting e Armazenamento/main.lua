local monitor = peripheral.find("monitor")
local chests = {}
local line = 1

local function transferirItens(chest1, chest2)
    if not chest1 or not chest2 then
        return
    end

    -- Tabela dos itens do baú 1 para evitar acessar slots repetidamente
    local itemsChest1 = chest1.list()
    local itemsChest2 = chest2.list()

    for slot1, item1 in pairs(itemsChest1) do
        for slot2, item2 in pairs(itemsChest2) do
            if item1.name == item2.name then
                local espacoNoBau1 = 64 - item1.count
                local quantidadeTransferir = math.min(espacoNoBau1, item2.count)
                
                if quantidadeTransferir > 0 then
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

    for _, name in ipairs(peripheral.getNames()) do
        if peripheral.hasType(name, "minecraft:chest") then
            table.insert(chests, peripheral.wrap(name))
        end
    end

    for i = 1, #chests - 1 do
        for j = i + 1, #chests do
            transferirItens(chests[i], chests[j])
        end
    end

    for i, chest in ipairs(chests) do
        local items = chest.list()

        monitor.write("Baú " .. i .. ":")
        line = line + 1
        monitor.setCursorPos(1, line)
        
        for slot, item in pairs(items) do
            monitor.write("Slot " .. slot .. ": " .. item.name .. " x" .. item.count)
            line = line + 1
            monitor.setCursorPos(1, line)

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
