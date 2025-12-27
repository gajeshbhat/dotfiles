# Dotfiles Repository

This repository contains my configuration files for various terminal and editor setups, including:

- **Bash** (`.bashrc`)
- **GNU Screen** (`.screenrc`)
- **Vim** (`.vimrc`, `.vimrc.plug`)

## Installation

To install these dotfiles, clone the repository and create symbolic links:

```sh
cd ~
git clone https://github.com/YOUR-USERNAME/dotfiles.git
ln -sf ~/dotfiles/.bashrc ~/.bashrc
ln -sf ~/dotfiles/.screenrc ~/.screenrc
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.vimrc.plug ~/.vimrc.plug
```

Restart your terminal or source the configuration files:

```sh
source ~/.bashrc
```

## Bash Configuration (`.bashrc`)

- Custom prompt showing the current Git branch.
- Useful for identifying branch while working in repositories.

## GNU Screen Configuration (`.screenrc`)

This configuration enhances the GNU Screen experience with custom key bindings, terminal handling, and real-time system monitoring:

- Disables startup message**
- **Adds key bindings:**
  - `\` → Quit
  - `K` → Kill window
  - `I` → Enable login
  - `O` → Disable login
  - `}` → View command history

- **Fetches system metrics** dynamically:
  - CPU usage every 2 seconds
  - Memory usage every 5 seconds
  - Network bandwidth every 20 seconds
  - Disk usage every 30 seconds

- **Displays system stats in the status bar**

## Vim Configuration (`.vimrc` & `.vimrc.plug`)

1. Install Vim Plugin Manager:
```sh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
mkdir -p ~/.vim/plugins

2. Install Plugins:
```sh
vim +PlugInstall +qall
```

- **Key features:**
  - Syntax highlighting, line numbers, and indentation settings.
  - Toggle paste mode with `<F2>`.
  - Search improvements: `hlsearch`, `incsearch`, `ignorecase`, `smartcase`.
  - Plugins managed via [vim-plug](https://github.com/junegunn/vim-plug).

### Important Commands:

```vim
:PlugInstall  " Install plugins
:set number   " Show line numbers
:set wrap     " Enable line wrapping
```

## License
This repository is open-source under the MIT License. Feel free to use and modify it.
