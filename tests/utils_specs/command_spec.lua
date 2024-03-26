local config = require "fs.config"
local rc = require "fs.utils.rc"
local rc_path = config.opts.fiveserverrc.gen_rc.path
local fs = require "fs"
local process = require "fs.utils.process"

describe("command", function()
  local function read_all(path)
    local f = io.open(path, "r")
    if f then
      return f:read "*all"
    end
  end

  local function stop_all()
    for id, _ in pairs(process.PROCESS_LIST) do
      process.stop(id)
      process.remove_process(id)
    end
  end

  before_each(function()
    vim.fn.delete(rc_path)
    fs.setup { notify = false }
    stop_all()
  end)

  after_each(function()
    vim.fn.delete(rc_path)
    stop_all()
  end)

  it("generate rc using command", function()
    vim.cmd "FiveServer gen_rc"

    assert.are.same(true, rc.has_rc(rc_path))
  end)

  it("generate rc using command with --force", function()
    vim.cmd "FiveServer gen_rc"

    local log = "start gen rc without force"
    config.set {
      notify = false,
      fiveserverrc = {
        config = {
          test_fild = log,
        },
        gen_rc = {
          before_start = true,
          force = true,
        },
      },
    }

    vim.cmd "FiveServer gen_rc --force"

    assert.are.equals(true, not not string.match(read_all(rc_path), log))
  end)

  it("start a instance with command", function()
    vim.cmd "FiveServer start"

    local has = process.path_has_instance(vim.fn.getcwd())

    assert.are.same(true, has)
  end)

  it("start a instance with command and force mode", function()
    vim.cmd "FiveServer start"
    vim.cmd "FiveServer start --force"

    local num = #vim.tbl_keys(process.PROCESS_LIST)

    assert.are.equals(2, num)
  end)

  -- TODO: stop test
  -- I'm still working out the best way to test the stop,
  -- as the process is removed after the job stops,
  -- which happens asynchronously.
end)
