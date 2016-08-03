-- wenn ein item verschoben wird, dann muss via lock sichergestellt werden,
-- dass es nicht ein zweites mal verschoben wird.
local itemLockMove = {}

-- wenn mehrere gegenstaende gelootet werden, dann duerfen die slots nicht
-- doppelt belegt werden.
local itemLockSlot = {}
local itemLockSlotTime = {}
local detectThresholdLockBug = 5    -- 5 sekunden

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
        end
    end

    -- gueltig?
    if not LmUtils.tableHasValue(stack, false) then

        -- prueft ob ggf. items im lock haengen bleiben.
        LmBagSort.Engine.dectectLockBug()

        -- elemente sind neu in die tasche gekommen, verarbeiten
        LmBagSort.Engine.sortItems(stack)
    end

end

-- prueft ob ggf. items im lock haengen bleiben
function LmBagSort.Engine.dectectLockBug()

    for item, time in pairs(itemLockSlotTime) do

        -- ist die zeit abgelaufen?
        if (Inspect.Time.Server() - time) > detectThresholdLockBug then

            dump("bug fuer slot", itemLockSlot[item], "gefunden")

            -- ja bug gefunden ... lock entfernen
            itemLockSlot[item] = nil
            itemLockSlotTime[item] = nil
        end
    end
end

-- sortiert die gegenstaende nach der einstellung
function LmBagSort.Engine.sortItems(items)

    -- alle items durchgehen und sortieren
    for slot, item in pairs(items) do

        -- pruefen ob item gelockt ist
        if LmUtils.tableHasValue(itemLockMove, item) then

            -- ja item gefunden und gelockt. item entfernen aber keinen
            -- slot zum verschieben finden
            table.remove(itemLockMove, LmUtils.findTableKey(itemLockMove, item))

            -- item slot lock wieder frei machen
            itemLockSlot[item] = nil
            itemLockSlotTime[item] = nil

            -- zum naechsten item
            goto sortItemContinue
        end

        -- kategorie des gegenstandes finden
        local itemDetails = Inspect.Item.Detail(item)
        local category = itemDetails.category

        -- nun mit der kategorie einen taschenplatz finden
        local slotDestination = LmBagSort.Engine.getBagSlotByCategory(category)

        -- fuer den gegenstand wurde ein slot gefunden
        -- also verschieben
        if slotDestination then

            -- slot zunaechst sperren
            itemLockSlot[item] = slotDestination
            itemLockSlotTime[item] = Inspect.Time.Server()

            -- gegenstand zum slot verschieben
            Command.Item.Move(slot, slotDestination)

            -- zum lock hinzufuegen
            table.insert(itemLockMove, item)
        end

        ::sortItemContinue::

    end

end

-- sucht den naechst besten taschenplatz via kategorie heraus
function LmBagSort.Engine.getBagSlotByCategory(itemCategory)

    -- moeglischen taschen anlegen
    local possibleBags = {}

    -- erstmal gucken in welchen taschen der gegenstand platziert werden
    -- kann. nach priotitaet vorgehen.
    for bag, categories in pairs(LmBagSort.Options) do

        -- kategorie vorhanden?
        local availableCategories = LmUtils.getTableKeys(categories)
        local categoryFound = nil

        -- kategorie des items vorhanden?
        for k, category in pairs(availableCategories) do

            -- nun via regexp pruefen
            for kr, regexp in pairs(LmBagSort.Misc.Categories[category]) do

                -- treffer?
                if string.match(itemCategory, regexp) then

                    -- ja!
                    categoryFound = category
                    goto category_found
                end
            end
            
        end

        ::category_found::

        if categoryFound ~= nil then

            -- ja! mit prioritaet hinzufuegen
            local priority = categories[categoryFound].priority
            possibleBags[tonumber(priority)] = {
                bag = bag,
                direction = categories[categoryFound].direction
            }
        end
    end

    -- gibt es moegliche taschenplaetze? wenn nicht abbrechen
    if LmUtils.tableLength(possibleBags) == 0 then return nil end

    -- ja, nun pruefen ob noch freie plaetzt vorhanden sind
    local priority, settings = next(possibleBags, nil)
    while priority do

        -- versuchen einen taschenplatz zu organisieren
        local slot = LmBagSort.Engine.getFreeSlotForBagAndDirection(settings.bag, settings.direction)

        -- wenn slot vorhanden dann diesen zurueckgeben
        if slot then return slot end

        -- sonst mit naechster prioritaet suchen
        priority, settings = next(possibleBags, priority)
    end

    -- nix gefunden...
    return nil

end

-- gibt einen taschenplatz zurueck
function LmBagSort.Engine.getFreeSlotForBagAndDirection(bag, direction)

    -- wenn direction nicht gesetz ist dann ist von TOP auszugehen
    if direction == nil then direction = "TOP" end

    -- slot default
    local slot = nil

    -- evtl ist kein platz mehr in der tasche    
    local slotNumberInBag = LmBagSort.Engine.getNextFreeItemSlot(bag, direction)
    
    -- taschenplatz anfragen
    if slotNumberInBag then

        slot = Utility.Item.Slot.Inventory(LmBagSort.Engine.getBagNumberFromId(bag), slotNumberInBag)
    end

    -- kein platz gefunden (alle taschen voll oder keine einstellung)
    return slot;

end

-- gibt den taschenplatz in numerischer form zurueck
function LmBagSort.Engine.getBagNumberFromId(bagId)

    -- aus dem cache die nummer holen
    return tonumber(LmUtils.findTableKey(LmBagSort.Misc.Bags, bagId))
end

-- naechsten freien taschenplatz
function LmBagSort.Engine.getNextFreeItemSlot(bag, direction)

    -- alle items holen
    local items = Inspect.Item.List()
    local invStack = {}

    for itemBag, item in pairs(items) do

        -- stimmt die tasche?
        local type, number = Utility.Item.Slot.Parse(itemBag)
        if type == "inventory" and number == LmBagSort.Engine.getBagNumberFromId(bag) then

            -- ja tasche passt
            if item == false then

                -- platz zurueckgeben
                local _, __, number = Utility.Item.Slot.Parse(itemBag)

                -- gucken ob der slot blockiert ist
                if not LmUtils.tableHasValue(itemLockSlot, itemBag) then
                
                    -- ist nicht geblockt. moeglichen slot hinzufuegen
                    table.insert(invStack, number)
                end
            end
        end
    end

    -- moegliche slots vorhanden?
    if LmUtils.tableLength(invStack) == 0 then return end

    -- nun slot zurueckgeben
    if direction == "TOP" then

        -- ersten freien platz zurueckgeben
        return math.min(unpack(invStack))
    else

        -- letzten platz zurueckgeben
        return math.max(unpack(invStack))
    end

end