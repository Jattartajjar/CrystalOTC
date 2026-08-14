#include <gtest/gtest.h>

#include <framework/luaengine/luainterface.h>

TEST(CyclopediaCompat, BasicItemDetailsNamedAndArrayFormatParsing)
{
    lua_State* L = luaL_newstate();
    ASSERT_NE(L, nullptr);
    luaL_openlibs(L);

    const char* script = R"lua(
        -- Mock Cyclopedia and UI environment
        Cyclopedia = {}
        local appendedRows = {}

        Cyclopedia.appendDetailKeyValueRow = function(parent, key, value)
            table.insert(appendedRows, { key = key, value = value })
        end

        UI = {
            isDestroyed = function() return false end,
            InfoBase = {
                DetailsBase = {
                    List = {
                        destroyChildren = function() end,
                        getWidth = function() return 446 end
                    }
                }
            }
        }

        g_logger = {
            info = function() end,
            warning = function() end
        }

        g_things = {
            getThingType = function(itemId, category)
                return { id = itemId }
            end
        }
        ThingCategoryItem = 0

        local function openFile(relPath)
            return io.open(relPath, "r")
                or io.open("../../" .. relPath, "r")

        end

        -- Load the loadItemDetail logic from items.lua
        local f = openFile("modules/game_cyclopedia/tab/items/items.lua")
        assert(f, "Cannot open items.lua")
        local content = f:read("*all")
        f:close()

        local fnPattern = "(function%s+Cyclopedia%.loadItemDetail%s*%(.-%)%s*\n.-)%s*function%s+Cyclopedia%.openItemInCyclopedia"
        local fnCode = content:match(fnPattern)
        assert(fnCode, "Could not extract Cyclopedia.loadItemDetail from items.lua")

        local loadChunk = loadstring or load
        local chunk, err = loadChunk(fnCode)
        assert(chunk, "Failed to compile Cyclopedia.loadItemDetail: " .. tostring(err))
        chunk()

        assert(type(Cyclopedia.loadItemDetail) == "function", "Cyclopedia.loadItemDetail must be a function")

        -- Test 1: Named description format ({ key = "Armor", value = "15" })
        appendedRows = {}
        local namedDescriptions = {
            { key = "Armor", value = "15" },
            { key = "Attack", value = "52" }
        }
        Cyclopedia.loadItemDetail(3394, namedDescriptions)
        assert(#appendedRows == 2, "Named format should append 2 rows")
        assert(appendedRows[1].key == "Armor" and appendedRows[1].value == "15", "Named format row 1 mismatch")
        assert(appendedRows[2].key == "Attack" and appendedRows[2].value == "52", "Named format row 2 mismatch")

        -- Test 2: Legacy array format ({ "Weight", "30.00 oz" })
        appendedRows = {}
        local legacyDescriptions = {
            { "Weight", "30.00 oz" },
            { "Attack", "45" }
        }
        Cyclopedia.loadItemDetail(3394, legacyDescriptions)
        assert(#appendedRows == 2, "Legacy format should append 2 rows")
        assert(appendedRows[1].key == "Weight" and appendedRows[1].value == "30.00 oz", "Legacy format row 1 mismatch")
        assert(appendedRows[2].key == "Attack" and appendedRows[2].value == "45", "Legacy format row 2 mismatch")

        -- Test 3: Mixed and empty descriptions
        appendedRows = {}
        local mixedDescriptions = {
            { key = "Defense", value = "30" },
            {}, -- completely empty row: must be skipped
            { "", "" }, -- blank row: must be skipped
            { "Imbuement Slots", "2" }
        }
        Cyclopedia.loadItemDetail(3394, mixedDescriptions)
        assert(#appendedRows == 2, "Empty rows must be skipped; expected 2 non-empty rows")
        assert(appendedRows[1].key == "Defense" and appendedRows[1].value == "30", "Mixed format row 1 mismatch")
        assert(appendedRows[2].key == "Imbuement Slots" and appendedRows[2].value == "2", "Mixed format row 2 mismatch")
    )lua";

    const int status = luaL_dostring(L, script);
    if (status != 0) {
        const char* err = lua_tostring(L, -1);
        FAIL() << "Lua execution failed: " << (err ? err : "unknown error");
    }

    lua_close(L);
}

TEST(CyclopediaCompat, ThingTypeCyclopediaCompatibility)
{
    lua_State* L = luaL_newstate();
    ASSERT_NE(L, nullptr);
    luaL_openlibs(L);

    const char* script = R"lua(
        g_game = {}
        g_logger = { warnings = {}, warning = function(msg) table.insert(g_logger.warnings, msg) end }
        g_app = {}
        g_client = {}
        g_mouse = {}
        g_things = {}
        g_minimap = {}
        g_platform = {}
        UIWidget = {}
        UIMap = {}
        OutputMessage = {}
        UICreature = {}
        Creature = {}
        ThingType = {}
        InputMessage = {}
        Item = {}
        Thing = {}
        LocalPlayer = {}
        Container = {}
        UIItem = {}
        UIGridLayout = {}

        local function openFile(relPath)
            return io.open(relPath, "r")
                or io.open("../../" .. relPath, "r")

        end

        local f = openFile("modules/gamelib/engine_compat.lua")
        assert(f, "Cannot open engine_compat.lua")
        local compatCode = f:read("*all")
        f:close()

        local chunk = assert((loadstring or load)(compatCode, "engine_compat.lua"))
        chunk()

        assert(type(ThingType.isCyclopediaItem) == "function", "ThingType:isCyclopediaItem must be installed")
        assert(type(Thing.isCyclopediaItem) == "function", "Thing:isCyclopediaItem must be preserved")

        -- Create mock ThingType instance with getCyclopediaType = 1 (valid item)
        local validItemType = setmetatable({
            _cyclopediaType = 1,
            getCyclopediaType = function(self) return self._cyclopediaType end
        }, { __index = ThingType })

        -- Create mock ThingType instance with getCyclopediaType = 0 (non-cyclopedia item)
        local nonCycItemType = setmetatable({
            _cyclopediaType = 0,
            getCyclopediaType = function(self) return self._cyclopediaType end
        }, { __index = ThingType })

        -- Create mock ThingType instance without getCyclopediaType method
        local emptyItemType = setmetatable({}, { __index = ThingType })

        assert(validItemType:isCyclopediaItem() == true, "Valid Cyclopedia item must return true")
        assert(nonCycItemType:isCyclopediaItem() == false, "Non-Cyclopedia item must return false")
        assert(emptyItemType:isCyclopediaItem() == false, "ItemType without getCyclopediaType must return false")
    )lua";

    const int status = luaL_dostring(L, script);
    if (status != 0) {
        const char* err = lua_tostring(L, -1);
        FAIL() << "Lua execution failed: " << (err ? err : "unknown error");
    }

    lua_close(L);
}

