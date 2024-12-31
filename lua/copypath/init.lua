local M = {}

-- Default configuration
M.config = {
    default_mappings = true,
    mapping = 'Y',
    notify = true,
}

-- Convert SSH git URL to HTTPS URL
-- @param url string: The SSH URL to convert (e.g., git@github.com:user/repo)
-- @return string|nil: The HTTPS URL if conversion successful, nil otherwise
local function convert_git_url(url)
    -- Remove trailing .git if present
    url = url:gsub('%.git$', '')

    -- Convert SSH URL to HTTPS URL
    -- Match pattern: git@host:org/repo or git@host/org/repo
    local host, path = url:match('git@([^:]+)[:/](.+)')
    if host and path then
        return string.format('https://%s/%s', host, path)
    end

    -- If already HTTPS, return as is
    if url:match('^https://') then
        return url
    end

    return nil
end

-- Get repository URL for current file
-- @return string|nil: The full repository URL for the current file, nil if not in a git repo
local function get_repo_url()
    -- Get git root directory
    local git_root = vim.fn.system('git rev-parse --show-toplevel 2>/dev/null'):gsub('\n', '')
    if git_root == '' then
        return nil
    end

    -- Get relative path from git root
    local file_path = vim.fn.expand('%:p')
    local relative_path = file_path:sub(#git_root + 2)  -- +2 to skip the trailing slash

    -- Get remote URL
    local remote_url = vim.fn.system('git config --get remote.origin.url'):gsub('\n', '')
    if remote_url == '' then
        return nil
    end

    -- Convert URL to HTTPS format
    local https_url = convert_git_url(remote_url)
    if not https_url then
        return nil
    end

    -- Get default branch (usually main or master)
    local default_branch = vim.fn.system('git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null'):gsub('\n', '')
    default_branch = default_branch:gsub('refs/remotes/origin/', '')
    if default_branch == '' then
        default_branch = 'main'  -- fallback to main
    end

    -- Construct repository URL
    return string.format('%s/blob/%s/%s', https_url, default_branch, relative_path)
end

-- Copy current file path with line number
function M.copy_path_with_line()
    -- Try to get repository URL
    local repo_url = get_repo_url()
    
    if repo_url then
        -- Get current line number
        local line_nr = vim.fn.line('.')
        -- Format repository URL with line number
        local result = repo_url .. '#L' .. line_nr
        
        -- Copy to clipboard
        vim.fn.setreg('+', result)
        if M.config.notify then
            vim.notify('Copied repository URL: ' .. result)
        end
    else
        -- Fallback to relative path with line number
        local file_path = vim.fn.expand('%:.')  -- :. gives path relative to current working directory
        if file_path == '' then
            file_path = vim.fn.expand('%:p')  -- fallback to absolute path if relative is not available
        end
        local line_nr = vim.fn.line('.')
        local result = file_path .. ':' .. line_nr
        
        -- Copy to clipboard
        vim.fn.setreg('+', result)
        if M.config.notify then
            vim.notify('Copied relative path: ' .. result)
        end
    end
end

-- Setup function
function M.setup(opts)
    -- Merge user config with defaults
    M.config = vim.tbl_deep_extend('force', M.config, opts or {})

    -- Set up default mappings if enabled
    if M.config.default_mappings then
        vim.keymap.set('n', M.config.mapping, M.copy_path_with_line, {
            desc = 'Copy file path with line number'
        })
    end
end

return M
