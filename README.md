# nekokak.nvim

Blazingly fast implementation for NEKOKAK with Neovim Lua.

https://user-images.githubusercontent.com/1239245/172523289-7ef6f617-fc36-45f8-96bd-274e6f77e4aa.mp4

## What's this?

This is a fork of [mattn/vim-nekokak][] implemented by Lua.

[mattn/vim-nekokak]: https://github.com/mattn/vim-nekokak

## Installation

### for [packer.nvim][]

```lua
use { "delphinus/nekokak.nvim" }
```

[packer.nvim]: https://github.com/wbthomason/packer.nvim

### for builtin [packages][]

```sh
git clone https://github.com/delphinus/nekokak.nvim \
  $HOME/.local/share/nvim/site/pack/foobar/start/nekokak.nvim
```

[packages]: https://neovim.io/doc/user/repeat.html#packages

## Functions

### `start()`

You can start NEKOKAK.

```lua
:lua require'nekokak'.start()
```

### `setup()`

Do initialization only (internal use).

## See also

* [mattn/vim-nekokak][]
