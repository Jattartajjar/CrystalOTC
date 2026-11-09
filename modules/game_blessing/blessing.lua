-- chunkname: @/game_blessing/blessing.lua

blessingWindow = nil
historyWindow = nil

local isModalOpenRequested = false
local openedFromCyclopedia = false
local blessSheet = "/images/game/blessings/blessings-icons"
local ICON_SIZE = 64
local blessingIcons = {
	["1"] = 0,
	["4"] = 3,
	["2"] = 8,
	["256"] = 7,
	["128"] = 6,
	["64"] = 1,
	["32"] = 4,
	["16"] = 2,
	["8"] = 5
}

local function isAlive(widget)
	return widget and not widget:isDestroyed()
end

local function destroyWindows()
	if isAlive(blessingWindow) then
		if g_modalManager then
			g_modalManager.hide(blessingWindow)
		end

		pcall(function()
			blessingWindow:ungrabKeyboard()
		end)
		blessingWindow:destroy()
	end

	blessingWindow = nil

	if isAlive(historyWindow) then
		if g_modalManager then
			g_modalManager.hide(historyWindow)
		end

		pcall(function()
			historyWindow:ungrabKeyboard()
		end)
		historyWindow:destroy()
	end

	historyWindow = nil
end

local function ensureWindows()
	if not isAlive(blessingWindow) then
		blessingWindow = g_ui.displayUI("blessing")

		blessingWindow:hide()
	end

	if not isAlive(historyWindow) then
		historyWindow = g_ui.displayUI("history")

		historyWindow:hide()
	end
end

local function getBlessingsPanel()
	ensureWindows()

	local mini = blessingWindow:recursiveGetChildById("miniWindowBlessing")

	return mini and mini:getChildById("blessings")
end

local function getPromotionLabel()
	ensureWindows()

	local mini = blessingWindow:recursiveGetChildById("miniWindowPromotion")

	return mini and mini:getChildById("label")
end

local function getInfoLabel(id)
	ensureWindows()

	local mini = blessingWindow:recursiveGetChildById("miniWindowInfo")

	return mini and mini:getChildById(id)
end

function init()
	ensureWindows()
	connect(g_game, {
		onGameStart = online,
		onGameEnd = offline,
		onUpdateBlessDialog = onBlessingDialog
	})
end

local function restoreCyclopediaIfNeeded()
	if not openedFromCyclopedia then
		return
	end

	openedFromCyclopedia = false

	if modules.game_cyclopedia and modules.game_cyclopedia.restoreFromOverlay then
		modules.game_cyclopedia.restoreFromOverlay()
	end
end

function openFromCyclopedia()
	ensureWindows()

	if blessingWindow:isVisible() then
		return
	end

	openedFromCyclopedia = true

	if modules.game_cyclopedia and modules.game_cyclopedia.hideForOverlay then
		modules.game_cyclopedia.hideForOverlay()
	end

	showBlessingModal()
end

function toggle()
	ensureWindows()

	if blessingWindow:isVisible() then
		closeBlessing()
	else
		openedFromCyclopedia = false

		showBlessingModal()
	end
end

local function syncModalPosition(from, to)
	to:breakAnchors()
	to:setPosition({
		x = from:getX(),
		y = from:getY()
	})
end

function history()
	ensureWindows()

	if blessingWindow:isVisible() then
		g_modalManager.hide(blessingWindow)
		blessingWindow:hide()
		syncModalPosition(blessingWindow, historyWindow)
		historyWindow:show()
		g_modalManager.show(historyWindow)
	else
		g_modalManager.hide(historyWindow)
		historyWindow:hide()
		syncModalPosition(historyWindow, blessingWindow)
		blessingWindow:show()
		g_modalManager.show(blessingWindow)
	end
end

function terminate()
	disconnect(g_game, {
		onGameStart = online,
		onGameEnd = offline,
		onUpdateBlessDialog = onBlessingDialog
	})
	destroyWindows()
end

function showBlessingModal()
	isModalOpenRequested = true
	g_game.requestBless()
end

function requestBlessingsSilent()
	if g_game.isOnline() then
		g_game.requestBless()
	end
end

function closeBlessing(restoreCyclopedia)
	if not isAlive(blessingWindow) then
		return
	end

	g_modalManager.hide(blessingWindow)
	blessingWindow:hide()

	if isAlive(historyWindow) and historyWindow:isVisible() then
		g_modalManager.hide(historyWindow)
		historyWindow:hide()
	end

	if restoreCyclopedia == false then
		openedFromCyclopedia = false

		return
	end

	restoreCyclopediaIfNeeded()
end

function openStoreFromBlessings()
	closeBlessing(false)

	if modules.game_store and modules.game_store.openStoreCategory then
		modules.game_store.openStoreCategory("Blessings")
	end
end

function closeBlessHistory()
	if not isAlive(historyWindow) then
		return
	end

	g_modalManager.hide(historyWindow)
	historyWindow:hide()
	restoreCyclopediaIfNeeded()
end

function online()
	destroyWindows()
	ensureWindows()
	requestBlessingsSilent()
end

function offline()
	isModalOpenRequested = false
	openedFromCyclopedia = false

	if isAlive(blessingWindow) then
		g_modalManager.hide(blessingWindow)
		blessingWindow:hide()
	end

	if isAlive(historyWindow) then
		g_modalManager.hide(historyWindow)
		historyWindow:hide()
	end

	destroyWindows()
end

local function updateBlessLayout(total)
	local panel = getBlessingsPanel()

	if not panel then
		return
	end

	local cols = total == 8 and 8 or 7
	local width = cols * 66 + (cols - 1) * 5

	panel:setWidth(width)
end

function onBlessingDialog(data)
	local bitmask = 0
	if data and data.blesses then
		for _, bless in ipairs(data.blesses) do
			if bless.playerBlessCount and bless.playerBlessCount > 0 then
				bitmask = bit.bor(bitmask, bless.blessBitwise or 0)
			end
		end
	end

	if modules.game_inventory and modules.game_inventory.updateBlessingsData then
		modules.game_inventory.updateBlessingsData(bitmask)
	end

	if not isModalOpenRequested then
		return
	end

	isModalOpenRequested = false

	ensureWindows()

	local blessingsPanel = getBlessingsPanel()

	if not blessingsPanel then
		return
	end

	blessingWindow:show(true)
	blessingWindow:focus()
	g_modalManager.show(blessingWindow)
	blessingsPanel:destroyChildren()

	for i, bless in ipairs(data.blesses) do
		local widget = g_ui.createWidget("BlessingWidget", blessingsPanel)
		local index = blessingIcons[tostring(bless.blessBitwise)]

		if index then
			widget.containerImage.image:setImageSource(blessSheet)
			widget.containerImage.image:setImageClip(string.format("%d 0 %d %d", index * ICON_SIZE, ICON_SIZE, ICON_SIZE))
		end

		widget.containerCount:setText(string.format("%d (%d)", bless.playerBlessCount, bless.store))

		if bless.playerBlessCount < 1 then
			widget.containerCount:setVisible(false)
			widget.storeButton:setVisible(true)
		end
	end

	local promotionLabel = getPromotionLabel()

	if promotionLabel then
		promotionLabel:parseColoredText("\nYour character is promoted and your account has Premium\nstatus. As a result, your XP loss is reduced by [color=#f75f5f]" .. data.promotion .. "%[/color]", "#c0c0c0")
	end

	local bullet = string.char(149):sub(1, 1)
	local nbsp = string.char(160)
	local pvpDeath = getInfoLabel("pvpDeath")

	if pvpDeath then
		pvpDeath:parseColoredText(bullet .. " Depending on the fair fight rules, you will lose between [color=#f75f5f]" .. data.pvpMinXpLoss .. "[/color] and [color=#f75f5f]" .. data.pvpMaxXpLoss .. "%[/color] less XP and skill\n" .. nbsp .. nbsp .. nbsp .. "points upon your next PvP death.", "#c0c0c0")
	end

	local pveDeath = getInfoLabel("pveDeath")

	if pveDeath then
		pveDeath:parseColoredText(bullet .. " You will lose [color=#f75f5f]" .. data.pveExpLoss .. "%[/color] less XP and skill points upon your next PvE death.", "#c0c0c0")
	end

	local pvpDrop = getInfoLabel("pvpDrop")

	if pvpDrop then
		pvpDrop:parseColoredText(bullet .. " There is a [color=#f75f5f]" .. data.equipPvpLoss .. "%[/color] chance that you will lose your equipped container on your next\n" .. nbsp .. nbsp .. nbsp .. "death.", "#c0c0c0")
	end

	local pveDrop = getInfoLabel("pveDrop")

	if pveDrop then
		pveDrop:parseColoredText(bullet .. " There is a [color=#f75f5f]" .. data.equipPveLoss .. "%[/color] chance that you will lose items upon your next death.", "#c0c0c0")
	end

	updateBlessLayout(data.totalBless)
end
