local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_FIREATTACK)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_FIRE)

local FIRE_TICKS = 5000 -- duração do fogo em ms

local function callback(player, level, magicLevel)
	local mana = player:getMaxMana()
	local trueML = ((mana - 100) / 5)
	local min = (trueML * 0.8) + 1
	local max = (trueML * 1.2) + 2
	return -min, -max
end

combat:setCallback(CallBackParam.LEVELMAGICVALUE, callback)

local spell = Spell("instant")
function spell.onCastSpell(creature, variant)
	if not combat:execute(creature, variant) then
		return false
	end

	-- Aplica a condição de fogo no alvo (dano por segundo baseado no trueML do jogador)
	local target = creature:getTarget()
	if target and target:isCreature() then
		local mana = creature:getMaxMana()
		local trueML = ((mana - 100) / 5)
		local tickDamage = 1.2 + math.floor(trueML * 0.2) -- dano por tick

		local condition = Condition(CONDITION_FIRE)
		condition:setParameter(CONDITION_PARAM_OWNER, creature:getId())
		condition:setParameter(CONDITION_PARAM_PERIODICDAMAGE, -tickDamage)
		condition:setParameter(CONDITION_PARAM_TICKS, FIRE_TICKS)
		condition:setParameter(CONDITION_PARAM_TICKINTERVAL, 1000) -- 1 tick por segundo
		target:addCondition(condition)
	end

	return true
end

spell:group("attack")
spell:id(111)
spell:name("Flame Strike")
spell:words("exori flam")
spell:level(3)
spell:mana(10)
spell:isPremium(false)
spell:range(5)
spell:needCasterTargetOrDirection(true)
spell:blockWalls(true)
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:vocation("pyromancer")
spell:register()