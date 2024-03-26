---@tag fiveserver.logger

---@brief [[
---
---This module is responsible for logging messages,
---sending notifications and handling output from the Five Server
---
---To use: `require "fs.utils.logger"`
---
---@brief ]]

local debug = require "fs.utils.debug"
local config = require "fs.config"
local levels = vim.log.levels

local M = {}

---Converts a vim.log.level to string representation.
---@param level number: the vim.log.level.
---@return string: string representation of vim.log.level.
function M.level_to_str(level)
  local log_type = { "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "OFF" }
  return log_type[level + 1]
end

---Handles data.
---Remove ANSI color
---Trimming text
---@param data table: Job output data
---@param level number: log level.
function M._handle_data(data, level)
  local msg = table.concat(data)
  msg = msg:gsub("\27%[[%d+;]*%d*[m]", "")
  msg = vim.trim(msg)

  if msg ~= "" then
    debug.debug_log(M.level_to_str(level), vim.trim(msg))
    M.logger(msg, level)
  end
end

---Send a notification.
---@param message string: message.
---@param level number: the vim.log.level.
---@param options? table: additional options for notify.
function M.logger(message, level, options)
  if config.opts.notify then
    vim.notify(message, level, options or { title = "Five Server" })
  end
end

---Send a warning notification.
---@param message string: message.
---@param options? table: additional options for notify.
function M.logger_warn(message, options)
  M.logger(message, levels.WARN, options)
end

---Send an informational notification.
---@param message string: message.
---@param options? table: additional options for notify.
function M.logger_info(message, options)
  M.logger(message, levels.INFO, options)
end

---Send an error notification.
---@param message string: message.
---@param options? table: additional options for notify.
function M.logger_error(message, options)
  M.logger(message, levels.ERROR, options)
end

---Handles output messages.
---@param _? number: process ID.
---@param data table: output data.
function M.handle_stdout(_, data)
  M._handle_data(data, levels.INFO)
end

---Handles error messages.
---@param _? number: process ID.
---@param data table: error data.
function M.handle_stderr(_, data)
  M._handle_data(data, levels.ERROR)
end

return M
