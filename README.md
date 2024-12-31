![copypath.nvim](https://socialify.git.ci/elliotxx/copypath.nvim/image?font=Raleway&language=1&name=1&owner=1&pattern=Plus&theme=Light)

# copypath.nvim

A Neovim plugin that provides enhanced path copying functionality, supporting both local paths and repository URLs.

![image](https://github.com/user-attachments/assets/7e038360-90b8-4a91-884e-6515d23dc88f)

![image](https://github.com/user-attachments/assets/7d23474e-b07c-49fc-b888-fc70d18c3bc7)


## Features

- Copy file path with line number
- Automatically detects if file is in a git repository
- Converts repository paths to web URLs (supports GitHub, GitLab, and other git platforms)
- Falls back to relative/absolute paths when not in a git repository

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    'elliotxx/copypath.nvim',
    opts = {
        -- Default options
        default_mappings = true,  -- Set to false to disable default mappings
        mapping = 'Y',            -- Default mapping to trigger copy
        notify = true,            -- Show notification when path is copied
    }
}
```

You can also use the traditional setup way:
```lua
{
    'elliotxx/copypath.nvim',
    config = function()
        require('copypath').setup({
            -- Your custom config here
        })
    end
}
```

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
    'elliotxx/copypath.nvim',
    config = function()
        require('copypath').setup({
            -- Your custom config here
        })
    end
}
```

## Configuration

```lua
require('copypath').setup({
    -- Default options
    default_mappings = true,  -- Set to false to disable default mappings
    mapping = 'Y',            -- Default mapping to trigger copy
    notify = true,            -- Show notification when path is copied
})
```

## Usage

By default, pressing `Y` in normal mode will:
- If in a git repository:
  * Copy the web URL (e.g., https://github.com/user/repo/blob/main/file.lua#L42)
  * Supports various Git platforms (GitHub, GitLab, etc.)
- If not in a git repository:
  * Copy the relative path with line number (e.g., src/file.lua:42)
  * Falls back to absolute path if relative path is not available

## License

MIT
