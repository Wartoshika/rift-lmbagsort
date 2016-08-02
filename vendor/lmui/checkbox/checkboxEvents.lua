function LmUI.Components.Registred.LmCheckbox:registerEvents(component)

    -- label setter funktion
    function component:SetLabel(text)

        -- den text des labels setzen
        self.label:SetText(text)
    end

    -- klick auf das label muss checkbox triggern
    function component.label.Event:LeftClick()

        -- checkbox triggern
        component:SetChecked(not component:GetChecked())
    end

    -- checkbox mit events zurueckgeben
    return component

end