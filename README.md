# SoxSlider

![Screenshot](https://i.imgur.com/K13d3an.png)

- Simple UI with volume slider for Sox, made in about an hour with a lot of help from ChatGPT
- Very barebones, very shitty.
- App icon made with Bing Copilot, it's bad too.

# Why?

In my case I have my Steam Deck and PS5 hooked up to a computer monitor, and that computer monitors Line Out goes to a [Line In USB-C Adapter](https://www.sonos.com/en/shop/sonos-line-in-adapter). Using `sox` I can listen to the audio coming in, while also hearing stuff from my Mac (like music, youtube) while playing games.

# Do I need this?

**No!** All this app does is run this command basically:

`sox -v 1.0 -V0 --multi-threaded --input-buffer 32 --buffer 128 -d -d`

(`sox` can be installed with Homebrew: `brew install sox`)

All this app helps with is modifying the value for `-v`, the volume.
(And it comes with `sox` bundled with it)

# So why are you sharing this?

Maybe I'll need this in the future. Maybe someone has use for it too.

# Known issues

- You can not select audio device. It will use whatever you defaults are in system audio settings.
- If you quit the app (⌘Q), you will keep hearing audio because sox is still running. Run `killall sox` in a Terminal to kill it.
- Volume doesn't adjust while sliding. This is intentional as I have to restart sox to apply the new `-v` parameter.
- Volume gets reset each time you run it
