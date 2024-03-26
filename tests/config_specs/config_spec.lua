local config = require "fs.config"

describe("set config", function()
  it("applay default config", function()
    local _config = config

    config.set(config.opts)

    assert.are.same(config.opts, _config.opts)
  end)

  it("apply a different configuration", function()
    local _opts = config.opts

    config.set { debug = false }

    assert.are_not.equal(config.opts, _opts)
  end)

  it("add new configuration field to fiveserverrc", function()
    config.set { fiveserverrc = { config = { port = 5500 } } }

    assert.are.equal(5500, config.opts.fiveserverrc.config.port)
  end)
end)
