# disable special characters in tty
if [ $(tput colors) = '256' ]; then
    BRANCH_CHARACTER='\uE0A0 '
    CLOCK_CHARACTER='⏱️'
    SSH_CHARACTER='🔒'
fi

# Must use Powerline font, for \uE0A0 to render.
ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}$BRANCH_CHARACTER"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_RUBY_PROMPT_PREFIX="%{$fg_bold[red]%}‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"

local exit_code_dollar="%(?,%{$fg[green]%}$%{$reset_color%},%{$fg[red]%}$%{$reset_color%})"

_start=-1

preexec () {
    typeset -ig _start=$(date +%s%N)
}

precmd () {
    if ssh-add -l >/dev/null 2>/dev/null; then
        ssh_info=" $SSH_CHARACTER(ssh-added)"
    else
        ssh_info=""
    fi

    ram_info=$(\free | sed -n "2p" | awk '{ printf "%.1f/%.1fG", ($2-$7)/1024/1024, $2/1024/1024}')

    (( _start >= 0 && (($(\date +%s%N)-_start >= 200000000)) )) && set -A _elapsed "$(printf " %.3fs" ($(\date +%s%N)-_start)/1000000000.0)" || set -A _elapsed ""
    _start=-1
}

PROMPT='
%{$fg_bold[green]%}%~%{$reset_color%}$(git_prompt_info) $CLOCK_CHARACTER%{$fg_bold[red]%}%*%{$reset_color%} %F{8}$ram_info%{$reset_color%}%{$fg_bold[blue]%}$_elapsed%{$reset_color%}%{$fg_bold[yellow]%}$ssh_info%{$reset_color%}
$exit_code_dollar '
