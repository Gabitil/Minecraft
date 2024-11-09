local monitor = peripheral.find("monitor")
local chests = {}
local itemCount = {}
local line = 1

-- Função para contar itens de todos os baús
local function contarItens()
    for _, chest in ipairs(chests) do
        for slot, item in pairs(chest.list()) do
            if not itemCount[item.name] then
                itemCount[item.name] = {total = 0, slots = {}}
            end
            itemCount[item.name].total = itemCount[item.name].total + item.count
            table.insert(itemCount[item.name].slots, {chest = chest, slot = slot, count = item.count})
        end
    end
end

-- Função para organizar e distribuir os itens
local function organizarItens()
    for itemName, data in pairs(itemCount) do
        local total = data.total
        local slots = data.slots

        -- Distribuir itens entre slots
        for _, slotInfo in ipairs(slots) do
            local chest = slotInfo.chest
            local slot = slotInfo.slot
            local espaco = 64

            if total <= 0 then break end

            local transferir = math.min(total, espaco)
            chest.pushItems(peripheral.getName(chest), slot, transferir)
            total = total - transferir

            -- Atualizar monitor
            monitor.setCursorPos(1, line)
            monitor.write("Distribuindo " .. transferir .. " de " .. itemName)
            line = line + 1
        end
    end
end

-- Main
if monitor then
    monitor.clear()
    monitor.setCursorPos(1, 1)

    -- Inicializa chests
    for _, name in ipairs(peripheral.getNames()) do
        if peripheral.hasType(name, "minecraft:chest") then
            table.insert(chests, peripheral.wrap(name))
        end
    end

    local inicio = os.epoch("utc")

    contarItens()
    organizarItens()

    local tempo = os.epoch("utc") - inicio
    print("Tempo de execução: " .. tempo .. " ms")
else
    print("Monitor não encontrado!")
end
