local internalNpcName = "Gnomelvis"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 493,
	lookHead = 67,
	lookBody = 76,
	lookLegs = 105,
	lookFeet = 95,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

local itemsTable = {
	["ferramentas"] = {
		{ itemName = "corda", clientId = 3003, buy = 10 },
		{ itemName = "shovel", clientId = 3457, buy = 20 },
		{ itemName = "pick", clientId = 3456, buy = 35 },
		{ itemName = "scythe", clientId = 3453, buy = 20 },
		{ itemName = "hoe", clientId = 3455, buy = 20 },
		{ itemName = "hammer", clientId = 3470, buy = 25 },
		{ itemName = "saw", clientId = 3461, buy = 25 },
		{ itemName = "watering can", clientId = 650, buy = 25 },
		{ itemName = "rolling pin", clientId = 3473, buy = 10 },
	},
	["armaduras de couro"] = {
		{ itemName = "botas de couro", clientId = 3552, buy = 100, sell = 25 },
	},
}

npcConfig.shop = {}
for _, categoryTable in pairs(itemsTable) do
	for _, itemTable in ipairs(categoryTable) do
		table.insert(npcConfig.shop, itemTable)
	end
end

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

keywordHandler:addKeyword({ "ferramentas" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Claro! Aqui na Terra do Doce não se planta sem boas ferramentas. Fique à vontade para olhar tudo!",
})

keywordHandler:addKeyword({ "armaduras de couro", "armadura" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Um bom conjunto de couro protege sem pesar. Dê uma olhada no que tenho!",
})

keywordHandler:addKeyword({ "bota", "botas" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "As botas de couro são práticas para andar pelos campos. E se sobrar alguma, também compro a sua por um preço justo!",
})

keywordHandler:addKeyword({ "coisas", "itens", "utilidades", "utilidade" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Tenho de tudo um pouco: {ferramentas} para o campo e algumas {armaduras de couro}. Dê uma olhada e me diga o que deseja!",
})

keywordHandler:addKeyword({ "extrator", "extractor", "chocolate extractor", "chocoin" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "O {chocolate extractor} é o coração da nossa coleta, |PLAYERNAME|. Todo o chocolate que os bichos mineram e você coletou lá embaixo, nas minas do subsolo, alimentam o crescimento da cidade. Bololandia agradece cada esforço seu! Basta usar a máquina para depositar {1 chocolate coin pura} ou {10 chocolate coin diluídas}. Ela transforma tudo isso em recompensas: no mínimo {1 moeda de ouro} a cada uso, e se a sorte sorrir, prêmios bem raros! Continue minerando, |PLAYERNAME|, sua contribuição faz a Bololandia prosperar.",
})

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local categoryTable = itemsTable[message:lower()]
	if categoryTable then
		local remainingCategories = npc:getRemainingShopCategories(message:lower(), itemsTable)
		npcHandler:say("Claro, pode olhar à vontade. Também tenho " .. remainingCategories .. ".", npc, player)
		npc:openShopWindowTable(player, categoryTable)
	end

	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Olá, |PLAYERNAME|! Bem-vindo à Terra do Doce! Precisa de alguma {utilidade} para o dia a dia? E se trouxe chocolate das minas, pode alimentar o meu chocolate {extractor} ali da sala, é só perguntar!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Até logo, |PLAYERNAME|. Volte sempre!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Até logo, |PLAYERNAME|. Bom trabalho!")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Claro, pode olhar tudo com calma. Ou talvez queira ver apenas " .. GetFormattedShopCategoryNames(itemsTable) .. ".")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Você vendeu %ix %s por %i moedas de ouro.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
