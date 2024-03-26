---@tag fiveserver.setup

---@brief [[
---
---This module is responsible for configuring the Five Server Plugin based on user options.
---
---To apply your options: `require("fs").setup({})`
---
---@brief ]]

local config = require "fs.config"
local logger = require "fs.utils.logger"
local commands = require "fs.utils.commands"

local M = {}

---Applies the user options and creates the `FiveServer` command.
---@param opts table: options for configuring the plugin.
function M.setup(opts)
  config.set(opts)

  ---Create command: `FiveServer`
  vim.api.nvim_create_user_command("FiveServer", function(infos)
    local flag = infos.fargs[1]

    if not commands.flags[flag] then
      logger.logger_warn("This command does not exist: " .. flag)
      return
    end

    commands.flags[flag].execute(infos.fargs[2])
  end, {
    desc = "Start or stop a job; Generate the five-server rc",
    nargs = "+",

    complete = function(lead_arg, cmd)
      local args = vim.split(cmd, "%s+", { trimempty = true })
      local has_space = string.match(cmd, "%s$")
      local flags = vim.tbl_keys(commands.flags)
      local has_valid_flag = vim.tbl_contains(flags, args[2])
      local sub_flags = {}

      if has_valid_flag and #args >= 2 then
        local ok, _sub_flags = pcall(commands.flags[args[2]].sub_flags)
        if ok and type(_sub_flags) == "table" then
          sub_flags = _sub_flags
        end
      end

      if #args == 1 then
        return flags
      elseif #args == 2 and not has_space then
        return commands.flag_filter(lead_arg, flags)
      elseif #args == 2 and has_valid_flag and has_space then
        return sub_flags
      elseif #args == 3 and has_valid_flag and not has_space then
        return commands.filter(lead_arg, sub_flags)
      end
    end,
  })
end

return M
