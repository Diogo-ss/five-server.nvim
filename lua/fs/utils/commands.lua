---@tag fiveserver.commands

---@brief [[
---
---Documentation for the Five Server commands:
---
--- - `:FiveServer start`: Start an instance of the five server.
---                       You can use the `--force` flag to start
---                       an instance in the current directory, even
---                       if one already exists.
---
--- - `:FiveServer stop`: Stop an instance in the current directory.
---                      It is possible to stop another instance of a
---                      different directory from the current one,
---                      just pass the id as an argument, and you can
---                      select an instance that will be listed on the command line.
---
--- - `:FiveServer gen_rc`: Generate a configuration file (fiveserverrc)
---                        based on the setup configuration. Use the `--force`
---                        flag to generate another file even if one already
---                        exists in the current directory.
---
---NOTE: The commands will only be available after running setup().
---
---@brief ]]

local M = {}

local process = require "fs.utils.process"
local logger = require "fs.utils.logger"
local rc = require "fs.utils.rc"

-- `sub_flags` returns a function that gets the sub flags.
-- `execute` receives the chosen sub_flag,
-- relaizing a different task for each one.

---Table containing flags and their corresponding functions.
M.flags = {
  ---Start flag.
  start = {
    ---@return table: sub flags options.
    sub_flags = function()
      return { "--force" }
    end,

    ---Executes an action according to the flag.
    ---@param flag string: sub flag chosen.
    execute = function(flag)
      if flag == "--force" then
        process.start(nil, true)
        return
      end

      process.start()
    end,
  },

  ---Stop flag.
  stop = {
    ---@return table: ID of all active instances.
    sub_flags = function()
      return vim.tbl_map(tostring, vim.tbl_keys(process.PROCESS_LIST))
    end,

    ---Stop Job with corresponding ID.
    ---@param id string: The ID of the process to stop.
    execute = function(id)
      id = tonumber(id) or process.get_path_instance(vim.fn.getcwd())

      if not process.job_exists(id) then
        logger.logger_warn "Job not found"
        return
      end

      process.stop(id)
    end,
  },

  ---Generate RC.
  gen_rc = {
    ---@return table: sub flags options.
    sub_flags = function()
      return { "--force" }
    end,

    ---Executes an action according to the flag.
    ---@param flag string: sub flag chosen.
    execute = function(flag)
      if flag == "--force" then
        rc.gen_rc(nil, true)
        return
      end

      rc.gen_rc()
    end,
  },

  install = {
    execute = function(_)
      require "fs.utils.install"()
    end
  }

}

---Filters flags based on a leading argument.
---@param lead_arg string: The leading argument to filter flags.
---@param flags table: flags Table containing flags to filter.
---@return table: Filtered flags based on the leading argument.
function M.flag_filter(lead_arg, flags)
  return vim.tbl_filter(function(val)
    return vim.startswith(val, lead_arg)
  end, flags)
end

return M
