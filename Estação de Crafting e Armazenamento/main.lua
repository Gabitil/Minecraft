local monitor = peripheral.find("monitor")
local chests = {}
local line = 1
local startTime = os.time() -- Marca o início
-- lista que guarda os itens não completos, seu slot e bau
local itensNaoCompletos = {}


--função  que recebe a lista chests para procurar itens não completos
local function procurarItensNaoCompletos(chests)
    for _, chest in ipairs(chests) do
        for slot, item in pairs(chest.list()) do
            if item.count < chest.getItemLimit(slot) then
                table.insert(itensNaoCompletos, {chest = chest, slot = slot, item = item})
            end
        end
    end
end

--função para conferir se tem mais de um item igual incompleto, se não tiver exclui da lista de procurar
local function conferirItensNaoCompletos()

    local temIgual = false;
    for i, item in ipairs(itensNaoCompletos) do
        for j, item2 in ipairs(itensNaoCompletos) do
            if i ~= j and item.item.name == item2.item.name then
                temIgual = true
            end
        end
        if not temIgual then
            table.remove(itensNaoCompletos, i)
        end
    end
    return false
    
end

--função que recebe dois baús e transfere os itens
local function transferirItens()
    if #itensNaoCompletos == 0 then
        print("Não há itens incompletos para transferir.")
        return
    end

    for i, item in ipairs(itensNaoCompletos) do
        for j, item2 in ipairs(itensNaoCompletos) do
            if i ~= j and item.item.name == item2.item.name then
                local transferir = math.min(item.item.count, item2.item.count)
                item.chest.pushItems(peripheral.getName(item2.chest), item2.slot, transferir)
                item2.chest.pushItems(peripheral.getName(item.chest), item.slot, transferir)
                item.item.count = item.item.count + transferir
                item2.item.count = item2.item.count - transferir
            end
        end
    end
end


if monitor then
    monitor.clear()
    monitor.setCursorPos(1, 1)

    -- Itera sobre os perifericos conectados
    local inicioPerifericos = os.time()
    for _, name in ipairs(peripheral.getNames()) do --
        if peripheral.hasType(name, "minecraft:chest") then -- Se o periférico for um baú, adiciona na tabela
            table.insert(chests, peripheral.wrap(name)) -- dentro da tabela os dados são: {peripheral.wrap(name), name}
        end
    end

    local tempoPerifericos = os.time() - inicioPerifericos
    print("Tempo de busca dos periféricos: " .. tempoPerifericos .. " segundos")

    local inicioContagem = os.time()
    -- Procura itens não completos
    procurarItensNaoCompletos(chests)

    local tempoContagem = os.time() - inicioContagem
    print("Tempo de contagem dos itens: " .. tempoContagem .. " segundos")

    -- Conferir se tem mais de um item igual incompleto, se não tiver exclui da lista de procurar
    local inicioConferir = os.time()
    conferirItensNaoCompletos()
    local tempoConferir = os.time() - inicioConferir
    print("Tempo de conferir itens: " .. tempoConferir .. " segundos")

    -- itera dentro da lista itens não completos e vai completando os itens
    local inicioTransferencia = os.time()

    transferirItens()

    local tempoTransferencia = os.time() - inicioTransferencia
    print("Tempo de transferência dos itens: " .. tempoTransferencia .. " segundos")

    
    else
    print("Monitor nao encontrado!")
end


-- Calcula o tempo de execução
local endTime = os.time()
local tempoExecucao = endTime - startTime /20 

print("Tempo de execução: " .. tempoExecucao .. " segundos")