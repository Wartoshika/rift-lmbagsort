local addon, window, body
local initialised, bags = false, {}

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
    window:SetWidth(450)
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
        local odd, counter, offsetY = false, 0, 20
        for category, matches in pairs(LmBagSort.Misc.Categories) do

            -- schon in den einstellungen gesetzt?
            local loaded = false
            if type(LmBagSort.Options[bag]) ~= "nil" and type(LmBagSort.Options[bag][category]) == "table" then
            
                -- ja geladen
                loaded = true
            end

            -- offset x berechnen
            local offsetX = 40
            if odd then offsetX = 240 end

            -- offsetY setzen
            local offsetY = (offsetY * math.ceil(counter)) + 20

            if odd then
                counter = counter + 1
            end

            -- box erstellen
            title.checkbox[category] = LmUI.createUiComponent("checkbox")
            title.checkbox[category]:SetPoint("TOPLEFT", title, "TOPLEFT", offsetX, offsetY)
            title.checkbox[category]:SetLabel(category)
            title.checkbox[category]:SetLayer(2)
            title.checkbox[category]:SetParent(title)
            title.checkbox[category]:SetAlpha(.3)

            -- kategorie setzen damit die kategorie gespeichert werden kann
            title.checkbox[category].category = category
            title.checkbox[category].bag = bag

            -- indikator fuer oben oder unten auffuellen
            title.checkbox[category].directionIndicator = UI.CreateFrame("Texture", LmBagSort.Addon.identifier .. ".CheckboxDirectionIndicator", title.checkbox[category])
            title.checkbox[category].directionIndicator:SetTexture("Rift", "splitbtn_arrow_D_(normal).png.dds")
            title.checkbox[category].directionIndicator:SetPoint("TOPLEFT", title.checkbox[category], "TOPLEFT", -20, 0)
            title.checkbox[category].directionIndicator:SetVisible(false)
            title.checkbox[category].directionIndicator.direction = "TOP"

            -- priotitaetsindikator
            title.checkbox[category].priorityIndicator = UI.CreateFrame("Text", LmBagSort.Addon.identifier .. ".CheckboxPriorityIndicator", title.checkbox[category])
            title.checkbox[category].priorityIndicator:SetText("1")
            title.checkbox[category].priorityIndicator:SetPoint("TOPLEFT", title.checkbox[category], "TOPLEFT", -35, 0)
            title.checkbox[category].priorityIndicator:SetVisible(false)
            title.checkbox[category].priorityIndicator.priority = 1

            -- geladen?
            if loaded then

                -- alpha setzen und checkbox setzen
                title.checkbox[category]:SetChecked(true)
                title.checkbox[category]:SetAlpha(1)
                title.checkbox[category].directionIndicator:SetVisible(true)
                title.checkbox[category].priorityIndicator:SetVisible(true)

                -- richtung setzen inkl. textur
                local texture = "splitbtn_arrow_D_(normal).png.dds" -- top
                title.checkbox[category].directionIndicator.direction = LmBagSort.Options[bag][category].direction
                if title.checkbox[category].directionIndicator.direction == "BOTTOM" then
                    texture = "minimap_depth_arrow.png.dds"
                end
                title.checkbox[category].directionIndicator:SetTexture("Rift", texture)

                -- prio setzen
                title.checkbox[category].priorityIndicator.priority = LmBagSort.Options[bag][category].priority
                title.checkbox[category].priorityIndicator:SetText(tostring(title.checkbox[category].priorityIndicator.priority))

            end

            -- events registrieren
            LmBagSort.Ui.initialiseEvents(title.checkbox[category])

            -- invertieren
            odd = not odd
        end

        -- alle daten speichern
        table.insert(bags, title)
    end
    
    -- ja initialisiert
    initialised = true

    return initialised
end

-- events initialisieren
function LmBagSort.Ui.initialiseEvents(checkbox)

    -- checked change events
    function checkbox.Event:CheckboxChange()

        -- arrow indikator anzeigen oder nicht
        checkbox.directionIndicator:SetVisible(self:GetChecked())
        checkbox.priorityIndicator:SetVisible(self:GetChecked())

        -- wenn gesetzt
        if self:GetChecked() then

            -- alpha anpassen
            checkbox:SetAlpha(1)

            -- dann dieses auch so speichern. pruefen ob in den optionen
            -- bereits die kategorie vorhanden ist
            if type(LmBagSort.Options[self.bag]) == "nil" then

                -- taschenkonfiguration anlegen
                LmBagSort.Options[self.bag] = {}
            end

            -- konfiguration hinzufuegen
            LmBagSort.Options[self.bag][self.category] = {
                direction = self.directionIndicator.direction,
                priority = self.priorityIndicator.priority
            }
        else

            -- konfiguration entfernen
            LmBagSort.Options[self.bag][self.category] = nil

            -- wenn die einstellungen der tasche nun leer sind dann die tasche ebenfalls entfernen
            if LmUtils.tableLength(LmBagSort.Options[self.bag]) == 0 then

                -- taschenkonfiguration entfernen
                LmBagSort.Options[self.bag] = nil
            end

            -- alpha anpassen
            checkbox:SetAlpha(.3)
        end
    end

    -- event zum aendern der richtung
    function checkbox.directionIndicator.Event:LeftClick()

        -- und veraendern
        if self.direction == "TOP" then 

            -- von unten nach oben
            self:SetTexture("Rift", "minimap_depth_arrow.png.dds")
            self.direction = "BOTTOM"
        else

            -- von oben nach unten
            self:SetTexture("Rift", "splitbtn_arrow_D_(normal).png.dds")
            self.direction = "TOP"
        end

        -- richtung speichern
        LmBagSort.Options[checkbox.bag][checkbox.category].direction = self.direction
    end

    -- priorityIndicator events
    function checkbox.priorityIndicator.Event:LeftClick()

        -- prioritaet erhoehen
        self.priority = tonumber(self.priority) - 1

        -- 1 ist max prio
        if self.priority < 1 then self.priority = 1 end

        self:SetText(tostring(self.priority))

        -- prioritaet speichern
        LmBagSort.Options[checkbox.bag][checkbox.category].priority = self.priority
    end
    function checkbox.priorityIndicator.Event:RightClick()

        -- prioritaet verringern
        self.priority = tonumber(self.priority) + 1

        -- 10 ist min prio
        if self.priority > 10 then self.priority = 10 end

        self:SetText(tostring(self.priority))

        -- prioritaet speichern
        LmBagSort.Options[checkbox.bag][checkbox.category].priority = self.priority 
    end

end