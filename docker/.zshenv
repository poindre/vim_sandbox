ZDOTDIR="$HOME/.zsh"
ZSHRCDIR="$ZDOTDIR/.zshrc.d"

if [ -d $ZSHRCDIR -a \
     -r $ZSHRCDIR -a \
     -x $ZSHRCDIR ]; then
    for i in $ZSHRCDIR/*; do
        [[ ${i##*/} = *.zsh ]] &&
            [ \( -f $i -o -h $i \) -a -r $i ] && . $i
    done
fi
