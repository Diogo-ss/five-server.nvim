# Five-Server for Nvim

Integrates Five-Server and Neovim. View dynamic and static pages.

## 🚀 Showcase

<img src="https://i.ibb.co/SXBQdmG/14dadc49-f7db-4e57-8560-e0c6a2935d2b.gif" border="0">

## ✨ Features:

- Bebug via notify (optional)
- Log file (optional)
- Supports fiveserverrc
- Automatic installation with NPM or PNPM
- No global installation required
- Multiple instances in a single Neovim session

## 🎯 Requirements

`NPM` or `PNPM` installed.

## 🛠 Installation

### Lazy.nvim

```lua
{
  "Diogo-ss/five-server.nvim",
  cmd = { "FiveServer" },
  build = function()
    require "fs.utils.install"()
  end,
  opts = {
    notify = true,
    -- add other options
  },
  config = function(_, opts)
    require("fs").setup(opts)
  end,
}
```
### Packer.nvim

```lua
use {
  "Diogo-ss/five-server.nvim",
  cmd = { "FiveServer" },
  run = function()
    require "fs.utils.install"()
  end,
  config = function()
    require("fs").setup({
    notify = true,
    -- add other options
  })
  end
}
```

## ⚙ options

These are the standard options. Change them according to your needs.

```lua
{
  -- configure debug.
  debug = {
    -- enables or disables debug.
    enabled = false,
    -- log filename.
    file_name = "fs-debug.log",
  },
  -- Five Server bin directory.
  -- if installed globally, use: `bin = "five-server"`
  bin = vim.fn.stdpath("data") .. "/five-server/node_modules/.bin/five-server",
  -- Directory for installing Five Server
  path = vim.fn.stdpath("data") .. "/five-server",
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
    -- settings to be saved in Five-Server RC.
    -- the key name and value will be used.
    config = {
      -- set the server port.
      port = 5500,
      -- the output level.
      logLevel = 3,

      -- see all options in: https://github.com/yandeu/five-server/blob/main/src/types.ts
    },
  },
}
```

## 🔧 Config File

Configure Five-Server differently for each directory, using `fiverserverrc`. All options available: [`types.ts`](https://github.com/yandeu/five-server/blob/main/src/types.ts). </br>
In the base directory, create the file `.fiveserverrc`

```json
{
  "port": 5500,
  "open": "index.html"
}
```

## 🎨 Commands

All commands use auto complete, allowing you to use flags to change their behavior. </br>

`:FiveServer start`: starts an instance in the current directory. </br>
`:FiveServer start --force`: force start another instance in the current directory. </br>
`:FiveServer stop`: stop instance of current directory. </br>
`:FiveServer stop <id>`: enter the ID of the instance to be stopped (all valid IDs will be provided). </br>
`:FiveServer gen_rc`: generates a config file based on the user configuration. </br>
`:FiveServer gen_rc --force`: generates a config file based on the user options. If a config already exists, it will be overwritten. </br>
`:FiveServer install`: install the five-server client using NPM or PNPM.
