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
cp bash_vim ~/.bash_vim

# copy vim skeleton templates
mkdir -p ~/vim/
cp vim/* ~/vim/.

# move the ghostty config where it needs to be.
if [[ $OSTYPE == "linux-gnu" ]]; then
    cp ghostty/config ~/.config/ghostty
    # This may only work on X11
    # xset can be used to set repeat rate
    # - First number (200): delay before repeat starts (milliseconds)
    # - Second number (30): repeat rate (characters per second)
    #
    # Make permanent (add to ~/.xinitrc or ~/.xprofile):
    # bash
    # echo "xset r rate 200 30" >> ~/.xinitrc
    #
    # TODO
    # What are linux defaults?
    # xset r rate 200 30

elif [[ $OSTYPE =~ "darwin" ]]; then
    cp ghostty/config $HOME/Library/Application\ Support/com.mitchellh.ghostty/config
    # TODO
    # Lets move this into some separate scripts, have it run in as part of
    # terminal startup.
    #
    # NOTE
    # The key repeat is changed to reduce a common input issue in vim. When
    # attempting to move to the end of a line using `SHIFT-4` I often release
    # the shift before releasing the 4. The time between the release of these
    # two keys is often long enough to trigger repeat. Though in this case the
    # `4` is repeated resulting in unwanted repeated inputs.
    delay=$(defaults read NSGlobalDomain InitialKeyRepeat)
    echo "Current key repeat delay settings: ${delay}"
    delay=80
    echo "Setting the new key repeat delay to \'${delay}\'"
    defaults write NSGlobalDomain InitialKeyRepeat -int  $delay
else
    echo "Unknown os: $OSTYPE"
fi
