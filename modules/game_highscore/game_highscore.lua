-- chunkname: @/game_highscore/game_highscore.lua

local highscoresWindow, highscoreButton, gameworldbox, vocationbox, categorybox, highscoreList
local isFilled = false
local cachedBattlEye = 0
local currentPage = 1
local currentTotalPages = 1
local ALL_WORLDS_LABEL = "All Game Worlds"
local ALL_VOCATIONS_ID = 4294967295
local ENTRIES_PER_PAGE = 20
local preferredWorldOnOpen, requestHighscore
local highscoreRequestPending = false
local HIGHSCORE_DEBUG = false
local highscoreRequestSeq = 0
local lastHighscoreRequest

local function highscoreDebugLog(msg)
	if not HIGHSCORE_DEBUG then
		return
	end

	g_logger.info("[Highscore] " .. msg)
	print("[Highscore] " .. msg)
end

local function summarizeHighscoreEntries(highscores)
	if #highscores == 0 then
		return "(empty)"
	end

	local parts = {}

	for i, character in ipairs(highscores) do
		parts[#parts + 1] = string.format("%d:%s rank=%s", i, character[2] or "?", tostring(character[1]))
	end

	return table.concat(parts, " | ")
end

local WORLD_TYPE = {
	retroHardcorePvp = 4,
	retroOpenPvp = 3,
	hardcorePvp = 2,
	optionalPvp = 1,
	openPvp = 0
}

local function isPlayerEntry(character)
	return character[7] == 1 or character[7] == true
end

local function isLocalPlayerEntry(character)
	local player = g_game.getLocalPlayer()

	if not player then
		return isPlayerEntry(character)
	end

	return character[2]:lower() == player:getName():lower() or isPlayerEntry(character)
end

local function getPlayerWorldName()
	if not g_game.isOnline() then
		return nil
	end

	local world = g_game.getWorldName()

	if world and world ~= "" then
		return world
	end

	return nil
end

local function ensureWorldOption(worldName)
	if worldName and worldName ~= "" and not gameworldbox:isOption(worldName) then
		gameworldbox:addOption(worldName, worldName)
	end
end

local function selectWorldInCombo(worldName)
	if worldName and worldName ~= "" and gameworldbox:isOption(worldName) then
		gameworldbox:setCurrentOption(worldName, true)

		return true
	end

	if gameworldbox:isOption(ALL_WORLDS_LABEL) then
		gameworldbox:setCurrentOption(ALL_WORLDS_LABEL, true)
	end

	return false
end

highscoreController = Controller:new()

highscoreController:setUI("game_highscore")

function highscoreController:onInit()
	highscoresWindow = highscoreController.ui

	highscoresWindow:hide()
	highscoreController:registerEvents(g_game, {
		onProcessHighscores = onProcessHighscores
	})
	initInterface()
	Keybind.new("Dialogs", "Open Highscores Dialog", "", "")
	Keybind.bind("Dialogs", "Open Highscores Dialog", {
		{
			type = KEY_DOWN,
			callback = toggle
		}
	})
end

function highscoreController:onTerminate()
	Keybind.delete("Dialogs", "Open Highscores Dialog")
	resetFilters()

	highscoresWindow = nil
	gameworldbox = nil
	vocationbox = nil
	categorybox = nil
	highscoreList = nil
end

local function initFilterPlaceholders()
	gameworldbox:clearOptions()
	gameworldbox:addOption(ALL_WORLDS_LABEL, "")
	ensureWorldOption(getPlayerWorldName())
	selectWorldInCombo(preferredWorldOnOpen or getPlayerWorldName())
	vocationbox:clearOptions()
	vocationbox:addOption(tr("(all)"), ALL_VOCATIONS_ID)
	categorybox:clearOptions()
	categorybox:addOption(tr("Experience Points"), 0)
end

function resetFilters()
	isFilled = false
	cachedBattlEye = 0
	currentPage = 1
	currentTotalPages = 1

	if gameworldbox then
		initFilterPlaceholders()
	end
end

function hide()
	preferredWorldOnOpen = nil
	highscoreRequestPending = false

	g_modalManager.hide(highscoresWindow)
	highscoresWindow:hide()
end

function show()
	preferredWorldOnOpen = getPlayerWorldName()

	highscoresWindow:show()
	highscoresWindow:raise()
	highscoresWindow:focus()
	g_modalManager.show(highscoresWindow)
	ensureWorldOption(preferredWorldOnOpen)
	selectWorldInCombo(preferredWorldOnOpen)
	requestHighscore(0, 1, "show-window")
end

local function getHours(seconds)
	return math.floor(seconds / 60 / 60)
end

local function getMinutes(seconds)
	return math.floor(seconds / 60)
end

local function getSeconds(seconds)
	return seconds % 60
end

local function getTimeinWords(secs)
	local hours, minutes, seconds = getHours(secs), getMinutes(secs), getSeconds(secs)

	if minutes > 59 then
		minutes = minutes - hours * 60
	end

	local timeStr = ""

	if hours > 0 then
		timeStr = timeStr .. hours .. " hours "
	end

	if minutes > 0 then
		timeStr = timeStr .. minutes .. " minutes"
	elseif seconds > 0 then
		timeStr = seconds .. " seconds"
	end

	return timeStr
end

local WORLD_TYPE_CHECKS

local function getWorldTypeCheckboxes()
	if WORLD_TYPE_CHECKS then
		return WORLD_TYPE_CHECKS
	end

	local filters = highscoresWindow.filters

	WORLD_TYPE_CHECKS = {
		{
			check = filters.openPvpCheck,
			id = WORLD_TYPE.openPvp
		},
		{
			check = filters.optionalPvpCheck,
			id = WORLD_TYPE.optionalPvp
		},
		{
			check = filters.hardcorePvpCheck,
			id = WORLD_TYPE.hardcorePvp
		},
		{
			check = filters.retroOpenPvpCheck,
			id = WORLD_TYPE.retroOpenPvp
		},
		{
			check = filters.retroHardcorePvpCheck,
			id = WORLD_TYPE.retroHardcorePvp
		}
	}

	return WORLD_TYPE_CHECKS
end

local function getSelectedWorldType()
	for _, entry in ipairs(getWorldTypeCheckboxes()) do
		if entry.check:isChecked() then
			return entry.id
		end
	end

	return 0
end

local function bindWorldTypeCheckbox(checkbox, worldTypeId)
	function checkbox.onCheckChange(widget, checked)
		if not checked then
			return
		end

		for _, entry in ipairs(getWorldTypeCheckboxes()) do
			if entry.check ~= widget then
				entry.check:setChecked(false)
			end
		end
	end
end

local function getSelectedWorld()
	local option = gameworldbox:getCurrentOption()

	if not option or option.text == ALL_WORLDS_LABEL then
		return ""
	end

	return option.text
end

local function getSelectedCategoryId()
	local option = categorybox:getCurrentOption()

	if option and option.data ~= nil then
		return option.data
	end

	return 0
end

local function getSelectedVocationId()
	local option = vocationbox:getCurrentOption()

	if option and option.data ~= nil then
		return option.data
	end

	return ALL_VOCATIONS_ID
end

local function getFilterSnapshot()
	local worldOpt = gameworldbox and gameworldbox:getCurrentOption()
	local vocOpt = vocationbox and vocationbox:getCurrentOption()
	local catOpt = categorybox and categorybox:getCurrentOption()

	return string.format("UI world=\"%s\" cat=%s voc=%s wType=0x%X", worldOpt and worldOpt.text or "?", catOpt and tostring(catOpt.data) or "?", vocOpt and string.format("0x%X", vocOpt.data or 0) or "?", getSelectedWorldType())
end

function requestHighscore(action, page, tag)
	if highscoreRequestPending then
		highscoreDebugLog(string.format("REQ ignored (server async): %s page=%d", tag or "?", page))

		return
	end

	highscoreRequestPending = true
	highscoreRequestSeq = highscoreRequestSeq + 1

	local seq = highscoreRequestSeq
	local category = getSelectedCategoryId()
	local vocation = getSelectedVocationId()
	local world = getSelectedWorld()
	local worldType = getSelectedWorldType()

	lastHighscoreRequest = {
		seq = seq,
		tag = tag or "?",
		action = action,
		page = page,
		category = category,
		vocation = vocation,
		world = world,
		worldType = worldType,
		battlEye = cachedBattlEye
	}

	highscoreDebugLog(string.format("REQ #%d tag=%s action=%d page=%d world=\"%s\" cat=%d voc=0x%X wType=0x%X battlEye=%d | %s", seq, tag or "?", action, page, world, category, vocation, worldType, cachedBattlEye, getFilterSnapshot()))
	g_game.requestHighscore(action, category, vocation, world, worldType, cachedBattlEye, page, ENTRIES_PER_PAGE)
end

local function fillHighscoreList(highscores)
	highscoreList:destroyChildren()

	local playerWidget

	for index = 1, ENTRIES_PER_PAGE do
		local widget = g_ui.createWidget("ListHighscore", highscoreList)

		widget:setBackgroundColor(index % 2 == 0 and "#414141" or "#484848")

		local character = highscores[index]

		if character then
			widget.rank:setText(character[1])
			widget.name:setText(character[2])
			widget.vocation:setText(g_game.getVocationName(character[4]))
			widget.gameworld:setText(short_text(character[5], 8))
			widget.level:setText(character[6])
			widget.points:setText(comma_value(character[8]))

			if isLocalPlayerEntry(character) then
				widget.rank:setColor("#60f860")
				widget.name:setColor("#60f860")
				widget.vocation:setColor("#60f860")
				widget.gameworld:setColor("#60f860")
				widget.level:setColor("#60f860")
				widget.points:setColor("#60f860")

				playerWidget = widget
			end
		end
	end

	if highscoreList.updateLayout then
		highscoreList:updateLayout()
	end

	if playerWidget then
		highscoreList:ensureChildVisible(playerWidget)
	end
end

local function setupFilterOptions(worlds, vocations, categories)
	gameworldbox:clearOptions()
	gameworldbox:addOption(ALL_WORLDS_LABEL, "")

	-- our C++ sends the world name as a single string (serverName), not a list
	if type(worlds) == "string" then
		if worlds ~= "" then
			ensureWorldOption(worlds)
		end
	else
		for _, worldName in ipairs(worlds or {}) do
			ensureWorldOption(worldName)
		end
	end

	ensureWorldOption(getPlayerWorldName())
	vocationbox:clearOptions()
	vocationbox:addOption(tr("(all)"), ALL_VOCATIONS_ID)

	for _, voc in ipairs(vocations) do
		vocationbox:addOption(voc[2], voc[1])
	end

	categorybox:clearOptions()

	for _, cat in ipairs(categories) do
		categorybox:addOption(cat[2], cat[1])
	end
end

local function updatePaginationButtons(page, totalPages)
	local isFirstPage = page <= 1
	local isLastPage = totalPages <= 1 or totalPages <= page

	highscoresWindow.first:setEnabled(not isFirstPage)
	highscoresWindow.prevButton:setEnabled(not isFirstPage)
	highscoresWindow.nextButton:setEnabled(not isLastPage)
	highscoresWindow.last:setEnabled(not isLastPage)
end

local function syncFilterSelections(selectedVocation, selectedCategory)
	local vocBefore = vocationbox:getCurrentOption()
	local catBefore = categorybox:getCurrentOption()
	local worldBefore = gameworldbox:getCurrentOption()

	if preferredWorldOnOpen then
		selectWorldInCombo(preferredWorldOnOpen)

		preferredWorldOnOpen = nil
	end

	vocationbox:setCurrentOptionByData(selectedVocation, true)
	categorybox:setCurrentOptionByData(selectedCategory, true)

	local vocAfter = vocationbox:getCurrentOption()
	local catAfter = categorybox:getCurrentOption()
	local worldAfter = gameworldbox:getCurrentOption()

	if HIGHSCORE_DEBUG then
		local changed = (vocBefore and vocBefore.data) ~= (vocAfter and vocAfter.data) or (catBefore and catBefore.data) ~= (catAfter and catAfter.data) or (worldBefore and worldBefore.text) ~= (worldAfter and worldAfter.text)

		if changed then
			highscoreDebugLog(string.format("syncFilterSelections CHANGED combos: voc 0x%X->0x%X cat %s->%s world \"%s\"->\"%s\" (server requested voc=0x%X cat=%d)", vocBefore and vocBefore.data or 0, vocAfter and vocAfter.data or 0, tostring(catBefore and catBefore.data), tostring(catAfter and catAfter.data), worldBefore and worldBefore.text or "?", worldAfter and worldAfter.text or "?", selectedVocation, selectedCategory))
		end
	end
end

function initInterface()
	highscoreList = highscoresWindow.highscoreList
	gameworldbox = highscoresWindow.filters.gameworldbox
	vocationbox = highscoresWindow.filters.vocationbox
	categorybox = highscoresWindow.filters.categorybox

	initFilterPlaceholders()
	bindWorldTypeCheckbox(highscoresWindow.filters.openPvpCheck, WORLD_TYPE.openPvp)
	bindWorldTypeCheckbox(highscoresWindow.filters.optionalPvpCheck, WORLD_TYPE.optionalPvp)
	bindWorldTypeCheckbox(highscoresWindow.filters.hardcorePvpCheck, WORLD_TYPE.hardcorePvp)
	bindWorldTypeCheckbox(highscoresWindow.filters.retroOpenPvpCheck, WORLD_TYPE.retroOpenPvp)
	bindWorldTypeCheckbox(highscoresWindow.filters.retroHardcorePvpCheck, WORLD_TYPE.retroHardcorePvp)

	function highscoresWindow.showOwnRank.onClick()
		highscoreDebugLog("CLICK showOwnRank")
		requestHighscore(1, 1, "show-own-rank")
	end

	function highscoresWindow.first.onClick()
		if currentPage > 1 then
			requestHighscore(0, 1, "nav-first")
		end
	end

	function highscoresWindow.prevButton.onClick()
		if currentPage > 1 then
			requestHighscore(0, currentPage - 1, "nav-prev")
		end
	end

	function highscoresWindow.nextButton.onClick()
		if currentPage < currentTotalPages then
			requestHighscore(0, currentPage + 1, "nav-next")
		end
	end

	function highscoresWindow.last.onClick()
		if currentPage < currentTotalPages then
			requestHighscore(0, currentTotalPages, "nav-last")
		end
	end

	function highscoresWindow.filters.submit.onClick()
		requestHighscore(0, 1, "submit-filters")
	end

	updatePaginationButtons(1, 1)
end

local function applyHighscoreResponse(page, totalPages, highscores, entriesTs)
	page = math.max(1, tonumber(page) or 1)
	totalPages = math.max(1, tonumber(totalPages) or 1)
	currentPage = page
	currentTotalPages = totalPages

	fillHighscoreList(highscores)
	highscoresWindow.page:setText(string.format("%d / %d", page, totalPages))
	highscoresWindow.lastUpdate:setText("Last Update: " .. getTimeinWords(os.time() - entriesTs) .. " ago")
	highscoresWindow.lastUpdate:setColor("#909090")
	updatePaginationButtons(page, totalPages)
end

-- our C++ (Game::processHighscore) does not send selectedVocation/selectedCategory:
-- (serverName, world, worldType, battlEye, vocations, categories, page, totalPages, highscores, entriesTs)
function onProcessHighscores(worlds, selectedWorld, worldType, battlEye, vocations, categories, page, totalPages, highscores, entriesTs)
	local req = lastHighscoreRequest
	local selectedVocation = req and req.vocation or 0xFFFFFFFF
	local selectedCategory = req and req.category or 0

	highscores = highscores or {}
	vocations = vocations or {}
	categories = categories or {}
	worlds = worlds or {}
	page = page or 1
	totalPages = totalPages or 1

	highscoreRequestPending = false

	local hasPlayer = false

	for _, character in ipairs(highscores) do
		if isLocalPlayerEntry(character) then
			hasPlayer = true

			break
		end
	end

	highscoreDebugLog(string.format("RSP after REQ #%s tag=%s | page=%d/%d entries=%d/%d srvWorld=\"%s\" srvWType=%d srvVoc=0x%X srvCat=%d | playerInList=%s | %s", req and tostring(req.seq) or "?", req and req.tag or "?", page, totalPages, #highscores, ENTRIES_PER_PAGE, selectedWorld or "", worldType, selectedVocation, selectedCategory, tostring(hasPlayer), getFilterSnapshot()))
	highscoreDebugLog("RSP entries: " .. summarizeHighscoreEntries(highscores))

	if req and req.action == 0 and req.page and page ~= req.page then
		highscoreDebugLog(string.format("WARNING divergent page: REQ #%d requested page=%d but server responded page=%d ? check the packet parse on the server", req.seq, req.page, page))
	end

	if req and req.action == 0 and #highscores > 0 and #highscores < ENTRIES_PER_PAGE then
		highscoreDebugLog(string.format("server sent %d/%d entries ? fix entriesPerPage in the server parse (use %d)", #highscores, ENTRIES_PER_PAGE, ENTRIES_PER_PAGE))
	end

	cachedBattlEye = battlEye

	if not isFilled then
		highscoreDebugLog("RSP setupFilterOptions (first fill)")
		setupFilterOptions(worlds, vocations, categories)

		isFilled = true
	end

	syncFilterSelections(selectedVocation, selectedCategory)
	applyHighscoreResponse(page, totalPages, highscores, entriesTs)
end

function highscoreController:onGameStart()
	highscoreButton = modules.game_mainpanel.addToggleButton("highscoresButton", tr("Open Highscores Dialog"), "/images/options/button_highscores", toggle)
end

function highscoreController:onGameEnd()
	if highscoreButton then
		highscoreButton:destroy()

		highscoreButton = nil
	end

	if highscoresWindow and highscoresWindow:isVisible() then
		hide()
	end

	resetFilters()
end

function toggle()
	if highscoresWindow:isVisible() then
		hide()
	else
		show()
	end
end
