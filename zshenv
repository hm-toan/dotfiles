#!/usr/bin/env zsh

#zmodload zsh/zprof

if [[ -d /usr/local/go/bin ]]; then
    path_prepend=( /usr/local/go/bin $path_prepend )
fi

if [[ -d $HOME/.jenv/bin ]]; then
    path_prepend=( $HOME/.jenv/shims $path_prepend )
    path_append=( $path_append $HOME/.jenv/bin )
    path=( $path_prepend $path $path_append )
    typeset -U path
    eval "$(jenv init -)"
fi

if [[ -d $HOME/.local/bin ]]; then
    path=( $path $HOME/.local/bin )
fi

# Fast path: resolve nvm default alias → actual version dir and inject into PATH.
# Works in non-interactive shells (hooks, scripts) where `load-nvm` is not called.
export NVM_DIR="$HOME/.nvm"
if [ -d "$NVM_DIR/versions/node" ]; then
    _nvm_alias=$(cat "$NVM_DIR/alias/default" 2>/dev/null)
    if [ -n "$_nvm_alias" ]; then
        # Handle lts/* aliases (e.g. lts/iron → read lts/iron alias file)
        if [[ "$_nvm_alias" == lts/* ]]; then
            _nvm_alias=$(cat "$NVM_DIR/alias/$_nvm_alias" 2>/dev/null | tr -d '[:space:]')
        fi
        # Match "v22" → "v22.22.2" (longest matching version wins)
        _nvm_version=$(ls -1 "$NVM_DIR/versions/node" 2>/dev/null \
            | grep "^${_nvm_alias}\." \
            | sort -t. -k1,1V -k2,2n -k3,3n \
            | tail -1)
        # Exact match fallback (alias already is a full version)
        [ -z "$_nvm_version" ] && _nvm_version="$_nvm_alias"
        if [ -d "$NVM_DIR/versions/node/$_nvm_version/bin" ]; then
            path_prepend=( "$NVM_DIR/versions/node/$_nvm_version/bin" $path_prepend )
            export NVM_BIN="$NVM_DIR/versions/node/$_nvm_version/bin"
        fi
    fi
fi

function load-nvm() {
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
}

typeset -U manpath
manpath=( $manpath )

export EDITOR=`which ex`
export CLICOLOR=1
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
if [[ $TERM != *(256color) ]]; then
    export TERM=xterm-256color
fi

# unset pushdignoredups & autopushd so zsh scripts behave normally
setopt NO_pushd_ignore_dups
setopt NO_auto_pushd
# expand dot files
setopt dotglob


# for OS X
if uname | grep Darwin >> /dev/null; then
    # env for stuff installed by macports
    export TERMINFO=/opt/local/share/terminfo
    manpath=(/opt/local/man /usr/local/man $manpath)
    cdpath=($cdpath ~/Documents)
    bindkey "\e[3~" delete-char
elif uname | grep Linux >> /dev/null; then
    export XDG_CONFIG_HOME="$HOME/.config"
fi

# set PATH
if uname | grep Darwin >> /dev/null; then
    path_prepend=( $path_prepend /usr/local/bin )
    path_append=( $path_append /usr/texbin /usr/local/opt/python/libexec/bin /opt/homebrew/bin )
fi

if [ -d "$HOME/.asdf" ]; then
    path_append=( $path_append ${ASDF_DATA_DIR:-$HOME/.asdf}/shims )
fi

# Ruby (Homebrew)
if [[ -d /opt/homebrew/opt/ruby/bin ]]; then
    path_prepend=( /opt/homebrew/opt/ruby/bin $path_prepend )
fi

# Android SDK
if [[ -d $HOME/Library/Android/sdk ]]; then
    export ANDROID_HOME=$HOME/Library/Android/sdk
    path_append=( $path_append $ANDROID_HOME/emulator $ANDROID_HOME/platform-tools )
fi

# Flutter pub cache
if [[ -d $HOME/.pub-cache/bin ]]; then
    path_append=( $path_append $HOME/.pub-cache/bin )
fi

# FVM Flutter
if [[ -d $HOME/fvm/default/bin ]]; then
    path_append=( $path_append $HOME/fvm/default/bin )
fi

# CoPaw
if [[ -d $HOME/.copaw/bin ]]; then
    path_append=( $path_append $HOME/.copaw/bin )
fi

# opencode
if [[ -d $HOME/.opencode/bin ]]; then
    path_append=( $path_append $HOME/.opencode/bin )
fi

# Antigravity
if [[ -d $HOME/.antigravity/antigravity/bin ]]; then
    path_append=( $path_append $HOME/.antigravity/antigravity/bin )
fi

export GOPATH=$HOME/go
path=( $path_prepend $path $path_append $HOME/go/bin $HOME/.local/bin $HOME/wip/bin $HOME/bin . )

typeset -U path

export path_prepend
export path_append

# use nvim
export VISUAL=`which nvim`

if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

if [[ -d "$HOME/src/thxph/flutter/bin" ]]; then
    path_append=( $path_append "$HOME/src/thxph/flutter/bin" )
fi
