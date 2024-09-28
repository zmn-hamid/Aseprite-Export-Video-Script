# Export Video (MP4 and MKV) In Aseprite

This aseprite extension is for exporting animations to mp4 and mkv files.

## Important Note

Unfortunately this script doesn't work if there's a white space or a non-latin character in the path of your file (for example "c:/users/احمد/my project/output.mp4"). i have mentioned this issue in [here](https://github.com/zmn-hamid/Aseprite-Export-Video-Script/issues/2) and still haven't found a solution for it. Any help is appreciated.

### What's new?

- Added option for looping. Enter a number more than 1 and the script would create a
  new \_loop video file as well. Example: 2 equals playing the video twice (looping it once)

## Prerequisite

Download and install **FFMPEG** on your system and add it to the Environment Variables. **You can check this guide too**: https://phoenixnap.com/kb/ffmpeg-windows (not sponsored lmao)

## How to install?

1. download the [Export Video file](/Export%20Video.lua)
2. open aseprite, File > Scripts > Open Scripts Folder
3. paste the script in the folder that's opened

## How to use?

1. open your aseprite file
2. export the frames using the built-in export menu (to jpg or png files)
3. open the script from File > Scripts > Video Export
4. choose **THE FIRST** exported frame (e.g. `animation1.png`)
   **CHOOSE THE FIRST ONE OR OTHERWISE YOU MAY GET A SHITTY OUTPUT**
5. choose where to save the file, specify the name and choose one of the extensions (mkv or mp4)
6. click "Export Video"
7. wait a few seconds and check the folder you chose
8. say thanks

**Note**: You can make a looped animation by entering a number more than 1 in the "Loop Number" section

## Log
To get a log of FFMPEG (the video maker tool used for this project), copy the [conf.lua](conf.lua) file
to the same directory where your aseprite file is, so each time a ffmpeg log error would be made. change
the `true` to `false` if you want to prevent the logging (default is false, so you can remove the file too)

**IMPORTANT NOTE**: Everytime you make changes to the `conf.lua` file, you gotta restart the whole app. That's
just how it works unfortunately.
