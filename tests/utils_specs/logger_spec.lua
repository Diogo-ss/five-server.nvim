local logger = require "fs.utils.logger"
local levels = vim.log.levels

describe("logger", function()
  it("level to str", function()
    local c = logger.level_to_str

    assert.are.same("TRACE", c(levels.TRACE))
    assert.are.same("DEBUG", c(levels.DEBUG))
    assert.are.same("INFO", c(levels.INFO))
    assert.are.same("WARN", c(levels.WARN))
    assert.are.same("ERROR", c(levels.ERROR))
    assert.are.same("OFF", c(levels.OFF))
  end)
end)
