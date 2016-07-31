local addon = ...

-- globale variable setzen
LmUI = {
    -- alle ui elemente
    Components = {
        Names = {},
        Registred = {}
    },

    -- addon
    Addon = addon,

    -- kontext aller elemente (kann ueberschrieben werden)
    Context = nil
}

-- context fuer alle ui elemente erzeugen
LmUI.Context = UI.CreateContext(addon.identifier .. ".GlobalContext")

-- grundfunktion fuer das erstellen von LmUI frames
function LmUI.createUiComponent(moduleName)

    -- systemname holen
    local systemName = LmUI.Components.Names[moduleName]

    -- gibt es das modul?
    if systemName == nil then error("LmUI: Modul " .. moduleName .. "nicht gefunden!") end

    -- modul erstellen und zurueckgeben
    return LmUI.Components.Registred[systemName]:initialize(LmUI.Context)
end

-- eine neue componente registrieren
function LmUI.registerComponent(systemName, userName)

    -- stapeln
    LmUI.Components.Names[userName] = systemName
    LmUI.Components.Registred[systemName] = {}
end