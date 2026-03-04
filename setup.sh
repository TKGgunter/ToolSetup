#!/bin/bash

# TODO
# check for common tools that do not ship with system. If they are not present
# ask user to check if installed.
# ---
# nvim
# ripgrep
# kitty - for icat
# ghostty
# ...

# script should copy files to where ever they belong.
cp vim-lsp-settings/settings.json ~/.local/share/vim-lsp-settings/.
cp init.vim ~/.config/nvim/.
cp search_tags.sh ~/.local/bin/.
cp notes ~/.local/bin/.
cp mdtags ~/.local/bin/.

# copy vim skeleton templates
mkdir -p ~/vim/
cp vim/* ~/vim/.

# move the ghostty config where it needs to be.
if [[ $OSTYPE == "linux-gnu" ]]; then
    cp ghostty/config ~/.config/ghostty

elif [[ $OSTYPE =~ "darwin" ]]; then
    cp ghostty/config $HOME/Library/Application\ Support/com.mitchellh.ghostty/config
    # TODO
    # Lets move this into some separate scripts
    #
    # NOTE
    # The key repeat is changed to reduce a common input issue in vim. When
    # attempting to move to the end of a line using `SHIFT-4` I often release
    # the shift before releasing the 4. The time between the release of these
    # two keys is often long enough to trigger repeat. Though in this case the
    # `4` is repeated resulting in unwanted repeated inputs.
    delay=$(defaults read NSGlobalDomain InitialKeyRepeat)
    echo "Current key repeat delay settings: ${delay}"
    echo "Setting the new key repeat delay to '50'"
    defaults write NSGlobalDomain InitialKeyRepeat -int  50
else
    echo "Unknown os: $OSTYPE"
fi
