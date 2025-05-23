#!/bin/bash
# shellcheck source=/dev/null

source "$HOME/.dotfiles/helpers.sh"

server_flag=false
package_manager=""

for arg in "$@"; do
  case "$arg" in
    --server)
      server_flag=true
      shift
      ;;
    --pm=*)
      package_manager="$arg"
      shift
      ;;
    *)
      h_format_error "--pm={brew,pacman,dnf,apt} --server"
      ;;
  esac
done

h_validate_package_manager "$package_manager"

if h_has_package "$package_manager" "zsh"; then
  h_echo --mode=noop "zsh already installed"
else
  h_install_package "$package_manager" zsh
  h_echo --mode=noop "exiting early, re-run the script"
  exit 1
fi

if ! h_string_includes "$SHELL" "zsh"; then
  h_echo --mode=doing "setting the default shell to zsh"
  chsh -s "$(which zsh)"
  h_echo --mode=noop "exiting early, restart the shell and re-run the script"
  exit 1
fi

echo -n "$(h_echo --mode=query "this script delete your ~/.zshrc. confirm 'y' for yes, anything else to abort: ")"
read -r answer

if [[ $answer != 'y' ]]; then
  h_echo --mode=error "aborting"
  exit 1
fi

h_echo --mode=doing "removing ~/.zshrc"
rm ~/.zshrc >/dev/null 2>&1

h_install_package "$package_manager" stow
h_install_package "$package_manager" shfmt
h_install_package "$package_manager" shellcheck
h_install_package "$package_manager" ranger

if $server_flag; then
  h_echo --mode=doing "writing 0 to .is_server"
  echo 0 >~/.dotfiles/.is_server
else
  h_echo --mode=doing "writing 1 to .is_server"
  echo 1 >~/.dotfiles/.is_server
fi

for dir in */; do
  stripped_dir="${dir%?}"
  h_array_includes --needle="$stripped_dir" "fonts" "nvm" "tmux" "base16" "alacritty" "ghostty"
  includes=$?
  if [[ $server_flag == true ]] && [[ $includes -eq 0 ]]; then
    h_echo --mode=noop "SKIPPING: running 'stow $stripped_dir'"
  else
    h_echo --mode=doing "running 'stow $stripped_dir'"
    stow "$stripped_dir"
  fi
done

h_echo --mode=doing "bootstrapping zsh"
source ~/.dotfiles/zsh/.config/zsh/bootstrap.sh "$package_manager"

if $server_flag; then
  h_echo --mode=noop "SKIPPING: bootstrapping tmux"
else
  h_echo --mode=doing "bootstrapping tmux"
  source ~/.dotfiles/tmux/bootstrap.sh "$package_manager"
fi

h_echo --mode=doing "bootstrapping nvm"
nvm_bootstrap_cmd="source ~/.dotfiles/nvm/bootstrap.sh $package_manager"
[[ $server_flag == true ]] && nvm_bootstrap_cmd+=" --server"
eval "$nvm_bootstrap_cmd"

if $server_flag; then
  h_echo --mode=noop "SKIPPING: bootstrapping fonts"
else
  h_echo --mode=doing "bootstrapping fonts"
  source ~/.dotfiles/fonts/bootstrap.sh "$package_manager"
fi

h_echo --mode=doing "bootstrapping nvim"
nvim_bootstrap_cmd="source ~/.dotfiles/neovim/.config/nvim/bootstrap.sh $package_manager"
[[ $server_flag == true ]] && nvim_bootstrap_cmd+=" --server"
eval "$nvim_bootstrap_cmd"

h_echo --mode=noop "if bootstrapping zsh for the first time, run source ~./zshrc"
