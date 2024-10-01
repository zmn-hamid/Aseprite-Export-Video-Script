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
dlg:number{
    id = 'loopAmount',
    label = 'Loop Number:',
    text = "1",
    decimals = integer
}

dlg:newrow()
dlg:button{
    id = "export",
    text = "Export Video",

    onclick = function()
        local data = dlg.data
        local firstFramePath = data.firstFramePath
        local saveTo = data.saveTo
        local loopAmount = data.loopAmount
        if (math.type(loopAmount) ~= "integer") or (loopAmount < 1) then
            app.alert('loop amout is wrong')
            return
        end
        loopAmount = loopAmount - 1

        if not firstFramePath then
            return app.alert('you gotta choose a sample exported frame first')
        end
        if not saveTo then
            return app.alert('choose where to save the file first')
        end
        local FramesParentFolder = firstFramePath ~= '' and
                                       string.match(firstFramePath, "(.*" .. app.fs.pathSeparator .. ")") or ''
        local saveToParentFolder = saveTo ~= '' and string.match(saveTo, "(.*" .. app.fs.pathSeparator .. ")") or ''
        local ffconcatContent = "ffconcat version 1.0\n"
        local sprite = app.sprite

        -- check no latin character in the folder of the sample frame or saveTo
        function isnt_safe(str)
            -- Match any character that is not in the ASCII range (0-127)
            return str:match("[\128-\255]") ~= nil
        end
        if isnt_safe(FramesParentFolder) or isnt_safe(saveToParentFolder) or isnt_safe(app.fs.fileTitle(saveTo)) then
            app.alert("non-latin characters are only permitted for the name of the frame images. " ..
                          "you should not put any non-latin chraacter in the folder's names or the export file name.")
            return
        end

        -- get the logging status
        local ffmpeg_log = false
        function loadconf()
            local conf = require "conf"
            ffmpeg_log = conf.log_ffmpeg
        end
        pcall(loadconf)

        -- find frames files
        local FolderFiles = app.fs.listFiles(string.match(firstFramePath, "(.*" .. app.fs.pathSeparator .. ")"))
        local frame_images = {}
        for _, sframe in ipairs(FolderFiles) do
            if string.match(sframe, "%." .. app.fs.fileExtension(firstFramePath) .. "$") then
                table.insert(frame_images, sframe)
            end
        end
        table.sort(frame_images, function(a, b)
            -- Extract the numeric part from the strings
            local numA = tonumber(string.match(a, "%d+"))
            local numB = tonumber(string.match(b, "%d+"))

            -- Compare based on the numeric part
            return numA < numB
        end)

        -- Create _info ffconcat file
        for i, frame in ipairs(sprite.frames) do
            local filename = app.fs.joinPath(FramesParentFolder, frame_images[i])
            local frameDuration = frame.duration -- Convert duration to seconds
            ffconcatContent = ffconcatContent .. string.format("file '%s'\nduration %s\n", filename, frameDuration)
        end

        local concatFilePath = saveToParentFolder .. "_info"
        local concatFile = io.open(concatFilePath, "w")
        concatFile:write(ffconcatContent)
        concatFile:close()

        -- get report argument's text
        local report_text = ''
        if ffmpeg_log == true then
            report_text = ' -report'
        end

        -- Run ffmpeg command
        local ffmpegCommand = string.format('ffmpeg -f concat -safe 0 -y -i "%s" -pix_fmt yuv420p "%s"%s',
            concatFilePath, saveTo, report_text)
        os.execute(ffmpegCommand)
        if loopAmount > 0 then
            local loopSaveTo = app.fs.filePathAndTitle(saveTo) .. '_loop' .. loopAmount + 1 .. "." ..
                                   app.fs.fileExtension(saveTo)
            os.execute(string.format('ffmpeg -y -stream_loop %s -i "%s" -c copy "%s"%s', loopAmount, saveTo, loopSaveTo,
                report_text))
        end
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
