# script should copy files to where ever they belong.
cp vimrc ~/.vimrc
cp after/syntax/syncolor.vim ~/.vim/after/syntax/.
cp after/syntax/toml.vim ~/.vim/after/syntax/.
cp vim-lsp-settings/settings.json ~/.local/share/vim-lsp-settings/.

# move the ghostty config where it needs to be.
if [[ $OSTYPE == "linux-gnu" ]]; then
    cp ghostty/config ~/.config/ghostty

elif [[ $OSTYPE == "darwin" ]]; then
    cp ghostty/config $HOME/Library/Application\ Support/com.mitchellh.ghostty/config

else
    echo "Unknown os"
fi
