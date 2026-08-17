local combat = Combat()
local cooldown = 10000 -- milis (duration)

combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local condition = Condition(CONDITION_REGENERATION)
condition:setParameter(CONDITION_PARAM_TICKS, cooldown)
condition:setParameter(CONDITION_PARAM_HEALTHGAIN, 5)
condition:setParameter(CONDITION_PARAM_HEALTHTICKS, 1000) -- 1sec
condition:setParameter(CONDITION_PARAM_BUFF_SPELL, true)
combat:addCondition(condition)

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("Intense Recovery")
spell:words("utura infir")
spell:group("healing")
spell:vocation("candy guardian;true")
spell:id(160)
spell:cooldown(cooldown)
spell:groupCooldown(1000)
spell:level(5)
spell:mana(25)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:isPremium(false)

spell:register()
