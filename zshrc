# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
export ZSH_THEME="tessa"


# Set to this to use case-sensitive completion
# export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# export DISABLE_AUTO_TITLE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(
    golang \
    lol \
    compleat \
    history \
    scd \
    aws \
    docker \
    colored-man-pages \
    zsh-navigation-tools \
    colorize \
    extract \
    python \
    git \
    vi-mode \
    zsh-syntax-highlighting \
    zsh-autosuggestions \
    thxph-fzf \
    thanh)
if uname | grep Darwin >> /dev/null; then
    plugins+=(macos)
elif uname | grep Linux >> /dev/null; then
    plugins+=(copypath copyfile copybuffer)
fi

if [ -f $HOME/.zshrc-tlocal ]; then
    source $HOME/.zshrc-tlocal
fi

source $ZSH/oh-my-zsh.sh

#zprof

# use load-nvm() instead of this
#export NVM_DIR="$HOME/.config/nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Antigravity
if [[ -d "$HOME/.antigravity/antigravity/bin" ]]; then
    export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
fi

alias f='fvm flutter'
alias d='fvm dart'

alias jenv_set_java_home='export JAVA_HOME="$HOME/.jenv/versions/`jenv version-name`"'

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f $HOME/.dart-cli-completion/zsh-config.zsh ]] && . $HOME/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

export CLOUDSDK_PYTHON="/opt/homebrew/bin/python3"

alias unplug='killall -9 adb CoreSimulatorService java 2>/dev/null; diskutil eject /Volumes/Data'
alias drive-off='killall -9 adb CoreSimulatorService java 2>/dev/null; diskutil eject /dev/disk6'
alias drive-on='diskutil mountDisk /dev/disk6'

# OpenClaw Completion
if [[ -f "$HOME/.openclaw/completions/openclaw.zsh" ]]; then
    source "$HOME/.openclaw/completions/openclaw.zsh"
fi
