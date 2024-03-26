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

  if vim.fn.executable(config.opts.bin) == 1 then
    logger.logger_info "Five-Server is ready to use."
    return
  end

  local package_managers = vim.tbl_filter(function(val)
    return vim.fn.executable(val) == 1
  end, { "npm", "pnpm" })

  if #package_managers > 0 then
    if vim.fn.isdirectory(path) ~= 1 then
      vim.fn.mkdir(path, "p")
    end

    cmd { package_managers[1], "install", "five-server", "--prefix", path }
  else
    logger.logger_error "No package manager found (NPM ou PNPM)."
  end
end

return install
