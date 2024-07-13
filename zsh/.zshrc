export ZSH="$HOME/.oh-my-zsh"
export PATH=$HOME/.local/bin:$HOME/.deno/bin:$PATH

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

ZSH_THEME="elan"

plugins=(z zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

COMPLETION_WAITING_DOTS="true"
bindkey '^ ' autosuggest-execute

alias ezsh="nvim ~/.dotfiles/zsh/.zshrc"
alias evim="cd ~/.dotfiles/neovim/.config/nvim && n ."
alias eterm="nvim ~/.dotfiles/alacritty/.config/alacritty/alacritty.toml"
alias etmux="nvim ~/.dotfiles/tmux/.config/tmux/tmux.conf"

alias gs="git status"
alias gcb="git checkout -b"
alias gc="git checkout"
alias ga="git add -A"
alias gam="git add -A && git commit -m"
alias game="git add -A && git commit --allow-empty-message -m ''"
alias gpsh="git push origin HEAD"
alias gpl="git pull origin master"

alias ni="npm install"
alias pi="pnpm install"

alias src="exec zsh"
alias tsrc="tmux source ~/.config/tmux/tmux.conf"

alias e="exit"
alias c="clear"
alias cats="highlight -O ansi --force"

alias resetnvim="rm -rf ~/.cache/nvim ~/.config/nvim/plugin ~/.local/share/nvim ~/.config/coc"
alias vim="nvim"
alias vi="nvim"

alias n="n.sh"
alias ps="ps.sh"

gif() { ffmpeg -i $1.mov -pix_fmt rgb8 -r 10 $1.gif && gifsicle -O3 $1.gif -o $1.gif }
mkcd () { mkdir $1 && cd $1 }
search() { grep "$1" ~/.zsh_history | tail -n 20 }
cdl() { cd $1 && ls }
zl() { z $1 && ls }
cb() {
  ref=$(git symbolic-ref HEAD | cut -d'/' -f3)
  echo $ref | pbcopy
}
killp() { kill -9 $(lsof -t -i:$1) }
