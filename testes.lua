Rodando = true;
PontosColocar = 25;
Rodada = 0;
PontosColocados = false;
InimigoVidaAparente = 0;
InimigoVidaMaxima = nil;

InimigoAtual = {
    nome = "",
    vida = 0,
    dano = 0,
    vivo = false,
};
--Lembrete: Não usar caracteces especiais, ele quebra no terminal
--Lembrete2: Não usar acentos, ele quebra no terminal

Humano = {
    nome = "",
    vida = 0,
    dano = 0,
    escudo = 0,
    escudoAtual = 0,
    regenEscudoEm = 0,
    acumulos = 0,
    curaCooldown = false,
    cooldownEm = 0,
}

InimigosT1 = {
    { nome = "Goblin", vida = 25, dano = 5, vivo = true }, -- Balanceado, bom inimigo inicial
    { nome = "Orc",    vida = 35, dano = 6, vivo = true }, -- Mais resistente, menos "vidro"
    { nome = "Troll",  vida = 50, dano = 4, vivo = true }, -- Tanque do T1, mas com dano relevante
}
InimigosT2 = {
    { nome = "Lobo",    vida = 40, dano = 8,  vivo = true }, -- Um bom avanco do T1
    { nome = "Urso",    vida = 65, dano = 11, vivo = true }, -- Forte, mas menos punitivo
    { nome = "Pantera", vida = 55, dano = 16, vivo = true }, -- Rapida e mortal, mas mais fragil
}
InimigosT3 = {
    { nome = "Esqueleto", vida = 80,  dano = 14, vivo = true }, -- Um desafio solido para o T3
    { nome = "Zumbi",     vida = 120, dano = 12, vivo = true }, -- Um verdadeiro tanque, muita vida
    { nome = "Vampiro",   vida = 100, dano = 19, vivo = true }, -- Inimigo final, poderoso mas vencivel
}

function CopiarTabela(orig)
    local copia = {}
    for k, v in pairs(orig) do
        if type(v) == "table" then
            copia[k] = CopiarTabela(v)
        else
            copia[k] = v
        end
    end
    return copia
end

function GerarInimigo()
    if Rodada <= 7 then
        InimigoAtual = CopiarTabela(InimigosT1[math.random(#InimigosT1)]);
    elseif Rodada <= 14 then
        InimigoAtual = CopiarTabela(InimigosT2[math.random(#InimigosT2)]);
    else
        InimigoAtual = CopiarTabela(InimigosT3[math.random(#InimigosT3)]);
    end
    InimigoVidaMaxima = InimigoAtual.vida;
    print("Um " .. InimigoAtual.nome .. " apareceu!");
end

function Humano:tomarDano(dano)
    local escudoAbsorvido = math.min(self.escudoAtual, dano)
    self.escudoAtual = self.escudoAtual - escudoAbsorvido
    local danoRestante = dano - escudoAbsorvido
    if self.escudoAtual <= 0 then
        self.escudoAtual = 0
    end
    if self.regenEscudoEm == 0 and self.escudo ~= self.escudoAtual then
        self.regenEscudoEm = Rodada + 5;
    end
    self.vida = self.vida - danoRestante
    if escudoAbsorvido > 0 then
        print("Seu escudo absorveu parte do dano! Escudo restante: " .. self.escudoAtual .. "/" .. self.escudo)
    end
    if self.vida <= 0 then
        print("")
        print("Voce morreu! Fim de jogo.")
        Rodando = false
    else
        print("O inimigo te atacou! Voce tomou " .. danoRestante .. " de dano.")
    end
end

function Humano:curar()
    if self.curaCooldown == false then
        self.vida = self.vida + 10
        self.curaCooldown = true
        self.cooldownEm = Rodada + 3
    else
        print("Cura em cooldown!");
    end
end

function Humano:upar()
    local function lerNumero(mensagem)
        while true do
            print(mensagem)
            local entrada = io.read()
            local numero = tonumber(entrada)
            if numero == nil then
                print("Digite um numero valido.")
            elseif numero < 0 then
                print("Digite um numero positivo.")
            else
                return numero
            end
        end
    end
    local ok, result = pcall(function()
        while not PontosColocados do
            local vida = lerNumero("Digite os pontos em Vida: ")
            local dano = lerNumero("Digite os pontos em Dano: ")
            local escudo = lerNumero("Digite os pontos em Escudo: ")
            if vida + dano + escudo > PontosColocar then
                print("Mais pontos do que o permitido. Tente novamente.");
            else
                Humano.vida = vida + Humano.vida;
                Humano.dano = dano + Humano.dano;
                Humano.escudo = escudo + Humano.escudo;
                Humano.escudoAtual = Humano.escudoAtual + escudo;
                PontosColocados = true;
            end
        end
    end)
    if not ok then
        print("Erro ao colocar pontos, tente novamente.");
    end
end

function CalcVidaAparente()
    --A cada rodada, mostra apenas a vida aparente do inimigo
    local calculo = InimigoAtual.vida / InimigoVidaMaxima * 100;
    InimigoVidaAparente = math.floor(calculo);
end

function ColocarPontos()
    local function lerNumero(mensagem)
        while true do
            print(mensagem)
            local entrada = io.read()
            local numero = tonumber(entrada)
            if numero == nil then
                print("Digite um numero valido.")
            elseif numero < 0 then
                print("Digite um numero positivo.")
            else
                return numero
            end
        end
    end

    local ok, result = pcall(function()
        while not PontosColocados do
            local vida = lerNumero("Digite os pontos em Vida: ")
            local dano = lerNumero("Digite os pontos em Dano: ")
            local escudo = lerNumero("Digite os pontos em Escudo: ")
            if vida + dano + escudo > PontosColocar then
                print("Mais pontos do que o permitido. Tente novamente.");
            else
                Humano.vida = vida;
                Humano.dano = dano;
                Humano.escudo = escudo;
                Humano.escudoAtual = escudo;
                PontosColocados = true;
            end
        end
    end)
    if not ok then
        print("Erro ao colocar pontos, tente novamente.");
    end
end

function Start()
    print("Bem vindo ao RPG de terminal!");
    print("Qual o seu nome?")
    local nome = io.read();
    Humano.nome = nome;
    ColocarPontos();

    while Rodando do
        print("-----------------------------");
        if InimigoAtual.vivo == false then
            GerarInimigo();
        end
        Rodada = Rodada + 1;
        if Humano.curaCooldown and Rodada >= Humano.cooldownEm then
            Humano.curaCooldown = false;
            print("");
            print("Sua cura está pronta para uso novamente!");
        end
        if Rodada >= Humano.regenEscudoEm and Humano.regenEscudoEm ~= 0 then
            Humano.regenEscudoEm = 0;
            Humano.escudoAtual = Humano.escudo;
            print("");
            print("Seu escudo foi restaurado!");
        end
        Menu();
        if InimigoAtual.vivo then
            print("");
            print("Isso e um jogo de turnos, entao ele ataca depois de voce");
            Humano:tomarDano(InimigoAtual.dano);
        else
            print("");
            print("O inimigo esta morto, ele não pode atacar.");
        end
    end
end

function Humano:atacar()
    print("1- Ataque normal (100% de dano)");
    print("2- Ataque forte (250% de dano, 15% de chance de errar)");
    print("3 - Ataque pesado (300% do dano) - Requer 1 Acumulo ");; if Humano.acumulos > 0 then
        print("Voce tem " .. Humano.acumulos .. " acumulo(s) para usar ataques pesados.");
    end
    local escolha = io.read();
    if escolha == "2" then
        if math.random(100) <= 15 then
            print("Seu ataque forte errou!");
            return;
        else
            local danoForte = math.floor(Humano.dano * 2.5);
            print("Voce usou um ataque forte! Dando... " .. danoForte .. " de dano.");
            InimigoAtual.vida = InimigoAtual.vida - (danoForte - Humano.dano);
        end
    elseif escolha == "3" then
        if Humano.acumulos > 0 then
            local danoPesado = math.floor(Humano.dano * 3);
            print("Voce usou um ataque pesado! Dando... " .. danoPesado .. " de dano.");
            InimigoAtual.vida = InimigoAtual.vida - (danoPesado - Humano.dano);
            Humano.acumulos = Humano.acumulos - 1;
        else
            print("Voce nao tem acumulos suficientes para usar ataque pesado. Usando ataque normal.");
            print("Voce atacou o " .. InimigoAtual.nome .. "! Dando... " .. Humano.dano .. " de dano.");
            InimigoAtual.vida = InimigoAtual.vida - Humano.dano;
            if Humano.acumulos < 5 then
                Humano.acumulos = Humano.acumulos + 1;
            end
        end
    elseif escolha == "1" then
        print("Voce atacou o " .. InimigoAtual.nome .. "! Dando... " .. Humano.dano .. " de dano.");
        InimigoAtual.vida = InimigoAtual.vida - Humano.dano;
        if Humano.acumulos < 5 then
            Humano.acumulos = Humano.acumulos + 1;
        end
    else
        print("Escolha inválida, usando ataque normal.");
        print("Voce atacou o " .. InimigoAtual.nome .. "! Dando... " .. Humano.dano .. " de dano.");
        InimigoAtual.vida = InimigoAtual.vida - Humano.dano
        if Humano.acumulos < 5 then
            Humano.acumulos = Humano.acumulos + 1;
        end
    end

    if InimigoAtual.vida <= 0 then
        InimigoAtual.vivo = false;

        print("");
        print("Você derrotou o " .. InimigoAtual.nome .. "!");
        PontosColocados = false;
        PontosColocar = Rodada + 6;
        print("Você tem " .. PontosColocar .. " pontos para distribuir.");
        Humano:upar();
    end
end

function Status()
    --Se o usuário vai perder uma rodada, pelo menos que ele veja o status do inimigo
    print("Inimigo: ");
    print("Nome: " .. InimigoAtual.nome);
    print("Vida: " .. InimigoAtual.vida);
    print("Dano: " .. InimigoAtual.dano);
end

function Menu()
    print("Voce: ");
    print("Nome: " .. Humano.nome);
    print("Vida: " .. Humano.vida);
    print("Dano: " .. Humano.dano);
    print("Escudo: " .. Humano.escudoAtual .. "/" .. Humano.escudo);
    print("Acumulos: " .. Humano.acumulos);
    print("");
    print("Inimigo: ");
    print("Nome: " .. InimigoAtual.nome);
    CalcVidaAparente();
    print("Vida: " .. InimigoVidaAparente .. "%");
    print("1 - Atacar", "2 - Curar", "3 - Status Inimigo", "4 - Sair do jogo");

    local escolha = tonumber(io.read());
    if escolha == 1 then
        Humano:atacar();
    elseif escolha == 2 then
        Humano:curar();
    elseif escolha == 3 then
        Status()
    elseif escolha == 4 then
        Rodando = false;
    else
        print("Escolha inválida, tente novamente.")
        Menu();
    end
end

Start();
