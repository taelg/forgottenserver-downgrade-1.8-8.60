local npc = Game.createNpcType("Gnomillion")
npc:speechBubble(SPEECHBUBBLE_TRADE)
npc:outfit({ lookType = 493, lookHead = 78, lookBody = 114, lookLegs = 79, lookFeet = 79, lookAddons = 0 })
npc:health(100)
npc:maxHealth(100)
npc:walkInterval(2000)
npc:spawnRadius(2)
npc:defaultBehavior()

local handler = NpcsHandler(npc)
local greet = handler:keyword(handler.greetWords)
greet:setGreetResponse("Olá, |PLAYERNAME|! Bem-vindo à Bololândia! Sou o Gnomillion, o banqueiro da cidade. Precisa de alguma coisa com sua {conta bancária}, ou quer {trocar} seus {chocoins}?")

local help = greet:keyword("help")
help:respond(
"Posso mostrar o {saldo} da sua conta, {depositar} dinheiro ou {sacar} ele. Você também pode {transferir} dinheiro para outros personagens, desde que tenham vocação, ou {trocar} moedas e seus {chocoins}.")

local bankAccount = greet:keyword("conta bancária", "conta", "bank account", "bank")
bankAccount:respond(
"Gostaria de saber mais sobre as funções {básicas} da sua conta, as {avançadas}, ou já está satisfeito?")

local basic = bankAccount:keyword({ "básicas", "basicas", "basic", "funções", "funcoes", "functions", "job" })
basic:respond("Eu trabalho neste banco. Posso {trocar} dinheiro para você e ajudar com a sua {conta bancária}.")

basic.keywords["saldo"] = greet.keywords["saldo"]
basic.keywords["depositar"] = greet.keywords["depositar"]
basic.keywords["sacar"] = greet.keywords["sacar"]
basic.keywords["transferir"] = greet.keywords["transferir"]
basic.keywords["trocar"] = greet.keywords["trocar"]

bankAccount.keywords["saldo"] = greet.keywords["saldo"]
bankAccount.keywords["depositar"] = greet.keywords["depositar"]
bankAccount.keywords["sacar"] = greet.keywords["sacar"]
bankAccount.keywords["transferir"] = greet.keywords["transferir"]
bankAccount.keywords["trocar"] = greet.keywords["trocar"]

local advanced = bankAccount:keyword("avançadas", "avancadas", "advanced")
advanced:respond(
"Sua conta bancária será usada automaticamente quando você quiser {alugar} uma casa ou fazer uma oferta em um item no {mercado}. Me avise se quiser saber como funciona.")

local rent = advanced:keyword("alugar", "rent")
rent:respond(
"Assim que você adquirir uma casa, o aluguel será cobrado automaticamente da sua {conta bancária} todo mês.")

local market = advanced:keyword("mercado", "market")
market:respond(
"Se você comprar um item no mercado, o ouro necessário será deduzido automaticamente da sua conta bancária. Por outro lado, o dinheiro que você ganha vendendo itens no mercado será adicionado à sua conta. Fácil!")

market.keywords["alugar"] = rent
market.keywords["rent"] = rent

-- Saldo do banco
local balance = greet:keyword("saldo", "balance")
function balance:callback(npc, player, message, handler)
    local balance = player:getBankBalance()
    if balance >= 100000000 then
        return true,
            "Acho que você deve ser um dos habitantes mais ricos do mundo! Seu saldo é de " ..
            balance .. " de ouro."
    elseif balance >= 10000000 then
        return true, "Você fez dez milhões e ainda cresce! Seu saldo é de " .. balance .. " de ouro."
    elseif balance >= 1000000 then
        return true,
            "Uau, você alcançou a marca mágica de um milhão de gp!!! Seu saldo é de " .. balance .. " de ouro!"
    elseif balance >= 100000 then
        return true, "Você certamente juntou um bom dinheiro. Seu saldo é de " .. balance .. " de ouro."
    end
    return true, "Seu saldo é de " .. balance .. " de ouro."
end

-- Depósito
local deposit = greet:keyword("depositar", "deposit")
deposit:respond("Quanto dinheiro você gostaria de depositar?")
local answer = deposit:onAnswer()
function answer:callback(npc, player, message, handler)
    local money = 0
    if message == "all" then
        money = player:getMoney()
    else
        money = tonumber(message)
    end
    local valid = isValidMoney(money)
    if valid then
        if player:getMoney() < money then
            return false, "Você não tem dinheiro suficiente para depositar " .. money .. " de ouro."
        end
        handler:addData(player, "money", money)
        return true, "Você quer depositar " .. money .. " moedas de ouro na sua conta bancária?"
    end
    return false, "Desculpe, mas você não pode depositar um valor negativo ou nenhum valor."
end

local accept = answer:keyword({ "yes", "sim" })
function accept:callback(npc, player, message, handler)
    local money = handler:getData(player, "money")
    if player:getMoney() < money then
        return false, "Você não tem dinheiro suficiente para depositar " .. money .. " de ouro."
    end
    player:depositMoney(money)
    handler:resetData(player)
    return true, "Você depositou " .. money .. " moedas de ouro na sua conta bancária."
end

local decline = answer:keyword({ "no", "não", "nao" })
decline:respond("Ok então, sem problema.")

-- Saque
local withdraw = greet:keyword("sacar", "withdraw")
withdraw:respond("Quanto dinheiro você gostaria de sacar?")
local answer = withdraw:onAnswer()
function answer:callback(npc, player, message, handler)
    local money = 0
    if message == "all" then
        money = player:getBankBalance()
    else
        money = tonumber(message)
    end
    local valid = isValidMoney(money)
    if valid then
        if player:getBankBalance() < money then
            return false, "Você não tem dinheiro suficiente no banco para sacar " .. money .. " de ouro."
        end
        if not player:canCarryMoney(money) then
            return false, "Você não consegue carregar tanto dinheiro."
        end
        handler:addData(player, "money", money)
        return true, "Você quer sacar " .. money .. " moedas de ouro da sua conta bancária?"
    end
    return false, "Desculpe, mas você não pode sacar um valor negativo ou nenhum valor."
end

local accept = answer:keyword({ "yes", "sim" })
function accept:callback(npc, player, message, handler)
    local money = handler:getData(player, "money")
    player:withdrawMoney(money)
    handler:resetData(player)
    return true, "Você sacou " .. money .. " moedas de ouro da sua conta bancária."
end

local decline = answer:keyword({ "no", "não", "nao" })
decline:respond("Ok então, sem problema.")

-- Transferência
local transfer = greet:keyword("transferir", "transfer")
transfer:respond("Você quer transferir dinheiro para outro jogador? Por favor, diga o valor e o nome do jogador.")
local answer = transfer:onAnswer()
function answer:callback(npc, player, message, handler)
    local data = string.split(message, " ")
    local money = 0
    local playerName = ""
    for i = 1, #data do
        if tonumber(data[i]) then
            money = tonumber(data[i])
        else
            playerName = playerName ~= "" and playerName .. " " .. data[i] or data[i]
        end
    end
    local receiver = Player.getPlayerDatabaseInfo(playerName)
    if not receiver then
        return false, "Não existe ninguém com o nome " .. playerName
    end
    if receiver.vocation == VOCATION_NONE or player:getVocation() == VOCATION_NONE then
        return false, "Você não pode transferir dinheiro para ou de um jogador sem vocação."
    end
    if receiver.name == player:getName() then
        return false, "Você não pode transferir dinheiro para você mesmo."
    end
    if not isValidMoney(money) then
        return false, "Você não pode transferir um valor negativo ou nenhum valor."
    end
    if player:getBankBalance() < money then
        return false, "Você não tem dinheiro suficiente no banco para transferir " .. money .. " de ouro para " .. playerName
    end
    handler:addData(player, "money", money)
    handler:addData(player, "playerName", playerName)
    return true, "Você quer transferir " .. money .. " moedas de ouro para " .. playerName .. "?"
end

local accept = answer:keyword({ "yes", "sim" })
function accept:callback(npc, player, message, handler)
    local money = handler:getData(player, "money")
    local playerName = handler:getData(player, "playerName")
    local receiver = Player.getPlayerDatabaseInfo(playerName)
    if not player:transferMoneyTo(receiver, money) then
        return false, "Você não tem dinheiro suficiente no banco para transferir " .. money .. " de ouro para " .. playerName
    end
    handler:resetData(player)
    return true, "Você transferiu " .. money .. " moedas de ouro para " .. playerName
end

local decline = answer:keyword({ "no", "não", "nao" })
decline:respond("Ok então, sem problema.")

-- Troca de moedas (ouro/platina/cristal) e chocoin
local change = greet:keyword("trocar", "troca", "change")
change:respond(
"Gostaria de trocar suas moedas? Você pode trocar seus chocoins nas maquinas aqui ao meu lado, leia as placas para saber usar.")

-- Ouro -> Platina
local gold = change:keyword("ouro", "gold")
gold:respond("Quantas moedas de platina você gostaria de receber?")
local answer = gold:onAnswer()
function answer:callback(npc, player, message, handler)
    local money = tonumber(message) * 100
    local valid = isValidMoney(money)
    if valid then
        if player:getItemCount(ITEM_GOLD_COIN) < money then
            return false,
                "Você não tem ouro suficiente para trocar " .. money .. " moedas de ouro em " .. message ..
                " moedas de platina."
        end
        handler:addData(player, "money", money)
        return true, "Você quer trocar " .. money .. " moedas de ouro em " .. message .. " moedas de platina?"
    end
    return false, "Desculpe, mas você não pode trocar um valor negativo ou nenhum valor."
end

local accept = answer:keyword({ "yes", "sim" })
function accept:callback(npc, player, message, handler)
    local money = handler:getData(player, "money")
    if not player:removeItem(ITEM_GOLD_COIN, money) then
        return false,
            "Você não tem ouro suficiente para trocar " ..
            money .. " moedas de ouro em " .. math.floor(money / 100) .. " moedas de platina."
    end
    player:addItem(ITEM_PLATINUM_COIN, math.floor(money / 100))
    handler:resetData(player)
    return true, "Você trocou " .. money .. " moedas de ouro em " .. math.floor(money / 100) .. " moedas de platina."
end

local decline = answer:keyword({ "no", "não", "nao" })
decline:respond("Ok então, sem problema.")

-- Platina -> Ouro / Cristal
local platinum = change:keyword("platina", "platinum")
platinum:respond(
"Você quer trocar suas moedas de platina em {ouro}, ou gostaria de trocá-las em {cristal}?")
local gold = platinum:keyword("ouro", "gold")
gold:respond("Quantas moedas de ouro você gostaria de receber?")
local answer = gold:onAnswer()
function answer:callback(npc, player, message, handler)
    local money = tonumber(message)
    local valid = isValidMoney(money)
    if valid then
        if player:getItemCount(ITEM_PLATINUM_COIN) * 100 < money then
            return false, "Você não tem platina suficiente para trocar em " .. money .. " moedas de ouro."
        end
        handler:addData(player, "money", money)
        return true, "Você quer trocar " .. money / 100 .. " moedas de platina em " .. money .. " moedas de ouro?"
    end
    return false, "Desculpe, mas você não pode trocar um valor negativo ou nenhum valor."
end

local accept = answer:keyword({ "yes", "sim" })
function accept:callback(npc, player, message, handler)
    local money = handler:getData(player, "money")
    if not player:removeItem(ITEM_PLATINUM_COIN, math.floor(money / 100)) then
        return false,
            "Você não tem platina suficiente para trocar " ..
            money / 100 .. " moedas de platina em " .. money .. " moedas de ouro."
    end
    player:addItem(ITEM_GOLD_COIN, money)
    handler:resetData(player)
    return true, "Você trocou " .. money / 100 .. " moedas de platina em " .. money .. " moedas de ouro."
end

local decline = answer:keyword({ "no", "não", "nao" })
decline:respond("Ok então, sem problema.")

-- Platina -> Cristal
local crystal = platinum:keyword("cristal", "crystal")
crystal:respond("Quantas moedas de cristal você gostaria de receber?")
local answer = crystal:onAnswer()
function answer:callback(npc, player, message, handler)
    local money = tonumber(message)
    local valid = isValidMoney(money)
    if valid then
        if player:getItemCount(ITEM_PLATINUM_COIN) * 100 < money * 10000 then
            return false, "Você não tem platina suficiente para trocar em " .. money .. " moedas de cristal."
        end
        handler:addData(player, "money", money)
        return true, "Você quer trocar " .. money * 100 .. " moedas de platina em " .. money .. " moedas de cristal?"
    end
    return false, "Desculpe, mas você não pode trocar um valor negativo ou nenhum valor."
end

local accept = answer:keyword({ "yes", "sim" })
function accept:callback(npc, player, message, handler)
    local money = handler:getData(player, "money")
    if not player:removeItem(ITEM_PLATINUM_COIN, math.floor(money * 100)) then
        return false,
            "Você não tem platina suficiente para trocar " ..
            money * 100 .. " moedas de platina em " .. money .. " moedas de cristal."
    end
    player:addItem(ITEM_CRYSTAL_COIN, money)
    handler:resetData(player)
    return true, "Você trocou " .. money * 100 .. " moedas de platina em " .. money .. " moedas de cristal."
end

local decline = answer:keyword({ "no", "não", "nao" })
decline:respond("Ok então, sem problema.")

-- Cristal -> Platina
local crystal = change:keyword("cristal", "crystal")
crystal:respond("Quantas moedas de platina você gostaria de receber?")
local answer = crystal:onAnswer()
function answer:callback(npc, player, message, handler)
    local money = tonumber(message)
    local valid = isValidMoney(money)
    if valid then
        if player:getItemCount(ITEM_CRYSTAL_COIN) * 10000 < money * 100 then
            return false, "Você não tem cristal suficiente para trocar em " .. money .. " moedas de platina."
        end
        handler:addData(player, "money", money)
        return true, "Você quer trocar " .. money / 100 .. " moedas de cristal em " .. money .. " moedas de platina?"
    end
    return false, "Desculpe, mas você não pode trocar um valor negativo ou nenhum valor."
end

local accept = answer:keyword({ "yes", "sim" })
function accept:callback(npc, player, message, handler)
    local money = handler:getData(player, "money") -- platina desejada
    if not player:removeItem(ITEM_CRYSTAL_COIN, math.floor(money / 100)) then
        return false,
            "Você não tem cristal suficiente para trocar " ..
            money / 100 .. " moedas de cristal em " .. money .. " moedas de platina."
    end
    player:addItem(ITEM_PLATINUM_COIN, money)
    handler:resetData(player)
    return true, "Você trocou " .. money / 100 .. " moedas de cristal em " .. money .. " moedas de platina."
end

local decline = answer:keyword({ "no", "não", "nao" })
decline:respond("Ok então, sem problema.")

------------------------------------------------------------------------
-- Troca de Chocoin (10x diluído 48249 <-> 1x puro 48250)
------------------------------------------------------------------------
local DILUTED_CHOCOIN = 48249 -- chocoin diluido
local PURE_CHOCOIN = 48250    -- chocoin puro (vale 10x mais)

local chocoin = change:keyword("chocoin", "choco", "chocolate coin")
chocoin:respond("O {chocoin puro} vale 10x mais que o {chocoin diluído}. Posso trocar 10 chocoins diluídos em 1 puro, ou 1 puro em 10 diluídos. O que você prefere?")

-- Diluído -> Puro (10x 48249 -> 1x 48250)
local dilutedToPure = chocoin:keyword("diluído", "diluido", "diluted", "10")
dilutedToPure:respond("Então você quer trocar 10 chocoins diluídos em 1 chocoin puro?")
local yes = dilutedToPure:keyword({ "yes", "sim" })
function yes:callback(npc, player, message, handler)
    if player:getItemCount(DILUTED_CHOCOIN) < 10 then
        return true, "Você não tem 10 chocoins diluídos. Vá minerar um pouco mais, |PLAYERNAME|!"
    end
    if not player:removeItem(DILUTED_CHOCOIN, 10) then
        return true, "Você não tem 10 chocoins diluídos para trocar."
    end
    player:addItem(PURE_CHOCOIN, 1)
    return true, "Fechado! Aqui está o seu chocoin puro em troca dos 10 diluídos."
end
local no = dilutedToPure:keyword({ "no", "não", "nao" })
no:respond("Ok então, me avise se mudar de ideia.")

-- Puro -> Diluído (1x 48250 -> 10x 48249)
local pureToDiluted = chocoin:keyword("puro", "pure", "1")
pureToDiluted:respond("Então você quer trocar 1 chocoin puro em 10 chocoins diluídos?")
local yes2 = pureToDiluted:keyword({ "yes", "sim" })
function yes2:callback(npc, player, message, handler)
    if player:getItemCount(PURE_CHOCOIN) < 1 then
        return true, "Você não tem um chocoin puro para trocar."
    end
    if not player:removeItem(PURE_CHOCOIN, 1) then
        return true, "Você não tem um chocoin puro para trocar."
    end
    player:addItem(DILUTED_CHOCOIN, 10)
    return true, "Aqui estão seus 10 chocoins diluídos, aproveite!"
end
local no2 = pureToDiluted:keyword({ "no", "não", "nao" })
no2:respond("Ok então, me avise se mudar de ideia.")

--------------------------------------------------------------------------------
-- Transferência / depósito / saque rápido
--------------------------------------------------------------------------------
local fast = greet:onAnswer()
function fast:callback(npc, player, message, handler)
    local transfer = string.find(message, "transfer")
    if transfer then
        local msg = string.gsub(message, "transfer ", "")
        local data = string.split(msg, " ")
        local money = 0
        local playerName = ""
        for i = 1, #data do
            if tonumber(data[i]) then
                money = tonumber(data[i])
            else
                playerName = playerName ~= "" and playerName .. " " .. data[i] or data[i]
            end
        end
        local receiver = Player.getPlayerDatabaseInfo(playerName)
        if not receiver then
            return false, "Não existe ninguém com o nome '" .. playerName .. "'"
        end
        if receiver.name == player:getName() then
            return false, "Você não pode transferir dinheiro para você mesmo."
        end
        if receiver.vocation == VOCATION_NONE or player:getVocation() == VOCATION_NONE then
            return false, "Você não pode transferir dinheiro para ou de um jogador sem vocação."
        end
        if not isValidMoney(money) then
            return false, "Você não pode transferir um valor negativo ou nenhum valor."
        end
        if player:getBankBalance() < money then
            return false, "Você não tem dinheiro suficiente no banco para transferir " .. money .. " de ouro para " .. playerName
        end
        handler:addData(player, "money", money)
        handler:addData(player, "playerName", playerName)
        handler:addData(player, "type", "transfer")
        return true, "Você quer transferir " .. money .. " moedas de ouro para " .. playerName .. "?"
    end

    local deposit = string.find(message, "deposit")
    if deposit then
        local sub = string.gsub(message, "deposit ", "")
        local money = 0
        if sub == "all" then
            money = player:getMoney()
        else
            money = tonumber(sub)
        end
        local valid = isValidMoney(money)
        if valid then
            if player:getMoney() < money then
                return false, "Você não tem dinheiro suficiente para depositar " .. money .. " de ouro."
            end
            handler:addData(player, "money", money)
            handler:addData(player, "type", "deposit")
            return true, "Você quer depositar " .. money .. " moedas de ouro na sua conta bancária?"
        end
        return false, "Desculpe, você não pode depositar um valor negativo ou nenhum valor."
    end

    local withdraw = string.find(message, "withdraw")
    if withdraw then
        local sub = string.gsub(message, "withdraw ", "")
        local money = 0
        if sub == "all" then
            money = player:getBankBalance()
        else
            money = tonumber(sub)
        end
        local valid = isValidMoney(money)
        if valid then
            if player:getBankBalance() < money then
                return false, "Você não tem dinheiro suficiente no banco para sacar " .. money .. " de ouro."
            end
            if not player:canCarryMoney(money) then
                return false, "Você não consegue carregar tanto dinheiro."
            end
            handler:addData(player, "money", money)
            handler:addData(player, "type", "withdraw")
            return true, "Você quer sacar " .. money .. " moedas de ouro da sua conta bancária?"
        end
        return false, "Desculpe, você não pode sacar um valor negativo ou nenhum valor."
    end
    return false
end

fast.failureResponse = "Não entendi o que você quer dizer. Quer {depositar}, {sacar}, {transferir} ou {trocar} algo?"

local accept = fast:keyword({ "yes", "sim" })
function accept:callback(npc, player, message, handler)
    local money = handler:getData(player, "money")
    local playerName = handler:getData(player, "playerName")
    local receiver = Player.getPlayerDatabaseInfo(playerName)
    local type = handler:getData(player, "type")
    if type == "transfer" then
        if not player:transferMoneyTo(receiver, money) then
            return false, "Você não tem dinheiro suficiente no banco para transferir " .. money .. " de ouro para " .. playerName
        end
        handler:resetData(player)
        return true, "Você transferiu " .. money .. " moedas de ouro para " .. playerName
    elseif type == "deposit" then
        if player:getMoney() < money then
            return false, "Você não tem dinheiro suficiente para depositar " .. money .. " de ouro."
        end
        player:depositMoney(money)
        handler:resetData(player)
        return true, "Você depositou " .. money .. " moedas de ouro na sua conta bancária."
    elseif type == "withdraw" then
        player:withdrawMoney(money)
        handler:resetData(player)
        return true, "Você sacou " .. money .. " moedas de ouro da sua conta bancária."
    end
    return false, "Algo deu errado, tente novamente."
end

local decline = fast:keyword({ "no", "não", "nao" })
decline:respond("Ok então.")