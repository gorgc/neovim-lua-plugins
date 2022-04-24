# Custom neovim plugins written in lua

Currently has one plugin which is splitting terminal. Feel free to modify and add more plugins :)

## Usage

```
$ git clone <repository>
$ cd ./neovim-lua-plugins
$ nvim ./lua/luaPlugin/init.lua --cmd "set rtp+=./"
$ :lua require"luaPlugin".split_terminal()
```
