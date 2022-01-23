# Yet Another Plugin Magager (yapm.nvim)

A minimal plugin manager for managing plugins via the builtin plugin management
system with git submodules.

## Use Case

The use case for this plugin manager is to have git manage your plugins via
submodules in your dotfiles repo.

There are some execellent tutorials out there detailing how to use git to manage
your dotfiles and using git submodules.

This Plugin essentially is a glorified wrapper for vim's builtin package
management system. If you aren't familiar with it, I would suggest reading about
it. The package manager makes use of the builtin package manager's optional
plugins. If you are a minimalist you can stop here and grab the following logic,
which is the most essential part of the plugin:

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

The rest of the plugin is some utility functions for running git and listing
loaded plugins.

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
    add_new_plugins = true, -- Adds the plugins as a submodules to your dotfiles
                            -- if they are not found in the plugins folder
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

Vim commands
```
-- List the currently loaded plugins via a popup
:YAPMList

-- Adds the plugin as a submodule to your dotfiles
:YAPMAdd github/plugin

-- Updates the plugin submodules to origin/default_branch
:YAPMUpdate

```

## TODOS
- Use popup for adding plugins
- Add lazy loading for plugins
- Add option to remove a plugin
- Add option to remove unused plugins - lists and prompts you
- Use popup for updating plugins
- Get main branch when updating plugins
- Add option to checkout latest tag
- Add removing plugins option
