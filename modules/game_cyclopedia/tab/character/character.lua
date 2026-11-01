-- chunkname: @/game_cyclopedia/tab/character/character.lua

local characterPanel, UI
local CATEGORY_BASE_HEIGHT = 22
local SUBCATEGORY_HEIGHT = 20
local SUBCATEGORY_ARROW_MARGIN_RIGHT = 5
local SUBCATEGORY_ARROW_MARGIN_RIGHT_PRESSED = 4
local APPEARANCE_CATEGORY_STORE = 2
local APPEARANCE_BUTTON_UP = "/images/ui/button-grey-up"
local APPEARANCE_BUTTON_DOWN = "/images/ui/button-grey-down"
local characterTitlesCache = {}
local characterTitlesCurrentTitle = 0
local characterTitlesSelectedId = 0
local characterTitlesFilterMode = "all"
local characterTitlesSearchText = ""
local characterTitlesCurrentDescription = ""
local TITLE_ICON_YES = "/images/icons/icon-yes"
local TITLE_ICON_NO = "/images/icons/icon-no"
local TITLE_NAME_COLOR = "#C0C0C0"
local TITLE_SELECTED_NAME_COLOR = "#F4F4F4"
local TITLE_SELECTED_ROW_COLOR = "#585858"
local CHARACTER_BUTTON_ICON_OFFSET = {
	player = {
		pressed = "1 1",
		idle = "0 0"
	},
	outfit = {
		pressed = "0 1",
		idle = "-1 0"
	}
}

local function refreshCharacterButtonIconOffset(widget, pressed)
	if not widget or widget:isDestroyed() then
		return
	end

	local mode = widget.state == 2 and "outfit" or "player"
	local offsetKey = pressed and "pressed" or "idle"

	widget:setIconOffset(topoint(CHARACTER_BUTTON_ICON_OFFSET[mode][offsetKey]))
end

local function bindCharacterButtonIcon(widget)
	if not widget or widget:isDestroyed() then
		return
	end

	refreshCharacterButtonIconOffset(widget, false)

	function widget:onMousePress(mousePos, mouseButton)
		if mouseButton == MouseLeftButton then
			refreshCharacterButtonIconOffset(self, true)
		end

		return false
	end

	function widget:onMouseRelease(mousePos, mouseButton)
		if mouseButton == MouseLeftButton then
			refreshCharacterButtonIconOffset(self, false)
		end

		return false
	end
end

local function applyCharacterOutfitPreview(spriteWidget)
	if not spriteWidget or spriteWidget:isDestroyed() then
		return
	end

	spriteWidget:setSize({
		width = 128,
		height = 128
	})
	spriteWidget:setCenter(true)
	spriteWidget:setFixedCreatureSize(true)
	spriteWidget:setBaseScale(true)
	spriteWidget:setIgnoreDisplacementShift(true)
end

local function setCharacterInspectionOutfit(outfit)
	if not outfit or (outfit.type or 0) == 0 then
		Cyclopedia.Character.InspectionOutfit = nil

		return
	end

	Cyclopedia.Character.InspectionOutfit = {
		familiar = 0,
		mount = 0,
		type = outfit.type,
		auxType = outfit.auxType or 0,
		head = outfit.head or 0,
		body = outfit.body or 0,
		legs = outfit.legs or 0,
		feet = outfit.feet or 0,
		addons = outfit.addons or 0
	}
end

function Cyclopedia.applyCharacterOutfitWidgets()
	if not UI or UI:isDestroyed() then
		return
	end

	local outfit = Cyclopedia.Character.InspectionOutfit

	if not outfit or (outfit.type or 0) == 0 then
		return
	end

	if UI.CharacterBase and UI.CharacterBase.Outfit then
		UI.CharacterBase.Outfit:setOutfit(outfit)
	end

	if UI.InfoBase and UI.InfoBase.outfitPanel and UI.InfoBase.outfitPanel.Sprite then
		UI.InfoBase.outfitPanel.Sprite:setOutfit(outfit)
		applyCharacterOutfitPreview(UI.InfoBase.outfitPanel.Sprite)
	end
end

local function formatPercentFraction(value, signed)
	local percent = value * 100
	local formatted = string.format("%.2f", percent)

	if signed and percent > 0 then
		return "+ " .. formatted .. "%"
	end

	return formatted .. "%"
end

local function formatPercentValue(value)
	return string.format("%.2f%%", value)
end

local function setCharacterCategoryButtonChecked(button, checked)
	button:setChecked(checked)
	button.Icon:setChecked(checked)
	button.Title:setChecked(checked)

	if not checked then
		button.Icon:setMarginLeft(6)
		button.Icon:setMarginTop(0)
		button.Title:setTextOffset("0 0")
	end
end

local function bindSubcategoryButtonHandlers(button)
	button.Arrow:setMarginRight(SUBCATEGORY_ARROW_MARGIN_RIGHT)

	function button:onMousePress()
		self.Icon:setMarginLeft(7)
		self.Icon:setMarginTop(1)
		self.Title:setTextOffset("1 1")

		if self.Arrow:isVisible() then
			self.Arrow:setMarginRight(SUBCATEGORY_ARROW_MARGIN_RIGHT_PRESSED)
		end
	end

	function button:onMouseRelease()
		if not self:isChecked() then
			self.Icon:setMarginLeft(6)
			self.Icon:setMarginTop(0)
			self.Title:setTextOffset("0 0")

			if self.Arrow:isVisible() then
				self.Arrow:setMarginRight(SUBCATEGORY_ARROW_MARGIN_RIGHT)
			end
		end
	end
end

local function close(parent)
	if table.empty(parent.subCategories) then
		return
	end

	for subId, _ in ipairs(parent.subCategories) do
		local subWidget = parent:getChildById(subId)

		if subWidget then
			subWidget:setVisible(false)
		end
	end

	parent:setHeight(parent.closedSize)

	parent.opened = false

	parent.Button.Arrow:setVisible(true)
end

local function reset()
	characterPanel.InfoBase.inventoryPanel:setVisible(true)
	characterPanel.InfoBase.outfitPanel:setVisible(false)

	if characterPanel.InfoBase.CharacterButton.state ~= 1 then
		Cyclopedia.characterButton(characterPanel.InfoBase.CharacterButton)
	end

	Cyclopedia.selectCharacterPage()

	characterPanel.openedCategory = nil
end

local function open(parent)
	local oldOpen = UI.openedCategory

	for subId, _ in ipairs(parent.subCategories) do
		local subWidget = parent:getChildById(subId)

		if subWidget then
			if tonumber(subWidget:getId()) == 1 then
				subWidget.Button.onClick(subWidget)
			end

			subWidget:setVisible(true)
		end
	end

	if oldOpen ~= nil and oldOpen ~= parent then
		close(oldOpen)
	end

	parent:setHeight(parent.openedSize)

	parent.opened = true

	parent.Button.Arrow:setVisible(false)

	UI.openedCategory = parent
end

function Cyclopedia.clearCharacterUI()
	if UI then
		UI.openedCategory = nil
	end

	UI = nil
	characterPanel = nil
end

function showCharacter()
	Cyclopedia.clearCharacterUI()

	characterPanel = g_ui.loadUI("character", contentContainer)
	UI = characterPanel

	function UI.onDestroy()
		UI = nil
		characterPanel = nil
	end

	characterPanel:show()

	UI.selectedOption = "InfoBase"

	if g_game.isOnline() then
		local player = g_game.getLocalPlayer()

		UI.CharacterBase:setText(player:getName())
		UI.CharacterBase.InfoLabel:setText(string.format("Level %d\n%s", player:getLevel(), player:getVocationNameByClientId()))
		UI.CharacterBase.worldInfoLabel:setText(g_game.getWorldName() or "")
		Cyclopedia.applyCharacterOutfitWidgets()
		UI.InfoBase.InspectLabel:setText(tr("You are inspecting") .. ": " .. player:getName())

		for i = InventorySlotFirst, InventorySlotPurse do
			local item = player:getInventoryItem(i)
			local itemWidget = UI.InfoBase.inventoryPanel["slot" .. i]

			if itemWidget then
				if item then
					itemWidget:setStyle("InventoryItemCyclopedia")
					itemWidget:setItem(item)
					itemWidget:setIcon("")
				else
					itemWidget:setStyle(Cyclopedia.InventorySlotStyles[i].name)
					itemWidget:setIcon(Cyclopedia.InventorySlotStyles[i].icon)
					itemWidget:setItem(nil)
				end
			end
		end

		Cyclopedia.bindCharacterInventorySlots()
		bindCharacterButtonIcon(UI.InfoBase.CharacterButton)

		if g_game.isOnline() then
			g_game.requestCharacterInfo(0, CyclopediaCharacterInfoTypes.Ispection)
			g_game.requestCharacterInfo(0, CyclopediaCharacterInfoTypes.OutfitsAndMounts)
			Cyclopedia.applyCharacterDescriptionParts()
			Cyclopedia.configureCharacterCategories()
		end
	end

	reset()
	controllerCyclopedia.ui.MajorCharmsBase:setVisible(true)
	controllerCyclopedia.ui.GoldBase:setVisible(true)
	controllerCyclopedia.ui.BestiaryTrackerButton:setVisible(false)
	controllerCyclopedia.ui.MinorCharmsBase:setVisible(true)
end

Cyclopedia.Character = {}
Cyclopedia.Character.Achievements = {}
Cyclopedia.InventorySlotStyles = {
	[InventorySlotHead] = {
		icon = "/images/inventory/inventory_head",
		name = "HeadSlot"
	},
	[InventorySlotNeck] = {
		icon = "/images/inventory/inventory_neck",
		name = "NeckSlot"
	},
	[InventorySlotBack] = {
		icon = "/images/inventory/inventory_back",
		name = "BackSlot"
	},
	[InventorySlotBody] = {
		icon = "/images/inventory/inventory_torso",
		name = "BodySlot"
	},
	[InventorySlotRight] = {
		icon = "/images/inventory/inventory_right_hand",
		name = "RightSlot"
	},
	[InventorySlotLeft] = {
		icon = "/images/inventory/inventory_left_hand",
		name = "LeftSlot"
	},
	[InventorySlotLeg] = {
		icon = "/images/inventory/inventory_legs",
		name = "LegSlot"
	},
	[InventorySlotFeet] = {
		icon = "/images/inventory/inventory_feet",
		name = "FeetSlot"
	},
	[InventorySlotFinger] = {
		icon = "/images/inventory/inventory_finger",
		name = "FingerSlot"
	},
	[InventorySlotAmmo] = {
		icon = "/images/inventory/inventory_hip",
		name = "AmmoSlot"
	}
}

local function getCharacterAppearancesListGrid()
	if not UI or UI:isDestroyed() then
		return nil
	end

	local appearances = UI.CharacterAppearances

	if not appearances then
		return nil
	end

	local listBase = appearances.ListBase
	local list = listBase and listBase.list
	local listGrid = list and list.listGrid

	if not listGrid or listGrid:isDestroyed() then
		return nil
	end

	return listGrid
end

function Cyclopedia.characterAppearancesFilter(widget)
	if Cyclopedia.Character.AppearancesFilterResetting then
		return
	end

	if not widget or widget:isDestroyed() then
		return
	end

	local parent = widget:getParent()

	if not parent or parent:isDestroyed() then
		return
	end

	for i = 1, parent:getChildCount() do
		local child = parent:getChildByIndex(i)

		if child and child:getId() ~= "show" then
			child:setChecked(false)
		end
	end

	widget:setChecked(true)
	Cyclopedia.applyCharacterAppearancesVisibility()
end

function Cyclopedia.characterAppearancesShowFilter(widget)
	if not UI or UI:isDestroyed() then
		return
	end

	Cyclopedia.applyCharacterAppearancesVisibility()
end

function Cyclopedia.getCharacterAppearancesTabFilter()
	local listFilter = UI and not UI:isDestroyed() and UI.CharacterAppearances and UI.CharacterAppearances.listFilter

	if not listFilter or listFilter:isDestroyed() then
		return "outfits"
	end

	for _, tabId in ipairs({
		"outfits",
		"mounts",
		"familiars"
	}) do
		local tab = listFilter[tabId]

		if tab and not tab:isDestroyed() and tab:isChecked() then
			return tabId
		end
	end

	return "outfits"
end

function Cyclopedia.getCharacterAppearancesCategoryFilter()
	if not UI or UI:isDestroyed() then
		return nil
	end

	local showCombo = UI.CharacterAppearances and UI.CharacterAppearances.listFilter and UI.CharacterAppearances.listFilter.show

	if not showCombo or showCombo:isDestroyed() or not showCombo.getCurrentOption then
		return nil
	end

	local option = showCombo:getCurrentOption()

	if not option then
		return nil
	end

	return option.data
end

function Cyclopedia.resetCharacterAppearancesFiltersUI()
	if not UI or not UI.CharacterAppearances or UI.CharacterAppearances:isDestroyed() then
		return
	end

	Cyclopedia.Character.AppearancesFilterResetting = true

	local listFilter = UI.CharacterAppearances.listFilter

	if listFilter and not listFilter:isDestroyed() then
		for _, tabId in ipairs({
			"outfits",
			"mounts",
			"familiars"
		}) do
			local tab = listFilter[tabId]

			if tab and not tab:isDestroyed() then
				tab:setChecked(tabId == "outfits")
			end
		end

		local showCombo = listFilter.show

		if showCombo and not showCombo:isDestroyed() and showCombo.setCurrentOption then
			showCombo:setCurrentOption("Show All", true)
		end
	end

	Cyclopedia.Character.AppearancesFilterResetting = false
end

function Cyclopedia.applyCharacterAppearancesDefaultFilters()
	Cyclopedia.resetCharacterAppearancesFiltersUI()
	Cyclopedia.applyCharacterAppearancesVisibility()
end

function Cyclopedia.applyCharacterAppearancesVisibility()
	if not UI or UI:isDestroyed() or not Cyclopedia.Character.Appearances then
		return
	end

	local tabType = Cyclopedia.getCharacterAppearancesTabFilter()
	local categoryFilter = Cyclopedia.getCharacterAppearancesCategoryFilter()

	for _, data in ipairs(Cyclopedia.Character.Appearances) do
		local tabMatch = data.type == tabType
		local categoryMatch = true

		if tabType == "outfits" and categoryFilter ~= nil then
			categoryMatch = (data.category or 0) == categoryFilter
		end

		data.visible = tabMatch and categoryMatch
	end

	Cyclopedia.reloadCharacterAppearances()
end

function Cyclopedia.clearCharacterAppearanceSelection()
	local selected = Cyclopedia.Character.AppearancesSelectedWidget

	if selected and not selected:isDestroyed() then
		selected:setImageSource(APPEARANCE_BUTTON_UP)
	end

	Cyclopedia.Character.AppearancesSelectedWidget = nil
	Cyclopedia.Character.AppearancesSelectedData = nil
end

function Cyclopedia.selectCharacterAppearanceWidget(widget, data)
	if not widget or widget:isDestroyed() then
		return
	end

	Cyclopedia.clearCharacterAppearanceSelection()
	widget:setImageSource(APPEARANCE_BUTTON_DOWN)

	Cyclopedia.Character.AppearancesSelectedWidget = widget
	Cyclopedia.Character.AppearancesSelectedData = data
end

function Cyclopedia.onCharacterAppearanceClick(widget)
	if not widget or widget:isDestroyed() then
		return
	end

	local data = widget.appearanceData

	if not data then
		return
	end

	if modules.game_cyclopedia and modules.game_cyclopedia.hideForOverlay then
		modules.game_cyclopedia.hideForOverlay()
	end

	if modules.game_outfit and modules.game_outfit.openFromCyclopedia then
		modules.game_outfit.openFromCyclopedia(data)
	else
		g_game.requestOutfit()
	end
end

function Cyclopedia.reloadCharacterAppearances()
	local selectedKey

	if Cyclopedia.Character.AppearancesSelectedData then
		local selected = Cyclopedia.Character.AppearancesSelectedData

		selectedKey = {
			type = selected.type,
			lookType = selected.outfit and selected.outfit.type,
			addons = selected.outfit and selected.outfit.addons or 0
		}
	end

	Cyclopedia.clearCharacterAppearanceSelection()

	local listGrid = getCharacterAppearancesListGrid()

	if not listGrid or not Cyclopedia.Character.Appearances then
		return
	end

	listGrid:destroyChildren()

	for _, data in ipairs(Cyclopedia.Character.Appearances) do
		data.widget = nil

		if data.visible then
			local widget = g_ui.createWidget("CharacterAppearance", listGrid)

			widget.name:setText(data.name)
			widget.creature:setOutfit(data.outfit)
			widget.creature:getCreature():setStaticWalking(0)

			if widget.storeIcon then
				widget.storeIcon:setVisible(data.category == APPEARANCE_CATEGORY_STORE)
			end

			widget.appearanceData = data

			if selectedKey and data.type == selectedKey.type and data.outfit.type == selectedKey.lookType and (data.outfit.addons or 0) == selectedKey.addons then
				widget:setImageSource(APPEARANCE_BUTTON_DOWN)

				Cyclopedia.Character.AppearancesSelectedWidget = widget
				Cyclopedia.Character.AppearancesSelectedData = data
			end

			data.widget = widget
		end
	end
end

function Cyclopedia.loadCharacterAppearances(color, outfits, mounts, familiars)
	local data = {}
	local currentOutfitName

	Cyclopedia.Character.OutfitNamesByLookType = Cyclopedia.Character.OutfitNamesByLookType or {}

	local function cacheOutfitNames(container)
		if not container then
			return
		end

		for i = 1, #container do
			local value = container[i]

			if value and value.lookType and value.name and value.name ~= "" then
				Cyclopedia.Character.OutfitNamesByLookType[value.lookType] = value.name

				if value.isCurrent == 1000 then
					currentOutfitName = value.name
				end
			end
		end
	end

	cacheOutfitNames(outfits)

	local function insert(value, type)
		local lookData = value.lookType

		if type == "mounts" then
			lookData = value.mountId
		end

		local data_t = {
			visible = false,
			name = value.name,
			type = type,
			category = value.type or 0,
			outfit = {
				auxType = 0,
				type = lookData,
				head = color.lookHead,
				body = color.lookBody,
				legs = color.lookLegs,
				feet = color.lookFeet,
				addons = value.addons or 0
			}
		}

		table.insert(data, data_t)
	end

	local function process(container, containerType)
		if not container then
			return
		end

		for i = 1, #container do
			local value = container[i]

			if value then
				insert(value, containerType)
			end
		end
	end

	process(outfits, "outfits")
	process(mounts, "mounts")
	process(familiars, "familiars")

	Cyclopedia.Character.Appearances = data

	if currentOutfitName then
		Cyclopedia.Character.DescriptionParts = Cyclopedia.Character.DescriptionParts or {}

		if not Cyclopedia.Character.DescriptionParts.outfit or Cyclopedia.Character.DescriptionParts.outfit == "" then
			Cyclopedia.Character.DescriptionParts.outfit = currentOutfitName
		end

		if UI and UI.InfoBase and not UI:isDestroyed() and UI.selectedOption == "InfoBase" then
			Cyclopedia.applyCharacterDescriptionParts()
		end
	end

	if UI and not UI:isDestroyed() then
		Cyclopedia.applyCharacterAppearancesDefaultFilters()
	end
end

local CHARACTER_ITEMS_DEFAULT_FILTERS = {
	inventory = true,
	store = false,
	inbox = false,
	stash = false,
	depot = false
}

function Cyclopedia.resetCharacterItemsFiltersUI()
	if not UI or not UI.CharacterItems or UI.CharacterItems:isDestroyed() then
		return
	end

	Cyclopedia.Character.ItemsFilterResetting = true

	local filters = UI.CharacterItems.filters

	for filterId, checked in pairs(CHARACTER_ITEMS_DEFAULT_FILTERS) do
		local checkbox = filters[filterId]

		if checkbox and not checkbox:isDestroyed() then
			checkbox:setChecked(checked)
		end
	end

	if filters.SearchEdit and not filters.SearchEdit:isDestroyed() then
		filters.SearchEdit:setText("")
	end

	Cyclopedia.characterItemListFilter(UI.CharacterItems.listFilter.list)

	Cyclopedia.Character.ItemsFilterResetting = false
end

function Cyclopedia.applyCharacterItemsDefaultFilters()
	Cyclopedia.resetCharacterItemsFiltersUI()

	if not Cyclopedia.Character.Items then
		return
	end

	for _, item in ipairs(Cyclopedia.Character.Items) do
		item.data.visible = CHARACTER_ITEMS_DEFAULT_FILTERS[item.data.type] == true
	end

	Cyclopedia.reloadCharacterItems()
end

function Cyclopedia.characterItemsSearch(text)
	local filter = UI.CharacterItems.filters
	local activeFilters = {}

	for i = 1, filter:getChildCount() do
		local child = filter:getChildByIndex(i)

		if child:isChecked() then
			table.insert(activeFilters, child:getId())
		end
	end

	for _, item in ipairs(Cyclopedia.Character.Items) do
		local data = item.data
		local name = data.name:lower()
		local meetsSearchCriteria = text == "" or string.find(name, text:lower()) ~= nil
		local meetsFilterCriteria = #activeFilters == 0 or table.contains(activeFilters, data.type)

		data.visible = meetsSearchCriteria and meetsFilterCriteria
	end

	Cyclopedia.reloadCharacterItems()
end

function Cyclopedia.characterItemsFilter(widget, force)
	if Cyclopedia.Character.ItemsFilterResetting then
		return
	end

	if force then
		widget:setChecked(true)
	end

	local id = widget:getId()

	for _, item in ipairs(Cyclopedia.Character.Items) do
		local data = item.data

		if data.type == id then
			data.visible = widget:isChecked()
		end
	end

	Cyclopedia.reloadCharacterItems()
end

local function applyCharacterListItemSlot(listItem, itemId, tier)
	if not listItem or not listItem.item then
		return
	end

	listItem.item:setItemId(itemId)

	local item = listItem.item:getItem()

	if item and tier and tier > 0 and item.setTier then
		item:setTier(tier)
	end

	if listItem.rarity then
		ItemsDatabase.setRarityItem(listItem.rarity, item)
		ItemsDatabase.syncRarityWidgetVisibility(listItem.rarity)
	end

	ItemsDatabase.setTier(listItem, item or tier or 0)
end

function Cyclopedia.reloadCharacterItems()
	UI.CharacterItems.ListBase.list:destroyChildren()
	UI.CharacterItems.gridBase.grid.itemsGrid:destroyChildren()

	local colors = {
		"#484848",
		"#414141"
	}
	local colorIndex = 1

	for _, item in ipairs(Cyclopedia.Character.Items) do
		local itemId, data = item.itemId, item.data

		if data.visible then
			local listItem = g_ui.createWidget("CharacterListItem", UI.CharacterItems.ListBase.list)

			applyCharacterListItemSlot(listItem, itemId, item.tier)
			listItem.name:setText(data.name)
			listItem.amount:setText(data.amount)
			listItem:setBackgroundColor(colors[colorIndex])

			local gridItem = g_ui.createWidget("CharacterGridItem", UI.CharacterItems.gridBase.grid.itemsGrid)

			applyCharacterListItemSlot(gridItem, itemId, item.tier)
			gridItem.amount:setText(data.amount)

			colorIndex = 3 - colorIndex
		end
	end
end

function Cyclopedia.loadCharacterItems(data)
	local inventory = data.inventory
	local store = data.store
	local stash = data.stash
	local depot = data.depot
	local inbox = data.inbox

	Cyclopedia.Character.Items = {}

	local function insert(data, type)
		if not data then
			return
		end

		local thing = g_things.getThingType(data.itemId, ThingCategoryItem)
		local name = thing:getMarketData().name:lower()

		name = name ~= "" and name or "?"

		local data_t = {
			visible = false,
			name = name,
			amount = data.amount,
			type = type
		}
		local itemKey = data.itemId .. "-" .. (data.tier or "no_tier")
		local insertedItem = Cyclopedia.Character.Items[itemKey]

		if insertedItem and insertedItem.amount then
			insertedItem.amount = insertedItem.amount + data.amount
		else
			Cyclopedia.Character.Items[itemKey] = {
				itemId = data.itemId,
				tier = data.tier,
				data = data_t
			}
		end
	end

	local function processContainer(container, containerType)
		for i = 0, #container do
			local data = container[i]

			if data then
				insert(data, containerType)
			end
		end
	end

	processContainer(inventory, "inventory")
	processContainer(store, "store")
	processContainer(stash, "stash")
	processContainer(depot, "depot")
	processContainer(inbox, "inbox")

	local sortedItems = {}

	for _, itemData in pairs(Cyclopedia.Character.Items) do
		table.insert(sortedItems, itemData)
	end

	local function compareByName(a, b)
		local nameA = a.data.name:lower()
		local nameB = b.data.name:lower()

		if nameA ~= "?" and nameB == "?" then
			return true
		elseif nameA == "?" and nameB ~= "?" then
			return false
		else
			return nameA < nameB
		end
	end

	table.sort(sortedItems, compareByName)

	Cyclopedia.Character.Items = sortedItems

	Cyclopedia.applyCharacterItemsDefaultFilters()
end

function Cyclopedia.resetCharacterAchievementsFiltersUI()
	if not UI or not UI.CharacterAchievements or UI.CharacterAchievements:isDestroyed() then
		return
	end

	Cyclopedia.Character.AchievementsFilterResetting = true

	local ui = UI.CharacterAchievements
	local filters = ui.filters

	for _, filterId in ipairs({
		"all",
		"locked",
		"accomplished"
	}) do
		local checkbox = filters[filterId]

		if checkbox and not checkbox:isDestroyed() then
			checkbox:setChecked(filterId == "accomplished")
		end
	end

	Cyclopedia.Character.Achievements.lastSort = 1

	if ui.sort and not ui.sort:isDestroyed() then
		if ui.sort.setCurrentOptionByData then
			ui.sort:setCurrentOptionByData(1, true)
		elseif ui.sort.setCurrentOption then
			ui.sort:setCurrentOption("Alphabetically", true)
		end
	end

	Cyclopedia.Character.AchievementsFilterResetting = false
end

function Cyclopedia.applyCharacterAchievementsDefaultFilters()
	Cyclopedia.resetCharacterAchievementsFiltersUI()

	if Cyclopedia.Character.Achievements.Data then
		Cyclopedia.refreshCharacterAchievementList()
	end
end

function Cyclopedia.loadCharacterAchievements()
	if not Cyclopedia.Character.Achievements.Loaded then
		UI.CharacterAchievements.sort:addOption("Alphabetically", 1, true)
		UI.CharacterAchievements.sort:addOption("By Grade", 2, true)
		UI.CharacterAchievements.sort:addOption("By Unlock Date", 3, true)

		Cyclopedia.Character.Achievements.Loaded = true
	end

	Cyclopedia.applyCharacterAchievementsDefaultFilters()
	g_game.requestCharacterInfo(0, CyclopediaCharacterInfoTypes.Achievements)
end

local function getStaticAchievement(id)
	if g_things.getAchievementData then
		local data = g_things.getAchievementData(id)

		if data and data.id and data.id > 0 then
			return data
		end
	end

	return ACHIEVEMENTS[id]
end

local function getRegularAchievementList()
	if g_things.getAchievementList then
		local list = g_things.getAchievementList()

		if list and #list > 0 then
			return list
		end
	end

	local fallback = {}

	for id, data in pairs(ACHIEVEMENTS) do
		if not data.secret then
			table.insert(fallback, {
				id = id,
				name = data.name,
				description = data.description,
				grade = data.grade or 1
			})
		end
	end

	return fallback
end

local function getAchievementTotals()
	if g_things.getRegularAchievementCount then
		local count = g_things.getRegularAchievementCount()

		if count and count > 0 then
			return count
		end
	end

	return #getRegularAchievementList()
end

local function isSecretAchievement(id, playerEntry)
	if playerEntry and playerEntry.isSecret == 1 then
		return true
	end

	local legacy = ACHIEVEMENTS[id]

	return legacy and legacy.secret or false
end

function Cyclopedia.setAchievementProgressBar(panel, current, max)
	if not panel or panel:isDestroyed() then
		return
	end

	panel.value:setText(string.format("%d/%d", current, max))

	local fill = panel.fill

	if not fill then
		return
	end

	local barWidth = panel:getWidth() or 0
	local progressValue = max > 0 and math.min(current, max) or 0
	local width = max > 0 and math.floor(progressValue / max * barWidth) or 0
	local rect = {
		height = 18,
		y = 0,
		x = 0,
		width = width
	}

	if current <= 0 or width < 1 then
		fill:setVisible(false)
	else
		fill:setVisible(true)
		fill:setImageRect(rect)
		fill:setImageClip(rect)
		fill:setImageSource("/images/bars/progressbar-orange-large")
	end
end

function Cyclopedia.buildAchievementEntry(id, playerEntry)
	if isSecretAchievement(id, playerEntry) then
		if not playerEntry then
			return nil
		end

		return {
			secret = true,
			accomplished = true,
			id = id,
			name = playerEntry.name or "?",
			description = playerEntry.description or "",
			grade = playerEntry.grade or 1,
			timestamp = playerEntry.timestamp or 0
		}
	end

	local static = getStaticAchievement(id)

	if not static then
		return nil
	end

	return {
		secret = false,
		id = id,
		name = static.name,
		description = static.description,
		grade = static.grade or 1,
		timestamp = playerEntry and playerEntry.timestamp or 0,
		accomplished = playerEntry ~= nil
	}
end

function Cyclopedia.buildAchievementEntries(filter)
	local data = Cyclopedia.Character.Achievements.Data
	local accomplished = Cyclopedia.Character.Achievements.accomplished or {}
	local entries = {}
	local listedIds = {}

	local function addEntry(entry)
		if entry and not listedIds[entry.id] then
			listedIds[entry.id] = true

			table.insert(entries, entry)
		end
	end

	if filter == "accomplished" then
		if not data or not data.achievements then
			return entries
		end

		for _, playerEntry in ipairs(data.achievements) do
			addEntry(Cyclopedia.buildAchievementEntry(playerEntry.id, playerEntry))
		end
	elseif filter == "locked" then
		for _, static in ipairs(getRegularAchievementList()) do
			if not accomplished[static.id] then
				addEntry(Cyclopedia.buildAchievementEntry(static.id, nil))
			end
		end
	else
		for _, static in ipairs(getRegularAchievementList()) do
			addEntry(Cyclopedia.buildAchievementEntry(static.id, accomplished[static.id]))
		end

		if data and data.achievements then
			for _, playerEntry in ipairs(data.achievements) do
				if playerEntry.isSecret == 1 then
					addEntry(Cyclopedia.buildAchievementEntry(playerEntry.id, playerEntry))
				end
			end
		end
	end

	return entries
end

function Cyclopedia.refreshCharacterAchievementsUI()
	local data = Cyclopedia.Character.Achievements.Data

	if not data then
		return
	end

	local ui = UI.CharacterAchievements

	ui.achievements.Points:setText(tr("Achievement Points: ") .. (data.achievementPoints or 0))

	local gradeCounts = {
		0,
		0,
		0,
		0
	}
	local regularDone = 0
	local secretDone = 0

	if data.achievements then
		for _, playerEntry in ipairs(data.achievements) do
			local entry = Cyclopedia.buildAchievementEntry(playerEntry.id, playerEntry)

			if entry then
				if entry.secret then
					secretDone = secretDone + 1
				else
					regularDone = regularDone + 1
				end

				local grade = entry.grade

				if grade >= 1 and grade <= 4 then
					gradeCounts[grade] = gradeCounts[grade] + 1
				end
			end
		end
	end

	ui.achievements.gradeOne:setText(tr("Grade 1: ") .. gradeCounts[1])
	ui.achievements.gradeTwo:setText(tr("Grade 2: ") .. gradeCounts[2])
	ui.achievements.gradeThree:setText(tr("Grade 3: ") .. gradeCounts[3])
	ui.achievements.gradeFour:setText(tr("Grade 4: ") .. gradeCounts[4])

	local function updateBars()
		Cyclopedia.setAchievementProgressBar(ui.regular, regularDone, getAchievementTotals())
		Cyclopedia.setAchievementProgressBar(ui.secret, secretDone, data.secretAchievementsMax or 0)
	end

	updateBars()
	addEvent(updateBars)
end

local function setAchievementTitleLabel(titleLabel, entry)
	local titleColor = "#909090"

	if entry.secret and entry.accomplished then
		local spacer = string.rep(" ", 3)

		titleLabel:setColoredText(string.format("{%s, %s}{%s, %s}{Secret, #f75f5f}", entry.name, titleColor, spacer, titleColor))
	else
		titleLabel:setText(entry.name)
		titleLabel:setColor(titleColor)
	end
end

function Cyclopedia.refreshCharacterAchievementList()
	local ui = UI.CharacterAchievements

	if not ui or ui:isDestroyed() then
		return
	end

	local filter = "accomplished"
	local filters = ui.filters

	if filters.all:isChecked() then
		filter = "all"
	elseif filters.locked:isChecked() then
		filter = "locked"
	end

	local option = Cyclopedia.Character.Achievements.lastSort or 1
	local entries = Cyclopedia.buildAchievementEntries(filter)

	if option == 1 then
		table.sort(entries, function(a, b)
			return a.name < b.name
		end)
	elseif option == 2 then
		table.sort(entries, function(a, b)
			if a.grade == b.grade then
				return a.name < b.name
			end

			return a.grade > b.grade
		end)
	elseif option == 3 then
		table.sort(entries, function(a, b)
			if a.timestamp == b.timestamp then
				return a.name < b.name
			end

			return a.timestamp > b.timestamp
		end)
	end

	ui.ListBase.List.listContent:destroyChildren()

	for _, entry in ipairs(entries) do
		local widget = g_ui.createWidget("Achievement", ui.ListBase.List.listContent)
		local titleLabel = widget.title

		widget:setId(entry.id)
		setAchievementTitleLabel(titleLabel, entry)
		widget.description:setText(entry.description)
		widget.icon:setWidth(11 * entry.grade)

		widget.grade = entry.grade
		widget.accomplished = entry.accomplished

		if entry.accomplished and entry.timestamp and entry.timestamp > 0 then
			widget.date:setText(os.date("%Y-%m-%d", entry.timestamp))
			widget.date:setVisible(true)
		else
			widget.date:setText("")
			widget.date:setVisible(false)
		end

		widget.description:setColor("#C0C0C0")
		addEvent(function()
			if widget:isDestroyed() then
				return
			end

			local rect = widget:getChildrenRect()

			if rect.height > 0 then
				widget:setHeight(rect.height + 6)
			end
		end)
	end
end

-- The engine passes parallel arrays (points, secretsUnlocked, ids, timestamps, secrets, names,
-- descriptions, grades), while the module expects ONE table - until now 'data' was the points number
-- and data.achievements blew up on indexing a number, which left the tab empty.
function Cyclopedia.onEngineCharacterAchievements(points, secretsUnlocked, ids, timestamps, secrets, names, descriptions, grades)
	local achievements = {}

	for i, id in ipairs(ids or {}) do
		achievements[#achievements + 1] = {
			id = id,
			timestamp = timestamps and timestamps[i] or 0,
			isSecret = secrets and secrets[i] or 0,
			name = names and names[i] or "",
			description = descriptions and descriptions[i] or "",
			grade = grades and grades[i] or 1
		}
	end

	Cyclopedia.onParseCyclopediaCharacterAchievements({
		achievementPoints = points or 0,
		secretsUnlocked = secretsUnlocked or 0,
		achievements = achievements
	})
end

-- same for titles: the module iterates entries as entry[1..5] (id, name, description, permanent, unlocked)
function Cyclopedia.onEngineCharacterTitles(currentTitle, ids, names, descriptions, permanents, unlockeds)
	local titles = {}

	for i, id in ipairs(ids or {}) do
		titles[#titles + 1] = {
			id,
			names and names[i] or "?",
			descriptions and descriptions[i] or "",
			permanents and permanents[i] or 0,
			unlockeds and unlockeds[i] or 0
		}
	end

	Cyclopedia.loadCharacterTitles(currentTitle, titles)
end

function Cyclopedia.onParseCyclopediaCharacterAchievements(data)
	Cyclopedia.Character.Achievements.Data = data

	local accomplished = {}

	if data.achievements then
		for _, entry in ipairs(data.achievements) do
			accomplished[entry.id] = entry
		end
	end

	Cyclopedia.Character.Achievements.accomplished = accomplished

	Cyclopedia.refreshCharacterAchievementsUI()
	Cyclopedia.applyCharacterAchievementsDefaultFilters()
end

function Cyclopedia.characterItemListFilter(widget)
	local parent = widget:getParent()

	for i = 1, parent:getChildCount() do
		local child = parent:getChildByIndex(i)

		if child then
			child:setChecked(false)
		end
	end

	widget:setChecked(true)

	if widget:getId() == "list" then
		UI.CharacterItems.ListBase:setVisible(true)
		UI.CharacterItems.gridBase:setVisible(false)
	else
		UI.CharacterItems.ListBase:setVisible(false)
		UI.CharacterItems.gridBase:setVisible(true)
	end
end

function Cyclopedia.achievementFilter(widget)
	if Cyclopedia.Character.AchievementsFilterResetting then
		return
	end

	if not widget or widget:isDestroyed() then
		return
	end

	local parent = widget:getParent()

	if not parent or parent:isDestroyed() then
		return
	end

	for i = 1, parent:getChildCount() do
		local child = parent:getChildByIndex(i)

		if child then
			child:setChecked(false)
		end
	end

	widget:setChecked(true)
	Cyclopedia.refreshCharacterAchievementList()
end

function Cyclopedia.achievementSort(option)
	Cyclopedia.Character.Achievements.lastSort = option

	Cyclopedia.refreshCharacterAchievementList()
end

local function getRecentKillStatusInfo(status)
	if status == 0 then
		return tr("Justified"), "#44ad25"
	end

	if status == 1 then
		return tr("Unjustified"), "#d33c3c"
	end

	return tostring(status), "#C0C0C0"
end

function Cyclopedia.loadCharacterRecentKills(data)
	UI.RecentKills.ListBase.List:destroyChildren()

	if not table.empty(data) then
		local color = "#484848"

		for i = 1, #data do
			local entry = data[i]
			local time = entry.timestamp
			local description = entry.description
			local status = entry.status
			local widget = g_ui.createWidget("CharacterKill", UI.RecentKills.ListBase.List)

			widget:setId(i)
			widget:setHeight(16)
			widget:setMinHeight(16)
			widget:setMaxHeight(16)
			widget.date:setText(os.date("%Y-%m-%d, %H:%M:%S", time))
			widget.description:setText(description)

			local statusText, statusColor = getRecentKillStatusInfo(status)

			widget.status:setText(statusText)

			widget.statusColor = statusColor

			widget.status:setColor(statusColor)

			widget.color = color

			widget:setBackgroundColor(color)

			color = color == "#484848" and "#414141" or "#484848"

			function widget:onClick()
				local parent = widget:getParent()

				for y = 1, parent:getChildCount() do
					local child = parent:getChildByIndex(y)

					child:setChecked(false)
					child.date:setOn(false)
					child.description:setOn(false)
					child.status:setColor(child.statusColor)
				end

				self:setChecked(not self:isChecked())
			end

			function widget:onCheckChange()
				if self:isChecked() then
					self:setBackgroundColor("#585858")
				else
					self:setBackgroundColor(self.color)
				end

				self.date:setOn(not self:isOn())
				self.description:setOn(not self:isOn())
			end

			if i == 1 then
				widget:setChecked(true)
			end
		end
	end
end

function Cyclopedia.loadCharacterRecentDeaths(data)
	UI.RecentDeaths.ListBase.List:destroyChildren()

	if not table.empty(data) then
		local color = "#484848"

		for i = 1, #data do
			local entry = data[i]
			local widget = g_ui.createWidget("CharacterDeath", UI.RecentDeaths.ListBase.List)

			widget:setId(i)
			widget:setHeight(16)
			widget:setMinHeight(16)
			widget:setMaxHeight(16)
			widget.date:setText(os.date("%Y-%m-%d, %H:%M:%S", entry.timestamp))
			widget.cause:setText(entry.cause)

			widget.color = color

			widget:setBackgroundColor(color)

			color = color == "#484848" and "#414141" or "#484848"

			function widget:onClick()
				local parent = widget:getParent()

				for y = 1, parent:getChildCount() do
					local child = parent:getChildByIndex(y)

					child:setChecked(false)
					child.cause:setOn(false)
					child.date:setOn(false)
				end

				self:setChecked(not self:isChecked())
			end

			function widget:onCheckChange()
				if self:isChecked() then
					self:setBackgroundColor("#585858")
				else
					self:setBackgroundColor(self.color)
				end

				self.cause:setOn(not self:isOn())
				self.date:setOn(not self:isOn())
			end

			if i == 1 then
				widget:setChecked(true)
			end
		end
	end
end

function Cyclopedia.loadCharacterCombatStats(data, mitigation, additionalSkillsArray, forgeSkillsArray, perfectShotDamageRanges, combatsArray, concoctionsArray)
	UI.CombatStats.attack.icon:setImageSource("/images/game/creatures/player-state-flags")
	UI.CombatStats.attack.icon:setImageClip(data.weaponElement * 9 .. " 0 9 9")
	UI.CombatStats.attack.value:setText(data.weaponMaxHitChance)

	if data.weaponElementDamage > 0 then
		UI.CombatStats.converted.none:setVisible(false)
		UI.CombatStats.converted.value:setVisible(true)
		UI.CombatStats.converted.icon:setVisible(true)
		UI.CombatStats.converted.icon:setImageSource("/images/game/creatures/player-state-flags")
		UI.CombatStats.converted.icon:setImageClip(data.weaponElementType * 9 .. " 0 9 9")
		UI.CombatStats.converted.value:setText(data.weaponElementDamage .. "%")
	else
		UI.CombatStats.converted.none:setVisible(true)
		UI.CombatStats.converted.value:setVisible(false)
		UI.CombatStats.converted.icon:setVisible(false)
	end

	UI.CombatStats.defence.value:setText(data.defense)
	UI.CombatStats.armor.value:setText(data.armor)
	UI.CombatStats.mitigation.value:setText(formatPercentValue(mitigation))
	UI.CombatStats.blessings.value:setText(string.format("%d/8", data.haveBlessings))

	for i = 0, 6 do
		local id = "reduction_" .. i

		if UI.CombatStats[id] then
			UI.CombatStats[id]:destroy()
		end
	end

	UI.CombatStats.reductionNone:destroyChildren()

	if next(combatsArray) == nil then
		UI.CombatStats.reductionNone:setVisible(true)
	else
		UI.CombatStats.reductionNone:setVisible(true)

		for i = 1, #combatsArray do
			local widget = g_ui.createWidget("CharacterElementReduction", UI.CombatStats.reductionNone)

			widget:setId("reduction_" .. i)

			local element = Cyclopedia.clientCombat[combatsArray[i][1]]

			if element then
				widget.icon:setImageSource(element.path)
				widget.icon:setImageSize({
					width = 9,
					height = 9
				})
			else
				print(string.format("WARNING: Element not found for combat array index %d with key %s.", i, tostring(combatsArray[i][1])))
			end

			local valor = combatsArray[i][2]
			local porcentaje = valor / 100
			local diferencia = 65535 - valor
			local porcentaje_negativo = diferencia / 100
			local resultado

			if porcentaje <= porcentaje_negativo then
				resultado = string.format("+%.2f%%", porcentaje)

				widget.value:setColor("green")
			else
				resultado = string.format("-%.2f%%", porcentaje_negativo)

				widget.value:setColor("red")
			end

			widget.value:setText(resultado)

			if element then
				widget.name:setText(element.id)
			end

			widget:setMarginLeft(13)
		end
	end

	UI.CombatStats.concoctionPanel:destroyChildren()

	if concoctionsArray or next(concoctionsArray) ~= nil then
		for i = 1, #concoctionsArray do
			local widget = g_ui.createWidget("CharacterGridItem", UI.CombatStats.concoctionPanel)
			local itemId = concoctionsArray[i][1]

			widget:setId("concoction_" .. itemId)
			widget.item:setItemId(itemId)
			widget.item:setVirtual(true)

			local minutes = concoctionsArray[i][2] / 60
			local itemName = widget.item:getItem():getMarketData().name

			widget.item:setTooltip(string.format("%s: %.0f minutes", itemName, minutes))
			widget.amount:setVisible(false)
		end
	end

	local skillsIndexes = {
		[Skill.CriticalChance] = 1,
		[Skill.CriticalDamage] = 2,
		[Skill.LifeLeechAmount] = 3,
		[Skill.ManaLeechAmount] = 4
	}
	local skillIndex = skillsIndexes[Skill.CriticalChance]
	local skill = additionalSkillsArray[skillIndex][2]

	UI.CombatStats.criticalChance.value:setText(string.format("%.2f%%", skill / 100))

	if skill > 0 then
		UI.CombatStats.criticalChance.value:setColor("#44AD25")
	else
		UI.CombatStats.criticalChance.value:setColor("#C0C0C0")
	end

	skillIndex = skillsIndexes[Skill.CriticalDamage]
	skill = additionalSkillsArray[skillIndex][2]

	UI.CombatStats.criticalDamage.value:setText(string.format("%.2f%%", skill / 100))

	if skill > 0 then
		UI.CombatStats.criticalDamage.value:setColor("#44AD25")
	else
		UI.CombatStats.criticalDamage.value:setColor("#C0C0C0")
	end

	skillIndex = skillsIndexes[Skill.LifeLeechAmount]
	skill = additionalSkillsArray[skillIndex][2]

	if skill > 0 then
		UI.CombatStats.lifeLeech.value:setColor("#44AD25")
		UI.CombatStats.lifeLeech.value:setText(string.format("%.2f%%", skill / 100))
	else
		UI.CombatStats.lifeLeech.value:setColor("#C0C0C0")
		UI.CombatStats.lifeLeech.value:setText(string.format("%d%%", skill))
	end

	skillIndex = skillsIndexes[Skill.ManaLeechAmount]
	skill = additionalSkillsArray[skillIndex][2]

	if skill > 0 then
		UI.CombatStats.manaLeech.value:setColor("#44AD25")
		UI.CombatStats.manaLeech.value:setText(string.format("%.2f%%", skill / 100))
	else
		UI.CombatStats.manaLeech.value:setColor("#C0C0C0")
		UI.CombatStats.manaLeech.value:setText(string.format("%d%%", skill))
	end

	for i = 1, #forgeSkillsArray do
		local skillId = forgeSkillsArray[i][1]
		local id = "special_" .. skillId

		if UI.CombatStats[id] then
			UI.CombatStats[id]:destroy()
		end
	end

	local firstSpecial = true

	for i = 1, #forgeSkillsArray do
		local skillId = forgeSkillsArray[i][1]
		local percent = forgeSkillsArray[i][2]

		if percent > 0 then
			local widget = g_ui.createWidget("CharacterSkillBase", UI.CombatStats)

			widget:setId("special_" .. skillId)

			local specialName = {
				[16] = "Transcendence",
				[15] = "Momentum",
				[13] = "Onslaught",
				[14] = "Ruse"
			}

			if firstSpecial then
				widget:addAnchor(AnchorTop, "manaLeech", AnchorBottom)
				widget:addAnchor(AnchorLeft, "criticalHit", AnchorLeft)
				widget:addAnchor(AnchorRight, "parent", AnchorRight)
				widget:setMarginTop(5)
			else
				widget:addAnchor(AnchorTop, "prev", AnchorBottom)
				widget:addAnchor(AnchorLeft, "criticalHit", AnchorLeft)
				widget:addAnchor(AnchorRight, "parent", AnchorRight)
				widget:setMarginTop(0)
			end

			widget:setMarginLeft(0)

			local name = g_ui.createWidget("SkillNameLabel", widget)

			name:setText(specialName[skillId])
			name:setColor("#C0C0C0")

			local value = g_ui.createWidget("SkillValueLabel", widget)

			value:setText(string.format("%.2f%%", percent / 100))
			value:setColor("#C0C0C0")
			value:setMarginRight(2)
			value:setColor("#C0C0C0")

			firstSpecial = firstSpecial and false
		end
	end
end

function Cyclopedia.loadCharacterGeneralStats(data, skills, combats)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	Cyclopedia.setCharacterSkillValue("level", comma_value(data.level))

	local rawLevelPercent = player:getLevelPercent()
	local percentToGo = string.format("%.2f", 100 - (rawLevelPercent or 0) / 100)
	local percentToGoText = tr("You have %s percent to go", percentToGo)

	Cyclopedia.setCharacterSkillTooltip("level", percentToGoText)
	Cyclopedia.setCharacterSkillPercent("level", rawLevelPercent, percentToGoText)

	local currentExp = player:getExperience()

	Cyclopedia.setCharacterSkillValue("experience", comma_value(currentExp))

	local expNeeded = modules.game_skills and modules.game_skills.expToAdvance and modules.game_skills.expToAdvance(player:getLevel(), currentExp)

	if expNeeded and expNeeded > 0 then
		Cyclopedia.setCharacterSkillTooltip("experience", tr("%s XP for next level", comma_value(expNeeded)) .. "\n" .. percentToGoText)
	else
		Cyclopedia.setCharacterSkillTooltip("experience", nil)
	end

	if modules.game_skills and modules.game_skills.updateXpGainRateWidgetFromData then
		modules.game_skills.updateXpGainRateWidgetFromData(UI.CharacterStats.expGainRate, {
			base = data.baseExpGain,
			lowLevel = data.lowLevelExpBonus,
			xpBoost = data.XpBoostPercent,
			staminaMultiplier = data.staminaExpBonus
		}, {
			xpBoostRemainingSeconds = data.XpBoostBonusRemainingTime,
			staminaMinutes = data.staminaMinutes
		})
	end

	local xpBoostButton = UI.CharacterStats.xpBoostRow and UI.CharacterStats.xpBoostRow.xpBoostButton

	if xpBoostButton then
		if data.canBuyXpBoost == 1 then
			xpBoostButton:show()
		else
			xpBoostButton:hide()
		end
	end

	Cyclopedia.setCharacterSkillValue("health", comma_value(data.maxHealth))
	Cyclopedia.setCharacterSkillTooltip("health", tr("You have %s of %s Hit Points left", comma_value(data.health), comma_value(data.maxHealth)))
	Cyclopedia.setCharacterSkillValue("mana", comma_value(data.mana))
	Cyclopedia.setCharacterSkillTooltip("mana", tr("You have %s of %s Mana left", comma_value(data.mana), comma_value(data.maxMana)))
	Cyclopedia.setCharacterSkillValue("soul", data.soul)
	Cyclopedia.setCharacterSkillTooltip("soul", tr("You have %s Soul Points left", data.soul))

	local freeCapacity = math.floor(data.freeCapacity or 0)
	local totalCapacity = data.capacity
	local baseCapacity = data.baseCapacity

	Cyclopedia.setCharacterSkillValue("capacity", comma_value(freeCapacity))

	if baseCapacity < totalCapacity then
		local bonus = totalCapacity - baseCapacity

		Cyclopedia.setCharacterSkillValue("capacity", comma_value(freeCapacity), "#44AD25")
		Cyclopedia.setCharacterSkillTooltip("capacity", comma_value(totalCapacity) .. " = " .. comma_value(baseCapacity) .. " + " .. comma_value(bonus) .. "\n" .. tr("You have %s of %s Capacity left", comma_value(freeCapacity), comma_value(totalCapacity)))
	else
		Cyclopedia.setCharacterSkillTooltip("capacity", tr("You have %s of %s Capacity left", comma_value(freeCapacity), comma_value(totalCapacity)))
	end

	local speed = math.floor(data.speed)
	local baseSpeed = data.baseSpeed

	Cyclopedia.setCharacterSkillValue("speed", comma_value(speed))

	if baseSpeed < speed then
		Cyclopedia.setCharacterSkillValue("speed", comma_value(speed), "#44AD25")
		Cyclopedia.setCharacterSkillTooltip("speed", comma_value(speed) .. " = " .. comma_value(baseSpeed) .. " + " .. comma_value(speed - baseSpeed) .. "\n" .. tr("You have %s Speed", comma_value(speed)))
	else
		Cyclopedia.setCharacterSkillValue("speed", comma_value(speed), "#C0C0C0")
		Cyclopedia.setCharacterSkillTooltip("speed", tr("You have %s Speed", comma_value(speed)))
	end

	syncFoodRegenerationTime(data.regenerationCondition)
	Cyclopedia.updateFoodRegenerationDisplay(getFoodRegenerationRemaining())
	startFoodRegenerationTicker()

	local function formatTime(time)
		local hours = math.floor(time / 60)
		local minutes = time % 60

		if minutes < 10 then
			minutes = "0" .. minutes
		end

		return hours, minutes
	end

	local function formatTimeTooltip(time)
		local hours = math.floor(time / 60)
		local minutes = time % 60

		return string.format("%02d", hours), string.format("%02d", minutes)
	end

	local staminaPercent = math.floor(10000 * data.staminaMinutes / 2520)
	local staminaHours, staminaMinutes = formatTime(data.staminaMinutes)
	local staminaTooltipHours, staminaTooltipMinutes = formatTimeTooltip(data.staminaMinutes)

	Cyclopedia.setCharacterSkillValue("stamina", staminaHours .. ":" .. staminaMinutes)

	local staminaRowTooltip

	if data.staminaMinutes > 2340 and g_game.getClientVersion() >= 1038 and player:isPremium() then
		staminaRowTooltip = tr("You have %s hours and %s minutes left and receive 50%% more experience", staminaTooltipHours, staminaTooltipMinutes)
	else
		staminaRowTooltip = tr("You have %s hours and %s minutes left", staminaTooltipHours, staminaTooltipMinutes)
	end

	Cyclopedia.setCharacterSkillTooltip("stamina", staminaRowTooltip)

	if data.staminaMinutes > 2340 then
		local text

		if g_game.getClientVersion() >= 1038 and player:isPremium() then
			text = tr("You have %s hours and %s minutes left", staminaHours, staminaMinutes) .. "\n" .. tr("Now you will gain 50%% more experience")
		elseif g_game.getClientVersion() >= 1038 and not player:isPremium() then
			text = tr("You have %s hours and %s minutes left", staminaHours, staminaMinutes) .. "\n" .. tr("You will not gain 50%% more experience because you aren't premium player, now you receive only 1x experience points")
		else
			text = tr("You have %s hours and %s minutes left", staminaHours, staminaMinutes) .. "\n" .. tr("If you are premium player, you will gain 50%% more experience")
		end

		Cyclopedia.setCharacterSkillPercent("stamina", staminaPercent, text, "green")
	elseif data.staminaMinutes <= 840 then
		Cyclopedia.setCharacterSkillPercent("stamina", staminaPercent, staminaRowTooltip, "#C00000")
	else
		Cyclopedia.setCharacterSkillPercent("stamina", staminaPercent, staminaRowTooltip, "#C06000")
	end

	local trainerHours, trainerMinutes = formatTime(data.offlineTrainingTime)
	local trainerTooltipHours, trainerTooltipMinutes = formatTimeTooltip(data.offlineTrainingTime)
	local trainerPercent = math.floor(10000 * data.offlineTrainingTime / 720)
	local trainerTooltip = tr("You have %s hours and %s minutes of offline training time left", trainerTooltipHours, trainerTooltipMinutes)

	Cyclopedia.setCharacterSkillValue("trainer", trainerHours .. ":" .. trainerMinutes)
	Cyclopedia.setCharacterSkillTooltip("trainer", trainerTooltip)
	Cyclopedia.setCharacterSkillPercent("trainer", trainerPercent, trainerTooltip)

	local magicLoyaltyField = data.loyaltyMagicLevel

	if magicLoyaltyField == nil and player.getMagicLoyalty then
		magicLoyaltyField = player:getMagicLoyalty()
	end

	Cyclopedia.updateCharacterLoyaltySkill("magiclevel", data.magicLevel, data.baseMagicLevel, magicLoyaltyField or 0, data.magicLevelPercent, combats)

	for i = Skill.Fist + 1, Skill.Fishing + 1 do
		local skillLevel, baseSkill, skillPercent, loyaltySkill = unpack(skills[i])

		Cyclopedia.updateCharacterLoyaltySkill("skillId" .. i - 1, skillLevel, baseSkill, loyaltySkill, skillPercent)
	end
end

function Cyclopedia.updateFoodRegenerationDisplay(regenerationTime)
	if not UI or not UI.CharacterStats or UI.CharacterStats:isDestroyed() then
		return
	end

	local remaining = math.max(0, regenerationTime or 0)

	Cyclopedia.setCharacterSkillValue("food", formatFoodRegenerationTime(remaining))
	Cyclopedia.setCharacterSkillTooltip("food", buildFoodRegenerationTooltip(remaining))
end

function Cyclopedia.setCharacterSkillTooltip(id, tooltip)
	local skill = UI.CharacterStats:recursiveGetChildById(id)

	if not skill then
		return
	end

	if tooltip and tooltip ~= "" then
		skill:setTooltip(tooltip)
	else
		skill:removeTooltip()
	end
end

function Cyclopedia.setCharacterSkillValue(id, value, color)
	local skill = UI.CharacterStats:recursiveGetChildById(id)
	local widget = skill:getChildById("value")

	widget:setText(value)
	widget:setColor(color or "#C0C0C0")
end

function Cyclopedia.setCharacterSkillPercent(id, percent, tooltip, color)
	local skill = UI.CharacterStats:recursiveGetChildById(id)
	local widget = skill:getChildById("percent")

	if widget then
		widget:setPercent(math.floor((percent or 0) / 100))

		if tooltip then
			widget:setTooltip(tooltip)
		end

		if color then
			widget:setBackgroundColor(color)
		end
	end
end

function Cyclopedia.updateCharacterLoyaltySkill(id, value, baseValue, loyaltyField, rawPercent, magicLevelBonuses)
	Cyclopedia.setCharacterSkillValue(id, value)
	Cyclopedia.setCharacterSkillPercent(id, rawPercent)
	Cyclopedia.setCharacterSkillBase(id, value, baseValue, loyaltyField, rawPercent, magicLevelBonuses)
end

function Cyclopedia.buildCharacterSkillTooltip(value, baseValue, loyaltyField, rawPercent, magicLevelBonuses)
	local skillsModule = modules.game_skills
	local percentLine

	if skillsModule and skillsModule.skillPercentToGoTooltipForDisplay then
		percentLine = skillsModule.skillPercentToGoTooltipForDisplay(rawPercent)
	else
		percentLine = tr("You have %s percent to go", string.format("%.2f", 100 - (rawPercent or 0) / 100))
	end

	if not skillsModule or not skillsModule.resolveSkillBonusesForDisplay then
		if skillsModule and skillsModule.appendMagicLevelModifiersTooltipForDisplay then
			return skillsModule.appendMagicLevelModifiersTooltipForDisplay(percentLine, magicLevelBonuses)
		end

		return percentLine
	end

	local itemBonus, loyaltyBonus = skillsModule.resolveSkillBonusesForDisplay(value, baseValue, loyaltyField or 0)
	local tooltip

	if itemBonus > 0 or loyaltyBonus > 0 then
		local breakdown = skillsModule.buildLoyaltySkillTooltipLineForDisplay(value, baseValue, loyaltyField or 0)

		tooltip = breakdown .. "\n" .. percentLine
	else
		tooltip = percentLine
	end

	if skillsModule.appendMagicLevelModifiersTooltipForDisplay then
		return skillsModule.appendMagicLevelModifiersTooltipForDisplay(tooltip, magicLevelBonuses)
	end

	return tooltip
end

function Cyclopedia.setCharacterSkillBase(id, value, baseValue, loyaltyField, rawPercent, magicLevelBonuses)
	if value < 0 or baseValue < 0 then
		return
	end

	local skill = UI.CharacterStats:recursiveGetChildById(id)

	if not skill then
		return
	end

	local widget = skill:getChildById("value")
	local percentWidget = skill:getChildById("percent")
	local isLoyaltySkill = id == "magiclevel" or type(id) == "string" and id:match("^skillId%d+$") ~= nil
	local skillsModule = modules.game_skills

	if isLoyaltySkill then
		local itemBonus = 0

		if skillsModule and skillsModule.resolveSkillBonusesForDisplay then
			itemBonus = select(1, skillsModule.resolveSkillBonusesForDisplay(value, baseValue, loyaltyField or 0))
		end

		local tooltip = Cyclopedia.buildCharacterSkillTooltip(value, baseValue, loyaltyField, rawPercent, id == "magiclevel" and magicLevelBonuses or nil)

		if itemBonus > 0 then
			widget:setColor("#44AD25")
		elseif value < baseValue then
			widget:setColor("#b22222")

			if id == "magiclevel" and tooltip then
				skill:setTooltip(tooltip)
			else
				skill:setTooltip(baseValue .. " " .. value - baseValue)
			end

			if percentWidget then
				percentWidget:setTooltip(tooltip)
			end

			return
		else
			widget:setColor("#bbbbbb")
		end

		skill:setTooltip(tooltip)

		if percentWidget then
			percentWidget:setTooltip(tooltip)
		end

		return
	end

	if baseValue < value then
		widget:setColor("#44AD25")
		skill:setTooltip(baseValue .. " +" .. value - baseValue)
	elseif value < baseValue then
		widget:setColor("#b22222")
		skill:setTooltip(baseValue .. " " .. value - baseValue)
	else
		widget:setColor("#bbbbbb")
		skill:removeTooltip()
	end
end

function Cyclopedia.selectCharacterPage()
	local selectedOption = UI.selectedOption

	UI[selectedOption]:setVisible(false)
	UI.InfoBase:setVisible(true)
	Cyclopedia.closeCharacterButtons()

	local oldOpen = UI.openedCategory

	if oldOpen ~= nil then
		close(oldOpen)
	end

	UI.selectedOption = "InfoBase"
end

function Cyclopedia.closeCharacterButtons()
	local size = UI.OptionsBase:getChildCount()

	for i = 1, size do
		local widget = UI.OptionsBase:getChildByIndex(i)

		if widget then
			if widget.subCategories ~= nil then
				for subId, _ in ipairs(widget.subCategories) do
					local subWidget = widget:getChildById(subId)

					if subWidget then
						setCharacterCategoryButtonChecked(subWidget.Button, false)
						subWidget.Button.Arrow:setVisible(false)
					end
				end
			else
				setCharacterCategoryButtonChecked(widget.Button, false)
				widget.Button.Arrow:setVisible(false)
			end
		end
	end
end

function Cyclopedia.configureCharacterCategories()
	UI.OptionsBase:destroyChildren()

	local buttons = {
		{
			icon = "/images/icons/icon-character-generalstats",
			text = "General Stats",
			subCategories = function()
				local categories = {
					{
						open = "CharacterStats",
						icon = "/images/icons/icon-character-generalstats-overview",
						text = "Character Stats"
					}
				}

				if g_game.getClientVersion() < 1410 then
					table.insert(categories, {
						open = "CombatStats",
						icon = "/images/icons/icon-character-generalstats-offence",
						text = "Combat Stats"
					})
				else
					table.insert(categories, {
						open = "OffenceStats",
						icon = "/images/icons/icon-character-generalstats-offence",
						text = "Offence Stats"
					})
					table.insert(categories, {
						open = "DeffenceStats",
						icon = "/images/icons/icon-character-generalstats-defence",
						text = "Deffence Stats"
					})
					table.insert(categories, {
						open = "MiscStats",
						icon = "/images/icons/icon-character-generalstats-misc",
						text = "Misc. Stats"
					})
				end

				return categories
			end
		},
		{
			icon = "/images/icons/icon-character-battleresults",
			text = "Battle Results",
			subCategories = {
				{
					open = "RecentDeaths",
					icon = "/images/icons/icon-character-battleresults-recentdeaths",
					text = "Recent Deaths"
				},
				{
					open = "RecentKills",
					icon = "/images/icons/icon-character-battleresults-recentpvpkills",
					text = "Recent PvP Kills"
				}
			}
		},
		{
			open = "CharacterAchievements",
			icon = "/images/icons/icon-character-achievement",
			text = "Achievements"
		},
		{
			open = "CharacterItems",
			icon = "/images/icons/icon-character-items",
			text = "Item Summary"
		},
		{
			open = "CharacterAppearances",
			icon = "/images/icons/icon-character-outfitsmounts",
			text = "Appearances"
		},
		{
			open = "StoreSummary",
			icon = "/images/icons/icon-character-store",
			text = "Store Summary"
		},
		{
			open = "CharacterTitles",
			icon = "/images/icons/icon-character-titles",
			text = "Character Titles"
		}
	}

	for id, button in ipairs(buttons) do
		local widgetStyle = button.subCategories ~= nil and "CharacterCategoryGroup" or "CharacterCategoryItem"
		local widget = g_ui.createWidget(widgetStyle, UI.OptionsBase)

		widget:setId(id)
		widget.Button.Icon:setIcon(button.icon)
		widget.Button.Title:setText(button.text)

		if button.open ~= nil then
			widget.open = button.open
		end

		if button.subCategories ~= nil then
			local subCats = button.subCategories

			if type(subCats) == "function" then
				subCats = subCats()
			end

			widget.subCategories = subCats
			widget.subCategoriesSize = #subCats

			widget.Button.Arrow:setVisible(true)

			widget.closedSize = CATEGORY_BASE_HEIGHT
			widget.openedSize = CATEGORY_BASE_HEIGHT + widget.subCategoriesSize * SUBCATEGORY_HEIGHT

			widget:setHeight(widget.closedSize)

			for subId, subButton in ipairs(subCats) do
				local subWidget = g_ui.createWidget("CharacterCategoryItem", widget)

				subWidget:setId(subId)
				subWidget.Button.Icon:setIcon(subButton.icon)
				subWidget.Button.Title:setText(subButton.text)
				subWidget:setVisible(false)

				subWidget.open = subButton.open

				subWidget:setImageSource("")
				subWidget:setImageBorder(0)
				subWidget:setHeight(SUBCATEGORY_HEIGHT)
				bindSubcategoryButtonHandlers(subWidget.Button)

				function subWidget.Button:onClick(test)
					local selectedOption = UI.selectedOption

					Cyclopedia.closeCharacterButtons()
					setCharacterCategoryButtonChecked(subWidget.Button, true)
					subWidget.Button.Arrow:setVisible(true)
					subWidget.Button.Arrow:setImageSource("/game_cyclopedia/images/icon-arrow7x7-right")
					subWidget.Button.Arrow:setMarginRight(SUBCATEGORY_ARROW_MARGIN_RIGHT)
					UI[selectedOption]:setVisible(false)
					UI[subWidget.open]:setVisible(true)

					if subWidget.open == "CharacterStats" then
						g_game.requestCharacterInfo(0, CyclopediaCharacterInfoTypes.GeneralStats)
						g_game.requestCharacterInfo(0, CyclopediaCharacterInfoTypes.Badges)
					elseif subWidget.open == "CombatStats" then
						g_game.requestCharacterInfo(0, CyclopediaCharacterInfoTypes.CombatStats)
					elseif subWidget.open == "OffenceStats" then
						g_game.requestCharacterInfo(0, CyclopediaCharacterInfoTypes.Offencestats)
					elseif subWidget.open == "DeffenceStats" then
						g_game.requestCharacterInfo(0, CyclopediaCharacterInfoTypes.Defencestats)
					elseif subWidget.open == "MiscStats" then
						g_game.requestCharacterInfo(0, CyclopediaCharacterInfoTypes.Miscstats)
					elseif subWidget.open == "RecentDeaths" then
						g_game.requestCharacterInfo(0, CyclopediaCharacterInfoTypes.RecentDeaths, 23, 1)
					elseif subWidget.open == "RecentKills" then
						g_game.requestCharacterInfo(0, CyclopediaCharacterInfoTypes.RecentPVPKills, 23, 1)
					end

					UI.selectedOption = subWidget.open
				end

				subWidget:setMarginLeft(0)

				if subId == 1 then
					subWidget:addAnchor(AnchorTop, "parent", AnchorTop)
					subWidget:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
					subWidget:setMarginTop(20)
				else
					subWidget:addAnchor(AnchorTop, "prev", AnchorBottom)
					subWidget:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
					subWidget:setMarginTop(1)
				end
			end
		elseif button.open ~= nil then
			bindSubcategoryButtonHandlers(widget.Button)
		end

		widget:setMarginLeft(-3)

		if id == 1 then
			widget:addAnchor(AnchorTop, "parent", AnchorTop)
			widget:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
			widget:setMarginTop(7)
		else
			widget:addAnchor(AnchorTop, "prev", AnchorBottom)
			widget:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
			widget:setMarginTop(4)
		end

		function widget.Button.onClick(this)
			if widget.open == "CharacterAchievements" then
				Cyclopedia.loadCharacterAchievements()
			elseif widget.open == "CharacterItems" then
				Cyclopedia.resetCharacterItemsFiltersUI()
				g_game.requestCharacterInfo(0, CyclopediaCharacterInfoTypes.ItemSummary)
			elseif widget.open == "CharacterAppearances" then
				Cyclopedia.applyCharacterAppearancesDefaultFilters()
				g_game.requestCharacterInfo(0, CyclopediaCharacterInfoTypes.OutfitsAndMounts)
			elseif widget.open == "StoreSummary" then
				g_game.requestCharacterInfo(0, CyclopediaCharacterInfoTypes.StoreSummary)
			elseif widget.open == "CharacterTitles" then
				g_game.requestCharacterInfo(0, CyclopediaCharacterInfoTypes.Titles)
			end

			local parent = this:getParent()

			if parent.subCategoriesSize ~= nil then
				parent.closedSize = parent.closedSize or CATEGORY_BASE_HEIGHT
				parent.openedSize = parent.openedSize or CATEGORY_BASE_HEIGHT + parent.subCategoriesSize * SUBCATEGORY_HEIGHT

				open(parent)
			else
				local oldOpen = UI.openedCategory
				local selectedOption = UI.selectedOption

				Cyclopedia.closeCharacterButtons()
				this.Arrow:setImageSource("/game_cyclopedia/images/icon-arrow7x7-right")
				this.Arrow:setVisible(true)
				this.Arrow:setMarginRight(SUBCATEGORY_ARROW_MARGIN_RIGHT)

				if oldOpen ~= nil and oldOpen ~= parent then
					close(oldOpen)
				end

				setCharacterCategoryButtonChecked(this, true)
				UI[selectedOption]:setVisible(false)
				UI[parent.open]:setVisible(true)

				UI.selectedOption = parent.open
			end
		end
	end
end

function Cyclopedia.getPreyRowsFromModule()
	local preyRows = {}

	if not modules.game_prey or not modules.game_prey.getCyclopediaActivePreySlots then
		return preyRows
	end

	for _, preySlot in ipairs(modules.game_prey.getCyclopediaActivePreySlots()) do
		table.insert(preyRows, {
			order = preySlot.slot,
			slot = preySlot.slot,
			value = preySlot.description
		})
	end

	table.sort(preyRows, function(a, b)
		return a.order < b.order
	end)

	return preyRows
end

function Cyclopedia.resolveCharacterOutfitName(protocolOutfitName)
	if protocolOutfitName and protocolOutfitName ~= "" then
		return protocolOutfitName
	end

	local player = g_game.getLocalPlayer()

	if not player then
		return nil
	end

	local lookType = Cyclopedia.Character.InspectionOutfit and Cyclopedia.Character.InspectionOutfit.type

	if not lookType or lookType == 0 then
		lookType = player:getOutfit().type
	end

	if not lookType or lookType == 0 then
		return nil
	end

	local namesByLook = Cyclopedia.Character.OutfitNamesByLookType

	if namesByLook and namesByLook[lookType] and namesByLook[lookType] ~= "" then
		return namesByLook[lookType]
	end

	if Cyclopedia.Character.Appearances then
		for _, appearance in ipairs(Cyclopedia.Character.Appearances) do
			if appearance.type == "outfits" and appearance.outfit and appearance.outfit.type == lookType and appearance.name and appearance.name ~= "" then
				return appearance.name
			end
		end
	end

	if modules.game_outfit and modules.game_outfit.getOutfitNameByLookType then
		local name = modules.game_outfit.getOutfitNameByLookType(lookType)

		if name and name ~= "" then
			return name
		end
	end

	return nil
end

function Cyclopedia.getCharacterLevelAndVocation(parts)
	local level = parts and parts.level
	local vocation = parts and parts.vocation
	local player = g_game.getLocalPlayer()

	if player then
		if not level or level == "" then
			level = tostring(player:getLevel())
		end

		if not vocation or vocation == "" then
			vocation = player:getVocationNameByClientId()
		end
	end

	return level, vocation
end

function Cyclopedia.buildCharacterDescriptionRowsFromParts(level, vocation, preyRows, outfit)
	local rows = {}

	if level and level ~= "" then
		table.insert(rows, {
			tr("Level"),
			level
		})
	end

	if vocation and vocation ~= "" then
		table.insert(rows, {
			tr("Vocation"),
			vocation
		})
	end

	for _, prey in ipairs(preyRows or {}) do
		table.insert(rows, {
			tr("Active Prey %d", prey.slot),
			prey.value
		})
	end

	if outfit then
		table.insert(rows, {
			tr("Outfit"),
			outfit
		})
	end

	return rows
end

function Cyclopedia.applyCharacterDescriptionParts()
	local parts = Cyclopedia.Character.DescriptionParts
	local preyRows

	if parts and parts.protocolPreyRows and #parts.protocolPreyRows > 0 then
		preyRows = parts.protocolPreyRows
	else
		preyRows = Cyclopedia.getPreyRowsFromModule()
	end

	local level, vocation = Cyclopedia.getCharacterLevelAndVocation(parts)
	local outfitName = Cyclopedia.resolveCharacterOutfitName(parts and parts.outfit or nil)

	if parts or level or vocation or outfitName or #preyRows > 0 then
		Cyclopedia.Character.DescriptionRows = Cyclopedia.buildCharacterDescriptionRowsFromParts(level, vocation, preyRows, outfitName)
	else
		Cyclopedia.Character.DescriptionRows = {}
	end

	if not Cyclopedia.Character.InfoItemSelected then
		Cyclopedia.renderCharacterDescription()
	end
end

function Cyclopedia.refreshCharacterPreyIfVisible()
	if UI and UI.InfoBase and not UI:isDestroyed() and UI.selectedOption == "InfoBase" then
		if Cyclopedia.Character.InfoItemSelected then
			return
		end

		Cyclopedia.applyCharacterDescriptionParts()
	end
end

function Cyclopedia.isCharacterInfoBaseActive()
	return UI and not UI:isDestroyed() and UI.selectedOption == "InfoBase" and UI.InfoBase and UI.InfoBase.inventoryPanel and UI.InfoBase.inventoryPanel:isVisible()
end

function Cyclopedia.clearCharacterInventorySelection()
	local selectedWidget = Cyclopedia.Character.selectedInventorySlotWidget

	if selectedWidget and not selectedWidget:isDestroyed() then
		selectedWidget:setBorderWidth(0)
	end

	Cyclopedia.Character.selectedInventorySlotWidget = nil
	Cyclopedia.Character.selectedInventorySlot = nil
	Cyclopedia.Character.InfoItemSelected = false
end

function Cyclopedia.setCharacterInventorySlotSelected(widget, selected)
	if not widget or widget:isDestroyed() then
		return
	end

	if selected then
		widget:setBorderWidth(1)
		widget:setBorderColor("#FFFFFF")
	else
		widget:setBorderWidth(0)
	end
end

local function isTierDetailKey(key)
	key = tostring(key or ""):gsub("^%s+", ""):gsub("%s+$", "")

	return key == "Tier" or key:match("^Tier:?%s*$") ~= nil
end

local function isImbuementSlotsDetailKey(key)
	return tostring(key or ""):find("Imbuement Slots", 1, true) ~= nil
end

function Cyclopedia.getCharacterSelectedItemTier()
	local slot = Cyclopedia.Character.selectedInventorySlot

	if not slot or not UI or not UI.InfoBase or not UI.InfoBase.inventoryPanel then
		return 0
	end

	local widget = UI.InfoBase.inventoryPanel["slot" .. slot]
	local item = widget and widget:getItem()

	if not item or not item.getTier then
		return 0
	end

	return item:getTier() or 0
end

function Cyclopedia.prepareCharacterItemDescriptionRows(descriptions)
	local rows = {}

	for _, description in ipairs(descriptions or {}) do
		local key = description.key or description[1]
		local value = description.value or description[2]

		if key and not isTierDetailKey(key) and value ~= nil and value ~= "" then
			table.insert(rows, {
				tostring(key),
				tostring(value)
			})
		end
	end

	local tierRow = {
		tr("Tier"),
		tostring(Cyclopedia.getCharacterSelectedItemTier())
	}
	local insertAt = #rows + 1

	for i, row in ipairs(rows) do
		if isImbuementSlotsDetailKey(row[1]) then
			insertAt = i

			break
		end
	end

	table.insert(rows, insertAt, tierRow)

	return rows
end

function Cyclopedia.renderCharacterItemDetail(descriptions)
	if not Cyclopedia.isCharacterInfoBaseActive() or not UI.InfoBase.DetailsBase then
		return
	end

	UI.InfoBase.DetailsBase.List:destroyChildren()

	for _, row in ipairs(Cyclopedia.prepareCharacterItemDescriptionRows(descriptions)) do
		Cyclopedia.appendDetailKeyValueRow(UI.InfoBase.DetailsBase.List, row[1], row[2])
	end
end

function Cyclopedia.showCharacterPlayerDetails()
	if not UI or not UI.InfoBase then
		return
	end

	Cyclopedia.clearCharacterInventorySelection()

	local player = g_game.getLocalPlayer()

	if player and UI.InfoBase.InspectLabel then
		UI.InfoBase.InspectLabel:setText(tr("You are inspecting") .. ": " .. player:getName())
	end

	Cyclopedia.renderCharacterDescription()
end

function Cyclopedia.onCharacterInventorySlotClick(slot, widget)
	if not Cyclopedia.isCharacterInfoBaseActive() then
		return
	end

	local item = widget:getItem()

	if not item then
		Cyclopedia.showCharacterPlayerDetails()

		return
	end

	if Cyclopedia.Character.selectedInventorySlot == slot then
		Cyclopedia.showCharacterPlayerDetails()

		return
	end

	Cyclopedia.clearCharacterInventorySelection()

	Cyclopedia.Character.selectedInventorySlot = slot
	Cyclopedia.Character.selectedInventorySlotWidget = widget
	Cyclopedia.Character.InfoItemSelected = true

	Cyclopedia.setCharacterInventorySlotSelected(widget, true)

	local cached = Cyclopedia.Character.InspectionInventoryBySlot and Cyclopedia.Character.InspectionInventoryBySlot[slot]
	local itemName = cached and cached.name or item:getName()

	if itemName and itemName ~= "" and UI.InfoBase.InspectLabel then
		UI.InfoBase.InspectLabel:setText(tr("You are inspecting") .. ": " .. itemName)
	end

	if cached and cached.descriptions and #cached.descriptions > 0 then
		Cyclopedia.renderCharacterItemDetail(cached.descriptions)
	else
		UI.InfoBase.DetailsBase.List:destroyChildren()
	end

	g_game.inspectionObject(3, item:getId(), math.max(1, item:getCount()))
end

function Cyclopedia.bindCharacterInventorySlots()
	if not UI or not UI.InfoBase or not UI.InfoBase.inventoryPanel then
		return
	end

	for slot = InventorySlotFirst, InventorySlotPurse do
		local itemWidget = UI.InfoBase.inventoryPanel["slot" .. slot]

		if itemWidget then
			function itemWidget.onMouseRelease(widget, mousePos, mouseButton)
				if mouseButton == MouseLeftButton then
					Cyclopedia.onCharacterInventorySlotClick(slot, widget)
				end

				return false
			end
		end
	end
end

function Cyclopedia.handleCharacterItemDetail(itemId, descriptions)
	if not Cyclopedia.Character.InfoItemSelected or not Cyclopedia.isCharacterInfoBaseActive() then
		return false
	end

	local selectedSlot = Cyclopedia.Character.selectedInventorySlot

	if selectedSlot then
		local widget = UI.InfoBase.inventoryPanel["slot" .. selectedSlot]
		local item = widget and widget:getItem()

		if item and item:getId() ~= itemId then
			return false
		end
	end

	Cyclopedia.renderCharacterItemDetail(descriptions)

	return true
end

function Cyclopedia.buildCharacterDescriptionRows()
	if not g_game.getLocalPlayer() then
		return {}
	end

	local level, vocation = Cyclopedia.getCharacterLevelAndVocation(Cyclopedia.Character.DescriptionParts)

	return Cyclopedia.buildCharacterDescriptionRowsFromParts(level, vocation, Cyclopedia.getPreyRowsFromModule(), Cyclopedia.resolveCharacterOutfitName(Cyclopedia.Character.DescriptionParts and Cyclopedia.Character.DescriptionParts.outfit))
end

function Cyclopedia.loadCharacterInspection(data)
	if not data then
		return
	end

	Cyclopedia.Character.InspectionInventoryBySlot = {}

	if data.inventoryItems then
		for _, entry in ipairs(data.inventoryItems) do
			if entry.slot ~= nil then
				Cyclopedia.Character.InspectionInventoryBySlot[entry.slot] = entry
			end
		end
	end

	if data.outfit then
		setCharacterInspectionOutfit(data.outfit)
		Cyclopedia.applyCharacterOutfitWidgets()
	end

	if not data.playerDescriptions then
		return
	end

	local level, vocation, outfit
	local preyRows = {}

	for _, desc in ipairs(data.playerDescriptions) do
		local key = desc.key or desc[1]
		local value = desc.value or desc[2]

		if key and value and value ~= "" then
			if key == "Level" or key:match("^Level:?%s*$") then
				level = value
			elseif key == "Vocation" or key:match("^Vocation:?%s*$") then
				vocation = value
			elseif key == "Outfit" or key:match("^Outfit:?%s*$") then
				outfit = value
			elseif key:match("^Active Prey ") then
				local serverSlot = tonumber(key:match("Active Prey (%d+)"))

				table.insert(preyRows, {
					order = serverSlot or 0,
					slot = serverSlot and serverSlot - 1 or 0,
					value = value
				})
			end
		end
	end

	table.sort(preyRows, function(a, b)
		return a.order < b.order
	end)

	if not level and not vocation and not outfit and #preyRows == 0 then
		return
	end

	Cyclopedia.Character.DescriptionParts = {
		level = level,
		vocation = vocation,
		outfit = outfit,
		protocolPreyRows = preyRows
	}

	Cyclopedia.applyCharacterDescriptionParts()
end

function Cyclopedia.renderCharacterDescription()
	if not UI or not UI.InfoBase or not UI.InfoBase.DetailsBase then
		return
	end

	if UI.selectedOption ~= "InfoBase" then
		return
	end

	if Cyclopedia.Character.InfoItemSelected then
		return
	end

	UI.InfoBase.DetailsBase.List:destroyChildren()

	local rows = Cyclopedia.Character.DescriptionRows or Cyclopedia.buildCharacterDescriptionRows()

	for _, description in ipairs(rows) do
		Cyclopedia.appendDetailKeyValueRow(UI.InfoBase.DetailsBase.List, description[1], tostring(description[2]))
	end
end

function Cyclopedia.createCharacterDescription()
	Cyclopedia.renderCharacterDescription()
end

function Cyclopedia.openWheelOfDestiny()
	if not g_game.isOnline() then
		return
	end

	hide()

	if CyclopediaButton then
		CyclopediaButton:setOn(false)
	end

	if modules.game_wheel and modules.game_wheel.openForPlayer then
		modules.game_wheel.openForPlayer()
	elseif g_game.openWheel then
		g_game.openWheel()
	end
end

function Cyclopedia.characterButton(widget)
	if widget.state == 1 then
		widget.state = 2

		widget:setIcon("/game_cyclopedia/images/icon-equipmentdetails")
		refreshCharacterButtonIconOffset(widget, false)
		Cyclopedia.showCharacterPlayerDetails()
		UI.InfoBase.inventoryPanel:setVisible(false)
		UI.InfoBase.outfitPanel:setVisible(true)
		Cyclopedia.applyCharacterOutfitWidgets()
	else
		widget.state = 1

		widget:setIcon("/game_cyclopedia/images/icon-playerdetails")
		refreshCharacterButtonIconOffset(widget, false)
		UI.InfoBase.inventoryPanel:setVisible(true)
		UI.InfoBase.outfitPanel:setVisible(false)
		Cyclopedia.bindCharacterInventorySlots()
	end
end

local function getCharacterTitlesList()
	if not UI or not UI.CharacterTitles or not UI.CharacterTitles.AvailableTitlesPanel then
		return nil
	end

	local listBase = UI.CharacterTitles.AvailableTitlesPanel.ListBase

	if not listBase then
		return nil
	end

	return listBase.List
end

local function titleMatchesFilter(isPermanent, isUnlocked)
	if characterTitlesFilterMode == "permanent" then
		return isPermanent
	elseif characterTitlesFilterMode == "temporary" then
		return not isPermanent
	elseif characterTitlesFilterMode == "unlocked" then
		return isUnlocked
	elseif characterTitlesFilterMode == "locked" then
		return not isUnlocked
	end

	return true
end

function Cyclopedia.loadCharacterTitles(currentTitle, titles)
	if not UI or not UI.CharacterTitles then
		return
	end

	characterTitlesCurrentTitle = tonumber(currentTitle) or 0
	characterTitlesSelectedId = characterTitlesCurrentTitle
	characterTitlesCache = titles or {}

	Cyclopedia.refreshCharacterTitles()
end

local function applyCharacterTitleRowSelection(row, selected)
	if not row or row:isDestroyed() then
		return
	end

	row:setBackgroundColor(selected and TITLE_SELECTED_ROW_COLOR or row.rowColor or "#484848")

	if row.Name then
		row.Name:setColor(selected and TITLE_SELECTED_NAME_COLOR or TITLE_NAME_COLOR)
	end

	if row.EditIcon then
		row.EditIcon:setVisible(selected and row.titleId == characterTitlesCurrentTitle)
	end

	if row.InfoIcon then
		row.InfoIcon:setVisible(selected)
	end
end

local function selectCharacterTitleRow(row)
	local list = getCharacterTitlesList()

	if not list or not row or row:isDestroyed() then
		return
	end

	characterTitlesSelectedId = row.titleId or 0
	characterTitlesCurrentDescription = row.titleDescription or ""

	for i = 1, list:getChildCount() do
		local child = list:getChildByIndex(i)

		applyCharacterTitleRowSelection(child, child == row)
	end
end

function Cyclopedia.refreshCharacterTitles(currentTitle)
	local list = getCharacterTitlesList()

	if not list then
		return
	end

	list:destroyChildren()

	if currentTitle ~= nil then
		characterTitlesCurrentTitle = tonumber(currentTitle) or characterTitlesCurrentTitle
		characterTitlesSelectedId = characterTitlesCurrentTitle
	end

	local selectedTitleId = characterTitlesSelectedId or characterTitlesCurrentTitle or 0
	local searchText = string.lower((characterTitlesSearchText or ""):trim())
	local selectedTitleText = tr("(No character title selected)")

	characterTitlesCurrentDescription = ""

	local color = "#484848"
	local selectedRow

	for _, entry in ipairs(characterTitlesCache or {}) do
		local titleId = tonumber(entry[1]) or 0
		local titleName = entry[2] or "?"
		local titleDescription = entry[3] or ""
		local isPermanent = entry[4] == true or entry[4] == 1
		local isUnlocked = entry[5] == true or entry[5] == 1
		local lowerName = string.lower(titleName)
		local lowerDescription = string.lower(titleDescription)
		local matchesSearch = searchText == "" or lowerName:find(searchText, 1, true) or lowerDescription:find(searchText, 1, true)

		if characterTitlesCurrentTitle > 0 and titleId == characterTitlesCurrentTitle then
			selectedTitleText = titleName

			if selectedTitleId == titleId then
				characterTitlesCurrentDescription = titleDescription
			end
		end

		if matchesSearch and titleMatchesFilter(isPermanent, isUnlocked) then
			local row = g_ui.createWidget("CharacterTitleListRow", list)
			local isSelected = selectedTitleId > 0 and selectedTitleId == titleId

			row.titleId = titleId
			row.titleName = titleName
			row.titleDescription = titleDescription
			row.isUnlocked = isUnlocked
			row.rowColor = color

			row:setHeight(16)
			row:setMinHeight(16)
			row:setMaxHeight(16)

			if row.Name then
				row.Name:setText(titleName)
			end

			if row.PermanentIcon then
				row.PermanentIcon:setImageSource(isPermanent and TITLE_ICON_YES or TITLE_ICON_NO)
			end

			if row.UnlockedIcon then
				row.UnlockedIcon:setImageSource(isUnlocked and TITLE_ICON_YES or TITLE_ICON_NO)
			end

			local tooltipText = titleDescription ~= "" and titleDescription or titleName

			row:setTooltip(tooltipText)

			if row.InfoIcon then
				row.InfoIcon:setTooltip(tooltipText)
			end

			applyCharacterTitleRowSelection(row, isSelected)

			if isSelected then
				selectedRow = row
				characterTitlesCurrentDescription = titleDescription
			end

			function row:onClick()
				selectCharacterTitleRow(self)

				if not self.isUnlocked then
					return
				end

				if self.titleId == characterTitlesCurrentTitle then
					return
				end

				g_game.requestSelectCharacterTitle(self.titleId)
			end

			color = color == "#484848" and "#414141" or "#484848"
		end
	end

	if selectedRow then
		selectCharacterTitleRow(selectedRow)
	end

	local currentPanel = UI.CharacterTitles.CurrentTitlePanel

	if currentPanel and currentPanel.CurrentTitleValue then
		currentPanel.CurrentTitleValue:setText(selectedTitleText)

		if currentPanel.CurrentTitleInfo then
			local infoText = ""

			for _, entry in ipairs(characterTitlesCache or {}) do
				if (tonumber(entry[1]) or 0) == characterTitlesCurrentTitle then
					infoText = entry[3] or entry[2] or ""

					break
				end
			end

			currentPanel.CurrentTitleInfo:setTooltip(infoText ~= "" and infoText or selectedTitleText)
			currentPanel.CurrentTitleInfo:setVisible(characterTitlesCurrentTitle > 0)
		end

		if currentPanel.CurrentTitleClear then
			currentPanel.CurrentTitleClear:setVisible(characterTitlesCurrentTitle > 0)
		end
	end
end

function Cyclopedia.characterTitlesSearch(text)
	characterTitlesSearchText = text or ""

	Cyclopedia.refreshCharacterTitles()
end

function Cyclopedia.characterTitlesClearSearch()
	if not UI or not UI.CharacterTitles or not UI.CharacterTitles.AvailableTitlesPanel then
		return
	end

	local searchEdit = UI.CharacterTitles.AvailableTitlesPanel.filters and UI.CharacterTitles.AvailableTitlesPanel.filters.SearchEdit

	if not searchEdit or searchEdit:isDestroyed() then
		return
	end

	if searchEdit:getText() == "" then
		return
	end

	searchEdit:setText("")
	Cyclopedia.characterTitlesSearch("")
end

function Cyclopedia.characterTitlesFilter(widget)
	if Cyclopedia.Character.TitlesFilterResetting then
		return
	end

	if not UI or not UI.CharacterTitles or not UI.CharacterTitles.AvailableTitlesPanel then
		return
	end

	local filters = UI.CharacterTitles.AvailableTitlesPanel.filters

	if not filters or not widget or widget:isDestroyed() then
		return
	end

	local mode = widget:getId() or "all"
	local validModes = {
		temporary = true,
		locked = true,
		unlocked = true,
		all = true,
		permanent = true
	}

	if not validModes[mode] then
		mode = "all"
	end

	characterTitlesFilterMode = mode
	Cyclopedia.Character.TitlesFilterResetting = true

	for i = 1, filters:getChildCount() do
		local child = filters:getChildByIndex(i)

		if child and child.setChecked and child.getId then
			local id = child:getId()

			if validModes[id] then
				child:setChecked(id == mode)
			end
		end
	end

	Cyclopedia.Character.TitlesFilterResetting = false

	Cyclopedia.refreshCharacterTitles()
end

function Cyclopedia.characterTitleClear()
	if characterTitlesCurrentTitle <= 0 then
		return
	end

	g_game.requestSelectCharacterTitle(0)
end

function Cyclopedia.characterTitleShowCurrentInfo()
	local text = characterTitlesCurrentDescription

	if not text or text == "" then
		local currentPanel = UI and UI.CharacterTitles and UI.CharacterTitles.CurrentTitlePanel

		if currentPanel and currentPanel.CurrentTitleValue then
			text = currentPanel.CurrentTitleValue:getText()
		end
	end

	if text and text ~= "" then
		displayGeneralBox(tr("Character Title"), text, {
			{
				text = tr("Ok")
			}
		})
	end
end

function Cyclopedia.loadCharacterBadges(showAccountInformation, playerOnline, playerPremium, loyaltyTitle, badgesVector)
	UI.CharacterStats.ListBadge:destroyChildren()

	local playerOnlineStatus = "Offline"
	local playerOnlineStatusColor = "#ff0000"

	if playerOnline == 1 then
		playerOnlineStatus = "Online"
		playerOnlineStatusColor = "#60f860"
	end

	local accountStatus = "Free"
	local accountStatusColor = "#ff0000"

	if playerPremium == 1 then
		accountStatus = "Premium"
		accountStatusColor = "#44ad25"
	end

	if not loyaltyTitle or loyaltyTitle == "" then
		loyaltyTitle = "None"
	end

	Cyclopedia.setCharacterSkillValue("accountStatus", accountStatus, accountStatusColor)
	Cyclopedia.setCharacterSkillValue("accountOnline", playerOnlineStatus, playerOnlineStatusColor)
	Cyclopedia.setCharacterSkillValue("loyaltyTitle", loyaltyTitle)

	for _, badge in ipairs(badgesVector) do
		local cell = g_ui.createWidget("CharacterBadge", UI.CharacterStats.ListBadge)

		if cell then
			cell:setImageClip(getImageClip(badge[1]))
			cell:setTooltip(badge[2])
		end
	end
end

function getImageClip(elementIndex)
	local elementSize = 64
	local elementsPerRow = 21
	local y = 0
	local x = (elementIndex - 1) * elementSize
	local imageClip = string.format("%d %d %d %d", x, y, elementSize, elementSize)

	return imageClip
end

local HIRELING_JOB_NAMES = {
	[1001] = "Banker",
	[1000] = "Trader",
	[1002] = "Cook",
	[1003] = "Steward"
}
local HIRELINGS_PANEL_FIXED_HEIGHT = 84
local HIRELING_GRID_ROW_HEIGHT = 15
local HIRELING_JOBS_AREA_HEIGHT_COMPACT = 15

local function normalizeHirelingJobNames(hirelingSkills)
	local names = {}

	if type(hirelingSkills) ~= "table" then
		return names
	end

	for _, skillId in pairs(hirelingSkills) do
		local id = tonumber(skillId)
		local name = id and HIRELING_JOB_NAMES[id]

		if name then
			table.insert(names, name)
		end
	end

	table.sort(names, function(a, b)
		return a:lower() < b:lower()
	end)

	return names
end

local function normalizeHirelingOutfitNames(hirelingOutfits)
	local names = {}

	if type(hirelingOutfits) ~= "table" then
		return names
	end

	for _, entry in ipairs(hirelingOutfits) do
		local name = entry

		if type(entry) == "table" then
			name = entry[1] or entry.name
		end

		if type(name) == "string" and name ~= "" then
			table.insert(names, name)
		end
	end

	table.sort(names, function(a, b)
		return a:lower() < b:lower()
	end)

	return names
end

local function getHirelingGridAreaHeight(itemCount)
	if itemCount <= 0 then
		return HIRELING_GRID_ROW_HEIGHT
	end

	return math.ceil(itemCount / 2) * HIRELING_GRID_ROW_HEIGHT
end

local function populateHirelingGridList(list, items)
	list:destroyChildren()

	for index, text in ipairs(items) do
		local label = g_ui.createWidget("Label", list)

		label:setFont("Verdana Bold-11px-new")
		label:setColor("#c0c0c0")
		label:setTextAutoResize(true)
		label:setTextAlign(AlignLeft)

		if index % 2 == 0 then
			label:setMarginLeft(1)
		end

		label:setText(text)
	end
end

local function applyHirelingsDisplay(hirelingsPanel, hirelingSkills, hirelingOutfits)
	if not hirelingsPanel then
		return
	end

	local jobsArea = hirelingsPanel.hirelingJobsArea
	local jobsList = jobsArea and jobsArea.hirelingJobsList
	local jobsNone = jobsArea and jobsArea.hirelingJobsNone
	local outfitsArea = hirelingsPanel.hirelingOutfitsArea
	local outfitsList = outfitsArea and outfitsArea.hirelingOutfitsList
	local outfitsNone = outfitsArea and outfitsArea.hirelingOutfitsNone
	local jobNames = normalizeHirelingJobNames(hirelingSkills)
	local jobsAreaHeight = getHirelingGridAreaHeight(#jobNames)

	if jobsList and jobsNone then
		if #jobNames == 0 then
			jobsList:setVisible(false)
			jobsList:destroyChildren()
			jobsNone:setVisible(true)
			jobsNone:setText("None")
		else
			jobsNone:setVisible(false)
			jobsList:setVisible(true)
			populateHirelingGridList(jobsList, jobNames)
		end

		jobsArea:setHeight(jobsAreaHeight)
	end

	local outfitNames = normalizeHirelingOutfitNames(hirelingOutfits)
	local outfitsAreaHeight = getHirelingGridAreaHeight(#outfitNames)

	if outfitsList and outfitsNone then
		if #outfitNames == 0 then
			outfitsList:setVisible(false)
			outfitsList:destroyChildren()
			outfitsNone:setVisible(true)
			outfitsNone:setText("None")
		else
			outfitsNone:setVisible(false)
			outfitsList:setVisible(true)
			populateHirelingGridList(outfitsList, outfitNames)
		end

		outfitsArea:setHeight(outfitsAreaHeight)
	end

	hirelingsPanel:setHeight(HIRELINGS_PANEL_FIXED_HEIGHT + jobsAreaHeight + outfitsAreaHeight)
end

local HOUSE_ITEMS_LIST_MARGIN_TOP = -3
local HOUSE_ITEMS_PANEL_TITLE_HEIGHT = 19
local HOUSE_ITEMS_PANEL_BOTTOM = 17
local HOUSE_ITEMS_PANEL_HEADER = HOUSE_ITEMS_LIST_MARGIN_TOP + HOUSE_ITEMS_PANEL_TITLE_HEIGHT
local HOUSE_ITEMS_ROW_HEIGHT = 74
local HOUSE_ITEMS_GRID_SPACING = 4
local HOUSE_ITEMS_COLUMNS = 2

local function getHouseItemsGridHeight(rowCount)
	if rowCount <= 0 then
		return 0
	end

	return rowCount * HOUSE_ITEMS_ROW_HEIGHT + (rowCount - 1) * HOUSE_ITEMS_GRID_SPACING
end

local function applyHouseItemPreview(itemWidget, itemId)
	if not itemWidget or not itemId then
		return
	end

	itemWidget:setItemId(itemId)
	itemWidget:setFixedItemSize(false)
	itemWidget:setPadding(0)

	local previewSize = g_gameConfig.getSpriteSize()
	local itemThing = itemWidget:getItem()

	if itemThing and itemThing.getExactSize then
		local exactSize = itemThing:getExactSize()

		if exactSize and exactSize > 0 then
			previewSize = exactSize
		end
	else
		local thingType = g_things.getThingType(itemId, ThingCategoryItem)

		if thingType and thingType.getExactSize then
			local exactSize = thingType:getExactSize()

			if exactSize and exactSize > 0 then
				previewSize = exactSize
			end
		end
	end

	itemWidget:setSize({
		width = previewSize,
		height = previewSize
	})
end

local function applyHouseItemsDisplay(houseItemsPanel, houseItems)
	if not houseItemsPanel or not houseItemsPanel.PurchasedHouseItems then
		return
	end

	local list = houseItemsPanel.PurchasedHouseItems

	list:destroyChildren()

	if type(houseItems) == "table" then
		for _, item in ipairs(houseItems) do
			local row = g_ui.createWidget("HouseItemCard", list)

			row.lblName:setText(item[2] or "")

			local count = tonumber(item[3]) or 1

			if count > 0 then
				row.count:setText(string.format("(%dx)", count))
			else
				row.count:setText("")
			end

			local itemWidget = row.itemFrame and row.itemFrame.item or row:recursiveGetChildById("item")

			if itemWidget then
				applyHouseItemPreview(itemWidget, item[1])
			end
		end
	end

	local itemCount = type(houseItems) == "table" and #houseItems or 0
	local rows = itemCount > 0 and math.ceil(itemCount / HOUSE_ITEMS_COLUMNS) or 0
	local gridHeight = getHouseItemsGridHeight(rows)
	local panelHeight = HOUSE_ITEMS_PANEL_HEADER + gridHeight

	if rows > 1 then
		panelHeight = panelHeight + HOUSE_ITEMS_PANEL_BOTTOM
	end

	list:setHeight(gridHeight)
	houseItemsPanel:setHeight(panelHeight)
end

local STORE_SUMMARY_BOTTOM_PADDING = 5

local function updateStoreSummaryColumnHeight(storeColumn)
	local function apply()
		storeColumn:setHeight(storeColumn:getChildrenRect().height + STORE_SUMMARY_BOTTOM_PADDING)

		local scrollArea = storeColumn:getParent()

		if scrollArea and scrollArea.updateScrollBars then
			scrollArea:updateScrollBars()
		end
	end

	apply()
	addEvent(apply)
end

function Cyclopedia.onParseCyclopediaStoreSummary(xpBoostTime, dailyRewardXpBoostTime, blessings, preySlotsUnlocked, preyWildcards, hasWeeklyTaskExpansion, instantRewards, hasCharmExpansion, hirelingsObtained, hirelingSkills, hirelingOutfits, houseItems)
	if not UI or not UI.StoreSummary then
		return
	end

	local storeColumn = UI.StoreSummary.ListBase and UI.StoreSummary.ListBase.List and UI.StoreSummary.ListBase.List.storeSummaryColumn

	if not storeColumn then
		return
	end

	local xpBoosts = storeColumn.XPBoosts

	if xpBoosts then
		xpBoosts.RemainingStoreXPBoostTimeValue:setText(string.format("%02d:%02d", math.floor(xpBoostTime / 3600), math.floor(xpBoostTime % 3600 / 60)))
		xpBoosts.RemainingDailyRewardXPBoostTimeValue:setText(string.format("%02d:%02d", math.floor(dailyRewardXpBoostTime / 3600), math.floor(dailyRewardXpBoostTime % 3600 / 60)))
	end

	local panel = storeColumn.Blessings and storeColumn.Blessings.BlessingsList

	if panel then
		panel:destroyChildren()

		for i, blessing in ipairs(blessings) do
			local row = g_ui.createWidget("BlessCreate", panel)

			if i % 2 == 1 then
				row:setMarginLeft(6)
			end

			row.text1:setText(blessing[1])
			row.text2:setText(blessing[2] .. "x")
		end
	end

	if storeColumn.preyPanel then
		storeColumn.preyPanel.PermanentPreySlotsValue:setText((preySlotsUnlocked == true or (tonumber(preySlotsUnlocked) or 0) > 0) and "Yes" or "No")
		storeColumn.preyPanel.PreyWildcardsValue:setText(preyWildcards .. "x")
	end

	if storeColumn.taskBoardPanel and storeColumn.taskBoardPanel.PermanentWeeklyTaskExpansionValue then
		storeColumn.taskBoardPanel.PermanentWeeklyTaskExpansionValue:setText((hasWeeklyTaskExpansion == true or hasWeeklyTaskExpansion == 1) and "Yes" or "No")
	end

	if storeColumn.dailyReward then
		storeColumn.dailyReward.InstantRewardAccessValue:setText(instantRewards .. "x")
	end

	if storeColumn.CharmPanel then
		storeColumn.CharmPanel.CharmExpansionValue:setText(hasCharmExpansion and "Yes" or "No")
	end

	if storeColumn.hirelings then
		if storeColumn.hirelings.PurchasedHirelingsValue then
			storeColumn.hirelings.PurchasedHirelingsValue:setText(hirelingsObtained .. "x")
		end

		applyHirelingsDisplay(storeColumn.hirelings, hirelingSkills, hirelingOutfits)
	end

	if storeColumn.houseItems then
		applyHouseItemsDisplay(storeColumn.houseItems, houseItems)
	end

	updateStoreSummaryColumnHeight(storeColumn)
end

local function getWeaponSkillName(skillType)
	local skillNames = {
		[0] = "Fist Fighting",
		"Club Fighting",
		"Sword Fighting",
		"Axe Fighting",
		"Distance Fighting",
		"Shielding",
		"Fishing",
		"Magic Level",
		"Critical Hits",
		"Life Leech",
		"Mana Leech"
	}

	return skillNames[skillType] or "Fighting Skill"
end

local function getOffenceWeaponSkillDescription(weaponSkillType)
	local descriptions = {
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		"from Distance Fighting",
		"from Sword Fighting",
		"from Club Fighting",
		"from Axe Fighting",
		"from Fist Fighting"
	}

	return descriptions[weaponSkillType] or "from Fist Fighting"
end

local function getOffenceElementName(elementId)
	local element = Cyclopedia.clientCombat and Cyclopedia.clientCombat[elementId]

	if element and element.id then
		return element.id:gsub("%s+$", "")
	end

	return "Element"
end

local function truncateOffenceDescription(text)
	if #text > 21 then
		return text:sub(1, 20) .. "..."
	end

	return text
end

local function getOffenceElementTypeDescription(elementId)
	return truncateOffenceDescription("for " .. getOffenceElementName(elementId) .. " Spells and Runes")
end

local function buildCriticalChanceTypeItems(data)
	local items = {}

	if data.critChanceByElement then
		for _, entry in ipairs(data.critChanceByElement) do
			if (entry.value or 0) > 0 then
				table.insert(items, {
					percent = true,
					value = entry.value,
					description = getOffenceElementTypeDescription(entry.element)
				})
			end
		end
	end

	if (data.critChanceOffensiveRunes or 0) > 0 then
		table.insert(items, {
			percent = true,
			description = "for Offensive Runes",
			value = data.critChanceOffensiveRunes
		})
	end

	if (data.critChanceAutoAttack or 0) > 0 then
		table.insert(items, {
			percent = true,
			description = "for Auto-Attack",
			value = data.critChanceAutoAttack
		})
	end

	return items
end

local function buildCriticalDamageTypeItems(data)
	local items = {}

	if data.critDamageByElement then
		for _, entry in ipairs(data.critDamageByElement) do
			if (entry.value or 0) > 0 then
				table.insert(items, {
					percent = true,
					value = entry.value,
					description = getOffenceElementTypeDescription(entry.element)
				})
			end
		end
	end

	if (data.critDamageOffensiveRunes or 0) > 0 then
		table.insert(items, {
			percent = true,
			description = "for Offensive Runes",
			value = data.critDamageOffensiveRunes
		})
	end

	if (data.critDamageAutoAttack or 0) > 0 then
		table.insert(items, {
			percent = true,
			description = "for Auto-Attack",
			value = data.critDamageAutoAttack
		})
	end

	return items
end

local function getOffenceProficiencySkillName(skillId)
	local skillNames = {
		"Magic Level",
		nil,
		nil,
		nil,
		nil,
		"Shielding",
		"Distance Fighting",
		"Sword Fighting",
		"Club Fighting",
		"Axe Fighting",
		"Fist Fighting",
		nil,
		"Fishing"
	}

	return skillNames[skillId] or "Skill"
end

local function buildProficiencySkillBonusBlock(entries, blockName)
	if not entries or #entries == 0 then
		return nil
	end

	local items = {}
	local total = 0

	for _, entry in ipairs(entries) do
		local bonus = entry.bonus or 0

		if bonus > 0 then
			total = total + bonus

			table.insert(items, {
				value = bonus,
				description = "from " .. getOffenceProficiencySkillName(entry.skill)
			})
		end
	end

	if #items == 0 then
		return nil
	end

	return {
		principal = {
			marginTop = 5,
			valueMarginRight = -2,
			name = blockName,
			value = total
		},
		items = items
	}
end

local function buildDamageAgainstTargetsBlock(data)
	if data.damageAgainstPowerfulFoes == nil then
		return nil
	end

	local items = {}
	local powerfulFoesValue = data.damageAgainstPowerfulFoes or 0

	if powerfulFoesValue > 0 then
		table.insert(items, {
			percent = true,
			description = "against powerful foes",
			marginTop = 3,
			value = powerfulFoesValue
		})
	end

	if data.damageAgainstTargets then
		for _, entry in ipairs(data.damageAgainstTargets) do
			if (entry.value or 0) > 0 then
				table.insert(items, {
					percent = true,
					marginTop = 3,
					value = entry.value,
					description = "against " .. (entry.name or "")
				})
			end
		end
	end

	if #items == 0 then
		return nil
	end

	return {
		header = "Damage against specific targets",
		headerOptions = {
			marginTop = 5
		},
		items = items
	}
end

function Cyclopedia.onCyclopediaCharacterOffenceStats(data)
	UI.OffenceStats.rightPanel:destroyChildren()
	UI.OffenceStats.leftPanel:destroyChildren()

	local leftPanel = UI.OffenceStats.leftPanel
	local rightPanel = UI.OffenceStats.rightPanel
	local leftBlocks = {
		{
			principal = {
				marginTop = 1,
				valueMarginRight = -2,
				name = "Flat Damage and Healing",
				value = data.flatDamage
			},
			items = {
				{
					description = "from Character Level",
					value = data.flatDamageBase
				},
				{
					description = "from Wheel of Destiny",
					value = data.flatDamageWheel
				}
			}
		},
		{
			principal = {
				marginTop = 5,
				name = "Attack Value",
				value = data.weaponAttack,
				element = data.weaponElement
			},
			items = {
				{
					description = "from Flat Bonus",
					value = data.weaponFlatModifier
				},
				{
					description = "from Equipment",
					value = data.weaponDamage
				},
				{
					value = data.weaponSkillLevel,
					description = getOffenceWeaponSkillDescription(data.weaponSkillType)
				},
				{
					description = "from Offensive Tactics",
					value = data.weaponSkillModifier
				}
			}
		}
	}

	if (data.weaponElementDamage or 0) > 0 then
		table.insert(leftBlocks, {
			principal = {
				marginTop = 5,
				percent = true,
				name = "Converted Damage",
				value = data.weaponElementDamage,
				element = data.weaponElementType
			}
		})
	end

	table.insert(leftBlocks, {
		principal = {
			marginTop = 5,
			percent = true,
			name = "Onslaught",
			valueMarginRight = -2,
			value = data.onslaught
		},
		items = {
			{
				percent = true,
				description = "from Equipment",
				value = data.onslaughtBase
			},
			{
				percent = true,
				description = "from Event Bonus",
				value = data.onslaughtEvent
			}
		}
	})
	table.insert(leftBlocks, {
		principal = {
			marginTop = 5,
			percent = true,
			name = "Life Leech",
			valueMarginRight = -2,
			value = data.lifeLeech
		},
		items = {
			{
				percent = true,
				description = "from Equipment",
				value = data.lifeLeechBase
			},
			{
				percent = true,
				description = "from Imbuement",
				value = data.lifeLeechImbuement
			},
			{
				percent = true,
				description = "from Wheel of Destiny",
				value = data.lifeLeechWheel
			},
			{
				percent = true,
				description = "from Event Bonus",
				value = data.lifeLeechEventBonus
			}
		}
	})

	if (data.lifeGainOnHit or 0) > 0 then
		table.insert(leftBlocks, {
			principal = {
				marginTop = 5,
				valueMarginRight = -2,
				name = "Life Gain on Hit",
				value = data.lifeGainOnHit
			}
		})
	end

	table.insert(leftBlocks, {
		principal = {
			marginTop = 5,
			percent = true,
			name = "Mana Leech",
			valueMarginRight = -2,
			value = data.manaLeech
		},
		items = {
			{
				percent = true,
				description = "from Equipment",
				value = data.manaLeechBase
			},
			{
				percent = true,
				description = "from Imbuement",
				value = data.manaLeechImbuement
			},
			{
				percent = true,
				description = "from Wheel of Destiny",
				value = data.manaLeechWheel
			},
			{
				percent = true,
				description = "from Event Bonus",
				value = data.manaLeechEventBonus
			}
		}
	})

	if (data.manaGainOnKill or 0) > 0 then
		table.insert(leftBlocks, {
			principal = {
				marginTop = 5,
				valueMarginRight = -2,
				name = "Mana Gain on Kill",
				value = data.manaGainOnKill
			}
		})
	end

	local damageAgainstBlock = buildDamageAgainstTargetsBlock(data)

	if damageAgainstBlock then
		table.insert(leftBlocks, damageAgainstBlock)
	end

	local autoAttackExtraDamageBlock = buildProficiencySkillBonusBlock(data.autoAttackExtraDamage, "Auto-Attack Extra Damage")

	if autoAttackExtraDamageBlock then
		table.insert(leftBlocks, autoAttackExtraDamageBlock)
	end

	local extraSpellDamageBlock = buildProficiencySkillBonusBlock(data.extraSpellDamage, "Extra Spell Damage")

	if extraSpellDamageBlock then
		table.insert(leftBlocks, extraSpellDamageBlock)
	end

	local extraSpellHealingBlock = buildProficiencySkillBonusBlock(data.extraSpellHealing, "Extra Spell Healing")

	if extraSpellHealingBlock then
		table.insert(leftBlocks, extraSpellHealingBlock)
	end

	table.insert(leftBlocks, {
		principal = {
			percent = true,
			name = "Cleave",
			value = data.cleavePercent
		}
	})

	local rightBlocks = {}
	local chanceTypeItems = buildCriticalChanceTypeItems(data)
	local damageTypeItems = buildCriticalDamageTypeItems(data)
	local hasCriticalStats = (data.critChance or 0) > 0 or (data.critDamage or 0) > 0 or (data.critChanceFlat or 0) > 0 or (data.critChanceEquipament or 0) > 0 or (data.critChanceImbuement or 0) > 0 or (data.critChanceWheel or 0) > 0 or (data.critChanceConcoction or 0) > 0 or (data.critDamageFlat or 0) > 0 or (data.critDamageBase or 0) > 0 or (data.critDamageImbuement or 0) > 0 or (data.critDamageWheel or 0) > 0 or (data.critDamageConcoction or 0) > 0 or #chanceTypeItems > 0 or #damageTypeItems > 0

	if hasCriticalStats then
		table.insert(rightBlocks, {
			header = "Critical Hit:"
		})

		local chanceBlock = {
			principal = {
				marginLeft = 20,
				marginTop = 8,
				percent = true,
				name = "Chance",
				valueMarginRight = 2,
				value = data.critChance
			},
			items = {
				{
					percent = true,
					description = "from Base",
					value = data.critChanceFlat
				},
				{
					percent = true,
					description = "from Equipment",
					value = data.critChanceEquipament
				},
				{
					percent = true,
					description = "from Imbuement",
					value = data.critChanceImbuement
				},
				{
					percent = true,
					description = "from Wheel of Destiny",
					value = data.critChanceWheel
				},
				{
					percent = true,
					description = "from Concoction",
					value = data.critChanceConcoction
				}
			}
		}

		if #chanceTypeItems > 0 then
			chanceBlock.typeSections = {
				{
					itemMarginTop = 3,
					itemMarginLeft = 58,
					marginTop = 5,
					subheader = "Critical Chance by Type",
					items = chanceTypeItems
				}
			}
		end

		table.insert(rightBlocks, chanceBlock)

		local damageBlock = {
			principal = {
				marginLeft = 20,
				marginTop = 5,
				percent = true,
				name = "Extra Damage",
				valueMarginRight = 2,
				value = data.critDamage
			},
			items = {
				{
					percent = true,
					description = "from Base",
					value = data.critDamageFlat
				},
				{
					percent = true,
					description = "from Equipment",
					value = data.critDamageBase
				},
				{
					percent = true,
					description = "from Imbuement",
					value = data.critDamageImbuement
				},
				{
					percent = true,
					description = "from Wheel of Destiny",
					value = data.critDamageWheel
				},
				{
					percent = true,
					description = "from Concoction",
					value = data.critDamageConcoction
				}
			}
		}

		if #damageTypeItems > 0 then
			damageBlock.typeSections = {
				{
					marginTop = 5,
					itemMarginTop = 3,
					itemMarginLeft = 56,
					subheader = "Critical Damage by Type",
					items = damageTypeItems
				}
			}
		end

		table.insert(rightBlocks, damageBlock)
	end

	if data.perfectShotDamage then
		local perfectShotBlock = {
			header = "Perfect Shot Damage Bonus",
			headerOptions = {
				marginTop = 5
			}
		}
		local perfectShotItems = {}

		for i = 1, #data.perfectShotDamage do
			local damage = data.perfectShotDamage[i]

			if damage and damage > 0 then
				table.insert(perfectShotItems, {
					marginLeft = 36,
					marginTop = 3,
					value = damage,
					description = "from Range " .. i,
					valueText = "+" .. damage
				})
			end
		end

		if #perfectShotItems > 0 then
			perfectShotBlock.items = perfectShotItems

			table.insert(rightBlocks, perfectShotBlock)
		end
	end

	for _, block in ipairs(leftBlocks) do
		Cyclopedia.renderOffenceStatBlock(leftPanel, block)
	end

	for _, block in ipairs(rightBlocks) do
		Cyclopedia.renderOffenceStatBlock(rightPanel, block)
	end
end

function Cyclopedia.onCyclopediaCharacterDefenceStats(data)
	UI.DeffenceStats.rightPanel:destroyChildren()
	UI.DeffenceStats.leftPanel:destroyChildren()

	local leftPanel = UI.DeffenceStats.leftPanel
	local rightPanel = UI.DeffenceStats.rightPanel

	local function getDefenceSkillDescription(skillType)
		local descriptions = {
			[0] = "from Fist Fighting",
			"from Club Fighting",
			"from Sword Fighting",
			"from Axe Fighting",
			"from Distance Fighting",
			"from Shielding",
			"from Shielding"
		}

		return descriptions[skillType] or "from Shielding"
	end

	local function getBreakdownItems(candidates)
		local items = {}

		for _, item in ipairs(candidates) do
			if (tonumber(item.value) or 0) > 0 then
				table.insert(items, item)
			end
		end

		if #items < 2 then
			return nil
		end

		return items
	end

	local leftBlocks = {
		{
			principal = {
				showZero = true,
				marginTop = 1,
				name = "Defence Value",
				valueMarginRight = -2,
				value = data.defense
			},
			items = getBreakdownItems({
				{
					description = "from Equipment",
					value = data.defenseEquipment
				},
				{
					value = data.shieldingSkill,
					description = getDefenceSkillDescription(data.defenseSkillType)
				},
				{
					description = "from Wheel of Destiny",
					value = data.defenseWheel
				}
			})
		},
		{
			principal = {
				showZero = true,
				marginTop = 5,
				name = "Armor Value",
				valueMarginRight = -2,
				value = data.armor
			}
		},
		{
			principal = {
				showZero = true,
				marginTop = 5,
				percent = true,
				name = "Mitigation",
				valueMarginRight = -2,
				value = data.mitigation
			},
			items = getBreakdownItems({
				{
					percent = true,
					description = "from Base",
					value = data.mitigationBase
				},
				{
					percent = true,
					description = "from Defence",
					value = data.mitigationEquipment
				},
				{
					percent = true,
					description = "from Shielding",
					value = data.mitigationShield
				},
				{
					percent = true,
					description = "from Wheel of Destiny",
					value = data.mitigationWheel
				},
				{
					percent = true,
					description = "from Combat Tactics",
					value = data.mitigationCombatTactics
				}
			})
		}
	}

	if (data.mantra or 0) > 0 then
		table.insert(leftBlocks, 3, {
			principal = {
				marginTop = 5,
				valueMarginRight = -2,
				name = "Mantra Value",
				value = data.mantra
			}
		})
	end

	if (data.magicShieldCapacity or 0) > 0 or (data.magicShieldCapacityFlat or 0) > 0 or (data.magicShieldCapacityPercent or 0) > 0 then
		table.insert(leftBlocks, {
			principal = {
				showZero = true,
				marginTop = 5,
				name = "Magic Shield Capacity",
				valueMarginRight = -2,
				value = data.magicShieldCapacity
			},
			items = getBreakdownItems({
				{
					description = "from Flat Bonus",
					value = data.magicShieldCapacityFlat
				},
				{
					percent = true,
					description = "from Percent Bonus",
					value = data.magicShieldCapacityPercent
				}
			})
		})
	end

	if (data.dodgeTotal or 0) > 0 or (data.dodgeBase or 0) > 0 or (data.dodgeBonus or 0) > 0 or (data.dodgeWheel or 0) > 0 then
		table.insert(leftBlocks, {
			principal = {
				marginTop = 5,
				percent = true,
				name = "Dodge",
				valueMarginRight = -2,
				value = data.dodgeTotal
			},
			items = getBreakdownItems({
				{
					percent = true,
					description = "from Equipment",
					value = data.dodgeBase
				},
				{
					percent = true,
					description = "from Amplification",
					value = data.dodgeBonus
				},
				{
					percent = true,
					description = "from Wheel of Destiny",
					value = data.dodgeWheel
				}
			})
		})
	end

	if (data.reflectPhysical or 0) > 0 then
		table.insert(leftBlocks, {
			principal = {
				marginTop = 5,
				valueMarginRight = -2,
				name = "Damage Reflection Amount",
				value = data.reflectPhysical
			}
		})
	end

	local resistanceMap = {}

	if data.resistances then
		for _, resistance in ipairs(data.resistances) do
			resistanceMap[resistance.element] = resistance.value
		end
	end

	local alwaysResistanceOrder = {
		0,
		1,
		2,
		3,
		4,
		5,
		6
	}
	local optionalResistanceOrder = {
		{
			name = "Life Drain",
			id = 9
		},
		{
			name = "Mana Drain",
			id = 10
		},
		{
			name = "Drowning",
			id = 8
		}
	}
	local rightBlocks = {
		{
			header = "Damage Reduction:",
			headerOptions = {
				marginTop = 0
			}
		}
	}

	local function appendResistanceRow(elementId, displayName, index, forceShow)
		local elementInfo = Cyclopedia.clientCombat and Cyclopedia.clientCombat[elementId]

		if not elementInfo then
			return false
		end

		local value = resistanceMap[elementId] or 0

		if not forceShow and value <= 0 then
			return false
		end

		local color = "#C0C0C0"

		if value > 0 then
			color = "#44AD25"
		elseif value < 0 then
			color = "#ff9854"
		end

		local percent = value * 100
		local absPercent = math.abs(percent)
		local rounded = math.floor(absPercent + 1e-06)
		local formatted

		if math.abs(absPercent - rounded) < 1e-06 then
			formatted = string.format("%d%%", rounded)
		else
			formatted = string.format("%.2f", absPercent):gsub("0+$", ""):gsub("%.$", "") .. "%"
		end

		local valueText = (percent < 0 and "-" or "+") .. formatted

		table.insert(rightBlocks, {
			principal = {
				showZero = true,
				iconMarginRight = -4,
				height = 18,
				percent = true,
				marginLeft = 20,
				valueMarginRight = 2,
				name = displayName or elementInfo.id,
				value = value,
				element = elementId,
				color = color,
				marginTop = index == 1 and 3 or -2,
				valueText = valueText
			}
		})

		return true
	end

	local rowIndex = 0

	for _, elementId in ipairs(alwaysResistanceOrder) do
		rowIndex = rowIndex + 1

		appendResistanceRow(elementId, nil, rowIndex, true)
	end

	for _, entry in ipairs(optionalResistanceOrder) do
		if appendResistanceRow(entry.id, entry.name, rowIndex + 1, false) then
			rowIndex = rowIndex + 1
		end
	end

	for _, block in ipairs(leftBlocks) do
		Cyclopedia.renderOffenceStatBlock(leftPanel, block)
	end

	for _, block in ipairs(rightBlocks) do
		Cyclopedia.renderOffenceStatBlock(rightPanel, block)
	end
end

function Cyclopedia.onCyclopediaCharacterMiscStats(data)
	UI.MiscStats.rightPanel:destroyChildren()
	UI.MiscStats.leftPanel:destroyChildren()

	local leftPanel = UI.MiscStats.leftPanel
	local rightPanel = UI.MiscStats.rightPanel

	local function getBreakdownItems(candidates)
		local items = {}

		for _, item in ipairs(candidates) do
			if (tonumber(item.value) or 0) > 0 then
				table.insert(items, item)
			end
		end

		if #items < 2 then
			return nil
		end

		return items
	end

	local leftBlocks = {}

	if (data.momentumTotal or 0) > 0 or (data.momentumBase or 0) > 0 or (data.momentumBonus or 0) > 0 or (data.momentumWheel or 0) > 0 then
		table.insert(leftBlocks, {
			principal = {
				marginTop = 1,
				percent = true,
				name = "Momentum",
				valueMarginRight = 10,
				value = data.momentumTotal
			},
			items = getBreakdownItems({
				{
					percent = true,
					description = "from Equipment",
					value = data.momentumBase
				},
				{
					percent = true,
					description = "from Amplification",
					value = data.momentumBonus
				},
				{
					percent = true,
					description = "from Wheel of Destiny",
					value = data.momentumWheel
				}
			})
		})
	end

	if (data.dodgeTotal or 0) > 0 or (data.dodgeBase or 0) > 0 or (data.dodgeBonus or 0) > 0 or (data.dodgeWheel or 0) > 0 then
		table.insert(leftBlocks, {
			principal = {
				percent = true,
				name = "Transcendence",
				valueMarginRight = 10,
				value = data.dodgeTotal,
				marginTop = #leftBlocks > 0 and 5 or 1
			},
			items = getBreakdownItems({
				{
					percent = true,
					description = "from Equipment",
					value = data.dodgeBase
				},
				{
					percent = true,
					description = "from Amplification",
					value = data.dodgeBonus
				},
				{
					percent = true,
					description = "from Event Bonus",
					value = data.dodgeWheel
				}
			})
		})
	end

	if (data.damageReflectionTotal or 0) > 0 or (data.damageReflectionBase or 0) > 0 or (data.damageReflectionBonus or 0) > 0 then
		table.insert(leftBlocks, {
			principal = {
				percent = true,
				name = "Amplification",
				valueMarginRight = 10,
				value = data.damageReflectionTotal,
				marginTop = #leftBlocks > 0 and 5 or 1
			},
			items = getBreakdownItems({
				{
					percent = true,
					description = "from Equipment",
					value = data.damageReflectionBase
				},
				{
					percent = true,
					description = "from Bonus",
					value = data.damageReflectionBonus
				}
			})
		})
	end

	table.insert(leftBlocks, {
		principal = {
			blessButtonGap = 6,
			blessButtonMarginTop = 1,
			name = "Blessings",
			blessButtonMarginRight = 4,
			blessButton = true,
			value = 1,
			marginTop = #leftBlocks > 0 and 5 or 1,
			valueText = (data.haveBlesses or 0) .. "/" .. (data.totalBlesses or 0)
		}
	})

	local augmentTypes = {
		{
			sign = "+",
			percent = false,
			name = "Mana Cost"
		},
		{
			sign = "+",
			percent = true,
			name = "Base Damage"
		},
		{
			sign = "+",
			percent = true,
			name = "Healing"
		},
		{
			suffix = "s",
			sign = "+",
			percent = false,
			name = "Duration"
		},
		{
			integer = true,
			sign = "+",
			percent = false,
			name = "Additional Targets"
		},
		{
			suffix = "s",
			percent = false,
			name = "Cooldown",
			sign = "-",
			integer = true
		},
		[14] = {
			sign = "+",
			percent = true,
			name = "Life Leech"
		},
		[15] = {
			sign = "+",
			percent = true,
			name = "Mana Leech"
		},
		[16] = {
			sign = "+",
			percent = true,
			name = "Critical Extra Damage"
		},
		[17] = {
			sign = "+",
			percent = true,
			name = "Critical Hit Chance"
		}
	}

	local function getAugmentSpellName(spellId)
		if SpellAugmentIcons and SpellAugmentIcons[spellId] and SpellAugmentIcons[spellId].name then
			return SpellAugmentIcons[spellId].name
		end

		if Spells and Spells.getSpellDataById then
			local spell = Spells.getSpellDataById(spellId)

			if spell and spell.name then
				return spell.name
			end
		end

		return "Unknown Spell (" .. tostring(spellId) .. ")"
	end

	local function formatAugmentValue(augment, typeInfo)
		local rawValue = tonumber(augment.value) or 0

		if typeInfo.percent then
			local percentValue = math.floor(math.abs(rawValue) * 10000) / 100

			return typeInfo.sign .. percentValue .. "%"
		elseif typeInfo.integer then
			return typeInfo.sign .. tostring(math.floor(math.abs(rawValue) + 0.5)) .. (typeInfo.suffix or "")
		end

		return typeInfo.sign .. string.format("%.1f", math.abs(rawValue)) .. (typeInfo.suffix or "")
	end

	local function appendAugmentBlocks(augments, header)
		if not augments or #augments == 0 then
			return
		end

		local typeSections = {}
		local sectionsBySpellId = {}

		for _, augment in ipairs(augments) do
			local spellId = augment.spellId
			local typeInfo = augmentTypes[augment.type] or {
				sign = "+",
				percent = true,
				name = "Augment Type " .. tostring(augment.type)
			}
			local section = sectionsBySpellId[spellId]

			if not section then
				section = {
					subheader = getAugmentSpellName(spellId),
					marginTop = #typeSections == 0 and 3 or -3,
					items = {}
				}
				sectionsBySpellId[spellId] = section

				table.insert(typeSections, section)
			end

			table.insert(section.items, {
				showZero = true,
				marginLeft = 48,
				value = 1,
				valueText = formatAugmentValue(augment, typeInfo),
				description = typeInfo.name,
				marginTop = #section.items == 0 and 3 or 0
			})
		end

		table.insert(leftBlocks, {
			header = header,
			headerOptions = {
				marginTop = 5
			},
			typeSections = typeSections
		})
	end

	appendAugmentBlocks(data.weaponProficiencyAugments, "Weapon Proficiency Spell Augments")
	appendAugmentBlocks(data.wheelAugments, "Wheel of Destiny Spell Augments")
	appendAugmentBlocks(data.equippedAugments, "Equipment Spell Augments")

	local function getTimedItemName(itemId)
		local itemName = "Item " .. tostring(itemId or 0)
		local thingType = g_things.getThingType(itemId, ThingCategoryItem)

		if thingType then
			local marketData = thingType:getMarketData()

			if marketData and marketData.name and marketData.name ~= "" then
				return marketData.name
			end
		end

		return itemName
	end

	local function formatTooltipDuration(seconds)
		seconds = math.max(0, math.floor(tonumber(seconds) or 0))

		local minutes = math.floor(seconds / 60)
		local secs = seconds % 60

		return string.format("%02dmin %02ds", minutes, secs)
	end

	local function appendTimedItemGrid(panel, items, header, options)
		options = options or {}

		if not items or #items == 0 then
			return
		end

		Cyclopedia.appendOffenceStatHeaderRow(panel, header, {
			marginTop = options.marginTop or 0
		})

		local grid = g_ui.createWidget("MiscTimedItemGrid", panel)

		grid:setMarginTop(3)
		grid:setMarginLeft(2)

		if options.marginBottom then
			grid:setMarginBottom(options.marginBottom)
		end

		local parentWidth = panel:getWidth() - panel:getPaddingLeft() - panel:getPaddingRight()

		if parentWidth <= 0 then
			parentWidth = 220
		end

		grid:setWidth(parentWidth)

		for _, entry in ipairs(items) do
			local slot = g_ui.createWidget("CharacterGridItem", grid)
			local itemId = entry.id or 0
			local duration = entry.duration or 0

			slot.item:setItemId(itemId)
			slot.item:setVirtual(true)

			if slot.tier then
				slot.tier:setVisible(false)
			end

			if slot.amount then
				slot.amount:setVisible(true)
				slot.amount:setText(formatItemDuration(duration))
			end

			local itemName = getTimedItemName(itemId)

			slot.item:setTooltip(string.format("%s: %s", itemName, formatTooltipDuration(duration)))
		end

		local cellSize = 34
		local cellSpacing = 5
		local rows = math.max(1, math.ceil(#items / 6))

		grid:setHeight(rows * cellSize + math.max(0, rows - 1) * cellSpacing)
	end

	for _, block in ipairs(leftBlocks) do
		Cyclopedia.renderOffenceStatBlock(leftPanel, block)
	end

	local hasConsumableCooldowns = data.activeConsumableCooldowns and #data.activeConsumableCooldowns > 0

	appendTimedItemGrid(rightPanel, data.concoctions, "Active Concoctions:", {
		marginTop = 0,
		marginBottom = hasConsumableCooldowns and 13 or 0
	})
	appendTimedItemGrid(rightPanel, data.activeConsumableCooldowns, "Consumable Cooldowns:", {
		marginTop = 0
	})
end
