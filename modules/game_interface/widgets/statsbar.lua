-- chunkname: @/game_interface/widgets/statsbar.lua

local statsBarTop, statsBarBottom
local statsBars = {}
local statsBarDeepInfo = {}
local statsBarQuickInfoEvent, statsBarDeepInfoEvent
local statsBarQuickHealthPending = false
local statsBarQuickManaPending = false
local statsBarsPlacements = {
	"Top",
	"Bottom"
}
local statsBarsDimensions = {
	Large = {
		height = 35
	},
	Default = {
		height = 35
	},
	Parallel = {
		height = 35
	},
	Compact = {
		height = 20
	}
}
local lastProficiencyCache = {}
local proficiencyPerkHighlightActive = false
local firstCall = true
local currentStats = {
	placement = "hide",
	dimension = "hide"
}
local skillsLineHeight = 20

local function playerLevelPercentForStatsBar(player)
	local p = player:getLevelPercent()

	if g_game.getFeature(GameLevelPercentU16) then
		return math.floor(p / 100)
	end

	return p
end

local function playerSkillPercentForStatsBar(rawPercent)
	return math.floor((rawPercent or 0) / 100)
end

local SKILL_ICONS_SHEET = "/images/game/creatures/icons-skills"
local skillsTuples = {
	{
		key = "experience",
		name = "Level",
		order = 0,
		clip = "9 0 9 9",
		placement = "center"
	},
	{
		key = "magic",
		name = "Magic Level",
		order = 1,
		clip = "27 0 9 9",
		placement = "left"
	},
	{
		key = "axe",
		name = "Axe Fighting Skill",
		order = 1,
		clip = "54 0 9 9",
		placement = "right",
		skill = Skill.Axe
	},
	{
		key = "club",
		name = "Club Fighting Skill",
		order = 2,
		clip = "45 0 9 9",
		placement = "left",
		skill = Skill.Club
	},
	{
		key = "distance",
		name = "Distance Fighting Skill",
		order = 2,
		clip = "18 0 9 9",
		placement = "right",
		skill = Skill.Distance
	},
	{
		key = "fist",
		name = "Fist Fighting Skill",
		order = 3,
		clip = "0 0 9 9",
		placement = "left",
		skill = Skill.Fist
	},
	{
		key = "shielding",
		name = "Shielding Fighting Skill",
		order = 3,
		clip = "63 0 9 9",
		placement = "right",
		skill = Skill.Shielding
	},
	{
		key = "sword",
		name = "Sword Fighting Skill",
		order = 4,
		clip = "36 0 9 9",
		placement = "left",
		skill = Skill.Sword
	},
	{
		key = "fishing",
		name = "Fishing Fighting Skill",
		order = 4,
		clip = "72 0 9 9",
		placement = "right",
		skill = Skill.Fishing
	}
}
local SKILL_MENU_CHECKBOX_LABEL = {
	club = "Show Club Fighting Skill",
	shielding = "Show Shielding Skill",
	axe = "Show Axe Fighting Skill",
	fishing = "Show Fishing Skill",
	fist = "Show Fist Fighting Skill",
	magic = "Show Magic Level",
	distance = "Show Distance Fighting Skill",
	sword = "Show Sword Fighting Skill",
	experience = "Show Level"
}

StatsBar = {}

function getConfigurations()
	local configs = {}

	for _, statsBar in pairs(statsBars) do
		for _, placement in ipairs(statsBarsPlacements) do
			for dimension, _ in pairs(statsBarsDimensions) do
				local dimensionOnPlacement = tostring(dimension):lower() .. "On" .. placement
				local key = "statsBar" .. placement:gsub("^%l", string.upper)

				if statsBar[key] then
					table.insert(configs, statsBar[key][dimensionOnPlacement])
				end
			end
		end
	end

	return configs
end

local DEFAULT_SKILL_CENTER_GAP_LEFT = -4
local DEFAULT_SKILL_CENTER_GAP_RIGHT = -1
local COMPACT_SKILL_CENTER_GAP_LEFT = 3
local COMPACT_SKILL_CENTER_GAP_RIGHT = 2
local COMPACT_STATS_BAR_HEIGHT = 23
local PARALLEL_STATS_BAR_HEIGHT = 8
local LARGE_STATS_BAR_HEIGHT_TRIM = 10

local function statsBarTopSkillsParentBaseHeight(parent)
	if not parent then
		return 40
	end

	local id = parent:getId()

	if id == "defaultOnTop" then
		return 32
	elseif id == "defaultOnBottom" then
		return 35
	elseif id == "compactOnBottom" or id == "parallelOnBottom" or id == "largeOnBottom" then
		return 43
	end

	return 40
end

local function statsBarSkillsParentIsCompact(parent)
	if not parent then
		return false
	end

	local id = parent:getId()

	return id == "compactOnTop" or id == "compactOnBottom"
end

local function statsBarSkillsParentIsParallel(parent)
	if not parent then
		return false
	end

	local id = parent:getId()

	return id == "parallelOnTop" or id == "parallelOnBottom"
end

local function statsBarSkillsParentIsLarge(parent)
	if not parent then
		return false
	end

	local id = parent:getId()

	return id == "largeOnTop" or id == "largeOnBottom"
end

local function statsBarApplyCompactSkillRowLayout(widget)
	if not widget or widget:isDestroyed() then
		return
	end

	local level = widget.level or widget:getChildById("level")
	local icon = widget.icon or widget:getChildById("icon")
	local bar = widget.bar or widget:getChildById("bar")

	if not level or not icon or not bar then
		return
	end

	local barMarginRight = bar:getMarginRight()

	if not barMarginRight or barMarginRight < 0 then
		barMarginRight = 2
	end

	level:setVisible(false)
	level:setPhantom(true)
	icon:breakAnchors()
	icon:addAnchor(AnchorLeft, "parent", AnchorLeft)
	icon:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
	icon:setMarginLeft(2)
	icon:setMarginTop(0)
	bar:breakAnchors()
	bar:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
	bar:addAnchor(AnchorLeft, "icon", AnchorRight)
	bar:setMarginLeft(6)
	bar:addAnchor(AnchorRight, "statsbarXpBoostSlot", AnchorLeft)
	bar:setMarginRight(barMarginRight)
end

local function reloadSkillsTab(skills, parent)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local tuples = {}

	for i = 1, #skillsTuples do
		local skillTuple = skillsTuples[i]

		if skillTuple and g_settings.getBoolean("top_statsbar_" .. skillTuple.key) then
			table.insert(tuples, skillTuple)
		end
	end

	local statsBar = StatsBar.getCurrentStatsBar()

	if not statsBar then
		return
	end

	skills:setHeight(0)
	skills:destroyChildren()

	local lines = 0
	local lastPlacement = "left"

	for i = 1, #tuples do
		local skillTuple = tuples[i]
		local widget = g_ui.createWidget("TopStatsSkillElement", skills)

		widget:setId("statsbar_skill_" .. skillTuple.key)
		widget:addAnchor(AnchorTop, "parent", AnchorTop)

		if lastPlacement == "left" then
			widget:setMarginTop(lines * skillsLineHeight)
		else
			widget:setMarginTop((lines - 1) * skillsLineHeight)
		end

		widget.level = widget:getChildById("level")
		widget.icon = widget:getChildById("icon")
		widget.bar = widget:getChildById("bar")

		local xpSlot = widget:recursiveGetChildById("statsbarXpBoostSlot")
		local xpBtn = widget:recursiveGetChildById("statsbarXpBoostButton")

		if xpSlot and xpBtn then
			if skillTuple.key == "experience" and g_game.getFeature(GameExperienceBonus) then
				xpBtn:show()

				local bw = xpBtn:getWidth()

				xpSlot:setWidth(bw > 0 and bw or 76)
			else
				xpSlot:setWidth(0)
				xpBtn:hide()
			end
		end

		if skillTuple.key == "experience" then
			local mr = widget.bar:getMarginRight()

			widget.bar:setMarginRight((mr and mr > 0 and mr or 2) + 4)
		else
			local mr = widget.bar:getMarginRight()

			widget.bar:setMarginRight((mr and mr > 0 and mr or 2) - 1)
		end

		widget.icon:setImageSource(SKILL_ICONS_SHEET)
		widget.icon:setImageClip(skillTuple.clip)
		widget.icon:setTooltip(skillTuple.name)

		widget.bar.statsGrade = 4
		widget.bar.statsGradeColor = "#070707ff"

		widget.bar:reloadBorder()

		widget.bar.showText = false

		if skillTuple.key == "experience" then
			widget.bar.statsType = "experience"
		else
			widget.bar.statsType = "skill"
		end

		if skillTuple.placement == "center" or i == #tuples and lastPlacement == "left" then
			widget:addAnchor(AnchorLeft, "parent", AnchorLeft)
			widget:addAnchor(AnchorRight, "parent", AnchorRight)

			lines = lines + 1
		elseif lastPlacement == "left" then
			widget:addAnchor(AnchorLeft, "parent", AnchorLeft)
			widget:addAnchor(AnchorRight, "parent", AnchorHorizontalCenter)

			if statsBarSkillsParentIsCompact(parent) then
				widget:setMarginRight(COMPACT_SKILL_CENTER_GAP_LEFT)
			else
				widget:setMarginRight(DEFAULT_SKILL_CENTER_GAP_LEFT)
			end

			lines = lines + 1
			lastPlacement = "right"
		elseif lastPlacement == "right" then
			widget:addAnchor(AnchorRight, "parent", AnchorRight)
			widget:addAnchor(AnchorLeft, "parent", AnchorHorizontalCenter)

			if statsBarSkillsParentIsCompact(parent) then
				widget:setMarginLeft(COMPACT_SKILL_CENTER_GAP_RIGHT)
			else
				widget:setMarginLeft(DEFAULT_SKILL_CENTER_GAP_RIGHT)
			end

			lastPlacement = "left"
		end

		if skillTuple.key == "experience" then
			widget.level:setText(comma_value(player:getLevel()))
			widget.bar:setValue(playerLevelPercentForStatsBar(player), 100)
		elseif skillTuple.key == "magic" then
			widget.level:setText(player:getMagicLevel())
			widget.bar:setValue(playerSkillPercentForStatsBar(player:getMagicLevelPercent()), 100)
		else
			widget.level:setText(player:getSkillLevel(skillTuple.skill))
			widget.bar:setValue(playerSkillPercentForStatsBar(player:getSkillLevelPercent(skillTuple.skill)), 100)
		end

		if statsBarSkillsParentIsCompact(parent) then
			statsBarApplyCompactSkillRowLayout(widget)
		end
	end

	skills:updateLayout()
	skills:setHeight(lines * skillsLineHeight + 5)

	local base = statsBarTopSkillsParentBaseHeight(parent)
	local totalH = base + skills:getHeight() - 1

	if statsBarSkillsParentIsCompact(parent) then
		totalH = totalH - COMPACT_STATS_BAR_HEIGHT
	elseif statsBarSkillsParentIsParallel(parent) then
		totalH = totalH + PARALLEL_STATS_BAR_HEIGHT
	elseif statsBarSkillsParentIsLarge(parent) then
		totalH = totalH - LARGE_STATS_BAR_HEIGHT_TRIM
	end

	if totalH < 1 then
		totalH = 1
	end

	parent:setHeight(totalH)
	statsBar:setHeight(totalH)
end

function StatsBar.getAllStatsBarWithPosition()
	local statsBarsWithPosition = {}

	for _, statsBar in pairs(statsBars) do
		for _, placement in ipairs(statsBarsPlacements) do
			for dimension, _ in pairs(statsBarsDimensions) do
				local dimensionOnPlacement = tostring(dimension):lower() .. "On" .. placement

				if statsBar[dimensionOnPlacement] then
					statsBarsWithPosition[#statsBarsWithPosition + 1] = statsBar[dimensionOnPlacement]
				end
			end
		end
	end

	return statsBarsWithPosition
end

function StatsBar.getCurrentStatsBarWithPosition()
	if currentStats.dimension == "hide" or currentStats.placement == "hide" then
		return nil
	end

	local placement = currentStats.placement:gsub("^%l", string.upper)
	local fullPosition = currentStats.dimension .. "On" .. placement
	local statsBar = StatsBar.getCurrentStatsBar()

	if not statsBar then
		return nil
	end

	if statsBar[fullPosition] then
		return statsBar[fullPosition]
	else
		print("No stats bar with position found for:", statsBar)
	end

	return nil
end

function StatsBar.getCurrentStatsBar()
	if currentStats.dimension == "hide" or currentStats.placement == "hide" then
		return nil
	end

	local placement = currentStats.placement:gsub("^%l", string.upper)
	local statsBar = "statsBar" .. placement

	if statsBars[statsBar] then
		return statsBars[statsBar]
	else
		print("No stats bar found for:", statsBar)
	end

	return nil
end

local function statsBarApplyManaLineWidget(widget, lineMain)
	if not widget or not widget.recursiveGetChildById then
		return
	end

	local row = widget:recursiveGetChildById("textRow")
	local lbl = widget:recursiveGetChildById("statsbarManaValue")
	local icon = widget:recursiveGetChildById("statsbarManaShieldIcon")
	local fin = widget:recursiveGetChildById("statsbarManaEnd")

	if row then
		row:show()
		row:raise()
	end

	if lbl then
		lbl:setText(lineMain)
		lbl:show()
	end

	if icon then
		icon:show()
	end

	if fin then
		fin:setText(")")
		fin:show()
	end
end

local function statsBarHideManaLineWidget(widget)
	if not widget or not widget.recursiveGetChildById then
		return
	end

	local row = widget:recursiveGetChildById("textRow")

	if row then
		row:hide()
	end
end

local function statsBarApplyShieldRowNoParen(widget, lineNumeric)
	if not widget or not widget.recursiveGetChildById then
		return
	end

	local row = widget:recursiveGetChildById("textRow")
	local lbl = widget:recursiveGetChildById("statsbarManaValue")
	local icon = widget:recursiveGetChildById("statsbarManaShieldIcon")
	local fin = widget:recursiveGetChildById("statsbarManaEnd")

	if row then
		row:show()
		row:raise()
	end

	if lbl then
		lbl:setText(lineNumeric)
		lbl:show()
	end

	if icon then
		icon:show()
	end

	if fin then
		fin:hide()
	end
end

local function statsBarPlayerUsesManaShieldBar(player)
	return player and (player:isSorcerer() or player:isDruid())
end

local function statsBarPlayerHasMagicShieldState(player)
	if not player or not player.hasCondition then
		return false
	end

	return player:hasCondition(PlayerStates.ManaShield) or player:hasCondition(PlayerStates.NewManaShield)
end

local function statsBarResetManaBarFillMargins(manaBarWidget)
	local b = manaBarWidget and manaBarWidget:getChildById("bar")

	if b then
		b:setMargin(1)
	end
end

local function statsBarSetManaBarReserveShieldStrip(manaBarWidget, stripPx)
	local b = manaBarWidget and manaBarWidget:getChildById("bar")

	if not b then
		return
	end

	b:setMarginTop(1)
	b:setMarginLeft(1)
	b:setMarginRight(1)
	b:setMarginBottom(stripPx + 1)
end

local function statsBarLayoutIsLargeDual(bar)
	local id = bar and bar.getId and bar:getId() or ""

	return id == "largeOnTop" or id == "largeOnBottom"
end

local LARGE_DUAL_MANA_STRIP_H = 13
local LARGE_DUAL_MANA_SHIELD_GAP_TOP = 2
local LARGE_DUAL_MANASHIELD_STRIP_H = 13

local function statsBarApplyLargeDualLayoutMode(bar, mode)
	local stack = bar:getChildById("manaStack")

	if not stack then
		return
	end

	local manaW = stack:getChildById("mana")
	local msW = stack:getChildById("manashield")

	if not manaW then
		return
	end

	if mode == "mage" and msW then
		msW:show()
		manaW:breakAnchors()
		manaW:addAnchor(AnchorTop, "parent", AnchorTop)
		manaW:addAnchor(AnchorLeft, "parent", AnchorLeft)
		manaW:addAnchor(AnchorRight, "parent", AnchorRight)
		manaW:setHeight(LARGE_DUAL_MANA_STRIP_H)
		msW:breakAnchors()
		msW:addAnchor(AnchorTop, "mana", AnchorBottom)
		msW:setMarginTop(LARGE_DUAL_MANA_SHIELD_GAP_TOP)
		msW:setMarginBottom(0)
		msW:addAnchor(AnchorLeft, "parent", AnchorLeft)
		msW:addAnchor(AnchorRight, "parent", AnchorRight)
		msW:setHeight(LARGE_DUAL_MANASHIELD_STRIP_H)
	else
		if msW then
			msW:hide()
			msW:breakAnchors()
			msW:setMarginTop(0)
			msW:setMarginBottom(0)
		end

		manaW:breakAnchors()
		manaW:addAnchor(AnchorTop, "parent", AnchorTop)
		manaW:addAnchor(AnchorLeft, "parent", AnchorLeft)
		manaW:addAnchor(AnchorRight, "parent", AnchorRight)
		manaW:addAnchor(AnchorBottom, "parent", AnchorBottom)
	end
end

local function statsBarApplyManaQuickInfoToBar(bar, player, updateHealth, updateMana)
	if not bar or not player then
		return
	end

	local healthW = bar.health or bar:getChildById("health")

	if updateHealth and healthW then
		healthW:setValue(player:getHealth(), player:getMaxHealth())
	end

	if not updateMana then
		return
	end

	local manaW = bar.mana or bar:getChildById("mana")
	local msW = bar.manashield

	if not manaW then
		local stack = bar:getChildById("manaStack")

		if stack then
			manaW = stack:getChildById("mana")
		end
	end

	if manaW then
		local nestedMs = manaW:getChildById("manashield")

		if nestedMs then
			msW = nestedMs
		end
	end

	msW = msW or bar:getChildById("manashield")

	if not msW then
		local stack = bar:getChildById("manaStack")

		if stack then
			msW = stack:getChildById("manashield")
		end
	end

	if not manaW then
		return
	end

	if msW and manaW then
		if manaW.statsOrientation then
			msW.statsOrientation = manaW.statsOrientation
		end

		msW.statsType = "manashield"

		if not statsBarLayoutIsLargeDual(bar) and manaW.statsSize then
			msW.statsSize = manaW.statsSize
		end
	end

	local mana = player:getMana()
	local maxMana = player:getMaxMana()
	local manashield = player:getManaShield()
	local maxManaShield = player:getMaxManaShield()
	local isMage = statsBarPlayerUsesManaShieldBar(player)
	local utamoShieldBarActive = statsBarPlayerHasMagicShieldState(player)
	local useSplitManaShieldBars = isMage and msW and utamoShieldBarActive and not statsBarLayoutIsLargeDual(bar)

	if statsBarLayoutIsLargeDual(bar) then
		manaW.manaShieldText = nil

		if msW then
			msW.manaShieldText = nil
		end

		local desiredMode = isMage and msW and "mage" or "knight"

		if bar._largeDualLayoutMode ~= desiredMode then
			bar._largeDualLayoutMode = desiredMode

			statsBarApplyLargeDualLayoutMode(bar, desiredMode)
		end

		statsBarResetManaBarFillMargins(manaW)

		if desiredMode == "mage" and msW then
			manaW.manaDisplayLineMain = nil
			manaW.manaShieldText = nil
			manaW.showText = true

			manaW:setValue(mana, maxMana)

			msW.manaDisplayLineMain = nil
			msW.manaShieldText = nil
			msW.showText = true

			local shieldBarTotal = math.max(1, maxManaShield)
			local shieldBarValue = math.max(0, math.min(manashield, shieldBarTotal))

			msW:setValue(shieldBarValue, shieldBarTotal)

			local shieldLine = string.format("%d/%d", manashield, maxManaShield)

			statsBarApplyShieldRowNoParen(msW, shieldLine)

			local textRowMana = manaW:recursiveGetChildById("textRow")

			if textRowMana then
				textRowMana:raise()
			end

			local textRowMs = msW:recursiveGetChildById("textRow")

			if textRowMs then
				textRowMs:raise()
			end
		else
			if msW then
				msW.manaDisplayLineMain = nil
				msW.manaShieldText = nil
				msW.showText = false

				statsBarHideManaLineWidget(msW)
			end

			manaW.manaDisplayLineMain = nil
			manaW.showText = true

			manaW:setValue(mana, maxMana)
			statsBarHideManaLineWidget(manaW)
		end

		return
	end

	if not manaW.defaultHeight then
		manaW.defaultHeight = manaW:getHeight()
	end

	manaW.manaShieldText = nil

	if msW then
		msW.manaShieldText = nil
	end

	if useSplitManaShieldBars then
		local manaLineMain = string.format("%d/%d (%d/%d", mana, maxMana, manashield, maxManaShield)
		local stripH = 6

		if manaW.defaultHeight then
			manaW:setHeight(manaW.defaultHeight)
		end

		statsBarSetManaBarReserveShieldStrip(manaW, stripH)

		manaW.manaDisplayLineMain = manaLineMain
		manaW.showText = true

		manaW:setValue(mana, maxMana)

		if msW then
			msW:show()
			msW:setMarginTop(0)
			msW:setMarginBottom(1)
			msW:setMarginLeft(0)
			msW:setMarginRight(0)
			msW:setHeight(stripH)

			msW.manaDisplayLineMain = nil
			msW.showText = false

			local shieldBarTotal = math.max(1, maxManaShield)
			local shieldBarValue = math.max(0, math.min(manashield, shieldBarTotal))

			msW:setValue(shieldBarValue, shieldBarTotal)
		end

		statsBarApplyManaLineWidget(manaW, manaLineMain)

		local textRow = manaW:recursiveGetChildById("textRow")

		if textRow then
			textRow:raise()
		end
	elseif isMage then
		if msW then
			msW.manaDisplayLineMain = nil
			msW.showText = true

			msW:setMarginTop(0)
			msW:hide()

			local msRow = msW:recursiveGetChildById("textRow")

			if msRow then
				msRow:setMarginTop(0)
				msRow:setMarginBottom(0)
			end
		end

		statsBarResetManaBarFillMargins(manaW)

		local manaLineMain = string.format("%d/%d (%d/%d", mana, maxMana, manashield, maxManaShield)

		manaW.manaDisplayLineMain = manaLineMain
		manaW.showText = true

		if manaW.defaultHeight then
			manaW:setHeight(manaW.defaultHeight)
		end

		manaW:setValue(mana, maxMana)
		statsBarHideManaLineWidget(msW)
		statsBarApplyManaLineWidget(manaW, manaLineMain)
	else
		if msW then
			msW.manaDisplayLineMain = nil
			msW.showText = true

			msW:setMarginTop(0)
			msW:hide()

			local msRow = msW:recursiveGetChildById("textRow")

			if msRow then
				msRow:setMarginTop(0)
				msRow:setMarginBottom(0)
			end
		end

		statsBarResetManaBarFillMargins(manaW)

		manaW.manaDisplayLineMain = nil
		manaW.showText = true

		if manaW.defaultHeight then
			manaW:setHeight(manaW.defaultHeight)
		end

		manaW:setValue(mana, maxMana)
		statsBarHideManaLineWidget(msW)
	end
end

function StatsBar.reloadCurrentStatsBarQuickInfo(updateHealth, updateMana)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	if updateHealth == nil and updateMana == nil then
		updateHealth = true
		updateMana = true
	end

	local bar = StatsBar.getCurrentStatsBarWithPosition()

	if bar then
		statsBarApplyManaQuickInfoToBar(bar, player, updateHealth == true, updateMana == true)
	end
end

local function loadIcon(bitChanged, content, topmenu)
	local info = Icons[bitChanged]

	if not info then
		return nil
	end

	if modules.client_options and modules.client_options.isSpecialConditionId(info.id) and not modules.client_options.isConditionVisibleInBar(info.id) then
		return nil
	end

	local icon = g_ui.createWidget("ConditionWidget", content)

	icon:setId(info.id)
	applyPlayerStateIcon(icon, info)

	local tooltip = info.tooltip

	if tooltip == "You are GoshnarTaint" then
		tooltip = "Goshnar's Lairs Penalties:\n" .. "- 10% chance of creature teleportation to you\n" .. "- 0.5% chance of new creature spawn when hitting another\n" .. "- 15% increased damage received\n" .. "- 10% chance of creature full heal instead of dying\n" .. "- Lose 10% of current HP and mana every 10 seconds"
	end

	icon:setTooltip(tooltip)
	icon:setImageSize(tosize("9 9"))
	icon:setMarginRight(-1)

	if topmenu then
		icon:setMarginTop(5)
		icon:setMarginLeft(2)
		icon:setMarginRight(-2)
	end

	return icon
end

local function getStatsBarsIconContent()
	local iconContents = {}
	local statsBars = StatsBar.getAllStatsBarWithPosition()

	for _, statsBar in ipairs(statsBars) do
		local iconsPanel = statsBar:recursiveGetChildById("icons")

		if iconsPanel then
			iconContents[#iconContents + 1] = {
				loadIconTransparent = true,
				content = iconsPanel
			}
		end
	end

	iconContents[#iconContents + 1] = {
		loadIconTransparent = false,
		content = modules.game_inventory.getIconsPanelOn()
	}
	iconContents[#iconContents + 1] = {
		loadIconTransparent = false,
		content = modules.game_inventory.getIconsPanelOff()
	}

	return iconContents
end

local BATTLE_CONDITION_STATES = bit.bor(PlayerStates.Swords, PlayerStates.RedSwords)

local function refreshBattleConditionIcon(states)
	local desiredState

	if bit.band(states, PlayerStates.RedSwords) ~= 0 then
		desiredState = PlayerStates.RedSwords
	elseif bit.band(states, PlayerStates.Swords) ~= 0 then
		desiredState = PlayerStates.Swords
	end

	local swordsInfo = Icons[PlayerStates.Swords]
	local redSwordsInfo = Icons[PlayerStates.RedSwords]

	for _, contentData in ipairs(getStatsBarsIconContent()) do
		for _, info in ipairs({
			swordsInfo,
			redSwordsInfo
		}) do
			if info and info.id then
				local icon = contentData.content:getChildById(info.id)

				if icon then
					icon:destroy()
				end
			end
		end

		if desiredState then
			local icon = loadIcon(desiredState, contentData.content, contentData.loadIconTransparent)

			if icon then
				icon:setParent(contentData.content)
			end
		end
	end
end

local function toggleIcon(bitChanged)
	local contents = getStatsBarsIconContent()
	local iconId = Icons[bitChanged]

	if not iconId then
		g_logger.warning(string.format("No icon ID %s (%s)  found. Check Icons array in modules/gamelib/player.lua.", tostring(bitChanged), tostring(math.log(bitChanged) / math.log(2))))

		return
	end

	for _, contentData in ipairs(contents) do
		local icon = contentData.content:getChildById(iconId.id)

		if icon then
			icon:destroy()
		else
			icon = loadIcon(bitChanged, contentData.content, contentData.loadIconTransparent)

			if icon then
				icon:setParent(contentData.content)
			end
		end
	end
end

function StatsBar.refreshConditionIconsFromSettings()
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local states = player:getStates()
	local clientOptions = modules.client_options

	for _, contentData in ipairs(getStatsBarsIconContent()) do
		for _, cond in ipairs(SpecialConditions or {}) do
			if cond.id and cond.state then
				local icon = contentData.content:getChildById(cond.id)
				local active = bit.band(states, cond.state) ~= 0

				if cond.id == "condition_hungry" and isPlayerHungryConditionActive(player) then
					active = true
				end

				local visible = true

				if clientOptions and clientOptions.isSpecialConditionId(cond.id) and clientOptions.isConditionVisibleInBar then
					visible = clientOptions.isConditionVisibleInBar(cond.id)
				end

				if active and visible then
					if not icon then
						icon = loadIcon(cond.state, contentData.content, contentData.loadIconTransparent)

						if icon then
							icon:setParent(contentData.content)
						end
					end
				elseif icon then
					icon:destroy()
				end
			end
		end
	end

	refreshBattleConditionIcon(states)
end

local function refreshHungryConditionIcon()
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local info = Icons[PlayerStates.Hungry]

	if not info or not info.id then
		return
	end

	local active = isPlayerHungryConditionActive(player)
	local visible = true

	if modules.client_options and modules.client_options.isSpecialConditionId(info.id) and modules.client_options.isConditionVisibleInBar then
		visible = modules.client_options.isConditionVisibleInBar(info.id)
	end

	for _, contentData in ipairs(getStatsBarsIconContent()) do
		local icon = contentData.content:getChildById(info.id)

		if active and visible then
			if not icon then
				icon = loadIcon(PlayerStates.Hungry, contentData.content, contentData.loadIconTransparent)

				if icon then
					icon:setParent(contentData.content)
				end
			end
		elseif icon then
			icon:destroy()
		end
	end
end

function processIcon(id, action, createIfMissing)
	for _, contentData in ipairs(getStatsBarsIconContent()) do
		local icon = contentData.content:getChildById(id)

		if icon then
			action(icon)
		elseif createIfMissing then
			icon = loadIcon(id, contentData.content, contentData.loadIconTransparent)

			icon:setParent(contentData.content)
			action(icon)
		end
	end
end

function StatsBar.reloadCurrentStatsBarQuickInfo_state(localPlayer, now, old)
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	if now == old then
		return
	end

	local bitsChanged = bit.bxor(now, old)
	local battleConditionChanged = bit.band(bitsChanged, BATTLE_CONDITION_STATES) ~= 0

	for i = 1, 32 do
		local pow = math.pow(2, i - 1)

		if bitsChanged < pow then
			break
		end

		local bitChanged = bit.band(bitsChanged, pow)

		if bitChanged ~= 0 then
			if bitChanged == PlayerStates.Hungry then
				refreshHungryConditionIcon()
			elseif bit.band(bitChanged, BATTLE_CONDITION_STATES) == 0 then
				toggleIcon(bitChanged)
			end
		end
	end

	if battleConditionChanged then
		refreshBattleConditionIcon(now)
	end

	local shieldStateBits = bit.bor(PlayerStates.ManaShield, PlayerStates.NewManaShield)

	if bit.band(bitsChanged, shieldStateBits) ~= 0 then
		StatsBar.scheduleCurrentStatsBarManaInfo()
	end
end

function StatsBar.reloadCurrentStatsBarDeepInfo()
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local bar = StatsBar.getCurrentStatsBarWithPosition()

	if not bar then
		return
	end

	for _, skillTuple in ipairs(skillsTuples) do
		local widget = bar:recursiveGetChildById("statsbar_skill_" .. skillTuple.key)

		if widget then
			if skillTuple.key == "experience" then
				widget.level:setText(comma_value(player:getLevel()))
				widget.bar:setValue(playerLevelPercentForStatsBar(player), 100)
			elseif skillTuple.key == "magic" then
				widget.level:setText(player:getMagicLevel())
				widget.bar:setValue(playerSkillPercentForStatsBar(player:getMagicLevelPercent()), 100)
			else
				widget.level:setText(player:getSkillLevel(skillTuple.skill))
				widget.bar:setValue(playerSkillPercentForStatsBar(player:getSkillLevelPercent(skillTuple.skill)), 100)
			end
		end
	end
end

function StatsBar.cancelPendingRefreshes()
	if statsBarQuickInfoEvent then
		removeEvent(statsBarQuickInfoEvent)

		statsBarQuickInfoEvent = nil
	end

	if statsBarDeepInfoEvent then
		removeEvent(statsBarDeepInfoEvent)

		statsBarDeepInfoEvent = nil
	end

	statsBarQuickHealthPending = false
	statsBarQuickManaPending = false
end

local function scheduleCurrentStatsBarQuickInfo(updateHealth, updateMana)
	statsBarQuickHealthPending = statsBarQuickHealthPending or updateHealth == true
	statsBarQuickManaPending = statsBarQuickManaPending or updateMana == true

	if statsBarQuickInfoEvent then
		return
	end

	statsBarQuickInfoEvent = addEvent(function()
		statsBarQuickInfoEvent = nil

		local refreshHealth = statsBarQuickHealthPending
		local refreshMana = statsBarQuickManaPending

		statsBarQuickHealthPending = false
		statsBarQuickManaPending = false

		StatsBar.reloadCurrentStatsBarQuickInfo(refreshHealth, refreshMana)
	end)
end

function StatsBar.scheduleCurrentStatsBarHealthInfo()
	scheduleCurrentStatsBarQuickInfo(true, false)
end

function StatsBar.scheduleCurrentStatsBarManaInfo()
	scheduleCurrentStatsBarQuickInfo(false, true)
end

function StatsBar.scheduleCurrentStatsBarDeepInfo()
	if statsBarDeepInfoEvent then
		return
	end

	statsBarDeepInfoEvent = addEvent(function()
		statsBarDeepInfoEvent = nil

		StatsBar.reloadCurrentStatsBarDeepInfo()
	end)
end

local function normalizePlacement(placement)
	placement = string.lower(tostring(placement or "top"))

	if placement ~= "bottom" then
		return "top"
	end

	return placement
end

local function saveStatsBarConfigNow(dimensionString, placement)
	placement = normalizePlacement(placement)
	currentStats = {
		dimension = dimensionString,
		placement = placement
	}

	g_settings.set("statsbar_dimension", dimensionString)
	g_settings.set("statsbar_placement", placement)
	g_settings.save()
end

function constructStatsBar(dimension, placement)
	local dimensionString = dimension:gsub("^%u", string.lower)

	placement = normalizePlacement(placement)

	saveStatsBarConfigNow(dimensionString, placement)

	local dimensionOnPlacement = dimensionString .. "On" .. placement:gsub("^%l", string.upper)
	local statsBar = statsBars["statsBar" .. placement:gsub("^%l", string.upper)]

	if not statsBar then
		return
	end

	local variant = statsBar[dimensionOnPlacement]

	if not variant then
		variant = statsBar:getChildById(dimensionOnPlacement)

		if variant then
			statsBar[dimensionOnPlacement] = variant
		end
	end

	if variant then
		statsBar:setHeight(statsBarsDimensions[dimension].height)
		variant:setHeight(statsBarsDimensions[dimension].height)
		variant:show()
		variant:setPhantom(false)

		variant.health = variant:getChildById("health")

		local root = variant
		local manaRef = root:getChildById("mana")
		local msRef = root:getChildById("manashield")

		if not manaRef or not msRef then
			local stack = root:getChildById("manaStack")

			if stack then
				manaRef = manaRef or stack:getChildById("mana")
				msRef = msRef or stack:getChildById("manashield")
			end
		end

		if not msRef and manaRef then
			msRef = manaRef:getChildById("manashield")
		end

		root.mana = manaRef
		root.manashield = msRef
		root._largeDualLayoutMode = nil
		variant.skills = variant:getChildById("skills")
		statsBar[dimensionOnPlacement] = variant

		reloadSkillsTab(variant.skills, variant)
		StatsBar.reloadCurrentStatsBarQuickInfo()

		if modules.game_interface and modules.game_interface.refreshStatsBarDockLayout then
			modules.game_interface.refreshStatsBarDockLayout()
		end

		modules.game_healthcircle.setStatsBarOption(dimensionString, placement)

		if string.lower(dimension) == "default" or string.lower(dimension) == "parallel" then
			StatsBar.applyDefaultTopProficiencyLayout()
		elseif string.lower(dimension) == "compact" then
			StatsBar.applyCompactTopProficiencyWeaponButton()
		end

		if string.lower(dimension) == "default" or string.lower(dimension) == "compact" or string.lower(dimension) == "parallel" or string.lower(dimension) == "large" then
			StatsBar.applyDefaultTopMonkComboSereneLayout()
		end

		StatsBar.switchCurrentLayout()
	else
		print("No stats bar found for:", dimensionOnPlacement .. " on constructStatsBar()")
	end
end

function StatsBar.updateCurrentStats(dimension, placement)
	currentStats = {
		dimension = dimension,
		placement = placement
	}
end

local function openDropMenu(mousePos)
	local menu = g_ui.createWidget("PopupMenu")

	menu:setGameMenu(true)

	local function currentStyleForConstruct()
		local d = currentStats.dimension

		if not d or d == "" or d == "hide" then
			d = g_settings.getString("statsbar_dimension")
		end

		if not d or d == "" or d == "hide" then
			return "Compact"
		end

		return d:sub(1, 1):upper() .. d:sub(2)
	end

	local function currentPlacementDefault()
		local p = currentStats.placement

		if not p or p == "" or p == "hide" then
			p = g_settings.getString("statsbar_placement")
		end

		return normalizePlacement(p)
	end

	local function placementMenuToPlacementDock(menuId)
		if menuId == "top" then
			g_settings.set("statsbar_dock", "full")

			return "top"
		elseif menuId == "left" then
			g_settings.set("statsbar_dock", "left")

			return "top"
		elseif menuId == "right" then
			g_settings.set("statsbar_dock", "right")

			return "top"
		elseif menuId == "bottom" then
			g_settings.set("statsbar_dock", "full")

			return "bottom"
		end

		return "top"
	end

	local placementRows = {
		{
			menuId = "top",
			label = tr("Switch to Top Position")
		},
		{
			menuId = "left",
			label = tr("Switch to Left Position")
		},
		{
			menuId = "right",
			label = tr("Switch to Right Position")
		},
		{
			menuId = "bottom",
			label = tr("Switch to Bottom Position")
		}
	}
	local barPlacement = currentStats.placement

	if not barPlacement or barPlacement == "" then
		barPlacement = g_settings.getString("statsbar_placement")
	end

	if barPlacement == "" or barPlacement == "hide" then
		barPlacement = "top"
	end

	for _, row in ipairs(placementRows) do
		local skipOption = barPlacement == "top" and row.menuId == "top" or barPlacement == "bottom" and row.menuId == "bottom"

		if not skipOption then
			menu:addOption(row.label, function()
				local plac = placementMenuToPlacementDock(row.menuId)

				StatsBar.hideAll()
				constructStatsBar(currentStyleForConstruct(), plac)
			end)
		end
	end

	menu:addSeparator()

	local barStyle = currentStats.dimension

	if not barStyle or barStyle == "" then
		barStyle = g_settings.getString("statsbar_dimension")
	end

	if barStyle == "" or barStyle == "hide" then
		barStyle = "compact"
	end

	barStyle = barStyle:lower()

	local styleRows = {
		{
			styleId = "default",
			dim = "Default",
			label = tr("Switch to Default Style")
		},
		{
			styleId = "compact",
			dim = "Compact",
			label = tr("Switch to Compact Style")
		},
		{
			styleId = "large",
			dim = "Large",
			label = tr("Switch to Large Style")
		},
		{
			styleId = "parallel",
			dim = "Parallel",
			label = tr("Switch to Parallel Style")
		}
	}

	for _, row in ipairs(styleRows) do
		if barStyle ~= row.styleId then
			menu:addOption(row.label, function()
				StatsBar.hideAll()
				constructStatsBar(row.dim, currentPlacementDefault())
			end)
		end
	end

	menu:addSeparator()

	for _, skillTuple in ipairs(skillsTuples) do
		local key = skillTuple.key
		local checked = g_settings.getBoolean("top_statsbar_" .. key)
		local label = tr(SKILL_MENU_CHECKBOX_LABEL[key] or "Show " .. skillTuple.name)

		menu:addCheckBox(label, checked, function(_, newChecked)
			g_settings.set("top_statsbar_" .. key, newChecked)

			local cur = StatsBar.getCurrentStatsBarWithPosition()

			if cur and cur.skills then
				reloadSkillsTab(cur.skills, cur)

				if modules.game_interface and modules.game_interface.refreshStatsBarDockLayout then
					modules.game_interface.refreshStatsBarDockLayout()
				end
			end
		end)
	end

	menu:addSeparator()

	if modules.client_options and modules.client_options.getOption and modules.client_options.setOption then
		local customOn = modules.client_options.getOption("showCustomisableStatusBars")

		menu:addCheckBox(tr("Show Customisable Status Bars"), customOn, function(_, checked)
			modules.client_options.setOption("showCustomisableStatusBars", checked, true)
		end)

		local statusOn = modules.client_options.getOption("showStatusBars")

		menu:addCheckBox(tr("Show Status Bars"), statusOn, function(_, checked)
			modules.client_options.setOption("showStatusBars", checked, true)
		end)
	end

	menu:setWidth(271)
	menu:display(mousePos)
end

local function onStatsMousePress(tab, mousePos, mouseButton)
	if mouseButton == MouseRightButton then
		openDropMenu(mousePos)

		return true
	end
end

function StatsBar.reloadCurrentTab()
	if currentStats.dimension == "hide" then
		return
	end

	local dimension = currentStats.dimension:gsub("^%l", string.upper)

	if statsBarsDimensions[dimension] then
		return constructStatsBar(dimension, currentStats.placement)
	else
		print("No stats bars dimensions found: ", dimension, " on reloadCurrentTab()")

		return
	end
end

function StatsBar.updateStatsBarOption(dimension)
	StatsBar.hideAll()
	StatsBar.firstLoadSettings()

	if currentStats.dimension ~= "hide" and dimension ~= "hide" then
		StatsBar.reloadCurrentTab()
	end
end

local function getSettingOrDefault(setting, default)
	local value = g_settings.getString(setting)

	return value ~= "" and value or default
end

local function setSetting(setting, value)
	g_settings.set(setting, value)
end

function StatsBar.loadSettings()
	currentStats = {
		dimension = getSettingOrDefault("statsbar_dimension", "compact"),
		placement = normalizePlacement(getSettingOrDefault("statsbar_placement", "top"))
	}
end

function StatsBar.firstLoadSettings()
	if firstCall then
		StatsBar.loadSettings()

		firstCall = false
	end
end

local statsBarInventoryPlayerRef, lastProficiencyPanelVisible, leftHandHasWeaponProficiency

local function onStatsBarInventoryChange()
	local showPanel = leftHandHasWeaponProficiency()

	StatsBar.applyDefaultTopProficiencyLayout()
	StatsBar.syncProficiencyHighlightWithHandWeapon()

	if lastProficiencyPanelVisible ~= showPanel then
		lastProficiencyPanelVisible = showPanel

		if g_settings.getString("statsbar_placement") == "bottom" and modules.game_interface and modules.game_interface.applyBottomSplitterLayoutHeight then
			modules.game_interface.applyBottomSplitterLayoutHeight()
		end
	end
end

local statsBarInventoryHandlers = {
	onInventoryChange = function()
		addEvent(onStatsBarInventoryChange)
	end
}

local function statsBarDisconnectInventoryPlayer()
	if statsBarInventoryPlayerRef then
		pcall(function()
			disconnect(statsBarInventoryPlayerRef, statsBarInventoryHandlers)
		end)

		statsBarInventoryPlayerRef = nil
	end
end

local function statsBarConnectInventoryPlayer()
	statsBarDisconnectInventoryPlayer()

	local p = g_game.getLocalPlayer()

	if p and type(p) == "userdata" then
		statsBarInventoryPlayerRef = p

		connect(statsBarInventoryPlayerRef, statsBarInventoryHandlers)
	end
end

function StatsBar.OnGameEnd()
	StatsBar.cancelPendingRefreshes()
	statsBarDisconnectInventoryPlayer()

	lastProficiencyCache = {}
	lastProficiencyPanelVisible = nil

	StatsBar.clearProficiencyHighlightUi()
	StatsBar.hideAll()
	modules.game_inventory.getIconsPanelOn():destroyChildren()
	modules.game_inventory.getIconsPanelOff():destroyChildren()
	StatsBar.destroyAllIcons()
end

function StatsBar.OnGameStart()
	lastProficiencyCache = {}

	StatsBar.clearProficiencyHighlightUi()
	statsBarConnectInventoryPlayer()
	StatsBar.loadSettings()
	StatsBar.reloadCurrentTab()
	StatsBar.applyDefaultTopProficiencyLayout()
	StatsBar.applyDefaultTopMonkComboSereneLayout()
	modules.game_healthcircle.setStatsBarOption()
	refreshHungryConditionIcon()

	if modules.game_interface and modules.game_interface.refreshStatsBarDockLayout then
		modules.game_interface.refreshStatsBarDockLayout()
	end
end

function createStatsBarWidgets(statsBar)
	local widget = statsBar

	for _, placement in ipairs(statsBarsPlacements) do
		for dimension, _ in pairs(statsBarsDimensions) do
			local elementName = tostring(dimension):gsub("^%u", string.lower) .. "On" .. placement

			widget[elementName] = statsBar:getChildById(elementName)
		end
	end

	widget.onMousePress = onStatsMousePress

	return widget
end

local statsBarThingsHandlers = {
	onLoadDat = function()
		StatsBar.applyDefaultTopProficiencyLayout()
	end
}

local function proficiencyTableHasEntries(PD)
	return PD and PD.content and next(PD.content) ~= nil
end

function leftHandHasWeaponProficiency()
	local player = g_game.getLocalPlayer()

	if not player or not g_game.isOnline() then
		return false
	end

	local item

	if modules.game_inventory and modules.game_inventory.getWeaponProficiencyHandItem then
		item = modules.game_inventory.getWeaponProficiencyHandItem()
	end

	item = item or player:getInventoryItem(InventorySlotLeft)

	if not item then
		return false
	end

	local ok, pid = pcall(function()
		return item:getProficiencyId()
	end)

	if not ok or not pid or pid == 0 then
		return false
	end

	local PD = ProficiencyData

	if not PD and modules.game_proficiency then
		PD = modules.game_proficiency.ProficiencyData
	end

	if PD and PD.isValidProfiencyId and proficiencyTableHasEntries(PD) then
		return PD:isValidProfiencyId(pid)
	end

	return true
end

local PROFICIENCY_BUTTON_COMPACT_UNEQUIPPED = "/images/game/topbar/proficiency-button-compact-unequipped"
local PROFICIENCY_BUTTON_COMPACT_EQUIPPED = "/images/game/topbar/proficiency-button-compact-equipped"
local PROFICIENCY_BUTTON_LARGE_UNEQUIPPED = "/images/game/topbar/proficiency-button-large-unequipped"
local PROFICIENCY_BUTTON_LARGE_EQUIPPED = "/images/game/topbar/proficiency-button-large-equipped"

local function buildRectPerimeterBorderPoints(W, H)
	local pts = {}

	for x = 1, W - 1 do
		pts[#pts + 1] = {
			x,
			0
		}
	end

	for y = 1, H - 1 do
		pts[#pts + 1] = {
			W - 1,
			y
		}
	end

	for x = W - 2, 0, -1 do
		pts[#pts + 1] = {
			x,
			H - 1
		}
	end

	for y = H - 2, 0, -1 do
		pts[#pts + 1] = {
			0,
			y
		}
	end

	return pts
end

local function proficiencyLargePerimeterCompanion(x, y, W, H)
	if y == 0 then
		return x, 1
	end

	if x == W - 1 then
		return W - 2, y
	end

	if y == H - 1 then
		return x, H - 2
	end

	if x == 0 then
		return 1, y
	end

	return x, y
end

local LARGE_PROF_RING_OFF_X = 2
local LARGE_PROF_RING_OFF_Y = 1
local LARGE_PROF_RING_INNER_W = 23
local LARGE_PROF_RING_INNER_H = 25

local function buildLargeProficiencyBorderPointsFlat()
	local baseLocal = buildRectPerimeterBorderPoints(LARGE_PROF_RING_INNER_W, LARGE_PROF_RING_INNER_H)
	local ox, oy = LARGE_PROF_RING_OFF_X, LARGE_PROF_RING_OFF_Y
	local flat = {}

	for _, pt in ipairs(baseLocal) do
		local cx, cy = proficiencyLargePerimeterCompanion(pt[1], pt[2], LARGE_PROF_RING_INNER_W, LARGE_PROF_RING_INNER_H)

		flat[#flat + 1] = {
			pt[1] + ox,
			pt[2] + oy
		}
		flat[#flat + 1] = {
			cx + ox,
			cy + oy
		}
	end

	return flat
end

local LARGE_BORDER_POINTS_FLAT = buildLargeProficiencyBorderPointsFlat()
local LARGE_BORDER_PIXEL_COUNT = #LARGE_BORDER_POINTS_FLAT
local LARGE_BORDER_STEP_COUNT = LARGE_BORDER_PIXEL_COUNT / 2

assert(LARGE_BORDER_PIXEL_COUNT == 184, "large proficiency border must be 92 steps x 2 pixels")
assert(LARGE_BORDER_STEP_COUNT == 92, "large proficiency perimeter must be 92 steps")

local BORDER_POINTS = {
	{
		1,
		0
	},
	{
		2,
		0
	},
	{
		3,
		0
	},
	{
		4,
		0
	},
	{
		5,
		0
	},
	{
		6,
		0
	},
	{
		7,
		0
	},
	{
		8,
		0
	},
	{
		9,
		0
	},
	{
		10,
		0
	},
	{
		11,
		0
	},
	{
		12,
		0
	},
	{
		13,
		0
	},
	{
		14,
		0
	},
	{
		14,
		1
	},
	{
		14,
		2
	},
	{
		14,
		3
	},
	{
		14,
		4
	},
	{
		14,
		5
	},
	{
		14,
		6
	},
	{
		14,
		7
	},
	{
		14,
		8
	},
	{
		14,
		9
	},
	{
		14,
		10
	},
	{
		14,
		11
	},
	{
		14,
		12
	},
	{
		14,
		13
	},
	{
		13,
		13
	},
	{
		12,
		13
	},
	{
		11,
		13
	},
	{
		10,
		13
	},
	{
		9,
		13
	},
	{
		8,
		13
	},
	{
		7,
		13
	},
	{
		6,
		13
	},
	{
		5,
		13
	},
	{
		4,
		13
	},
	{
		3,
		13
	},
	{
		2,
		13
	},
	{
		1,
		13
	},
	{
		0,
		13
	},
	{
		0,
		12
	},
	{
		0,
		11
	},
	{
		0,
		10
	},
	{
		0,
		9
	},
	{
		0,
		8
	},
	{
		0,
		7
	},
	{
		0,
		6
	},
	{
		0,
		5
	},
	{
		0,
		4
	},
	{
		0,
		3
	},
	{
		0,
		2
	},
	{
		0,
		1
	},
	{
		0,
		0
	}
}
local BORDER_SIZE = #BORDER_POINTS

assert(BORDER_SIZE == 54, "compact proficiency border must trace exactly 54 pixels")

local COMPACT_BORDER_PROGRESS_COLOR = "#00b9b1"

local function getProficiencyProgressRingSpec(panel)
	if not panel or panel:isDestroyed() then
		return nil, nil
	end

	local pid = panel:getId()

	if pid == "proficiencyButtonCompactProgress" then
		return BORDER_POINTS, BORDER_SIZE
	elseif pid == "proficiencyButtonLargeProgress" then
		return LARGE_BORDER_POINTS_FLAT, LARGE_BORDER_PIXEL_COUNT
	end

	return nil, nil
end

local function ensureBorderPixels(panel)
	if not panel or panel:isDestroyed() then
		return
	end

	local borderPoints, expectedSize = getProficiencyProgressRingSpec(panel)

	if not borderPoints or not expectedSize then
		return
	end

	local existing = panel.borderPixels

	if existing and #existing == expectedSize then
		local intact = true

		for i = 1, expectedSize do
			local w = existing[i]

			if not w or w:isDestroyed() then
				intact = false

				break
			end
		end

		if intact then
			return
		end
	end

	if existing then
		for _, w in ipairs(existing) do
			if w and not w:isDestroyed() then
				w:destroy()
			end
		end
	end

	panel.borderPixels = {}

	for i, pos in ipairs(borderPoints) do
		local pixel = g_ui.createWidget("UIWidget", panel)

		pixel:setPhantom(true)
		pixel:setFocusable(false)
		pixel:setSize({
			height = 1,
			width = 1
		})
		pixel:breakAnchors()
		pixel:addAnchor(AnchorLeft, "parent", AnchorLeft)
		pixel:addAnchor(AnchorTop, "parent", AnchorTop)
		pixel:setMarginLeft(pos[1])
		pixel:setMarginTop(pos[2])
		pixel:setBackgroundColor(COMPACT_BORDER_PROGRESS_COLOR)
		pixel:setVisible(false)

		panel.borderPixels[i] = pixel
	end

	panel:updateLayout()
end

local function updateCompactBorderProgress(panel, percent)
	if not panel or panel:isDestroyed() then
		return
	end

	local _, borderSize = getProficiencyProgressRingSpec(panel)

	if not borderSize then
		return
	end

	ensureBorderPixels(panel)

	local pixels = panel.borderPixels

	if not pixels then
		return
	end

	local p = math.max(0, math.min(100, tonumber(percent) or 0))
	local pid = panel:getId()

	if pid == "proficiencyButtonLargeProgress" then
		local steps = LARGE_BORDER_STEP_COUNT
		local visibleSteps = math.floor(steps * p / 100)

		if visibleSteps < 0 then
			visibleSteps = 0
		elseif steps < visibleSteps then
			visibleSteps = steps
		end

		for i = 1, borderSize do
			local step = math.ceil(i / 2)

			pixels[i]:setVisible(step <= visibleSteps)
		end
	else
		local visiblePixels = math.floor(borderSize * p / 100)

		if visiblePixels < 0 then
			visiblePixels = 0
		elseif borderSize < visiblePixels then
			visiblePixels = borderSize
		end

		for i = 1, borderSize do
			pixels[i]:setVisible(i <= visiblePixels)
		end
	end
end

local PROFICIENCY_DEFAULT_PARALLEL_LAYOUT_IDS = {
	"defaultOnTop",
	"parallelOnTop",
	"defaultOnBottom",
	"parallelOnBottom"
}
local PROFICIENCY_COMPACT_LAYOUT_IDS = {
	"compactOnTop",
	"compactOnBottom"
}
local PROFICIENCY_LARGE_LAYOUT_IDS = {
	"largeOnTop",
	"largeOnBottom"
}
local PROFICIENCY_STATS_LAYOUT_IDS = PROFICIENCY_DEFAULT_PARALLEL_LAYOUT_IDS

local function applyCompactProficiencyWeaponButtonToRoot(root, equipped, srcCompact, srcLarge, pct)
	if not root then
		return
	end

	local btn = root:recursiveGetChildById("proficiencyButtonCompact")

	if btn and btn.setImageSource then
		btn:setImageSource(srcCompact)
	end

	local ring = root:recursiveGetChildById("proficiencyButtonCompactProgress")

	if ring then
		ring:setVisible(equipped)
		updateCompactBorderProgress(ring, equipped and pct or 0)
	end

	local btnL = root:recursiveGetChildById("proficiencyButtonLarge")

	if btnL and btnL.setImageSource then
		btnL:setImageSource(srcLarge)
	end

	local ringL = root:recursiveGetChildById("proficiencyButtonLargeProgress")

	if ringL then
		ringL:setVisible(equipped)
		updateCompactBorderProgress(ringL, equipped and pct or 0)
	end
end

local function applyProficiencyTopBarWidgetsAllLayouts(percent, progressTooltip, showHighlight)
	for _, bar in pairs(statsBars) do
		if bar then
			for _, layoutId in ipairs(PROFICIENCY_STATS_LAYOUT_IDS) do
				local root = bar:getChildById(layoutId)

				if root then
					local pb = root:recursiveGetChildById("starProgress")

					if pb then
						pb:setPercent(percent)
						pb:setTooltip(progressTooltip)
					end

					local lbl = root:recursiveGetChildById("proficiencyLabel")

					if lbl then
						lbl:setText(percent .. "%")
					end

					local icon = root:recursiveGetChildById("proficiencyIcon")

					if icon then
						icon:setOn(showHighlight)
					end
				end
			end
		end
	end
end

function StatsBar.applyCompactTopProficiencyWeaponButton()
	local equipped = leftHandHasWeaponProficiency()
	local srcCompact = equipped and PROFICIENCY_BUTTON_COMPACT_EQUIPPED or PROFICIENCY_BUTTON_COMPACT_UNEQUIPPED
	local srcLarge = equipped and PROFICIENCY_BUTTON_LARGE_EQUIPPED or PROFICIENCY_BUTTON_LARGE_UNEQUIPPED
	local pct = lastProficiencyCache and lastProficiencyCache.topBarPercent or 0

	for _, bar in pairs(statsBars) do
		if bar then
			for _, layoutId in ipairs(PROFICIENCY_COMPACT_LAYOUT_IDS) do
				applyCompactProficiencyWeaponButtonToRoot(bar:getChildById(layoutId), equipped, srcCompact, srcLarge, pct)
			end

			for _, layoutId in ipairs(PROFICIENCY_LARGE_LAYOUT_IDS) do
				applyCompactProficiencyWeaponButtonToRoot(bar:getChildById(layoutId), equipped, srcCompact, srcLarge, pct)
			end
		end
	end
end

local function proficiencyServerHighlightOn(flag)
	return flag == true or flag == 1
end

local function applyProficiencyPerkHighlightVisibleToWidgets()
	for _, bar in pairs(statsBars) do
		if bar then
			for _, layoutId in ipairs(PROFICIENCY_DEFAULT_PARALLEL_LAYOUT_IDS) do
				local layoutRoot = bar:getChildById(layoutId)

				if layoutRoot then
					local highlightButton = layoutRoot:recursiveGetChildById("highlightProficiencyButton")

					if highlightButton then
						highlightButton:setVisible(proficiencyPerkHighlightActive)
					end
				end
			end

			for _, layoutId in ipairs(PROFICIENCY_COMPACT_LAYOUT_IDS) do
				local layoutRoot = bar:getChildById(layoutId)

				if layoutRoot then
					local highlightCompact = layoutRoot:recursiveGetChildById("highlightProficiencyButtonCompact")

					if highlightCompact then
						highlightCompact:setVisible(proficiencyPerkHighlightActive)
					end
				end
			end

			for _, layoutId in ipairs(PROFICIENCY_LARGE_LAYOUT_IDS) do
				local layoutRoot = bar:getChildById(layoutId)

				if layoutRoot then
					local highlightLarge = layoutRoot:recursiveGetChildById("highlightProficiencyButtonLarge")

					if highlightLarge then
						highlightLarge:setVisible(proficiencyPerkHighlightActive)
					end
				end
			end
		end
	end

	if modules.game_mainpanel and modules.game_mainpanel.getButton then
		local shortcutBtn = modules.game_mainpanel.getButton("ProciencyButton")

		if shortcutBtn and not shortcutBtn:isDestroyed() then
			local sh = shortcutBtn:recursiveGetChildById("proficiencyShortcutHighlight")

			if sh then
				sh:setVisible(proficiencyPerkHighlightActive)
			end
		end
	end
end

local function setProficiencyPerkHighlightVisible(show)
	proficiencyPerkHighlightActive = proficiencyServerHighlightOn(show)

	applyProficiencyPerkHighlightVisibleToWidgets()
end

function StatsBar.resyncProficiencyPerkHighlightWidgets()
	applyProficiencyPerkHighlightVisibleToWidgets()
end

function StatsBar.isProficiencyPerkHighlightVisible()
	return proficiencyPerkHighlightActive
end

function StatsBar.clearProficiencyHighlightUi()
	setProficiencyPerkHighlightVisible(false)

	for _, bar in pairs(statsBars) do
		if bar then
			for _, layoutId in ipairs(PROFICIENCY_DEFAULT_PARALLEL_LAYOUT_IDS) do
				local layoutRoot = bar:getChildById(layoutId)

				if layoutRoot then
					local proficiencyIcon = layoutRoot:recursiveGetChildById("proficiencyIcon")

					if proficiencyIcon then
						proficiencyIcon:setOn(false)
					end
				end
			end
		end
	end
end

function StatsBar.syncProficiencyHighlightWithHandWeapon()
	if not modules.game_inventory or not modules.game_inventory.getWeaponProficiencyHandItem then
		return
	end

	local hand = modules.game_inventory.getWeaponProficiencyHandItem()

	if not hand then
		StatsBar.clearProficiencyHighlightUi()

		return
	end

	local hid = hand:getId()

	if lastProficiencyCache.itemClientId and lastProficiencyCache.itemClientId ~= hid then
		StatsBar.clearProficiencyHighlightUi()

		lastProficiencyCache = {}
	end

	if WeaponProficiency and WeaponProficiency.cacheList and WeaponProficiency.cacheList[hid] then
		local thingType = hand:getThingType()
		if thingType then
			local unused = WeaponProficiency:hasUnusedPerk(hid, thingType)
			if unused ~= proficiencyPerkHighlightActive then
				StatsBar.onUpdateProficiencyData(WeaponProficiency.cacheList[hid], unused, thingType)
			end
		end
	end
end

function StatsBar.applyDefaultTopProficiencyLayout()
	local showPanel = leftHandHasWeaponProficiency()

	for _, bar in pairs(statsBars) do
		if bar then
			for _, layoutId in ipairs(PROFICIENCY_DEFAULT_PARALLEL_LAYOUT_IDS) do
				local layoutRoot = bar:getChildById(layoutId)

				if layoutRoot then
					local panel = layoutRoot:recursiveGetChildById("proficiencyPanel")

					if panel then
						panel:setVisible(showPanel)

						local rowInner = layoutRoot:recursiveGetChildById("topBarProficiencyRowInner")

						if rowInner then
							rowInner:updateLayout()
						end
					end
				end
			end
		end
	end

	if not showPanel then
		StatsBar.clearProficiencyHighlightUi()

		lastProficiencyCache = {}
	end

	StatsBar.applyCompactTopProficiencyWeaponButton()

	for _, bar in pairs(statsBars) do
		if bar then
			for _, layoutId in ipairs(PROFICIENCY_LARGE_LAYOUT_IDS) do
				local largeRoot = bar:getChildById(layoutId)

				if largeRoot then
					local centerRow = largeRoot:recursiveGetChildById("largeTopCenterRow")

					if centerRow then
						centerRow:updateLayout()
					end
				end
			end
		end
	end
end

local MONK_COMBO_IMAGE_EMPTY = "/images/game/topbar/icon-combopoint-empty"
local MONK_COMBO_IMAGE_FILLED = "/images/game/topbar/icon-combopoint-filled"
local MONK_SERENE_IMAGE_OFF = "/images/game/topbar/icon-serene-off"
local MONK_SERENE_IMAGE_ON = "/images/game/topbar/icon-serene-on"

local function statsBarApplyMonkComboSereneToRoot(root, monkPanelId, comboNamePrefix, sereneIconId, player)
	if not root then
		return
	end

	local monkPanel = root:recursiveGetChildById(monkPanelId)

	if not monkPanel then
		return
	end

	if not player or not g_game.isOnline() or not player.isMonk or not player:isMonk() then
		monkPanel:hide()

		return
	end

	monkPanel:show()

	local harmony = 0

	if player.getHarmony then
		harmony = math.min(5, math.max(0, player:getHarmony()))
	end

	for i = 1, 5 do
		local w = monkPanel:recursiveGetChildById(comboNamePrefix .. i)

		if w then
			w:setImageSource(i <= harmony and MONK_COMBO_IMAGE_FILLED or MONK_COMBO_IMAGE_EMPTY)
		end
	end

	local sereneIcon = monkPanel:recursiveGetChildById(sereneIconId)

	if sereneIcon and player.isSerene then
		sereneIcon:setImageSource(player:isSerene() and MONK_SERENE_IMAGE_ON or MONK_SERENE_IMAGE_OFF)
	end
end

function StatsBar.applyDefaultTopMonkComboSereneLayout()
	local player = g_game.isOnline() and g_game.getLocalPlayer() or nil

	for _, bar in pairs(statsBars) do
		if bar then
			for _, layoutId in ipairs(PROFICIENCY_DEFAULT_PARALLEL_LAYOUT_IDS) do
				local layoutRoot = bar:getChildById(layoutId)

				if layoutRoot then
					statsBarApplyMonkComboSereneToRoot(layoutRoot, "topBarMonkComboSerene", "topBarMonkCombo", "topBarMonkSereneIcon", player)

					local rowInner = layoutRoot:recursiveGetChildById("topBarProficiencyRowInner")

					if rowInner then
						rowInner:updateLayout()
					end
				end
			end

			for _, layoutId in ipairs(PROFICIENCY_LARGE_LAYOUT_IDS) do
				local largeRoot = bar:getChildById(layoutId)

				if largeRoot then
					statsBarApplyMonkComboSereneToRoot(largeRoot, "topBarMonkComboSereneLarge", "topBarMonkLargeCombo", "topBarMonkLargeSereneIcon", player)

					local centerRow = largeRoot:recursiveGetChildById("largeTopCenterRow")

					if centerRow then
						centerRow:updateLayout()
					end
				end
			end

			for _, layoutId in ipairs(PROFICIENCY_COMPACT_LAYOUT_IDS) do
				local compactRoot = bar:getChildById(layoutId)

				if compactRoot then
					statsBarApplyMonkComboSereneToRoot(compactRoot, "topBarMonkComboSereneCompact", "topBarMonkCompactCombo", "topBarMonkCompactSereneIcon", player)

					local centerRow = compactRoot:recursiveGetChildById("compactTopCenterRow")

					if centerRow then
						centerRow:updateLayout()
					end
				end
			end
		end
	end
end

function StatsBar.init()
	statsBarTop = modules.game_interface.getGameTopStatsBar()
	statsBarBottom = modules.game_interface.getGameBottomStatsBar()
	statsBars = {
		statsBarTop = statsBarTop,
		statsBarBottom = statsBarBottom
	}

	if not statsBarTop then
		return
	end

	if not statsBarBottom then
		return
	end

	for _, statBar in pairs(statsBars) do
		statBar = createStatsBarWidgets(statBar)
	end

	statsBarDeepInfo = {
		onExperienceChange = StatsBar.scheduleCurrentStatsBarDeepInfo,
		onLevelChange = StatsBar.scheduleCurrentStatsBarDeepInfo,
		onHealthChange = StatsBar.scheduleCurrentStatsBarHealthInfo,
		onManaChange = StatsBar.scheduleCurrentStatsBarManaInfo,
		onManaShieldChange = StatsBar.scheduleCurrentStatsBarManaInfo,
		onMagicLevelChange = StatsBar.scheduleCurrentStatsBarDeepInfo,
		onBaseMagicLevelChange = StatsBar.scheduleCurrentStatsBarDeepInfo,
		onSkillChange = StatsBar.scheduleCurrentStatsBarDeepInfo,
		onBaseSkillChange = StatsBar.scheduleCurrentStatsBarDeepInfo,
		onStatesChange = StatsBar.reloadCurrentStatsBarQuickInfo_state,
		onRegenerationChange = StatsBar.onRegenerationChange,
		onHarmonyChange = StatsBar.applyDefaultTopMonkComboSereneLayout,
		onSereneChange = StatsBar.applyDefaultTopMonkComboSereneLayout,
		onVocationChange = StatsBar.applyDefaultTopMonkComboSereneLayout
	}

	StatsBar.hideAll()
	connect(LocalPlayer, statsBarDeepInfo)
	connect(g_things, statsBarThingsHandlers)
	connect(g_game, {
		onGameStart = StatsBar.OnGameStart,
		onGameEnd = StatsBar.OnGameEnd
	})
	StatsBar.applyDefaultTopProficiencyLayout()
	StatsBar.applyDefaultTopMonkComboSereneLayout()

	if g_game.isOnline() then
		statsBarConnectInventoryPlayer()
	end
end

function StatsBar.hideAll()
	for _, bar in pairs(statsBars) do
		if bar then
			for _, placement in pairs(statsBarsPlacements) do
				for dimension, _ in pairs(statsBarsDimensions) do
					local key = tostring(dimension):lower() .. "On" .. placement

					if bar[key] and bar[key].skills then
						bar[key].skills:destroyChildren()
						bar[key].skills:setHeight(0)
						bar[key]:setHeight(0)
						bar[key]:hide()
					end
				end
			end

			bar:setHeight(0)
		end
	end
end

function StatsBar.destroyAllIcons()
	for _, bar in pairs(statsBars) do
		if bar then
			for _, placement in pairs(statsBarsPlacements) do
				for dimension, _ in pairs(statsBarsDimensions) do
					local key = tostring(dimension):lower() .. "On" .. placement

					if bar[key] and bar[key].skills then
						local iconsPanel = bar[key]:recursiveGetChildById("icons")

						if iconsPanel then
							iconsPanel:destroyChildren()
						end
					end
				end
			end

			bar:setHeight(0)
		end
	end
end

function StatsBar.destroyAllBars()
	for _, bar in pairs(statsBars) do
		if bar then
			bar:destroy()
		end
	end
end

function StatsBar.terminate()
	StatsBar.cancelPendingRefreshes()
	statsBarDisconnectInventoryPlayer()
	disconnect(LocalPlayer, statsBarDeepInfo)
	disconnect(g_things, statsBarThingsHandlers)
	disconnect(g_game, {
		onGameStart = StatsBar.OnGameStart,
		onGameEnd = StatsBar.OnGameEnd
	})
	StatsBar.destroyAllBars()
end

function StatsBar.onRegenerationChange(localPlayer, now, old)
	if now == old then
		return
	end

	refreshHungryConditionIcon()
end

function StatsBar.onHungryChange(regenerationTime, alert)
	refreshHungryConditionIcon()
end

function StatsBar.switchCurrentLayout()
	if table.empty(lastProficiencyCache) then
		return
	end

	StatsBar.onUpdateProficiencyData(lastProficiencyCache.itemCache, lastProficiencyCache.hasUnnusedPerk, lastProficiencyCache.thingType)
end

function StatsBar.onUpdateProficiencyData(itemCache, hasHighlight, thingType)
	if not thingType or not itemCache then
		StatsBar.clearProficiencyHighlightUi()
		StatsBar.applyDefaultTopProficiencyLayout()

		return
	end

	local PD = ProficiencyData

	if not PD and modules.game_proficiency then
		PD = modules.game_proficiency.ProficiencyData
	end

	if not modules.game_proficiency or not PD then
		StatsBar.clearProficiencyHighlightUi()
		StatsBar.applyDefaultTopProficiencyLayout()

		return
	end

	local perkLanes = PD:getPerkLaneCount(thingType:getProficiencyId())
	local maxAvailableLevel = perkLanes + 2
	local floorLastPerk = perkLanes > 0 and PD:getMaxExperienceByLevel(perkLanes, thingType) or nil
	local percent = PD:getTopBarProficiencyPercent(itemCache.exp, thingType)
	local maxLevelExperience, progressTooltip

	if floorLastPerk and floorLastPerk <= itemCache.exp then
		maxLevelExperience = PD:getMaxExperience(perkLanes, thingType)
		progressTooltip = string.format("Proficiency Progress: %s / %s", comma_value(itemCache.exp), comma_value(maxLevelExperience))
	else
		local weaponLevel = PD:getCurrentLevelByExp(thingType, itemCache.exp, true)

		maxLevelExperience = PD:getMaxExperienceByLevel(math.min(maxAvailableLevel, weaponLevel + 1), thingType)
		progressTooltip = string.format("Proficiency Progress: %s / %s", comma_value(itemCache.exp), comma_value(maxLevelExperience))
	end

	local showHighlight = false
	if WeaponProficiency and WeaponProficiency.hasUnusedPerk then
		showHighlight = WeaponProficiency:hasUnusedPerk(thingType:getId(), thingType)
	else
		showHighlight = proficiencyServerHighlightOn(hasHighlight)
	end

	applyProficiencyTopBarWidgetsAllLayouts(percent, progressTooltip, showHighlight)

	for _, bar in pairs(statsBars) do
		if bar then
			local compactRing = bar:recursiveGetChildById("proficiencyButtonCompactProgress")

			if compactRing then
				updateCompactBorderProgress(compactRing, percent)
				compactRing:setTooltip(progressTooltip)
			end

			local largeRing = bar:recursiveGetChildById("proficiencyButtonLargeProgress")

			if largeRing then
				updateCompactBorderProgress(largeRing, percent)
				largeRing:setTooltip(progressTooltip)
			end
		end
	end

	setProficiencyPerkHighlightVisible(showHighlight)

	lastProficiencyCache = {
		itemCache = itemCache,
		hasUnnusedPerk = showHighlight,
		thingType = thingType,
		itemClientId = thingType:getId(),
		topBarPercent = percent
	}

	StatsBar.applyDefaultTopProficiencyLayout()
end
