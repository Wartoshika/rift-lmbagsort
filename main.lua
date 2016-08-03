local addon = ...

-- initialisierung
local function init()

    -- variablen laden
    if LmBagSortGlobal then

        -- variablen laden wenn definiert
        for k,v in pairs(LmBagSortGlobal) do

            -- einzelnd updaten
            LmBagSort.Options[k] = v;
        end
    end

    -- addon setzen
    LmBagSort.Addon = addon

    -- taschenplaetze setzen
    for bag, bagItem in pairs(Inspect.Item.List()) do

        -- details holen
        local type, subType, number = Utility.Item.Slot.Parse(bag)

        -- passt der typ?
        if type == "inventory" and subType == "bag" then

            -- ja, passt. nun noch gucken ob es ueberhaupt slots gibt
            -- beispiel: gekaufter oder vorhanderer slot aber keine tasche vorhanden
            if bagItem then

                -- tasche vorhanden
                LmBagSort.Misc.Bags[number] = bag
            end
        end
    end

    -- minimap button erstellen
    LmBagSort.Ui.MinimapButton()

    -- events registrieren
    Command.Event.Attach(Event.Item.Slot, LmBagSort.Engine.bagUpdateEvent, "LmBagSort.Engine.bagUpdateEvent")

    -- erfolgreichen start ausgeben
    print("erfolgreich geladen (v " .. addon.toc.Version .. ")")

end

-- nach dem addon laden ist das rift inventar system noch nicht geladen
-- also muss solange gewartet werden weil die taschen relevant fuer den addon start sind
local function waitForRiftInventorySystem()

    local foundAtLeaseOneBag = false

    -- pruefen ob taschen bereit sind
    for bag, bagItem in pairs(Inspect.Item.List()) do

        -- details holen
        local type, subType, number = Utility.Item.Slot.Parse(bag)

        -- passen die typen?
        if type == "inventory" and subType == "bag" then

            -- ja
            foundAtLeaseOneBag = true
        end
    end

    -- gibt es eine tasche? wenn ja dann addon initialisieren
    if foundAtLeaseOneBag then

        -- wait event entfernen
        Command.Event.Detach(Event.System.Update.End, waitForRiftInventorySystem, "waitForRiftInventorySystem")

        -- addon starten
        init()
    end
end

-- speichert die gesetzten optionen
local function saveOptionVariables()

    -- ueberschreiben
    LmBagSortGlobal = LmBagSort.Options
end

-- init event binden
Command.Event.Attach(Event.System.Update.End, waitForRiftInventorySystem, "waitForRiftInventorySystem")
Command.Event.Attach(Event.Addon.Shutdown.Begin, saveOptionVariables, "saveOptionVariables")