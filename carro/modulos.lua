local Modulos = {}

-- Motores
Modulos.motores = {
    padrao = { acc = 5, vel = 120, consumo = 10, potencia = 80, temperatura = 0, montado = true },
    esportivo = { acc = 10, vel = 220, consumo = 18, potencia = 200, temperatura = 0, montado = true },
    economico = { acc = 3, vel = 100, consumo = 6, potencia = 60, temperatura = 0, montado = true }
}

-- Transmissões
Modulos.transmissoes = {
    manual = { marcha = 0, tipo = "manual", montado = true },
    automatico = { marcha = 0, tipo = "automatico", montado = true },
    corrida = { marcha = 0, tipo = "corrida", montado = true }
}

-- Baterias
Modulos.baterias = {
    comum = { carga = 100, voltagem = 12, montado = true },
    potente = { carga = 150, voltagem = 14, montado = true },
    fraca = { carga = 40, voltagem = 10, montado = true }
}

-- Combustíveis
Modulos.combustiveis = {
    gasolina = { nivel = 100, tipo = "gasolina", capacidade = 50, montado = true },
    alcool = { nivel = 100, tipo = "alcool", capacidade = 45, montado = true },
    diesel = { nivel = 100, tipo = "diesel", capacidade = 60, montado = true }
}

-- Rodas
Modulos.rodas = {
    basica = {
        { id = 1, travada = false, desgaste = 0 },
        { id = 2, travada = false, desgaste = 0 },
        { id = 3, travada = false, desgaste = 0 },
        { id = 4, travada = false, desgaste = 0 },
    },
    corrida = {
        { id = 1, travada = false, desgaste = 0 },
        { id = 2, travada = false, desgaste = 0 },
        { id = 3, travada = false, desgaste = 0 },
        { id = 4, travada = false, desgaste = 0 },
    }
}

return Modulos