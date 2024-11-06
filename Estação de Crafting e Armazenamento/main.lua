-- Tabela para armazenar os baus
local chests = {}

-- Procura por perifericos do tipo "minecraft:chest" e adiciona cada um à tabela 'chests'
for _, name in ipairs(peripheral.getNames()) do -- 'ipairs' retorna uma tabela com os indices e valores da tabela 'peripheral.getNames()'
    if peripheral.hasType(name, "minecraft:chest") then
        table.insert(chests, peripheral.wrap(name))
        print("resultado wrap", peripheral.wrap(name))
    end
end

-- Exemplo: acessando itens de todos os baús
for i, chest in ipairs(chests) do
    print("Bau " .. i .. ":")
    local items = chest.list()
    for slot, item in pairs(items) do -- 'pairs' retorna uma tabela com os indices e valores da tabela 'items' asfdasfasfasdas
        print("Slot " .. slot .. ": " .. item.name .. " x" .. item.count)
    end


end
