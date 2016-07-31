-- componente
LmUI.registerComponent("LmWindow", "window")

-- window erstellen
function LmUI.Components.Registred.LmWindow:initialize(context)

    local window, padding = nil, 5

    -- hauptframe erstellen
    window = UI.CreateFrame("Mask", LmUI.Addon.identifier .. ".LmWindow", context)
    window.title = UI.CreateFrame("Text", LmUI.Addon.identifier .. ".LmWindow.Title", context)
    window.close = UI.CreateFrame("Text", LmUI.Addon.identifier .. ".LmWindow.Close", context)
    window.body = UI.CreateFrame("Mask", LmUI.Addon.identifier .. ".LmWindow.Body", context)

    -- standard groessen festlegen
    window:SetHeight(300)
    window:SetWidth(300)

    -- texte
    window.title:SetText("LmUI - Fenstertitel")
    window.close:SetText("X")

    window.body:SetHeight(300 - (window.title:GetHeight() + padding * 2))
    window.body:SetWidth(300 - padding * 2)

    -- punkt setzen
    window:SetPoint("CENTER", UIParent, "CENTER")
    window:SetLayer(1)
    window.title:SetPoint("TOPLEFT", window, "TOPLEFT", padding, padding)
    window.title:SetLayer(2)
    window.close:SetPoint("TOPRIGHT", window, "TOPRIGHT", padding * -1, padding)
    window.close:SetLayer(2)
    window.body:SetPoint("TOPLEFT", window, "TOPLEFT", padding, window.title:GetHeight() + padding)
    window.body:SetLayer(3)

    -- farben
    window:SetBackgroundColor(.098, .098, .098, .8)
    window.body:SetBackgroundColor(1, 1, 1, .05)

    

    -- gerendertes fenster zurueckgeben
    return window

end