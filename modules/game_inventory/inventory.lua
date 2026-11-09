-- chunkname: @/game_inventory/inventory.lua
local updateQuickLootIconPosition -- forward declaration (used before its declaration in the decompiled file)

local iconTopMenu
local inventoryShrink = false
local itemSlotsWithDuration = {}
local updateSlotsDurationEvent
local DURATION_UPDATE_INTERVAL = 1000
local pvpModeRadioGroup
local SHIELD_MIRROR_OPACITY = 0.6

local function getInventoryUi()
	if inventoryShrink then
		return inventoryController.ui.offPanel
	end

	return inventoryController.ui.onPanel
end

local getSlotPanelBySlot = {
	[InventorySlotHead] = function(ui)
		return ui.helmet, ui.helmet.helmet
	end,
	[InventorySlotNeck] = function(ui)
		return ui.amulet, ui.amulet.amulet
	end,
	[InventorySlotBack] = function(ui)
		return ui.backpack, ui.backpack.backpack
	end,
	[InventorySlotBody] = function(ui)
		return ui.armor, ui.armor.armor
	end,
	[InventorySlotRight] = function(ui)
		return ui.shield, ui.shield.shield
	end,
	[InventorySlotLeft] = function(ui)
		return ui.sword, ui.sword.sword
	end,
	[InventorySlotLeg] = function(ui)
		return ui.legs, ui.legs.legs
	end,
	[InventorySlotFeet] = function(ui)
		return ui.boots, ui.boots.boots
	end,
	[InventorySlotFinger] = function(ui)
		return ui.ring, ui.ring.ring
	end,
	[InventorySlotAmmo] = function(ui)
		return ui.tools, ui.tools.tools
	end
}

local function inventoryItemIsDualWielding(item)
	if not item then
		return false
	end

	local tt = g_things.getThingType(item:getId(), ThingCategoryItem)

	return tt and tt:isDualWielding()
end

local function inventoryItemIsQuiver(item)
	if not item then
		return false
	end

	if item.isQuiver then
		return item:isQuiver()
	end

	local md = item:getMarketData()

	return md and MarketCategory and md.category == MarketCategory.Quivers
end

local function countQuiverAmmoInContainer(container)
	local total = 0

	for slot = 0, container:getCapacity() - 1 do
		local slotItem = container:getItem(slot)

		if slotItem then
			total = total + slotItem:getCount()
		end
	end

	return total
end

local function refreshEquippedQuiverSlotDisplay(quiver)
	if inventoryShrink or not quiver then
		return
	end

	local ui = getInventoryUi()
	local getSlotInfo = getSlotPanelBySlot[InventorySlotRight]

	if not getSlotInfo then
		return
	end

	local slotPanel = getSlotInfo(ui)

	if slotPanel and slotPanel.item then
		slotPanel.item:setItem(quiver)
		updateQuickLootIconPosition(slotPanel.item, quiver)
	end
end

updateQuickLootIconPosition = function(itemWidget, item)
	if not itemWidget then
		return
	end

	local icon = itemWidget.quickloot or itemWidget:getChildById("quickloot")

	if not icon then
		return
	end

	local show = false

	if item and item:isContainer() then
		show = item:getQuickLootFlags() ~= 0 or item:getObtainLootFlags() ~= 0
	end

	if show then
		if item and item:isQuiver() and item:getQuiverAmmoCount() > 0 then
			icon:breakAnchors()
			icon:addAnchor(AnchorTop, "parent", AnchorTop)
			icon:addAnchor(AnchorRight, "parent", AnchorRight)
			icon:setMarginTop(1)
			icon:setMarginBottom(0)
		else
			icon:breakAnchors()
			icon:addAnchor(AnchorBottom, "parent", AnchorBottom)
			icon:addAnchor(AnchorRight, "parent", AnchorRight)
			icon:setMarginTop(0)
			icon:setMarginBottom(1)
		end
	end
end

local function syncEquippedQuiverAmmoFromContainer(container)
	if not g_game.getFeature(GameThingQuiver) or not container then
		return
	end

	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local quiver = player:getInventoryItem(InventorySlotRight)

	if not quiver or not inventoryItemIsQuiver(quiver) then
		return
	end

	local containerItem = container:getContainerItem()

	if containerItem ~= quiver then
		return
	end

	if quiver.setQuiverAmmoCount then
		quiver:setQuiverAmmoCount(countQuiverAmmoInContainer(container))
	end

	refreshEquippedQuiverSlotDisplay(quiver)
end

local function onEquippedQuiverContainerChange(container)
	syncEquippedQuiverAmmoFromContainer(container)
end

local function stopEvent()
	if updateSlotsDurationEvent then
		removeEvent(updateSlotsDurationEvent)

		updateSlotsDurationEvent = nil
	end
end

local function updateSlotsDuration()
	if not g_game.isOnline() or next(itemSlotsWithDuration) == nil then
		stopEvent()

		return
	end

	if not modules.client_options.getOption("showExpiryInInvetory") then
		stopEvent()

		local ui = getInventoryUi()

		for slot, itemDurationReg in pairs(itemSlotsWithDuration) do
			local getSlotInfo = getSlotPanelBySlot[slot]

			if getSlotInfo then
				local slotPanel = getSlotInfo(ui)

				if slotPanel and slotPanel.item then
					slotPanel.item.duration:setText("")
				end
			end
		end

		return
	end

	local currTime = g_clock.seconds()
	local ui = getInventoryUi()
	local hasItemsWithDuration = false

	for slot, itemDurationReg in pairs(itemSlotsWithDuration) do
		local item = itemDurationReg.item

		if item and item:getDurationTime() > 0 then
			if ItemsDatabase.shouldHideExpiryForUnusedItem(item) then
				local getSlotInfo = getSlotPanelBySlot[slot]

				if getSlotInfo then
					local slotPanel = getSlotInfo(ui)

					if slotPanel and slotPanel.item then
						slotPanel.item.duration:setText("")
					end
				end
			else
				hasItemsWithDuration = true

				local durationTimeLeft = math.max(0, itemDurationReg.timeEnd - currTime)
				local getSlotInfo = getSlotPanelBySlot[slot]

				if getSlotInfo then
					local slotPanel = getSlotInfo(ui)

					if slotPanel and slotPanel.item then
						slotPanel.item.duration:setText(formatItemDuration(durationTimeLeft))
					end
				end
			end
		end
	end

	if hasItemsWithDuration then
		updateSlotsDurationEvent = scheduleEvent(updateSlotsDuration, DURATION_UPDATE_INTERVAL)
	else
		stopEvent()
	end
end

local function walkEvent()
	if modules.client_options.getOption("autoChaseOff") and g_game.isAttacking() and g_game.getChaseMode() == ChaseOpponent then
		selectPosture("stand", false)
	end
end

local syncCombatControlsUi

local function combatEvent()
	if g_game.getChaseMode() == ChaseOpponent then
		selectPosture("follow", true)
	else
		selectPosture("stand", true)
	end

	syncCombatControlsUi()
end

local function inventoryEvent(player, slot, item, oldItem)
	if inventoryShrink then
		return
	end

	local ui = getInventoryUi()
	local getSlotInfo = getSlotPanelBySlot[slot]

	if not getSlotInfo then
		return
	end

	local slotPanel, toggler = getSlotInfo(ui)
	local displayItem = item
	local mirrorShieldSlot = false

	if slot == InventorySlotRight and not item and player and g_game.isOnline() then
		local leftItem = player:getInventoryItem(InventorySlotLeft)

		if leftItem and inventoryItemIsDualWielding(leftItem) then
			displayItem = leftItem:clone()
			mirrorShieldSlot = true
		end
	end

	slotPanel.item:setItem(displayItem)
	slotPanel.item:setMirrorHorizontal(mirrorShieldSlot)

	if slot == InventorySlotRight then
		if mirrorShieldSlot then
			slotPanel:setOpacity(SHIELD_MIRROR_OPACITY)
			slotPanel.item:setOpacity(SHIELD_MIRROR_OPACITY)
		else
			slotPanel:setOpacity(1)
			slotPanel.item:setOpacity(1)
		end
	end

	toggler:setEnabled(not item and not mirrorShieldSlot)
	slotPanel.item:setWidth(34)
	slotPanel.item:setHeight(34)
	slotPanel.item.duration:setText("")
	slotPanel.item.charges:setText("")

	if g_game.getFeature(GameThingClock) then
		if item and item:getDurationTime() > 0 and not ItemsDatabase.shouldHideExpiryForUnusedItem(item) then
			if not itemSlotsWithDuration[slot] or itemSlotsWithDuration[slot].item ~= item then
				itemSlotsWithDuration[slot] = {
					item = item,
					timeEnd = g_clock.seconds() + item:getDurationTime()
				}
			end

			if modules.client_options.getOption("showExpiryInInvetory") then
				if updateSlotsDurationEvent then
					stopEvent(updateSlotsDurationEvent)

					updateSlotsDurationEvent = nil
				end

				updateSlotsDuration()
			end
		else
			itemSlotsWithDuration[slot] = nil
		end
	end

	if modules.client_options.getOption("showExpiryInInvetory") then
		ItemsDatabase.setCharges(slotPanel.item, item)
	end

	ItemsDatabase.setTier(slotPanel.item, mirrorShieldSlot and displayItem or item)

	if slot == InventorySlotRight and item and inventoryItemIsQuiver(item) and not mirrorShieldSlot then
		for _, container in pairs(g_game.getContainers()) do
			if container and container:getContainerItem() == item then
				syncEquippedQuiverAmmoFromContainer(container)

				break
			end
		end
	end

	if slot == InventorySlotRight then
		updateQuickLootIconPosition(slotPanel.item, item)
	end

	if slot == InventorySlotLeft and player and g_game.isOnline() then
		inventoryEvent(player, InventorySlotRight, player:getInventoryItem(InventorySlotRight))
	end
end

local function bindPlayerInventory()
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	disconnect(player, {
		onInventoryChange = inventoryEvent
	})
	connect(player, {
		onInventoryChange = inventoryEvent
	})
end

local function setCapacityLabel(capacityLabel, player, rawFreeCapacity, formattedFreeCapacity)
	if not capacityLabel then
		return
	end

	capacityLabel:setText(formattedFreeCapacity)

	if rawFreeCapacity == 0 then
		capacityLabel:setColor("#d33c3c")
	elseif player:getTotalCapacity() > player:getBaseCapacity() then
		capacityLabel:setColor("#44ad25")
	else
		capacityLabel:setColor("#c0c0c0")
	end
end

local function onSoulChange(localPlayer, soul)
	if not localPlayer or not soul then
		return
	end

	local onPanel = inventoryController.ui.onPanel
	local offPanel = inventoryController.ui.offPanel

	if onPanel.soulPanel and onPanel.soulPanel.soul then
		onPanel.soulPanel.soul:setText(soul)
	end

	if offPanel.soulAndCapacity and offPanel.soulAndCapacity.soul then
		offPanel.soulAndCapacity.soul:setText(soul)
	end
end

local function onFreeCapacityChange(player, freeCapacity)
	if not player or not freeCapacity then
		return
	end

	local rawFreeCapacity = freeCapacity
	local formattedFreeCapacity = formatFreeCapacity(freeCapacity)
	local onPanel = inventoryController.ui.onPanel
	local offPanel = inventoryController.ui.offPanel

	if onPanel.capacityPanel and onPanel.capacityPanel.capacity then
		setCapacityLabel(onPanel.capacityPanel.capacity, player, rawFreeCapacity, formattedFreeCapacity)
	end

	if offPanel.soulAndCapacity and offPanel.soulAndCapacity.capacity then
		setCapacityLabel(offPanel.soulAndCapacity.capacity, player, rawFreeCapacity, formattedFreeCapacity)
	end
end

local function onCapacityStatsChange(player)
	if not player then
		return
	end

	onFreeCapacityChange(player, player:getFreeCapacity())
end

local BLESSING_BUTTON_IMAGES = {
	[2] = "/images/inventory/button_blessings_gold",
	[3] = "/images/inventory/button_blessings_green"
}

local cachedBlessingsBitmask = 0
local lastBlessRequestTime = 0

local function buildBlessingsTooltip(blessings, status)
	blessings = tonumber(blessings) or 0
	status = tonumber(status) or 0

	-- Fallback caso o bitmask ainda não tenha sido recebido (blessings <= 1)
	if blessings <= 1 then
		if status == 3 then
			-- Todas as 8 blessings
			blessings = 510
		elseif status == 2 then
			-- As 5 blessings regulares
			blessings = 124
		else
			return "You are not protected by any blessings."
		end
	end

	local list = {}

	-- Twist of Fate (PvP) - bit 1 (valor 2)
	if bit.band(blessings, 2) ~= 0 then
		table.insert(list, "Twist of Fate")
	end

	-- The Wisdom of Solitude - bit 2 (valor 4)
	if bit.band(blessings, 4) ~= 0 then
		table.insert(list, "The Wisdom of Solitude")
	end

	-- The Spark of the Phoenix - bit 3 (valor 8)
	if bit.band(blessings, 8) ~= 0 then
		table.insert(list, "The Spark of the Phoenix")
	end

	-- The Fire of the Suns - bit 4 (valor 16)
	if bit.band(blessings, 16) ~= 0 then
		table.insert(list, "The Fire of the Suns")
	end

	-- The Spiritual Shielding - bit 5 (valor 32)
	if bit.band(blessings, 32) ~= 0 then
		table.insert(list, "The Spiritual Shielding")
	end

	-- The Embrace of Tibia - bit 6 (valor 64)
	if bit.band(blessings, 64) ~= 0 then
		table.insert(list, "The Embrace of Tibia")
	end

	-- Heart of the Mountain - bit 7 (valor 128)
	if bit.band(blessings, 128) ~= 0 then
		table.insert(list, "Heart of the Mountain")
	end

	-- Blood of the Mountain - bit 8 (valor 256)
	if bit.band(blessings, 256) ~= 0 then
		table.insert(list, "Blood of the Mountain")
	end

	-- Adventurer's Blessing - bit 0 (valor 1)
	if bit.band(blessings, 1) ~= 0 then
		table.insert(list, "Adventurer's Blessing")
	end

	if #list == 0 then
		return "You are not protected by any blessings."
	end

	return "You are protected by the following blessings:\n" .. table.concat(list, "\n")
end

local function applyBlessingsIcon(status, tooltip)
	local image = BLESSING_BUTTON_IMAGES[status] or "/images/inventory/button_blessings_grey"
	local buttons = {
		inventoryController.ui.onPanel.blessings,
		inventoryController.ui.offPanel.blessings
	}

	for _, button in ipairs(buttons) do
		if button then
			if tooltip then
				button:setTooltip(tooltip)
			end

			button:setImageSource(image)
		end
	end
end

function updateBlessingsData(bitmask)
	cachedBlessingsBitmask = tonumber(bitmask) or 0
	local player = g_game.getLocalPlayer()
	local status = 0
	if player then
		if player.getBlessVisualState then
			status = player:getBlessVisualState()
		end
		if (not status or status == 0) and player.getBlessingsIconColor then
			status = player:getBlessingsIconColor()
		end
	end
	applyBlessingsIcon(status, buildBlessingsTooltip(cachedBlessingsBitmask, status))
end

local function setupBlessingsButtonHover(button)
	if not button then
		return
	end

	connect(button, {
		onHoverChange = function(widget, hovered)
			if hovered then
				local now = g_clock.millis()
				if now - lastBlessRequestTime > 1500 then
					lastBlessRequestTime = now
					if modules.game_blessing and modules.game_blessing.requestBlessingsSilent then
						modules.game_blessing.requestBlessingsSilent()
					end
				end

				local player = g_game.getLocalPlayer()
				if player then
					local blessings = cachedBlessingsBitmask
					if not blessings or blessings <= 0 then
						blessings = player:getBlessings()
					end
					local status = player.getBlessVisualState and player:getBlessVisualState() or (player.getBlessingsIconColor and player:getBlessingsIconColor()) or 0
					widget:setTooltip(buildBlessingsTooltip(blessings, status))
				end
			end
		end
	})
end

local function onBlessingsChange(player, blessings, oldBlessings, blessVisualState)
	if not player then
		return
	end

	local hasAdventurerBlessing = Bit.hasBit(blessings, Blessings.Adventurer) or Bit.hasBit(blessings, 1)

	toggleAdventurerStyle(hasAdventurerBlessing)

	local status = blessVisualState

	if not status or status == 0 then
		if player.getBlessVisualState then
			status = player:getBlessVisualState()
		end
		if not status or status == 0 and player.getBlessingsIconColor then
			status = player:getBlessingsIconColor()
		end
	end

	if blessings and blessings > 1 then
		cachedBlessingsBitmask = blessings
	end

	if modules.game_blessing and modules.game_blessing.requestBlessingsSilent then
		modules.game_blessing.requestBlessingsSilent()
	end

	local effectiveBlessings = cachedBlessingsBitmask
	if not effectiveBlessings or effectiveBlessings <= 0 then
		effectiveBlessings = blessings
	end

	applyBlessingsIcon(status, buildBlessingsTooltip(effectiveBlessings, status))
end

function getIconsPanelOn()
	return inventoryController.ui.onPanel.icons
end

function getIconsPanelOff()
	return inventoryController.ui.offPanel.icons
end

local function applyAdventurerStyleToPanel(panel, hasBlessing)
	if not panel then
		return
	end

	for slot = InventorySlotFirst, InventorySlotLast do
		local itemWidget = panel:getChildById(InventoryNameById[slot])

		if itemWidget then
			local goldenBorder = itemWidget:getChildById("goldenBorder")

			if goldenBorder then
				goldenBorder:setVisible(hasBlessing)
			end
		end
	end
end

function toggleAdventurerStyle(hasBlessing)
	applyAdventurerStyleToPanel(inventoryController.ui.onPanel, hasBlessing)
	applyAdventurerStyleToPanel(inventoryController.ui.offPanel, hasBlessing)
end

local function refreshInventory_panel()
	local player = g_game.getLocalPlayer()

	if player then
		onSoulChange(player, player:getSoul())
		onFreeCapacityChange(player, player:getFreeCapacity())
		onBlessingsChange(player, player:getBlessings(), 0, player.getBlessVisualState and player:getBlessVisualState() or 0)
	end

	if inventoryShrink then
		return
	end

	for i = InventorySlotFirst, InventorySlotPurse do
		if g_game.isOnline() then
			inventoryEvent(player, i, player:getInventoryItem(i))
		else
			inventoryEvent(player, i, nil)
		end
	end
end

local EXPERT_PVP_BOX_IDS = {
	"whiteDoveBox",
	"whiteHandBox",
	"yellowHandBox",
	"redFistBox"
}
local BOX_ID_BY_PVP_MODE = {
	[PVPWhiteDove] = "whiteDoveBox",
	[PVPWhiteHand] = "whiteHandBox",
	[PVPYellowHand] = "yellowHandBox",
	[PVPRedFist] = "redFistBox"
}

local function getExpertPvpPanel()
	if inventoryShrink then
		return inventoryController.ui.offPanel
	end

	return inventoryController.ui.onPanel
end

function syncCombatControlsUi()
	local secureOn = g_game.isSafeFight()

	inventoryController.ui.onPanel.pvp:setChecked(not secureOn)
	inventoryController.ui.offPanel.pvp:setChecked(not secureOn)

	if g_game.getFeature(GamePVPMode) and pvpModeRadioGroup then
		local boxId = BOX_ID_BY_PVP_MODE[g_game.getPVPMode()]
		local panel = getExpertPvpPanel()

		if boxId and panel[boxId] then
			pvpModeRadioGroup:selectWidget(panel[boxId], true)
		end
	end
end

local function bindPvpModeRadioGroup()
	if pvpModeRadioGroup then
		disconnect(pvpModeRadioGroup, {
			onSelectionChange = onSetPVPMode
		})
		pvpModeRadioGroup:destroy()

		pvpModeRadioGroup = nil
	end

	if not g_game.getFeature(GamePVPMode) then
		return
	end

	local panel = getExpertPvpPanel()

	pvpModeRadioGroup = UIRadioGroup.create()

	for _, boxId in ipairs(EXPERT_PVP_BOX_IDS) do
		pvpModeRadioGroup:addWidget(panel[boxId])
	end

	connect(pvpModeRadioGroup, {
		onSelectionChange = onSetPVPMode
	})

	if g_game.isOnline() then
		local boxId = BOX_ID_BY_PVP_MODE[g_game.getPVPMode()]

		if boxId and panel[boxId] then
			pvpModeRadioGroup:selectWidget(panel[boxId])
		end
	end
end

local function setExpertPvpBoxesVisible(panel, visible)
	if not panel then
		return
	end

	for _, boxId in ipairs(EXPERT_PVP_BOX_IDS) do
		local box = panel[boxId]

		if box then
			box:setVisible(visible)
		end
	end
end

local function refreshExpertPvpLayout()
	if not g_game.getExpertPvpMode() then
		return
	end

	local onPanel = inventoryController.ui.onPanel
	local offPanel = inventoryController.ui.offPanel
	local checked = onPanel.expert:isChecked()

	setExpertPvpBoxesVisible(onPanel, checked and not inventoryShrink)
	setExpertPvpBoxesVisible(offPanel, checked and inventoryShrink)
end

local function syncExpertWidgets(checked, sourceWidget)
	local onPanel = inventoryController.ui.onPanel
	local offPanel = inventoryController.ui.offPanel

	if sourceWidget ~= onPanel.expert and onPanel.expert:isChecked() ~= checked then
		onPanel.expert:setChecked(checked)
	end

	if sourceWidget ~= offPanel.expert and offPanel.expert:isChecked() ~= checked then
		offPanel.expert:setChecked(checked)
	end
end

local function refreshInventorySizes()
	if inventoryShrink then
		inventoryController.ui:setOn(false)
		inventoryController.ui.onPanel:hide()
		inventoryController.ui.offPanel:show()
	else
		inventoryController.ui:setOn(true)
		inventoryController.ui.onPanel:show()
		inventoryController.ui.offPanel:hide()
		refreshInventory_panel()
	end

	refreshExpertPvpLayout()
	bindPvpModeRadioGroup()
	combatEvent()
	walkEvent()
	modules.game_mainpanel.reloadMainPanelSizes()
end

function onSetChaseMode(self, selectedChaseModeButton)
	if selectedChaseModeButton == nil then
		return
	end

	local buttonId = selectedChaseModeButton:getId()
	local chaseMode

	if buttonId == "followPosture" then
		chaseMode = ChaseOpponent
	else
		chaseMode = DontChase
	end

	g_game.setChaseMode(chaseMode)
end

inventoryController = Controller:new()

inventoryController:setUI("inventory", modules.game_interface.getMainRightPanel())

function inventoryController:onInit()
	refreshInventory_panel()

	local ui = getInventoryUi()

	connect(inventoryController.ui.onPanel.pvp, {
		onCheckChange = onSetSafeFight
	})
	connect(inventoryController.ui.offPanel.pvp, {
		onCheckChange = onSetSafeFight
	})
	connect(inventoryController.ui.onPanel.expert, {
		onCheckChange = expertMode
	})
	connect(inventoryController.ui.offPanel.expert, {
		onCheckChange = expertMode
	})
	inventoryController:registerEvents(LocalPlayer, {
		onSoulChange = onSoulChange,
		onFreeCapacityChange = onFreeCapacityChange,
		onTotalCapacityChange = onCapacityStatsChange,
		onBaseCapacityChange = onCapacityStatsChange,
		onBlessingsChange = onBlessingsChange
	})
end

function inventoryController:onGameStart()
	local player = g_game.getLocalPlayer()

	if player then
		local char = g_game.getCharacterName()
		local lastCombatControls = g_settings.getNode("LastCombatControls")

		if not table.empty(lastCombatControls) and lastCombatControls[char] then
			g_game.setSafeFight(lastCombatControls[char].safeFight)

			if lastCombatControls[char].pvpMode then
				g_game.setPVPMode(lastCombatControls[char].pvpMode)
			end
		end
	end

	inventoryController:registerEvents(g_game, {
		onWalk = walkEvent,
		onAutoWalk = walkEvent,
		onChaseModeChange = combatEvent,
		onSafeFightChange = combatEvent,
		onPVPModeChange = combatEvent
	}):execute()

	inventoryShrink = false

	if SidebarPersistence and SidebarPersistence.getSection then
		local panelOptions = SidebarPersistence.getSection("sidebarPanelsOptions")

		if type(panelOptions) == "table" and panelOptions.minimizeInventory ~= nil then
			inventoryShrink = panelOptions.minimizeInventory == true
		end
	end

	refreshInventorySizes()
	refreshInventory_panel()
	setupBlessingsButtonHover(inventoryController.ui.onPanel.blessings)
	setupBlessingsButtonHover(inventoryController.ui.offPanel.blessings)

	local elements = {
		{
			inventoryController.ui.offPanel.blessings,
			inventoryController.ui.onPanel.blessings
		},
		{
			inventoryController.ui.offPanel.expert,
			inventoryController.ui.onPanel.expert
		},
		{
			inventoryController.ui.offPanel.whiteDoveBox,
			inventoryController.ui.onPanel.whiteDoveBox
		},
		{
			inventoryController.ui.offPanel.whiteHandBox,
			inventoryController.ui.onPanel.whiteHandBox
		},
		{
			inventoryController.ui.offPanel.yellowHandBox,
			inventoryController.ui.onPanel.yellowHandBox
		},
		{
			inventoryController.ui.offPanel.redFistBox,
			inventoryController.ui.onPanel.redFistBox
		}
	}
	local showBlessings = g_game.getClientVersion() >= 1000
	local showPVPMode = g_game.getFeature(GamePVPMode)

	for i, elementGroup in ipairs(elements) do
		local show = i == 1 and showBlessings or i > 1 and showPVPMode

		for _, element in ipairs(elementGroup) do
			if show then
				element:show()
			else
				element:hide()
			end
		end
	end

	inventoryController.ui.onPanel.purseButton:setVisible(g_game.getFeature(GamePurseSlot))

	local expertPvpEnabled = g_game.getExpertPvpMode()

	inventoryController.ui.onPanel.expert:setEnabled(expertPvpEnabled)
	inventoryController.ui.offPanel.expert:setEnabled(expertPvpEnabled)

	if not expertPvpEnabled then
		syncExpertWidgets(false)
		setExpertPvpBoxesVisible(inventoryController.ui.onPanel, false)
		setExpertPvpBoxesVisible(inventoryController.ui.offPanel, false)
	else
		refreshExpertPvpLayout()
	end

	bindPlayerInventory()
	addEvent(bindPlayerInventory)
	connect(Container, {
		onOpen = onEquippedQuiverContainerChange,
		onAddItem = onEquippedQuiverContainerChange,
		onUpdateItem = onEquippedQuiverContainerChange,
		onRemoveItem = onEquippedQuiverContainerChange
	})

	if modules.game_blessing and modules.game_blessing.requestBlessingsSilent then
		modules.game_blessing.requestBlessingsSilent()
	end
end

function inventoryController:onGameEnd()
	cachedBlessingsBitmask = 0
	lastBlessRequestTime = 0
	stopEvent()
	toggleAdventurerStyle(false)

	local lp = g_game.getLocalPlayer()

	if lp then
		disconnect(lp, {
			onInventoryChange = inventoryEvent
		})
	end

	disconnect(Container, {
		onOpen = onEquippedQuiverContainerChange,
		onAddItem = onEquippedQuiverContainerChange,
		onUpdateItem = onEquippedQuiverContainerChange,
		onRemoveItem = onEquippedQuiverContainerChange
	})

	local ui = getInventoryUi()

	if ui and ui.helmet then
		ui.helmet:setImageColor("#FFFFFF")
	end

	local lastCombatControls = g_settings.getNode("LastCombatControls")

	lastCombatControls = lastCombatControls or {}

	local player = g_game.getLocalPlayer()

	if player then
		local char = g_game.getCharacterName()

		lastCombatControls[char] = {
			safeFight = g_game.isSafeFight()
		}

		if g_game.getFeature(GamePVPMode) then
			lastCombatControls[char].pvpMode = g_game.getPVPMode()
		end

		g_settings.setNode("LastCombatControls", lastCombatControls)
	end
end

function inventoryController:onTerminate()
	if iconTopMenu then
		iconTopMenu:destroy()

		iconTopMenu = nil
	end

	if pvpModeRadioGroup then
		disconnect(pvpModeRadioGroup, {
			onSelectionChange = onSetPVPMode
		})
		pvpModeRadioGroup:destroy()

		pvpModeRadioGroup = nil
	end
end

function onSetSafeFight(self, checked)
	if not checked then
		inventoryController.ui.onPanel.pvp:setChecked(false)
		inventoryController.ui.offPanel.pvp:setChecked(false)
	else
		inventoryController.ui.onPanel.pvp:setChecked(true)
		inventoryController.ui.offPanel.pvp:setChecked(true)
	end

	g_game.setSafeFight(not checked)

	if not checked then
		g_game.cancelAttack()
	end
end

function selectPosture(key, ignoreUpdate)
	local standSelected = key == "stand"

	for _, panel in ipairs({
		inventoryController.ui.onPanel,
		inventoryController.ui.offPanel
	}) do
		if panel.standPosture then
			panel.standPosture:setOn(standSelected)
			panel.followPosture:setOn(not standSelected)
		end
	end

	if not ignoreUpdate then
		if key == "stand" then
			g_game.setChaseMode(DontChase)
		elseif key == "follow" then
			g_game.setChaseMode(ChaseOpponent)
		end
	end
end

function expertMode(self, checked)
	if not g_game.getExpertPvpMode() then
		return
	end

	local onPanel = inventoryController.ui.onPanel

	if checked == nil then
		checked = not onPanel.expert:isChecked()
	end

	syncExpertWidgets(checked, self)
	refreshExpertPvpLayout()
end

function onSetPVPMode(self, selectedPVPButton)
	if selectedPVPButton == nil then
		return
	end

	local buttonId = selectedPVPButton:getId()
	local pvpMode = PVPWhiteDove

	if buttonId == "whiteDoveBox" then
		pvpMode = PVPWhiteDove
	elseif buttonId == "whiteHandBox" then
		pvpMode = PVPWhiteHand
	elseif buttonId == "yellowHandBox" then
		pvpMode = PVPYellowHand
	elseif buttonId == "redFistBox" then
		pvpMode = PVPRedFist
	end

	g_game.setPVPMode(pvpMode)
end

function getInventoryMinimized()
	return inventoryShrink
end

function setInventoryMinimized(minimized)
	if inventoryShrink == (minimized == true) then
		return
	end

	inventoryShrink = minimized == true

	refreshInventorySizes()

	if modules.game_mainpanel and modules.game_mainpanel.reloadMainPanelSizes then
		modules.game_mainpanel.reloadMainPanelSizes()
	end
end

function getChaseModeEnabled()
	return g_game.getChaseMode() == ChaseOpponent
end

function setChaseModeEnabled(enabled)
	if enabled then
		selectPosture("follow", false)
	else
		selectPosture("stand", false)
	end
end

function changeInventorySize()
	inventoryShrink = not inventoryShrink

	refreshInventorySizes()
	modules.game_mainpanel.reloadMainPanelSizes()

	local player = g_game.getLocalPlayer()

	if player and g_game.isOnline() then
		onFreeCapacityChange(player, player:getFreeCapacity())
		onSoulChange(player, player:getSoul())
		onBlessingsChange(player, player:getBlessings(), 0, player.getBlessVisualState and player:getBlessVisualState() or 0)
	end
end

function getSlot5()
	return inventoryController.ui.onPanel.shield
end

function reloadInventory()
	if modules.client_options.getOption("showExpiryInInvetory") then
		updateSlotsDuration()
	end

	for slot, getSlotInfo in pairs(getSlotPanelBySlot) do
		local ui = getInventoryUi()
		local slotPanel, toggler = getSlotInfo(ui)

		if slotPanel then
			local player = g_game.getLocalPlayer()

			if player then
				inventoryEvent(player, slot, player:getInventoryItem(slot))
			end
		end
	end
end

function extendedView(extendedView)
	if extendedView then
		if not iconTopMenu then
			iconTopMenu = modules.client_topmenu.addTopRightToggleButton("inventory", tr("Show inventory"), "/images/topbuttons/inventory", toggle)

			iconTopMenu:setOn(inventoryController.ui:isVisible())
			inventoryController.ui:setBorderColor("black")
			inventoryController.ui:setBorderWidth(2)
		end
	else
		if iconTopMenu then
			iconTopMenu:destroy()

			iconTopMenu = nil
		end

		inventoryController.ui:setBorderColor("alpha")
		inventoryController.ui:setBorderWidth(0)

		local mainRightPanel = modules.game_interface.getMainRightPanel()

		if not mainRightPanel:hasChild(inventoryController.ui) then
			mainRightPanel:insertChild(3, inventoryController.ui)
		end

		inventoryController.ui:show()
	end

	inventoryController.ui.moveOnlyToMain = not extendedView
end

function toggle()
	if iconTopMenu:isOn() then
		inventoryController.ui:hide()
		iconTopMenu:setOn(false)
	else
		inventoryController.ui:show()
		iconTopMenu:setOn(true)
	end
end

function getLeftSlotItem()
	local itemWidget = inventoryController.ui:getChildById("slot6")

	if not itemWidget then
		return nil
	end

	return itemWidget:getItem()
end

function getWeaponProficiencyHandItem()
	local player = g_game.getLocalPlayer()

	if not player then
		return nil
	end

	local function hasProficiency(it)
		if not it then
			return false
		end

		local ok, pid = pcall(function()
			return it:getProficiencyId()
		end)

		return ok and pid and pid > 0
	end

	for _, slot in ipairs({
		InventorySlotLeft,
		InventorySlotOther,
		InventorySlotRight
	}) do
		local it = player:getInventoryItem(slot)

		if hasProficiency(it) then
			return it
		end
	end

	return nil
end
