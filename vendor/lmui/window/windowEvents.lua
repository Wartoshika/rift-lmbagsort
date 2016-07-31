function LmUI.Components.Registred.LmWindow:registerEvents(component)

    -- schliessen event
    function component.close.Event:LeftClick()

        -- schliessen
        component:SetVisible(false)
    end

    -- default values
    component.title.onMove = false
    component.title.moveableFlag = true

    -- verschieben
    function component.title.Event:LeftDown()
        component.title.onMove = true
    end
    function component.title.Event:LeftUp()
        component.title.onMove = false
    end
    function component.title.Event:LeftUpoutside()
        component.title.onMove = false
    end
    function component.title.Event:MouseMove()

        -- wenn nicht am verschieben dann abbrechen
        if not component.title.onMove or not component.title.moveableFlag then return end

        -- offset holen. d.h. die bildschirmbreite/2
        local offsetX = UIParent:GetWidth() / 2
        local offsetY = UIParent:GetHeight() / 2
        local x, y = Inspect.Mouse().x, Inspect.Mouse().y

        -- verschieben
        component:SetPoint("CENTER", UIParent, "CENTER", x - offsetX, (y - offsetY) + (component:GetHeight() / 2) - (component.title:GetHeight() / 2))
    end

    -- moveable
    function component:SetMoveable(moveableFlag)
        component.title.moveableFlag = moveableFlag
    end

    -- resize event
    function component.Event:Size()

        -- body
        self.body:SetHeight(self:GetHeight() - (self.title:GetHeight() + self.padding * 3))
        self.body:SetWidth(self:GetWidth() - self.padding * 2)

        -- title
        self.title:SetWidth(self:GetWidth() - ((self.padding * 2) + self.close:GetWidth()) )
    end

    -- body click focus
    function component.body.Event:LeftClick()

        -- es braucht nix hier stehen, funktioniert aber
    end

    -- fenster titel
    function component:SetTitle(title)

        -- titel setzen
        self.title:SetText(title)
    end

    -- zurueckgeben
    return component

end