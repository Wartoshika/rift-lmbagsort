-- eigene events fuer die komponente registrieren
function LmUI.Components.Registred.LmSelectBox:registerEvents(component)

    -- werte fuer die selectbox setzen
    function component:SetValues(values, useKeys)

        dump("setvalues", values)
    end

    -- das ausgewaehlte item setzen
    function component:SetSelected(item)

        dump("setSelected", item)
    end

    -- expandierungsfunktion
    function component.selectBoxBtnTexture.Event:LeftClick()

        -- trigger list
        if component.selectBoxDropdownList:GetVisible() then

            -- verstecken
            component.selectBoxDropdownList:SetVisible(false)
        else

            -- anzeigen
            component.selectBoxDropdownList:SetVisible(true)
        end
    end

    -- das update event
    function component:update()

        -- hoehe festsetzen
        self:SetHeight(25)

        -- breite und hohe der dynamischen elemente anpassen
        self.selectBoxBgTexture:SetHeight(self:GetHeight())
        self.selectBoxBgTexture:SetWidth(self:GetWidth())
        self.selectBoxBtnTexture:SetHeight(self:GetHeight())
        self.selectBoxDropdownList:SetWidth(self:GetWidth())

        -- eigenreferenz fuer kurzschreibweise zurueckgeben
        return self
    end

    -- componente mit events zurueckgeben
    return component
end