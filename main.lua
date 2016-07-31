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

    -- gui bauen
    --LmBagSort.Ui.init(addon)

    -- erfolgreichen start ausgeben
    print("erfolgreich geladen (v " .. addon.toc.Version .. ")")

end

-- speichert die gesetzten optionen
local function saveOptionVariables()

    -- ueberschreiben
    LmBagSortGlobal = LmMBagSort.Options
end

-- init event binden
Command.Event.Attach(Event.Addon.Load.End, init, "init")
Command.Event.Attach(Event.Addon.Shutdown.Begin, saveOptionVariables, "saveOptionVariables")