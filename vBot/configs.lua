--[[
    Configs for modules
    Based on Kondrah storage method
--]]
local configName = modules.game_bot.contentsPanel.config:getCurrentOption().text

-- make vBot config dir
if not g_resources.directoryExists("/bot/".. configName .."/vBot_configs/") then
  g_resources.makeDir("/bot/".. configName .."/vBot_configs/")
end
if not g_resources.directoryExists("/bot/".. configName .."/vBot_configs/Storage") then
  g_resources.makeDir("/bot/".. configName .."/vBot_configs/Storage")
end

HealBotConfig = {}
local healBotFile = "/bot/" .. configName .. "/vBot_configs/HealBot.json"
AttackBotConfig = {}
local attackBotFile = "/bot/" .. configName .. "/vBot_configs/AttackBot.json"
SuppliesConfig = {}
local suppliesFile = "/bot/" .. configName .. "/vBot_configs/Supplies.json"
StorageConfig = {}
local storageFile = "/bot/" .. configName .. "/vBot_configs/Storage/".. player:getName() ..".json"


--healbot
if g_resources.fileExists(healBotFile) then
    local status, result = pcall(function()
      return json.decode(g_resources.readFileContents(healBotFile))
    end)
    if not status then
      return onError("Error while reading config file (" .. healBotFile .. "). To fix this problem you can delete HealBot.json. Details: " .. result)
    end
    HealBotConfig = result
end

--attackbot
if g_resources.fileExists(attackBotFile) then
    local status, result = pcall(function()
      return json.decode(g_resources.readFileContents(attackBotFile))
    end)
    if not status then
      return onError("Error while reading config file (" .. attackBotFile .. "). To fix this problem you can delete HealBot.json. Details: " .. result)
    end
    AttackBotConfig = result
end

--supplies
if g_resources.fileExists(suppliesFile) then
    local status, result = pcall(function()
      return json.decode(g_resources.readFileContents(suppliesFile))
    end)
    if not status then
      return onError("Error while reading config file (" .. suppliesFile .. "). To fix this problem you can delete HealBot.json. Details: " .. result)
    end
    SuppliesConfig = result
end

--storage
if g_resources.fileExists(storageFile) then
    local status, result = pcall(function()
      return json.decode(g_resources.readFileContents(storageFile))
    end)
    if not status then
      return onError("Error while reading config file (" .. storageFile .. "). To fix this problem you can delete HealBot.json. Details: " .. result)
    end
    StorageConfig = result
end

function vBotConfigSave(file)
  -- file can be either
  --- heal
  --- atk
  --- supply
  --- storage
  local configFile
  local configTable
  if not file then return end
  file = file:lower()
  if file == "heal" then
      configFile = healBotFile
      configTable = HealBotConfig
  elseif file == "atk" then
      configFile = attackBotFile
      configTable = AttackBotConfig
	elseif file == "supply" then
			configFile = suppliesFile
			configTable = SuppliesConfig
	elseif file == "storage" then
			configFile = storageFile
			configTable = StorageConfig
  else
    return
  end

  local status, result = pcall(function()
    return json.encode(configTable, 2)
  end)
  if not status then
    return onError("Error while saving config. it won't be saved. Details: " .. result)
  end

  if result:len() > 100 * 1024 * 1024 then
    return onError("config file is too big, above 100MB, it won't be saved")
  end

  g_resources.writeFileContents(configFile, result)
end
