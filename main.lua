local addon = ...

-- initialisierung
local function init()

    -- nur einmal initialisieren
    Command.Event.Detach(Event.Addon.Load.End, init, "init")

    -- variablen laden
    if LmBagSortGlobal then

        -- variablen laden wenn definiert
        for k,v in pairs(LmBagSortGlobal) do

            -- einzelnd updaten
            LmMBagSort.Options[k] = v;
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

    -- events registrieren
    Command.Event.Attach(Event.Item.Slot, LmBagSort.Engine.bagUpdateEvent, "LmBagSort.Engine.bagUpdateEvent")

    -- erfolgreichen start ausgeben
    print("erfolgreich geladen (v " .. addon.toc.Version .. ")")

    LmBagSort.Ui.show()
end

-- speichert die gesetzten optionen
local function saveOptionVariables()

    -- ueberschreiben
    LmBagSortGlobal = LmMBagSort.Options
end

-- init event binden
Command.Event.Attach(Event.Addon.Load.End, init, "init")
Command.Event.Attach(Event.Addon.Shutdown.Begin, saveOptionVariables, "saveOptionVariables")