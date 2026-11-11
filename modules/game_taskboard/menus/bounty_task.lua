-- chunkname: @/game_taskboard/menus/bounty_task.lua

TaskBoard.BountyTask = {}

local BountyTask = TaskBoard.BountyTask

CLAIMED_DAILY_TASK_STATE = false

local BACKDROP_BY_STARS = {
	[0] = "/modules/game_taskboard/images/backdrop_tasksystem_normal_task",
	"/modules/game_taskboard/images/backdrop_tasksystem_silver_task",
	"/modules/game_taskboard/images/backdrop_tasksystem_gold_task"
}

local function capitalizeWords(str)
	return (str or ""):gsub("(%a)([%w_']*)", function(first, rest)
		return first:upper() .. rest:lower()
	end)
end

local function applyStarsBackdrop(starsWidget, stars)
	if not starsWidget then
		return
	end

	local stars = tonumber(stars) or 0

	if stars > 0 then
		starsWidget:setSize(tosize("279 44"))
	end

	starsWidget:setImageSource(BACKDROP_BY_STARS[stars] or BACKDROP_BY_STARS[0])
end

local BOUNTY_TRACKER_TOOLTIP_FOOTER = "Click in this window to open the Task Board dialog."
local BOUNTY_TRACKER_TOOLTIP_INACTIVE = "Inactive Task.\n\nClick in this window to open Task Board dialog. Select a monster to start a new task."
local lastBountyTrackerData

local function buildBountyTrackerActiveTooltip(creatureName, killed, total)
	local header = string.format("Creature: %s\nAmount: %s / %s", capitalizeWords(creatureName), TaskBoard:formatNumberWithCommas(killed), TaskBoard:formatNumberWithCommas(total))

	return header .. "\n\n" .. tr(BOUNTY_TRACKER_TOOLTIP_FOOTER)
end

local function getBountyTrackerSlot()
	local prey = modules.game_prey

	if not prey or not prey.preyTracker or prey.preyTracker:isDestroyed() then
		return nil
	end

	local contents = prey.preyTracker.contentsPanel

	if not contents then
		return nil
	end

	return contents:getChildById("bslot1")
end

local function setBountyTrackerTooltip(slot, text)
	if not slot then
		return
	end

	slot:setTooltip(text)
end

local function setBountyTrackerInactive()
	local slot = getBountyTrackerSlot()

	if not slot then
		return
	end

	local creature = slot:getChildById("creature")
	local noCreature = slot:getChildById("noCreature")
	local nameLabel = slot:getChildById("creatureName")
	local timeBar = slot:getChildById("time")

	if creature then
		creature:setVisible(false)
	end

	if noCreature then
		noCreature:setVisible(true)
	end

	if nameLabel then
		nameLabel:setText(tr("Inactive"))
	end

	if timeBar then
		timeBar:setPercent(0)
	end

	setBountyTrackerTooltip(slot, tr(BOUNTY_TRACKER_TOOLTIP_INACTIVE))
end

local function setBountyTrackerSelected(data)
	local slot = getBountyTrackerSlot()

	if not slot or not data then
		return
	end

	local creature = slot:getChildById("creature")
	local noCreature = slot:getChildById("noCreature")
	local nameLabel = slot:getChildById("creatureName")
	local timeBar = slot:getChildById("time")
	local raceId = tonumber(data.raceId) or 0
	local raceData = g_things.getRaceData(raceId)
	local creatureName = (raceData and raceData.raceId ~= 0 and raceData.name and raceData.name ~= "") and raceData.name or (raceId > 0 and string.format("Creature (%d)", raceId) or "?")

	if creature then
		if raceData and raceData.outfit then
			creature:setOutfit(raceData.outfit)
			creature:getCreature():setStaticWalking(1000)
			creature:setVisible(true)
		else
			creature:setVisible(false)
		end
	end

	if noCreature then
		noCreature:setVisible(false)
	end

	if nameLabel then
		nameLabel:setText(modules.game_prey.formatKillTrackerCreatureName(creatureName))
	end

	local killed = tonumber(data.monstersKilled) or 0
	local total = tonumber(data.totalKills) or 0

	if timeBar then
		local percent = 0

		if total > 0 then
			percent = math.min(100, math.floor(killed / total * 100))
		end

		timeBar:setPercent(percent)
	end

	local tooltip = buildBountyTrackerActiveTooltip(creatureName, killed, total)

	setBountyTrackerTooltip(slot, tooltip)
	scheduleEvent(function()
		local trackerSlot = getBountyTrackerSlot()

		if trackerSlot then
			setBountyTrackerTooltip(trackerSlot, tooltip)
		end
	end, 0)
end

local function updateBountyKillTracker(slots)
	if type(slots) == "table" and #slots == 1 then
		lastBountyTrackerData = slots[1]

		setBountyTrackerSelected(slots[1])
	else
		lastBountyTrackerData = nil

		setBountyTrackerInactive()
	end

	if modules.game_prey and modules.game_prey.updateTrackerHeight then
		modules.game_prey.updateTrackerHeight()
	end
end

function BountyTask.requestTrackerData()
	if not g_game.isOnline() then
		return
	end

	if g_game.sendOpenMenuTaskBoardAction then
		g_game.sendOpenMenuTaskBoardAction(0)
	end
end

local function refreshBountyKillTrackerFromCache()
	if lastBountyTrackerData then
		setBountyTrackerSelected(lastBountyTrackerData)
	else
		setBountyTrackerInactive()
	end
end

function BountyTask.refreshKillTracker()
	refreshBountyKillTrackerFromCache()
end

function BountyTask:fillSlotPanel(panel, data, selected)
	if not panel or not data then
		return
	end

	panel.bountySlotData = data

	local starsBox = panel:getChildById("stars")

	applyStarsBackdrop(starsBox, data.stars)

	local creature = panel:recursiveGetChildById("slotCreature")
	local raceId = tonumber(data.raceId) or 0
	local creatureName = raceId > 0 and string.format("Creature (%d)", raceId) or "?"
	local raceData = g_things.getRaceData(raceId)

	if raceData and raceData.raceId ~= 0 and raceData.name and raceData.name ~= "" then
		creatureName = raceData.name

		if creature and raceData.outfit then
			creature:setOutfit(raceData.outfit)
			creature:setCenter(true)
			creature:setFixedCreatureSize(true)
			creature:setBaseScale(true)
			creature:setIgnoreDisplacementShift(true)
			creature:setVisible(true)

			local c = creature:getCreature()

			if c then
				c:setStaticWalking(1000)
			end
		end
	elseif creature then
		creature:setVisible(false)

		local c = creature:getCreature()

		if c then
			c:setStaticWalking(0)
		end
	end

	local nameLabel = starsBox and starsBox:getChildById("creatureName")
	local cur = panel:getChildById("killsCurrentValue")
	local tgt = panel:getChildById("killsTargetValue")
	local expL = panel:getChildById("experienceLabel")
	local bpL = panel:getChildById("bountyPointsLabel")

	nameLabel:setText(capitalizeWords(creatureName))
	cur:setText(TaskBoard:formatNumberWithCommas(data.monstersKilled or 0))
	tgt:setText(TaskBoard:formatNumberWithCommas(data.totalKills or 0))
	expL:setText(TaskBoard:formatNumberWithCommas(data.experiencePoints or 0))
	bpL:setText(TaskBoard:formatNumberWithCommas(data.bountyPoints or 0))

	local btn = panel:getChildById("selectTaskButton")

	if selected then
		btn:setText(tr("Claim Reward"))

		if data.monstersKilled < data.totalKills then
			btn:setEnabled(false)
			btn:setTooltip(tr("Finish the task to claim the reward."))
		else
			btn:setEnabled(true)
		end
	end

	function btn.onClick()
		if selected then
			g_game.sendClaimReward()
		else
			BountyTask:onSelectSlot(panel)
		end
	end

	local container = panel:getParent()

	if not container then
		return
	end

	local children = container:getChildren()

	if selected then
		children[1]:setMarginLeft(325)
	else
		for i = 2, #children do
			local child = children[i]

			child:addAnchor(AnchorLeft, "prev", AnchorRight)
			child:addAnchor(AnchorTop, "parent", AnchorTop)
			child:setMarginLeft(11)
		end
	end
end

function BountyTask:onSelectSlot(panel)
	local data = panel and panel.bountySlotData

	if not data then
		return
	end

	g_game.sendSelectTask(data.taskId)
end

function BountyTask:selectDifficulty(difficulty)
	local difficulties = {
		[0] = 0, [1] = 1, [2] = 2, [3] = 3,
		Beginner = 0, Adept = 1, Expert = 2, Master = 3,
		beginner = 0, adept = 1, expert = 2, master = 3
	}

	local d = difficulties[difficulty]
	if d == nil and type(difficulty) == "string" then
		d = difficulties[difficulty:lower()]
		if d == nil then
			if difficulty == tr("Beginner") then d = 0
			elseif difficulty == tr("Adept") then d = 1
			elseif difficulty == tr("Expert") then d = 2
			elseif difficulty == tr("Master") then d = 3
			end
		end
	end

	g_game.sendSelectTaskDifficulty(d or 0)
end

local bountyCreatureCache, selectedBountyRow, selectedBountyRace, listBuildEvent
local BOUNTY_COLOR_EVEN = "#484848"
local BOUNTY_COLOR_ODD = "#414141"
local BOUNTY_COLOR_SELECTED = "#585858"
local BOUNTY_BATCH_SIZE = 10

local function reindexListColors(list)
	if not list then
		return
	end

	local children = list:getChildren()
	local idx = 0

	for _, row in ipairs(children) do
		local base = idx % 2 == 0 and BOUNTY_COLOR_EVEN or BOUNTY_COLOR_ODD

		row.bountyBaseColor = base

		if row ~= selectedBountyRow then
			row:setBackgroundColor(base)
		end

		idx = idx + 1
	end
end

local function getBountyList()
	local preferredListPanel = TaskBoard.preferredListPanel

	if not preferredListPanel then
		return nil
	end

	local leftPanel = preferredListPanel:getChildById("leftPanel")

	if not leftPanel then
		return nil
	end

	return leftPanel:getChildById("list")
end

local function buildBountyCreatureCache()
	local allRaces = g_things.getMonsterList()
	local filtered = {}

	-- The module filtered on `race.hasBountyTask` - a field from the ported client's own build, which
	-- our staticdata.proto does not have at all (Creature carries only raceId/name/outfit, plus the
	-- boss flag from the boss bank). The condition was therefore always false and the list came out EMPTY.
	-- The server validates raceId only via getMonsterTypeByRaceId, so filtering out bosses is enough.
	for _, race in ipairs(allRaces) do
		if race.raceId and race.raceId > 0 and not race.boss and race.name and race.name ~= "" then
			filtered[#filtered + 1] = race
		end
	end

	table.sort(filtered, function(a, b)
		return a.name:lower() < b.name:lower()
	end)

	bountyCreatureCache = filtered
end

local function getBountyCreaturesSorted()
	if not bountyCreatureCache then
		buildBountyCreatureCache()
	end

	return bountyCreatureCache
end

local function selectBountyRow(row, race)
	if selectedBountyRow and selectedBountyRow ~= row then
		selectedBountyRow:setBackgroundColor(selectedBountyRow.bountyBaseColor or BOUNTY_COLOR_EVEN)
	end

	selectedBountyRow = row
	selectedBountyRace = race

	if row then
		row:setBackgroundColor(BOUNTY_COLOR_SELECTED)
	end
end

local function applyBountyCreaturePreview(creatureWidget, outfit, animate)
	if not creatureWidget or not outfit then
		return
	end

	creatureWidget:setOutfit(outfit)

	if animate then
		local c = creatureWidget:getCreature()

		if c then
			c:setStaticWalking(1000)
		end
	end
end

local function setSlotCreature(slotWidget, race)
	if not slotWidget or not race then
		return
	end

	local creature = slotWidget:getChildById("slotCreature")

	if creature and race.outfit then
		applyBountyCreaturePreview(creature, race.outfit, true)
		creature:setVisible(true)
	end

	slotWidget.assignedRaceId = race.raceId
end

local function cancelListBuild()
	if listBuildEvent then
		removeEvent(listBuildEvent)

		listBuildEvent = nil
	end
end

local function createBountyRow(list, race, rowIndex)
	local row = g_ui.createWidget("BountyCreatureRow", list)

	if not row then
		return
	end

	local base = rowIndex % 2 == 0 and BOUNTY_COLOR_EVEN or BOUNTY_COLOR_ODD

	row.bountyBaseColor = base
	row.bountyRace = race

	row:setBackgroundColor(base)

	local sprite = row:getChildById("creatureSprite")

	if sprite and race.outfit then
		applyBountyCreaturePreview(sprite, race.outfit, false)
	end

	local nameLabel = row:getChildById("creatureName")

	if nameLabel then
		nameLabel:setText(capitalizeWords(race.name))
	end

	function row.onClick()
		selectBountyRow(row, race)
	end
end

local function populateBountyCreatureList(filterText, excludeRaceIds)
	cancelListBuild()

	local preferredListPanel = TaskBoard.preferredListPanel

	if not preferredListPanel then
		return
	end

	local leftPanel = preferredListPanel:getChildById("leftPanel")

	if not leftPanel then
		return
	end

	local list = leftPanel:getChildById("list")

	if not list then
		return
	end

	selectedBountyRow = nil
	selectedBountyRace = nil

	list:destroyChildren()

	local creatures = getBountyCreaturesSorted()
	local lowerFilter = filterText and filterText:lower() or ""
	local excludeSet = {}

	for _, id in ipairs(excludeRaceIds or {}) do
		excludeSet[id] = true
	end

	local toCreate = {}

	for _, race in ipairs(creatures) do
		if not excludeSet[race.raceId] and (lowerFilter == "" or race.name:lower():find(lowerFilter, 1, true)) then
			toCreate[#toCreate + 1] = race
		end
	end

	local idx = 1
	local total = #toCreate

	local function createNextBatch()
		listBuildEvent = nil

		if not list or list:isDestroyed() then
			return
		end

		local layout = list:getLayout()

		if layout then
			layout:disableUpdates()
		end

		local endIdx = math.min(idx + BOUNTY_BATCH_SIZE - 1, total)

		for i = idx, endIdx do
			createBountyRow(list, toCreate[i], i - 1)
		end

		idx = endIdx + 1

		if layout then
			layout:enableUpdates()
			layout:update()
		end

		if idx <= total then
			listBuildEvent = addEvent(createNextBatch)
		end
	end

	createNextBatch()
end

local function getExcludedRaceIds()
	local ids = {}
	local preferredListPanel = TaskBoard.preferredListPanel

	if not preferredListPanel then
		return ids
	end

	local rightPanel = preferredListPanel:getChildById("rightPanel")

	if not rightPanel then
		return ids
	end

	local slotsList = rightPanel:getChildById("slotsList")

	if not slotsList then
		return ids
	end

	for _, row in ipairs(slotsList:getChildren()) do
		local prefSlot = row:getChildById("preferredSlot")

		if prefSlot and prefSlot.assignedRaceId then
			ids[#ids + 1] = prefSlot.assignedRaceId
		end

		local unwSlot = row:getChildById("unwantedSlot")

		if unwSlot and unwSlot.assignedRaceId then
			ids[#ids + 1] = unwSlot.assignedRaceId
		end
	end

	return ids
end

function BountyTask:filterPreferredList(text)
	populateBountyCreatureList(text, getExcludedRaceIds())
end

function BountyTask:clearPreferredSearch()
	local preferredListPanel = TaskBoard.preferredListPanel

	if not preferredListPanel then
		return
	end

	local leftPanel = preferredListPanel:getChildById("leftPanel")

	if not leftPanel then
		return
	end

	local search = leftPanel:getChildById("search")

	if search then
		search:setText("")
	end

	populateBountyCreatureList("", getExcludedRaceIds())
end

function BountyTask:showPreferredList()
	local preferredListPanel = TaskBoard.preferredListPanel

	if not preferredListPanel then
		return
	end

	bountyCreatureCache = nil
	selectedBountyRow = nil
	selectedBountyRace = nil

	populateBountyCreatureList("", {})

	local chainTransparent = TaskBoard.chainTransparent

	if chainTransparent then
		chainTransparent:show()
	end

	preferredListPanel:show()
	preferredListPanel:raise()
	preferredListPanel:focus()
end

function BountyTask:closePreferredList()
	cancelListBuild()

	local preferredListPanel = TaskBoard.preferredListPanel

	if not preferredListPanel then
		return
	end

	preferredListPanel:hide()

	local chainTransparent = TaskBoard.chainTransparent

	if chainTransparent then
		chainTransparent:hide()
	end
end

local PREFERRED_CLEAR_COST = 10
local PREFERRED_UNLOCK_COSTS = {
	300,
	600,
	900,
	1200
}

local function clearSlotWidget(slotWidget)
	if not slotWidget then
		return
	end

	local creature = slotWidget:getChildById("slotCreature")

	if creature then
		creature:setVisible(false)

		local c = creature:getCreature()

		if c then
			c:setStaticWalking(0)
		end
	end

	slotWidget.assignedRaceId = nil
end

local function wireSlotClearButton(row, slotWidget, btn, costPanel, slotIndex, isUnwanted)
	btn:setText(tr("Clear"))

	if costPanel then
		costPanel:show()
	end

	function btn.onClick()
		if isUnwanted then
			g_game.sendPreferredListClearUnwanted(slotIndex)
		else
			g_game.sendPreferredListClearPreferred(slotIndex)
		end

		clearSlotWidget(slotWidget)
		btn:setText(tr("Assign"))

		if costPanel then
			costPanel:hide()
		end

		function btn.onClick()
			if isUnwanted then
				BountyTask:assignToRow(row, slotIndex, true)
			else
				BountyTask:assignToRow(row, slotIndex, false)
			end
		end

		populateBountyCreatureList("", getExcludedRaceIds())
	end
end

local function wireSlotAssignButton(row, btn, slotIndex, isUnwanted)
	function btn.onClick()
		if isUnwanted then
			BountyTask:assignToRow(row, slotIndex, true)
		else
			BountyTask:assignToRow(row, slotIndex, false)
		end
	end
end

function BountyTask:assignToRow(row, slotIndex, isUnwanted)
	if not selectedBountyRace then
		return
	end

	local slotId = isUnwanted and "unwantedSlot" or "preferredSlot"
	local btnId = isUnwanted and "unwantedButton" or "preferredButton"
	local costId = isUnwanted and "unwantedCostPanel" or "preferredCostPanel"
	local slotWidget = row:getChildById(slotId)
	local btn = row:getChildById(btnId)
	local costPanel = row:getChildById(costId)

	setSlotCreature(slotWidget, selectedBountyRace)

	if isUnwanted then
		g_game.sendPreferredListUnwanted(slotIndex, selectedBountyRace.raceId)
	else
		g_game.sendPreferredListPreferred(slotIndex, selectedBountyRace.raceId)
	end

	if selectedBountyRow then
		selectedBountyRow:destroy()

		selectedBountyRow = nil
	end

	selectedBountyRace = nil

	reindexListColors(getBountyList())
	wireSlotClearButton(row, slotWidget, btn, costPanel, slotIndex, isUnwanted)
end

function BountyTask:AssignCreatureSlot()
	return
end

function BountyTask:UnwantedCreatureSlot()
	return
end

local function buildPreferredSlotRow(container, slotIndex, data)
	local row = g_ui.createWidget("PreferredSlotRow", container)

	if not row then
		return
	end

	local prefSlot = row:getChildById("preferredSlot")
	local prefBtn = row:getChildById("preferredButton")
	local prefCost = row:getChildById("preferredCostPanel")
	local unwSlot = row:getChildById("unwantedSlot")
	local unwBtn = row:getChildById("unwantedButton")
	local unwCost = row:getChildById("unwantedCostPanel")

	if data.preferred and data.preferred ~= 0 then
		local raceData = g_things.getRaceData(data.preferred)

		if raceData and raceData.raceId ~= 0 then
			setSlotCreature(prefSlot, raceData)
			wireSlotClearButton(row, prefSlot, prefBtn, prefCost, slotIndex, false)
		end
	else
		wireSlotAssignButton(row, prefBtn, slotIndex, false)
	end

	if data.unwanted and data.unwanted ~= 0 then
		local raceData = g_things.getRaceData(data.unwanted)

		if raceData and raceData.raceId ~= 0 then
			setSlotCreature(unwSlot, raceData)
			wireSlotClearButton(row, unwSlot, unwBtn, unwCost, slotIndex, true)
		end
	else
		wireSlotAssignButton(row, unwBtn, slotIndex, true)
	end
end

local function buildPreferredLockedRow(container, slotIndex)
	local row = g_ui.createWidget("PreferredLockedRow", container)

	if not row then
		return
	end

	local costLabel = row:recursiveGetChildById("unlockCostValue")
	local unlockCost = PREFERRED_UNLOCK_COSTS[slotIndex] or slotIndex * 300

	if costLabel then
		costLabel:setText(TaskBoard:formatNumberWithCommas(unlockCost))
	end

	local btn = row:getChildById("unlockButton")

	if btn then
		function btn.onClick()
			-- our engine requires the slot number (bountyPreferredAction BUY_SLOT ignores slot == 0),
			-- while the module had it only in the closure and never passed it anywhere
			g_game.sendPreferredListUnlockSlots(slotIndex)
		end
	end
end

local function updatePreferredList(preferredListData)
	local preferredListPanel = TaskBoard.preferredListPanel

	if not preferredListPanel then
		return
	end

	local rightPanel = preferredListPanel:getChildById("rightPanel")

	if not rightPanel then
		return
	end

	local slotsList = rightPanel:getChildById("slotsList")

	if not slotsList then
		return
	end

	slotsList:destroyChildren()

	if type(preferredListData) ~= "table" then
		return
	end

	local lockedIndex = 1

	for i, data in ipairs(preferredListData) do
		local isUnlocked = data.unlocked or i == 1

		if isUnlocked then
			buildPreferredSlotRow(slotsList, i - 1, data)
		else
			buildPreferredLockedRow(slotsList, lockedIndex)

			lockedIndex = lockedIndex + 1
		end
	end

	populateBountyCreatureList("", getExcludedRaceIds())
end

function BountyTask:rerollTasks()
	local rerollTokens = TaskBoard.bountyTaskPanel and TaskBoard.bountyTaskPanel:recursiveGetChildById("rerollPanel")
	local rerollButton = TaskBoard.bountyTaskPanel and TaskBoard.bountyTaskPanel:recursiveGetChildById("rerollButton")
	local valueLabel = rerollTokens and rerollTokens:getChildById("value")
	local tokens = valueLabel and tonumber(valueLabel:getText()) or 0

	if tokens == 1 and rerollButton then
		rerollButton:setEnabled(false)
		rerollButton:setTooltip(tr("You don't have more reroll tokens."))
	end

	g_game.sendRerollTasks()
end

function BountyTask:claimDaily()
	if not CLAIMED_DAILY_TASK_STATE then
		return
	end

	local rerollBox = TaskBoard.bountyTaskPanel:recursiveGetChildById("rerollTasks")
	local claimButton = rerollBox:getChildById("claimButton")

	claimButton:setEnabled(false)
	claimButton:setImageClip("0 40 108 20")
	claimButton:setTooltip(tr("Already claimed today."))

	CLAIMED_DAILY_TASK_STATE = false

	g_game.sendClaimDaily()
end

function BountyTask:updateTalisman(talismanId)
	g_game.sendUpgradeTalisman(talismanId)
end

local function bountyDifficultyOptionText(index)
	local i = tonumber(index) or 0
	local names = {
		tr("Beginner"),
		tr("Adept"),
		tr("Expert"),
		tr("Master")
	}

	return names[i + 1] or names[1]
end

local function getTalismanBonus(talismanId, level)
	local percent = 2.5

	level = tonumber(level) or 0
	talismanId = tonumber(talismanId) or 0

	if talismanId <= 2 then
		local lvl1 = math.min(level, 15)

		percent = percent + lvl1 * 0.5

		if level > 15 then
			local lvl2 = math.min(level - 15, 40)

			percent = percent + lvl2 * 0.25
		end

		if level > 55 then
			percent = percent + (level - 55) * 0.1
		end

		return math.min(percent, 50)
	end

	percent = 5

	if talismanId == 3 then
		local lvl1 = math.min(level, 15)

		percent = percent + lvl1 * 1

		if level > 15 then
			local lvl2 = math.min(level - 15, 40)

			percent = percent + lvl2 * 0.5
		end

		if level > 55 then
			percent = percent + (level - 55) * 0.2
		end

		return math.min(percent, 100)
	end

	return 0
end

local function applyBountyTalismanRow(talismanId, data, labelWidget, upgradeButton, bountyPointsPanel)
	if not data then
		return
	end

	local level = tonumber(data.talismaLevel) or 0
	local price = tonumber(data.upgradePrice) or 0
	local can = data.canUpgrade == true

	if labelWidget then
		labelWidget:setText(string.format("%.1f", getTalismanBonus(talismanId, level)))
	end

	if bountyPointsPanel then
		local v = bountyPointsPanel:getChildById("value")

		if v then
			v:setText(TaskBoard:formatNumberWithCommas(price))
		end
	end

	if upgradeButton then
		upgradeButton:setEnabled(can)

		if can then
			local nextTier = getTalismanBonus(talismanId, level + 1)

			upgradeButton:setText(tr("Upgrade to %.1f %%", nextTier))
		else
			local nextTier = getTalismanBonus(talismanId, level + 1)

			upgradeButton:setText(tr("Upgrade to %.1f %%", nextTier))
			upgradeButton:setTooltip(tr("You do not have enough Bounty Points."))
		end
	end
end

function onBountyTasksDaily(slots, rerollTokens, claimUnlocked, difficultyBountyTask, talismanData, preferredListData)
	updateBountyKillTracker(slots)

	local container = TaskBoard.bountyTaskPanel and TaskBoard.bountyTaskPanel:recursiveGetChildById("dailyTasks")

	if not container then
		return
	end

	container:destroyChildren()

	if #slots == 1 then
		local panel = g_ui.createWidget("BountyTaskSlotPanel", container)

		if panel then
			BountyTask:fillSlotPanel(panel, slots[1], true)
		end
	else
		for _, slotData in ipairs(slots) do
			local panel = g_ui.createWidget("BountyTaskSlotPanel", container)

			if panel then
				BountyTask:fillSlotPanel(panel, slotData)
			end
		end
	end

	container:updateLayout()

	local bountyPanel = container:getParent()

	if bountyPanel then
		bountyPanel:updateLayout()
	end

	local rerollBox = TaskBoard.bountyTaskPanel:recursiveGetChildById("rerollTasks")
	local filterDifficulty = rerollBox:getChildById("showFilterDifficulty")
	local rerollButton = rerollBox:getChildById("rerollButton")
	local rerollTokensLabel = rerollBox:getChildById("rerollPanel")
	local rerollTokensValue = rerollTokensLabel and rerollTokensLabel:getChildById("value")
	local claimButton = rerollBox:getChildById("claimButton")

	filterDifficulty:setCurrentOption(bountyDifficultyOptionText(difficultyBountyTask), true)
	rerollTokensValue:setText(rerollTokens and tostring(rerollTokens) or "0")

	if not rerollTokens or tonumber(rerollTokens) == 0 then
		rerollButton:setEnabled(false)
		rerollButton:setImageClip("0 40 108 20")
		rerollButton:setTooltip(tr("You have no rerolls left."))
	else
		rerollButton:setEnabled(true)
		rerollButton:setImageClip("0 0 108 20")
	end

	if tonumber(claimUnlocked) == 0 then
		claimButton:setEnabled(true)
		claimButton:setImageClip("0 0 108 20")

		CLAIMED_DAILY_TASK_STATE = true
	elseif tonumber(claimUnlocked) == 1 then
		claimButton:setEnabled(false)
		claimButton:setImageClip("0 40 108 20")
		claimButton:setTooltip(tr("Already claimed today."))

		CLAIMED_DAILY_TASK_STATE = false
	elseif tonumber(claimUnlocked) == 2 then
		claimButton:setEnabled(false)
		claimButton:setImageClip("0 40 108 20")
		claimButton:setTooltip(tr("Limit reached."))

		CLAIMED_DAILY_TASK_STATE = false
	end

	local talismanPanel = TaskBoard.bountyTaskPanel and TaskBoard.bountyTaskPanel:recursiveGetChildById("bountyTalismans")

	if talismanPanel and type(talismanData) == "table" and #talismanData >= 4 then
		local damageTalisman = talismanPanel:recursiveGetChildById("damageAgainst")
		local damageButton = talismanPanel:getChildById("damageButton")
		local bountyDamagePanel = talismanPanel:getChildById("bountyPointsDamagePanel")

		applyBountyTalismanRow(0, talismanData[1], damageTalisman, damageButton, bountyDamagePanel)

		local lifeLeechTalisman = talismanPanel:recursiveGetChildById("LifeLeechAgainst")
		local lifeLeechButton = talismanPanel:getChildById("lifeLeechButton")
		local bountyLifeLeechPanel = talismanPanel:getChildById("bountyPointsLifeLeechPanel")

		applyBountyTalismanRow(1, talismanData[2], lifeLeechTalisman, lifeLeechButton, bountyLifeLeechPanel)

		local moreLootTalisman = talismanPanel:recursiveGetChildById("MoreLootAgainst")
		local moreLootButton = talismanPanel:getChildById("moreLootButton")
		local bountyMoreLootPanel = talismanPanel:getChildById("bountyPointsMoreLootPanel")

		applyBountyTalismanRow(2, talismanData[3], moreLootTalisman, moreLootButton, bountyMoreLootPanel)

		local bestiaryTalisman = talismanPanel:recursiveGetChildById("BestiaryAgainst")
		local bestiaryButton = talismanPanel:getChildById("bestiaryButton")
		local bountyBestiaryPanel = talismanPanel:getChildById("bountyPointsBestiaryPanel")

		applyBountyTalismanRow(3, talismanData[4], bestiaryTalisman, bestiaryButton, bountyBestiaryPanel)
	end

	if type(preferredListData) == "table" then
		updatePreferredList(preferredListData)
	end
end

local function onGameStartBounty()
	bountyCreatureCache = nil

	scheduleEvent(buildBountyCreatureCache, 500)
	scheduleEvent(function()
		BountyTask.requestTrackerData()
	end, 500)
end

local function onGameEndBounty()
	cancelListBuild()

	bountyCreatureCache = nil
	selectedBountyRow = nil
	selectedBountyRace = nil
	lastBountyTrackerData = nil

	setBountyTrackerInactive()
end

-- ADAPTER for our engine.
-- The engine splits bounty data into TWO events always arriving in pairs and always in this order:
-- onBountyTaskData (header + monsters + talismans), followed immediately by onBountyPreferredData
-- (preference list slots). The module expects everything at once in onBountyTasksDaily, so
-- we stash the first packet in a cache and only call the handler on the second one.
local pendingBountyData = nil

local BOUNTY_ENGINE_STARS = { [0] = 0, [1] = 1, [2] = 2 }

function onEngineBountyTaskData(header, monsters, talismans)
	local slots = {}

	for _, m in ipairs(monsters or {}) do
		slots[#slots + 1] = {
			taskId = m.taskIndex,
			raceId = m.raceId,
			monstersKilled = m.currentKills,
			totalKills = m.totalKills,
			experiencePoints = m.rewardXp,
			bountyPoints = m.rewardPoints,
			rerollPoints = m.rewardReroll,
			stars = BOUNTY_ENGINE_STARS[m.rarity] or 0,
			isActive = m.isActive == 1,
			isCompleted = m.isCompleted == 1
		}
	end

	local talismanData = {}

	for _, t in ipairs(talismans or {}) do
		talismanData[#talismanData + 1] = {
			talismaLevel = t.currentValue,
			upgradePrice = t.upgradeCost,
			-- the module expects a boolean, the engine gives 0/1
			canUpgrade = t.isActiveUpgrade == 1
		}
	end

	pendingBountyData = {
		slots = slots,
		talismanData = talismanData,
		-- the engine reports difficulty on a 1-4 scale, the module counts 0-3
		difficulty = math.max(0, (header and header.difficulty or 1) - 1),
		rerollTokens = header and header.rerollPoints or 0,
		-- engine: claimDaily == 1 means "can be claimed"; module: 0 means "unlocked"
		claimUnlocked = (header and header.claimDaily == 1) and 0 or 1
	}
end

function onEngineBountyPreferredData(preferredSlots, _, allRaceIds)
	local data = pendingBountyData or {
		slots = {},
		talismanData = {},
		difficulty = 0,
		rerollTokens = 0,
		claimUnlocked = 1
	}

	pendingBountyData = nil

	local preferredListData = {}

	for _, s in ipairs(preferredSlots or {}) do
		preferredListData[#preferredListData + 1] = {
			slot = s.slot,
			-- the engine sends locked (1 = locked), the module reads unlocked
			unlocked = s.locked == 0,
			preferred = s.preferred,
			unwanted = s.unwanted,
			price = s.price
		}
	end

	BountyTask.engineRaceIds = allRaceIds or {}

	onBountyTasksDaily(data.slots, data.rerollTokens, data.claimUnlocked, data.difficulty,
		data.talismanData, preferredListData)
end

function BountyTask:init()
	connect(g_game, {
		onBountyTasksDaily = onBountyTasksDaily,
		onBountyTaskData = onEngineBountyTaskData,
		onBountyPreferredData = onEngineBountyPreferredData,
		onGameStart = onGameStartBounty,
		onGameEnd = onGameEndBounty
	})
	scheduleEvent(refreshBountyKillTrackerFromCache, 0)
end

function BountyTask:terminate()
	disconnect(g_game, {
		onBountyTasksDaily = onBountyTasksDaily,
		onBountyTaskData = onEngineBountyTaskData,
		onBountyPreferredData = onEngineBountyPreferredData,
		onGameStart = onGameStartBounty,
		onGameEnd = onGameEndBounty
	})
end
