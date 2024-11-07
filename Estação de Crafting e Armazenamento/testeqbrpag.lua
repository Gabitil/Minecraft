local printer = peripheral.find("printer")

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

-- Exemplo de uso
printer.newPage()
printer.setPageTitle("Teste de Impressão com Quebra e Palavra Completa")

local texto_teste = "Este é um exemplo de texto muito longo que precisa quebrar as linhas automaticamente sem dividir palavras ao meio. O texto deve ser organizado em várias páginas, se necessário, então vou ficar aqui digitando qualquer coisa ate eu ficar enjoado, então, a vida é complicada, somente os poderosos tem o direito de viver o resto só existe, estão a merce do capitalismo e das suas vontades, como viver de verdade em um mundo em que o consumismo é forçado na sua guela, tudo tem um preço até mesmo a sua vida."
print_line(texto_teste)

printer.endPage()
