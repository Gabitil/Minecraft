
local chests = {} -- Lista de baús
local startTime = os.time() -- Marca o início
-- lista que guarda os itens não completos, seu slot e bau
local itensNaoCompletos = {} -- Lista de itens não completos

-- Abre o arquivo de log para salvar a saída
local logFile = fs.open("saida.txt", "w")

-- Redefine a função `print` para registrar as mensagens no arquivo
function print(...)
    local args = {...}
    for i, v in ipairs(args) do
        logFile.write(tostring(v) .. "\t")
    end
    logFile.write("\n")
    logFile.flush()
end

-- Captura erros usando pcall para salvar no arquivo também
local status, err = pcall(function()

    --função  que recebe a lista chests para procurar itens não completos
    local function procurarItensNaoCompletos(chests)
        for _, chest in ipairs(chests) do
            for slot, item in pairs(chest.list()) do
                -- Busca detalhes completos do item
                local itemDetail = chest.getItemDetail(slot) -- Detalhes do item
                if itemDetail and itemDetail.count < chest.getItemLimit(slot) then -- Verifica se o item é incompleto
                    table.insert(itensNaoCompletos, {chest = chest, slot = slot, item = item, itemDetail = itemDetail}) -- Adiciona à lista de itens incompletos
                    print("Item incompleto: " .. itemDetail.displayName .. " " .. itemDetail.count .. " limite: " .. chest.getItemLimit(slot))
                end
            end
        end
    end

    --função para conferir se tem mais de um item igual incompleto, se não tiver exclui da lista de procurar
    local function conferirItensNaoCompletos()
        local itensParaManter = {} -- Lista de itens para manter
    
        -- Itera sobre a lista de itens incompletos
        for i, item in ipairs(itensNaoCompletos) do
            local temIgual = false
    
            -- Verifica se existe um item igual na lista
            for j, item2 in ipairs(itensNaoCompletos) do
                if i ~= j and item.itemDetail.displayName == item2.itemDetail.displayName then -- Verifica se o nome é igual e o slot é diferente
                    temIgual = true
                    break -- Encontrou um item igual, então não precisa continuar verificando
                end
            end
    
            -- Se tiver item igual, adiciona à lista de itens para manter
            if temIgual then
                table.insert(itensParaManter, item) -- Adicionando à lista de itens para manter
                print("Item duplicado encontrado: " .. item.itemDetail.displayName .. " " .. item.itemDetail.count .. " slot " .. item.slot .. " bau " .. peripheral.getName(item.chest))
            end
        end
    
        -- Atualiza a lista de itens não completos com apenas os duplicados
        itensNaoCompletos = itensParaManter
    end

    -- Verifica se um item existe na tabela
    local function itemExists(tabela, itemToFind)
        for _, item in ipairs(tabela) do
            if item.chest == itemToFind.chest and 
               item.slot == itemToFind.slot and
               item.item == itemToFind.item and
               item.itemDetail.displayName == itemToFind.itemDetail.displayName and
               item.itemDetail.count == itemToFind.itemDetail.count then
                return true
            end
        end
        return false
    end
    
    --função que recebe dois baús e transfere os itens
    local function transferirItens()

        -- Verifica se não há itens incompletos
        if #itensNaoCompletos == 0 then
            print("Nao ha itens incompletos para transferir.")
            return
        end
        -- Fazer uma cópia da tabela itensNaoCompletos
        local itensNaoFinalizados = {} -- Lista de itens não finalizados
        for i, item in ipairs(itensNaoCompletos) do
            table.insert(itensNaoFinalizados, item) -- Adiciona à lista de itens não finalizados
        end

        local itemfinalizado = {} -- Lista de itens finalizados

        -- Itera sobre a lista de itens incompletos
        for i, item in ipairs(itensNaoCompletos) do

            if itemExists(itemfinalizado, item) then -- Verifica se o item já foi finalizado
                break
            end
                for j, item2 in ipairs(itensNaoFinalizados) do -- Itera sobre a lista de itens não finalizados
                    if item.slot ~= item2.slot and item.itemDetail.displayName == item2.itemDetail.displayName and item.itemDetail.count < item.chest.getItemLimit(item.slot) and item.itemDetail.count > 0 then -- Verifica se o nome é igual e o slot é diferente
                        local qntfalta = item.chest.getItemLimit(item.slot) - item.itemDetail.count -- Calcula a quantidade que falta para completar o stack
                        local qntTrans = 0 -- Quantidade a ser transferida

                        if item2.itemDetail.count > qntfalta then -- Verifica se a quantidade do item2 é maior que a quantidade que falta

                            item.chest.pullItems(peripheral.getName(item2.chest), item2.slot, qntfalta, item.slot) -- Transfere a quantidade que falta
                            qntTrans = qntfalta
                            table.insert(itemfinalizado, item) -- Adiciona o item à lista de itens finalizados
                            table.remove(itensNaoFinalizados, i) -- Remove o item da lista de itens não finalizados
                            print("Transferindo " .. qntTrans .. " " .. item.itemDetail.displayName .. " do bau " .. peripheral.getName(item2.chest) .. " slot ".. item2.slot .." para o bau " .. peripheral.getName(item.chest) .. " slot ".. item.slot)
                            break

                        else                            
                            item.chest.pullItems(peripheral.getName(item2.chest), item2.slot, qntfalta, item.slot)
                            local falta = qntfalta - item2.itemDetail.count
                            qntTrans = item2.itemDetail.count
                            print("Transferindo " .. qntTrans .. " " .. item.itemDetail.displayName .. " do bau " .. peripheral.getName(item2.chest) .. " slot ".. item2.slot .. " para o bau " .. peripheral.getName(item.chest) .. " slot ".. item.slot .. " falta " .. falta)
                        end
                    end
                end      
        end
    end




    -- Itera sobre os perifericos conectados
    local inicioPerifericos = os.time()
    for _, name in ipairs(peripheral.getNames()) do
        if peripheral.hasType(name, "minecraft:chest") then
            table.insert(chests, peripheral.wrap(name))
        end
    end

    local tempoPerifericos = os.time() - inicioPerifericos
    print("Tempo de busca dos perifericos: " .. tempoPerifericos .. " segundos")

    local inicioContagem = os.time()
    -- Procura itens não completos
    procurarItensNaoCompletos(chests)

    local tempoContagem = os.time() - inicioContagem
    print("Tempo de contagem dos itens: " .. tempoContagem .. " segundos")

    -- Conferir se tem mais de um item igual incompleto
    local inicioConferir = os.time()
    conferirItensNaoCompletos()
    local tempoConferir = os.time() - inicioConferir
    print("Tempo de conferir itens: " .. tempoConferir .. " segundos")

    -- itera dentro da lista itens não completos e vai completando os itens
    local inicioTransferencia = os.time()
    transferirItens()
    local tempoTransferencia = os.time() - inicioTransferencia
    print("Tempo de transferencia dos itens: " .. tempoTransferencia .. " segundos")


    -- Calcula o tempo de execução
    local endTime = os.time()
    local tempoExecucao = endTime - startTime / 20
    print("Tempo de execucao: " .. tempoExecucao .. " segundos")
end)

-- Salva o erro, caso exista
if not status then
    logFile.write("Erro encontrado: " .. err .. "\n")
end

-- Fecha o arquivo de log
logFile.close()
