-- componente
LmUI.registerComponent("LmSelectBox", "selectBox")

-- event fuer das aendern eines wertes hinzufuegen
local changeEventCaller, changeEventHandle = Utility.Event.Create(LmUI.Addon.identifier, "LmSelectBox.ChangeSelected")

-- selectbox
function LmUI.Components.Registred.LmSelectBox:initialize(context)

    -- variablen
    local selectBox

    -- frame erzeugen
    selectBox = UI.CreateFrame("Mask", LmUI.Addon.identifier .. ".LmSelectBox", context)
    selectBox.selectBoxBgTexture = UI.CreateFrame("Texture", LmUI.Addon.identifier .. ".LmSelectBox.Bg", context)
    selectBox.selectBoxBtnTexture = UI.CreateFrame("Texture", LmUI.Addon.identifier .. ".LmSelectBox.Btn", context)
    selectBox.selectBoxDropdownList = UI.CreateFrame("Texture", LmUI.Addon.identifier .. ".LmSelectBox.Dropdown", context)

    -- punkte und texturen
    selectBox.selectBoxBgTexture:SetPoint("TOPLEFT", selectBox, "TOPLEFT")
    selectBox.selectBoxBgTexture:SetTexture("Rift", "mini_healthbar_bg.png.dds")
    selectBox.selectBoxBgTexture:SetLayer(1)
    selectBox.selectBoxBtnTexture:SetPoint("TOPRIGHT", selectBox, "TOPRIGHT", -5, 0)
    selectBox.selectBoxBtnTexture:SetTexture("Rift", "scrollvert_chat_pgdwn_(normal).png.dds")
    selectBox.selectBoxBtnTexture:SetLayer(2)

    selectBox.selectBoxDropdownList:SetPoint("TOPLEFT", selectBox, "BOTTOMLEFT", 0, 0)
    selectBox.selectBoxDropdownList:SetTexture("Rift", "dropdown_list.png.dds")
    selectBox.selectBoxDropdownList:SetLayer(2)
    selectBox.selectBoxDropdownList:SetVisible(false)

    -- hover texture aenderungen
    function selectBox.selectBoxBtnTexture.Event:MouseIn() selectBox.selectBoxBtnTexture:SetTexture("Rift", "scrollvert_chat_pgdwn_(over).png.dds") end
    function selectBox.selectBoxBtnTexture.Event:MouseOut() selectBox.selectBoxBtnTexture:SetTexture("Rift", "scrollvert_chat_pgdwn_(normal).png.dds") end
    function selectBox.selectBoxBtnTexture.Event:LeftDown() selectBox.selectBoxBtnTexture:SetTexture("Rift", "scrollvert_chat_pgdwn_(click).png.dds") end
    function selectBox.selectBoxBtnTexture.Event:LeftUp() selectBox.selectBoxBtnTexture:SetTexture("Rift", "scrollvert_chat_pgdwn_(over).png.dds") end
    function selectBox.selectBoxBtnTexture.Event:LeftUpoutside() selectBox.selectBoxBtnTexture:SetTexture("Rift", "scrollvert_chat_pgdwn_(normal).png.dds") end

    -- funktionen erzeugen
    return LmUI.Components.Registred.LmSelectBox:registerEvents(selectBox):update()

end

--Mail_AttachmentHousing.png.dds

-- checkbox bg
-- Minion_I57.dds
-- mini_healthbar_bg.png.dds
-- QuestStickies_I11F.dds
-- raid_slot_filled.png.dds
-- scrollvert_chat_pgdwn_(normal).png.dds
-- SoulTree_I11D.dds

-- drop_down_(normal)02.png.dds
-- dropdown_list.png.dds