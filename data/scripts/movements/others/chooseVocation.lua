local moveevent = MoveEvent()

-- Portal de escolher vocation.
-- Ao pisar no tile (unique id entre 25501 e 25550), troca a vocation
-- e adiciona os itens de acordo com a classe escolhida.
--
-- Tabela: [uniqueId] = { vocation = <id da vocation no vocations.xml>, items = { {itemId, quantidade}, ... } }
local chooseVoc = {
	[25502] = { -- Candy Guardian (vocation 2)
		vocation = 2,
		items = {
			-- {2160, 100}, -- exemplo: 100 gold
		},
	},
	[25503] = { -- Pyromancer (vocation 3)
		vocation = 3,
		items = {
			-- {2160, 100}, -- exemplo: 100 gold
		},
	},
}

function moveevent.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() or creature:isInGhostMode() then
		return true
	end

	local voc = chooseVoc[item:getUniqueId()]
	if not voc then
		return true
	end

	creature:setVocation(voc.vocation)
	for _, entry in ipairs(voc.items) do
		creature:addItem(entry[1], entry[2])
	end

	return true
end

moveevent:type("stepin")
moveevent:uid(25502, 25503)
moveevent:register()
