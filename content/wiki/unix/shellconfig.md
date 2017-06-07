+++
title = "shellconfig"
draft = false
tags = [
    "unix",
    "shellconfig"
]
date = "2013-03-12"
+++
# Shell Configuration 

## ZShell 

```bash

############################################
####	Jefklak's ZSH Config file 		####
####	Last Edited: 18/10/2005			####
####	Thank you Gentoo Forum!			####
############################################

####	FreeBSD Specific stuff here	####
# export CLICOLOR=yes for the BSD ls thing (flag -G)
# LSCOLORS=fxgxcxdxbxegedabagacad; export LSCOLORS

####	Envoirnment Variables	####
export HOSTTYPE="$(uname -m)"
export COLORTERM=yes
export LINKS_XTERM=screen

# Fixes Savage mouse problems.
export SDL_VIDEO_X11_DGAMOUSE=0


####	Aliases	####
alias vi="vim"
alias ..="cd .. && ls"
alias del="nocorrect rm -rf"
alias mv="nocorrect mv -f"
alias cp="cp -rf"
alias cls='clear'
alias l="ls -la"

alias showstuff="figlet unix rocks | cowsay -n -d;uname -a"


####	set the console title	####
case $TERM in
xterm*)
    PR_TITLEBAR######$'%{<br/>e]0;%(!.-*[ROOT]*=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y<br/>a%}'
    ;;
*rxvt*)
    PR_TITLEBAR######$'%{<br/>e]0;%(!.-*[ROOT]*=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y<br/>a%}'
    ;;
*)
	PR_TITLEBAR=''
    ;;
esac

 
####	the prompt style	####
# check for colors
autoload colors zsh/terminfo
if [ "$terminfo[colors]" -ge 8 ]("$terminfo[colors]" -ge 8 .md"); then colors; fi
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE
do
	eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
	eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
	(( count = $count + 1 ))
done
PR_NO_COLOUR="%{$terminfo[sgr0]%}"

PROMPT='${(e)PR_TITLEBAR}<br/>
$PR_BLUE($PR_YELLOW%D{%H:%M}$PR_BLUE)$PR_CYAN-<br/>
$PR_BLUE(%{[01;32m%}%n@%m%{[01;36m%}$PR_BLUE)$PR_CYAN-<br/>
$PR_BLUE($PR_YELLOW$(ls | wc -l | bc) files$PR_BLUE) %(30l.
.)${PR_CYAN}[$PR_MAGENTA %}%.%{%} ${PR_CYAN}]${PR_WHITE} >> '
RPROMPT=$'%{<br/>e[0;15m<br/>e[0;15m%}'


####	General Config setup	####
# SCREENDIR will screw screen up
unset SCREENDIR

# Make sure no cores can be dumped while zsh is in charge.
limit coredumpsize 0

# History things >> history -10 recalls the latest 10 history commands
# !! re-uses the last command. ![command number] re-uses that command. 
HISTFILE=$HOME/.zshist
SAVEHIST=500
HISTSIZE=800
TMPPREFIX=/tmp


####	Autocompletion rules ####
# general setup
autoload -U compinit
compinit
compctl -g '*(-/)' + -g '.*(-/)' -v cd pushd rmdir
compctl -k hosts -x 'p[2,-1]' -l '' -- rsh ssh

# "man" auto-completion
compctl -f -x 'S[1][2][3][4][5][6][7][8][9]' -k '(1 2 3 4 5 6 7 8 9)' <br/>
  1. 'R[[1-9nlo]|[1-9](|[a-z]),^*]' -K 'match-man' <br/>
  2. 's[-M],c[-1,-M]' -g '*(-/)' <br/>
  3. 's[-P],c[-1,-P]' -c <br/>
  4. 's[-S],s[-1,-S]' -k '( )' <br/>
  5. 's[-]' -k '(a d f h k t M P)' <br/>
  6. 'p[1,-1]' -c + -K 'match-man' <br/>
  -- man

# other completitions
compctl -b bindkey
compctl -v export
compctl -o setopt
compctl -v unset
compctl -o unsetopt
compctl -v vared
compctl -c which
compctl -c sudo


####	Key bindings, useful.	####
# get the code by pressing C-v and then a code
bindkey "<br/>e[3~" delete-char
bindkey "<br/>e[7~" beginning-of-line
bindkey "<br/>e[8~" end-of-line
bindkey "<br/>e[5~" history-search-backward
bindkey "<br/>e[6~" history-search-forward 
bindkey "[3~" delete-char				# Del
bindkey "[2~" overwrite-mode			# Insert
bindkey "^[[Z"  reverse-menu-complete	# shift+tab

# Setting HOME and END keys to browse the last used commands
case $TERM in (xterm*|aterm|rxvt)
	bindkey '<br/>e[H' beginning-of-line
	bindkey '<br/>e[F' end-of-line ;;
esac

# =======================================
# following lines were set automatically!
# =======================================

# Select Prompt
zstyle ':completion:*' menu select=1

# Expansion options
zstyle ':completion:*' completer _complete _prefix
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete

# Completion caching
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

# Expand partial paths
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'

# Include non-hidden directories in globbed file completions
# for certain commands

zstyle ':completion::complete:*' '<br/>'

# Use menuselection for pid completion
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

#  tag-order 'globbed-files directories' all-files 
zstyle ':completion::complete:*:tar:directories' file-patterns '*~.*(-/)'

# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*<br/>~'

# Separate matches into groups
zstyle ':completion:*:matches' group 'yes'

# With commands like rm, it's annoying if you keep getting offered the same
# file multiple times. This fixes it. Also good for cp, et cetera..
zstyle ':completion:*:rm:*' ignore-line yes
zstyle ':completion:*:cp:*' ignore-line yes

# Describe each match group.
zstyle ':completion:*:descriptions' format "%B---- %d%b"

# Messages/warnings format
zstyle ':completion:*:messages' format '%B%U---- %d%u%b' 
zstyle ':completion:*:warnings' format '%B%U---- no match for: %d%u%b'
 
# Describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

# Simulate spider's old abbrev-expand 3.0.5 patch 
zstyle ':completion:*:history-words' stop verbose
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false

# Follow GNU LS_COLORS
zmodload -i zsh/complist
#eval "`dircolors ~/.dir_colors`"
export ZLSCOLORS="${LS_COLORS}"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:*:kill:*' list-colors '######%*01;31'

# zsh Options. 
setopt                       <br/>
     NO_all_export           <br/>
        always_last_prompt   <br/>
		nohashdirs			 <br/>
        always_to_end        <br/>
        append_history       <br/>
        auto_cd              <br/>
        auto_list            <br/>
        auto_menu            <br/>
        auto_name_dirs       <br/>
        auto_param_keys      <br/>
        auto_param_slash     <br/>
        auto_pushd           <br/>
        auto_remove_slash    <br/>
     NO_auto_resume          <br/>
        bad_pattern          <br/>
        bang_hist            <br/>
     NO_beep                 <br/>
        brace_ccl            <br/>
        correct_all          <br/>
     NO_bsd_echo             <br/>
        cdable_vars          <br/>
     NO_chase_links          <br/>
        clobber              <br/>
        complete_aliases     <br/>
        complete_in_word     <br/>
        correct              <br/>
     NO_correct_all          <br/>
        csh_junkie_history   <br/>
     NO_csh_junkie_loops     <br/>
     NO_csh_junkie_quotes    <br/>
     NO_csh_null_glob        <br/>
        equals               <br/>
        extended_glob        <br/>
        extended_history     <br/>
        function_argzero     <br/>
        glob                 <br/>
     NO_glob_assign          <br/>
        glob_complete        <br/>
     NO_glob_dots            <br/>
        glob_subst           <br/>
     NO_hash_cmds            <br/>
     NO_hash_dirs            <br/>
        hash_list_all        <br/>
        hist_allow_clobber   <br/>
        hist_beep            <br/>
        hist_ignore_dups     <br/>
        hist_ignore_space    <br/>
     NO_hist_no_store        <br/>
        hist_verify          <br/>
     NO_hup                  <br/>
     NO_ignore_braces        <br/>
     NO_ignore_eof           <br/>
        interactive_comments <br/>
      	inc_append_history   <br/>
     NO_list_ambiguous       <br/>
     NO_list_beep            <br/>
        list_types           <br/>
        long_list_jobs       <br/>
        magic_equal_subst    <br/>
     NO_mail_warning         <br/>
     NO_mark_dirs            <br/>
        menu_complete        <br/>
        multios              <br/>
        nomatch              <br/>
        notify               <br/>
     NO_null_glob            <br/>
        numeric_glob_sort    <br/>
     NO_overstrike           <br/>
        path_dirs            <br/>
        posix_builtins       <br/>
     NO_print_exit_value     <br/>
     NO_prompt_cr            <br/>
        prompt_subst         <br/>
        pushd_ignore_dups    <br/>
     NO_pushd_minus          <br/>
        pushd_silent         <br/>
        pushd_to_home        <br/>
        rc_expand_param      <br/>
     NO_rc_quotes            <br/>
     NO_rm_star_silent       <br/>
     NO_sh_file_expansion    <br/>
        sh_option_letters    <br/>
        short_loops          <br/>
     NO_sh_word_split        <br/>
     NO_single_line_zle      <br/>
     NO_sun_keyboard_hack    <br/>
        unset                <br/>
     NO_verbose              <br/>
        zle
```