local portalEffects = GlobalEvent("PortalEffects")
function portalEffects.onThink(interval)
    local effects = {
		{position = Position(1000, 1000, 7),  text = "Bem vindo ao OTzinho!",     effect = 30, color = TEXTCOLOR_LIGHTGREEN},
    } --TEXTCOLOR_BLUE, TEXTCOLOR_RED, TEXTCOLOR_PURPLE, TEXTCOLOR_LIGHTGREEN

    for i = 1, #effects do
        local settings = effects[i]
        if not settings.configKey or configManager.getBoolean(settings.configKey) then
            local spectators = Game.getSpectators(settings.position, false, true, 7, 7, 5, 5)

            if #spectators > 0 then
                if settings.effect then
                    settings.position:sendMagicEffect(settings.effect)
                end
                Game.sendAnimatedText(settings.text, settings.position, settings.color)
            end
        end
    end
    return true
end
portalEffects:interval(2000)
portalEffects:register()
