# Use powerline
USE_POWERLINE="true"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi

# replace p10k theme with mine
source ~/.p10k.zsh
# append to end to avoid taking precedence of pip under python venv
export PATH="$PATH:$HOME/.local/bin"
# Java path for vim plugin
export JAVA_HOME=/usr/lib/jvm/default
