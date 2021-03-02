alias vi="nvim"

eval "$(starship init bash)"
eval "$(direnv hook bash)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ${ASDF_DIR}/asdf.sh ] && source ${ASDF_DIR}/asdf.sh
