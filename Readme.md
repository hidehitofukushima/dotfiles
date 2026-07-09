### git clone
git clone https://github.com/hidehitofukushima/dotfiles.git "${HOME}/dotfiles"

### pre-requisite

@SHIROKANE
-vim
@home
git clone https://github.com/vim/vim.git
cd ~/vim && ./configure --prefix=$HOME/.local --with-features=huge --enable-multibyte
make -j4
make install
export PATH="$HOME/.local/bin:$PATH"を必ずいれること


- cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
cargo --version
rustc --version

- zsh
chsh.ldap -s /bin/zsh

- tmux
cd && wget https://github.com/nelsonenzo/tmux-appimage/releases/download/3.5a/tmux.appimage
chmod +x "$HOME/tmux.appimage"
mkdir -p "$HOME/.local/bin"
ln -sf "$HOME/tmux.appimage" "$HOME/.local/bin/tmux"
tmux -V

- fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

- fd && rg
cargo install fd-find
cargo instll ripgrep

- vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim



tmptmptmp
@MACBOOK
brew install tmux
brew install fd
brew install fzf
brew install rg



### setup
chmod +x "$HOME/dotfiles/setup.sh" && "$HOME/dotfiles/setup.sh"

