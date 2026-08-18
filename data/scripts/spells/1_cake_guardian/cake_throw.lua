local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_CAKE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_CAKE) --CONST_ANI_CHERRYBOMB  CONST_ANI_CHERRYBOMB CONST_ANI_CAKE CONST_ANI_CANDYCANE
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setParameter(COMBAT_PARAM_USECHARGES, true)

local function callback(player, level, magicLevel)
	local mana = player:getMaxMana()
	local trueML = ((mana - 100) / 5) -- Level calculado de acordo com a mana do player, para que o dano seja proporcional a mana do player. (item com + mana max aumenta o dano do player)
	local min = (trueML * 0.8) + 2
	local max = (trueML * 1.2) + 5
	return -min, -max
end

combat:setCallback(CallBackParam.SKILLVALUE, callback)

local spell = Spell("instant")
function spell.onCastSpell(creature, variant) return combat:execute(creature, variant) end


spell:group("attack")
spell:id(120)
spell:name("Whirlwind Throw")
spell:words("exori cake")
spell:level(5)
spell:mana(20)
spell:isPremium(false)
spell:range(5)
spell:needTarget(true)
spell:blockWalls(true)
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:vocation("candy guardian")
spell:register()
