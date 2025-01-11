# This Project Is No Longer Maintained

# Export Video (MP4 and MKV) In Aseprite

This aseprite extension is for exporting animations to mp4 and mkv files.

### Looping

- You can loop your animations as well. Example number: 2 -> playing the video twice (looping it once)

## UPDATE

With the latest update, all of the errors have been fixed and imporvements have been made:
1) There's **no need for specific naming or choosing the first image only** anymore.
2) **The problem with spaces, numbers and underscores have been completely fixed**
3) **The problem with non-Latin chracters have been handled**:
    - Unfortunately ffmpeg (the module responsible for making the animation) doesn't recognize non-ascii or non-Latin characters/letters.
    - No folder name in the file paths are accepted if it includes non-ascii characters. If you use them, the app will alert you and wouldn't proceed.

      Examples that will work:
        - C:/Users/Hamid/Desktop/frames/فریم.png
        - C:/Users/Hamid/Desktop/frames/خروجی.mkv

      Examples that wouldn't work:
        - C:/Users/Hamid/Desktop/فریمها/frame.png
        - C:/Users/Hamid/Desktop/فریمها/output.mkv
      
      Note: If you know how to overcome this issue with FFMPEG, contact me. Unfortunately, "chcp 65001" didn't work for me.

## Prerequisite

Download and install **FFMPEG** on your system and add it to the Environment Variables. **You can check this guide too**: https://phoenixnap.com/kb/ffmpeg-windows (not sponsored lmao)

## How to install?

1. Download the [Export Video file](/Export%20Video.lua)
2. Open aseprite, File > Scripts > Open Scripts Folder
3. Paste the script in the folder that's opened

## How to use?

1. Open your aseprite file
2. Export the frames using the built-in export menu (to jpg or png files)
3. open the script from File > Scripts > Video Export
4. Choose one of the frames that you just exported
5. Choose where to save the file, specify the name and choose one of the extensions (mkv or mp4)
6. Click "Export Video"
7. Wait a few seconds and you're done
8. Buy me a coffee if you will :D

## Log
To get a log of FFMPEG (the video maker tool used for this project), copy the [conf.lua](conf.lua) file
to the same directory where your aseprite file is, so each time a ffmpeg log error would be made. change
the `true` to `false` if you want to prevent the logging (default is false, so you can remove the file too)

**IMPORTANT NOTE**: Everytime you make changes to the `conf.lua` file, you gotta restart the whole app. That's
just how Aseprite works unfortunately.

# Copyright

This script is free for any usage, personal or commercial. Do not share without crediting the project.

## Buy me a coffee

I've put so much energy into this script. I would highly appreciate it if you could donate me

- USDT (BEP20): `0xF11206c2234306c55794169C3991f9e8a09063Eb`
- USDT (ERC20): `0xF11206c2234306c55794169C3991f9e8a09063Eb`
