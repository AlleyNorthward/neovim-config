require("plugin-config.plugins")
require("plugin-config.bufferline")
require("plugin-config.nvim_tree")
require("plugin-config.nvim_treesitter")
-- require("plugin-config.lualine") 

local lualine_operation = require("data.plugin_data")
lualine_operation.delete("lualine_data") -- 可选参数:true

