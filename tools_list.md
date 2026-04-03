## our nice terminal
- ghostty https://ghostty.org/

## use this to view images in the terminal
- kitty for terminal image rendering
    - https://sw.kovidgoyal.net/kitty/binary/
### Back up image rendering
- chafa https://hpjansson.org/chafa

## Other things
- ripgrep -> much faster grep
- ruff
- pyright 
- pip3 install pyright
- local excalidraw with the mermaid conversion extension
    - https://github.com/excalidraw/mermaid-to-excalidraw#
- yq
    - used for toml and yaml parsing


Nice Alias
`git log --oneline --decorate --graph --all`
`kitty +kitten icat`

---
# Experiments
bat and bat-extras:
    Bat is a better cat that does syntax high lighting among other things
    
- ohmyzsh
    - command suggestions
    - command parameter tab options
    - Current thoughts:
        - Not sure what the hype is about. The shadow of previous commands are
          a little annoying. And tab complete doesn't seem to offer much.
- excalidraw extensions:
    - Feed in mermaid files directly
    - extend to d2 perhaps by having a in between conversion.
- pass 
    - https://www.passwordstore.org/
    - for password management
- passmenu
    - https://git.zx2c4.com/password-store/tree/contrib/dmenu/passmenu
    - to view passwords

- Creating gifs using ffmpeg. I'm currently thinking of using this with excalidraw
    `ffmpeg -framerate 10 -i img%03d.png output.gif`
