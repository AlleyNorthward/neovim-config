local func = {}

func.get_file_name = function()
    local info = debug.getinfo(2, "S")
    local path = info.source
    if path:sub(1, 1) == "@" then
        path = path:sub(2)
    end
    return path:match("^.+\\(.+)$") or path:match("^.+/(.+)$") or path
    
end

func.is_safe_cb = function(cb_func, info)
    if not cb_func then
        local file_name = func.get_file_name()
        vim.notify(
            string.format("在文件 %s 中没有找到CallBack函数. binding-info: %s", file_name, info),
            vim.log.levels.WARN
        )
        return false
    end
    return true
end

func.is_safe_func = function(normal_func)
    if not normal_func then
        local file_name = func.get_file_name()
        vim.notify(
            string.format("在文件 %s 中没有找到General_Func.", file_name),
            vim.log.levels.WARN
        )
        return false
    end
    return true
end

func.on_tree = function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_buf_get_name(buf):match("NvimTree_")then
            vim.api.nvim_set_current_win(win)
            break
        end
    end
end

return func
