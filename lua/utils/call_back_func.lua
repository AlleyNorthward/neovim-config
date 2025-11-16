local General_Func = require("utils.func")

local status_api, api = pcall(require, "nvim-tree.api")
if not status_api then
    vim.notify("没有nvim-tree模块.", vim.log.levels.INFO)
    return
end

local call_back_func = {}
--[[
    @author 巷北
    @time 2025.11.16 17:05
        这是所有的函数汇总地方, 方便后续内部随时调用.但是问题是, 随着数量
    的增多, 会混乱. 所以, 最好还是要说明一下是属于谁的, 这样就明确很多了.
]]

call_back_func.auto_delete_bufferLine = function() 
-- 标签: (1) 用途:灵活删除上方标签.
-- 属于: keybindings.lua 调用:map("n", "<leader>w", .. opts)
    vim.notify("Quit: esc Continue: <space>")
    local first = true

    while true do
        if first then
            vim.cmd("BufferLinePickClose")
            first = false
        else
            local key = vim.fn.getchar() -- 获取输入
            if key == 27 then
                vim.notify("Exit Success", vim.log.levels.INFO)
                break
            elseif key == 32 then
                vim.cmd("BufferLinePickClose")
            else
                vim.notify("Press Esc to quit of <space> to continue.", vim.log.levels.INFO)
            end
        end
    end
end

call_back_func.auto_delete_bufferLine_two = function()
-- 标签: (2) 用途:同上, 一处调用.
-- 属于: keybindings.lua 调用:map("n", "<leader>w", .. opts)
    vim.notify("Quit: Esc. ", vim.log.levels.INFO) 

    while true do
        vim.cmd("BufferLinePickClose")

        local key = vim.fn.getchar()
        if key == 27 then
            vim.notify("Exit Success.", vim.log.levels.INFO)
            break
        else
            local buffer_key = vim.fn.nr2char(key)
            vim.api.nvim_feedkeys(buffer_key, "n", false)
        end
    end
end

call_back_func.open_file = function()
-- 标签: (3) 用途:在树中分屏, 光标仍在树中
-- 属于: keybindings.lua 调用:map("n", "o", .. usebuffer)
    api.node.open.edit()
    if General_Func.is_safe_func(General_Func.on_tree) then
        General_Func.on_tree()
    end
end

call_back_func.open_file_v = function()
-- 标签: (4) 用途:同上.
-- 属于: keybindings.lua 调用:map("n", "v", .. usebuffer)
    api.node.open.vertical()
    if General_Func.is_safe_func(General_Func.on_tree) then
        General_Func.on_tree()
    end
end

return call_back_func









