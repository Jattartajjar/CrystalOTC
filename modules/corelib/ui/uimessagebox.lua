-- chunkname: @/corelib/ui/uimessagebox.lua

if not UIMiniWindow then
	dofile("uiminiwindow")
end

UIMessageBox = extends(UIMiniWindow, "UIMessageBox")

function UIMessageBox.create(title, okCallback, cancelCallback)
	local calendar = UIMessageBox.internalCreate()

	return calendar
end

local function formatWrappedText(str, maxCharsPerLine)
	if not str or type(str) ~= "string" or #str == 0 then
		return str or ""
	end

	maxCharsPerLine = maxCharsPerLine or 86

	local resultLines = {}
	local pos = 1
	while pos <= #str do
		local lineEnd = str:find("\n", pos, true) or (#str + 1)
		local paragraph = str:sub(pos, lineEnd - 1):gsub("\r", "")
		pos = lineEnd + 1

		if #paragraph <= maxCharsPerLine then
			table.insert(resultLines, paragraph)
		else
			local current = ""
			for word in paragraph:gmatch("%S+") do
				if #current == 0 then
					current = word
				elseif #current + 1 + #word <= maxCharsPerLine then
					current = current .. " " .. word
				else
					table.insert(resultLines, current)
					current = word
				end
			end
			if #current > 0 then
				table.insert(resultLines, current)
			end
		end
	end

	return table.concat(resultLines, "\n")
end

function UIMessageBox.display(title, message, buttons, onEnterCallback, onEscapeCallback)
	local staticSizes = {
		width = {
			min = 504,
			max = 864
		},
		height = {
			min = 100,
			max = 600
		}
	}

	local messageBox = g_ui.createWidget("MessageBoxWindow", rootWidget)

	messageBox.title = messageBox:getChildById("title")
	messageBox.title:setText(title)

	local formattedMessage = formatWrappedText(message, 86)
	messageBox.content = messageBox:getChildById("content")
	messageBox.content:setText(formattedMessage)

	if messageBox.content.setFont then
		messageBox.content:setFont("Verdana Bold-11px-new")
	end

	if messageBox.content.setTextAlign then
		messageBox.content:setTextAlign(AlignCenter)
	end

	if messageBox.content.resizeToText then
		messageBox.content:resizeToText()
	end

	messageBox.holder = messageBox:getChildById("holder")

	local totalButtonsWidth = 0
	local buttonHeight = 22
	for i = 1, #buttons do
		local button = messageBox:addButton(buttons[i].text, buttons[i].callback)

		button:addAnchor(AnchorTop, "parent", AnchorTop)
		button:setTextOffset(topoint(0 .. " " .. 0))
		buttonHeight = math.max(buttonHeight, button:getHeight())

		if i == 1 then
			button:addAnchor(AnchorRight, "parent", AnchorRight)
			totalButtonsWidth = totalButtonsWidth + button:getWidth()
		else
			button:addAnchor(AnchorRight, "prev", AnchorLeft)
			button:setMarginRight(6)
			totalButtonsWidth = totalButtonsWidth + button:getWidth() + 6
		end
	end

	local titleWidth = (messageBox.title.getTextSize and messageBox.title:getTextSize().width) or 100
	local contentWidth = messageBox.content:getWidth()
	local contentHeight = messageBox.content:getHeight()

	local targetWidth = math.max(staticSizes.width.min, math.max(contentWidth + 48, titleWidth + 48, totalButtonsWidth + 48))
	targetWidth = math.min(staticSizes.width.max, targetWidth)

	local targetHeight = 29 + contentHeight + 11 + 2 + 11 + buttonHeight + 16
	targetHeight = math.min(staticSizes.height.max, math.max(staticSizes.height.min, targetHeight))

	messageBox:setWidth(targetWidth)
	messageBox:setHeight(targetHeight)

	if onEnterCallback then
		connect(messageBox, {
			onEnter = onEnterCallback
		})
	end

	if onEscapeCallback then
		connect(messageBox, {
			onEscape = onEscapeCallback
		})
	end

	messageBox:raise()
	messageBox:focus()
	g_modalManager.show(messageBox)

	return messageBox
end

function displayInfoBox(title, message)
	local messageBox
	local hideImbue = false
	local Im = modules.game_imbuing and modules.game_imbuing.Imbuement
	local awaiting = Im and Im.awaitingFyiRestore
	local isNotice = false

	if type(title) == "string" then
		local tl = title:lower()

		isNotice = tl == "for your information" or tl == tr("For Your Information"):lower() or tl == "info" or tl == tr("Info"):lower() or tl == "information" or tl == tr("Information"):lower() or tl == "informação" or tl == "informacao"
	end

	if (isNotice or awaiting) and Im and Im.tryHideForOverlay then
		hideImbue = Im:tryHideForOverlay()
	end

	if (isNotice or awaiting) and Im and Im.hide and Im.window and not Im.window:isDestroyed() and Im.window:isVisible() then
		Im:hide()

		hideImbue = true
	end

	local function defaultCallback()
		if hideImbue then
			g_client.setInputLockWidget(nil)
		end

		messageBox:ok()

		if hideImbue and g_game.isOnline() then
			local Im = modules.game_imbuing and modules.game_imbuing.Imbuement

			if Im and Im.tryShowAfterOverlay then
				Im:tryShowAfterOverlay()
			end
		end
	end

	messageBox = UIMessageBox.display(title, message, {
		{
			text = "Ok",
			callback = defaultCallback
		}
	}, defaultCallback, defaultCallback)

	if hideImbue then
		messageBox:raise()
		messageBox:focus()
		g_client.setInputLockWidget(messageBox)
	end

	return messageBox
end

function displayErrorBox(title, message)
	local messageBox

	local function defaultCallback()
		messageBox:ok()
	end

	messageBox = UIMessageBox.display(title, message, {
		{
			text = "Ok",
			callback = defaultCallback
		}
	}, defaultCallback, defaultCallback)

	return messageBox
end

function displayCancelBox(title, message)
	local messageBox

	local function defaultCallback()
		messageBox:cancel()
	end

	messageBox = UIMessageBox.display(title, message, {
		{
			text = "Cancel",
			callback = defaultCallback
		}
	}, defaultCallback, defaultCallback)

	return messageBox
end

function displayGeneralBox(title, message, buttons, onEnterCallback, onEscapeCallback)
	return UIMessageBox.display(title, message, buttons, onEnterCallback, onEscapeCallback)
end

function UIMessageBox.displayModalHigh(title, message, buttons, onEnterCallback, onEscapeCallback, size, fitSingleLine)
	local messageBox = g_ui.createWidget("ModalHigh", rootWidget)

	if size and not fitSingleLine then
		local sizeStr = tostring(size)

		if sizeStr:match("^%d+%s+%d+$") then
			messageBox:setSize(sizeStr)
		end
	end

	messageBox.title = messageBox:getChildById("title")

	messageBox.title:setText(title)

	messageBox.content = messageBox:getChildById("content")

	messageBox.content:setText(message)

	if fitSingleLine then
		messageBox.content:setTextWrap(false)
		messageBox:setSize("3000 400")

		if messageBox.content.resizeToText then
			messageBox.content:resizeToText()
		end

		local ts = messageBox.content:getTextSize()
		local textW = math.max(ts.width, messageBox.content:getWidth())
		local textH = math.max(ts.height, messageBox.content:getHeight())
		local titleTs = messageBox.title:getTextSize()
		local winW = math.max(320, textW + 48, titleTs.width + 48)
		local winH = math.max(100, textH + 90)

		messageBox:setSize(string.format("%d %d", winW, winH))
	else
		messageBox.content:setTextWrap(true)

		local textWidth = math.max(280, messageBox:getWidth() - 48)

		messageBox.content:setWidth(textWidth)

		if messageBox.content.resizeToText then
			messageBox.content:resizeToText()
		end
	end

	messageBox.holder = messageBox:getChildById("holder")

	for i = 1, #buttons do
		local button = messageBox:addButton(buttons[i].text, buttons[i].callback)

		button:setWidth(43)
		button:setHeight(20)
		button:addAnchor(AnchorTop, "parent", AnchorTop)
		button:setTextOffset(topoint(0 .. " " .. 0))

		if i == 1 then
			button:addAnchor(AnchorRight, "parent", AnchorRight)
			button:setMarginRight(10)
		else
			button:addAnchor(AnchorRight, "prev", AnchorLeft)
			button:setMarginRight(6)
		end
	end

	if onEnterCallback then
		connect(messageBox, {
			onEnter = onEnterCallback
		})
	end

	if onEscapeCallback then
		connect(messageBox, {
			onEscape = onEscapeCallback
		})
	end

	return messageBox
end

function displayModalHigh(title, message, buttons, onEnterCallback, onEscapeCallback, size, fitSingleLine)
	return UIMessageBox.displayModalHigh(title, message, buttons, onEnterCallback, onEscapeCallback, size, fitSingleLine)
end

function UIMessageBox.displayImbueSuccessInfo(onAfterClose, title, message, size)
	title = title or tr("Info")
	message = message or tr("Congratulations! You have successfully imbued your item.")

	local messageBox = g_ui.createWidget("ImbueSuccessInfoModal", rootWidget)

	if size then
		local sizeStr = tostring(size)

		if sizeStr:match("^%d+%s+%d+$") then
			messageBox:setSize(sizeStr)
		end
	end

	messageBox.title = messageBox:getChildById("title")

	messageBox.title:setText(title)

	messageBox.content = messageBox:getChildById("content")

	messageBox.content:setText(message)

	messageBox.holder = messageBox:getChildById("holder")

	local function closeSuccess()
		g_client.setInputLockWidget(nil)

		if messageBox and not messageBox:isDestroyed() then
			messageBox:destroy()
		end

		if onAfterClose then
			onAfterClose()
		end
	end

	local btn = messageBox:addButton(tr("Ok"), closeSuccess)

	btn:setWidth(43)
	btn:setHeight(20)
	btn:addAnchor(AnchorTop, "parent", AnchorTop)
	btn:addAnchor(AnchorRight, "parent", AnchorRight)
	btn:setMarginRight(12)
	connect(messageBox, {
		onEnter = closeSuccess,
		onEscape = closeSuccess
	})
	messageBox:raise()
	messageBox:focus()
	g_client.setInputLockWidget(messageBox)

	return messageBox
end

function displayImbueSuccessInfo(onAfterClose, title, message, size)
	return UIMessageBox.displayImbueSuccessInfo(onAfterClose, title, message, size)
end

local suppressShopDoNotShowOptionWrite = false

local function syncShopDoNotShowCheckbox(messageBox)
	local checkbox = messageBox:recursiveGetChildById("doNotShowAgain")

	if not checkbox then
		return
	end

	local askBeforeBuying = true

	if modules.client_options and modules.client_options.getOption then
		local value = modules.client_options.getOption("askBeforeBuying")

		if value ~= nil then
			askBeforeBuying = value
		end
	end

	suppressShopDoNotShowOptionWrite = true

	checkbox:setChecked(not askBeforeBuying)

	suppressShopDoNotShowOptionWrite = false
end

local function onShopDoNotShowAgainChange(checkbox, checked)
	if suppressShopDoNotShowOptionWrite then
		return
	end

	if not modules.client_options or not modules.client_options.setOption then
		return
	end

	local doNotShowAgain = checked

	if doNotShowAgain == nil and checkbox and checkbox.isChecked then
		doNotShowAgain = checkbox:isChecked()
	end

	modules.client_options.setOption("askBeforeBuying", not doNotShowAgain, true)
end

function applyShopDoNotShowAgainPreference(shopWindow)
	if not shopWindow or shopWindow:isDestroyed() then
		return
	end

	local checkbox = shopWindow:recursiveGetChildById("doNotShowAgain")

	if checkbox and checkbox:isChecked() and modules.client_options and modules.client_options.setOption then
		modules.client_options.setOption("askBeforeBuying", false, true)
	end
end

function releaseShopMessageBoxRefs(messageBox)
	if not messageBox then
		return
	end

	if messageBox.doNotShowAgain and not messageBox.doNotShowAgain:isDestroyed() then
		disconnect(messageBox.doNotShowAgain, {
			onCheckChange = onShopDoNotShowAgainChange
		})
	end

	messageBox.doNotShowAgain = nil
	messageBox.title = nil
	messageBox.content = nil
	messageBox.additionalLabel = nil
	messageBox.productLine = nil
	messageBox.priceLine = nil
	messageBox.priceRow = nil
	messageBox.priceLabel = nil
	messageBox.priceAmount = nil
	messageBox.priceCoin = nil
	messageBox.detailsPanel = nil
	messageBox.holder = nil
	messageBox.Box = nil
	messageBox.onOk = nil
	messageBox.onCancel = nil
end

function displayGeneralSHOPBox(title, message, productLine, priceAmount, priceIcon, buttons, onEnterCallback, onEscapeCallback)
	return UIMessageBox.displaySHOP(title, message, productLine, priceAmount, priceIcon, buttons, onEnterCallback, onEscapeCallback)
end

function UIMessageBox:addButton(text, callback)
	local holder = self:getChildById("holder")
	local button = g_ui.createWidget("Button", holder)

	button:setWidth(math.max(43, string.len(text) * 8))
	button:setHeight(20)
	button:setText(text)
	connect(button, {
		onClick = callback
	})

	return button
end

function UIMessageBox:ok()
	signalcall(self.onOk, self)

	self.onOk = nil

	self:destroy()
end

function UIMessageBox:cancel()
	signalcall(self.onCancel, self)

	self.onCancel = nil

	self:destroy()
end

function UIMessageBox.displaySHOP(title, message, productLine, priceAmount, priceIcon, buttons, onEnterCallback, onEscapeCallback)
	local staticSizes = {
		width = {
			min = 390,
			max = 390
		},
		height = {
			min = 205,
			max = 616
		}
	}
	local currentSizes = {
		width = 0,
		height = 0
	}
	local messageBox = g_ui.createWidget("MessageBoxShopWindow", rootWidget)

	messageBox.title = messageBox:getChildById("title")

	messageBox.title:setText(title)
	messageBox.title:setTextAutoResize(true)

	messageBox.content = messageBox:getChildById("content")

	messageBox.content:setText(message)
	messageBox.content:setTextAutoResize(true)
	messageBox.content:setTextWrap(true)
	messageBox.content:setTextAlign(AlignCenter)

	messageBox.detailsPanel = messageBox:getChildById("detailsPanel")
	messageBox.productLine = messageBox:recursiveGetChildById("productLine")
	messageBox.priceRow = messageBox:recursiveGetChildById("priceRow")
	messageBox.priceLabel = messageBox:recursiveGetChildById("priceLabel")
	messageBox.priceAmount = messageBox:recursiveGetChildById("priceAmount")
	messageBox.priceCoin = messageBox:recursiveGetChildById("priceCoin")

	if messageBox.productLine then
		messageBox.productLine:setText(productLine or "")
		messageBox.productLine:setTextWrap(true)

		if messageBox.productLine.setTextAlign then
			messageBox.productLine:setTextAlign(AlignTopLeft)
		end
	end

	if messageBox.priceAmount then
		messageBox.priceAmount:setText(tostring(priceAmount or ""))
	end

	if messageBox.priceCoin and priceIcon then
		messageBox.priceCoin:setImageSource(priceIcon)
	end

	messageBox.doNotShowAgain = messageBox:recursiveGetChildById("doNotShowAgain")

	if messageBox.doNotShowAgain then
		syncShopDoNotShowCheckbox(messageBox)
		connect(messageBox.doNotShowAgain, {
			onCheckChange = onShopDoNotShowAgainChange
		})
	end

	local contentWidth = messageBox.content:getTextSize().width + messageBox.content:getPaddingLeft() + messageBox.content:getPaddingRight()
	local contentHeight = messageBox.content:getHeight() + messageBox.content:getPaddingTop() + messageBox.content:getPaddingBottom()

	currentSizes.width = math.max(staticSizes.width.min, contentWidth + 32)

	local box = messageBox:getChildById("Box")
	local detailsPanel = messageBox.detailsPanel
	local productRowHeight = (box and box:getMarginTop() or 11) + math.max(box and box:getHeight() or 80, detailsPanel and detailsPanel:getHeight() or 80)
	local doNotShowPanel = messageBox:getChildById("doNotShowAgainPanel")
	local checkboxRowHeight = 0

	if doNotShowPanel then
		checkboxRowHeight = doNotShowPanel:getMarginTop() + doNotShowPanel:getHeight()
	elseif messageBox.doNotShowAgain then
		checkboxRowHeight = 8 + messageBox.doNotShowAgain:getHeight()
	end

	currentSizes.height = 29 + contentHeight + productRowHeight + checkboxRowHeight + 30
	messageBox.holder = messageBox:getChildById("holder")

	local buyButton = messageBox:addButton(buttons[1].text, buttons[1].callback)
	local cancelButton = messageBox:addButton(buttons[2].text, buttons[2].callback)

	buyButton:setSize("43 20")
	buyButton:setImageSource("/images/ui/buttons-blue")
	buyButton:setImageClip("0 0 43 20")
	buyButton:setImageBorder(1)
	buyButton:addAnchor(AnchorTop, "parent", AnchorTop)
	cancelButton:setSize("43 20")
	cancelButton:setImageSource("/images/ui/buttons")
	cancelButton:setImageClip("0 0 43 20")
	cancelButton:setImageBorder(1)
	cancelButton:addAnchor(AnchorTop, "parent", AnchorTop)
	cancelButton:addAnchor(AnchorRight, "parent", AnchorRight)
	cancelButton:setMarginRight(6)
	buyButton:addAnchor(AnchorRight, cancelButton:getId(), AnchorLeft)
	buyButton:setMarginRight(6)
	connect(buyButton, {
		onMousePress = function(self)
			self:setImageClip("0 20 43 20")
		end,
		onMouseRelease = function(self)
			self:setImageClip("0 0 43 20")
		end
	})
	connect(cancelButton, {
		onMousePress = function(self)
			self:setImageClip("0 20 43 20")
		end,
		onMouseRelease = function(self)
			self:setImageClip("0 0 43 20")
		end
	})

	currentSizes.height = currentSizes.height + buyButton:getHeight() + 22 - 15

	messageBox:setWidth(currentSizes.width)
	messageBox:setHeight(math.min(staticSizes.height.max, math.max(staticSizes.height.min, currentSizes.height)))

	if onEnterCallback then
		connect(messageBox, {
			onEnter = onEnterCallback
		})
	end

	if onEscapeCallback then
		connect(messageBox, {
			onEscape = onEscapeCallback
		})
	end

	messageBox:raise()
	messageBox:focus()
	g_modalManager.show(messageBox)

	return messageBox
end
