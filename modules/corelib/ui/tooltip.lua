-- chunkname: @/corelib/ui/tooltip.lua

g_tooltip = {}

local toolTipLabel, SpecialToolTipLabel, currentHoveredWidget, pendingHoveredWidget, pendingTooltipEvent
local tooltipDelay = 500
local moveToolTipConnected = false

local function tooltipPointerStillOver(widget)
	if not widget then
		return false
	end

	if widget:isHovered() then
		return true
	end

	if widget:isEnabled() then
		return false
	end

	return widget:containsPoint(g_window.getMousePosition())
end

local function isWidgetOrRelatedHovered(target)
	if not target or not currentHoveredWidget then
		return false
	end

	if currentHoveredWidget == target then
		return true
	end

	local cur = currentHoveredWidget:getParent()
	while cur do
		if cur == target then
			return true
		end
		if not cur.getParent then
			break
		end
		cur = cur:getParent()
	end

	local tcur = target:getParent()
	while tcur do
		if tcur == currentHoveredWidget then
			return true
		end
		if not tcur.getParent then
			break
		end
		tcur = tcur:getParent()
	end

	return false
end

local function hasHtmlMarkup(text)
	if type(text) ~= "string" then
		return false
	end

	if text:find("<[bB][rR]%s*/?>") then
		return true
	end

	if text:find("<[/]?[lLuUoOpPbBiI][lLiI]?%s*>") then
		return true
	end

	if text:find("<[cC][oO][lL][oO][rR]%s*=") then
		return true
	end

	if text:find("</[cC][oO][lL][oO][rR]>") then
		return true
	end

	if text:find("&nbsp;") or text:find("&lt;") or text:find("&gt;") or text:find("&amp;") or text:find("&quot;") then
		return true
	end

	return false
end

local LIST_INDENT = "       "
local LIST_BULLET = "\x95 "
local TOOLTIP_MAX_WIDTH = 450
local measureLabel

local function measureTextWidth(text)
	if not measureLabel or not text or text == "" then
		return (text and #text or 0) * 7
	end

	measureLabel:setText(text, true)

	return measureLabel:getTextSize().width
end

local function wrapWords(line, maxWidth, contIndent)
	if maxWidth >= measureTextWidth(line) then
		return line
	end

	local prefix = line:match("^(%s+)") or ""
	local rest = line:sub(#prefix + 1)
	local lines = {}
	local current = prefix
	local hasWord = false

	for word in rest:gmatch("%S+") do
		local trial = hasWord and current .. " " .. word or current .. word

		if hasWord and maxWidth < measureTextWidth(trial) then
			lines[#lines + 1] = current
			current = contIndent .. word
		else
			current = trial
		end

		hasWord = true
	end

	if hasWord then
		lines[#lines + 1] = current
	end

	return table.concat(lines, "\n")
end

local function wrapTooltipText(text, maxWidth)
	if maxWidth <= 0 or type(text) ~= "string" or text == "" then
		return text
	end

	local listPrefix = LIST_INDENT .. LIST_BULLET
	local hangIndent = LIST_INDENT .. string.rep(" ", #LIST_BULLET)
	local out = {}
	local inListContinuation = false

	for line in (text .. "\n"):gmatch("([^\n]*)\n") do
		if line == "" then
			inListContinuation = false
			out[#out + 1] = line
		elseif line:sub(1, #listPrefix) == listPrefix then
			inListContinuation = true
			out[#out + 1] = wrapWords(line, maxWidth, hangIndent)
		elseif inListContinuation then
			local indentedLine = hangIndent .. line

			out[#out + 1] = wrapWords(indentedLine, maxWidth, hangIndent)
		else
			out[#out + 1] = wrapWords(line, maxWidth, "")
		end
	end

	return table.concat(out, "\n")
end

local function htmlToTooltipText(html)
	local text = html:gsub("\r", "")

	text = text:gsub("<[bB][rR]%s*/?>", "\n")
	text = text:gsub("</[lL][iI]>%s*<[lL][iI]>%s*", "\n" .. LIST_INDENT .. LIST_BULLET)
	text = text:gsub("(.?)<[lL][iI]>%s*", function(prev)
		if prev == "" or prev == "\n" then
			return prev .. LIST_INDENT .. LIST_BULLET
		end

		return prev .. "\n" .. LIST_INDENT .. LIST_BULLET
	end)
	text = text:gsub("</[lL][iI]>[ \t]*", "\n")
	text = text:gsub("%s*</?[uUoO][lL]>%s*", "\n")
	text = text:gsub("<[pP]>%s*", "")
	text = text:gsub("</[pP]>%s*", "\n")
	text = text:gsub("<[cC][oO][lL][oO][rR]%s*=%s*\"(#?%x+)\"%s*>", "[color=%1]")
	text = text:gsub("<[cC][oO][lL][oO][rR]%s*=%s*'(#?%x+)'%s*>", "[color=%1]")
	text = text:gsub("<[cC][oO][lL][oO][rR]%s*=%s*(#?%x+)%s*>", "[color=%1]")
	text = text:gsub("</[cC][oO][lL][oO][rR]>", "[/color]")
	text = text:gsub("</?[bB]>", "")
	text = text:gsub("</?[iI]>", "")
	text = text:gsub("</?[uU]>", "")
	text = text:gsub("&nbsp;", " ")
	text = text:gsub("&lt;", "<")
	text = text:gsub("&gt;", ">")
	text = text:gsub("&quot;", "\"")
	text = text:gsub("&amp;", "&")
	text = text:gsub("^\n+", "")
	text = text:gsub("\n+$", "")
	text = text:gsub("\n\n\n+", "\n\n")

	return text
end

local function cancelPendingTooltip()
	if pendingTooltipEvent then
		removeEvent(pendingTooltipEvent)

		pendingTooltipEvent = nil
	end

	pendingHoveredWidget = nil
end

local function displayWidgetTooltip(widget)
	if not widget or not tooltipPointerStillOver(widget) or g_mouse.isPressed() then
		return
	end

	if widget.tooltip then
		g_tooltip.display(widget.tooltip, widget)

		currentHoveredWidget = widget
	elseif widget.specialtooltip then
		g_tooltip.displaySpecial(widget.specialtooltip)

		currentHoveredWidget = widget
	elseif widget.parseColoreDisplay then
		g_tooltip.parseColoreDisplay(widget.parseColoreDisplay)

		currentHoveredWidget = widget
	end
end

local function scheduleTooltip(widget)
	if not widget or g_mouse.isPressed() then
		return
	end

	if pendingTooltipEvent then
		removeEvent(pendingTooltipEvent)

		pendingTooltipEvent = nil
	end

	pendingHoveredWidget = widget
	pendingTooltipEvent = scheduleEvent(function()
		pendingTooltipEvent = nil

		if pendingHoveredWidget ~= widget then
			return
		end

		pendingHoveredWidget = nil

		displayWidgetTooltip(widget)
	end, tooltipDelay)
end

local function onPendingTooltipMouseMove()
	if currentHoveredWidget then
		local widget = currentHoveredWidget

		if widget.tooltip or widget.parseColoreDisplay then
			g_tooltip.hide()
		end

		if widget.specialtooltip then
			g_tooltip.hideSpecial()
		end

		currentHoveredWidget = nil

		if tooltipPointerStillOver(widget) and not g_mouse.isPressed() then
			scheduleTooltip(widget)
		end

		return
	end

	if not pendingHoveredWidget then
		return
	end

	if not tooltipPointerStillOver(pendingHoveredWidget) then
		cancelPendingTooltip()

		return
	end

	scheduleTooltip(pendingHoveredWidget)
end

local function raiseTooltipWidget(widget)
	if not widget or widget:isDestroyed() then
		return
	end

	widget:raise()
	addEvent(function()
		if widget and not widget:isDestroyed() and widget:isVisible() then
			widget:raise()
		end
	end)
end

local function reRaiseVisibleTooltips()
	if toolTipLabel and toolTipLabel:isVisible() and toolTipLabel:getOpacity() > 0.1 then
		raiseTooltipWidget(toolTipLabel)
	end

	if SpecialToolTipLabel and SpecialToolTipLabel:isVisible() and SpecialToolTipLabel:getOpacity() > 0.1 then
		raiseTooltipWidget(SpecialToolTipLabel)
	end
end

local function moveToolTip(first)
	if not first and (not toolTipLabel:isVisible() or toolTipLabel:getOpacity() < 0.1) then
		return
	end

	local pos = g_window.getMousePosition()
	local windowSize = g_window.getSize()
	local labelSize = toolTipLabel:getSize()

	pos.x = pos.x + 1
	pos.y = pos.y + 1

	if windowSize.width - (pos.x + labelSize.width) < 10 then
		pos.x = pos.x - labelSize.width
	else
		pos.x = pos.x - 1
	end

	if pos.y - labelSize.height - 3 < 10 then
		pos.y = pos.y + 10
	else
		pos.y = pos.y - labelSize.height
	end

	toolTipLabel:setPosition(pos)
end

local function moveSpecialToolTip(first)
	if not first and (not SpecialToolTipLabel:isVisible() or SpecialToolTipLabel:getOpacity() < 0.1) then
		return
	end

	local pos = g_window.getMousePosition()
	local windowSize = g_window.getSize()
	local labelSize = SpecialToolTipLabel:getSize()

	pos.x = pos.x + 1
	pos.y = pos.y + 1

	if windowSize.width - (pos.x + labelSize.width) < 10 then
		pos.x = pos.x - labelSize.width
	else
		pos.x = pos.x - 1
	end

	if pos.y - labelSize.height - 3 < 10 then
		pos.y = pos.y + 10
	else
		pos.y = pos.y - labelSize.height
	end

	SpecialToolTipLabel:setPosition(pos)
end

local function onWidgetDestroy(widget)
	if widget == currentHoveredWidget then
		if widget.tooltip or widget.parseColoreDisplay then
			g_tooltip.hide()
		end

		if widget.specialtooltip then
			g_tooltip.hideSpecial()
		end

		currentHoveredWidget = nil
	end

	if widget == pendingHoveredWidget then
		cancelPendingTooltip()
	end
end

local function onWidgetHoverChange(widget, hovered)
	if hovered then
		if (widget.tooltip or widget.specialtooltip or widget.parseColoreDisplay) and not g_mouse.isPressed() and widget ~= currentHoveredWidget then
			scheduleTooltip(widget)
		end
	else
		if widget == pendingHoveredWidget then
			cancelPendingTooltip()
		end

		if widget == currentHoveredWidget then
			if widget.tooltip or widget.parseColoreDisplay then
				g_tooltip.hide()
			end

			if widget.specialtooltip then
				g_tooltip.hideSpecial()
			end

			currentHoveredWidget = nil
		end
	end
end

local function onWidgetStyleApply(widget, styleName, styleNode)
	if styleNode.tooltip then
		widget.tooltip = styleNode.tooltip
	end

	if styleNode.specialtooltip then
		widget.specialtooltip = {
			{
				header = "",
				info = styleNode.specialtooltip
			}
		}
	end

	local tooltipWidget = widget:getChildById("toolTipWidget")

	if widget:getId() == "toolTipWidget" then
		tooltipWidget = widget
		widget = widget:getParent()
	end

	if tooltipWidget then
		if widget.tooltip then
			tooltipWidget.tooltip = widget.tooltip
			widget.tooltip = nil
		end

		if widget.specialtooltip then
			tooltipWidget.specialtooltip = widget.specialtooltip
			widget.specialtooltip = nil
		end

		if widget.parseColoreDisplay then
			tooltipWidget.parseColoreDisplay = widget.parseColoreDisplay
			widget.parseColoreDisplay = nil
		end

		if tooltipWidget.tooltip or tooltipWidget.specialtooltip or widget.parseColoreDisplay then
			tooltipWidget:setOpacity(1)
		else
			tooltipWidget:setOpacity(0.4)
		end
	end
end

local function onTooltipMouseRelease()
	addEvent(reRaiseVisibleTooltips)
end

function g_tooltip.init()
	connect(UIWidget, {
		onStyleApply = onWidgetStyleApply,
		onHoverChange = onWidgetHoverChange,
		onDestroy = onWidgetDestroy
	})
	addEvent(function()
		toolTipLabel = g_ui.createWidget("UILabel", rootWidget)

		toolTipLabel:setId("toolTip")
		toolTipLabel:setBackgroundColor("#c0c0c0ff")
		toolTipLabel:setTextAlign(AlignLeft)
		toolTipLabel:setColor("#3f3f3f")
		toolTipLabel:setBorderColor("#000000ff")
		toolTipLabel:setBorderWidth(1)
		toolTipLabel:setFont("Verdana Bold-11px-new")
		toolTipLabel:setTextOffset(topoint("5 3"))
		toolTipLabel:hide()
		toolTipLabel:setPhantom(true)
	end)
	addEvent(function()
		SpecialToolTipLabel = g_ui.createWidget("UIWidget", rootWidget)

		SpecialToolTipLabel:setBackgroundColor("#c0c0c0ff")
		SpecialToolTipLabel:setBorderColor("#000000ff")
		SpecialToolTipLabel:setBorderWidth(1)
		SpecialToolTipLabel:setWidth(455)
		SpecialToolTipLabel:setPaddingTop(2)
		SpecialToolTipLabel:setFont("Verdana Bold-11px-new")
		SpecialToolTipLabel:hide()
		SpecialToolTipLabel:setPhantom(true)
	end)
	addEvent(function()
		measureLabel = g_ui.createWidget("UILabel", rootWidget)

		measureLabel:setId("tooltipMeasure")
		measureLabel:setFont("Verdana Bold-11px-new")
		measureLabel:setTextWrap(false)
		measureLabel:setPhantom(true)
		measureLabel:hide()
	end)
	connect(rootWidget, {
		onMouseMove = onPendingTooltipMouseMove
	})
	connect(rootWidget, {
		onMouseRelease = onTooltipMouseRelease
	})
end

function g_tooltip.terminate()
	disconnect(UIWidget, {
		onStyleApply = onWidgetStyleApply,
		onHoverChange = onWidgetHoverChange,
		onDestroy = onWidgetDestroy
	})
	disconnect(rootWidget, {
		onMouseMove = onPendingTooltipMouseMove,
		onMouseRelease = onTooltipMouseRelease
	})
	cancelPendingTooltip()

	currentHoveredWidget = nil

	toolTipLabel:destroy()

	toolTipLabel = nil

	if measureLabel then
		measureLabel:destroy()

		measureLabel = nil
	end

	g_tooltip = nil
end

function g_tooltip.display(text, widget)
	if type(text) == "string" and text:len() == 0 or type(text) == "table" and #text == 0 then
		return
	end

	if not toolTipLabel then
		return
	end

	toolTipLabel:setFont("Verdana Bold-11px-new")

	local processed = text

	if type(text) == "string" and hasHtmlMarkup(text) then
		processed = htmlToTooltipText(text)
	end

	local needsManualWrap = type(processed) == "string" and processed:find(LIST_BULLET, 1, true) ~= nil

	if needsManualWrap and TOOLTIP_MAX_WIDTH > 0 then
		processed = wrapTooltipText(processed, TOOLTIP_MAX_WIDTH)

		toolTipLabel:setTextWrap(false)
	elseif TOOLTIP_MAX_WIDTH > 0 then
		toolTipLabel:setTextWrap(true)
		toolTipLabel:setWidth(TOOLTIP_MAX_WIDTH)
	else
		toolTipLabel:setTextWrap(false)
	end

	if type(processed) == "string" and processed:find("%[color=") then
		toolTipLabel:parseColoredText(processed, "#3f3f3f")
	else
		toolTipLabel:setText(processed)
	end

	toolTipLabel:resizeToText()
	toolTipLabel:resize(toolTipLabel:getWidth() + 4, toolTipLabel:getHeight() + 4)

	local alreadyVisible = toolTipLabel:isVisible() and toolTipLabel:getOpacity() > 0.8

	toolTipLabel:show()
	raiseTooltipWidget(toolTipLabel)
	toolTipLabel:enable()

	if widget then
		if widget.hasTooltipAlign ~= nil then
			toolTipLabel:setTextAlign(widget.tooltipAlign)
			toolTipLabel:setTextOffset(topoint(3 .. " " .. 3))
			toolTipLabel:resize(toolTipLabel:getWidth() + 3, toolTipLabel:getHeight() + 3)
		else
			toolTipLabel:setTextAlign(AlignCenter)
			toolTipLabel:setTextOffset(topoint(0 .. " " .. 0))
		end
	end

	if not alreadyVisible then
		g_effects.fadeIn(toolTipLabel, 100)
	end
	moveToolTip(true)
	if not moveToolTipConnected then
		connect(rootWidget, {
			onMouseMove = moveToolTip
		})
		moveToolTipConnected = true
	end
end

function g_tooltip.parseColoreDisplay(text)
	if text == nil or text:len() == 0 then
		return
	end

	if not toolTipLabel then
		return
	end

	toolTipLabel:setFont("Verdana Bold-11px-new")

	if TOOLTIP_MAX_WIDTH > 0 then
		toolTipLabel:setTextWrap(true)
		toolTipLabel:setWidth(TOOLTIP_MAX_WIDTH)
	else
		toolTipLabel:setTextWrap(false)
	end

	toolTipLabel:parseColoredText(text, "#3f3f3f")
	toolTipLabel:resizeToText()
	toolTipLabel:resize(toolTipLabel:getWidth() + 4, toolTipLabel:getHeight() + 4)
	toolTipLabel:show()
	raiseTooltipWidget(toolTipLabel)
	toolTipLabel:enable()
	g_effects.fadeIn(toolTipLabel, 100)
	moveToolTip(true)
	connect(rootWidget, {
		onMouseMove = moveToolTip
	})
end

function g_tooltip.displaySpecial(special)
	if not SpecialToolTipLabel then
		return
	end

	local width = 4
	local height = 4

	SpecialToolTipLabel:destroyChildren()

	for index, data in ipairs(special) do
		local headerW = 0
		local headerH = 0

		if string.len(data.header) > 0 then
			local header = g_ui.createWidget("UILabel", SpecialToolTipLabel)

			if index == 1 then
				header:addAnchor(AnchorTop, "parent", AnchorTop)
			else
				header:addAnchor(AnchorTop, "prev", AnchorBottom)
			end

			header:addAnchor(AnchorLeft, "parent", AnchorLeft)
			header:setText(data.header)
			header:setTextAlign(AlignLeft)
			header:setColor("#3f3f3f")
			header:setFont("Verdana-11px-lowspace-underline")
			header:setTextOffset(topoint("5 0"))
			header:resizeToText()
			header:resize(header:getWidth(), header:getHeight())

			headerW = header:getWidth()
			headerH = header:getHeight()
		end

		local info = g_ui.createWidget("UILabel", SpecialToolTipLabel)

		if string.len(data.header) > 0 then
			info:addAnchor(AnchorTop, "prev", AnchorBottom)
		else
			info:addAnchor(AnchorTop, "parent", AnchorTop)
		end

		info:addAnchor(AnchorLeft, "parent", AnchorLeft)
		info:setText(data.info:wrap(445))
		info:setTextAlign(AlignLeft)
		info:setColor("#3f3f3f")
		info:setFont("Verdana-11px-lowspace")
		info:setTextOffset(topoint("5 0"))
		info:resizeToText()
		info:resize(info:getWidth(), info:getHeight())

		width = width + math.max(headerW, info:getWidth())
		height = height + headerH + info:getHeight()
	end

	SpecialToolTipLabel:resize(width, height)
	SpecialToolTipLabel:show()
	raiseTooltipWidget(SpecialToolTipLabel)
	SpecialToolTipLabel:enable()
	g_effects.fadeIn(SpecialToolTipLabel, 100)
	moveSpecialToolTip(true)
	connect(rootWidget, {
		onMouseMove = moveSpecialToolTip
	})
end

function g_tooltip.hide()
	g_effects.fadeOut(toolTipLabel, 100)
	disconnect(rootWidget, {
		onMouseMove = moveToolTip
	})
	moveToolTipConnected = false
end

function g_tooltip.hideSpecial()
	g_effects.fadeOut(SpecialToolTipLabel, 100)
	disconnect(rootWidget, {
		onMouseMove = moveSpecialToolTip
	})
end

function UIWidget:setTooltip(text)
	local tooltipWidget = self:getChildById("toolTipWidget")

	if tooltipWidget then
		tooltipWidget.tooltip = text
	else
		self.tooltip = text
	end

	if toolTipLabel and toolTipLabel:isVisible() and toolTipLabel:getOpacity() > 0.1 and currentHoveredWidget then
		local isTargetHovered = isWidgetOrRelatedHovered(self)
			or (tooltipWidget and isWidgetOrRelatedHovered(tooltipWidget))
			or (self.isHovered and self:isHovered() and tooltipPointerStillOver(self))

		if isTargetHovered and tooltipPointerStillOver(currentHoveredWidget) then
			if text == nil or text == "" then
				g_tooltip.hide()
			else
				g_tooltip.display(text, currentHoveredWidget)
			end
		end
	end
end

function UIWidget:parseColoreDisplayToolTip(text)
	local tooltipWidget = self:getChildById("toolTipWidget")

	if tooltipWidget then
		tooltipWidget.parseColoreDisplay = text
	else
		self.parseColoreDisplay = text
	end
end

function UIWidget:setSpecialToolTip(special)
	if type(special) == "string" then
		special = {
			{
				header = "",
				info = special
			}
		}
	end

	self.specialtooltip = special
end

function UIWidget:removeTooltip()
	self.tooltip = nil
	self.specialtooltip = nil
	self.parseColoreDisplay = nil
end

function UIWidget:getTooltip()
	return self.tooltip
end

function UIWidget:getSpecialTooltip()
	return self.specialtooltip
end

function UIWidget:setTooltipAlign(align)
	self.hasTooltipAlign = true
	self.tooltipAlign = align
end

g_tooltip.init()
connect(g_app, {
	onTerminate = g_tooltip.terminate
})

function g_tooltip.onWidgetHoverChange(widget, hovered)
	onWidgetHoverChange(widget, hovered)
end
