local M = {}

---Applies the user options to the default table.
---@param opts table: settings
M.set = function(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
end

M.opts = {
  -- configure debug.
  debug = {
    -- enables or disables debug.
    enabled = false,
    -- log filename.
    file_name = "fs-debug.log",
  },
  -- Five Server bin directory.
  -- if installed globally, use: `bin = "five-server"`
  bin = vim.fn.stdpath "data" .. "/five-server/node_modules/.bin/five-server",
  -- Directory for installing Five Server
  path = vim.fn.stdpath "data" .. "/five-server",
  -- notifications on the interface.
  notify = true,
  -- configure Five Server RC.
  fiveserverrc = {
    -- RC generation settings.
    gen_rc = {
      -- generate RC before starting Five Server.
      before_start = false,
      -- forces the RC to be generated. If a RC already exists, it will be overwritten.
      force = false,
      -- RC filename (not recommended to change).
      path = ".fiveserverrc",
    },
    -- settings to be saved in Five Server RC.
    -- the key name and value will be used.
    -- see all options in: https://github.com/yandeu/five-server/blob/main/src/types.ts
    config = {
      --- set the server port.
      -- port = 5500,

      --- the output level.
      -- logLevel = 3,

      -- ...
    },
  },
}

return M
