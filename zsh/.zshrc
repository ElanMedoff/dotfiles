#####################
### env variables ###
#####################

# https://github.com/christoomey/vim-tmux-navigator/issues/72#issuecomment-103566743
export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="spaceship"
plugins=(z zsh-syntax-highlighting zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

export PATH="$HOME/.local/bin:$HOME/.deno/bin:/usr/local/sbin:$PATH"
export EDITOR="nvim"

# https://superuser.com/a/71593
export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
export LESS=" -R "

# https://superuser.com/a/613754
export XDG_TEMPLATES_DIR="$HOME"
export XDG_PUBLICSHARE_DIR="$HOME"
export XDG_DOCUMENTS_DIR="$HOME"
export XDG_MUSIC_DIR="$HOME"
export XDG_PICTURES_DIR="$HOME"
export XDG_VIDEOS_DIR="$HOME"
export XDG_SCREENCASTS_DIR="$HOME"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

export BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        source "$BASE16_SHELL/profile_helper.sh"
base16_tomorrow-night


###############
### aliases ###
###############

# editing
alias ezsh="cd ~/.dotfiles/zsh && n.sh ."
alias eterm="nvim ~/.dotfiles/alacritty/.config/alacritty/alacritty.toml"
alias etmux="nvim ~/.dotfiles/tmux/.config/tmux/tmux.conf"
alias evim="cd ~/.dotfiles/neovim/.config/nvim && n.sh ."
alias resetnvim="rm -rf ~/.cache/nvim ~/.local/share/nvim ~/.config/coc"
# sourcing
alias src="exec zsh"
alias tsrc="tmux source ~/.config/tmux/tmux.conf"
# git
alias gs="git status"
alias gcb="git checkout -b"
alias gc="git checkout"
alias ga="git add -A"
alias gm="git commit -m"
alias gam="git add -A && git commit -m"
alias game="git add -A && git commit --allow-empty-message -m ''"
alias gpsh="git push origin HEAD"
alias gpl="git pull origin master"
# shorter commands
alias e="exit"
alias vi="nvim"
alias tm="tmux"
if [[ "$(uname -s)" == "Linux" ]]
then
  alias lsa="command ls -a --color=tty --group-directories-first"
else
  alias lsa="command ls -a --color=tty"
fi
# scripts
alias n="n.sh"
alias ps="ps.sh"
# overrides
alias vim="nvim -u ~/.dotfiles/neovim/.config/nvim/barebones.lua"
alias man='nvim -c "Man find" -c "wincmd o"'
alias cat="highlight -O ansi --force"

#################
### functions ###
#################

# https://unix.stackexchange.com/a/310553
setopt +o nomatch 
unalias ls
ls() {
  if [[ "$(find . -maxdepth 1 ! -name '.*' | wc -l)" == 0 ]]
  then 
    lsa "$@"
  else
    ls_cmd="command ls --color=tty"
    [[ "$(uname -s)" == "Linux" ]] && ls_cmd+=" --group-directories-first"
    ls_cmd+=" "$@""
    eval "$ls_cmd"
  fi
}
mkcd() { mkdir "$1" && cd "$1" }
cl() { cd "$1" && ls }
zl() { z "$1" && ls }
abspath() { 
  local abs_path=$(realpath "$1")
  echo "$abs_path" | xclip -selection clipboard
  echo "$abs_path"
}
gd() { nvim -c ":Git difftool -y"}
gif() { 
  ffmpeg -i "$1.mov" -pix_fmt rgb8 -r 10 "$1.gif"
  gifsicle -O3 "$1.gif" -o "$1.gif"
}
search() { grep "$1" "$ZSH/.zsh_history" | tail -n 20 }
cb() {
  local branch=$(git symbolic-ref HEAD | cut -d'/' -f3)
  echo "$branch" | xclip -selection clipboard
}
killp() { kill -9 $(lsof -t -i:$1) }

c() {
  source ~/Desktop/cd_time_machine/main.sh --change_dir="$1"
  ls
}
time_machine_backwards() {
  source ~/Desktop/cd_time_machine/main.sh --backwards
  zle accept-line
}
time_machine_forwards() {
  source ~/Desktop/cd_time_machine/main.sh --forwards
  zle accept-line
}
zle -N time_machine_backwards
zle -N time_machine_forwards

################
### bindkeys ###
################

# based on moving around the vim jumplist
bindkey '^O' time_machine_backwards
bindkey '^I' time_machine_forwards

# bindkey -s '^O' 'source /home/elan/Desktop/cd_time_machine/main.sh --backwards \n'
# bindkey -s '^I' 'source /home/elan/Desktop/cd_time_machine/main.sh --forwards \n'

if [[ "$(uname -s)" == "Linux" ]]
then
  alias open="xdg-open"
fi
# TODO: issues using fzf in a function that's registered with zle -N
bindkey -s '^F' 'file_to_open="$(fzf)"; if [[ "$file_to_open" != "" ]]; then; open "$file_to_open"; fi \n'
bindkey -s '^P' 'file_to_edit="$(fzf)"; if [[ "$file_to_edit" != "" ]]; then; nvim "$file_to_edit"; fi \n'
bindkey '^s' autosuggest-execute

# TODO: find a better keybidning for this
bindkey "A" expand-or-complete
