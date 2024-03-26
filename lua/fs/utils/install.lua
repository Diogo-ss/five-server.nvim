local config = require "fs.config"
local logger = require "fs.utils.logger"

local function cmd(command)
  logger.logger_info("Starting installation with: " .. tostring(command[1]))

  vim.fn.jobstart(command, {
    on_exit = function(_, code)
      if code ~= 0 then
        logger.logger_error("Error when trying to install with: " .. table.concat(command, " "))
      else
        logger.logger_info "Five Server was installed."
      end
    end,
  })
end

local function install(path)
  path = path or config.opts.path

  if vim.fn.isdirectory(path) ~= 1 then
    vim.fn.mkdir(path, "p")
  end

  if vim.fn.executable "npm" == 1 then
    cmd { "npm", "install", "five-server", "--prefix", path }
    return
  end

  if vim.fn.executable "pnpm" == 1 then
    cmd { "pnpm", "install", "five-server", "--prefix", path }
    return
  end

  logger.logger_error "No package manager found (npm or pnpm)."
end

return install
