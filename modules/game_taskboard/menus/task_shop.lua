-- chunkname: @/game_taskboard/menus/task_shop.lua

TaskBoard.TaskShop = {}

local TaskShop = TaskBoard.TaskShop
local TYPE_ITEM = 0
local TYPE_MOUNT = 1
local TYPE_OUTFIT = 2
local TYPE_ITEMS = 3
local TYPE_WHEEL_POINTS = 4
local STATUS_BUYABLE = 0
local STATUS_OWNED = 1
local STATUS_NO_POINTS = 2
local STATUS_NEEDS_BASE = 3
local STATUS_PURCHASED = 4
local CATEGORY_ICON = {
	[TYPE_ITEM] = "/modules/game_taskboard/images/backdrop_huntingtaskpoint_shop_decoration",
	[TYPE_MOUNT] = "/modules/game_taskboard/images/backdrop_huntingtaskpoint_shop_Mount",
	[TYPE_OUTFIT] = "/modules/game_taskboard/images/backdrop_huntingtaskpoint_shop_outfit",
	[TYPE_ITEMS] = "/modules/game_taskboard/images/backdrop_huntingtaskpoint_shop_decoration",
	[TYPE_WHEEL_POINTS] = "/modules/game_taskboard/images/backdrop_huntingtaskpoint_shop_boost"
}
local STATUS_TOOLTIP = {
	[STATUS_NO_POINTS] = tr("Not enough points."),
	[STATUS_NEEDS_BASE] = tr("Requires the base outfit first."),
	[STATUS_OWNED] = tr("Already owned."),
	[STATUS_PURCHASED] = tr("Already purchased.")
}

function TaskShop:getListPanel()
	if not TaskBoard.taskShopPanel then
		return nil
	end

	return TaskBoard.taskShopPanel:getChildById("shopItemList")
end

function TaskShop:clearShop()
	local list = self:getListPanel()

	if list then
		list:destroyChildren()
	end
end

-- ADAPTER for our engine: onTaskHuntingShopData passes the offers under different field names
-- and - more importantly - ALL values as text. The module compares them numerically
-- (e.g. `(data.clientId or 0) > 0`), which throws a Lua error on a string, hence tonumber everywhere.
local SHOP_TYPE_ITEM, SHOP_TYPE_MOUNT, SHOP_TYPE_ITEMS = 0, 1, 3

function onEngineTaskHuntingShopData(shopData)
	local offers = {}

	for _, o in ipairs(shopData or {}) do
		local offerType = tonumber(o.offerType) or 0
		local itemId = tonumber(o.itemId) or 0
		local lookType = tonumber(o.lookType) or 0

		local clientId = 0
		if offerType == SHOP_TYPE_ITEM or offerType == SHOP_TYPE_ITEMS then
			clientId = itemId
		elseif offerType == SHOP_TYPE_MOUNT then
			clientId = lookType
		end

		offers[#offers + 1] = {
			offerId = tonumber(o.id) or 0,
			offerType = offerType,
			name = o.title or "",
			description = o.description or "",
			price = tonumber(o.price) or 0,
			bought = tonumber(o.bought) or 0,
			status = tonumber(o.status) or ((tonumber(o.bought) == 1) and STATUS_PURCHASED or STATUS_BUYABLE),
			clientId = clientId,
			lookType = lookType,
			addons = tonumber(o.lookAddons) or 0,
			itemId = itemId,
			maxPurchases = tonumber(o.maxPurchases) or 0,
			points = tonumber(o.currentPurchases) or 0,
			nextCost = tonumber(o.nextCost) or 0
		}
	end

	onShopTasks(offers)
end

function onShopTasks(offers)
	TaskShop:clearShop()

	if not offers then
		return
	end

	for i, offer in ipairs(offers) do
		TaskShop:createCard(offer)
	end
end

function TaskShop:init()
	connect(g_game, {
		onShopTasks = onShopTasks,
		onTaskHuntingShopData = onEngineTaskHuntingShopData
	})
end

function TaskShop:terminate()
	disconnect(g_game, {
		onShopTasks = onShopTasks,
		onTaskHuntingShopData = onEngineTaskHuntingShopData
	})
	self:clearShop()
end

function TaskShop:createCard(data)
	local list = self:getListPanel()

	if not list then
		return
	end

	local card = g_ui.createWidget("ShopItemCard", list)

	if not card then
		return
	end

	if data.offerType == TYPE_WHEEL_POINTS then
		card:setText(tr("Bonus Promotion Point"))
	else
		card:setText(data.name or "")
	end

	local descLabel = card:getChildById("descLabel")

	if descLabel then
		if data.offerType == TYPE_WHEEL_POINTS then
			local purchased = data.points or 0

			descLabel:setText(tr("Earn up to 50 Promotion Points to spend in your Wheel of Destiny.\nAlready purchased %d / 50.", purchased))

			local iconBox = card:getChildById("iconBox")

			if iconBox then
				iconBox:setImageSource("/modules/game_taskboard/images/icon_tasksystem_promotionpoint")
			end
		else
			descLabel:setText(data.description or "")
		end
	end

	local currencyWidget = card:getChildById("currencyTypeWidget")

	if currencyWidget then
		local icon = CATEGORY_ICON[data.offerType]

		if icon then
			currencyWidget:setImageSource(icon)
		end
	end

	self:applyPrice(card, data)
	self:applyIcon(card, data)
	self:applyStatus(card, data)
end

function TaskShop:applyPrice(card, data)
	local pricePanel = card:getChildById("pricePanel")

	if not pricePanel then
		return
	end

	local coinIcon = pricePanel:getChildById("coinIcon")

	if coinIcon then
		coinIcon:setImageSource("/modules/game_taskboard/images/preyhuntingtask-tokens")
	end

	local priceLabel = pricePanel:getChildById("priceLabel")

	if priceLabel then
		priceLabel:setText(TaskBoard:formatNumberWithCommas(data.price or 0))
	end
end

function TaskShop:applyIcon(card, data)
	local iconBox = card:getChildById("iconBox")

	if not iconBox then
		return
	end

	local itemIcon = iconBox:getChildById("itemIcon")
	local itemIcon2 = iconBox:getChildById("itemIcon2")
	local outfitIcon = iconBox:getChildById("outfitIcon")

	if itemIcon then
		itemIcon:setVisible(false)
	end

	if itemIcon2 then
		itemIcon2:setVisible(false)
	end

	if outfitIcon then
		outfitIcon:setVisible(false)
	end

	local offerType = data.offerType

	if offerType == TYPE_OUTFIT then
		if outfitIcon and (data.lookType or 0) > 0 then
			local outfit = {
				mount = 0,
				feet = 0,
				legs = 0,
				body = 0,
				head = 0,
				type = data.lookType or 0,
				addons = data.addons or 0
			}

			outfitIcon:setOutfit(outfit)
			outfitIcon:setVisible(true)
		end
	elseif offerType == TYPE_MOUNT then
		if outfitIcon and (data.clientId or 0) > 0 then
			local outfit = {
				mount = 0,
				feet = 0,
				legs = 0,
				body = 0,
				head = 0,
				addons = 0,
				type = data.clientId or 0
			}

			outfitIcon:setOutfit(outfit)
			outfitIcon:setVisible(true)
		end
	elseif offerType == TYPE_ITEM then
		if itemIcon and (data.clientId or 0) > 0 then
			itemIcon:setItemId(data.clientId)
			itemIcon:setVisible(true)
		end
	elseif offerType == TYPE_ITEMS then
		if itemIcon and (data.clientId or 0) > 0 then
			itemIcon:setItemId(data.clientId)
			itemIcon:setVisible(true)
			itemIcon:setSize(tosize("44 28"))
			itemIcon:setMarginTop(-22)
			itemIcon:setMarginLeft(1)
		end

		if itemIcon2 and (data.clientId2 or 0) > 0 then
			itemIcon2:setItemId(data.clientId2)
			itemIcon2:setVisible(true)
		end
	elseif offerType == TYPE_WHEEL_POINTS then
		-- block empty
	end
end

function TaskShop:applyStatus(card, data)
	local buyButton = card:getChildById("buyButton")
	local boughtWidget = card:getChildById("boughtWidget")

	if not buyButton or not boughtWidget then
		return
	end

	local status = data.status or STATUS_BUYABLE

	if status == STATUS_OWNED or status == STATUS_PURCHASED then
		buyButton:setVisible(false)
		boughtWidget:setVisible(true)

		return
	end

	boughtWidget:setVisible(false)
	buyButton:setVisible(true)

	if status == STATUS_BUYABLE then
		buyButton:setEnabled(true)
		buyButton:setTooltip("")

		function buyButton.onClick()
			TaskShop:onBuyItem(data)
		end
	else
		buyButton:setEnabled(false)

		local tip = STATUS_TOOLTIP[status]

		if tip then
			buyButton:setTooltip(tip)
		end
	end
end

function TaskShop:onBuyItem(data)
	if not data then
		return
	end

	g_game.sendOnBuyHuntingTaskShop(data.offerId)
end
