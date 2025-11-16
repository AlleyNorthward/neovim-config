local packer = require("packer")
packer.startup(
    function(use)
        -- Packer 可以管理自己本身
        use 'wbthomason/packer.nvim'
        -- 主题
        use("folke/tokyonight.nvim")
        use("mhartington/oceanic-next")
        use({"ellisonleao/gruvbox.nvim", requires = {"rktjmp/lush.nvim"}})
        use("shaunsingh/nord.nvim")
        use("ful1e5/onedark.nvim")
        use("EdenEast/nightfox.nvim")

        -- 树
        use({"kyazdani42/nvim-tree.lua", requires = "kyazdani42/nvim-web-devicons"})

        -- bufferline
        use({ "akinsho/bufferline.nvim", requires = { "kyazdani42/nvim-web-devicons", "moll/vim-bbye" }})

        -- lualine
        use({ "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons" } })
        use("arkav/lualine-lsp-progress")

        -- treesitter 代码高亮
        use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
    end
)

-- 每次保存 plugins.lua 自动安装插件

pcall(
  vim.cmd,
  [[
    augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
  ]]
)
