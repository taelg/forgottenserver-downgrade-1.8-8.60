local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local feed = 20
	local health = player:getMaxHealth() * 0.20
	local mana = player:getMaxMana() * 0.20
	local sounds = {"Yum.", "Munch.", "Crunch.", "Gulp.", "Slurp."}
	
	local condition = player:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)
	if condition and math.floor(condition:getTicks() / 1000 + feed) >= 120 then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "Voce está cheio para comer isso. [feed: " .. condition:getTicks() / 1000 .."/120]")
	else
		player:feed(feed)
		player:addHealth(health)
		player:addMana(mana)
		player:say(sounds[math.random(#sounds)], TALKTYPE_MONSTER_SAY)
		player:sendStats()
	end
	return true
end

action:id(45045)
action:register()
