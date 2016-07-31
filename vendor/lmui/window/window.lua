-- componente
LmUI.registerComponent("LmWindow", "window")

-- window erstellen
function LmUI.Components.Registred.LmWindow:initialize(context)

    local window, padding, size = nil, 5, 300

    -- hauptframe erstellen
    window = UI.CreateFrame("Mask", LmUI.Addon.identifier .. ".LmWindow", context)
    window.title = UI.CreateFrame("Text", LmUI.Addon.identifier .. ".LmWindow.Title", context)
    window.close = UI.CreateFrame("Text", LmUI.Addon.identifier .. ".LmWindow.Close", context)
    window.body = UI.CreateFrame("Mask", LmUI.Addon.identifier .. ".LmWindow.Body", context)

    -- standard groessen festlegen
    window:SetHeight(size)
    window:SetWidth(size)

    -- texte
    window.title:SetText("LmUI - Fenstertitel")
    window.close:SetText("X")

    window.body:SetHeight(size - (window.title:GetHeight() + padding * 3))
    window.body:SetWidth(size - padding * 2)
    window.title:SetWidth(window:GetWidth() - ((padding * 2) + window.close:GetWidth()) )
    window.title:SetHeight(25)

    -- punkt setzen
    window:SetPoint("CENTER", UIParent, "CENTER")
    window:SetLayer(1)
    window.title:SetPoint("TOPLEFT", window, "TOPLEFT", padding, padding)
    window.title:SetLayer(2)
    window.title:SetParent(window)
    window.close:SetPoint("TOPRIGHT", window, "TOPRIGHT", padding * -1, padding)
    window.close:SetLayer(2)
    window.close:SetParent(window)
    window.body:SetPoint("TOPLEFT", window, "TOPLEFT", padding, window.title:GetHeight() + padding)
    window.body:SetLayer(3)
    window.body:SetParent(window)

    -- farben
    window:SetBackgroundColor(.098, .098, .098, .6)
    window.body:SetBackgroundColor(.098, .098, .098, 1)

    -- vars setzen und fenster verstecken
    window.padding = padding;
    window:SetVisible(false)

    window = LmUI.Components.Registred.LmWindow:registerEvents(window)

    -- gerendertes fenster zurueckgeben
    return window, window.body

end