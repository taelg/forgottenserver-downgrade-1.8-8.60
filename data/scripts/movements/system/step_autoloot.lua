local moveevent = MoveEvent()

local function moveLootToPlayer(player, container)
    for i = container:getSize() - 1, 0, -1 do
        local item = container:getItem(i)
        if item then
            if item:isContainer() then
                moveLootToPlayer(player, item)
            elseif player:addItem(item:getId(), item:getSubType(), false, 1, CONST_SLOT_WHEREEVER) then
                item:remove()
            end
        end
    end
end

function moveevent.onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player or not item:isContainer() then
        return true
    end

    local corpseOwner = item:getCorpseOwner()
    if corpseOwner > 0 and corpseOwner ~= player:getId() then
        local party = player:getParty()
        if not party or (party:getLeader() and party:getLeader():getId() ~= corpseOwner) then
            return true
        end
    end

    if item:getSize() > 0 then
        moveLootToPlayer(player, item)
        position:sendMagicEffect(CONST_ME_MAGIC_GREEN)
    end
    return true
end

moveevent:type("stepin")

for id = 3058, 3127 do moveevent:id(id) end
for id = 5965, 6075 do moveevent:id(id) end

moveevent:register()
