-- chunkname: @/game_playerdeath/playerdeath.lua

deathController = Controller:new()

local openStoreBlessingsOnLogin = false

function deathController:onInit()
	deathController:registerEvents(g_game, {
		onDeath = display,
		onGameStart = onGameStart
	})
end

function deathController:onTerminate()
	openStoreBlessingsOnLogin = false
	deathController.ui = destroyWindows()
end

function deathController:onGameEnd()
	deathController.ui = destroyWindows()
end

function onGameStart()
	if not openStoreBlessingsOnLogin then
		return
	end

	openStoreBlessingsOnLogin = false

	scheduleEvent(function()
		if not g_game.isOnline() or not modules.game_store then
			return
		end

		if modules.game_store.openStoreCategory then
			modules.game_store.openStoreCategory("Blessings", "", 0, 1)
		elseif modules.game_store.gameOpenStore then
			modules.game_store.gameOpenStore()
		end
	end, 250)
end

function destroyWindows()
	if deathController.ui and not deathController.ui:isDestroyed() then
		if g_modalManager then
			g_modalManager.hide(deathController.ui)
		end

		pcall(function()
			deathController.ui:ungrabKeyboard()
		end)
		deathController.ui:destroy()
	end

	if modules.game_interface and modules.game_interface.getRootPanel then
		local rootPanel = modules.game_interface.getRootPanel()

		if rootPanel then
			rootPanel:focus()
		end
	end

	if modules.game_console and modules.game_console.getConsole then
		local console = modules.game_console.getConsole()

		if console then
			console:focus()
		end
	end

	return nil
end

local function setStringColor(textTable, text, color)
	table.insert(textTable, text)
	table.insert(textTable, color)
end

local function tableToColoredText(t)
	local result = ""

	for i = 1, #t, 2 do
		local text = t[i] or ""
		local color = t[i + 1] or "#ffffff"

		result = result .. "{" .. text .. ", " .. color .. "}"
	end

	return result
end

function display(deathType, penalty)
	openWindow(deathType, penalty)
end

function openWindow(deathType, penalty)
	deathController.ui = destroyWindows()
	deathController.ui = g_ui.displayUI("deathwindow", rootWidget)

	local window = deathController.ui
	local textLabel = window:recursiveGetChildById("labelText")
	local baseWidth = window.baseWidth or 369
	local baseHeight = window.baseHeight or 217
	local messageT = {}
	local extraHeight = 15

	if deathType == DeathType.Regular and penalty ~= nil and penalty ~= 100 then
		setStringColor(messageT, "Alas! Brave adventurer, you have met a sad fate.\nBut do not despair, for the gods will bring you back\ninto the world in exchange for a small sacrifice\n\n", "#c0c0c0")
		setStringColor(messageT, "This death penalty has been reduced by " .. tostring(penalty) .. "%\nbecause it was a unfair fight.\n\nSimply click on ", "#c0c0c0")
		setStringColor(messageT, "Ok ", "#ffffff")
		setStringColor(messageT, "to resume your journeys in game\nor on ", "#c0c0c0")
		setStringColor(messageT, "Cancel ", "#ffffff")
		setStringColor(messageT, "to get to your character list!\n\nClick on ", "#c0c0c0")
		setStringColor(messageT, "Store ", "#ffffff")
		setStringColor(messageT, "to resume your journeys and to shop\nblessings to ease the pain if you are unfortunate\nenough to lose another fight!", "#c0c0c0")

		extraHeight = 46
	else
		setStringColor(messageT, "Alas! Brave adventurer, you have met a sad fate.\nBut do not despair, for the gods will bring you back\ninto the world in exchange for a small sacrifice\n\nSimply click on ", "#c0c0c0")
		setStringColor(messageT, "Ok ", "#ffffff")
		setStringColor(messageT, "to resume your journeys in game\nor on ", "#c0c0c0")
		setStringColor(messageT, "Cancel ", "#ffffff")
		setStringColor(messageT, "to get to your character list!\n\nClick on ", "#c0c0c0")
		setStringColor(messageT, "Store ", "#ffffff")
		setStringColor(messageT, "to resume your journeys and to shop\nblessings to ease the pain if you are unfortunate\nenough to lose another fight!", "#c0c0c0")

		extraHeight = 15
	end

	window:setWidth(baseWidth)
	window:setHeight(baseHeight + extraHeight)

	if textLabel then
		textLabel:setColoredText(tableToColoredText(messageT))
	end

	if g_modalManager then
		g_modalManager.show(window)
	end

	local storeButton = window:recursiveGetChildById("buttonStore")
	local okButton = window:recursiveGetChildById("buttonOk")
	local cancelButton = window:recursiveGetChildById("buttonCancel")

	local function storeFunc()
		deathController.ui = destroyWindows()
		openStoreBlessingsOnLogin = true
		CharacterList.doLogin()
	end

	local function okFunc()
		deathController.ui = destroyWindows()
		openStoreBlessingsOnLogin = false
		CharacterList.doLogin()
	end

	local function cancelFunc()
		openStoreBlessingsOnLogin = false
		deathController.ui = destroyWindows()
		g_game.cancelLogin()

		if CharacterList and CharacterList.showAgain then
			CharacterList.showAgain()
		end
	end

	window.onEnter = okFunc
	window.onEscape = cancelFunc

	if storeButton then
		storeButton.onClick = storeFunc
	end

	if okButton then
		okButton.onClick = okFunc
	end

	if cancelButton then
		cancelButton.onClick = cancelFunc
	end
end
