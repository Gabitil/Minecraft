local printer = peripheral.find("printer")

local page_limit = 25  -- Número máximo de linhas por página, ajuste conforme necessário
local line_length = 20 -- Limite de caracteres por linha
local line_count = 1   -- Contador de linhas para cada página

-- Função para checar e ajustar quebra de linha e página
local function print_line(text)
    -- Quebra o texto em várias linhas se ultrapassar o comprimento máximo
    while #text > line_length do
        printer.write(text:sub(1, line_length))  -- Escreve a linha no limite
        text = text:sub(line_length + 1)         -- Remove a parte impressa do texto
        line_count = line_count + 1
        if line_count > page_limit then
            printer.endPage()
            printer.newPage()
            printer.setPageTitle("Nova Página")
            line_count = 1
        end
        printer.setCursorPos(1, line_count)
    end

    -- Imprime o restante do texto
    printer.write(text)
    line_count = line_count + 1
    if line_count > page_limit then
        printer.endPage()
        printer.newPage()
        printer.setPageTitle("Nova Página")
        line_count = 1
    end
    printer.setCursorPos(1, line_count)
end

-- Exemplo de uso com textos longos
printer.newPage()
printer.setPageTitle("Teste de Impressão com Quebra")

local texto_teste = "Exemplo de texto muito longo que precisa quebrar a linha automaticamente quando atinge o limite da página. O texto deve ser organizado em várias páginas, se necessário."
print_line(texto_teste)

printer.endPage()
