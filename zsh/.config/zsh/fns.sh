 
if [[ "$(uname -s)" == "Linux" ]]
then
  alias lsa="command ls -a --color=tty --group-directories-first"
else
  alias lsa="command ls -a --color=tty"
fi

# https://unix.stackexchange.com/a/310553
setopt +o nomatch 
unalias ls
ls() {
  if [[ $(find . -maxdepth 1 ! -name '.*' | wc -l) -eq 0 ]]
  then 
    lsa "$@"
  else
    ls_cmd="command ls --color=tty"
    [[ "$(uname -s)" == "Linux" ]] && ls_cmd+=" --group-directories-first"
    ls_cmd+=" "$@""
    eval "$ls_cmd"
  fi
}
if [[ "$(uname -s)" == "Linux" ]] then 
  alias copy="xclip -selection clipboard"
else
  alias copy="pbcopy"
fi

export ZSHZ_CMD="zsh_z"
# need `function` https://github.com/ohmyzsh/ohmyzsh/issues/6723#issue-313463147
function z { 
  zsh_z "$@" 
  ls 
}

mkcd() { mkdir "$1" && cd "$1" }
abspath() { 
  local abs_path=$(realpath "$1")
  echo "$abs_path" | copy
  echo "$abs_path"
}
gd() { nvim -c ":Git difftool -y"}
gif() { 
  ffmpeg -i "$1.mov" -pix_fmt rgb8 -r 10 "$1.gif"
  gifsicle -O3 "$1.gif" -o "$1.gif"
}
search() { grep "$1" "$HISTFILE" | tail -n 20 }
cb() {
  local branch=$(git symbolic-ref HEAD | cut -d'/' -f3)
  echo "$branch" | copy
}
killp() { kill -9 $(lsof -t -i:$1) }
man_e(){ nvim -c "Man $1" -c "wincmd o" }
alias man="man_e"

cd() {
  builtin cd "$@"
  ls
}
setopt auto_cd
c() {
  if [[ $# -eq 0 ]]
  then 
    builtin cd ~
  else
    source ~/Desktop/cd_time_machine/main.sh --change_dir="$1"
  fi
  ls
}
