---@tag fiveserver.process

---@brief [[
---
---This module is responsible for managing the Five Server instances.
---
---To use: `require "fs.utils.process"`
---
---@brief ]]

local logger = require "fs.utils.logger"
local debug = require "fs.utils.debug"
local config = require "fs.config"
local rc = require "fs.utils.rc"

local M = {}

---List of processes
M.PROCESS_LIST = {}

---Adds a process to the process list.
---@param path string: path associated with the process.
---@param job_id number: job ID associated with the process.
---@param command string: command used.
function M.add_process(path, job_id, command)
  local process = {
    path = path,
    command = command,
  }

  M.PROCESS_LIST[job_id] = process

  debug.debug_log("INFO", ("added instance ID: %s process: %s"):format(job_id, vim.inspect(process)))
end

---Checks if a path has an associated instance.
---@param path string: path to check.
---@return boolean: path associated with the instance.
function M.path_has_instance(path)
  for _, vals in pairs(M.PROCESS_LIST) do
    if vals.path == path then
      return true
    end
  end

  return false
end

---Returns the first Job ID found that is associated with the PATH.
---@param path string: path to check.
---@return number|nil: job ID associated with the path, or nil if no match is found.
function M.get_path_instance(path)
  for job_id, vals in pairs(M.PROCESS_LIST) do
    if vals.path == path then
      return job_id
    end
  end

  return nil
end

---Checks if a Job exists through the process list.
---@param id number: job ID to check.
---@return boolean: true if the job exists, and false otherwise.
function M.job_exists(id)
  local process = M.PROCESS_LIST[id]

  if type(process) == "table" and not vim.tbl_isempty(process) then
    return true
  end

  return false
end

---Gets the process associated with a job ID.
---@param id number: job ID.
---@return table|nil: returns the process if it exists, or nil otherwise.
function M.get_process(id)
  if M.job_exists(id) then
    return M.PROCESS_LIST[id]
  end

  return nil
end

---Internal function to start the Five Server process.
---@param command string: command to start the Five Server process.
---@return number: job ID if started.
function M._start_fs(command)
  local job_id = vim.fn.jobstart(command, {

    on_stderr = function(id, data)
      logger.handle_stderr(id, data)
    end,

    on_stdout = function(id, data)
      logger.handle_stdout(id, data)
    end,

    on_exit = function(id, code)
      logger.logger_info("Five Server stopped with code: " .. tostring(code))
      M.remove_process(id)
    end,
  })

  return job_id
end

---Removes a process from the process list.
---@param id number: ID of the process to remove.
---@return boolean: return true If the removal was successful, or false otherwise.
function M.remove_process(id)
  if M.job_exists(id) then
    M.PROCESS_LIST[id] = nil
    debug.debug_log("INFO", "instance removed with sucess. ID: " .. id)
    return true
  end

  debug.debug_log("INFO", "failed when trying to remove job. ID: " .. id)
  return false
end

---Starts the Five Server process.
---@param command? string: command to start the Five Server process.
---@param force? boolean: Whether to force the start even if an instance already exists for the directory.
function M.start(command, force)
  local path = vim.fn.getcwd()
  local has_rc = rc.has_rc(config.opts.fiveserverrc.gen_rc.path)
  command = command or config.opts.bin

  if M.path_has_instance(path) and not force then
    logger.logger_warn "An instance already exists for this directory"
    return
  end

  -- if vim.tbl_isempty(vim.version.parse(vim.fn.system { config.opts.bin, "--version" })) then
  --   logger.logger_error "Five Server not found, check your config.bin."
  --   return nil
  -- end

  if config.opts.fiveserverrc.gen_rc.before_start then
    if not has_rc then
      rc.gen_rc()
    elseif has_rc and config.opts.fiveserverrc.gen_rc.force then
      rc.gen_rc(nil, true)
    end
  end

  local job_id = M._start_fs(command)
  -- if job_id then
  M.add_process(path, job_id, command)

  return job_id
end

---Stop a process using the Job ID.
---@param id number: ID of the process to stop.
function M.stop(id)
  if not M.job_exists(id) then
    logger.logger_warn "Job ID does not match any Job."
    return
  end

  vim.fn.jobstop(id)
end

return M
