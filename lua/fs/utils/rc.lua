---@tag fiveserver.rc

---@brief [[
---
---This module is responsible for managing fiveserverrc.
---It can generate a configuration file based on the
---pluguin configuration and also check its existence.
---
---To use: `require "fs.utils.rc"`
---
---@brief ]]

local logger = require "fs.utils.logger"
local config = require "fs.config"

local M = {}

---Checks if the fiveserverrc file exists.
---@param path string|nil: path to check for the existence of the fiveserverrc.
---@return boolean: true if the fiveserverrc file exists; otherwise, false.
function M.has_rc(path)
  return vim.fn.filereadable(path) > 0
end

---Write in fiveserverrc.
---@param path string: full file PATH
function M._gen_rc(path)
  local rc_json = vim.json.encode(config.opts.fiveserverrc.config)

  local f = io.open(path, "w+")
  if f then
    f:write(rc_json)
    f:close()
    logger.logger_info(("Fiveserverrc generated in `%s`.\nLearn more: %s"):format(path, "https://github.com/yandeu/five-server/blob/main/src/types.ts"))
    return
  end
  logger.logger_error "Error while trying to generate fiveserverrc"
end

---Generate fiveserverrc file.
---@param path string|nil: path to generate the fiveserverrc file.
---@param force boolean|nil: if true, force the generation of the fiveserverrc file even if it already exists.
function M.gen_rc(path, force)
  path = path or config.opts.fiveserverrc.gen_rc.path

  if M.has_rc(path) and not force then
    local response = vim.fn.input "There is already a fiveserverrc. Would you like to generate another one? [y/N]: "
    if response:lower() ~= "y" then
      logger.logger_warn "Operation canceled."
      return
    end
  end

  M._gen_rc(path)
end

return M
