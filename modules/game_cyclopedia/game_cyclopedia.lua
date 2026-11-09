-- chunkname: @/game_cyclopedia/game_cyclopedia.lua

Cyclopedia = {}

local DETAIL_LABEL_COLUMN_WIDTH = 150
local DETAIL_ROW_HEIGHT = 20

local function measureDetailRowHeight(value, valueWidth)
	if not Cyclopedia.detailMeasureLabel then
		Cyclopedia.detailMeasureLabel = g_ui.createWidget("Label", g_ui.getRootWidget())

		Cyclopedia.detailMeasureLabel:setVisible(false)
		Cyclopedia.detailMeasureLabel:setPhantom(true)
	end

	local label = Cyclopedia.detailMeasureLabel

	label:setFont("Verdana Bold-11px-new")
	label:setTextAutoResize(false)
	label:setTextWrap(true)
	label:setWidth(valueWidth)
	label:setText(value or "")

	return math.max(DETAIL_ROW_HEIGHT, label:getTextSize().height + 2)
end

function Cyclopedia.appendDetailKeyValueRow(parent, key, value)
	local row = g_ui.createWidget("UIWidget", parent)

	row:setPhantom(true)

	local parentWidth = parent:getWidth() - parent:getPaddingLeft() - parent:getPaddingRight()

	if parentWidth <= 0 then
		parentWidth = 425
	end

	local valueWidth = parentWidth - DETAIL_LABEL_COLUMN_WIDTH - 8
	local rowHeight = measureDetailRowHeight(value, valueWidth)

	row:setWidth(parentWidth)
	row:setHeight(rowHeight)

	local keyLabel = g_ui.createWidget("Label", row)

	keyLabel:setText(key .. ":")
	keyLabel:setColor("#C0C0C0")
	keyLabel:setFont("Verdana Bold-11px-new")
	keyLabel:setTextAlign(AlignTopRight)
	keyLabel:setTextAutoResize(false)
	keyLabel:setWidth(DETAIL_LABEL_COLUMN_WIDTH)
	keyLabel:setHeight(rowHeight)
	keyLabel:addAnchor(AnchorLeft, "parent", AnchorLeft)
	keyLabel:addAnchor(AnchorTop, "parent", AnchorTop)

	local valueLabel = g_ui.createWidget("Label", row)

	valueLabel:setColor("#C0C0C0")
	valueLabel:setFont("Verdana Bold-11px-new")
	valueLabel:setTextAlign(AlignTopLeft)
	valueLabel:setTextAutoResize(false)
	valueLabel:setWidth(valueWidth)
	valueLabel:setHeight(rowHeight)
	valueLabel:setTextWrap(true)
	valueLabel:setText(value)
	valueLabel:addAnchor(AnchorLeft, "parent", AnchorLeft)
	valueLabel:addAnchor(AnchorTop, "parent", AnchorTop)
	valueLabel:setMarginLeft(DETAIL_LABEL_COLUMN_WIDTH + 8)
end

local OFFENCE_STAT_FONT = "Verdana Bold-11px-new"
local OFFENCE_VALUE_COLUMN_WIDTH = 60
local OFFENCE_STAT_ROW_HEIGHT = 16
local OFFENCE_STAT_COLUMN_GAP = 6
local OFFENCE_SUB_ROW_INDENT = 38
local OFFENCE_CHILD_INDENT = 20

local function formatOffencePercentDisplay(display)
	local absVal = math.abs(display)
	local rounded = math.floor(absVal + 1e-06)
	local isWhole = math.abs(absVal - rounded) < 1e-06
	local formatted

	if isWhole then
		formatted = string.format("%d%%", rounded)
	else
		local numberText = string.format("%.2f", absVal)

		numberText = numberText:gsub("0+$", ""):gsub("%.$", "")
		formatted = numberText .. "%"
	end

	if display > 0 then
		return "+" .. formatted
	elseif display < 0 then
		return "-" .. formatted
	end

	return formatted
end

local function formatOffenceStatValue(value, percent)
	local numericValue = tonumber(value) or 0

	if percent then
		return formatOffencePercentDisplay(numericValue * 100)
	end

	return tostring(numericValue)
end

local function getOffencePanelWidth(parent)
	local parentWidth = parent:getWidth() - parent:getPaddingLeft() - parent:getPaddingRight()

	if parentWidth <= 0 then
		parentWidth = 230
	end

	return parentWidth
end

function Cyclopedia.appendOffenceStatHeaderRow(parent, text, options)
	options = options or {}

	local row = g_ui.createWidget("Label", parent)

	row:setPhantom(true)
	row:setColor("#C0C0C0")
	row:setFont(OFFENCE_STAT_FONT)
	row:setTextAlign(AlignTopLeft)
	row:setTextAutoResize(true)
	row:setText(text or "")

	if options.indent then
		row:setMarginLeft(OFFENCE_SUB_ROW_INDENT)
	end

	if options.marginLeft then
		row:setMarginLeft(options.marginLeft)
	end

	if options.marginTop then
		row:setMarginTop(options.marginTop)
	end

	return row
end

function Cyclopedia.appendOffenceStatPrincipalRow(parent, name, value, options)
	options = options or {}

	local numericValue = tonumber(value) or 0

	if numericValue == 0 and not options.showZero then
		return nil
	end

	local row = g_ui.createWidget("UIWidget", parent)

	row:setPhantom(not options.blessButton)

	local parentWidth = getOffencePanelWidth(parent)

	row:setWidth(parentWidth)
	row:setHeight(options.height or OFFENCE_STAT_ROW_HEIGHT)

	if options.marginLeft then
		row:setMarginLeft(options.marginLeft)
	end

	if options.marginTop then
		row:setMarginTop(options.marginTop)
	end

	local nameLabel = g_ui.createWidget("Label", row)

	nameLabel:setPhantom(true)
	nameLabel:setColor("#C0C0C0")
	nameLabel:setFont(OFFENCE_STAT_FONT)
	nameLabel:setTextAlign(AlignTopLeft)
	nameLabel:setTextAutoResize(true)
	nameLabel:setText(name or "")
	nameLabel:addAnchor(AnchorLeft, "parent", AnchorLeft)
	nameLabel:addAnchor(AnchorTop, "parent", AnchorTop)

	local valueText = options.valueText or formatOffenceStatValue(value, options.percent)
	local valueRightMargin = options.valueMarginRight or 0

	if options.element and Cyclopedia.clientCombat and Cyclopedia.clientCombat[options.element] then
		local iconMarginRight = options.iconMarginRight or -8
		local valueIconGap = options.valueIconGap or 6
		local iconSize = 9
		local icon = g_ui.createWidget("SkillCharacterIcon", row)

		icon:setPhantom(true)
		icon:setMarginTop(2)
		icon:setMarginRight(iconMarginRight)
		icon:addAnchor(AnchorRight, "parent", AnchorRight)

		local element = Cyclopedia.clientCombat[options.element]

		icon:setImageSource(element.path)
		icon:setImageSize({
			width = iconSize,
			height = iconSize
		})

		valueRightMargin = iconMarginRight + iconSize + valueIconGap
	end

	if options.blessButton then
		local buttonMarginRight = options.blessButtonMarginRight or 0
		local button = g_ui.createWidget("CyclopediaBlessButton", row)

		button:addAnchor(AnchorRight, "parent", AnchorRight)
		button:addAnchor(AnchorTop, "parent", AnchorTop)
		button:setMarginTop(options.blessButtonMarginTop or 2)

		if buttonMarginRight ~= 0 then
			button:setMarginRight(buttonMarginRight)
		end

		local blessingImages = {
			[2] = "/images/inventory/button_blessings_gold",
			[3] = "/images/inventory/button_blessings_green"
		}
		local player = g_game.getLocalPlayer()
		local status = player and player.getBlessingsIconColor and player:getBlessingsIconColor() or 0

		button:setImageSource(blessingImages[status] or "/images/inventory/button_blessings_grey")

		function button.onClick()
			if modules.game_blessing and modules.game_blessing.openFromCyclopedia then
				modules.game_blessing.openFromCyclopedia()
			elseif modules.game_blessing and modules.game_blessing.toggle then
				modules.game_blessing.toggle()
			end
		end

		valueRightMargin = buttonMarginRight + 12 + (options.blessButtonGap or 3)
	end

	local valueLabel = g_ui.createWidget("Label", row)

	valueLabel:setPhantom(true)
	valueLabel:setColor(options.color or "#C0C0C0")
	valueLabel:setFont(OFFENCE_STAT_FONT)
	valueLabel:setTextAlign(AlignTopRight)
	valueLabel:setTextAutoResize(true)
	valueLabel:setText(valueText)
	valueLabel:addAnchor(AnchorRight, "parent", AnchorRight)
	valueLabel:addAnchor(AnchorTop, "parent", AnchorTop)

	if valueRightMargin ~= 0 then
		valueLabel:setMarginRight(valueRightMargin)
	end

	return row
end

function Cyclopedia.appendOffenceStatRow(parent, value, description, options)
	options = options or {}

	local numericValue = tonumber(value) or 0

	if numericValue == 0 and not options.showZero then
		return nil
	end

	local row = g_ui.createWidget("UIWidget", parent)

	row:setPhantom(true)

	local parentWidth = getOffencePanelWidth(parent)
	local valueColumnWidth = options.valueColumnWidth or OFFENCE_VALUE_COLUMN_WIDTH
	local descriptionWidth = parentWidth - valueColumnWidth - OFFENCE_STAT_COLUMN_GAP
	local rowHeight = options.height or OFFENCE_STAT_ROW_HEIGHT

	row:setWidth(parentWidth)
	row:setHeight(rowHeight)

	local rowIndent = options.marginLeft

	if rowIndent == nil and options.indent ~= false then
		rowIndent = OFFENCE_SUB_ROW_INDENT
	end

	if rowIndent then
		row:setMarginLeft(rowIndent)
	end

	if options.marginTop then
		row:setMarginTop(options.marginTop)
	end

	local valueText = options.valueText or formatOffenceStatValue(value, options.percent)
	local valueLabel = g_ui.createWidget("Label", row)

	valueLabel:setPhantom(true)
	valueLabel:setColor("#C0C0C0")
	valueLabel:setFont(OFFENCE_STAT_FONT)
	valueLabel:setTextAlign(AlignTopRight)
	valueLabel:setTextAutoResize(false)
	valueLabel:setWidth(valueColumnWidth)
	valueLabel:setHeight(rowHeight)
	valueLabel:setText(valueText)
	valueLabel:addAnchor(AnchorLeft, "parent", AnchorLeft)
	valueLabel:addAnchor(AnchorTop, "parent", AnchorTop)

	local descriptionLabel = g_ui.createWidget("Label", row)

	descriptionLabel:setPhantom(true)
	descriptionLabel:setColor("#C0C0C0")
	descriptionLabel:setFont(OFFENCE_STAT_FONT)
	descriptionLabel:setTextAlign(AlignTopLeft)
	descriptionLabel:setTextAutoResize(false)
	descriptionLabel:setWidth(descriptionWidth)
	descriptionLabel:setHeight(rowHeight)
	descriptionLabel:setText(description or "")
	descriptionLabel:addAnchor(AnchorLeft, "parent", AnchorLeft)
	descriptionLabel:addAnchor(AnchorTop, "parent", AnchorTop)
	descriptionLabel:setMarginLeft(valueColumnWidth + OFFENCE_STAT_COLUMN_GAP + (options.descriptionIndent or 0))

	return row
end

function Cyclopedia.renderOffenceStatBlock(panel, block)
	if not panel or not block then
		return
	end

	local principalValue = block.principal and tonumber(block.principal.value) or 0
	local hasItemValue = false

	for _, item in ipairs(block.items or {}) do
		if (tonumber(item.value) or 0) ~= 0 or item.showZero then
			hasItemValue = true

			break
		end
	end

	local hasTypeItemValue = false

	for _, section in ipairs(block.typeSections or {}) do
		for _, item in ipairs(section.items or {}) do
			if (tonumber(item.value) or 0) ~= 0 then
				hasTypeItemValue = true

				break
			end
		end

		if hasTypeItemValue then
			break
		end
	end

	if block.principal and principalValue == 0 and not hasItemValue and not hasTypeItemValue and not block.header and not block.subheader and not block.principal.showZero then
		return
	end

	if block.header then
		Cyclopedia.appendOffenceStatHeaderRow(panel, block.header, block.headerOptions)
	end

	if block.principal and (principalValue ~= 0 or block.principal.showZero) then
		Cyclopedia.appendOffenceStatPrincipalRow(panel, block.principal.name, block.principal.value, block.principal)
	end

	if block.subheader then
		Cyclopedia.appendOffenceStatHeaderRow(panel, block.subheader, {
			indent = true
		})
	end

	for _, item in ipairs(block.items or {}) do
		Cyclopedia.appendOffenceStatRow(panel, item.value, item.description, {
			marginLeft = item.marginLeft,
			marginTop = item.marginTop,
			percent = item.percent,
			valueText = item.valueText,
			valueColumnWidth = item.valueColumnWidth,
			descriptionIndent = item.descriptionIndent,
			height = item.height,
			indent = item.indent,
			showZero = item.showZero
		})
	end

	for _, section in ipairs(block.typeSections or {}) do
		local hasTypeItem = false

		for _, item in ipairs(section.items or {}) do
			if (tonumber(item.value) or 0) ~= 0 then
				hasTypeItem = true

				break
			end
		end

		if hasTypeItem then
			if section.subheader then
				Cyclopedia.appendOffenceStatHeaderRow(panel, section.subheader, {
					marginLeft = section.marginLeft or OFFENCE_CHILD_INDENT,
					marginTop = section.marginTop
				})
			end

			for _, item in ipairs(section.items or {}) do
				local itemOptions = {
					marginLeft = item.marginLeft or section.itemMarginLeft,
					marginTop = item.marginTop or section.itemMarginTop,
					percent = item.percent,
					valueText = item.valueText,
					valueColumnWidth = item.valueColumnWidth,
					descriptionIndent = item.descriptionIndent,
					height = item.height,
					indent = item.indent,
					showZero = item.showZero
				}

				Cyclopedia.appendOffenceStatRow(panel, item.value, item.description, itemOptions)
			end
		end
	end
end

trackerButton = nil
trackerMiniWindow = nil
trackerButtonBosstiary = nil
trackerMiniWindowBosstiary = nil
contentContainer = nil

local currentCharacter

function Cyclopedia.syncBestiaryTrackerMainPanelButton()
	if not trackerButton or trackerButton:isDestroyed() then
		return
	end

	local on = false

	if trackerMiniWindow and not trackerMiniWindow:isDestroyed() then
		on = trackerMiniWindow:isVisible()
	end

	trackerButton:setOn(on)

	if trackerButton.setTooltip then
		trackerButton:setTooltip(tr(on and "Close Bestiary Tracker Window" or "Open Bestiary Tracker Window"))
	end
end

function Cyclopedia.syncBosstiaryTrackerMainPanelButton()
	if not trackerButtonBosstiary or trackerButtonBosstiary:isDestroyed() then
		return
	end

	local on = false

	if trackerMiniWindowBosstiary and not trackerMiniWindowBosstiary:isDestroyed() then
		on = trackerMiniWindowBosstiary:isVisible()
	end

	trackerButtonBosstiary:setOn(on)

	if trackerButtonBosstiary.setTooltip then
		trackerButtonBosstiary:setTooltip(tr(on and "Close Bosstiary Tracker Window" or "Open Bosstiary Tracker Window"))
	end
end

local buttonSelection, items, bestiary, charms, map, houses, character, CyclopediaButton, bosstiary, bossSlot, ButtonBossSlot, ButtonBestiary
local tabStack = {}
local previousType
local windowTypes = {}
local magicalArchives
local cyclopediaShortcutHighlightActive = false
local bosstiaryShortcutHighlightActive = false
local CLIENT_EVENT_TYPE_BESTIARY = 6
local CLIENT_EVENT_TYPE_BOSSTIARY = 7

local function createShortcutHighlightWidget(button, highlightId, visible)
	if not button or button:isDestroyed() then
		return
	end

	if button:recursiveGetChildById(highlightId) then
		return
	end

	local highlight = g_ui.createWidget("UIWidget", button)

	if not highlight then
		return
	end

	highlight:setId(highlightId)
	highlight:setSize({
		height = 22,
		width = 22
	})
	highlight:setPhantom(true)
	highlight:setClipping(false)
	highlight:setImageSource("/images/animations/button-highlight-22x22")
	highlight:breakAnchors()
	highlight:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
	highlight:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
	highlight:setVisible(visible)
end

local function applyShortcutHighlight(button, highlightId, visible)
	if not button or button:isDestroyed() then
		return
	end

	local highlight = button:recursiveGetChildById(highlightId)

	if highlight then
		highlight:setVisible(visible)
	end
end

local function ensureCyclopediaShortcutHighlightWidget()
	createShortcutHighlightWidget(CyclopediaButton, "cyclopediaShortcutHighlight", cyclopediaShortcutHighlightActive)
end

local function ensureBosstiaryShortcutHighlightWidget()
	createShortcutHighlightWidget(ButtonBestiary, "bosstiaryShortcutHighlight", bosstiaryShortcutHighlightActive)
end

function Cyclopedia.setCyclopediaShortcutHighlightVisible(show)
	cyclopediaShortcutHighlightActive = show == true or show == 1

	applyShortcutHighlight(CyclopediaButton, "cyclopediaShortcutHighlight", cyclopediaShortcutHighlightActive)
end

function Cyclopedia.setBosstiaryShortcutHighlightVisible(show)
	bosstiaryShortcutHighlightActive = show == true or show == 1

	applyShortcutHighlight(ButtonBestiary, "bosstiaryShortcutHighlight", bosstiaryShortcutHighlightActive)
end

function Cyclopedia.clearCyclopediaShortcutHighlight()
	Cyclopedia.setCyclopediaShortcutHighlightVisible(false)
end

function Cyclopedia.clearBosstiaryShortcutHighlight()
	Cyclopedia.setBosstiaryShortcutHighlightVisible(false)
end

function Cyclopedia.clearAllShortcutHighlights()
	Cyclopedia.clearCyclopediaShortcutHighlight()
	Cyclopedia.clearBosstiaryShortcutHighlight()
end

function Cyclopedia.resyncShortcutHighlightWidgets()
	ensureCyclopediaShortcutHighlightWidget()
	ensureBosstiaryShortcutHighlightWidget()
	applyShortcutHighlight(CyclopediaButton, "cyclopediaShortcutHighlight", cyclopediaShortcutHighlightActive)
	applyShortcutHighlight(ButtonBestiary, "bosstiaryShortcutHighlight", bosstiaryShortcutHighlightActive)
end

function Cyclopedia.onBestiaryEntryChanged(raceId)
	raceId = tonumber(raceId)

	if raceId and raceId > 0 then
		Cyclopedia._pendingBestiaryRaceId = raceId
		Cyclopedia._pendingBosstiaryRaceId = nil

		if Cyclopedia.Bestiary then
			if Cyclopedia.Bestiary.CreatureDetailCache then
				Cyclopedia.Bestiary.CreatureDetailCache[raceId] = nil
			end

			Cyclopedia.Bestiary.OverviewCache = nil
			Cyclopedia.Bestiary.CategoriesLoaded = false
			Cyclopedia.Bestiary.CategoriesRequested = false
		end
	end

	Cyclopedia.clearBosstiaryShortcutHighlight()
	Cyclopedia.setCyclopediaShortcutHighlightVisible(true)
end

function Cyclopedia.onBosstiaryEntryChanged(bossId)
	bossId = tonumber(bossId)

	if bossId and bossId > 0 then
		Cyclopedia._pendingBosstiaryRaceId = bossId
		Cyclopedia._pendingBestiaryRaceId = nil
	end

	Cyclopedia.clearCyclopediaShortcutHighlight()
	Cyclopedia.setBosstiaryShortcutHighlightVisible(true)
end

function Cyclopedia.onClientEvent(eventType, ...)
	if eventType == CLIENT_EVENT_TYPE_BESTIARY then
		Cyclopedia.onBestiaryEntryChanged(select(1, ...))
	elseif eventType == CLIENT_EVENT_TYPE_BOSSTIARY then
		Cyclopedia.onBosstiaryEntryChanged(select(1, ...))
	end
end

function Cyclopedia.openFromShortcutButton()
	local window = Cyclopedia._pendingBestiaryRaceId and "bestiary" or "items"

	toggle(window)
end

function Cyclopedia.openBosstiaryFromShortcutButton()
	toggle("bosstiary")
end

local function updateCyclopediaMoneyDisplay()
	if not controllerCyclopedia.ui or not controllerCyclopedia.ui:isVisible() then
		return
	end

	local player = g_game.getLocalPlayer()
	local totalMoney = 0

	if player then
		if player.getTotalMoney then
			totalMoney = player:getTotalMoney() or 0
		else
			local bankMoney = player:getResourceBalance(ResourceBank) or 0
			local inventoryMoney = player:getResourceBalance(ResourceInventary) or 0

			totalMoney = bankMoney + inventoryMoney
		end
	end

	controllerCyclopedia.ui.GoldBase.Value:setText(Cyclopedia.formatGold(totalMoney))
end

function Cyclopedia.onResourceBalance(resourceType)
	updateCyclopediaMoneyDisplay()

	if (resourceType == ResourceBank or resourceType == ResourceInventary) and Cyclopedia.refreshBossSlotsRemoveAffordability then
		Cyclopedia.refreshBossSlotsRemoveAffordability()
	end

	if (not resourceType or resourceType == ResourceTypes.CHARM or resourceType == ResourceTypes.MINOR_CHARM or resourceType == ResourceTypes.MAX_CHARM or resourceType == ResourceTypes.MAX_MINOR_CHARM) and Cyclopedia.updateCharmResourceDisplays then
		Cyclopedia.updateCharmResourceDisplays()
	end

	if Cyclopedia.refreshCharmAffordability then
		Cyclopedia.refreshCharmAffordability()
	end
end

function toggle(defaultWindow)
	if not controllerCyclopedia.ui then
		return
	end

	if controllerCyclopedia.ui:isVisible() then
		return hide()
	end

	show(defaultWindow)
end

controllerCyclopedia = Controller:new()

controllerCyclopedia:setUI("game_cyclopedia")

function controllerCyclopedia:onInit()
	Cyclopedia.storedTrackerData = {}
	Cyclopedia.storedBosstiaryTrackerData = {}

	controllerCyclopedia:registerEvents(g_game, {
		onParseCyclopediaTracker = Cyclopedia.onParseCyclopediaTracker,
		onParseBestiaryRaces = Cyclopedia.loadBestiaryCategories,
		onParseBestiaryOverview = Cyclopedia.loadBestiaryOverview,
		onUpdateBestiaryMonsterData = Cyclopedia.loadBestiarySelectedCreature,
		onBestiaryEntryChanged = Cyclopedia.onBestiaryEntryChanged
	})
	connect(g_things, {
		onLoadDat = Cyclopedia.invalidateItemsIndex
	})
end

function controllerCyclopedia:onGameStart()
	if g_game.getClientVersion() >= 1310 then
		CyclopediaButton = modules.game_mainpanel.addToggleButton("CyclopediaButton", tr("Open Cyclopedia Window"), "/images/options/button_cyclopedia", Cyclopedia.openFromShortcutButton, false, 7)
		ButtonBossSlot = modules.game_mainpanel.addToggleButton("bossSlot", tr("Open Boss Slots Dialog"), "/images/options/button_boss_slot", function()
			toggle("bossSlot")
		end, false, 20)

		CyclopediaButton:setOn(false)

		ButtonBestiary = modules.game_mainpanel.addToggleButton("bosstiary", tr("Open Bosstiary Dialog"), "/images/options/button_bosstiary", Cyclopedia.openBosstiaryFromShortcutButton, false, 17)

		ensureCyclopediaShortcutHighlightWidget()
		ensureBosstiaryShortcutHighlightWidget()

		contentContainer = controllerCyclopedia.ui:recursiveGetChildById("contentContainer")
		buttonSelection = controllerCyclopedia.ui:recursiveGetChildById("buttonSelection")
		items = buttonSelection:recursiveGetChildById("items")
		bestiary = buttonSelection:recursiveGetChildById("bestiary")
		charms = buttonSelection:recursiveGetChildById("charms")
		map = buttonSelection:recursiveGetChildById("map")
		houses = buttonSelection:recursiveGetChildById("houses")
		character = buttonSelection:recursiveGetChildById("character")
		bosstiary = buttonSelection:recursiveGetChildById("bosstiary")
		bossSlot = buttonSelection:recursiveGetChildById("bossSlot")
		magicalArchives = buttonSelection:recursiveGetChildById("magicalArchives")
		windowTypes = {
			items = {
				obj = items,
				func = showItems
			},
			bestiary = {
				obj = bestiary,
				func = showBestiary
			},
			charms = {
				obj = charms,
				func = showCharms
			},
			map = {
				obj = map,
				func = showMap
			},
			houses = {
				obj = houses,
				func = showHouse
			},
			character = {
				obj = character,
				func = showCharacter
			},
			bosstiary = {
				obj = bosstiary,
				func = showBosstiary
			},
			bossSlot = {
				obj = bossSlot,
				func = showBossSlot
			},
			magicalArchives = {
				obj = magicalArchives,
				func = showMagicalArchives
			}
		}

		g_ui.importStyle("cyclopedia_widgets")
		g_ui.importStyle("cyclopedia_pages")
		controllerCyclopedia:registerEvents(g_game, {
			onBosstiaryEntryChanged = Cyclopedia.onBosstiaryEntryChanged,
			onClientEvent = Cyclopedia.onClientEvent,
			onParseSendBosstiary = Cyclopedia.LoadBosstiaryCreatures,
			onParseBosstiarySlots = Cyclopedia.loadBossSlots,
			onParseCyclopediaCharacterGeneralStats = Cyclopedia.loadCharacterGeneralStats,
			onParseCyclopediaCharacterCombatStats = Cyclopedia.loadCharacterCombatStats,
			onParseCyclopediaCharacterBadges = Cyclopedia.loadCharacterBadges,
			onCyclopediaCharacterRecentDeaths = Cyclopedia.loadCharacterRecentDeaths,
			onCyclopediaCharacterRecentKills = Cyclopedia.loadCharacterRecentKills,
			onUpdateCyclopediaCharacterItemSummary = Cyclopedia.loadCharacterItems,
			onParseCyclopediaCharacterAppearances = Cyclopedia.loadCharacterAppearances,
			onParseCyclopediaStoreSummary = Cyclopedia.onParseCyclopediaStoreSummary,
			onParseCyclopediaCharacterAchievements = Cyclopedia.onEngineCharacterAchievements,
			onParseCyclopediaCharacterInspection = Cyclopedia.loadCharacterInspection,
			onParseCyclopediaCharacterTitles = Cyclopedia.onEngineCharacterTitles,
			onPreyActive = Cyclopedia.refreshCharacterPreyIfVisible,
			onPreyInactive = Cyclopedia.refreshCharacterPreyIfVisible,
			onPreyTimeLeft = Cyclopedia.refreshCharacterPreyIfVisible,
			onCyclopediaCharacterOffenceStats = Cyclopedia.onCyclopediaCharacterOffenceStats,
			onCyclopediaCharacterDefenceStats = Cyclopedia.onCyclopediaCharacterDefenceStats,
			onCyclopediaCharacterMiscStats = Cyclopedia.onCyclopediaCharacterMiscStats,
			onResourceBalance = Cyclopedia.onResourceBalance,
			onCyclopediaHouseList = Cyclopedia.onCyclopediaHouseList,
			onCyclopediaHousesInfo = Cyclopedia.onCyclopediaHousesInfo,
			onCyclopediaHouseActionResult = Cyclopedia.onCyclopediaHouseActionResult,
			onUpdateBestiaryCharmsData = Cyclopedia.loadCharms,
			-- our C++ (Game::processItemDetail) sends ONE ItemInspectionData table
			-- {inspectionType, creatureId, name, item, imbuements, descriptions[{key,value}]}
			onParseItemDetail = function(data, legacyDescriptions)
				local itemId, descriptions = data, legacyDescriptions

				if type(data) == "table" then
					itemId = data.item and data.item:getId() or 0
					descriptions = data.descriptions or {}
				end

				if not itemId or itemId == 0 then
					return
				end

				if Cyclopedia.handleCharacterItemDetail(itemId, descriptions) then
					return
				end

				Cyclopedia.loadItemDetail(itemId, descriptions)
			end
		})

		if Cyclopedia.ensureBestiaryCategoriesRequested then
			Cyclopedia.ensureBestiaryCategoriesRequested()
		end

		if not trackerButton then
			trackerButton = modules.game_mainpanel.addToggleButton("trackerButton", tr("Open Bestiary Tracker Window"), "/images/options/button_bestiary_tracker", Cyclopedia.toggleBestiaryTracker, false, 17)
		end

		trackerButton:setOn(false)

		if not trackerMiniWindow then
			trackerMiniWindow = g_ui.createWidget("BestiaryTracker", modules.game_interface.getRightPanel())

			trackerMiniWindow:setId("BestiaryTrackerWindow")

			local titleWidget = trackerMiniWindow:getChildById("miniwindowTitle")

			if titleWidget then
				local title = tr("Bestiary Tracker")

				if title:len() > 12 then
					title = title:sub(1, 12) .. "..."
				end

				titleWidget:setText(title)
			end

			local toggleFilterButton = trackerMiniWindow:recursiveGetChildById("toggleFilterButton")

			if toggleFilterButton then
				toggleFilterButton:setVisible(false)
				toggleFilterButton:setOn(false)
			end

			local contextMenuButton = trackerMiniWindow:recursiveGetChildById("contextMenuButton")
			local newWindowButton = trackerMiniWindow:recursiveGetChildById("newWindowButton")
			local minimizeButton = trackerMiniWindow:recursiveGetChildById("minimizeButton")

			if contextMenuButton then
				contextMenuButton:setVisible(true)

				if minimizeButton then
					contextMenuButton:breakAnchors()
					contextMenuButton:addAnchor(AnchorTop, minimizeButton:getId(), AnchorTop)
					contextMenuButton:addAnchor(AnchorRight, minimizeButton:getId(), AnchorLeft)
					contextMenuButton:setMarginRight(5)
					contextMenuButton:setMarginTop(0)
				end

				function contextMenuButton.onClick(widget, mousePos, mouseButton)
					return Cyclopedia.createTrackerContextMenu("bestiary", mousePos)
				end
			end

			if newWindowButton then
				newWindowButton:setVisible(true)

				function newWindowButton.onClick(widget, mousePos, mouseButton)
					toggle("bestiary")

					return true
				end
			end

			function trackerMiniWindow.onOpen()
				Cyclopedia.syncBestiaryTrackerMainPanelButton()
				Cyclopedia.applyStoredTracker(0)
			end

			function trackerMiniWindow.onClose()
				Cyclopedia.syncBestiaryTrackerMainPanelButton()
			end

			trackerMiniWindow:setup()
			trackerMiniWindow:hide()
		end

		if not trackerButtonBosstiary then
			trackerButtonBosstiary = modules.game_mainpanel.addToggleButton("bosstiarytrackerButton", tr("Open Bosstiary Tracker Window"), "/images/options/button_bosstiary_tracker", Cyclopedia.toggleBosstiaryTracker, false, 17)
		end

		trackerButtonBosstiary:setOn(false)

		if not trackerMiniWindowBosstiary then
			trackerMiniWindowBosstiary = g_ui.createWidget("BestiaryTracker", modules.game_interface.getRightPanel())

			trackerMiniWindowBosstiary:setId("BosstiaryTrackerWindow")

			local titleWidgetBosstiary = trackerMiniWindowBosstiary:getChildById("miniwindowTitle")

			if titleWidgetBosstiary then
				local title = tr("Bosstiary Tracker")

				if title:len() > 12 then
					title = title:sub(1, 12) .. "..."
				end

				titleWidgetBosstiary:setText(title)
				titleWidgetBosstiary:setTextOffset("0 -1")
				titleWidgetBosstiary:setColor("#909090")
			end

			local iconWidgetBosstiary = trackerMiniWindowBosstiary:getChildById("miniwindowIcon")

			if iconWidgetBosstiary then
				iconWidgetBosstiary:setImageSource("/images/icons/icon-bosstiarytracker-widget")
			end

			local toggleFilterButtonBosstiary = trackerMiniWindowBosstiary:recursiveGetChildById("toggleFilterButton")

			if toggleFilterButtonBosstiary then
				toggleFilterButtonBosstiary:setVisible(false)
				toggleFilterButtonBosstiary:setOn(false)
			end

			local contextMenuButtonBosstiary = trackerMiniWindowBosstiary:recursiveGetChildById("contextMenuButton")
			local newWindowButtonBosstiary = trackerMiniWindowBosstiary:recursiveGetChildById("newWindowButton")
			local minimizeButtonBosstiary = trackerMiniWindowBosstiary:recursiveGetChildById("minimizeButton")

			if contextMenuButtonBosstiary then
				contextMenuButtonBosstiary:setVisible(true)

				if minimizeButtonBosstiary then
					contextMenuButtonBosstiary:breakAnchors()
					contextMenuButtonBosstiary:addAnchor(AnchorTop, minimizeButtonBosstiary:getId(), AnchorTop)
					contextMenuButtonBosstiary:addAnchor(AnchorRight, minimizeButtonBosstiary:getId(), AnchorLeft)
					contextMenuButtonBosstiary:setMarginRight(5)
					contextMenuButtonBosstiary:setMarginTop(0)
				end

				function contextMenuButtonBosstiary.onClick(widget, mousePos, mouseButton)
					return Cyclopedia.createTrackerContextMenu("bosstiary", mousePos)
				end
			end

			if newWindowButtonBosstiary then
				newWindowButtonBosstiary:setVisible(true)

				function newWindowButtonBosstiary.onClick(widget, mousePos, mouseButton)
					toggle("bosstiary")

					return true
				end
			end

			function trackerMiniWindowBosstiary.onOpen()
				Cyclopedia.syncBosstiaryTrackerMainPanelButton()
				Cyclopedia.applyStoredTracker(1)
			end

			function trackerMiniWindowBosstiary.onClose()
				Cyclopedia.syncBosstiaryTrackerMainPanelButton()
			end

			trackerMiniWindowBosstiary:setup()
			trackerMiniWindowBosstiary:hide()
		end

		trackerMiniWindow:setupOnStart()
		trackerMiniWindowBosstiary:setupOnStart()
		Cyclopedia.loadTrackerFilters("bestiary")
		Cyclopedia.loadTrackerFilters("bosstiary")

		local char = g_game.getCharacterName()

		if char and #char > 0 then
			if currentCharacter and currentCharacter ~= char then
				Cyclopedia.clearTrackerDataForCharacterChange()
			end

			currentCharacter = char
		end

		if Cyclopedia.loadItemPrices then
			Cyclopedia.loadItemPrices()
		end

		if Cyclopedia.scheduleItemsIndexPreload then
			Cyclopedia.scheduleItemsIndexPreload()
		end

		Cyclopedia.applyStoredTracker(0)
		Cyclopedia.applyStoredTracker(1)
		Cyclopedia.syncBestiaryTrackerMainPanelButton()
		Cyclopedia.syncBosstiaryTrackerMainPanelButton()

		Cyclopedia.BossSlots.UnlockBosses = {}

		Keybind.new("Windows", "Show/hide Bosstiary Tracker", "", "")
		Keybind.bind("Windows", "Show/hide Bosstiary Tracker", {
			{
				type = KEY_DOWN,
				callback = Cyclopedia.toggleBosstiaryTracker
			}
		})
		Keybind.new("Windows", "Show/hide Bestiary Tracker", "", "")
		Keybind.bind("Windows", "Show/hide Bestiary Tracker", {
			{
				type = KEY_DOWN,
				callback = Cyclopedia.toggleBestiaryTracker
			}
		})
	end
end

function controllerCyclopedia:onGameEnd()
	if trackerMiniWindow and trackerMiniWindow.save then
		trackerMiniWindow:saveSelfIndex()

		if trackerMiniWindow:isResizeable() and not trackerMiniWindow:isOn() then
			trackerMiniWindow:setSettings({
				height = trackerMiniWindow:getHeight()
			})
		end
	end

	if trackerMiniWindowBosstiary and trackerMiniWindowBosstiary.save then
		trackerMiniWindowBosstiary:saveSelfIndex()

		if trackerMiniWindowBosstiary:isResizeable() and not trackerMiniWindowBosstiary:isOn() then
			trackerMiniWindowBosstiary:setSettings({
				height = trackerMiniWindowBosstiary:getHeight()
			})
		end
	end

	Cyclopedia.clearAllShortcutHighlights()

	if trackerMiniWindow then
		trackerMiniWindow.contentsPanel:destroyChildren()
	end

	if trackerMiniWindowBosstiary then
		trackerMiniWindowBosstiary.contentsPanel:destroyChildren()
	end

	hide()

	if Cyclopedia.saveTrackerFilters then
		Cyclopedia.saveTrackerFilters("bestiary")
		Cyclopedia.saveTrackerFilters("bosstiary")
	end

	Cyclopedia.storedTrackerData = {}
	Cyclopedia.storedBosstiaryTrackerData = {}
	Cyclopedia.ItemPrices = nil

	if Cyclopedia.invalidateItemsIndex then
		Cyclopedia.invalidateItemsIndex()
	end

	if Cyclopedia.clearBestiaryCachedData then
		Cyclopedia.clearBestiaryCachedData()
	end

	Keybind.delete("Windows", "Show/hide Bosstiary Tracker")
	Keybind.delete("Windows", "Show/hide Bestiary Tracker")
end

function controllerCyclopedia:onTerminate()
	disconnect(g_things, {
		onLoadDat = Cyclopedia.invalidateItemsIndex
	})

	if Cyclopedia.invalidateItemsIndex then
		Cyclopedia.invalidateItemsIndex()
	end

	if trackerButton then
		trackerButton:destroy()

		trackerButton = nil
	end

	if trackerMiniWindow then
		trackerMiniWindow:destroy()

		trackerMiniWindow = nil
	end

	if trackerButtonBosstiary then
		trackerButtonBosstiary:destroy()

		trackerButtonBosstiary = nil
	end

	if trackerMiniWindowBosstiary then
		trackerMiniWindowBosstiary:destroy()

		trackerMiniWindowBosstiary = nil
	end

	if CyclopediaButton then
		CyclopediaButton:destroy()

		CyclopediaButton = nil
	end

	if ButtonBossSlot then
		ButtonBossSlot:destroy()

		ButtonBossSlot = nil
	end

	if ButtonBestiary then
		ButtonBestiary:destroy()

		ButtonBestiary = nil
	end

	currentCharacter = nil

	onTerminateCharm()
end

function hide()
	if not controllerCyclopedia.ui then
		return
	end

	if previousType == "map" then
		if Cyclopedia.disconnectMapPositionEvent then
			Cyclopedia.disconnectMapPositionEvent()
		end

		if Cyclopedia.saveMapConfiguration then
			Cyclopedia.saveMapConfiguration()
		end
	end

	if Cyclopedia.clearItemsUI then
		Cyclopedia.clearItemsUI()
	end

	if Cyclopedia.clearBosstiaryUI then
		Cyclopedia.clearBosstiaryUI()
	end

	if Cyclopedia.clearBossSlotsUI then
		Cyclopedia.clearBossSlotsUI()
	end

	if Cyclopedia.clearMapUI then
		Cyclopedia.clearMapUI()
	end

	if Cyclopedia.clearCharacterUI then
		Cyclopedia.clearCharacterUI()
	end

	if Cyclopedia.clearMagicalArchivesUI then
		Cyclopedia.clearMagicalArchivesUI()
	end

	if Cyclopedia.clearBestiaryUI then
		Cyclopedia.clearBestiaryUI(true)
	end

	onTerminateCharm()
	resetCyclopediaTabs()
	g_modalManager.hide(controllerCyclopedia.ui)
	controllerCyclopedia.ui:hide()

	if CyclopediaButton then
		CyclopediaButton:setOn(false)
	end
end

function hideForOverlay()
	if not controllerCyclopedia.ui or not controllerCyclopedia.ui:isVisible() then
		return false
	end

	g_modalManager.hide(controllerCyclopedia.ui)
	controllerCyclopedia.ui:hide()

	if CyclopediaButton then
		CyclopediaButton:setOn(false)
	end

	return true
end

function restoreFromOverlay()
	if not controllerCyclopedia.ui then
		return
	end

	controllerCyclopedia.ui:show()
	g_modalManager.show(controllerCyclopedia.ui)

	if CyclopediaButton then
		CyclopediaButton:setOn(true)
	end
end

function resetCyclopediaTabs()
	tabStack = {}

	controllerCyclopedia.ui.BackButton:setEnabled(false)

	if previousType then
		local previousWindow = windowTypes[previousType]

		previousWindow.obj:enable()
		previousWindow.obj:setOn(false)

		previousType = nil
	end
end

function show(defaultWindow)
	if not controllerCyclopedia.ui or not CyclopediaButton then
		return
	end

	if defaultWindow == "bosstiary" then
		Cyclopedia.clearBosstiaryShortcutHighlight()
	else
		Cyclopedia.clearCyclopediaShortcutHighlight()
	end

	controllerCyclopedia.ui:show()
	g_modalManager.show(controllerCyclopedia.ui)
	SelectWindow(defaultWindow, false)

	if g_game.requestResource then
		g_game.requestResource(ResourceBank)
		g_game.requestResource(ResourceInventary)
	end

	updateCyclopediaMoneyDisplay()
end

function toggleBack()
	if previousType == "bestiary" and Cyclopedia.handleBestiaryBack and Cyclopedia.handleBestiaryBack() then
		return
	end

	local previousTab = table.remove(tabStack, #tabStack)

	if #tabStack < 1 then
		controllerCyclopedia.ui.BackButton:setEnabled(false)
	end

	SelectWindow(previousTab, true)
end

function SelectWindow(type, isBackButtonPress)
	if previousType then
		if previousType == "map" then
			if Cyclopedia.disconnectMapPositionEvent then
				Cyclopedia.disconnectMapPositionEvent()
			end

			if Cyclopedia.saveMapConfiguration then
				Cyclopedia.saveMapConfiguration()
			end
		end

		local previousWindow = windowTypes[previousType]

		previousWindow.obj:enable()
		previousWindow.obj:setOn(false)

		if not isBackButtonPress then
			table.insert(tabStack, previousType)
			controllerCyclopedia.ui.BackButton:setEnabled(true)
		end
	end

	onTerminateCharm()

	if Cyclopedia.clearBestiaryUI then
		Cyclopedia.clearBestiaryUI(false)
	end

	if Cyclopedia.clearItemsUI then
		Cyclopedia.clearItemsUI()
	end

	if Cyclopedia.clearBosstiaryUI then
		Cyclopedia.clearBosstiaryUI()
	end

	if Cyclopedia.clearBossSlotsUI then
		Cyclopedia.clearBossSlotsUI()
	end

	if Cyclopedia.clearMapUI then
		Cyclopedia.clearMapUI()
	end

	if Cyclopedia.clearCharacterUI then
		Cyclopedia.clearCharacterUI()
	end

	if Cyclopedia.clearMagicalArchivesUI then
		Cyclopedia.clearMagicalArchivesUI()
	end

	if Cyclopedia.clearCharmsUI then
		Cyclopedia.clearCharmsUI()
	end

	contentContainer:destroyChildren()

	local window = windowTypes[type]

	if window then
		if type == "bestiary" then
			Cyclopedia.Bestiary.RestoreView = isBackButtonPress
		elseif Cyclopedia.Bestiary then
			Cyclopedia.Bestiary.RestoreView = false
		end

		if controllerCyclopedia.ui.RefreshButton then
			controllerCyclopedia.ui.RefreshButton:setVisible(type == "houses")
		end

		window.obj:setOn(true)
		window.obj:disable()

		previousType = type

		if window.func then
			window.func(contentContainer)
		end
	end
end
