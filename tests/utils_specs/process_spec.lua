local config = require "fs.config"
local process = require "fs.utils.process"
local rc = require "fs.utils.rc"
local debug_path = config.opts.debug.file_name
local rc_path = config.opts.fiveserverrc.gen_rc.path

describe("process", function()
  local function stop_all()
    for id, _ in pairs(process.PROCESS_LIST) do
      process.stop(id)
      process.remove_process(id)
    end
  end

  local function read_all(path)
    local f = io.open(path, "r")
    if f then
      return f:read "*all"
    end
  end

  before_each(function()
    vim.fn.delete(debug_path)
    vim.fn.delete(rc_path)
  end)

  after_each(function()
    stop_all()
    vim.fn.delete(debug_path)
    vim.fn.delete(rc_path)
  end)

  it("add new process", function()
    local temp = "temp/"
    local job_id = 100
    local cmd = "five-server"

    process.add_process("temp/", job_id, cmd)

    assert.are.equals(cmd, process.PROCESS_LIST[100].command)
    assert.are.equals(temp, process.PROCESS_LIST[100].path)
    assert.are.equals(true, vim.tbl_contains(vim.tbl_keys(process.PROCESS_LIST), job_id))
  end)

  it("removes all instances from the process list", function()
    config.set { notify = false }
    process.start(config.opts.bin, true)

    local num = #vim.tbl_keys(process.PROCESS_LIST)

    for id, _ in pairs(process.PROCESS_LIST) do
      process.remove_process(id)
    end

    assert.are_not.equals(num, #vim.tbl_keys(process.PROCESS_LIST))
  end)

  it("check that the current directory has no instances", function()
    local exists = process.path_has_instance(vim.fn.getcwd())
    assert.are.equals(false, exists)
  end)

  it("try to get non-existent instances for the current directory using path", function()
    local job_id = process.get_path_instance(vim.fn.getcwd())
    assert.are.same(nil, job_id)
  end)

  it("search for an instance in the current directory", function()
    config.set { notify = false }

    process.start(config.opts.bin, true)

    local exists = process.path_has_instance(vim.fn.getcwd())
    assert.are.equals(true, exists)
  end)

  it("starts two instances in a forced mode", function()
    config.set { notify = false }

    local num = #vim.tbl_keys(process.PROCESS_LIST)

    process.start(config.opts.bin, true)
    process.start(config.opts.bin, true)

    assert.are.equals(num, #vim.tbl_keys(process.PROCESS_LIST) - 2)
  end)

  it("stop all active instances and clear process list", function()
    process.start(config.opts.bin, true)
    process.start(config.opts.bin, true)

    stop_all()

    assert.are.same(0, #vim.tbl_keys(process.PROCESS_LIST))
  end)

  it("starts instance and generates fiveserverrc", function()
    local log = "start gen rc with force"

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

    process.start(config.opts.bin)

    assert.are.equals(true, not not string.match(read_all(rc_path), log))
  end)

  it("starts the instance and generates rc, with force mode", function()
    local log = "start gen rc without force"

    config.set {
      fiveserverrc = {
        config = {
          port = 5500,
        },
      },
    }

    rc.gen_rc(nil, true)

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

    process.start(config.opts.bin, true)

    assert.are.equals(true, not not string.match(read_all(rc_path), log))
  end)
end)
