#!/bin/bash
#
DIR="$(dirname "$(realpath "$0")")"
sudo wget https://raw.githubusercontent.com/deluan/zsh-in-docker/master/zsh-in-docker.sh -P $DIR
bash $DIR/zsh-in-docker.sh -x
mkdir ~/.config && mkdir ~/.tmux
git clone https://github.com/LazyVim/starter ~/.config/nvim
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

cp /opt/scripts/tmux.conf /home/$1/.tmux.conf
cp /opt/scripts/tmux.lua /home/$1/.config/nvim/lua/plugins
cp /opt/scripts/vim_tpipeline.lua /home/$1/.config/nvim/lua/plugins
cp /opt/scripts/zshrc /home/$1/.zshrc

tmux start-server &&
  tmux new-session -d &&
  sleep 1 &&
  bash ~/.tmux/plugins/tpm/scripts/install_plugins.sh &&
  tmux kill-server

bash ~/.tmux/plugins/tmux-powerline/generate_config.sh
cp /opt/scripts/config.sh /home/$1/.config/tmux-powerline/config.sh
mkdir -p ~/.config/tmux-powerline/themes
cp /opt/scripts/my-theme.sh /home/$1/.config/tmux-powerline/themes
cp /opt/scripts/display_times.sh /home/$1/.tmux/plugins/tmux-powerline/segments
cp /opt/scripts/hostname.sh /home/$1/.tmux/plugins/tmux-powerline/segments
cp /opt/scripts/keymaps.lua /home/$1/.config/nvim/lua/config

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
sudo curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
sudo tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
sudo curl -Lo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
sudo tar xf lazydocker.tar.gz lazydocker
sudo install lazydocker /usr/local/bin