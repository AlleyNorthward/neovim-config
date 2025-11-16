require("basic")
require("autocommand")
require("keybindings")
require("plugins")
require("colorscheme")
require("plugin-config.nvim-tree")
require("plugin-config.bufferline")
require("plugin-config.lualine")
require("plugin-config.nvim-treesitter")


vim.cmd [[
  hi normal guibg=none ctermbg=none
  hi normalnc guibg=none ctermbg=none
  hi signcolumn guibg=none
  hi linenr guibg=none
  hi foldcolumn guibg=none
  hi endofbuffer guibg=none
]]

