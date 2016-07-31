
-- wird gerufen wenn 
function LmBagSort.Engine.bagUpdateEvent(_, items)

    -- wenn die taschen auf sind dann nicht pruefen
    if UI.Native.BagInventory1:GetLoaded() then return end

    local stack = {}

    -- es muessen alle nicht taschen ausgeschlossen werden
    -- die nicht beim start registriert worden sind (z.B. bank)
    for slot, item in pairs(items) do

        -- taschenplatz vorhanden?
        local type, number = Utility.Item.Slot.Parse(slot)

        -- typ und registrierung stimmt?
        if type == "inventory" and LmUtils.tableHasValue(LmUtils.getTableKeys(LmBagSort.Misc.Bags), number) then

            -- pruefen
            stack[slot] = item
            --LmBagSort.Engine.checkItemIsNew(item, slot)
        end
    end

    -- gueltig?
    if not LmUtils.tableHasValue(stack, false) then

        -- elemente sind neu in die tasche gekommen, verarbeiten
        LmBagSort.Engine.sortItems(stack)
    end

end

-- sortiert die gegenstaende nach der einstellung
function LmBagSort.Engine.sortItems(items)

    for slot, item in pairs(items) do

        dump("Neuer Gegenstand: " .. Inspect.Item.Detail(item).name)
    end

end