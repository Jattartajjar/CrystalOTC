-- chunkname: @/game_offlinetraining/game_offlinetraining.lua

offlineTrainingWindow = nil

-- forward declaration: init/terminate/sendOfflineTraining sit HIGHER in the file than
-- the definition, and they must call the local version (the global name is shared with other modules)
local destroyOfflineTrainingDialog

-- must come BEFORE setSkillPercent, which uses it (in the decompiled file it was lower -> nil)
local function skillPercentForBar(rawPercent)
	rawPercent = rawPercent or 0
	if rawPercent > 100 then
		return math.floor(rawPercent / 100)
	end
	return math.floor(rawPercent)
end

local function setSkillValue(id, value)
	if not offlineTrainingWindow or offlineTrainingWindow:isDestroyed() then
		return
	end

	local skill = offlineTrainingWindow:recursiveGetChildById(id)

	if not skill then
		return
	end

	local widget = skill:getChildById("value")

	if widget then
		widget:setText(value)
	end
end

local function setSkillPercent(id, percent, tooltip, color)
	if not offlineTrainingWindow or offlineTrainingWindow:isDestroyed() then
		return
	end

	local skill = offlineTrainingWindow:recursiveGetChildById(id)

	if not skill then
		return
	end

	local widget = skill:getChildById("percent")

	if not widget then
		return
	end

	widget:setVisible(true)
	widget:setPercent(skillPercentForBar(percent))

	if tooltip then
		widget:setTooltip(tooltip)
	end

	if color then
		widget:setBackgroundColor(color)
	end
end

local function skillPercentToGoFormatted(rawPercent)
	rawPercent = rawPercent or 0
	if rawPercent > 100 then
		return string.format("%.2f", 100 - rawPercent / 100)
	end
	return string.format("%.2f", 100 - rawPercent)
end

local function skillPercentToGoTooltip(rawPercent)
	return tr("You have %s percent to go", skillPercentToGoFormatted(rawPercent))
end

local function buildLoyaltySkillTooltipLine(total, base, loyaltyField)
	loyaltyField = loyaltyField or 0

	local loyaltyBonus = 0
	local itemBonus = 0

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

	local line = string.format("%d = %d", total, base)

	if itemBonus > 0 then
		line = line .. " +" .. itemBonus
	end

	if loyaltyBonus > 0 then
		line = line .. string.format(" (+%d Loyalty)", loyaltyBonus)
	end

	return line
end

local function setSkillBase(id, value, baseValue, loyaltyField)
	if not offlineTrainingWindow or offlineTrainingWindow:isDestroyed() then
		return
	end

	if baseValue <= 0 or value < 0 then
		return
	end

	local skill = offlineTrainingWindow:recursiveGetChildById(id)

	if not skill then
		return
	end

	local widget = skill:getChildById("value")

	if not widget then
		return
	end

	if baseValue < value then
		widget:setColor("#44ad25")
		skill:setTooltip(buildLoyaltySkillTooltipLine(value, baseValue, loyaltyField))
	elseif value < baseValue then
		widget:setColor("#ff9854")
		skill:setTooltip(baseValue .. " " .. value - baseValue)
	else
		widget:setColor("#c0c0c0")
		skill:removeTooltip()
	end
end

local function updateAllSkills()
	local player = g_game.getLocalPlayer()

	if not player or not offlineTrainingWindow or offlineTrainingWindow:isDestroyed() then
		return
	end

	setSkillValue("magiclevel", player:getMagicLevel())
	setSkillPercent("magiclevel", player:getMagicLevelPercent(), skillPercentToGoTooltip(player:getMagicLevelPercent()))
	setSkillBase("magiclevel", player:getMagicLevel(), player:getBaseMagicLevel(), player.getMagicLoyalty and player:getMagicLoyalty() or 0)

	for i = Skill.Fist, Skill.Distance do
		local widgetId = "skillId" .. i

		setSkillValue(widgetId, player:getSkillLevel(i))
		setSkillPercent(widgetId, player:getSkillLevelPercent(i), skillPercentToGoTooltip(player:getSkillLevelPercent(i)))
		setSkillBase(widgetId, player:getSkillLevel(i), player:getSkillBaseLevel(i), player.getSkillLoyalty and player:getSkillLoyalty(i) or 0)
	end
end

function init()
	g_ui.importStyle("/game_skills/skills_widgets")
	g_ui.importStyle("game_offlinetraining")
	connect(g_game, {
		onGameEnd = destroyOfflineTrainingDialog,
		onModalOfflineTraining = onModalOfflineTraining
	})

	-- our engine emits this on the LocalPlayer as onMultiOfflineTrainingDialog
	-- (protocolgameparse -> LocalPlayer::openMultiOfflineTrainingDialog), not on g_game
	connect(LocalPlayer, {
		onMultiOfflineTrainingDialog = onModalOfflineTraining
	})

	modules.game_offlinetraining.hide = offlineTrainingHide
	modules.game_offlinetraining.offlineTrainingHide = offlineTrainingHide
	modules.game_offlinetraining.cancel = cancel
	modules.game_offlinetraining.offlineTrainingCancel = offlineTrainingCancel
	modules.game_offlinetraining.sendOfflineTraining = sendOfflineTraining
end

function terminate()
	disconnect(g_game, {
		onGameEnd = destroyOfflineTrainingDialog,
		onModalOfflineTraining = onModalOfflineTraining
	})
	disconnect(LocalPlayer, {
		onMultiOfflineTrainingDialog = onModalOfflineTraining
	})
	destroyOfflineTrainingDialog()
end

-- NOTE: this module is NOT sandboxed (.otmod without `sandboxed: true`), so every
-- `function name()` lands in the SHARED global namespace of the whole client. The names `cancel`
-- and `destroyDialog` are also used by game_bossdifficulty, game_soulpit and game_modaldialog -
-- whoever loads later overwrites the predecessor. That is why clicking Cancel called the cancel
-- function of the boss difficulty window: no error, no log, and our window never closed.
-- Internally we therefore use a LOCAL function that nobody from outside can swap out.
destroyOfflineTrainingDialog = function()
	if offlineTrainingWindow and not offlineTrainingWindow:isDestroyed() then
		-- WITHOUT g_modalManager: its blocker (modalBlocker) lands over the window and swallows
		-- clicks, which left the Cancel/Train buttons dead. Our working version from before the
		-- module swap also used a plain destroy().
		if g_modalManager and g_modalManager.hide then
			pcall(g_modalManager.hide, offlineTrainingWindow)
		end

		offlineTrainingWindow:destroy()

		offlineTrainingWindow = nil
	end
end

-- the global aliases stay for compatibility (connect in init, possible external calls),
-- but EVERY internal use goes through the local function above
function destroyDialog()
	destroyOfflineTrainingDialog()
end

-- likewise a unique name: `hide` collides with game_soulpit
function offlineTrainingHide()
	if offlineTrainingWindow and not offlineTrainingWindow:isDestroyed() then
		if g_modalManager and g_modalManager.hide then
			pcall(g_modalManager.hide, offlineTrainingWindow)
		end

		offlineTrainingWindow:hide()
	end
end

function hide()
	offlineTrainingHide()
end

-- Name UNIQUE to this module: `cancel` is shared with game_bossdifficulty and was being
-- overwritten by it, so the Cancel button cancelled the boss window instead of closing this one.
function offlineTrainingCancel()
	-- We send NOTHING to the server here: crystal/canary treats skill 0 as Fist Fighting
	-- (Game::playerStartOfflineTraining) and with no bed present it logs the player out IMMEDIATELY.
	-- Cancelling is only supposed to close the window on the client side.
	destroyOfflineTrainingDialog()
end

function cancel()
	offlineTrainingCancel()
end

local function bindWindowHandlers()
	if not offlineTrainingWindow or offlineTrainingWindow:isDestroyed() then
		return
	end

	-- we call the LOCAL function, not the global `cancel` - the latter can be overwritten
	-- at any moment by another module, since none of them is sandboxed
	offlineTrainingWindow.onEscape = function()
		destroyOfflineTrainingDialog()
	end

	function offlineTrainingWindow.onKeyDown(_, keyCode, keyboardModifiers)
		if keyboardModifiers == KeyboardNoModifier and keyCode == KeyEscape then
			destroyOfflineTrainingDialog()

			return true
		end

		return false
	end

	local closeButton = offlineTrainingWindow:recursiveGetChildById("closeButton")

	if closeButton then
		closeButton.onClick = function()
			destroyOfflineTrainingDialog()
		end
	end
end

function onModalOfflineTraining()
	if offlineTrainingWindow and not offlineTrainingWindow:isDestroyed() then
		offlineTrainingWindow:show()
	else
		offlineTrainingWindow = g_ui.createWidget("OfflineTrainingWindow", rootWidget)
	end

	updateAllSkills()
	bindWindowHandlers()

	-- we show the window directly (raise+focus), without g_modalManager - its blocking overlay
	-- intercepted clicks on the Cancel/Train buttons
	offlineTrainingWindow:show()
	offlineTrainingWindow:raise()
	offlineTrainingWindow:focus()
end

-- The server does NOT expect skills_t values - parseStartOfflineTraining has its own switch over
-- protocol codes 1..6 (1=CLUB, 2=SWORD, 3=AXE, 4=DISTANCE, 5=MAGLEVEL, 6=FIST) and translates them
-- to skills_t itself. Client-side remapping sent 13 and 0, which fell into default:,
-- so Magic and Fist were rejected and the training never got set at all.
-- The button numbers are corrected directly in the .otui, so here we pass the value 1:1.
function sendOfflineTraining(skillId)
	if type(skillId) ~= "number" or skillId < 1 or skillId > 6 then
		g_logger.error(string.format("[oft] unknown skillId from UI: %s", tostring(skillId)))

		return
	end

	g_game.sendOfflineTraining(skillId)
	destroyOfflineTrainingDialog()
end
