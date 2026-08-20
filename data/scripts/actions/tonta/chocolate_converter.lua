local chocolateConverter = Action()

function chocolateConverter.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	if item.actionid == 15002 then
		if player:removeItem(48249, 10) then
			player:addItem(48250, 1)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		else
			player:sendTextMessage(MESSAGE_STATUS_SMALL, 'Você precisa de 10x choco diluído para converter.')
		end
	elseif item.actionid == 15003 then
		if player:removeItem(48250, 1) then
			player:addItem(48249, 10)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		else
			player:sendTextMessage(MESSAGE_STATUS_SMALL, 'Você precisa de 1x de chocoin puro para converter.')
		end
	end

	return true
end

chocolateConverter:aid(15002, 15003)
chocolateConverter:register()
