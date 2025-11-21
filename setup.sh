# script should copy files to where ever they belong.
cp vimrc ~/.vimrc
cp after/syntax/syncolor.vim ~/.vim/after/syntax/.
cp after/syntax/toml.vim ~/.vim/after/syntax/.
cp vim-lsp-settings/settings.json ~/.local/share/vim-lsp-settings/.
cp init.vim ~/.config/nvim/.

# move the ghostty config where it needs to be.
if [[ $OSTYPE == "linux-gnu" ]]; then
    cp ghostty/config ~/.config/ghostty

elif [[ "darwin" =~ $OSTYPE ]]; then
    cp ghostty/config $HOME/Library/Application\ Support/com.mitchellh.ghostty/config
    # TODO
    # Lets move this into some separate scripts
    #
    # NOTE
    # The key repeat is changed to reduce a common input issue.
    # When attempting to move to the end of a line using `SHIFT-4` I often release the shift before releasing the 4.
    # The time between the release of these two keys is often long enough to trigger repeat.
    # Though in this case the `4` is repeated resulting in unwanted repeated inputs.
    echo "Currently set key repeat delay"
    defaults read NSGlobalDomain InitialKeyRepeat
    echo "Setting the new key repeat delay to `50`"
    defaults write NSGlobalDomain InitialKeyRepeat -int  50
else
    echo "Unknown os"
fi
