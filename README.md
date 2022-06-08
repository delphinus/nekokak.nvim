# nekokak.nvim

Brazingly fast implementation for NEKOKAK with Neovim Lua.

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

* [mattn/vim-nekokak]: https://github.com/mattn/vim-nekokak
