function LmUI.Components.Registred.LmCheckbox:registerEvents(component)

    -- label setter funktion
    function component:SetLabel(text)

        -- den text des labels setzen
        self.label:SetText(text)
    end

    -- checkbox mit events zurueckgeben
    return component

end