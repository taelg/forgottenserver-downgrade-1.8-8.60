local chocolateExtractor = Action()

-- ============================================================
-- LISTA DE RECOMPENSAS (sorteio de 1 item por rodada)
-- A soma de todas as "chance" DEVE ser 1000 (1000 = 100%)
-- Formato: { itemId = X, count = Y, chance = Z }
-- ============================================================
local rewardTable = {         -- totalizar 1k a chance
	{ itemId = 3031, count = 1, chance = 939 }, -- x%    1x gold coin
	{ itemId = 3590, count = 5, chance = 50 }, --   5%    5x cherry

	{ itemId = 3552, count = 1, chance = 10 }, --  1%    bota de couro (vende por 25gp ao lado)

	{ itemId = 48250, count = 10, chance = 1 }, -- 1/1k   10x chocoins

}

-- ============================================================
-- VALIDACAO DE CHANCES (roda 1x no startup do servidor)
-- O script só é carregado uma vez no startup, então esse
-- codigo roda 1x apenas. Precisa vir DEPOIS da rewardTable.
-- ============================================================
local totalChance = 0
for _, reward in ipairs(rewardTable) do
	totalChance = totalChance + reward.chance
end
if totalChance ~= 1000 then
	logError("[TONTA - ERROR] chocolate_extractor.lua: a soma das chances deve ser exatamente 1000. Valor atual: " .. totalChance .. ".")
end

local function rollReward()
	local roll = math.random(1, 1000)
	local cumulative = 0
	for _, reward in ipairs(rewardTable) do
		cumulative = cumulative + reward.chance
		if roll <= cumulative then
			return reward
		end
	end
	-- fallback seguro (nunca deve acontecer se as chances somam 1000)
	return rewardTable[1]
end

-- Verifica se o jogador tem slot livre na mochila e cap livre para carregar a recompensa.
-- Parametros:
--   player     - o jogador
--   itemWeight - peso total da recompensa, em oz (gramas brutas / 100)
--   message    - (opcional) mensagem de contexto (mantida por compatibilidade)
-- Retorna true se tiver espaco, false caso contrario.
function checkWeightAndBackpackRoom(player, itemWeight, message)
	if not player then
		return false
	end

	-- getFreeCapacity() retorna a capacidade livre em centesimos de oz,
	-- entao multiplicamos o peso (em oz) por 100 para comparar.
	if player:getFreeCapacity() < itemWeight * 100 then
		return false
	end

	-- Verifica se ha slot livre na mochila principal.
	local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
	if not backpack or backpack:getEmptySlots(true) < 1 then
		return false
	end

	return true
end

function chocolateExtractor.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	-- Tenta remover 1x chocoin puro (id: 48250); se nao removeu,
	-- tenta remover 10x chocoin diluido (id: 48249)
    local playerPaidInPureCoin = nil
	if player:removeItem(48250, 1) then
        playerPaidInPureCoin = true -- removeu, roda a maquina
	elseif player:removeItem(48249, 10) then
		playerPaidInPureCoin = false -- removeu, roda a maquina
	else
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "Você precisa de chocolate coins para usar a maquina (10x diluidos ou 1x puros)")
		return true
	end

	-- Ao rodar a maquina: efeito magico no pe do jogador
	item:getPosition():sendMagicEffect(CONST_ME_CAKE)

 	-- Sorteia uma recompensa da lista
	local reward = rollReward()

	-- Verifica se o jogador tem cap livre e slot na mochila para a recompensa.
	-- getItemWeight retorna o peso em oz; multiplicamos pela quantidade.
	local rewardWeight = getItemWeight(reward.itemId) * reward.count
	if not checkWeightAndBackpackRoom(player, rewardWeight, "reward") then
	    player:getPosition():sendMagicEffect(CONST_ME_STORM)
	    item:getPosition():sendMagicEffect(CONST_ME_PIXIE_EXPLOSION)

		player:sendTextMessage(MESSAGE_STATUS_SMALL, "Voce ganhou um GRANDE premio, mas não tem espaço ou capacidade de carregar ele, então pega aqui seu chocoin de volta!")
		
        -- Se o jogador não tinha cap para pegar devolve o pagamento dele
        if (playerPaidInPureCoin) then
	        player:addItem(48250, 1)
        else
	        player:addItem(48249, 10)
        end
        return true
    end

	-- Da a recompensa ao jogador
	player:addItem(reward.itemId, reward.count)

    -- Efeito adicional se a recompensa é rara (<= 1% de chance)
    if (reward.chance <= 10) then
	    player:getPosition():sendMagicEffect(CONST_ME_CRAPS)
    end

	return true
end

chocolateExtractor:aid(15001)
chocolateExtractor:register()
