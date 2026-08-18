local spellbook = Action()

-- Mapa de vocacoes -> lista de spells (palavras mágicas / spell:words)
-- Adicione/edite abaixo conforme as classes
local CLASS_SPELLS = {
	["all"] = {
		"utevo lux",
	},
	["Candy Guardian"] = {
		"utura infir",
		"exori cake",
	},
	["Pyromancer"] = {
		"exori flam",
	},

}

function spellbook.onUse(player, item, fromPosition, target, toPosition,
                         isHotkey)
	local vocationName = player:getVocation():getName()

	-- Lista permitida: "all" + spells da vocacao do player
	local allowed = {}
	local allSpells = CLASS_SPELLS["all"] or {}
	local classSpells = CLASS_SPELLS[vocationName] or {}
	for _, s in ipairs(allSpells) do allowed[s] = true end
	for _, s in ipairs(classSpells) do allowed[s] = true end

	local text = {}
	local spells = {}
	for _, spell in ipairs(player:getInstantSpells()) do
		if spell.level ~= 0 and allowed[spell.words] then
			if spell.manapercent > 0 then spell.mana = spell.manapercent .. "%" end
			if spell.params > 0 then spell.words = spell.words .. " para" end
			spells[#spells + 1] = spell
		end
	end

	table.sort(spells, function(a, b) return a.level < b.level end)

	local prevLevel = -1
	for i, spell in ipairs(spells) do
		if prevLevel ~= spell.level then
			if i == 1 then
				text[#text == nil and 1 or #text + 1] = "Spells for Level "
			else
				text[#text + 1] = "\nSpells for Level "
			end
			text[#text + 1] = spell.level .. "\n"
			prevLevel = spell.level
		end
		text[#text + 1] = spell.words .. " - " .. spell.name .. " : " .. spell.mana ..
			                  "\n"
	end

	player:showTextDialog(item:getId(), table.concat(text))
	return true
end

spellbook:id(3059, 6120, 8072, 8073, 8074, 8075, 8076, 8090)
spellbook:register()
