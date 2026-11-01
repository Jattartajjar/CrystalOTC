-- chunkname: @/game_skills/skills.lua

skillsWindow = nil
skillsButton = nil
skillsSettings = nil

local ExpRating = {}
local updateExperienceRate, lastDefenseInfo, lastForgeInfo, lastAbsorbValues, lastMagicLevelBonuses, syncSkillsMainPanelButton
local OFFENCE_BAR_STATS_IDS = {
	"skillId7",
	"skillId8",
	"skillId9",
	"skillId10",
	"skillId11",
	"skillId12",
	"skillId13",
	"skillId14",
	"skillId15",
	"skillId16"
}

local function hideOffenceStatsInSkillsBar()
	if not skillsWindow then
		return
	end

	for _, id in pairs(OFFENCE_BAR_STATS_IDS) do
		local w = skillsWindow:recursiveGetChildById(id)

		if w then
			w:setVisible(false)
		end
	end
end

local function syncOffenceExtraSkillRows()
	if g_game.getClientVersion() < 1412 or not skillsWindow then
		return
	end

	hideOffenceStatsInSkillsBar()
end

function init()
	connect(LocalPlayer, {
		onExperienceChange = onExperienceChange,
		onLevelChange = onLevelChange,
		onHealthChange = onHealthChange,
		onManaChange = onManaChange,
		onSoulChange = onSoulChange,
		onFreeCapacityChange = onFreeCapacityChange,
		onTotalCapacityChange = onTotalCapacityChange,
		onBaseCapacityChange = onBaseCapacityChange,
		onStaminaChange = onStaminaChange,
		onPremiumChange = onPremiumChange,
		onOfflineTrainingChange = onOfflineTrainingChange,
		onRegenerationChange = onRegenerationChange,
		onSpeedChange = onSpeedChange,
		onBaseSpeedChange = onBaseSpeedChange,
		onMagicLevelChange = onMagicLevelChange,
		onBaseMagicLevelChange = onBaseMagicLevelChange,
		onSkillChange = onSkillChange,
		onBaseSkillChange = onBaseSkillChange,
		onFlatDamageHealingChange = onFlatDamageHealingChange,
		onAttackInfoChange = onAttackInfoChange,
		onConvertedDamageChange = onConvertedDamageChange,
		onImbuementsChange = onImbuementsChange,
		onDefenseInfoChange = onDefenseInfoChange,
		onCombatAbsorbValuesChange = onCombatAbsorbValuesChange,
		onMagicLevelBonusesChange = onMagicLevelBonusesChange,
		onForgeBonusesChange = onForgeBonusesChange,
		onExperienceRateChange = onExperienceRateChange
	})
	connect(g_game, {
		onGameStart = online,
		onGameEnd = offline
	})
	g_ui.importStyle("skills_widgets")

	skillsButton = modules.game_mainpanel.addToggleButton("skillsButton", tr("Open Skills Window"), "/images/options/button_skills", toggle, false, 1)
	skillsWindow = g_ui.loadUI("skills")

	skillsWindow:setContentMinimumHeight(80)
	Keybind.new("Windows", "Show/hide skills windows", "Alt+S", "")
	Keybind.bind("Windows", "Show/hide skills windows", {
		{
			type = KEY_DOWN,
			callback = toggle
		}
	})

	skillSettings = g_settings.getNode("skills-hide")

	if not skillSettings then
		skillSettings = {}
	end

	local toggleFilterButton = skillsWindow:recursiveGetChildById("toggleFilterButton")

	if toggleFilterButton then
		toggleFilterButton:setVisible(false)
		toggleFilterButton:setOn(false)
	end

	local contextMenuButton = skillsWindow:recursiveGetChildById("contextMenuButton")
	local minimizeButton = skillsWindow:recursiveGetChildById("minimizeButton")

	if contextMenuButton and minimizeButton then
		contextMenuButton:addAnchor(AnchorTop, minimizeButton:getId(), AnchorTop)
		contextMenuButton:addAnchor(AnchorRight, minimizeButton:getId(), AnchorLeft)
		contextMenuButton:setMarginRight(5)

		function contextMenuButton.onClick(widget, mousePos, mouseButton)
			return showSkillsContextMenu(widget, mousePos, mouseButton)
		end
	end

	function skillsWindow.onMousePress(widget, mousePos, button)
		if button == MouseRightButton then
			return showSkillsContextMenu(widget, mousePos, button)
		end

		return false
	end

	local newWindowButton = skillsWindow:recursiveGetChildById("newWindowButton")

	if newWindowButton then
		function newWindowButton.onClick()
			if modules.game_cyclopedia then
				modules.game_cyclopedia.show("character")
			end
		end
	end

	refresh()
	skillsWindow:setup()

	if g_game.isOnline() then
		skillsWindow:setupOnStart()
	end

	syncSkillsMainPanelButton()
end

function terminate()
	disconnect(LocalPlayer, {
		onExperienceChange = onExperienceChange,
		onLevelChange = onLevelChange,
		onHealthChange = onHealthChange,
		onManaChange = onManaChange,
		onSoulChange = onSoulChange,
		onFreeCapacityChange = onFreeCapacityChange,
		onTotalCapacityChange = onTotalCapacityChange,
		onBaseCapacityChange = onBaseCapacityChange,
		onStaminaChange = onStaminaChange,
		onPremiumChange = onPremiumChange,
		onOfflineTrainingChange = onOfflineTrainingChange,
		onRegenerationChange = onRegenerationChange,
		onSpeedChange = onSpeedChange,
		onBaseSpeedChange = onBaseSpeedChange,
		onMagicLevelChange = onMagicLevelChange,
		onBaseMagicLevelChange = onBaseMagicLevelChange,
		onSkillChange = onSkillChange,
		onBaseSkillChange = onBaseSkillChange,
		onFlatDamageHealingChange = onFlatDamageHealingChange,
		onAttackInfoChange = onAttackInfoChange,
		onConvertedDamageChange = onConvertedDamageChange,
		onImbuementsChange = onImbuementsChange,
		onDefenseInfoChange = onDefenseInfoChange,
		onCombatAbsorbValuesChange = onCombatAbsorbValuesChange,
		onMagicLevelBonusesChange = onMagicLevelBonusesChange,
		onForgeBonusesChange = onForgeBonusesChange,
		onExperienceRateChange = onExperienceRateChange
	})
	disconnect(g_game, {
		onGameStart = online,
		onGameEnd = offline
	})
	Keybind.delete("Windows", "Show/hide skills windows")
	skillsWindow:destroy()
	skillsButton:destroy()

	skillsWindow = nil
	skillsButton = nil
end

function showSkillsContextMenu(widget, mousePos, mouseButton)
	local menu = g_ui.createWidget("SkillsListSubMenu")

	menu:setGameMenu(true)

	if not g_game.getFeature(GameOfflineTrainingTime) then
		local offlineTrainingOption = menu:getChildById("showOfflineTraining")

		if offlineTrainingOption then
			offlineTrainingOption:setVisible(false)
		end
	end

	if g_game.getClientVersion() < 1412 then
		local offenceStatsOption = menu:getChildById("showOffenceStats")

		if offenceStatsOption then
			offenceStatsOption:setVisible(false)
		end

		local defenceStatsOption = menu:getChildById("showDefenceStats")

		if defenceStatsOption then
			defenceStatsOption:setVisible(false)
		end

		local miscStatsOption = menu:getChildById("showMiscStats")

		if miscStatsOption then
			miscStatsOption:setVisible(false)
		end

		local children = menu:getChildren()
		local separatorCount = 0

		for i, child in ipairs(children) do
			if child:getClassName() == "HorizontalSeparator" or child:getId() == "HorizontalSeparator" then
				separatorCount = separatorCount + 1

				if separatorCount > 1 then
					child:setVisible(false)
				end
			end
		end
	end

	for _, choice in ipairs(menu:getChildren()) do
		local choiceId = choice:getId()

		if choiceId and choiceId ~= "HorizontalSeparator" then
			if choiceId == "resetExperienceCounter" then
				function choice.onClick()
					onSkillsMenuAction(choiceId)
					menu:destroy()
				end
			else
				local currentState = getSkillVisibilityState(choiceId)

				choice:setChecked(currentState)

				function choice.onCheckChange()
					onSkillsMenuAction(choiceId)
					menu:destroy()
				end
			end
		end
	end

	menu:display({
		x = mousePos.x,
		y = mousePos.y
	})

	return true
end

function onSkillsMenuAction(actionId)
	if actionId == "resetExperienceCounter" then
		resetExperienceCounter()
	elseif actionId == "showLevel" then
		toggleSkillProgressBar("level")
	elseif actionId == "showStamina" then
		toggleSkillProgressBar("stamina")
	elseif actionId == "showOfflineTraining" then
		toggleSkillProgressBar("offlineTraining")
	elseif actionId == "showMagic" then
		toggleSkillProgressBar("magiclevel")
	elseif actionId == "showFist" then
		toggleSkillProgressBar("skillId0")
	elseif actionId == "showClub" then
		toggleSkillProgressBar("skillId1")
	elseif actionId == "showSword" then
		toggleSkillProgressBar("skillId2")
	elseif actionId == "showAxe" then
		toggleSkillProgressBar("skillId3")
	elseif actionId == "showDistance" then
		toggleSkillProgressBar("skillId4")
	elseif actionId == "showShielding" then
		toggleSkillProgressBar("skillId5")
	elseif actionId == "showFishing" then
		toggleSkillProgressBar("skillId6")
	elseif actionId == "showOffenceStats" then
		toggleOffenceStatsVisibility()
	elseif actionId == "showDefenceStats" then
		toggleDefenceStatsVisibility()
	elseif actionId == "showMiscStats" then
		toggleMiscStatsVisibility()
	elseif actionId == "showAllSkillBars" then
		toggleAllSkillBars()
	end
end

function getSkillVisibilityState(actionId)
	if actionId == "showLevel" then
		return isSkillPercentBarVisible("level")
	elseif actionId == "showStamina" then
		return isSkillPercentBarVisible("stamina")
	elseif actionId == "showOfflineTraining" then
		return isSkillPercentBarVisible("offlineTraining")
	elseif actionId == "showMagic" then
		return isSkillPercentBarVisible("magiclevel")
	elseif actionId == "showFist" then
		return isSkillPercentBarVisible("skillId0")
	elseif actionId == "showClub" then
		return isSkillPercentBarVisible("skillId1")
	elseif actionId == "showSword" then
		return isSkillPercentBarVisible("skillId2")
	elseif actionId == "showAxe" then
		return isSkillPercentBarVisible("skillId3")
	elseif actionId == "showDistance" then
		return isSkillPercentBarVisible("skillId4")
	elseif actionId == "showShielding" then
		return isSkillPercentBarVisible("skillId5")
	elseif actionId == "showFishing" then
		return isSkillPercentBarVisible("skillId6")
	elseif actionId == "showOffenceStats" then
		return areOffenceStatsVisible()
	elseif actionId == "showDefenceStats" then
		return areDefenceStatsVisible()
	elseif actionId == "showMiscStats" then
		return areMiscStatsVisible()
	elseif actionId == "showAllSkillBars" then
		return areAllSkillBarsVisible()
	end

	return false
end

function isSkillVisible(skillId)
	local skill = skillsWindow:recursiveGetChildById(skillId)

	return skill and skill:isVisible()
end

function isSkillPercentBarVisible(skillId)
	local skill = skillsWindow:recursiveGetChildById(skillId)

	if skill then
		local percentBar = skill:getChildById("percent")

		return percentBar and percentBar:isVisible()
	end

	return false
end

function toggleSkillProgressBar(skillId)
	local skill = skillsWindow:recursiveGetChildById(skillId)

	if skill then
		local percentBar = skill:getChildById("percent")
		local skillIcon = skill:getChildById("icon")

		if percentBar then
			local isVisible = percentBar:isVisible()

			percentBar:setVisible(not isVisible)

			if skillIcon then
				skillIcon:setVisible(not isVisible)
			end

			if not isVisible then
				skill:setHeight(21)
			else
				skill:setHeight(15)
			end

			local char = g_game.getCharacterName()

			if not skillSettings[char] then
				skillSettings[char] = {}
			end

			skillSettings[char][skillId] = isVisible and 1 or 0

			g_settings.setNode("skills-hide", skillSettings)
		end
	end
end

function toggleSkillVisibility(skillId)
	local skill = skillsWindow:recursiveGetChildById(skillId)

	if skill then
		local percentBar = skill:getChildById("percent")
		local skillIcon = skill:getChildById("icon")

		if percentBar then
			local isVisible = percentBar:isVisible()

			percentBar:setVisible(not isVisible)

			if skillIcon then
				skillIcon:setVisible(not isVisible)
			end

			if not isVisible then
				skill:setHeight(21)
			else
				skill:setHeight(15)
			end

			local char = g_game.getCharacterName()

			if not skillSettings[char] then
				skillSettings[char] = {}
			end

			skillSettings[char][skillId] = isVisible and 1 or 0

			g_settings.setNode("skills-hide", skillSettings)
		end
	end
end

function resetExperienceCounter()
	local player = g_game.getLocalPlayer()

	if player then
		modules.game_textmessage.displayGameMessage("Experience counter has been reset.")
	end
end

function areOffenceStatsVisible()
	local offenceStats = {
		"skillId7",
		"skillId8",
		"skillId9",
		"skillId10",
		"skillId11",
		"skillId12",
		"skillId13",
		"skillId14",
		"skillId15",
		"skillId16",
		"separadorOnOffenceInfoChange"
	}

	for _, skillId in pairs(offenceStats) do
		local skill = skillsWindow:recursiveGetChildById(skillId)

		if skill and skill:isVisible() then
			return true
		end
	end

	return false
end

function toggleOffenceStatsVisibility()
	hideOffenceStatsInSkillsBar()

	local char = g_game.getCharacterName()

	if not skillSettings[char] then
		skillSettings[char] = {}
	end

	skillSettings[char].offenceStats_visible = false

	g_settings.setNode("skills-hide", skillSettings)
end

function areDefenceStatsVisible()
	local defenceStats = {
		"physicalResist",
		"fireResist",
		"earthResist",
		"energyResist",
		"IceResist",
		"HolyResist",
		"deathResist",
		"HealingResist",
		"drowResist",
		"lifedrainResist",
		"manadRainResist",
		"defenceValue",
		"armorValue",
		"mitigation",
		"dodge",
		"damageReflection",
		"separadorOnDefenseInfoChange"
	}

	for _, skillId in pairs(defenceStats) do
		local skill = skillsWindow:recursiveGetChildById(skillId)

		if skill and skill:isVisible() then
			return true
		end
	end

	return false
end

function toggleDefenceStatsVisibility()
	local allDefenceWidgets = {
		"physicalResist",
		"fireResist",
		"earthResist",
		"energyResist",
		"IceResist",
		"HolyResist",
		"deathResist",
		"HealingResist",
		"drowResist",
		"lifedrainResist",
		"manadRainResist",
		"defenceValue",
		"armorValue",
		"mitigation",
		"dodge",
		"damageReflection",
		"separadorOnDefenseInfoChange"
	}
	local shouldShow = not areDefenceStatsVisible()

	if shouldShow then
		local player = g_game.getLocalPlayer()

		if player and lastDefenseInfo then
			onDefenseInfoChange(player, lastDefenseInfo[1], lastDefenseInfo[2], lastDefenseInfo[3], lastDefenseInfo[4], lastDefenseInfo[5])
		end

		if player and lastAbsorbValues then
			onCombatAbsorbValuesChange(player, lastAbsorbValues)
		end
	else
		for _, skillId in pairs(allDefenceWidgets) do
			local skill = skillsWindow:recursiveGetChildById(skillId)

			if skill then
				skill:setVisible(false)
			end
		end

		updateHeight()
	end

	local char = g_game.getCharacterName()

	if not skillSettings[char] then
		skillSettings[char] = {}
	end

	skillSettings[char].defenceStats_visible = shouldShow

	g_settings.setNode("skills-hide", skillSettings)
end

function areMiscStatsVisible()
	local miscStats = {
		"momentum",
		"transcendence",
		"amplification",
		"separadorOnForgeBonusesChange"
	}

	for _, skillId in pairs(miscStats) do
		local skill = skillsWindow:recursiveGetChildById(skillId)

		if skill and skill:isVisible() then
			return true
		end
	end

	return false
end

function toggleMiscStatsVisibility()
	local miscStats = {
		"momentum",
		"transcendence",
		"amplification",
		"separadorOnForgeBonusesChange"
	}
	local shouldShow = not areMiscStatsVisible()

	for _, skillId in pairs(miscStats) do
		local skill = skillsWindow:recursiveGetChildById(skillId)

		if skill then
			skill:setVisible(shouldShow)
		end
	end

	local char = g_game.getCharacterName()

	if not skillSettings[char] then
		skillSettings[char] = {}
	end

	skillSettings[char].miscStats_visible = shouldShow

	g_settings.setNode("skills-hide", skillSettings)
end

function areAllSkillBarsVisible()
	local allSkills = {
		"level",
		"stamina",
		"offlineTraining",
		"magiclevel",
		"skillId0",
		"skillId1",
		"skillId2",
		"skillId3",
		"skillId4",
		"skillId5",
		"skillId6"
	}

	for _, skillId in pairs(allSkills) do
		local skill = skillsWindow:recursiveGetChildById(skillId)

		if skill then
			local percentBar = skill:getChildById("percent")

			if percentBar and not percentBar:isVisible() then
				return false
			end
		end
	end

	return true
end

function toggleAllSkillBars()
	local allSkills = {
		"level",
		"stamina",
		"offlineTraining",
		"magiclevel",
		"skillId0",
		"skillId1",
		"skillId2",
		"skillId3",
		"skillId4",
		"skillId5",
		"skillId6"
	}
	local shouldShow = not areAllSkillBarsVisible()

	for _, skillId in pairs(allSkills) do
		local skill = skillsWindow:recursiveGetChildById(skillId)

		if skill then
			local percentBar = skill:getChildById("percent")
			local skillIcon = skill:getChildById("icon")

			if percentBar then
				percentBar:setVisible(shouldShow)

				if skillIcon then
					skillIcon:setVisible(shouldShow)
				end

				if shouldShow then
					skill:setHeight(21)
				else
					skill:setHeight(15)
				end

				local char = g_game.getCharacterName()

				if not skillSettings[char] then
					skillSettings[char] = {}
				end

				skillSettings[char][skillId] = shouldShow and 0 or 1
			end
		end
	end

	g_settings.setNode("skills-hide", skillSettings)
end

function expForLevel(level)
	return math.floor(50 * level * level * level / 3 - 100 * level * level + 850 * level / 3 - 200)
end

function expToAdvance(currentLevel, currentExp)
	return expForLevel(currentLevel + 1) - currentExp
end

local skillRawPercents = {}

local function skillPercentForBar(rawPercent)
	return math.floor((rawPercent or 0) / 100)
end

local function skillPercentToGoFormatted(rawPercent)
	return string.format("%.2f", 100 - (rawPercent or 0) / 100)
end

local function skillPercentToGoTooltip(rawPercent)
	return tr("You have %s percent to go", skillPercentToGoFormatted(rawPercent))
end

local function formatTimeTooltip(time)
	local hours = math.floor(time / 60)
	local minutes = time % 60

	return string.format("%02d", hours), string.format("%02d", minutes)
end

local function updateCapacitySkill(localPlayer)
	if not localPlayer then
		return
	end

	local freeCapacity = math.floor(localPlayer:getFreeCapacity())
	local totalCapacity = localPlayer:getTotalCapacity()
	local baseCapacity = localPlayer:getBaseCapacity()

	setSkillValue("capacity", comma_value(freeCapacity))

	if baseCapacity < totalCapacity then
		local bonus = totalCapacity - baseCapacity

		setSkillColor("capacity", "#44ad25")
		setSkillTooltip("capacity", comma_value(totalCapacity) .. " = " .. comma_value(baseCapacity) .. " + " .. comma_value(bonus) .. "\n" .. tr("You have %s of %s Capacity left", comma_value(freeCapacity), comma_value(totalCapacity)))
	else
		setSkillColor("capacity", "#c0c0c0")
		setSkillTooltip("capacity", tr("You have %s of %s Capacity left", comma_value(freeCapacity), comma_value(totalCapacity)))
	end
end

local function updateSpeedSkill(localPlayer)
	if not localPlayer then
		return
	end

	local speed = math.floor(localPlayer:getSpeed())
	local baseSpeed = localPlayer:getBaseSpeed()

	setSkillValue("speed", comma_value(speed))

	if baseSpeed < speed then
		setSkillColor("speed", "#44ad25")
		setSkillTooltip("speed", comma_value(speed) .. " = " .. comma_value(baseSpeed) .. " + " .. comma_value(speed - baseSpeed) .. "\n" .. tr("You have %s Speed", comma_value(speed)))
	else
		setSkillColor("speed", "#c0c0c0")
		setSkillTooltip("speed", tr("You have %s Speed", comma_value(speed)))
	end
end

local function getExperienceProgressTooltip(localPlayer)
	local expNeeded = expToAdvance(localPlayer:getLevel(), localPlayer:getExperience())

	if expNeeded and expNeeded > 0 then
		return tr("%s XP for next level", comma_value(expNeeded)) .. "\n" .. skillPercentToGoTooltip(localPlayer:getLevelPercent())
	end

	return nil
end

local function updateExperienceTooltip(localPlayer)
	if not localPlayer then
		return
	end

	local progressTooltip = getExperienceProgressTooltip(localPlayer)

	if localPlayer.expSpeed ~= nil then
		local expPerHour = math.floor(localPlayer.expSpeed * 3600)

		if expPerHour > 0 then
			local expNeeded = expToAdvance(localPlayer:getLevel(), localPlayer:getExperience())

			if expNeeded and expNeeded > 0 then
				local hoursLeft = expNeeded / expPerHour
				local minutesLeft = math.floor((hoursLeft - math.floor(hoursLeft)) * 60)

				hoursLeft = math.floor(hoursLeft)

				local expText = tr("%s of experience per hour", comma_value(expPerHour)) .. "\n" .. tr("Next level in %d hours and %d minutes", hoursLeft, minutesLeft)

				if progressTooltip then
					expText = expText .. "\n" .. progressTooltip
				end

				setSkillTooltip("experience", expText)

				return
			end

			setSkillTooltip("experience", tr("%s of experience per hour", comma_value(expPerHour)))

			return
		end
	end

	setSkillTooltip("experience", progressTooltip)
end

local function isLoyaltySkillWidgetId(id)
	return id == "magiclevel" or type(id) == "string" and id:match("^skillId%d+$") ~= nil
end

local function resolveSkillBonuses(total, base, loyaltyField)
	loyaltyField = loyaltyField or 0

	local loyaltyBonus = 0
	local itemBonus = 0

	if total <= base then
		return 0, 0
	end

	if base < loyaltyField then
		loyaltyBonus = loyaltyField - base
		itemBonus = total - loyaltyField
	elseif loyaltyField > 0 and loyaltyField <= total - base then
		loyaltyBonus = loyaltyField
		itemBonus = total - base - loyaltyBonus
	else
		itemBonus = total - base
	end

	if itemBonus < 0 then
		itemBonus = 0
	end

	if loyaltyBonus < 0 then
		loyaltyBonus = 0
	end

	return itemBonus, loyaltyBonus
end

local function buildLoyaltySkillTooltipLine(total, base, loyaltyField)
	local itemBonus, loyaltyBonus = resolveSkillBonuses(total, base, loyaltyField)
	local line = string.format("%d = %d", total, base)

	if itemBonus > 0 then
		line = line .. " +" .. itemBonus
	elseif itemBonus < 0 then
		line = line .. " " .. itemBonus
	end

	if loyaltyBonus > 0 then
		line = line .. string.format(" (+%d Loyalty)", loyaltyBonus)
	end

	return line
end

local function normalizeMagicLevelBonuses(bonuses)
	local normalized = {}

	if not bonuses or type(bonuses) ~= "table" then
		return normalized
	end

	local firstEntry = bonuses[1]

	if type(firstEntry) == "table" then
		for i = 1, #bonuses do
			local entry = bonuses[i]

			if entry then
				local elementId = entry[1]
				local value = entry[2]

				if elementId ~= nil and value and value > 0 then
					table.insert(normalized, {
						elementId,
						value
					})
				end
			end
		end
	else
		for elementId, value in pairs(bonuses) do
			if type(value) == "number" and value > 0 then
				table.insert(normalized, {
					elementId,
					value
				})
			end
		end
	end

	table.sort(normalized, function(a, b)
		return a[1] < b[1]
	end)

	return normalized
end

function buildAdditionalMagicLevelModifiersTooltip(bonuses)
	local normalized = normalizeMagicLevelBonuses(bonuses)

	if #normalized == 0 then
		return nil
	end

	local lines = {
		tr("Additional magic level modifiers:")
	}

	for i = 1, #normalized do
		local elementId = normalized[i][1]
		local value = normalized[i][2]

		lines[#lines + 1] = tr("%s magic level +%d", getClientCombatElementName(elementId), value)
	end

	return "\n\n" .. table.concat(lines, "\n")
end

local function appendMagicLevelModifiersTooltip(tooltip, bonuses)
	local modifierTooltip = buildAdditionalMagicLevelModifiersTooltip(bonuses)

	if not modifierTooltip then
		return tooltip
	end

	if tooltip and tooltip ~= "" then
		return tooltip .. modifierTooltip
	end

	return modifierTooltip:gsub("^\n\n", "")
end

local function buildLoyaltySkillTooltip(value, baseValue, loyaltyField, rawPercent, magicLevelBonuses)
	local percentLine = rawPercent ~= nil and skillPercentToGoTooltip(rawPercent) or nil
	local itemBonus, loyaltyBonus = resolveSkillBonuses(value, baseValue, loyaltyField or 0)
	local tooltip

	if itemBonus > 0 or loyaltyBonus > 0 then
		local breakdown = buildLoyaltySkillTooltipLine(value, baseValue, loyaltyField or 0)

		if percentLine then
			tooltip = breakdown .. "\n" .. percentLine
		else
			tooltip = breakdown
		end
	else
		tooltip = percentLine
	end

	return appendMagicLevelModifiersTooltip(tooltip, magicLevelBonuses)
end

function resetSkillColor(id)
	local skill = skillsWindow:recursiveGetChildById(id)
	local widget = skill:getChildById("value")

	widget:setColor("#c0c0c0")
end

function toggleSkill(id, state)
	for i = 7, 16 do
		if id == "skillId" .. i then
			state = false

			break
		end
	end

	local skill = skillsWindow:recursiveGetChildById(id)

	if skill then
		skill:setVisible(state)
	end
end

function setSkillBase(id, value, baseValue, loyaltyField)
	if value < 0 or baseValue < 0 then
		return
	end

	local skill = skillsWindow:recursiveGetChildById(id)

	if not skill then
		return
	end

	local widget = skill:getChildById("value")
	local rawPercent = skillRawPercents[id]
	local percentWidget = skill:getChildById("percent")

	if isLoyaltySkillWidgetId(id) then
		local itemBonus = select(1, resolveSkillBonuses(value, baseValue, loyaltyField))
		local magicLevelBonuses = id == "magiclevel" and lastMagicLevelBonuses or nil
		local tooltip = buildLoyaltySkillTooltip(value, baseValue, loyaltyField, rawPercent, magicLevelBonuses)

		if itemBonus > 0 then
			widget:setColor("#44ad25")
		elseif value < baseValue then
			widget:setColor("#ff9854")

			if id == "magiclevel" and tooltip then
				skill:setTooltip(tooltip)
			else
				skill:setTooltip(baseValue .. " " .. value - baseValue)
			end

			if percentWidget and rawPercent ~= nil then
				percentWidget:setTooltip(tooltip or skillPercentToGoTooltip(rawPercent))
			end

			return
		else
			widget:setColor("#c0c0c0")
		end

		if tooltip then
			skill:setTooltip(tooltip)
		else
			skill:removeTooltip()
		end

		if percentWidget then
			percentWidget:setTooltip(tooltip or rawPercent ~= nil and skillPercentToGoTooltip(rawPercent) or nil)
		end

		return
	end

	if baseValue < value then
		widget:setColor("#44ad25")
		skill:setTooltip(baseValue .. " +" .. value - baseValue)
	elseif value < baseValue then
		widget:setColor("#ff9854")
		skill:setTooltip(baseValue .. " " .. value - baseValue)

		if percentWidget and rawPercent ~= nil then
			percentWidget:setTooltip(skillPercentToGoTooltip(rawPercent))
		end
	else
		widget:setColor("#c0c0c0")
		skill:removeTooltip()

		if percentWidget and rawPercent ~= nil then
			percentWidget:setTooltip(skillPercentToGoTooltip(rawPercent))
		end
	end
end

function setSkillValue(id, value)
	local skill = skillsWindow:recursiveGetChildById(id)

	if skill then
		local widget = skill:getChildById("value")

		if id == "skillId7" or id == "skillId8" or id == "skillId9" or id == "skillId11" or id == "skillId13" or id == "skillId14" or id == "skillId15" or id == "skillId16" then
			if g_game.getFeature(GameEnterGameShowAppearance) then
				value = value / 100
			end

			widget:setText(value .. "%")
		else
			widget:setText(value)
		end
	end
end

function setSkillColor(id, value)
	local skill = skillsWindow:recursiveGetChildById(id)

	if skill then
		local widget = skill:getChildById("value")

		widget:setColor(value)
	end
end

function setSkillTooltip(id, value)
	local skill = skillsWindow:recursiveGetChildById(id)

	if skill then
		if value then
			skill:setTooltip(value)
		else
			skill:removeTooltip()
		end
	end
end

function setSkillPercent(id, percent, tooltip, color)
	skillRawPercents[id] = percent

	local skill = skillsWindow:recursiveGetChildById(id)

	if skill then
		local widget = skill:getChildById("percent")

		if widget then
			widget:setPercent(skillPercentForBar(percent))

			if tooltip then
				widget:setTooltip(tooltip)
			end

			if color then
				widget:setBackgroundColor(color)
			end
		end
	end
end

function checkAlert(id, value, maxValue, threshold, greaterThan)
	if greaterThan == nil then
		greaterThan = false
	end

	local alert = false

	if type(maxValue) == "boolean" then
		if maxValue then
			return
		end

		if greaterThan then
			if threshold < value then
				alert = true
			end
		elseif value < threshold then
			alert = true
		end
	elseif type(maxValue) == "number" then
		if maxValue < 0 then
			return
		end

		local percent = math.floor(value / maxValue * 100)

		if greaterThan then
			if threshold < percent then
				alert = true
			end
		elseif percent < threshold then
			alert = true
		end
	end

	if alert then
		setSkillColor(id, "#b22222")
	else
		resetSkillColor(id)
	end
end

function update()
	local offlineTraining = skillsWindow:recursiveGetChildById("offlineTraining")

	if not g_game.getFeature(GameOfflineTrainingTime) then
		offlineTraining:hide()
	else
		offlineTraining:show()
	end

	local regenerationTime = skillsWindow:recursiveGetChildById("regenerationTime")

	if not g_game.getFeature(GamePlayerRegenerationTime) then
		regenerationTime:hide()
	else
		regenerationTime:show()
	end

	local xpBoostButton = skillsWindow:recursiveGetChildById("xpBoostButton")
	local xpGainRate = skillsWindow:recursiveGetChildById("xpGainRate")
	local player = g_game.getLocalPlayer()

	if player and g_game.getFeature(GameExperienceBonus) then
		updateExperienceRate(player)
	else
		if xpBoostButton then
			xpBoostButton:hide()
		end

		if xpGainRate then
			xpGainRate:hide()
		end
	end
end

function online()
	skillsWindow:setupOnStart()

	local toggleFilterButton = skillsWindow:recursiveGetChildById("toggleFilterButton")

	if toggleFilterButton then
		toggleFilterButton:setVisible(false)
		toggleFilterButton:setOn(false)
	end

	local contextMenuButton = skillsWindow:recursiveGetChildById("contextMenuButton")
	local minimizeButton = skillsWindow:recursiveGetChildById("minimizeButton")

	if contextMenuButton and minimizeButton then
		contextMenuButton:addAnchor(AnchorTop, minimizeButton:getId(), AnchorTop)
		contextMenuButton:addAnchor(AnchorRight, minimizeButton:getId(), AnchorLeft)
		contextMenuButton:setMarginRight(5)
	end

	local newWindowButton = skillsWindow:recursiveGetChildById("newWindowButton")

	if g_game.getClientVersion() < 1310 then
		newWindowButton:hide()
	end

	if newWindowButton then
		function newWindowButton.onClick()
			if modules.game_cyclopedia then
				modules.game_cyclopedia.show("character")
			end
		end
	end

	refresh()

	if g_game.getFeature(GameEnterGameShowAppearance) then
		skillsWindow:recursiveGetChildById("regenerationTime"):getChildByIndex(1):setText("Food")
	end
end

function refresh()
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	if expSpeedEvent then
		expSpeedEvent:cancel()
	end

	expSpeedEvent = cycleEvent(checkExpSpeed, 30000)

	onExperienceChange(player, player:getExperience())
	onLevelChange(player, player:getLevel(), player:getLevelPercent())
	onHealthChange(player, player:getHealth(), player:getMaxHealth())
	onManaChange(player, player:getMana(), player:getMaxMana())
	onSoulChange(player, player:getSoul())
	onFreeCapacityChange(player, player:getFreeCapacity())
	onStaminaChange(player, player:getStamina())
	onMagicLevelChange(player, player:getMagicLevel(), player:getMagicLevelPercent())

	if player.getMagicLevelBonuses then
		lastMagicLevelBonuses = player:getMagicLevelBonuses()
	end

	onOfflineTrainingChange(player, player:getOfflineTrainingTime())
	onRegenerationChange(player, player:getRegenerationTime())
	startFoodRegenerationTicker()
	onSpeedChange(player, player:getSpeed())

	local hasAdditionalSkills = g_game.getFeature(GameAdditionalSkills)

	for i = Skill.Fist, Skill.Transcendence do
		onSkillChange(player, i, player:getSkillLevel(i), player:getSkillLevelPercent(i))

		if i > Skill.Fishing then
			local ativedAdditionalSkills = hasAdditionalSkills

			if ativedAdditionalSkills then
				if g_game.getClientVersion() >= 1281 then
					if i == Skill.LifeLeechAmount or i == Skill.ManaLeechAmount then
						ativedAdditionalSkills = false
					elseif g_game.getClientVersion() < 1332 and Skill.Transcendence then
						ativedAdditionalSkills = false
					elseif i >= Skill.Fatal and player:getSkillLevel(i) <= 0 then
						ativedAdditionalSkills = false
					end
				elseif g_game.getClientVersion() < 1281 and i >= Skill.Fatal then
					ativedAdditionalSkills = false
				end
			end

			toggleSkill("skillId" .. i, ativedAdditionalSkills)
		end
	end

	updateExperienceRate(player)
	update()
	updateHeight()

	if g_game.getClientVersion() < 1412 then
		local offenceStats = {
			"skillId7",
			"skillId8",
			"skillId9",
			"skillId10",
			"skillId11",
			"skillId12",
			"skillId13",
			"skillId14",
			"skillId15",
			"skillId16"
		}

		for _, skillId in pairs(offenceStats) do
			local skill = skillsWindow:recursiveGetChildById(skillId)

			if skill then
				skill:hide()
			end
		end

		local defenceStats = {
			"physicalResist",
			"fireResist",
			"earthResist",
			"energyResist",
			"IceResist",
			"HolyResist",
			"deathResist",
			"HealingResist",
			"drowResist",
			"lifedrainResist",
			"manadRainResist",
			"defenceValue",
			"armorValue",
			"mitigation",
			"dodge",
			"damageReflection",
			"separadorOnDefenseInfoChange"
		}

		for _, skillId in pairs(defenceStats) do
			local skill = skillsWindow:recursiveGetChildById(skillId)

			if skill then
				skill:hide()
			end
		end

		local miscStats = {
			"momentum",
			"transcendence",
			"amplification",
			"separadorOnForgeBonusesChange"
		}

		for _, skillId in pairs(miscStats) do
			local skill = skillsWindow:recursiveGetChildById(skillId)

			if skill then
				skill:hide()
			end
		end

		local additionalSeparators = {
			"criticalHit",
			"damageHealing",
			"attackValue",
			"convertedDamage",
			"convertedElement",
			"lifeLeech",
			"manaLeech",
			"criticalChance",
			"criticalExtraDamage",
			"onslaught"
		}

		for _, separatorId in pairs(additionalSeparators) do
			local separator = skillsWindow:recursiveGetChildById(separatorId)

			if separator then
				separator:hide()
			end
		end

		local function hideUnnamedSeparators(widget)
			if not widget then
				return
			end

			local children = widget:getChildren()

			for _, child in pairs(children) do
				if child:getClassName() == "HorizontalSeparator" and (not child:getId() or child:getId() == "") then
					child:hide()
				elseif child:getClassName() == "UIWidget" and (not child:getId() or child:getId() == "") then
					local childHeight = child:getHeight()
					local childChildrenCount = #child:getChildren()

					if childHeight <= 15 and childChildrenCount == 0 then
						child:hide()
					end
				end

				hideUnnamedSeparators(child)
			end
		end

		hideUnnamedSeparators(skillsWindow)
	end

	loadSkillsVisibilitySettings()

	if g_game.getClientVersion() >= 1412 then
		syncOffenceExtraSkillRows()
	end
end

function loadSkillsVisibilitySettings()
	local char = g_game.getCharacterName()

	if not char or not skillSettings[char] then
		return
	end

	local settings = skillSettings[char]
	local individualSkills = {
		"level",
		"stamina",
		"offlineTraining",
		"magiclevel",
		"skillId0",
		"skillId1",
		"skillId2",
		"skillId3",
		"skillId4",
		"skillId5",
		"skillId6"
	}

	for _, skillId in pairs(individualSkills) do
		if settings[skillId] ~= nil then
			local skill = skillsWindow:recursiveGetChildById(skillId)

			if skill then
				local percentBar = skill:getChildById("percent")
				local skillIcon = skill:getChildById("icon")

				if percentBar then
					local shouldShow = settings[skillId] ~= 1

					percentBar:setVisible(shouldShow)

					if skillIcon then
						skillIcon:setVisible(shouldShow)
					end

					if shouldShow then
						skill:setHeight(21)
					else
						skill:setHeight(15)
					end
				end
			end
		end
	end

	if g_game.getClientVersion() >= 1412 then
		hideOffenceStatsInSkillsBar()

		if settings.defenceStats_visible ~= nil then
			local defGroup = settings.defenceStats_visible

			if not defGroup then
				local allDefenceWidgets = {
					"physicalResist",
					"fireResist",
					"earthResist",
					"energyResist",
					"IceResist",
					"HolyResist",
					"deathResist",
					"HealingResist",
					"drowResist",
					"lifedrainResist",
					"manadRainResist",
					"defenceValue",
					"armorValue",
					"mitigation",
					"dodge",
					"damageReflection",
					"separadorOnDefenseInfoChange"
				}

				for _, id in pairs(allDefenceWidgets) do
					local w = skillsWindow:recursiveGetChildById(id)

					if w then
						w:setVisible(false)
					end
				end
			end
		end

		if settings.miscStats_visible ~= nil then
			local mGroup = settings.miscStats_visible
			local sep = skillsWindow:recursiveGetChildById("separadorOnForgeBonusesChange")

			if sep then
				sep:setVisible(mGroup)
			end

			if not mGroup then
				for _, id in pairs({
					"momentum",
					"transcendence",
					"amplification"
				}) do
					local w = skillsWindow:recursiveGetChildById(id)

					if w then
						w:setVisible(false)
					end
				end
			end
		end
	end
end

local FORGE_MISC_SCROLL_ROW_HEIGHT = 14
local FORGE_MISC_SCROLL_GROUP_ADJUST = -3

local function isForgeMiscStatRowId(id)
	return id == "momentum" or id == "transcendence" or id == "amplification"
end

function updateHeight()
	local maximumHeight = 8
	local minimumHeight = 52

	if g_game.isOnline() then
		local char = g_game.getCharacterName()

		if not skillSettings[char] then
			skillSettings[char] = {}
		end

		local skillsButtons = skillsWindow:recursiveGetChildById("experience"):getParent():getChildren()
		local forgeMiscVisibleCount = 0

		for _, skillButton in ipairs(skillsButtons) do
			local percentBar = skillButton:getChildById("percent")

			if skillButton:isVisible() then
				if percentBar then
					showPercentBar(skillButton, skillSettings[char][skillButton:getId()] ~= 1)
				end

				local rowId = skillButton:getId() or ""

				if isForgeMiscStatRowId(rowId) then
					forgeMiscVisibleCount = forgeMiscVisibleCount + 1
					maximumHeight = maximumHeight + FORGE_MISC_SCROLL_ROW_HEIGHT
				else
					maximumHeight = maximumHeight + skillButton:getHeight() + skillButton:getMarginBottom()
				end
			end
		end

		if forgeMiscVisibleCount > 0 then
			maximumHeight = maximumHeight + FORGE_MISC_SCROLL_GROUP_ADJUST
		end

		local bottomSep = skillsWindow:recursiveGetChildById("skillsContentBottomSeparator")
		local cont = skillsWindow:getChildById("contentsPanel")

		if bottomSep and bottomSep:isVisible() and cont and bottomSep:getParent() == cont then
			local hCap = (bottomSep:getY() or 0) + bottomSep:getHeight() + (bottomSep.getMarginBottom and bottomSep:getMarginBottom() or 0)

			if hCap > 0 and hCap > maximumHeight * 0.2 then
				maximumHeight = math.max(maximumHeight, hCap)
			end
		end
	else
		maximumHeight = 390
	end

	skillsWindow:setContentMinimumHeight(math.max(minimumHeight, 44))
	skillsWindow:setContentMaximumHeight(maximumHeight)
end

local EXTENDED_OFFENCE_STATS = {
	"criticalHit",
	"damageHealing",
	"attackValue",
	"convertedDamage",
	"convertedElement",
	"lifeLeech",
	"manaLeech",
	"criticalChance",
	"criticalExtraDamage",
	"onslaught"
}
local EXTENDED_DEFENCE_STATS = {
	"physicalResist",
	"fireResist",
	"earthResist",
	"energyResist",
	"IceResist",
	"HolyResist",
	"deathResist",
	"HealingResist",
	"drowResist",
	"lifedrainResist",
	"manadRainResist",
	"defenceValue",
	"armorValue",
	"mitigation",
	"dodge",
	"damageReflection",
	"separadorOnDefenseInfoChange"
}
local EXTENDED_MISC_STATS = {
	"momentum",
	"transcendence",
	"amplification",
	"separadorOnForgeBonusesChange"
}
local PROGRESS_BAR_SKILL_IDS = {
	"level",
	"stamina",
	"offlineTraining",
	"magiclevel",
	"skillId0",
	"skillId1",
	"skillId2",
	"skillId3",
	"skillId4",
	"skillId5",
	"skillId6"
}

local function resetExtendedStats()
	if not skillsWindow then
		return
	end

	for _, id in pairs(EXTENDED_OFFENCE_STATS) do
		local skill = skillsWindow:recursiveGetChildById(id)

		if skill then
			local valueWidget = skill:getChildById("value")

			if valueWidget then
				valueWidget:setText("0")
			end

			skill:hide()
		end
	end

	for _, id in pairs(EXTENDED_DEFENCE_STATS) do
		local skill = skillsWindow:recursiveGetChildById(id)

		if skill then
			local valueWidget = skill:getChildById("value")

			if valueWidget then
				valueWidget:setText("0")
			end

			skill:hide()
		end
	end

	for _, id in pairs(EXTENDED_MISC_STATS) do
		local skill = skillsWindow:recursiveGetChildById(id)

		if skill then
			local valueWidget = skill:getChildById("value")

			if valueWidget then
				valueWidget:setText("0")
			end

			skill:hide()
		end
	end

	for _, id in pairs(PROGRESS_BAR_SKILL_IDS) do
		local skill = skillsWindow:recursiveGetChildById(id)

		if skill then
			local percentWidget = skill:getChildById("percent")

			if percentWidget then
				percentWidget:setPercent(0)
			end
		end
	end

	ExpRating = {}
	skillRawPercents = {}
	lastDefenseInfo = nil
	lastForgeInfo = nil
	lastAbsorbValues = nil
	lastMagicLevelBonuses = nil
end

function offline()
	if not SidebarPersistence or not SidebarPersistence.lastSessionActive then
		skillsWindow:setParent(nil, true)
	end

	if expSpeedEvent then
		expSpeedEvent:cancel()

		expSpeedEvent = nil
	end

	stopFoodRegenerationTicker()
	resetExtendedStats()
	g_settings.setNode("skills-hide", skillSettings)
end

function syncSkillsMainPanelButton()
	if SidebarWidgetOptions and SidebarWidgetOptions.syncToggleButton then
		SidebarWidgetOptions.syncToggleButton(skillsWindow, skillsButton, "Open Skills Window", "Close Skills Window")

		return
	end

	if not skillsButton or skillsButton:isDestroyed() then
		return
	end

	local on = false

	if skillsWindow and not skillsWindow:isDestroyed() then
		on = skillsWindow:isVisible()
	end

	skillsButton:setOn(on)

	if skillsButton.setTooltip then
		skillsButton:setTooltip(tr(on and "Close Skills Window" or "Open Skills Window"))
	end
end

function toggle()
	if skillsButton:isOn() then
		skillsWindow:closeAndForgetLayout()
	else
		if not skillsWindow:getParent() then
			local panel = modules.game_interface.findContentPanelAvailable(skillsWindow, skillsWindow:getMinimumHeight())

			if not panel then
				return
			end

			panel:addChild(skillsWindow)
		end

		local toggleFilterButton = skillsWindow:recursiveGetChildById("toggleFilterButton")

		if toggleFilterButton then
			toggleFilterButton:setVisible(false)
			toggleFilterButton:setOn(false)
		end

		local contextMenuButton = skillsWindow:recursiveGetChildById("contextMenuButton")
		local minimizeButton = skillsWindow:recursiveGetChildById("minimizeButton")

		if contextMenuButton and minimizeButton then
			contextMenuButton:addAnchor(AnchorTop, minimizeButton:getId(), AnchorTop)
			contextMenuButton:addAnchor(AnchorRight, minimizeButton:getId(), AnchorLeft)
			contextMenuButton:setMarginRight(5)
		end

		local newWindowButton = skillsWindow:recursiveGetChildById("newWindowButton")

		if newWindowButton then
			function newWindowButton.onClick()
				if modules.game_cyclopedia then
					modules.game_cyclopedia.show("character")
				end
			end
		end

		skillsWindow:open()
		updateHeight()
	end

	syncSkillsMainPanelButton()
end

function checkExpSpeed()
	local player = g_game.getLocalPlayer()

	if not player then
		return
	end

	local currentExp = player:getExperience()
	local currentTime = g_clock.seconds()

	if player.lastExps == nil then
		player.lastExps = {}
	end

	table.insert(player.lastExps, {
		currentExp,
		currentTime
	})

	if #player.lastExps > 30 then
		table.remove(player.lastExps, 1)
	end

	if #player.lastExps >= 2 then
		local oldestEntry = player.lastExps[1]
		local expGained = currentExp - oldestEntry[1]
		local timeElapsed = currentTime - oldestEntry[2]

		if timeElapsed > 0 then
			player.expSpeed = expGained / timeElapsed
		else
			player.expSpeed = 0
		end

		onLevelChange(player, player:getLevel(), player:getLevelPercent())
		onExperienceChange(player, player:getExperience())
	end
end

function onMiniWindowOpen()
	syncSkillsMainPanelButton()
end

function onMiniWindowClose()
	syncSkillsMainPanelButton()
end

function onSkillButtonClick(button)
	local percentBar = button:getChildById("percent")
	local skillIcon = button:getChildById("icon")

	if percentBar and skillIcon then
		showPercentBar(button, not percentBar:isVisible())
		skillIcon:setVisible(skillIcon:isVisible())

		local char = g_game.getCharacterName()

		if percentBar:isVisible() then
			skillsWindow:modifyMaximumHeight(6)

			skillSettings[char][button:getId()] = 0
		else
			skillsWindow:modifyMaximumHeight(-6)

			skillSettings[char][button:getId()] = 1
		end
	end
end

function showPercentBar(button, show)
	local percentBar = button:getChildById("percent")
	local skillIcon = button:getChildById("icon")

	if percentBar and skillIcon then
		percentBar:setVisible(show)
		skillIcon:setVisible(show)

		if show then
			button:setHeight(21)
		else
			button:setHeight(15)
		end
	end
end

function onExperienceChange(localPlayer, value)
	setSkillValue("experience", comma_value(value))
	updateExperienceTooltip(localPlayer)
end

function onLevelChange(localPlayer, value, percent)
	local tooltip = skillPercentToGoTooltip(percent)

	setSkillValue("level", comma_value(value))
	setSkillTooltip("level", tooltip)
	setSkillPercent("level", percent, tooltip)
	updateExperienceTooltip(localPlayer)
end

function onHealthChange(localPlayer, health, maxHealth)
	setSkillValue("health", comma_value(health))
	setSkillTooltip("health", tr("You have %s of %s Hit Points left", comma_value(health), comma_value(maxHealth)))
end

function onManaChange(localPlayer, mana, maxMana)
	setSkillValue("mana", comma_value(mana))
	setSkillTooltip("mana", tr("You have %s of %s Mana left", comma_value(mana), comma_value(maxMana)))
end

function onSoulChange(localPlayer, soul)
	setSkillValue("soul", soul)
	setSkillTooltip("soul", tr("You have %s Soul Points left", soul))
end

function onFreeCapacityChange(localPlayer, freeCapacity)
	updateCapacitySkill(localPlayer)
end

function onTotalCapacityChange(localPlayer, totalCapacity)
	updateCapacitySkill(localPlayer)
end

function onBaseCapacityChange(localPlayer, baseCapacity, oldBaseCapacity)
	updateCapacitySkill(localPlayer)
end

function onStaminaChange(localPlayer, stamina)
	local hours = math.floor(stamina / 60)
	local minutes = stamina % 60

	if minutes < 10 then
		minutes = "0" .. minutes
	end

	local tooltipHours, tooltipMinutes = formatTimeTooltip(stamina)
	local rawPercent = math.floor(10000 * stamina / 2520)

	setSkillValue("stamina", hours .. ":" .. minutes)

	local rowTooltip

	if stamina > 2340 and g_game.getClientVersion() >= 1038 and localPlayer:isPremium() then
		rowTooltip = tr("You have %s hours and %s minutes left and receive 50%% more experience", tooltipHours, tooltipMinutes)
	else
		rowTooltip = tr("You have %s hours and %s minutes left", tooltipHours, tooltipMinutes)
	end

	setSkillTooltip("stamina", rowTooltip)

	if stamina > 2340 then
		local text

		if g_game.getClientVersion() >= 1038 and localPlayer:isPremium() then
			text = tr("You have %s hours and %s minutes left", hours, minutes) .. "\n" .. tr("Now you will gain 50%% more experience")
		elseif g_game.getClientVersion() >= 1038 and not localPlayer:isPremium() then
			text = tr("You have %s hours and %s minutes left", hours, minutes) .. "\n" .. tr("You will not gain 50%% more experience because you aren't premium player, now you receive only 1x experience points")
		else
			text = tr("You have %s hours and %s minutes left", hours, minutes) .. "\n" .. tr("If you are premium player, you will gain 50%% more experience")
		end

		setSkillPercent("stamina", rawPercent, text, "green")
	elseif stamina <= 840 then
		setSkillPercent("stamina", rawPercent, rowTooltip, "#C00000")
	else
		setSkillPercent("stamina", rawPercent, rowTooltip, "#C06000")
	end

	updateExperienceRate(localPlayer)
end

function onPremiumChange(localPlayer, isPremium)
	if localPlayer then
		onStaminaChange(localPlayer, localPlayer:getStamina())
	end
end

function onOfflineTrainingChange(localPlayer, offlineTrainingTime)
	if not g_game.getFeature(GameOfflineTrainingTime) then
		return
	end

	local hours = math.floor(offlineTrainingTime / 60)
	local minutes = offlineTrainingTime % 60

	if minutes < 10 then
		minutes = "0" .. minutes
	end

	local tooltipHours, tooltipMinutes = formatTimeTooltip(offlineTrainingTime)
	local rawPercent = math.floor(10000 * offlineTrainingTime / 720)
	local tooltip = tr("You have %s hours and %s minutes of offline training time left", tooltipHours, tooltipMinutes)

	setSkillValue("offlineTraining", hours .. ":" .. minutes)
	setSkillTooltip("offlineTraining", tooltip)
	setSkillPercent("offlineTraining", rawPercent, tooltip)
end

function updateFoodRegenerationDisplay(regenerationTime)
	if not skillsWindow or not g_game.getFeature(GamePlayerRegenerationTime) then
		return
	end

	local remaining = math.max(0, regenerationTime or 0)
	local alert = 300

	if g_game.getFeature(GameEnterGameShowAppearance) then
		alert = 0
	end

	setSkillValue("regenerationTime", formatFoodRegenerationTime(remaining))
	setSkillTooltip("regenerationTime", buildFoodRegenerationTooltip(remaining))
	checkAlert("regenerationTime", remaining, false, alert)

	if g_game.getFeature(GameEnterGameShowAppearance) then
		modules.game_interface.StatsBar.onHungryChange(remaining, alert)
	end
end

function onRegenerationChange(localPlayer, regenerationTime)
	if not g_game.getFeature(GamePlayerRegenerationTime) or regenerationTime < 0 then
		return
	end

	syncFoodRegenerationTime(regenerationTime)
	updateFoodRegenerationDisplay(getFoodRegenerationRemaining())
	startFoodRegenerationTicker()
end

function onSpeedChange(localPlayer, speed)
	updateSpeedSkill(localPlayer)
end

function onBaseSpeedChange(localPlayer, baseSpeed)
	updateSpeedSkill(localPlayer)
end

function onMagicLevelChange(localPlayer, magiclevel, percent)
	setSkillValue("magiclevel", magiclevel)
	setSkillPercent("magiclevel", percent, skillPercentToGoTooltip(percent))
	onBaseMagicLevelChange(localPlayer, localPlayer:getBaseMagicLevel())
end

function onBaseMagicLevelChange(localPlayer, baseMagicLevel)
	local loyaltyField = localPlayer.getMagicLoyalty and localPlayer:getMagicLoyalty() or 0

	setSkillBase("magiclevel", localPlayer:getMagicLevel(), baseMagicLevel, loyaltyField)
end

function onSkillChange(localPlayer, id, level, percent)
	local skillId = "skillId" .. id

	setSkillValue(skillId, level)
	setSkillPercent(skillId, percent, skillPercentToGoTooltip(percent))
	onBaseSkillChange(localPlayer, id, localPlayer:getSkillBaseLevel(id))

	if id > Skill.ManaLeechAmount then
		toggleSkill("skillId" .. id, level > 0)
	end

	if id >= Skill.Fatal and id <= Skill.Transcendence and g_game.getClientVersion() >= 1412 then
		syncOffenceExtraSkillRows()
	end
end

function onBaseSkillChange(localPlayer, id, baseLevel)
	local loyaltyField = localPlayer.getSkillLoyalty and localPlayer:getSkillLoyalty(id) or 0

	setSkillBase("skillId" .. id, localPlayer:getSkillLevel(id), baseLevel, loyaltyField)
end

function updateXpGainRateWidgetFromData(xpGainRateWidget, rates, context)
	if not xpGainRateWidget or not g_game.getFeature(GameExperienceBonus) then
		return
	end

	local widget = xpGainRateWidget:getChildById("value")

	if not widget then
		return
	end

	rates = rates or {}
	context = context or {}

	local baseRate = rates.base or 100
	local expRateTotal = baseRate + (rates.lowLevel or 0) + (rates.xpBoost or 0) + (rates.voucher or 0)
	local staminaMultiplier = rates.staminaMultiplier or 100

	expRateTotal = expRateTotal * staminaMultiplier / 100

	widget:setText(math.floor(expRateTotal) .. "%")

	local tooltip = string.format("Your current XP gain rate amounts to %d%%.", math.floor(expRateTotal))

	tooltip = tooltip .. string.format("\nYour XP gain rate is calculated as follows:\n- Base XP gain rate %d%%", baseRate)

	if (rates.voucher or 0) > 0 then
		tooltip = tooltip .. string.format("\n- Voucher: %d%%", rates.voucher)
	end

	if (rates.xpBoost or 0) > 0 then
		tooltip = tooltip .. string.format("\n- XP Boost: %d%% (%s h remaining)", rates.xpBoost, formatTimeBySeconds(context.xpBoostRemainingSeconds or 0))
	end

	if staminaMultiplier > 100 then
		tooltip = tooltip .. string.format("\n- Stamina multiplier: x%.1f (%s h remaining)", staminaMultiplier / 100, formatTimeByMinutes(math.max(0, (context.staminaMinutes or 0) - 2340)))
	end

	xpGainRateWidget:setTooltip(tooltip)

	if expRateTotal == 0 then
		widget:setColor("#d33c3c")
	elseif expRateTotal > 100 then
		widget:setColor("#44ad25")
	elseif expRateTotal < 100 then
		widget:setColor("#ff9854")
	else
		widget:setColor("#c0c0c0")
	end
end

function updateXpGainRateWidget(xpGainRateWidget, localPlayer)
	if not xpGainRateWidget or not localPlayer then
		return
	end

	updateXpGainRateWidgetFromData(xpGainRateWidget, {
		base = ExpRating[ExperienceRate.BASE] or 100,
		lowLevel = ExpRating[ExperienceRate.LOW_LEVEL] or 0,
		xpBoost = ExpRating[ExperienceRate.XP_BOOST] or 0,
		voucher = ExpRating[ExperienceRate.VOUCHER] or 0,
		staminaMultiplier = ExpRating[ExperienceRate.STAMINA_MULTIPLIER] or 100
	}, {
		xpBoostRemainingSeconds = localPlayer:getStoreExpBoostTime(),
		staminaMinutes = localPlayer:getStamina()
	})
end

function updateExperienceRate(localPlayer)
	local xpBoostButton = skillsWindow:recursiveGetChildById("xpBoostButton")
	local xpGainRate = skillsWindow:recursiveGetChildById("xpGainRate")

	if g_game.getFeature(GameExperienceBonus) then
		if xpGainRate then
			xpGainRate:show()
		end

		if xpBoostButton then
			if (ExpRating[ExperienceRate.XP_BOOST] or 0) > 0 then
				xpBoostButton:hide()
			else
				xpBoostButton:show()
			end
		end
	else
		if xpBoostButton then
			xpBoostButton:hide()
		end

		if xpGainRate then
			xpGainRate:hide()
		end

		return
	end

	updateXpGainRateWidget(xpGainRate, localPlayer)
end

function onExperienceRateChange(localPlayer, type, value)
	ExpRating[type] = value

	updateExperienceRate(localPlayer)
end

local function formatImbuementPercent(value)
	local n = value == nil and 0 or value

	return math.floor(n * 10000) / 100
end

local function buildCriticalHitStatTooltip(critChance, critDamage)
	return tr("You have a +%s%% chance to cause +%s%% extra damage", formatImbuementPercent(critChance), formatImbuementPercent(critDamage))
end

local function setSkillValueWithTooltips(id, value, tooltip, showPercentage, color)
	local skill = skillsWindow:recursiveGetChildById(id)

	if not skill then
		return
	end

	if g_game.getClientVersion() < 1412 then
		local statsToHide = {
			"skillId7",
			"skillId8",
			"skillId9",
			"skillId10",
			"skillId11",
			"skillId12",
			"skillId13",
			"skillId14",
			"skillId15",
			"skillId16",
			"physicalResist",
			"fireResist",
			"earthResist",
			"energyResist",
			"IceResist",
			"HolyResist",
			"deathResist",
			"HealingResist",
			"drowResist",
			"lifedrainResist",
			"manadRainResist",
			"defenceValue",
			"armorValue",
			"mitigation",
			"dodge",
			"damageReflection",
			"momentum",
			"transcendence",
			"amplification"
		}

		for _, statId in pairs(statsToHide) do
			if id == statId then
				skill:hide()

				return
			end
		end
	end

	local alwaysShow = id == "attackValue" or id == "defenceValue" or id == "armorValue"

	if alwaysShow or value ~= nil and value ~= 0 then
		skill:show()

		local widget = skill:getChildById("value")

		if not widget then
			return
		end

		if color then
			widget:setColor(color)
		end

		if showPercentage then
			local n = value == nil and 0 or value
			local percentValue = math.floor(n * 10000) / 100
			local sign = percentValue > 0 and "+" or ""

			widget:setText(sign .. percentValue .. "%")

			if percentValue < 0 then
				widget:setColor("#FF9854")
			end
		elseif alwaysShow then
			local num = value == nil and 0 or value

			widget:setText(tostring(num))
		else
			widget:setText(tostring(value))
		end

		if tooltip then
			skill:setTooltip(tooltip)
		end
	else
		skill:hide()
	end
end

function onFlatDamageHealingChange(localPlayer, flatBonus)
	if g_game.getClientVersion() < 1412 then
		return
	end

	local tooltips = "This flat bonus is the main source of your character's power, added to most of the damage and healing values you cause."

	setSkillValueWithTooltips("damageHealing", flatBonus, tooltips, false)
	updateHeight()
end

function onAttackInfoChange(localPlayer, attackValue, attackElement)
	if g_game.getClientVersion() < 1412 then
		return
	end

	local tooltips = "This is your character's basic attack power whenever you enter a fight with a weapon or your fists. It does not apply to any spells you cast. The attack value is calculated from the weapon's attack value, the corresponding weapon skill, the bonus received from the Revelation Perks and the player's level. The value represents the average damage you would inflict on a creature which had no kind of defence or protection."

	setSkillValueWithTooltips("attackValue", attackValue, tooltips, false)

	local skill = skillsWindow:recursiveGetChildById("attackValue")

	if skill then
		local el = attackElement

		if el == nil then
			el = combatStates.CLIENT_COMBAT_PHYSICAL
		end

		local element = clientCombat[el] or clientCombat[combatStates.CLIENT_COMBAT_PHYSICAL]

		if element then
			local icon = skill:getChildById("icon")

			if icon then
				icon:setImageSource(element.path)
				icon:setImageSize({
					height = 9,
					width = 9
				})
				icon:setTooltip(getClientCombatElementName(el))
			end
		end
	end

	updateHeight()
end

function onConvertedDamageChange(localPlayer, convertedDamage, convertedElement)
	if g_game.getClientVersion() < 1412 then
		return
	end

	setSkillValueWithTooltips("convertedDamage", convertedDamage, false, true)

	local skill = skillsWindow:recursiveGetChildById("convertedDamage")

	if skill and convertedDamage and convertedDamage ~= 0 then
		local element = clientCombat[convertedElement]

		if element then
			local icon = skill:getChildById("icon")

			if icon then
				icon:setImageSource(element.path)
				icon:setImageSize({
					height = 9,
					width = 9
				})
			end
		end
	end

	local skillElementRow = skillsWindow:recursiveGetChildById("convertedElement")

	if skillElementRow then
		skillElementRow:hide()
	end

	updateHeight()
end

function onImbuementsChange(localPlayer, lifeLeech, manaLeech, critChance, critDamage, onslaught)
	if g_game.getClientVersion() < 1412 then
		return
	end

	local lifeLeechTooltips = "You have a +11.4% chance to trigger Onslaught, granting you 60% increased damage for all attacks."
	local manaLeechTooltips = "You have a +1% chance to cause +1% extra damage."
	local criticalHitDescription = tr("Critical Hits deal more damage than normal attacks. They have a chance to be triggered during combat, inflicting additional damage beyond the standard amount.")
	local criticalStatTooltip = buildCriticalHitStatTooltip(critChance, critDamage)
	local onslaughtTooltips = "You get +1% of the damage dealt as hit points"
	local criticalHitWidget = skillsWindow:recursiveGetChildById("criticalHit")

	if criticalHitWidget then
		criticalHitWidget:setVisible(true)
		criticalHitWidget:setTooltip(criticalHitDescription)
	end

	setSkillValueWithTooltips("lifeLeech", lifeLeech, lifeLeechTooltips, true)
	setSkillValueWithTooltips("manaLeech", manaLeech, manaLeechTooltips, true)
	setSkillValueWithTooltips("criticalChance", critChance, criticalStatTooltip, true)
	setSkillValueWithTooltips("criticalExtraDamage", critDamage, criticalStatTooltip, true)
	setSkillValueWithTooltips("onslaught", onslaught, onslaughtTooltips, true)
	updateHeight()
end

local combatIdToWidgetId = {
	[0] = "physicalResist",
	"fireResist",
	"earthResist",
	"energyResist",
	"IceResist",
	"HolyResist",
	"deathResist",
	"HealingResist",
	"drowResist",
	"lifedrainResist",
	"manadRainResist"
}

function onMagicLevelBonusesChange(localPlayer, bonuses)
	lastMagicLevelBonuses = bonuses

	if localPlayer then
		onBaseMagicLevelChange(localPlayer, localPlayer:getBaseMagicLevel())
	end
end

function onCombatAbsorbValuesChange(localPlayer, absorbValues)
	if g_game.getClientVersion() < 1412 then
		return
	end

	lastAbsorbValues = absorbValues

	for id, widgetId in pairs(combatIdToWidgetId) do
		local skill = skillsWindow:recursiveGetChildById(widgetId)

		if skill then
			local value = absorbValues[id]

			if value then
				setSkillValueWithTooltips(widgetId, value, false, true, "#44AD25")
			else
				skill:hide()
			end
		end
	end

	updateDefenceSeparatorVisibility()
	updateHeight()
end

function updateDefenceSeparatorVisibility()
	local defenceWidgetIds = {
		"physicalResist",
		"fireResist",
		"earthResist",
		"energyResist",
		"IceResist",
		"HolyResist",
		"deathResist",
		"HealingResist",
		"drowResist",
		"lifedrainResist",
		"manadRainResist",
		"defenceValue",
		"armorValue",
		"mitigation",
		"dodge",
		"damageReflection"
	}
	local anyVisible = false

	for _, wid in pairs(defenceWidgetIds) do
		local w = skillsWindow:recursiveGetChildById(wid)

		if w and w:isVisible() then
			anyVisible = true

			break
		end
	end

	local sep = skillsWindow:recursiveGetChildById("separadorOnDefenseInfoChange")

	if sep then
		sep:setVisible(anyVisible)
	end
end

function onDefenseInfoChange(localPlayer, defense, armor, mitigation, dodge, damageReflection)
	if g_game.getClientVersion() < 1412 then
		return
	end

	lastDefenseInfo = {
		defense,
		armor,
		mitigation,
		dodge,
		damageReflection
	}

	local defenseToolstip = "This is your protection against all physical attacks in close combat as well as all distance physical attacks. The higher the defence value, the less damage you will take from melee physical hits. The defence value is calculated from your shield and/or weapon defence and the corresponding skill. Careful! Your defence value protects you only from hits of two creatures in a single round."
	local armorToolstip = "This shows how well your armor protects you from all physical attacks."
	local mitigationToolstip = "Mitigation reduces most of the damage you take and varies based on your shielding skill, equipped weapon, chosen combat tactics and any mitigation multipliers acquired in your Wheel of Destiny."
	local dodgetToolstip = "This is your protection against all physical attacks in close combat \nas well as all distance physical attacks. The higher the defence value, the less damage you will take from melee physical hits. The defence\n value is calculated from your shield and/or weapon\n defence and the corresponding skill. Careful! \nYour defence value protects you only from hits of two creatures in a single round."

	setSkillValueWithTooltips("defenceValue", defense, defenseToolstip, false)
	setSkillValueWithTooltips("armorValue", armor, armorToolstip, false)
	setSkillValueWithTooltips("mitigation", mitigation, mitigationToolstip, true)
	setSkillValueWithTooltips("dodge", dodge, dodgetToolstip, true)
	setSkillValueWithTooltips("damageReflection", damageReflection, false, true)
	updateDefenceSeparatorVisibility()
	updateHeight()
end

function onForgeBonusesChange(localPlayer, momentum, transcendence, amplification)
	if g_game.getClientVersion() < 1412 then
		return
	end

	lastForgeInfo = {
		momentum,
		transcendence,
		amplification
	}

	skillsWindow:recursiveGetChildById("separadorOnForgeBonusesChange"):setVisible(true)

	local momentumTooltip = "During combat, you have a +" .. math.floor(momentum * 10000) / 100 .. "% chance to trigger Momentum\n, which reduces all spell cooldowns by 2 seconds."
	local transcendenceTooltip = "During combat, you have a +" .. math.floor(transcendence * 10000) / 100 .. "% chance to trigger\nTranscendence, which transforms your character into a vocation-\nspecific avatar for 7 seconds. " .. "While in this form, you will benefit\nfrom a 15% damage reduction and guaranteed critical hits that \ndeal an additional 15% damage."
	local amplificationTooltip = "Effects of tiered items are amplified by +" .. math.floor(amplification * 10000) / 100 .. "%."

	setSkillValueWithTooltips("momentum", momentum, momentumTooltip, true)
	setSkillValueWithTooltips("transcendence", transcendence, transcendenceTooltip, true)
	setSkillValueWithTooltips("amplification", amplification, amplificationTooltip, true)
	updateHeight()
end

function resolveSkillBonusesForDisplay(total, base, loyaltyField)
	return resolveSkillBonuses(total, base, loyaltyField)
end

function buildLoyaltySkillTooltipLineForDisplay(total, base, loyaltyField)
	return buildLoyaltySkillTooltipLine(total, base, loyaltyField)
end

function skillPercentToGoTooltipForDisplay(rawPercent)
	return skillPercentToGoTooltip(rawPercent)
end

function appendMagicLevelModifiersTooltipForDisplay(tooltip, bonuses)
	return appendMagicLevelModifiersTooltip(tooltip, bonuses)
end
