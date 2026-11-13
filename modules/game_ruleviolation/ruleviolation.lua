-- chunkname: @/game_ruleviolation/ruleviolation.lua

rvreasons = {}
rvreasons[1] = tr("1a) Offensive Name")
rvreasons[2] = tr("1b) Invalid Name Format")
rvreasons[3] = tr("1c) Unsuitable Name")
rvreasons[4] = tr("1d) Name Inciting Rule Violation")
rvreasons[5] = tr("2a) Offensive Statement")
rvreasons[6] = tr("2b) Spamming")
rvreasons[7] = tr("2c) Illegal Advertising")
rvreasons[8] = tr("2d) Off-Topic Public Statement")
rvreasons[9] = tr("2e) Non-English Public Statement")
rvreasons[10] = tr("2f) Inciting Rule Violation")
rvreasons[11] = tr("3a) Bug Abuse")
rvreasons[12] = tr("3b) Game Weakness Abuse")
rvreasons[13] = tr("3c) Using Unofficial Software to Play")
rvreasons[14] = tr("3d) Hacking")
rvreasons[15] = tr("3e) Multi-Clienting")
rvreasons[16] = tr("3f) Account Trading or Sharing")
rvreasons[17] = tr("4a) Threatening Gamemaster")
rvreasons[18] = tr("4b) Pretending to Have Influence on Rule Enforcement")
rvreasons[19] = tr("4c) False Report to Gamemaster")
rvreasons[20] = tr("Destructive Behaviour")
rvreasons[21] = tr("Excessive Unjustified Player Killing")
rvactions = {}
rvactions[0] = tr("Notation")
rvactions[1] = tr("Name Report")
rvactions[2] = tr("Banishment")
rvactions[3] = tr("Name Report + Banishment")
rvactions[4] = tr("Banishment + Final Warning")
rvactions[5] = tr("Name Report + Banishment + Final Warning")
rvactions[6] = tr("Statement Report")
ruleViolationWindow = nil
reasonsTextList = nil
actionsTextList = nil
playerReportWindow = nil
pendingPlayerReport = nil
ReportType = {
	Statement = 1,
	Name = 0,
	Bot = 2
}
BotReportReasons = {
	{
		id = 13,
		title = tr("Using unofficial software to play"),
		description = tr("The player has used unofficial software e.g. a macro program or a so-called tasker or bot, or manipulated the client program.")
	}
}
NameReportReasons = {
	{
		id = 5,
		title = tr("Insulting"),
		description = tr("Names can be reported if they contain very rude and offensive vocabulary or have been created to insult other character names.\n\nExamples:\n\nIllegal - You can report names like:\nStupid Retard, Katie the Moron, Dickhead\n\nLegal - Names like the following are legal and must not be reported:\nNoob, Crazy Guy, Silly Gerta, Charlie the fool")
	},
	{
		id = 5,
		title = tr("Racist"),
		description = tr("Names can be reported if they reflect prejudice or hatred against people from other races or other countries.\n\nExamples:\n\nIllegal - You can report names like:\nJew hater, White Power, Niggerkiller, Stupid Polak\n\nLegal - Names like the following are legal and must not be reported:\nPolish warrior, Tiago de Brasilia, Black Fighter")
	},
	{
		id = 5,
		title = tr("Sexually Related"),
		description = tr("Names can be reported if they refer to sex, a sexual orientation or intimate body parts. Also names of well-known prostitutes or porn stars may be reported.\n\nExamples:\n\nIllegal - You can report names like:\nSixty-nine, Hetero Guy, Nipple, Breastfeeder\n\nLegal - Names like the following are legal and must not be reported:\nSweet Kiss, Macho, Long Legs")
	},
	{
		id = 5,
		title = tr("Drug-related"),
		description = tr("Names can be reported if they explicitly relate to drugs and other illegal substances or to well-known drug dealers. The same is true for names that refer to alcoholism.\n\nExamples:\n\nIllegal - You can report names like:\nJunkie, Weedsmoker, Pablo Escobar, Alcoholic\n\nLegal - Names like the following are legal and must not be reported:\nWater pipe, Tobacco Man, Rum bottle, Drunk Dwarf")
	},
	{
		id = 5,
		title = tr("Harassing"),
		description = tr("Names can be reported if they have been made to harass other players or to threaten other players in real life.\n\nExamples:\n\nIllegal - You can report names like:\nIkillyou Reallife, Wheelchair Marcin\n\nLegal - Names like the following are legal and must not be reported:\nTomurka's friend, Bubble Two")
	},
	{
		id = 8,
		title = tr("Generally objectionable"),
		description = tr("Names can be reported if they are distasteful and likely to offend people, e.g. references to body fluids, excrements, serious diseases or organised crime, also names of contemporary persons known for serious crimes or inhuman actions.\n\nExamples:\n\nIllegal - You can report names like:\nSnot, Moe the Mongolist, Mafia Hitman, Hitler\n\nLegal - Names like the following are legal and must not be reported:\nVial of Blood, Blind beggar, Genghis Khan")
	},
	{
		id = 7,
		title = tr("Advertising brand, product or service of a third party"),
		description = tr("Names can be reported if they contain advertising for worldwide known products, services or companies including titles of other online games.\n\nExamples:\n\nIllegal - You can report names like:\nNike Shoes, Siemens, Frank Google, World of Warcraft\n\nLegal - Names like the following are legal and must not be reported:\nGoddess Nike, Jennifer Lopez, Harry Potter, Real Madrid")
	},
	{
		id = 7,
		title = tr("Advertising content which is not related to the game"),
		description = tr("Names can be reported if they contain advertising for content which is not related to the game.\n\nExamples:\n\nIllegal - You can report names like:\nMobile Sale, Buy headset, Sell My Car\n\nLegal - Names like the following are legal and must not be reported:\nMerchant, Potionbuyer")
	},
	{
		id = 7,
		title = tr("Advertising a trade for real money"),
		description = tr("Names can be reported if they contain advertising that imply the selling or buying of Tibia items for real life money.\n\nExamples:\n\nIllegal - You can report names like:\nPremium Seller, Goldseller\n\nLegal - Names like the following are legal and must not be reported:\nTrader Frank, Goldcoin Collector")
	},
	{
		id = 8,
		title = tr("Religious or political view"),
		description = tr("Names can be reported if they refer to a specific religion or to a person or position that is connected to a certain religion. The same is true for names that express political views or refer to contemporary and well-known politicians.\n\nExamples:\n\nIllegal - You can report names like:\nHindu Master, Jesus Christ, Pope Frank, Anarchist, Lula da Silva\n\nLegal - Names like the following are legal and must not be reported:\nJesus Gonzales, Elfish Priest, God of War, Satan, Abraham Lincoln")
	},
	{
		id = 4,
		title = tr("Supporting rule violation"),
		description = tr("Names can be reported if they support a rule break, encourage others to break a Tibia Rule or announce or imply a violation of the Tibia Rules. The same is true for names that have been created to fake an official position.\n\nExamples:\n\nIllegal - You can report names like:\nSellacc, Spam Sponsor, Bothater, God Durin, System Admin, Senator Kate\n\nLegal - Names like the following are legal and must not be reported:\nEvil Thief, Bad Guy, Steve Johnson, God of War, Count Stephan")
	}
}
StatementReportReasons = {
	{
		id = 5,
		title = tr("Insulting"),
		description = tr("Statements can be reported if they are insulting or contain very offensive vocabulary. Keep in mind that harmless words like \"noob\" might annoy you, but are tolerated and should not be reported.")
	},
	{
		id = 5,
		title = tr("Racist"),
		description = tr("Statements can be reported if they are made to insult a certain country or its inhabitants, a certain nation or an ethnic group.")
	},
	{
		id = 5,
		title = tr("Sexually Related"),
		description = tr("Statements can be reported if they contain references to sex, sexual related body parts or a sexual orientation.")
	},
	{
		id = 5,
		title = tr("Drug-related"),
		description = tr("Statements can be reported if they refer to drugs in any way.")
	},
	{
		id = 5,
		title = tr("Harassing"),
		description = tr("Statements can be reported if they are made to harass other players or to threaten other players in real life.")
	},
	{
		id = 8,
		title = tr("Generally objectionable"),
		description = tr("Statements can be reported if they are grossly distasteful, e.g. cynical remarks about catastrophes.")
	},
	{
		id = 6,
		title = tr("Excessively repeating identical or similar statements"),
		description = tr("Statements can be reported if they have been repeated excessively on the website or ingame.")
	},
	{
		id = 6,
		title = tr("Using badly formatted or nonsensical text"),
		description = tr("Statements can be reported if they only consist of nonsensical letter combinations like \"asdfsdfskhjkh\" or \"spamspamspam\".")
	},
	{
		id = 7,
		title = tr("Advertising brand, product or service of a third party"),
		description = tr("Statements can be reported if they are made to advertise certain goods, services or brands of a third party.")
	},
	{
		id = 7,
		title = tr("Advertising content which is not related to the game"),
		description = tr("Statements can be reported if they contain advertising for all kind of goods and services that are not related to Tibia, e.g. sell my car.")
	},
	{
		id = 7,
		title = tr("Advertising a trade for real money"),
		description = tr("Statements can be reported if they advertise trades of real money for Tibia goods. This includes also offers to buy or sell Premium time.")
	},
	{
		id = 8,
		title = tr("Religious or political view"),
		description = tr("Statements can be reported if they deal with controversial topics like religion and politics.")
	},
	{
		id = 8,
		title = tr("Off-topic public statements in a channel or board"),
		description = tr("Statements can be reported if they have been made in the wrong channel or on the wrong board, e.g. trade messages in the help channel.")
	},
	{
		id = 9,
		title = tr("Violation language restriction"),
		description = tr("Statements can be reported if a player repeatedly uses another language than English in the English chat.")
	},
	{
		id = 8,
		title = tr("Disclosing personal data of other people"),
		description = tr("Statements can be reported if they contain personal data of other people, e.g. email address or phone number.")
	},
	{
		id = 4,
		title = tr("Supporting rule violation"),
		description = tr("Names can be reported if they support a rule break, encourage others to break a Tibia Rule or announce or imply a violation of the Tibia Rules. The same is true for names that have been created to fake an official position.\n\nExamples:\n\nIllegal - You can report names like:\nSellacc, Spam Sponsor, Bothater, God Durin, System Admin, Senator Kate\n\nLegal - Names like the following are legal and must not be reported:\nEvil Thief, Bad Guy, Steve Johnson, God of War, Count Stephan")
	},
	{
		id = 12,
		title = tr("Bug abuse"),
		description = tr("Statements can be reported if they prove that a player has abused an obvious game error or any other part of CipSoft's service.")
	},
	{
		id = 13,
		title = tr("Using unofficial software to play"),
		description = tr("Statements can be reported if they prove that a player has manipulated the client program or has used unofficial software, e.g. a macro program or a so-called tasker or bot.")
	},
	{
		id = 18,
		title = tr("Pretending to be staff"),
		description = tr("Statements can be reported if they are made to make other players believe that a player is a staff member or has their powers or legitimation.")
	},
	{
		id = 19,
		title = tr("Publishing clearly wrong information about CrystalOTC"),
		description = tr("Statements can be reported if they are made to publish clearly wrong information about CrystalOTC or its services.")
	},
	{
		id = 17,
		title = tr("Calling a boycott against staff or its services"),
		description = tr("Statements can be reported if they are made to ask other players to boycott staff or its services.")
	},
	{
		id = 19,
		title = tr("False information to CrystalOTC"),
		description = tr("Statements can be reported if they prove that a player has intentionally given wrong or misleading information concerning rule violation reports, complaints, bug reports or support requests to CrystalOTC.")
	},
	{
		id = 14,
		title = tr("Stealing other players account or personal data"),
		description = tr("Statements can be reported if they prove that a player has tried to steal another player's account data or to hack an account or if they contain links to trick other players into downloading malicious software.")
	},
	{
		id = 20,
		title = tr("Attacking a CrystalOTC service"),
		description = tr("Statements can be reported if they prove that a player has or wants to attack, disrupt or damage the operation of CrystalOTC servers, the game or any other part of CrystalOTC service.")
	},
	{
		id = 20,
		title = tr("Violating applicable law"),
		description = tr("Statements can be reported if they violate any applicable law or prove that an applicable law has been or is planned to be violated.")
	},
	{
		id = 20,
		title = tr("Violating the CrystalOTC Service Agreement"),
		description = tr("Statements can be reported if they violate the CrystalOTC Service Agreement or prove that the CrystalOTC Service Agreement has been violated or is planned to be violated.")
	},
	{
		id = 20,
		title = tr("Violating a right of a third party"),
		description = tr("Statements can be reported if they violate the right of a third party or prove that the right of a third party has been violated or is planned to be violated.")
	}
}

function init()
	connect(g_game, {
		onGMActions = loadReasons
	})

	ruleViolationWindow = g_ui.displayUI("ruleviolation")

	ruleViolationWindow:setVisible(false)

	reasonsTextList = ruleViolationWindow:getChildById("reasonList")
	actionsTextList = ruleViolationWindow:getChildById("actionList")

	Keybind.new("Dialogs", "Open Rule Violation Window", "Ctrl+U", "")
	Keybind.bind("Dialogs", "Open Rule Violation Window", {
		{
			type = KEY_DOWN,
			callback = function()
				show()
			end
		}
	})

	if g_game.isOnline() then
		loadReasons()
	end
end

function terminate()
	disconnect(g_game, {
		onGMActions = loadReasons
	})
	Keybind.delete("Dialogs", "Open Rule Violation Window")
	hidePlayerReportWindow()
	ruleViolationWindow:destroy()
end

function hasWindowAccess()
	return reasonsTextList:getChildCount() > 0
end

function loadReasons()
	reasonsTextList:destroyChildren()
	actionsTextList:destroyChildren()

	local actions = g_game.getGMActions()

	for reason, actionFlags in pairs(actions) do
		local label = g_ui.createWidget("RVListLabel", reasonsTextList)

		label.onFocusChange = onSelectReason

		label:setText(rvreasons[reason])

		label.reasonId = reason
		label.actionFlags = actionFlags
	end

	if not hasWindowAccess() and ruleViolationWindow:isVisible() then
		hide()
	end
end

function show(target, statement)
	if g_game.isOnline() and hasWindowAccess() then
		if target then
			ruleViolationWindow:getChildById("nameText"):setText(target)
		end

		if statement then
			ruleViolationWindow:getChildById("statementText"):setText(statement)
		end

		ruleViolationWindow:show()
		ruleViolationWindow:raise()
		ruleViolationWindow:focus()
		ruleViolationWindow:getChildById("commentText"):focus()
	end
end

local function focusReasonAndAction(reasonId, actionId)
	for _, child in pairs(reasonsTextList:getChildren()) do
		if child.reasonId == reasonId then
			child:focus()

			break
		end
	end

	if actionId == nil then
		return
	end

	scheduleEvent(function()
		for _, child in pairs(actionsTextList:getChildren()) do
			if child.actionId == actionId then
				child:focus()

				break
			end
		end
	end, 50)
end

local function getPlayerReportWidget(id)
	if not playerReportWindow then
		return nil
	end

	return playerReportWindow:recursiveGetChildById(id)
end

local REASON_ROW_COLOR_A = "#484848"
local REASON_ROW_COLOR_B = "#414141"
local REASON_ROW_COLOR_SELECTED = "#585858"
local TEXT_MAX_LENGTH = 300

local function updatePlayerReportStep2State()
	if not playerReportWindow or not pendingPlayerReport or pendingPlayerReport.step ~= 2 then
		return
	end

	local commentText = getPlayerReportWidget("commentText")
	local commentHint = getPlayerReportWidget("commentHint")
	local commentCounter = getPlayerReportWidget("commentCounter")
	local nextButton = getPlayerReportWidget("nextButton")
	local translationCounter = getPlayerReportWidget("translationCounter")
	local translationText = getPlayerReportWidget("translationText")
	local hasComment = commentText and commentText:getText() ~= ""

	if commentHint then
		commentHint:setVisible(not hasComment)
	end

	if commentCounter then
		commentCounter:setVisible(hasComment)

		if hasComment then
			local remaining = TEXT_MAX_LENGTH - #commentText:getText()

			commentCounter:setText(tostring(remaining) .. tr(" characters left"))
		end
	end

	if nextButton then
		nextButton:setEnabled(hasComment)
	end

	if translationCounter and translationText then
		local remaining = TEXT_MAX_LENGTH - #translationText:getText()

		translationCounter:setText(tostring(remaining) .. tr(" characters left"))
	end
end

local function blurPlayerReportEditableFields()
	if not playerReportWindow then
		return
	end

	for _, widgetId in ipairs({
		"translationText",
		"commentText"
	}) do
		local field = getPlayerReportWidget(widgetId)

		if field then
			field:setCursorVisible(false)
		end
	end

	pcall(function()
		playerReportWindow:ungrabKeyboard()
	end)
end

local function focusPlayerReportEditableField(field)
	if not field or field:isDestroyed() or not playerReportWindow then
		return
	end

	for _, widgetId in ipairs({
		"translationText",
		"commentText"
	}) do
		local other = getPlayerReportWidget(widgetId)

		if other and other ~= field and not other:isDestroyed() then
			other:setCursorVisible(false)
		end
	end

	for _, blockId in ipairs({
		"translationBlock",
		"commentBlock"
	}) do
		local block = getPlayerReportWidget(blockId)

		if block and not block:isDestroyed() then
			block:focusChild(nil, MouseFocusReason)
		end
	end

	playerReportWindow:raise()
	playerReportWindow:focus()
	pcall(function()
		playerReportWindow:grabKeyboard()
	end)
	field:focus()
	field:setCursorVisible(true)
	field:blinkCursor()
end

local function attachPlayerReportEditableField(widget)
	if not widget then
		return
	end

	widget:setCursorVisible(false)

	function widget:onMousePress(mousePos, button)
		if button == MouseLeftButton then
			focusPlayerReportEditableField(self)
		end

		return false
	end

	function widget:onFocusChange(focused)
		if not focused then
			self:setCursorVisible(false)
		end
	end

	function widget.onTextChange()
		updatePlayerReportStep2State()
	end
end

local function setupPlayerReportStep2Fields()
	attachPlayerReportEditableField(getPlayerReportWidget("commentText"))
	attachPlayerReportEditableField(getPlayerReportWidget("translationText"))
end

local STEP2_STATEMENT_LAYOUT = {
	statementBlockHeight = 91,
	commentTextHeight = 73,
	commentBlockHeight = 106,
	translationTextHeight = 74,
	translationBlockHeight = 110,
	statementTextHeight = 73
}
local STEP2_NAME_LAYOUT = {
	statementBlockHeight = 0,
	commentTextHeight = 121,
	commentBlockHeight = 163,
	translationTextHeight = 122,
	translationBlockHeight = 158
}
local STEP2_BOT_LAYOUT = {
	statementBlockHeight = 0,
	commentTextHeight = 284,
	commentBlockHeight = 328,
	translationTextHeight = 0,
	translationBlockHeight = 0
}

local function configurePlayerReportStep2Layout(reportType, targetName)
	if not playerReportWindow then
		return
	end

	local statementBlock = getPlayerReportWidget("statementBlock")
	local statementText = getPlayerReportWidget("statementText")
	local translationBlock = getPlayerReportWidget("translationBlock")
	local translationText = getPlayerReportWidget("translationText")
	local commentBlock = getPlayerReportWidget("commentBlock")
	local commentText = getPlayerReportWidget("commentText")
	local commentCaption = getPlayerReportWidget("commentCaption")
	local step2Label = getPlayerReportWidget("step2Label")
	local layout

	if reportType == ReportType.Statement then
		layout = STEP2_STATEMENT_LAYOUT
	elseif reportType == ReportType.Bot then
		layout = STEP2_BOT_LAYOUT
	else
		layout = STEP2_NAME_LAYOUT
	end

	if reportType == ReportType.Statement then
		statementBlock:setVisible(true)
		statementBlock:setHeight(layout.statementBlockHeight)
		statementText:setHeight(layout.statementTextHeight)
		translationBlock:setMarginTop(6)
		translationBlock:setVisible(true)
		step2Label:setText(tr("Step 2 of 3:\nAdd details on the statement report."))
	elseif reportType == ReportType.Bot then
		statementBlock:setVisible(false)
		statementBlock:setHeight(0)
		translationBlock:setVisible(false)
		translationBlock:setHeight(0)
		step2Label:setText(tr("Step 2 of 3:\nAdd details on the report of \"%s\".", targetName or ""))
	else
		statementBlock:setVisible(false)
		statementBlock:setHeight(0)
		translationBlock:setMarginTop(1)
		translationBlock:setVisible(true)
		step2Label:setText(tr("Step 2 of 3:\nAdd details on the report of \"%s\".", targetName or ""))
	end

	if reportType ~= ReportType.Bot then
		translationBlock:setHeight(layout.translationBlockHeight)
		translationText:setHeight(layout.translationTextHeight)
	end

	commentBlock:setHeight(layout.commentBlockHeight)
	commentText:setHeight(layout.commentTextHeight)

	if commentCaption then
		if reportType == ReportType.Bot then
			commentCaption:setMarginTop(-10)
		else
			commentCaption:setMarginTop(0)
		end
	end
end

local function setPlayerReportStatementText(text)
	local statementField = getPlayerReportWidget("statementText")

	if not statementField then
		return
	end

	statementField:setText(text or "")
	addEvent(function()
		if statementField:isDestroyed() then
			return
		end

		statementField:wrapText()
	end)
end

local function updatePlayerReportReasonSelectionState()
	if not playerReportWindow or not pendingPlayerReport or pendingPlayerReport.step ~= 1 then
		return
	end

	local reasonList = getPlayerReportWidget("reasonList")
	local hintLabel = getPlayerReportWidget("reasonSelectHint")
	local nextButton = getPlayerReportWidget("nextButton")
	local hasSelection = reasonList and reasonList:getFocusedChild() ~= nil

	if hintLabel then
		hintLabel:setVisible(not hasSelection)
	end

	if nextButton then
		nextButton:setEnabled(hasSelection)
	end
end

local function updatePlayerReportReasonDescription(reasonLabel)
	local descLabel = getPlayerReportWidget("reasonDescriptionLabel")

	if not descLabel then
		return
	end

	if reasonLabel and reasonLabel.reasonDescription then
		descLabel:setText(reasonLabel.reasonDescription)
		addEvent(function()
			if descLabel:isDestroyed() then
				return
			end

			descLabel:wrapText()
		end)
	else
		descLabel:setText("")
	end
end

local function refreshPlayerReportReasons(reasons)
	if not playerReportWindow then
		return
	end

	local reasonList = getPlayerReportWidget("reasonList")

	reasonList:destroyChildren()

	for index, reason in ipairs(reasons) do
		local label = g_ui.createWidget("ReportReasonListLabel", reasonList)

		label:setText(reason.title)

		label.reasonId = reason.id
		label.reasonDescription = reason.description

		local zebraColor = index % 2 == 1 and REASON_ROW_COLOR_A or REASON_ROW_COLOR_B

		label.zebraColor = zebraColor

		label:setBackgroundColor(zebraColor)

		function label.onFocusChange(widget, focused)
			if focused then
				widget:setBackgroundColor(REASON_ROW_COLOR_SELECTED)
				updatePlayerReportReasonDescription(widget)
			else
				addEvent(function()
					if not widget:isDestroyed() then
						widget:setBackgroundColor(widget.zebraColor or REASON_ROW_COLOR_A)
					end
				end)
			end

			addEvent(function()
				updatePlayerReportReasonSelectionState()
			end)
		end
	end

	updatePlayerReportReasonDescription(nil)
	updatePlayerReportReasonSelectionState()
end

local function setPlayerReportSummaryFieldText(field, text)
	if not field then
		return
	end

	field:setText(text or "")
	addEvent(function()
		if field:isDestroyed() then
			return
		end

		field:wrapText()
	end)
end

local STEP3_STATEMENT_SUMMARY = {
	translationBlockHeight = 92,
	commentTextHeight = 89,
	commentBlockHeight = 92,
	translationTextHeight = 89,
	translationMarginTop = 0
}
local STEP3_NAME_SUMMARY = {
	translationBlockHeight = 138,
	commentTextHeight = 134,
	commentBlockHeight = 137,
	translationTextHeight = 135,
	translationMarginTop = 0
}

local function applyStep3SummaryLayout(reportType)
	local translationBlock = getPlayerReportWidget("summaryTranslationBlock")
	local translationText = getPlayerReportWidget("summaryTranslationText")
	local commentBlock = getPlayerReportWidget("summaryCommentBlock")
	local commentText = getPlayerReportWidget("summaryCommentText")

	if not translationBlock or not translationText or not commentBlock or not commentText then
		return
	end

	local layout

	if reportType == ReportType.Name then
		layout = STEP3_NAME_SUMMARY
	elseif reportType == ReportType.Bot then
		layout = STEP3_NAME_SUMMARY
	else
		layout = STEP3_STATEMENT_SUMMARY
	end

	translationBlock:breakAnchors()

	if reportType == ReportType.Name then
		translationBlock:addAnchor(AnchorTop, "summaryReasonRow", AnchorBottom)
	elseif reportType == ReportType.Bot then
		translationBlock:setVisible(false)
		translationBlock:setHeight(0)
	else
		translationBlock:addAnchor(AnchorTop, "summaryStatementBlock", AnchorBottom)
	end

	if reportType ~= ReportType.Bot then
		translationBlock:addAnchor(AnchorLeft, "parent", AnchorLeft)
		translationBlock:addAnchor(AnchorRight, "parent", AnchorRight)
		translationBlock:setMarginTop(layout.translationMarginTop)
		translationBlock:setHeight(layout.translationBlockHeight)
		translationText:setHeight(layout.translationTextHeight)
	end

	if reportType == ReportType.Bot then
		commentBlock:breakAnchors()
		commentBlock:addAnchor(AnchorTop, "summaryReasonRow", AnchorBottom)
		commentBlock:addAnchor(AnchorLeft, "parent", AnchorLeft)
		commentBlock:addAnchor(AnchorRight, "parent", AnchorRight)
		commentBlock:setMarginTop(0)
		commentBlock:setHeight(275)
		commentText:setHeight(271)
	else
		commentBlock:setHeight(layout.commentBlockHeight)
		commentText:setHeight(layout.commentTextHeight)
	end
end

local function updatePlayerReportSummary()
	if not playerReportWindow or not pendingPlayerReport then
		return
	end

	getPlayerReportWidget("summaryNameText"):setText(pendingPlayerReport.targetName or "")
	getPlayerReportWidget("summaryReasonText"):setText(pendingPlayerReport.reasonText or "")

	local statementBlock = getPlayerReportWidget("summaryStatementBlock")
	local translationBlock = getPlayerReportWidget("summaryTranslationBlock")
	local isStatementReport = pendingPlayerReport.reportType == ReportType.Statement

	applyStep3SummaryLayout(pendingPlayerReport.reportType)

	if isStatementReport then
		statementBlock:setVisible(true)
		statementBlock:setHeight(92)
		translationBlock:setVisible(true)
		setPlayerReportSummaryFieldText(getPlayerReportWidget("summaryStatementText"), getPlayerReportWidget("statementText"):getText())
		setPlayerReportSummaryFieldText(getPlayerReportWidget("summaryTranslationText"), getPlayerReportWidget("translationText"):getText())
	elseif pendingPlayerReport.reportType == ReportType.Bot then
		statementBlock:setVisible(false)
		statementBlock:setHeight(0)
		translationBlock:setVisible(false)
		translationBlock:setHeight(0)
	else
		statementBlock:setVisible(false)
		statementBlock:setHeight(0)
		translationBlock:setVisible(true)
		setPlayerReportSummaryFieldText(getPlayerReportWidget("summaryTranslationText"), getPlayerReportWidget("translationText"):getText())
	end

	setPlayerReportSummaryFieldText(getPlayerReportWidget("summaryCommentText"), getPlayerReportWidget("commentText"):getText())
end

local function updatePlayerReportBackButtonAnchor(step)
	local backButton = getPlayerReportWidget("backButton")

	if not backButton then
		return
	end

	backButton:breakAnchors()

	if step == 3 then
		backButton:addAnchor(AnchorRight, "sendButton", AnchorLeft)
	else
		backButton:addAnchor(AnchorRight, "nextButton", AnchorLeft)
	end

	backButton:addAnchor(AnchorBottom, "parent", AnchorBottom)
	backButton:setMarginRight(6)
end

local function showPlayerReportStep(step)
	if not playerReportWindow then
		return
	end

	pendingPlayerReport.step = step

	getPlayerReportWidget("step1Panel"):setVisible(step == 1)
	getPlayerReportWidget("step2Panel"):setVisible(step == 2)
	getPlayerReportWidget("step3Panel"):setVisible(step == 3)
	getPlayerReportWidget("backButton"):setVisible(step > 1)
	getPlayerReportWidget("nextButton"):setVisible(step < 3)
	getPlayerReportWidget("sendButton"):setVisible(step == 3)
	updatePlayerReportBackButtonAnchor(step)

	if step == 1 then
		updatePlayerReportReasonSelectionState()
	elseif step == 2 then
		updatePlayerReportStep2State()
		addEvent(function()
			if not playerReportWindow then
				return
			end

			blurPlayerReportEditableFields()
			getPlayerReportWidget("backButton"):focus()
		end)
	elseif step < 3 then
		getPlayerReportWidget("nextButton"):setEnabled(true)
	end

	if step == 3 then
		updatePlayerReportSummary()
	end
end

function hidePlayerReportWindow()
	if playerReportWindow then
		playerReportWindow:destroy()

		playerReportWindow = nil
	end

	pendingPlayerReport = nil
end

function backPlayerReportStep()
	if not playerReportWindow or not pendingPlayerReport then
		return
	end

	local step = pendingPlayerReport.step or 1

	if step > 1 then
		showPlayerReportStep(step - 1)
	end
end

function nextPlayerReportStep()
	if not playerReportWindow or not pendingPlayerReport then
		return
	end

	local step = pendingPlayerReport.step or 1

	if step == 1 then
		local reasonList = getPlayerReportWidget("reasonList")
		local reasonLabel = reasonList:getFocusedChild()

		if not reasonLabel then
			displayErrorBox(tr("Error"), tr("You must select a reason."))

			return
		end

		pendingPlayerReport.reasonId = reasonLabel.reasonId
		pendingPlayerReport.reasonText = reasonLabel:getText()
		pendingPlayerReport.reasonDescription = reasonLabel.reasonDescription
	elseif step == 2 then
		local comment = getPlayerReportWidget("commentText"):getText()

		if comment == "" then
			displayErrorBox(tr("Error"), tr("You must enter a comment."))

			return
		end

		local translation = getPlayerReportWidget("translationText"):getText()

		if pendingPlayerReport.reportType == ReportType.Statement and translation == "" then
			displayErrorBox(tr("Error"), tr("You must enter a translation."))

			return
		end
	end

	if step < 3 then
		showPlayerReportStep(step + 1)
	end
end

function submitPlayerReport()
	if not playerReportWindow or not pendingPlayerReport then
		return
	end

	if (pendingPlayerReport.step or 1) ~= 3 then
		nextPlayerReportStep()

		return
	end

	local reasonId = pendingPlayerReport.reasonId

	if not reasonId then
		displayErrorBox(tr("Error"), tr("You must select a reason."))

		return
	end

	local comment = getPlayerReportWidget("commentText"):getText()

	if comment == "" then
		displayErrorBox(tr("Error"), tr("You must enter a comment."))

		return
	end

	local translation = ""

	if pendingPlayerReport.reportType == ReportType.Statement then
		translation = getPlayerReportWidget("translationText"):getText()

		if translation == "" then
			displayErrorBox(tr("Error"), tr("You must enter a translation."))

			return
		end
	elseif pendingPlayerReport.reportType == ReportType.Name then
		translation = getPlayerReportWidget("translationText"):getText()
	end

	local statementId = pendingPlayerReport.statementId or 0

	if pendingPlayerReport.reportType == ReportType.Statement and statementId == 0 then
		displayErrorBox(tr("Error"), tr("This message cannot be reported."))

		return
	end

	local targetName = pendingPlayerReport.targetName or ""

	g_game.reportRuleViolationReport(pendingPlayerReport.reportType, reasonId, targetName, comment, translation, statementId)
	hidePlayerReportWindow()
end

local function openPlayerReportWindow(reportType, targetName, statementText, statementId)
	if not g_game.isOnline() then
		return false
	end

	hidePlayerReportWindow()

	pendingPlayerReport = {
		step = 1,
		reportType = reportType,
		targetName = targetName,
		statementId = statementId or 0
	}
	playerReportWindow = g_ui.displayUI("statementreport")

	if not playerReportWindow then
		pendingPlayerReport = nil

		modules.game_textmessage.displayFailureMessage(tr("Failed to open report window."))

		return false
	end

	local translationField = getPlayerReportWidget("translationText")
	local step3Label = getPlayerReportWidget("step3Label")

	setupPlayerReportStep2Fields()

	if reportType == ReportType.Statement then
		playerReportWindow:setText(tr("Report Statement"))
		step3Label:setText(tr("Step 3 of 3:\nPlease verify your Statement report. If everything is correct, click on 'Send' to forward the report to customer support."))
		refreshPlayerReportReasons(StatementReportReasons)
	elseif reportType == ReportType.Bot then
		playerReportWindow:setText(tr("Report Bot/Macro"))
		step3Label:setText(tr("Step 3 of 3:\nPlease verify your Bot/Macro report. If everything is correct, click on 'Send' to forward the report to customer support."))
		refreshPlayerReportReasons(BotReportReasons)
	else
		playerReportWindow:setText(tr("Report Name"))
		step3Label:setText(tr("Step 3 of 3:\nPlease verify your Name report. If everything is correct, click on 'Send' to forward the report to customer support."))
		refreshPlayerReportReasons(NameReportReasons)
	end

	configurePlayerReportStep2Layout(reportType, targetName)

	if reportType == ReportType.Statement then
		setPlayerReportStatementText(statementText)
	end

	translationField:setText("")
	getPlayerReportWidget("commentText"):setText("")
	updatePlayerReportStep2State()
	showPlayerReportStep(1)
	playerReportWindow:show()
	playerReportWindow:raise()
	playerReportWindow:focus()

	return true
end

function openStatementReport(target, statement, statementId)
	if not g_game.isOnline() then
		return false
	end

	if hasWindowAccess() then
		show(target, statement)
		focusReasonAndAction(5, 6)

		return true
	end

	if (statementId or 0) == 0 then
		modules.game_textmessage.displayFailureMessage(tr("This message cannot be reported."))

		return false
	end

	return openPlayerReportWindow(ReportType.Statement, target, statement, statementId)
end

function openNameReport(target)
	if not g_game.isOnline() then
		return false
	end

	if hasWindowAccess() then
		show(target, nil)
		focusReasonAndAction(1, 1)

		return true
	end

	return openPlayerReportWindow(ReportType.Name, target, nil, 0)
end

function openBotMacroReport(target)
	if not g_game.isOnline() then
		return false
	end

	if hasWindowAccess() then
		show(target, nil)
		focusReasonAndAction(13, 1)

		return true
	end

	return openPlayerReportWindow(ReportType.Bot, target, nil, 0)
end

function hide()
	ruleViolationWindow:hide()
	clearForm()
end

function onSelectReason(reasonLabel, focused)
	if reasonLabel.actionFlags and focused then
		actionsTextList:destroyChildren()

		for actionBaseFlag = 0, #rvactions do
			local actionFlagString = rvactions[actionBaseFlag]

			if bit.band(reasonLabel.actionFlags, math.pow(2, actionBaseFlag)) > 0 then
				local label = g_ui.createWidget("RVListLabel", actionsTextList)

				label:setText(actionFlagString)

				label.actionId = actionBaseFlag
			end
		end
	end
end

function report()
	local reasonLabel = reasonsTextList:getFocusedChild()

	if not reasonLabel then
		displayErrorBox(tr("Error"), tr("You must select a reason."))

		return
	end

	local actionLabel = actionsTextList:getFocusedChild()

	if not actionLabel then
		displayErrorBox(tr("Error"), tr("You must select an action."))

		return
	end

	local target = ruleViolationWindow:getChildById("nameText"):getText()
	local reason = reasonLabel.reasonId
	local action = actionLabel.actionId
	local comment = ruleViolationWindow:getChildById("commentText"):getText()
	local statement = ruleViolationWindow:getChildById("statementText"):getText()
	local statementId = 0
	local ipBanishment = ruleViolationWindow:getChildById("ipBanCheckBox"):isChecked()

	if action == 6 and statement == "" then
		displayErrorBox(tr("Error"), tr("No statement has been selected."))
	elseif comment == "" then
		displayErrorBox(tr("Error"), tr("You must enter a comment."))
	else
		g_game.reportRuleViolation(target, reason, action, comment, statement, statementId, ipBanishment)
		hide()
	end
end

function clearForm()
	ruleViolationWindow:getChildById("nameText"):clearText()
	ruleViolationWindow:getChildById("commentText"):clearText()
	ruleViolationWindow:getChildById("statementText"):clearText()
	ruleViolationWindow:getChildById("ipBanCheckBox"):setChecked(false)
end
