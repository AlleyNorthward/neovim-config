call_back_func = require("utils.call_back_func")
General_Func = require("utils.func")

local status_api, api = pcall(require, "nvim-tree.api")
if not status_api then
    vim.notify("没有nvim-tree模块.", vim.log.levels.INFO)
    return
end

-- 插件快捷键
local pluginKeys = {}

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- local map = vim.api.nvim_set_keymap  老版本映射, 现在改成新版本
-- local opt = {noremap = true, silent = true}

local map = vim.keymap.set
local opts = {noremap = true, silent = true}

--[[ 日志
    @author 巷北
    @time 2025.11.14 21:29
        这部分是自定义映射部分, 虽然练习了一段时间的vim, 但肯定有些按键还不知晓
    其作用, 所以自定义映射的话, 还是比较担心的, 万一之后用到, 怎么办呢?所以打算
    对于一些对我个人而言, 将一些不常用的, 或者有好的替代的(重复的)按键, 给取消
    映射掉, 这样就能比较好地拓展一下.

    @author 巷北
    @time 2025.11.16 15:13
        昨天弄了弄lsp, 参考资料是22年的, 这段时间, 其内部用到的插件也更新了很多
    所以直接copy代码的话, 也是失败了.稍微有些受挫.
        但是呢, 参考别人代码还是稍微让我知道了些lua配置neovim的方式, 从原来的完
    不懂, 到如今能稍微写一写代码.只不过, 在插件方面, 还是有些问题.
        思考了一下, 其实还是对于api接口很不熟悉, 自己弄, 或者问ai, 存在极大的不
    确定性.但是文档也看不懂, 所以非常受挫.
        今天, 参考了一下某插件的部分按键绑定, 结合之前写好的按键绑定代码, 有了
    一定的认识. lua跟python都是动态语言, 所以有些东西(尤其是函数方面)非常类似, 
    也很感谢之前深入了解了python, 再加上嵌入式中理解的回调函数, 在配置neovim按
    键绑定时, 能让我非常快速地理解这是在干什么. 结合ai呢, 能够让我了解neovim中
    lua相关接口.
        以前的想法是, 学习一个新东西, 快速弄出来, 然后迅速投入应用. 但是实践后,
    总在告诉我, 一口吃不成个胖子. 将其放入生活之中, 变成一种习惯, 日久天长, 方
    可成功. 而配置neovim亦是如此.
        之前弄vim时, 对vimscrit语言十分不熟悉, 所以想快速配置, 所以一直问ai, 现
    在有了lua, 其实就好很多了.以前在纠结, 是否需要什么都去专门学习一下, 回想一
    下, 还是有必要的, 只是不要太着急, 放到日常中, 慢慢来, 就会好很多.
        所以现在lsp也不着急弄, 就先专门练习一下按键绑定, 等熟练后, 看得懂文档后,
    再去弄lsp, 也不晚.
]]

--[[ 映射规定
    一.宏观要求
    (1) 组合按键, 小写跟小写在一块, 大写跟大写在一块
    二.移动方面
    (1) 单按键hjkl HJKL表示移动
    (2) 组合按键, 可以使用ctrl hjkl(不可以使用ctrl HJKL, 有bug)
    (3) 可以使用alt hjkl, 但是alt不太好按, 所以就给一些不经常用到的移动问题
]]

--[[ 下面的设计思想.
    (1) 映射部分, 点明移除vim原生按键
    (2) 分屏, 调整屏幕, 
]]

-- 一.映射部分
-- (1)s是替换字符, 替换后进入插入模式, 比较鸡肋, 修改的话, 用r比较好.
map("n", "s", "", opts)
-- (2) S是删除一行, 并进入插入模式.有类似的
map("n", "S", "", opts) 
-- (3) L比较奇怪吧, 去末尾, 取消了,可以n+j,可以G
map("n", "L", "", opts)
-- (4) H是去头部, 跟gg类似, 取消了
map("n", "H", "", opts)
-- (5) K是显示某些东西, 这里映射取消了
map("n", "K", "", opts)
-- (6) J是合并一行, 但是感觉之后很少用到, 取消了
map("n", "J", "", opts)

-- 二.分屏相关快捷键这里相关的只用S, 本意是分屏, 其余的是
-- (1) windows 分屏快捷键
map("n", "sv", ":vsp<CR>", opts)
map("n", "sh", ":sp<CR>", opts) 
-- (2) 关闭当前
map("n", "so", "<C-w>c", opts)
-- (3) 关闭其他
map("n", "sc", "<C-w>o", opts)
-- (4) 调整左右比例
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-RIGHT>", ":vertical resize +2<CR>", opts)
map("n", "<A-l>", ":vertical resize +10<CR>", opts)
map("n", "<A-h>", ":vertical resize -10<CR>", opts)
-- (5) 调整上下比例
map("n", "<A-j>", ":resize +2<CR>", opts)
map("n", "<A-k>", ":resize -2<CR>", opts)
map("n", "<C-Down>", ":resize +2<CR>", opts)
map("n", "<C-Up>", ":resize -2<CR>", opts)
-- (6) 等比例
map("n", "<A-e>", "<C-w>=", opts)
-- (7) Alt + hjkl 窗口之间跳转
map("n", "H", "<C-w>h", opts)
map("n", "J", "<C-w>j", opts)
map("n", "K", "<C-w>k", opts)
map("n", "L", "<C-w>l", opts)

-- 三.Terminal模式配置
map("n", "<leader>t", ":sp | terminal<CR>", opts)
map("n", "<leader>vt", ":vsp | terminal<CR>", opts)
map("t", "<Esc>", "<C-\\><C-n>", opts)
map("t", "H", [[ <C-\><C-N><C-w>h ]], opts)
map("t", "J", [[ <C-\><C-N><C-w>j ]], opts)
map("t", "K", [[ <C-\><C-N><C-w>k ]], opts)
map("t", "L", [[ <C-\><C-N><C-w>l ]], opts)

-- 四.Visule模式下快捷键
-- (1) visual模式下缩进代码
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)
-- (2) 上下移动选中文本
map("v", "<C-j>", ":move '>+1<CR>gv-gv", opts)
map("v", "<C-k>", ":move '<-2<CR>gv-gv", opts)

-- 五.代码阅读
-- (1) 上下滚动浏览
-- map("n", "<C-j>", "4j", opt) -- 不需要, 注意, 跟上面重复了, 不要打开
-- map("n", "<C-k>", "4k", opt)
-- (2) ctrl u ctrl d  翻滚
map("n", "<C-u>", "9k", opts)
map("n", "<C-d>", "9j", opts)

-- 六. 作者其它配置
-- 在visual模式里粘贴不要复制
map("v", "p", '"_dp', opts)


-- 七. 其它插件快捷键映射
-- (1) bufferline
-- 左右切换
map("n", "<C-h>", ":BufferLineCyclePrev<CR>", opts)
map("n", "<C-l>", ":BufferLineCycleNext<CR>", opts)
-- 关闭
-- "moll/vim-bbye"
map("n", "<C-w>", ":Bdelete!<CR>", opts)
-- map("n", "<leader>bl", ":BufferLineCloseRight<CR>", opts) -- 删左
-- map("n", "<leader>bh", ":BufferLineCloseLeft<CR>", opts) -- 删右
--map("n", "<leader>w", ":BufferLinePickClose<CR>", opts) -- 选择删除

if General_Func.is_safe_cb(call_back_func.auto_delete_bufferLine_two, "(2)") then
    map("n", "<leader>w", call_back_func.auto_delete_bufferLine_two, opts) --call_back_func (2)
end

-- (2) lsp
-- lsp 回调函数快捷键设置
pluginKeys.mapLSP = function(mapbuf)
  -- rename
  mapbuf("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opt)
  -- code action
  mapbuf("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opt)
  -- go xx
  mapbuf("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opt)
  mapbuf("n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", opt)
  mapbuf("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opt)
  mapbuf("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opt)
  mapbuf("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opt)
  -- diagnostic
  mapbuf("n", "gp", "<cmd>lua vim.diagnostic.open_float()<CR>", opt)
  mapbuf("n", "gk", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opt)
  mapbuf("n", "gj", "<cmd>lua vim.diagnostic.goto_next()<CR>", opt)
  mapbuf("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opt)
  -- 没用到
  -- mapbuf('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opt)
  -- mapbuf("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opt)
  -- mapbuf('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opt)
  -- mapbuf('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opt)
  -- mapbuf('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opt)
  -- mapbuf('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opt)
end

-- (n) nvim-tree
-- alt + m 键打开关闭tree
map("n", "<A-m>", ":NvimTreeToggle<CR>", opts)
-- 列表快捷键
pluginKeys.mapTree = function(bufnr) -- 这里的回调函数, 用1表示吧
    api.config.mappings.default_on_attach(bufnr)

    local usebuffer = {
        buffer = bufnr,
        noremap = true,
        silent = true
    }

    map("n", "L", "<c-w>l", usebuffer)
    map("n", "<a-l>", ":vertical resize +2<cr>", usebuffer)
    map("n", "<a-h>", ":vertical resize -2<cr>", usebuffer)
    -- y 复制相对路径, gy复制绝对路径
    -- 打开文件, 光标在树中
    --vim.keymap.set("n", "o", "<2-LeftMouse><C-w>h", opts)
    -- 测试<2-LeftMouse>是否可行 不可行

    -- 打开文件, 并且光标在树中
    --local open_file = function()
    --end
    if General_Func.is_safe_cb(call_back_func.open_file, "(3)") then
        map("n", "o", call_back_func.open_file, usebuffer)
    end

    -- 类似同上
    if General_Func.is_safe_cb(call_back_func.open_file_v, "(4)") then
        map("n", "v", call_back_func.open_file_v, usebuffer)
    end
    -- vim.keymap.set("n", "h", api.node.open.horizontal, opt)
end

-- 八.按照按键分类
-- 1.S
--  (1) 全屏复制(复制到粘贴板中)
map("n", "SY", "ggVG\"+y", opts)
--  (2) 粘贴粘贴板内容
map("n", "SP", "\"+p", opts)
return pluginKeys



