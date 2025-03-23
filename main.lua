storage.PallyScripts = storage.PallyScripts or {}
modules.game_bot.contentsPanel.config:setText(g_game.getCharacterName())

-- outfiter

-- darkwings = 3399
local function setoutfit(localp, outfit, oldoutfit)
  if player:getOutfit().type ~= 3634 then
      player:setOutfit({type=3634, addons=7, trail=6, mount=0, wings=0, shader="Full Rainbow", head=114, legs=114,body=114,feet=114})
      player:setInformationColor("teal")
  end
end


modules._G.connect(modules._G.LocalPlayer, {onOutfitChange = setoutfit})

--

local context = modules._G.getfenv()

local tab = context.addTab('PALLY')
context.panel = tab

HTTP.downloadImage("https://i.imgur.com/Jj2LIvh.png", function(data, err)
  context.panel = tab
  context.panel:setImageSource(data)
end)

local DRTYTab = context.tabs:getTab('PALLY')

DRTYTab:setFont('small-9px')
DRTYTab:setColor('darkGray')

DRTYTab.onHoverChange = function(self, hovered, x)
  if hovered then
    self:setColor('yellow')
  else
    self:setColor('darkGray')
  end
end
local configName = modules.game_bot.contentsPanel.config:getCurrentOption().text

local startlbl = UI.Label("--- PALLY SCRIPTS ---")
startlbl:setColor("teal")
startlbl:setFont("caviar-11px-rounded")

storage.PallyScripts.Potion = storage.PallyScripts.Potion or {enabled=false, id=7642, hpPercent=99, mpPercent=99, cooldown=500, realTime=0}
local configPot = storage.PallyScripts.Potion
local StopPotion = 0

local potionUI = setupUI([[
Panel
  id: potPanel
  height: 65

  Label
    id: background1
    anchors.fill: parent
    background-color: black
    opacity: 0.5

  BotItem
    id: potItem
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    size: 50 50

  BotSwitch
    id: pot_macro
    anchors.left: prev.right
    margin-left: 2
    anchors.top: prev.top
    anchors.right: parent.right
    text: POTION
    margin-top: -2

  Label
    id: hp_label
    anchors.left: potItem.right
    margin-left: 5
    text: HP%:
    font: caviar-11px-rounded
    anchors.top: prev.bottom
    margin-top: 5
    text-auto-resize: true

  Label
    id: mp_label
    anchors.left: potItem.right
    margin-left: 5
    text: MP%:
    font: caviar-11px-rounded
    anchors.top: prev.bottom
    margin-top: 5
    text-auto-resize: true

  HorizontalScrollBar
    id: hp_value
    anchors.left: hp_label.right
    margin-left: 5
    anchors.right: parent.right
    anchors.top: hp_label.top
    minimum: 0
    maximum: 100
    step: 1

  HorizontalScrollBar
    id: mp_value
    anchors.left: mp_label.right
    margin-left: 5
    anchors.right: parent.right
    anchors.top: mp_label.top
    minimum: 0
    maximum: 100
    step: 1

]])

potionUI.hp_value.onValueChange = function(self, value)
    potionUI.hp_value.valueLabel:setText(value)
    configPot.hpPercent = value
end
potionUI.mp_value.onValueChange = function(self, value)
    potionUI.mp_value.valueLabel:setText(value)
    configPot.mpPercent = value
end

potionUI.pot_macro.onClick = function(self)
    self:setOn(not self:isOn())
    configPot.enabled = self:isOn()
end

potionUI.potItem.onItemChange = function(self)
    configPot.id = self:getItemId()
end

potionUI.potItem:setItemId(configPot.id)
potionUI.hp_value:setValue(configPot.hpPercent)
potionUI.mp_value:setValue(configPot.mpPercent)

potionUI.hp_value.valueLabel:setOpacity(0.5)
potionUI.mp_value.valueLabel:setOpacity(0.5)

potionUI.pot_macro:setOn(configPot.enabled)


onTalk(function(name, level, mode, text, channelId, pos)
    if not name:lower():find("|") then return end

    local realName = name:lower():split("|")[1]

    if realName ~= g_game.getCharacterName():lower() then return end

    if text:lower():find("aaaah...") then
        configPot.realTime = now + configPot.cooldown
    end
end);
local macro_pot = function()
    if StopPotion > now then return end
    if not configPot.enabled then return end
    if configPot.realTime > now then return end

    if (player:getHealthPercent() <= configPot.hpPercent) or (manapercent() <= configPot.mpPercent) then
        useWith(configPot.id, player)
    end
end

macro(1, macro_pot)


macro(1, "Exura gran san (Heal)", function()
  if player:getHealthPercent() <= 99 then
    say("exura gran san")
  end
end)

-- SD

local sdTimer = 0

autoSd = macro(1, "AUTO_SD", function()
  local target = g_game.getAttackingCreature()
  if not target then return end
  if sdTimer < now then
    useWith(3155, target)
  end
end)

local function isMyMissle(missle)
  local src = missle:getSource()
  if src.x == pos().x and src.y == pos().y then
    return true
  end
  return false
end



onMissle(function(missle)
  if isMyMissle(missle) then
    if missle:getId() == 32 then
      sdTimer = now + 1000
    end
  end
end);

-- (EXEVO MAS SAN) AREA

macro(1, "Exevo Mas San (AREA)", function()
  local target = g_game.getAttackingCreature()
  if not target then return end
  local targetPos = target:getPosition()
  if not targetPos then return end
  local distance = getDistanceBetween(player:getPosition(), targetPos)
  if not distance or distance > 4 then return end
  if autoSd.isOn() then
    if sdTimer > now then
      say("exevo mas san")
    end
  else
    say("exevo mas san")
  end
end)

-- CHANGE RING

local config = {
    ringIdOne = 32664,
    hppercentChange = 70,
    ringIdTwo = 3051
}
UI.Separator()
macro(1, 'Swap Ring', function()
    local checkRing = getFinger();
    if hppercent() <= config.hppercentChange then
        if not checkRing or checkRing:getId() ~= config.ringIdTwo then
            moveToSlot(config.ringIdTwo, SlotFinger)
            if not (StopPotion > now) then
                StopPotion = now + 500
            end
        end
    else
        if not checkRing or checkRing:getId() ~= config.ringIdOne then
            moveToSlot(config.ringIdOne, SlotFinger)
            if not (StopPotion > now) then
                StopPotion = now + 500
            end
        end
    end
end);


-- RUN
UI.Separator()
macro(1, "Utani Hur (Speed)", function()
    if not hasHaste() then
        say("utani hur")
    end
end)
