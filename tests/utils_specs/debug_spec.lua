local _debug = require "fs.utils.debug"
local config = require "fs.config"
local path = config.opts.debug.file_name

describe("debug", function()
  local function read_all(path)
    local f = io.open(path, "r")
    if f then
      return f:read "*all"
    end
  end

  before_each(function()
    vim.fn.delete(path)
  end)

  after_each(function()
    vim.fn.delete(path)
  end)

  it("writes to the file", function()
    local log = "log test message"

    config.set {
      debug = {
        enabled = false,
      },
    }

    _debug.write_log(log, path, "w+")

    assert.are.equal(log, read_all(path))
  end)

  it("saves the log in the variable", function()
    config.set {
      debug = {
        enabled = false,
      },
    }

    _debug.save_log("INFO", "test")

    assert.are.equal(true, _debug.LOGS_HISTORY[1] ~= nil)
    assert.are.equal(true, not not string.find(_debug.LOGS_HISTORY[1], "INFO: test"))
    assert.are_not.equal(1, vim.fn.filereadable(path))
  end)

  it("saves the log to file", function()
    local log = "log test message"

    config.set {
      debug = {
        enabled = true,
      },
    }

    _debug.save_log("INFO", log)

    assert.are.equal(true, not not string.find(read_all(path), log))
  end)
end)
