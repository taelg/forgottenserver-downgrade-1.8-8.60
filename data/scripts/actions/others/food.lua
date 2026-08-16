local action = Action()

local foods = {
	[3590] = {3, "Yum.", 1, 1, 1}, -- cherry

	[3250] = {1, "Crunch.", 1, 1, 1}, -- carrot
	[3577] = {3, "Munch.", 4, 3, 1}, -- meat
	[3578] = {3, "Munch.", 3, 3, 1}, -- fish
	[3579] = {2, "Mmmm.", 3, 2, 1}, -- salmon
	[3580] = {4, "Munch.", 5, 4, 1}, -- northern pike
	[3581] = {1, "Gulp.", 1, 1, 1}, -- shrimp
	[3582] = {7, "Chomp.", 8, 6, 1}, -- ham
	[3583] = {15, "Chomp.", 18, 12, 1}, -- dragon ham
	[3584] = {1, "Yum.", 1, 1, 1}, -- pear
	[3585] = {1, "Yum.", 1, 1, 1}, -- red apple
	[3586] = {3, "Yum.", 3, 3, 1}, -- orange
	[3587] = {2, "Yum.", 1, 3, 1}, -- banana
	[3588] = {0, "Yum.", 0, 1, 1}, -- blueberry
	[3589] = {4, "Slurp.", 5, 4, 1}, -- coconut
	[3591] = {0, "Yum.", 0, 1, 1}, -- strawberry
	[3592] = {2, "Yum.", 2, 2, 1}, -- grapes
	[3593] = {5, "Yum.", 6, 4, 1}, -- melon
	[3594] = {4, "Munch.", 5, 4, 1}, -- pumpkin
	[3595] = {1, "Crunch.", 1, 1, 1}, -- carrot
	[3596] = {1, "Munch.", 1, 1, 1}, -- tomato
	[3597] = {2, "Crunch.", 2, 2, 1}, -- corncob
	[3598] = {0, "Crunch.", 0, 1, 1}, -- cookie
	[3599] = {0, "Munch.", 0, 1, 1}, -- candy cane
	[3600] = {2, "Crunch.", 3, 2, 1}, -- bread
	[3601] = {0, "Crunch.", 1, 0, 1}, -- roll
	[3602] = {2, "Crunch.", 2, 2, 1}, -- brown bread
	[3606] = {1, "Gulp.", 1, 1, 1}, -- egg
	[3607] = {2, "Smack.", 2, 2, 1}, -- cheese
	[3723] = {2, "Munch.", 2, 2, 1}, -- white mushroom
	[3724] = {1, "Munch.", 1, 1, 1}, -- red mushroom
	[3725] = {5, "Munch.", 6, 4, 1}, -- brown mushroom
	[3726] = {7, "Munch.", 8, 6, 1}, -- orange mushroom
	[3727] = {2, "Munch.", 2, 2, 1}, -- wood mushroom
	[3728] = {1, "Munch.", 1, 1, 1}, -- dark mushroom
	[3729] = {3, "Munch.", 3, 3, 1}, -- some mushrooms
	[3730] = {0, "Munch.", 0, 1, 1}, -- some mushrooms
	[3731] = {9, "Munch.", 10, 8, 1}, -- fire mushroom
	[3732] = {1, "Munch.", 1, 1, 1}, -- green mushroom
	[5096] = {1, "Yum.", 1, 1, 1}, -- mango
	[5678] = {2, "Gulp.", 2, 2, 1}, -- tortoise egg
	[6125] = {2, "Gulp.", 2, 2, 1}, -- tortoise egg from Nargor
	[6277] = {2, "Mmmm.", 3, 2, 1}, -- cake
	[6278] = {3, "Mmmm.", 4, 3, 1}, -- decorated cake
	[6392] = {3, "Mmmm.", 3, 3, 1}, -- valentine's cake
	[6393] = {3, "Mmmm.", 4, 3, 1}, -- cream cake
	[6500] = {5, "Mmmm.", 6, 4, 1}, -- gingerbread man
	[6541] = {1, "Gulp.", 1, 1, 1}, -- coloured egg (yellow)
	[6542] = {1, "Gulp.", 1, 1, 1}, -- coloured egg (red)
	[6543] = {1, "Gulp.", 1, 1, 1}, -- coloured egg (blue)
	[6544] = {1, "Gulp.", 1, 1, 1}, -- coloured egg (green)
	[6545] = {1, "Gulp.", 1, 1, 1}, -- coloured egg (purple)
	[6569] = {0, "Mmmm.", 0, 1, 1}, -- candy
	[6574] = {1, "Mmmm.", 1, 1, 1}, -- bar of chocolate
	[7158] = {3, "Munch.", 4, 3, 1}, -- rainbow trout
	[7159] = {3, "Munch.", 3, 3, 1}, -- green perch
	[229] = {0, "Yum.", 0, 1, 1}, -- ice cream cone (crispy chocolate chips)
	[7373] = {0, "Yum.", 0, 1, 1}, -- ice cream cone (velvet vanilla)
	[7374] = {0, "Yum.", 0, 1, 1}, -- ice cream cone (sweet strawberry)
	[7375] = {0, "Yum.", 0, 1, 1}, -- ice cream cone (chilly cherry)
	[7376] = {0, "Yum.", 0, 1, 1}, -- ice cream cone (mellow melon)
	[7377] = {0, "Yum.", 0, 1, 1}, -- ice cream cone (blue-barian)
	[836] = {1, "Crunch.", 1, 1, 1}, -- walnut
	[841] = {1, "Crunch.", 1, 1, 1}, -- peanut
	[901] = {15, "Munch.", 18, 12, 1}, -- marlin
	[169] = {2, "Urgh.", 2, 2, 1}, -- scarab cheese
	[8010] = {2, "Gulp.", 3, 2, 1}, -- potato
	[8011] = {1, "Yum.", 1, 1, 1}, -- plum
	[8012] = {0, "Yum.", 0, 1, 1}, -- raspberry
	[8013] = {0, "Urgh.", 0, 1, 1}, -- lemon
	[8014] = {1, "Munch.", 2, 1, 1}, -- cucumber
	[8015] = {1, "Crunch.", 1, 1, 1}, -- onion
	[8016] = {0, "Gulp.", 0, 1, 1}, -- jalapeño pepper
	[8017] = {1, "Munch.", 1, 1, 1}, -- beetroot
	[8019] = {2, "Yum.", 3, 2, 1}, -- chocolate cake
	[8177] = {1, "Slurp.", 2, 1, 1}, -- yummy gummy worm
	[8197] = {1, "Crunch.", 1, 1, 1}, -- bulb of garlic
	[9083] = {0, "Slurp.", 0, 0, 1}, -- banana chocolate shake
	[9537] = {0, "Your head begins to feel better.", 0, 0, 1}, -- headache pill
	[10329] = {3, "Yum.", 4, 3, 1}, -- rice ball
	[10453] = {0, "Urgh.", 1, 0, 1}, -- terramite eggs
	[10219] = {2, "Mmmm.", 3, 2, 1}, -- crocodile steak
	[11459] = {5, "Yum.", 6, 4, 1}, -- pineapple
	[11460] = {2, "Munch.", 3, 2, 1}, -- aubergine
	[11461] = {2, "Crunch.", 2, 2, 1}, -- broccoli
	[11462] = {2, "Crunch.", 2, 2, 1}, -- cauliflower
	[11681] = {13, "Gulp.", 15, 11, 1}, -- ectoplasmic sushi
	[11682] = {4, "Yum.", 5, 4, 1}, -- dragonfruit
	[11683] = {0, "Munch.", 0, 1, 1} -- peas
}

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local food = foods[item.itemid]
	if not food then return false end

	local feed = food[1]
	local sound = food[2]
	local health = food[3]
	local mana = food[4]
	local minLevel = food[5]

	if player:getLevel() < minLevel then
		player:sendTextMessage(MESSAGE_STATUS_SMALL,"Essa comida exige level " .. minLevel .. ".")
		return true
	end

	local condition = player:getCondition(CONDITION_REGENERATION,
	                                      CONDITIONID_DEFAULT)
	if condition and math.floor(condition:getTicks() / 1000 + feed) >= 120 then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "Voce está cheio para comer isso. [feed: " .. condition:getTicks() / 1000 .."/120]")
	else
		player:feed(feed)
		player:addHealth(health)
		player:addMana(mana)
		player:say(sound, TALKTYPE_MONSTER_SAY)
		item:remove(1)
		player:sendStats()
	end
	return true
end

action:id(3250, 3577, 3578, 3579, 3580, 3581, 3582, 3583, 3584, 3585, 3586, 3587, 3588, 3589, 3590, 3591, 3592, 3593, 3594, 3595, 3596, 3597, 3598, 3599, 3600, 3601, 3602, 3606, 3607, 3723, 3724, 3725, 3726, 3727, 3728, 3729, 3730, 3731, 3732, 5096, 6125, 6277, 6278, 6392, 6393, 6500, 6541, 6542, 6543, 6544, 6545, 6569, 6574, 7158, 7159, 229, 7373, 7374, 7375, 7376, 7377, 836, 841, 901, 169, 8010, 8011, 8012, 8013, 8014, 8015, 8016, 8017, 8019, 8177, 8197, 9083, 9537, 10329, 10453, 10219, 11459, 11460, 11461, 11462, 11681, 11682, 11683)
action:register()
