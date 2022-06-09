# nekokak.nvim

Blazingly fast implementation for NEKOKAK with Neovim Lua.

https://user-images.githubusercontent.com/1239245/172523289-7ef6f617-fc36-45f8-96bd-274e6f77e4aa.mp4

## What's this?

This is a fork of [mattn/vim-nekokak][] implemented by Lua.

[mattn/vim-nekokak]: https://github.com/mattn/vim-nekokak

## Installation

### for [packer.nvim][]

```lua
use {
  "delphinus/nekokak.nvim",
  config = function()
    require "nekokak".setup {}
  end,
}
```

[packer.nvim]: https://github.com/wbthomason/packer.nvim

### for builtin [packages][]

```sh
git clone https://github.com/delphinus/nekokak.nvim \
  $HOME/.local/share/nvim/site/pack/foobar/start/nekokak.nvim
```

```lua
-- And in your init.lua……
require "nekokak".setup {}
```

[packages]: https://neovim.io/doc/user/repeat.html#packages

## Commands

### `Nekokak`

```vim
:Nekokak
```

You see him.

```vim
:Nekokak { wait_ms = 10, direction = 'loop' }
```

You see more passionate him.

#### Options

* `wait_ms` (default: `100`)
  - Milliseconds to wait between frames.
* `direction` (default: `'expand'`)
  - Direction to animate him. Either `'expand'`, `'reduct'` or `'loop'` is available.
* `count` (default: `3`)
  - Count to loop. This is ignored when `direction` is not `'loop'`.

## Functions

### `start()`

You can start NEKOKAK.

```lua
:lua require'nekokak'.start()
```

### `setup()`

Do initialization only (internal use).

## See also

* [mattn/vim-nekokak]: https://github.com/mattn/vim-nekokak
