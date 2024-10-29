local chestSide = "right"  -- Substitua pelo lado onde está o baú: "left", "right", "top", "bottom", etc.

-- Função para listar itens dentro do baú
function listarItens()
    if peripheral.isPresent(chestSide) and peripheral.getType(chestSide) == "minecraft:chest" then
        local chest = peripheral.wrap(chestSide)
        local items = chest.list()
        
        for slot, item in pairs(items) do
            print("Slot:", slot, "Item:", item.name, "Quantidade:", item.count)
        end
    else
        print("Nenhum baú detectado no lado especificado.")
    end
end

listarItens()
