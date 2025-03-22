storage.PallyScripts = storage.PallyScripts or {}


local context = modules._G.getfenv()

local tab = context.addTab('PALLY')
context.panel = tab

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


HTTP.downloadImage("https://i.imgur.com/Jj2LIvh.png", function(data, err)
    context.panel:setImageSource(data)
end)

local startlbl = UI.Label("--- PALLY SCRIPTS ---")
startlbl:setColor("teal")
startlbl:setFont("caviar-11px-rounded")

storage.PallyScripts.Potion = storage.PallyScripts.Potion or {enabled=false, id=7642, hpPercent=99, mpPercent=99, cooldown=500, realTime=0}
local configPot = storage.PallyScripts.Potion
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

potionUI.potItem:setItemId(configPot.id)

potionUI.hp_value.valueLabel:setOpacity(0.5)
potionUI.mp_value.valueLabel:setOpacity(0.5)
potionUI.hp_value.onValueChange = function(self, value)
    potionUI.hp_value.valueLabel:setText(value)
end
potionUI.mp_value.onValueChange = function(self, value)
    potionUI.mp_value.valueLabel:setText(value)
end