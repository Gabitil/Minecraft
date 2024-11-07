-- Tabela para armazenar os baus
local printer = peripheral.find("printer")
local chests = {}
i=3
printer.newPage()
printer.setPageTitle("Teste impressora")
-- Procura por perifericos do tipo "minecraft:chest" e adiciona cada um à tabela 'chests'
for _, name in ipairs(peripheral.getNames()) do -- 'ipairs' retorna uma tabela com os indices e valores da tabela 'peripheral.getNames()'
    if peripheral.hasType(name, "minecraft:chest") then
        table.insert(chests, peripheral.wrap(name))
       
        printer.write("resultado wrap", peripheral.wrap(name))
        printer.setCursorPos(1,i)
        i=i+1

    end
end

-- Exemplo: acessando itens de todos os baús
for i, chest in ipairs(chests) do

    printer.write("Bau " .. i .. ":")
    printer.setCursorPos(1,i)
    i=i+1
    local items = chest.list()
    for slot, item in pairs(items) do -- 'pairs' retorna uma tabela com os indices e valores da tabela 'items' asfdasfasfasdas
        printer.write("Slot " .. slot .. ": " .. item.name .. " x" .. item.count)
        printer.setCursorPos(1,i)
        i=i+1
    end


end
printer.endPage()
