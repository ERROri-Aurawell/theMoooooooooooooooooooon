local Modulos = require("modulos")

local Carro = {
    ligado = false,
    motor = { acc = 0, vel = 0, consumo = 0, potencia = 0, temperatura = 0, montado = false },
    roda = {
        { id = 1, travada = false, desgaste = 0 },
        { id = 2, travada = false, desgaste = 0 },
        { id = 3, travada = false, desgaste = 0 },
        { id = 4, travada = false, desgaste = 0 },
    },
    banco = { id = 0, travado = false, ocupado = false },
    radiador = { resf = 0, vel = 0, temperatura = 0 },

    combustivel = { nivel = 0, tipo = "", capacidade = 0, montado = false },
    freio = { estado = "ok", pressao = 0 },
    transmissao = { marcha = 0, tipo = "manual", montado = false },
    bateria = { carga = 0, voltagem = 0, montado = false },
    painel = { farol = false, velocimetro = 0, rpm = 0 },
    portas = {
        { id = 1, trancada = false },
        { id = 2, trancada = false },
        { id = 3, trancada = false },
        { id = 4, trancada = false },
    },
    manivela = false,
    velocidade = 0
}

--Motor, transmissão, {bateria ou manivela}, sem isso o carro nem liga

-- Liga o carro
function Ligar(carro)
    if not carro.motor.montado then
        print("Sem motor!")
        return
    end
    if not carro.transmissao.montado then
        print("Sem transmissão!")
        return
    end
    if not carro.bateria.montado and not carro.manivela then
        print("Sem bateria e sem manivela!")
        return
    end
    if carro.combustivel.nivel <= 0 then
        print("Sem combustível!")
        return
    end

    carro.ligado = true
    print("Carro ligado 🚗💨")
end

-- Função para trocar parte do carro
function TrocarParte(carro, parte, modulo)
    if carro[parte] ~= nil then
        carro[parte] = modulo
        print(parte .. " substituído com sucesso!")
    else
        print("Parte '" .. parte .. "' não existe no carro!")
    end
end

function Esperar(segundos)
    if package.config:sub(1, 1) == "\\" then
        -- Windows
        os.execute("timeout /t " .. segundos .. " >nul")
    else
        -- Linux/Mac
        os.execute("sleep " .. segundos)
    end
end

function Main()
    while Carro.ligado do
        -- Consome combustível
        Carro.combustivel.nivel = Carro.combustivel.nivel - (Carro.motor.consumo * 0.1)

        -- Aumenta desgaste das rodas
        for _, roda in ipairs(Carro.roda) do
            roda.desgaste = roda.desgaste + 0.01
        end

        -- Simula velocidade
        Carro.velocidade = math.min(Carro.velocidade + Carro.motor.acc, Carro.motor.vel)

        -- Se acabar combustível → desliga
        if Carro.combustivel.nivel <= 0 then
            print("O carro ficou sem combustível!")
            Desligar(Carro)
        end
        
        -- Mostra status
        print("Velocidade:", Carro.velocidade, "km/h | Combustível:", Carro.combustivel.nivel)

        -- Pausa pequena pra não travar (simulação)
        Esperar(1)
    end
end

function Desligar(carro)
    carro.ligado = false
    print("Carro desligado ❌")
end

function Abastecer(carro, qtt, tipo)
    if not carro.combustivel.montado then
        print("Tanque não montado!")
        return
    end

    if qtt <= 0 then
        print("Quantidade inválida!")
        return
    end

    local capacidade = carro.combustivel.capacidade
    local nivelAtual = carro.combustivel.nivel
    local novoNivel = nivelAtual + qtt

    if novoNivel > capacidade then
        carro.combustivel.nivel = capacidade
        print("Tanque cheio! (+" .. (capacidade - nivelAtual) .. "L)")
    else
        carro.combustivel.nivel = novoNivel
        print("Abastecido +" .. qtt .. "L | Nível atual: " .. carro.combustivel.nivel .. "L")
    end
end

TrocarParte(Carro, "motor", Modulos.motores.esportivo);
TrocarParte(Carro, "transmissao", Modulos.transmissoes.automatico);
TrocarParte(Carro, "manivela", true)
TrocarParte(Carro, "combustivel", Modulos.combustiveis.alcool)
Abastecer(Carro, 20, "alcool");
Ligar(Carro)
Main()
