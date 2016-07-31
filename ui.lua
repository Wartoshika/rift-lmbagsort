local addon, window, body
local initialised = false

-- ui initialisieren
function LmBagSort.Ui.show()

    -- nicht mehr resourcen verschwenden!
    if initialised then

        -- nur anzeigen
        return window:SetVisible(true)
    end

    -- fenster bauen
    window, body = LmUI.createUiComponent("window")

    -- groesse setzen
    window:SetWidth(400)
    window:SetHeight(600)

    -- titel setzen
    window:SetTitle(LmBagSort.Addon.name .. " - Einstellungen")

    -- initialisieren
    if LmBagSort.Ui.initialise() then

        -- anzeigen
        return window:SetVisible(true)
    end

    -- fehler
    return false
end

-- alle einstellungsmoeglichkeiten initialisieren
function LmBagSort.Ui.initialise()

    -- jede tasche anzeigen
    for number, bag in pairs(LmBagSort.Misc.Bags) do

        -- bereich fuer selektierung erstellen
        local title = UI.CreateFrame("Text", LmBagSort.Addon.identifier .. ".BagTitle", body)
        title:SetPoint("TOPLEFT", body, "TOPLEFT", 10, ((number - 1) * 80) + 10)
        title:SetParent(body)
        title:SetText("Taschenplatz " .. number .. " (" .. Inspect.Item.Detail(bag).name .. ")")

        -- checkboxen
        title.checkbox = {}
        local odd, counter = false, 0
        for category, matches in pairs(LmBagSort.Misc.Categories) do

            -- offset x berechnen
            local offsetX = 0
            if odd then offsetX = 200 end

            -- offset y berechnen
            local offsetY = 20
            if not odd then

                -- offset veraendern
                offsetY = (offsetY * math.ceil(counter)) + 20
                counter = counter + 1
            end

            -- box erstellen
            title.checkbox[category] = LmUI.createUiComponent("checkbox")
            title.checkbox[category]:SetPoint("TOPLEFT", title, "TOPLEFT", offsetX, offsetY)
            title.checkbox[category]:SetLabel(category)
            title.checkbox[category]:SetLayer(2)
            title.checkbox[category]:SetParent(title)

            -- invertieren
            odd = not odd
        end
    end
    
    -- ja initialisiert
    initialised = true

    return initialised
end

-- update event
function LmBagSort.Ui.update()

    
end