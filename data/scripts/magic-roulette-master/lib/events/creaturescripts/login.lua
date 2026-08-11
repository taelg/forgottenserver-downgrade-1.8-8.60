--[[
	Description: This file is part of Roulette System (refactored)
	Author: Ly�
	Discord: Ly�#8767
]]

local DatabaseRoulettePlays = require('data/scripts/magic-roulette-master/lib/database/roulette_plays')
local Functions = require('data/scripts/magic-roulette-master/lib/core/functions')

local creatureevent = CreatureEvent('Roulette Login')
local CONST_SLOT_BACKPACK = 3

-- Opens the backpack from the equipment slot (slot 3) shortly after login.
-- Only applies to AstraClient users.
local function openBackpackOnLogin(player)
	if not player or not player:isUsingAstraClient() then
		return
	end

	local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
	if backpack then
		player:openContainer(backpack)
	end
end

function creatureevent.onLogin(player)
	player:registerEvent('Roulette Logout')

	local pendingPlayRewards = DatabaseRoulettePlays:selectPendingPlayRewardsByPlayerGuid(player:getGuid())
	
	for _, reward in ipairs(pendingPlayRewards) do
		Functions:giveReward(player, reward)
	end

	-- Open the backpack after a short delay so the client is ready to receive it.
	addEvent(openBackpackOnLogin, 1000, player)

	return true
end

creatureevent:register()
