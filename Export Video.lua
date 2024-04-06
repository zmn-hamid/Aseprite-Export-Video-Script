local dlg = Dialog("Export Video")

if app.sprite then
    if not (string.find(app.sprite.filename, '/') or string.find(app.sprite.filename, '\\')) then
        app.alert('save the file and export the frames first')
    end
else
    app.alert('no file is opened')
end

dlg:newrow()
dlg:file{
    id = 'firstFramePath',
    label = 'choose the first frame:',
    title = 'Choose THE FIRST exported frame (e.g. 1.png)',
    open = false,
    save = false,
    load = true,
    filetypes = {'png', 'jpg'}
}

dlg:newrow()
dlg:file{
    id = 'saveTo',
    label = 'Save To:',
    title = 'Choose where to save the video',
    open = false,
    save = true,
    load = false,
    filetypes = {'mkv', 'mp4'}
}

dlg:newrow()
dlg:button{
    id = "export",
    text = "Export Video",

    onclick = function()
        local data = dlg.data
        local firstFramePath = data.firstFramePath
        local saveTo = data.saveTo

        if not firstFramePath then
            return app.alert('you gotta choose a sample exported frame first')
        end
        if not saveTo then
            return app.alert('choose where to save the file first')
        end
        local firstFrameParentFolder = firstFramePath ~= '' and firstFramePath:match("(.*[/\\])") or ''
        local saveDestination = saveTo ~= '' and saveTo:match("(.*[/\\])") or ''
        local ffconcatContent = "ffconcat version 1.0\n"
        local sprite = app.sprite

        -- find concat patternstring.match(fullPath, "/([^/]-)$")
        local sampleFileNameEXT = string.match(firstFramePath,
            string.format("%s([^%s]-)$", app.fs.pathSeparator, app.fs.pathSeparator))
        local framePrefix, frameNumber, frameExtension = string.match(sampleFileNameEXT, "(%a*)(%d+)(%.%w+)")
        local numberOfZeros = frameNumber:len()
        local pattern = string.format('%s%%0%sd%s', framePrefix, numberOfZeros, frameExtension)

        -- Create info.ffconcat file
        for i, frame in ipairs(sprite.frames) do
            local filename = app.fs.joinPath(firstFrameParentFolder, string.format(pattern, i))
            local frameDuration = frame.duration -- Convert duration to seconds
            ffconcatContent = ffconcatContent .. string.format("file '%s'\nduration %s\n", filename, frameDuration)
        end

        local concatFilePath = saveDestination .. "info.ffconcat"
        local concatFile = io.open(concatFilePath, "w")
        concatFile:write(ffconcatContent)
        concatFile:close()

        -- Run ffmpeg command
        local changeDirCommand = string.format("cd /d %s", saveDestination)
        local ffmpegCommand = string.format(
            "ffmpeg -f concat -safe 0 -y -i info.ffconcat -pix_fmt yuv420p -t 3.4 \"%s\"", saveTo)
        os.execute(changeDirCommand .. " && " .. ffmpegCommand)

    end
}
dlg:button{
    id = "cancel",
    text = "Cancel",

    onclick = app.command.Cancel
}
dlg:button{
    id = "help",
    text = "Help!",
    onclick = function()
        local helpDlg = Dialog("Help!")
        helpDlg:label{
            label = "go to github lol"
        }
        helpDlg:show()

    end
}

dlg:show{
    wait = false

}
