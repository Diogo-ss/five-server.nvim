---@tag fiveserver.debug

---@brief [[
---
--- This module is responsible for debug.
--- Responsible for saving the log in a variable and also in a file.
--- It can be called using like:
---
---To use: `require "fs.utils.debug"`
---
---@brief ]]

local config = require "fs.config"

local M = {}

---Ensures that the debug has been cleared
M.CLEAN_DEBUG = false
---History of logs.
M.LOGS_HISTORY = {}

---Writes contents to a file.
---@param contents string: The contents to write to the file.
---@param path string: file PATH.
---@param mode string: mode to open the file in ("w+" for write, "a+" for append).
function M.write_log(contents, path, mode)
  local f = io.open(path, mode)
  if f then
    f:write(contents)
    f:close()
  end
end

---Saves a log message.
---@param log_type string: log type.
---@param message string: message.
function M.save_log(log_type, message)
  message = tostring(message):gsub("\n", " ")
  local timestamp = os.date "%Y-%m-%d %H:%M:%S"
  local log_entry = ("[%s] %s: %s\n"):format(timestamp, log_type:upper(), message)

  table.insert(M.LOGS_HISTORY, log_entry)

  if config.opts.debug.enabled then
    local mode = M.CLEAN_DEBUG and "a+" or "w+"
    M.write_log(log_entry, config.opts.debug.file_name, mode)
    M.CLEAN_DEBUG = true
  end
end

---Send a message to the log
---@param log_type string: log type.
---@param message string: message.
function M.debug_log(log_type, message)
  M.save_log(log_type, message)
end

return M
