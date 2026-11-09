-- chunkname: @/gamelib/player.lua

PlayerStates = {
	PartyBuff = 4096,
	Cursed = 2048,
	Dazzled = 1024,
	Freezing = 512,
	Drowning = 256,
	Swords = 128,
	Haste = 64,
	Paralyze = 32,
	ManaShield = 16,
	Drunk = 8,
	Energy = 4,
	Burn = 2,
	Poison = 1,
	None = 0,
	Rewards = 30,
	Mentor = 536870912,
	Powerless = 268435456,
	Agony = 134217728,
	NewManaShield = 67108864,
	GoshnarTaint5 = 33554432,
	GoshnarTaint4 = 16777216,
	GoshnarTaint3 = 8388608,
	GoshnarTaint2 = 4194304,
	GoshnarTaint1 = 2097152,
	Feared = 1048576,
	Rooted = 524288,
	GreaterHex = 262144,
	IntenseHex = 131072,
	LesserHex = 65536,
	Hungry = 65536,
	Bleeding = 32768,
	Pigeon = 16384,
	Pz = 16384,
	PzBlock = 8192,
	RedSwords = 8192
}
Icons = {}
Icons[PlayerStates.Poison] = {
	clip = 1,
	id = "condition_poisoned",
	tooltip = tr("You are poisoned")
}
Icons[PlayerStates.Burn] = {
	clip = 2,
	id = "condition_burning",
	tooltip = tr("You are burning")
}
Icons[PlayerStates.Energy] = {
	clip = 3,
	id = "condition_electrified",
	tooltip = tr("You are electrified")
}
Icons[PlayerStates.Drunk] = {
	clip = 4,
	id = "condition_drunk",
	tooltip = tr("You are drunk")
}
Icons[PlayerStates.ManaShield] = {
	clip = 5,
	id = "condition_magic_shield",
	tooltip = tr("You are protected by a magic shield")
}
Icons[PlayerStates.Paralyze] = {
	clip = 6,
	id = "condition_slowed",
	tooltip = tr("You are paralysed")
}
Icons[PlayerStates.Haste] = {
	clip = 7,
	id = "condition_haste",
	tooltip = tr("You are hasted")
}
Icons[PlayerStates.Swords] = {
	clip = 8,
	id = "condition_logout_block",
	tooltip = tr("You may not logout during a fight")
}
Icons[PlayerStates.Drowning] = {
	clip = 9,
	id = "condition_drowning",
	tooltip = tr("You are drowning")
}
Icons[PlayerStates.Freezing] = {
	clip = 10,
	id = "condition_freezing",
	tooltip = tr("You are freezing")
}
Icons[PlayerStates.Dazzled] = {
	clip = 11,
	id = "condition_dazzled",
	tooltip = tr("You are dazzled")
}
Icons[PlayerStates.Cursed] = {
	clip = 12,
	id = "condition_cursed",
	tooltip = tr("You are cursed")
}
Icons[PlayerStates.PartyBuff] = {
	clip = 13,
	id = "condition_strengthened",
	tooltip = tr("You are strengthened")
}
Icons[PlayerStates.RedSwords] = {
	clip = 14,
	id = "condition_RedSwords",
	tooltip = tr("You may not logout or enter a protection zone")
}
Icons[PlayerStates.Pigeon] = {
	clip = 15,
	id = "condition_Pigeon",
	tooltip = tr("You are within a protection zone")
}
Icons[PlayerStates.Bleeding] = {
	clip = 16,
	id = "condition_Bleeding",
	tooltip = tr("You are Bleeding")
}
Icons[PlayerStates.LesserHex] = {
	clip = 17,
	id = "condition_LesserHex",
	tooltip = tr("You are LesserHex")
}
Icons[PlayerStates.IntenseHex] = {
	clip = 18,
	id = "condition_IntenseHex",
	tooltip = tr("You are IntenseHex")
}
Icons[PlayerStates.GreaterHex] = {
	clip = 19,
	id = "condition_GreaterHex",
	tooltip = tr("You are GreaterHex")
}
Icons[PlayerStates.Rooted] = {
	clip = 20,
	id = "condition_Rooted",
	tooltip = tr("You are Rooted")
}
Icons[PlayerStates.Feared] = {
	clip = 21,
	id = "condition_Feared",
	tooltip = tr("You are Feared")
}
Icons[PlayerStates.GoshnarTaint1] = {
	clip = 22,
	id = "condition_GoshnarTaint1",
	tooltip = tr("You are GoshnarTaint")
}
Icons[PlayerStates.GoshnarTaint2] = {
	clip = 23,
	id = "condition_GoshnarTaint2",
	tooltip = tr("You are GoshnarTaint")
}
Icons[PlayerStates.GoshnarTaint3] = {
	clip = 24,
	id = "condition_GoshnarTaint3",
	tooltip = tr("You are GoshnarTaint")
}
Icons[PlayerStates.GoshnarTaint4] = {
	clip = 25,
	id = "condition_GoshnarTaint4",
	tooltip = tr("You are GoshnarTaint")
}
Icons[PlayerStates.GoshnarTaint5] = {
	clip = 26,
	id = "condition_GoshnarTaint5",
	tooltip = tr("You are GoshnarTaint")
}
Icons[PlayerStates.NewManaShield] = {
	clip = 27,
	id = "condition_NewManaShield",
	tooltip = tr("You are NewManaShield")
}
Icons[PlayerStates.Agony] = {
	clip = 28,
	id = "condition_Agony",
	tooltip = tr("You are Agony")
}
Icons[PlayerStates.Powerless] = {
	clip = 29,
	id = "condition_Powerless",
	tooltip = tr("You are Powerless")
}
Icons[PlayerStates.Mentor] = {
	clip = 30,
	id = "condition_Mentor",
	tooltip = tr("You are Mentor")
}
Icons[PlayerStates.Rewards] = {
	clipRect = "0 0 9 9",
	id = "condition_Rewards",
	image = "/images/game/creatures/player-state-flags-client",
	tooltip = tr("Rewards")
}
Icons[PlayerStates.Hungry] = {
	clipRect = "18 0 9 9",
	id = "condition_hungry",
	image = "/images/game/creatures/player-state-flags-client",
	tooltip = tr("You are hungry")
}
PlayerStateFlagsImage = "/images/game/creatures/player-state-flags"
PlayerStateFlagsClientImage = "/images/game/creatures/player-state-flags-client"
PlayerStateFlagsRottenBloodImage = "/images/game/creatures/player-state-flags-rotten-blood"
PlayerStatePlayerKillerFlagsImage = "/images/game/creatures/player-state-playerkiller-flags"
PlayerStateFlagGuildImage = "/images/game/creatures/hud/flags/guild"
SpecialConditionExtraIcons = {
	condition_restingarea = {
		clipRect = "0 0 9 9",
		id = "condition_restingarea",
		image = PlayerStateFlagsClientImage,
		tooltip = tr("You are within a resting area")
	},
	condition_LesserHex = {
		id = "condition_LesserHex",
		clip = 17,
		tooltip = tr("You are LesserHex")
	},
	condition_goshnar_taint = {
		id = "condition_goshnar_taint",
		clip = 26,
		tooltip = tr("You are Goshnar's Taint")
	},
	condition_bakragore_taint = {
		clipRect = "72 0 9 9",
		id = "condition_bakragore_taint",
		image = PlayerStateFlagsRottenBloodImage,
		tooltip = tr("You are Bakragore's Taint")
	},
	skullyellow = {
		clipRect = "0 0 9 9",
		id = "skullyellow",
		image = PlayerStatePlayerKillerFlagsImage,
		tooltip = tr("You have a yellow skull")
	},
	skullgreen = {
		clipRect = "9 0 9 9",
		id = "skullgreen",
		image = PlayerStatePlayerKillerFlagsImage,
		tooltip = tr("You are in party mode")
	},
	skullwhite = {
		clipRect = "18 0 9 9",
		id = "skullwhite",
		image = PlayerStatePlayerKillerFlagsImage,
		tooltip = tr("You have a white skull")
	},
	skullred = {
		clipRect = "27 0 9 9",
		id = "skullred",
		image = PlayerStatePlayerKillerFlagsImage,
		tooltip = tr("You have a red skull")
	},
	skullblack = {
		clipRect = "36 0 9 9",
		id = "skullblack",
		image = PlayerStatePlayerKillerFlagsImage,
		tooltip = tr("You have a black skull")
	},
	skullorange = {
		clipRect = "45 0 9 9",
		id = "skullorange",
		image = PlayerStatePlayerKillerFlagsImage,
		tooltip = tr("You have an orange skull")
	},
	guildWar = {
		clipRect = "0 0 11 11",
		id = "guildWar",
		image = PlayerStateFlagGuildImage,
		tooltip = tr("You are in a guild war")
	}
}
SpecialConditions = {
	{
		defaultHud = true,
		defaultBar = true,
		state = PlayerStates.Poison,
		label = tr("Poisoned")
	},
	{
		defaultHud = true,
		defaultBar = true,
		state = PlayerStates.Burn,
		label = tr("Burning")
	},
	{
		defaultHud = true,
		defaultBar = true,
		state = PlayerStates.Energy,
		label = tr("Electrified")
	},
	{
		defaultHud = true,
		defaultBar = true,
		state = PlayerStates.Bleeding,
		label = tr("Bleeding")
	},
	{
		defaultHud = true,
		defaultBar = true,
		state = PlayerStates.Agony,
		label = tr("Agony")
	},
	{
		defaultHud = true,
		defaultBar = true,
		state = PlayerStates.Powerless,
		label = tr("Powerless")
	},
	{
		defaultHud = true,
		defaultBar = true,
		state = PlayerStates.Rooted,
		label = tr("Rooted")
	},
	{
		defaultHud = true,
		defaultBar = true,
		state = PlayerStates.Feared,
		label = tr("Feared")
	},
	{
		defaultHud = true,
		defaultBar = true,
		state = PlayerStates.Drunk,
		label = tr("Drunk")
	},
	{
		defaultHud = true,
		defaultBar = true,
		state = PlayerStates.NewManaShield,
		label = tr("Magic Shield")
	},
	{
		defaultHud = true,
		defaultBar = true,
		state = PlayerStates.Paralyze,
		label = tr("Slowed")
	},
	{
		defaultHud = true,
		defaultBar = true,
		state = PlayerStates.Haste,
		label = tr("Haste")
	},
	{
		defaultHud = false,
		defaultBar = true,
		state = PlayerStates.Swords,
		label = tr("Logout Block")
	},
	{
		defaultHud = true,
		defaultBar = true,
		state = PlayerStates.Drowning,
		label = tr("Drowning")
	},
	{
		defaultHud = true,
		defaultBar = true,
		state = PlayerStates.Freezing,
		label = tr("Freezing")
	},
	{
		defaultHud = true,
		defaultBar = true,
		state = PlayerStates.Dazzled,
		label = tr("Dazzled")
	},
	{
		defaultHud = true,
		defaultBar = true,
		state = PlayerStates.Cursed,
		label = tr("Cursed")
	},
	{
		defaultHud = false,
		defaultBar = true,
		state = PlayerStates.Mentor,
		label = tr("Mentor Other")
	},
	{
		defaultHud = false,
		defaultBar = true,
		state = PlayerStates.PartyBuff,
		label = tr("Strengthened")
	},
	{
		defaultHud = false,
		defaultBar = true,
		state = PlayerStates.RedSwords,
		label = tr("Protection Zone Block")
	},
	{
		defaultHud = false,
		defaultBar = true,
		state = PlayerStates.Pigeon,
		label = tr("In Protection Zone")
	},
	{
		id = "condition_restingarea",
		defaultHud = false,
		defaultBar = true,
		label = tr("Resting Area")
	},
	{
		id = "condition_LesserHex",
		defaultHud = true,
		defaultBar = true,
		label = tr("Lesser Hex")
	},
	{
		defaultHud = true,
		defaultBar = true,
		state = PlayerStates.IntenseHex,
		label = tr("Intense Hex")
	},
	{
		defaultHud = true,
		defaultBar = true,
		state = PlayerStates.GreaterHex,
		label = tr("Greater Hex")
	},
	{
		id = "condition_goshnar_taint",
		defaultHud = false,
		defaultBar = true,
		label = tr("Goshnar's Taint")
	},
	{
		id = "condition_bakragore_taint",
		defaultHud = false,
		defaultBar = true,
		label = tr("Bakragore's Taint")
	},
	{
		id = "skullyellow",
		defaultHud = true,
		defaultBar = true,
		label = tr("Yellow Skull")
	},
	{
		id = "skullgreen",
		defaultHud = true,
		defaultBar = true,
		label = tr("Party Mode")
	},
	{
		id = "skullwhite",
		defaultHud = true,
		defaultBar = true,
		label = tr("White Skull")
	},
	{
		id = "skullred",
		defaultHud = true,
		defaultBar = true,
		label = tr("Red Skull")
	},
	{
		id = "skullblack",
		defaultHud = true,
		defaultBar = true,
		label = tr("Black Skull")
	},
	{
		id = "skullorange",
		defaultHud = true,
		defaultBar = true,
		label = tr("Orange Skull")
	},
	{
		id = "guildWar",
		defaultHud = false,
		defaultBar = true,
		label = tr("In Guild War")
	},
	{
		defaultHud = false,
		defaultBar = true,
		state = PlayerStates.Hungry,
		label = tr("Hungry")
	}
}

for _, cond in ipairs(SpecialConditions) do
	if cond.state then
		local info = Icons[cond.state]

		if info then
			cond.id = cond.id or info.id
			cond.info = info
		end
	elseif cond.id and SpecialConditionExtraIcons[cond.id] then
		cond.info = SpecialConditionExtraIcons[cond.id]
	end
end

function getSpecialConditionDefaults(id)
	for _, cond in ipairs(SpecialConditions) do
		if cond.id == id then
			return cond.defaultHud ~= false, cond.defaultBar ~= false
		end
	end

	return true, true
end

function isPlayerHungry(player)
	player = player or g_game.getLocalPlayer()

	if not player then
		return false
	end

	return getFoodRegenerationRemaining() <= 0
end

function isPlayerHungryConditionActive(player)
	player = player or g_game.getLocalPlayer()

	if not player then
		return false
	end

	return isPlayerHungry(player) or bit.band(player:getStates(), PlayerStates.Hungry) ~= 0
end

function buildFoodRegenerationTooltip(regenerationTime)
	if not regenerationTime or regenerationTime <= 0 then
		return tr("You are hungry.\nEat something to regenerate hit points and mana faster over time.")
	end

	local minutes = math.floor(regenerationTime / 60)
	local seconds = regenerationTime % 60

	return tr("You are regenerating hit points and mana faster for %d minutes and %d seconds", minutes, seconds)
end

function formatFoodRegenerationTime(regenerationTime)
	if not regenerationTime or regenerationTime <= 0 then
		return "00:00"
	end

	local hours = math.floor(regenerationTime / 3600)
	local minutes = math.floor(regenerationTime % 3600 / 60)

	return string.format("%02d:%02d", hours, minutes)
end

local foodRegenerationRemaining = 0
local foodRegenerationSyncedAt = 0
local foodRegenerationTickEvent
local FOOD_REGENERATION_TICK_MS = 5000

local function refreshFoodRegenerationUi(regenerationTime)
	if modules.game_skills and modules.game_skills.updateFoodRegenerationDisplay then
		modules.game_skills.updateFoodRegenerationDisplay(regenerationTime)
	end

	if Cyclopedia and Cyclopedia.updateFoodRegenerationDisplay then
		Cyclopedia.updateFoodRegenerationDisplay(regenerationTime)
	end
end

local function tickFoodRegeneration()
	refreshFoodRegenerationUi(getFoodRegenerationRemaining())
end

function getFoodRegenerationRemaining()
	if foodRegenerationRemaining <= 0 then
		return 0
	end

	local elapsed = g_clock.seconds() - foodRegenerationSyncedAt

	return math.max(0, foodRegenerationRemaining - elapsed)
end

function syncFoodRegenerationTime(regenerationTime)
	if regenerationTime == nil or regenerationTime < 0 then
		foodRegenerationRemaining = 0
	else
		foodRegenerationRemaining = regenerationTime
	end

	foodRegenerationSyncedAt = g_clock.seconds()
end

function startFoodRegenerationTicker()
	if foodRegenerationTickEvent then
		return
	end

	if not g_game.isOnline() then
		return
	end

	foodRegenerationTickEvent = cycleEvent(tickFoodRegeneration, FOOD_REGENERATION_TICK_MS)
end

function stopFoodRegenerationTicker()
	if foodRegenerationTickEvent then
		foodRegenerationTickEvent:cancel()

		foodRegenerationTickEvent = nil
	end

	foodRegenerationRemaining = 0
	foodRegenerationSyncedAt = 0
end

local RESTING_AREA_ZONE = 1
local lastRestingAreaZone
local restingAreaActive = false
local restingAreaTooltip

function updatePlayerRestingAreaState(zone, state, message)
	local changed = lastRestingAreaZone ~= zone

	lastRestingAreaZone = zone
	restingAreaActive = zone == RESTING_AREA_ZONE

	local tooltipChanged = false

	if message and message ~= "" and message ~= restingAreaTooltip then
		restingAreaTooltip = message
		tooltipChanged = true
	end

	return changed or tooltipChanged
end

function resetPlayerRestingAreaState()
	lastRestingAreaZone = nil
	restingAreaActive = false
	restingAreaTooltip = nil
end

function isPlayerInRestingArea()
	return restingAreaActive
end

function getPlayerRestingAreaTooltip()
	local info = SpecialConditionExtraIcons.condition_restingarea

	if restingAreaTooltip and restingAreaTooltip ~= "" then
		return restingAreaTooltip
	end

	return info and info.tooltip or tr("You are within a resting area")
end

function getPlayerRestingAreaIconInfo()
	local info = SpecialConditionExtraIcons.condition_restingarea

	if not info then
		return nil
	end

	local tooltip = getPlayerRestingAreaTooltip()

	if tooltip == info.tooltip then
		return info
	end

	return {
		id = info.id,
		image = info.image,
		clipRect = info.clipRect,
		clip = info.clip,
		tooltip = tooltip
	}
end

function getPlayerStateIconImage(info)
	return info.image or PlayerStateFlagsImage
end

function getPlayerStateIconClip(info, variant)
	if info.clipRect then
		return info.clipRect
	end

	if info.clip then
		return (info.clip - 1) * 9 .. " 0 9 9"
	end
end

function applyPlayerStateIcon(widget, info, variant)
	widget:setImageSource(getPlayerStateIconImage(info))
	widget:setImageClip(getPlayerStateIconClip(info, variant))
end

combatStates = {
	CLIENT_COMBAT_MANADRAIN = 10,
	CLIENT_COMBAT_LIFEDRAIN = 9,
	CLIENT_COMBAT_DROWN = 8,
	CLIENT_COMBAT_HEALING = 7,
	CLIENT_COMBAT_DEATH = 6,
	CLIENT_COMBAT_HOLY = 5,
	CLIENT_COMBAT_ICE = 4,
	CLIENT_COMBAT_ENERGY = 3,
	CLIENT_COMBAT_EARTH = 2,
	CLIENT_COMBAT_FIRE = 1,
	CLIENT_COMBAT_PHYSICAL = 0
}
clientCombat = {}
clientCombat[combatStates.CLIENT_COMBAT_PHYSICAL] = {
	id = "Physical",
	path = "/game_cyclopedia/images/bestiary/icons/monster-icon-physical-resist"
}
clientCombat[combatStates.CLIENT_COMBAT_FIRE] = {
	id = "Fire",
	path = "/game_cyclopedia/images/bestiary/icons/monster-icon-fire-resist"
}
clientCombat[combatStates.CLIENT_COMBAT_EARTH] = {
	id = "Earth",
	path = "/game_cyclopedia/images/bestiary/icons/monster-icon-earth-resist"
}
clientCombat[combatStates.CLIENT_COMBAT_ENERGY] = {
	id = "Energy",
	path = "/game_cyclopedia/images/bestiary/icons/monster-icon-energy-resist"
}
clientCombat[combatStates.CLIENT_COMBAT_ICE] = {
	id = "Ice",
	path = "/game_cyclopedia/images/bestiary/icons/monster-icon-ice-resist"
}
clientCombat[combatStates.CLIENT_COMBAT_HOLY] = {
	id = "Holy",
	path = "/game_cyclopedia/images/bestiary/icons/monster-icon-holy-resist"
}
clientCombat[combatStates.CLIENT_COMBAT_DEATH] = {
	id = "Death",
	path = "/game_cyclopedia/images/bestiary/icons/monster-icon-death-resist"
}
clientCombat[combatStates.CLIENT_COMBAT_HEALING] = {
	id = "Healing",
	path = "/game_cyclopedia/images/bestiary/icons/monster-icon-healing-resist"
}
clientCombat[combatStates.CLIENT_COMBAT_DROWN] = {
	id = "Drown",
	path = "/game_cyclopedia/images/bestiary/icons/monster-icon-drowning-resist"
}
clientCombat[combatStates.CLIENT_COMBAT_LIFEDRAIN] = {
	id = "Lifedrain ",
	path = "/game_cyclopedia/images/bestiary/icons/monster-icon-lifedrain-resist"
}
clientCombat[combatStates.CLIENT_COMBAT_MANADRAIN] = {
	id = "Manadrain",
	path = "/game_cyclopedia/images/bestiary/icons/monster-icon-manadrain-resist"
}

function getClientCombatElementName(combatType)
	if combatType == nil then
		combatType = combatStates.CLIENT_COMBAT_PHYSICAL
	end

	local element = clientCombat[combatType] or clientCombat[combatStates.CLIENT_COMBAT_PHYSICAL]

	if not element or not element.id then
		return tr("Physical")
	end

	return tr(element.id:match("^%s*(.-)%s*$"))
end

InventorySlotOther = 0
InventorySlotHead = 1
InventorySlotNeck = 2
InventorySlotBack = 3
InventorySlotBody = 4
InventorySlotRight = 5
InventorySlotLeft = 6
InventorySlotLeg = 7
InventorySlotFeet = 8
InventorySlotFinger = 9
InventorySlotAmmo = 10
InventorySlotPurse = 11
InventorySlotFirst = 1
InventorySlotLast = 10
InventoryNameById = {
	[InventorySlotHead] = "helmet",
	[InventorySlotNeck] = "amulet",
	[InventorySlotBack] = "backpack",
	[InventorySlotBody] = "armor",
	[InventorySlotRight] = "shield",
	[InventorySlotLeft] = "sword",
	[InventorySlotLeg] = "legs",
	[InventorySlotFeet] = "boots",
	[InventorySlotFinger] = "ring",
	[InventorySlotAmmo] = "tools"
}
vocationNamesByClientId = {
	[0] = "No Vocation",
	"Knight",
	"Paladin",
	"Sorcerer",
	"Druid",
	"Monk",
	nil,
	nil,
	nil,
	nil,
	nil,
	"Elite Knight",
	"Royal Paladin",
	"Master Sorcerer",
	"Elder Druid",
	"Exalted Monk"
}

function Player:isPartyLeader()
	local shield = self:getShield()

	return shield == ShieldWhiteYellow or shield == ShieldYellow or shield == ShieldYellowSharedExp or shield == ShieldYellowNoSharedExpBlink or shield == ShieldYellowNoSharedExp
end

function Player:isPartyMember()
	local shield = self:getShield()

	return shield == ShieldWhiteYellow or shield == ShieldYellow or shield == ShieldYellowSharedExp or shield == ShieldYellowNoSharedExpBlink or shield == ShieldYellowNoSharedExp or shield == ShieldBlueSharedExp or shield == ShieldBlueNoSharedExpBlink or shield == ShieldBlueNoSharedExp or shield == ShieldBlue
end

function Player:isPartySharedExperienceActive()
	local shield = self:getShield()

	return shield == ShieldYellowSharedExp or shield == ShieldYellowNoSharedExpBlink or shield == ShieldYellowNoSharedExp or shield == ShieldBlueSharedExp or shield == ShieldBlueNoSharedExpBlink or shield == ShieldBlueNoSharedExp
end

function Player:hasCondition(condition)
	return bit.band(self:getStates(), condition) > 0
end

function Player:isInProtectionZone()
	return self:hasCondition(PlayerStates.Pz)
end

function Player:hasVip(creatureName)
	for id, vip in pairs(g_game.getVips()) do
		if vip[1] == creatureName then
			return true
		end
	end

	return false
end

function Player:isMounted()
	local outfit = self:getOutfit()

	return outfit.mount ~= nil and outfit.mount > 0
end

function Player:toggleMount()
	if g_game.getFeature(GamePlayerMounts) then
		g_game.mount(not self:isMounted())
	end
end

function Player:mount()
	if g_game.getFeature(GamePlayerMounts) then
		g_game.mount(true)
	end
end

function Player:dismount()
	if g_game.getFeature(GamePlayerMounts) then
		g_game.mount(false)
	end
end

function Player:getItem(itemId, subType)
	return g_game.findPlayerItem(itemId, subType or -1)
end

function Player:getItems(itemId, subType)
	local subType = subType or -1
	local items = {}

	for i = InventorySlotFirst, InventorySlotLast do
		local item = self:getInventoryItem(i)

		if item and item:getId() == itemId and (subType == -1 or item:getSubType() == subType) then
			table.insert(items, item)
		end
	end

	for i, container in pairs(g_game.getContainers()) do
		for j, item in pairs(container:getItems()) do
			if item:getId() == itemId and (subType == -1 or item:getSubType() == subType) then
				item.container = container

				table.insert(items, item)
			end
		end
	end

	return items
end

function Player:getItemsCount(itemId)
	local items, count = self:getItems(itemId), 0

	for i = 1, #items do
		count = count + items[i]:getCount()
	end

	return count
end

function Player:hasState(state, states)
	states = states or self:getStates()

	for i = 1, 32 do
		local pow = math.pow(2, i - 1)

		if states < pow then
			break
		end

		local states = bit.band(states, pow)

		if states == state then
			return true
		end
	end

	return false
end

function Player:getVocationNameByClientId()
	return vocationNamesByClientId[self:getVocation()] or "Unknown Vocation"
end

function Player:isPromoted()
	local promoted = {
		11,
		12,
		13,
		14,
		15
	}

	if table.contains(promoted, self:getVocation()) then
		return true
	end

	return false
end

function Player:getBlessingStatus()
	if self.getBlessVisualState then
		local visualState = self:getBlessVisualState()
		if visualState and visualState > 0 then
			return visualState
		end
	end

	local blessings = tonumber(self:getBlessings()) or 0
	local status = 1

	if Bit.hasBit(blessings, 256) or (Bit.hasBit(blessings, 128) and Bit.hasBit(blessings, 64) and Bit.hasBit(blessings, 32)) then
		status = 3
	elseif blessings > 0 then
		status = 2
	end

	return status
end
