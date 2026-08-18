local cooldown = 10000 -- milis (duration)

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	-- Pega o level atual do jogador
	local level = player:getLevel()
	local health = player:getMaxHealth()

		local trueHL = ((health - 100) / 5) -- Level calculado de acordo com a health do player, para que a cura seja proporcional a health do player. (item com + health max aumenta o cura do player)

	local healthGain = 4 + math.floor(level/3)

	-- Cria o combat localmente para aplicar a condição dinâmica
	local combat = Combat()
	combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)
	combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

	-- Configura a condição com o valor atualizado baseado no level
	local condition = Condition(CONDITION_REGENERATION)
	condition:setParameter(CONDITION_PARAM_TICKS, cooldown)
	condition:setParameter(CONDITION_PARAM_HEALTHGAIN, healthGain)
	condition:setParameter(CONDITION_PARAM_HEALTHTICKS, 1000) -- 1sec
	condition:setParameter(CONDITION_PARAM_BUFF_SPELL, true)
	combat:addCondition(condition)

	return combat:execute(creature, variant)
end

spell:name("Intense Recovery")
spell:words("utura infir")
spell:group("healing")
spell:vocation("candy guardian;true")
spell:id(160)
spell:cooldown(cooldown)
spell:groupCooldown(1000)
spell:level(3)
spell:mana(15)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:isPremium(false)

spell:register()
