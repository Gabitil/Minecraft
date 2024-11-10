-- Função para fazer a solicitação JSON
local function requisitarAPI(url)
    local resposta, erro = http.get(url)

    if resposta then
        local conteudo = resposta.readAll()
        resposta.close()
        return textutils.unserializeJSON(conteudo)
    else
        print("Erro ao acessar a API: " .. (erro or ""))
        return nil
    end
end

-- Exibe os dados da API no monitor
local function exibirDadosMonitor(dados)
    monitor.clear()
    monitor.setCursorPos(1, 1)

    if dados then
        monitor.write("Servidor: " .. (dados.nome or "Desconhecido"))
        monitor.setCursorPos(1, 2)
        monitor.write("Status: " .. (dados.status or "Indisponível"))
    else
        monitor.write("Erro ao acessar dados da API.")
    end
end

-- Chamada para exibir status
local urlAPI = "https://api.exemplo.com/status"
local dadosServidor = requisitarAPI(urlAPI)
exibirDadosMonitor(dadosServidor)
