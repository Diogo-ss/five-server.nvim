local config = require "fs.config"
local rc = require "fs.utils.rc"
local rc_path = config.opts.fiveserverrc.gen_rc.path

describe("fiveserverrc", function()
  local function read_all(path)
    local f = io.open(path, "r")
    if f then
      return f:read "*all"
    end
  end

  before_each(function()
    vim.fn.delete(rc_path)
  end)

  after_each(function()
    vim.fn.delete(rc_path)
  end)

  it("generate rc", function()
    local log = "without force"

    config.set {
      notify = false,
      fiveserverrc = {
        config = {
          test_fild = log,
        },
      },
    }

    rc.gen_rc(rc_path, false)

    assert.are.same(true, not not string.match(read_all(rc_path), "without force"))
  end)

  it("generate rc with force mode", function()
    local log = "with force"

    config.set {
      notify = false,
      fiveserverrc = {
        config = {
          test_fild = log,
        },
      },
    }

    rc.gen_rc(rc_path, true)

    assert.are.same(true, not not string.match(read_all(rc_path), log))
  end)

  it("check the existence of the rc", function()
    config.set {
      notify = false,
    }

    rc.gen_rc(rc_path, true)

    assert.are.same(true, rc.has_rc(rc_path))
  end)

  it("generate rc with underscore gen", function()
    local log = "with underscore"

    config.set {
      notify = false,
      fiveserverrc = {
        config = {
          test_fild = log,
        },
      },
    }

    rc._gen_rc(rc_path)

    assert.are.same(true, not not string.match(read_all(rc_path), log))
  end)
end)
