# Yet Another Plugin Magager (yapm.nvim)

A package manager for managing plugins via the builtin plugin management system
with git submodules.

## Philosophy

The idea behind this plugin manager is to have git manage your plugins via
submodules in your dotfiles repo. There are some execellent tutorials out there
detailing how to use git to manage your dotfiles and using git submodules.

This Plugin essentially is a glorified wrapper for vim's builtin package
management system. If you aren't familiar with it, I would suggest reading about
it. The package manager makes use of the builtin package manager's optional
plugins. The following logic is the most essential part of the plugin:

```lua
local load_plugin = function(plugin)
    if vim.v.vim_did_enter == 1 then
        -- Adds the optional plugin to the runtime path and sources it now
        vim.cmd('packadd ' .. plugin)
    else
        -- Adds the optional plugin to the runtime path and sources it later as
        -- a part of the startup process
        vim.cmd('packadd! ' .. plugin)
    end
end
```

It is responsible for loading the specified optional plugin.

## Reasons to use this plugin
- If you manage your dotfiles with git
- If you want to ensure your plugins are at a given known good state

## Reasons not to use this plugin
- If you hate git submodules
- Your dotfiles are not managed via git
- If you want to keep your plugins at the bleading edge
- You love minimalism

## Getting Started

```bash
cd your-dotfiles-root
git submodule add --name yapm git@github.com:jglowe/yapm.nvim.git .config/nvim/pack/all/start/yapm.nvim

git commit -m "Added YAPM package manager"
```

```lua
require("yapm").setup({
    add_new_plugins = true,
    git = {
        executable = "git",
        repo_path = vim.env.HOME,
        packages_path = ".config/nvim/pack/all/opt",
        add = {
            options = "--git-dir=$HOME/.dotfiles/ --work-tree=$HOME",
        },
        update = {command = "pull", options = ""}
    }
})
```

## Usage

```lua
local yapm = require("yapm")

yapm.load("github/plugin")
```

## TODOS
- Use popup for adding plugins
- Add lazy loading for plugins
- Add option to remove a plugin
- Add option to remove unused plugins - lists and prompts you
- Use popup for updating plugins
- Get main branch when updating plugins
- Add option to checkout latest tag
