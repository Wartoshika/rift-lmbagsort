-- componente
LmUI.registerComponent("LmCheckbox", "checkbox")

-- checkbox erstellen
function LmUI.Components.Registred.LmCheckbox:initialize(context)

    local checkbox

    -- frames erstellen
    checkbox = UI.CreateFrame("RiftCheckbox", LmUI.Addon.identifier .. ".LmCheckbox", context)
    checkbox.label = UI.CreateFrame("Text", LmUI.Addon.identifier .. ".LmCheckbox.Label", context)

    -- punkte setzen
    checkbox.label:SetPoint("TOPLEFT", checkbox, "TOPLEFT", 20, 0)
    checkbox.label:SetParent(checkbox)

    -- checkbox zurueckgeben
    return LmUI.Components.Registred.LmCheckbox:registerEvents(checkbox)

end