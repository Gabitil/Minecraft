-- Tabela para armazenar os baus
local printer = peripheral.find("printer")
local chests = {}
-- Verifica se a impressora foi encontrada
if not printer then
    error("Nenhuma impressora foi encontrada.")
end

-- Configurações de impressão
local page_limit = 25  -- Número máximo de linhas por página
local line_length = 20 -- Limite de caracteres por linha
local line_count = 1   -- Contador de linhas por página

-- Função para checar e ajustar a quebra de linha e página com controle de palavras
local function print_line(text)
    local words = {} -- Tabela para armazenar palavras

    -- Divide o texto em palavras usando espaço como separador
    for word in text:gmatch("%S+") do
        table.insert(words, word)
    end

    local line_text = ""  -- Texto acumulado para a linha atual

    for _, word in ipairs(words) do
        -- Se adicionar a palavra à linha atual ultrapassar o limite, imprime a linha e começa uma nova
        if #line_text + #word + 1 > line_length then
            printer.write(line_text)  -- Escreve a linha atual
            line_count = line_count + 1
            
            -- Verifica se a página atingiu o limite de linhas
            if line_count > page_limit then
                printer.endPage()
                printer.newPage()
                printer.setPageTitle("Nova Página")
                line_count = 1
            end
            
            -- Configura o cursor para a próxima linha e inicia uma nova linha
            printer.setCursorPos(1, line_count)
            line_text = word -- Reinicia com a palavra atual
        else
            -- Adiciona a palavra à linha atual com um espaço, se não estiver vazia
            if #line_text > 0 then
                line_text = line_text .. " " .. word
            else
                line_text = word
            end
        end
    end

    -- Imprime qualquer conteúdo restante em `line_text`
    if #line_text > 0 then
        printer.write(line_text)
        line_count = line_count + 1

        -- Verifica se precisa de uma nova página
        if line_count > page_limit then
            printer.endPage()
            printer.newPage()
            printer.setPageTitle("Nova Página")
            line_count = 1
        end
        printer.setCursorPos(1, line_count)
    end
end


-- Procura por perifericos do tipo "minecraft:chest" e adiciona cada um à tabela 'chests'
printer.newPage()
for _, name in ipairs(peripheral.getNames()) do -- 'ipairs' retorna uma tabela com os indices e valores da tabela 'peripheral.getNames()'
    if peripheral.hasType(name, "minecraft:chest") then
        table.insert(chests, peripheral.wrap(name))
       
        print_line("resultado wrap", chests)


    end
end

-- Exemplo: acessando itens de todos os baús
for i, chest in ipairs(chests) do

    print_line("Bau " .. i .. ":")
    local items = chest.list()
    for slot, item in pairs(items) do -- 'pairs' retorna uma tabela com os indices e valores da tabela 'items' asfdasfasfasdas
        print_line("Slot " .. slot .. ": " .. item.name .. " x" .. item.count)
    end


end
printer.endPage()
