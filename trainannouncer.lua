local aukit = require "aukit"
local speaker = peripheral.find("speaker")

function log(string)
    io.write("[", os.date("%m/%d - %T"), "] ")
    io.write(string, "\n")
end

function openAudio()
    local path = shell.resolve("doors.dfpwm")
    local file = fs.open(path, "rb")
    local data = file.readAll()
    file.close()
    return data
end

function playDoorClosingCue()
    for i = 0, 4, 1 do
        speaker.playNote("chime", 2.0, 19)
        os.sleep(0.25)
        speaker.playNote("chime", 2.0, 3)
        os.sleep(1)
    end
end

log("started program")
local shouldPlay = false -- To know if the audio has already been played
local audio = openAudio()
log("starting to poll redstone")

while true do
    os.sleep(1)
    local currValue = redstone.getInput("left")
    if currValue == true then
        log("redstone signal detected!")
        if shouldPlay == true then
            log("playing audio")
            aukit.play(aukit.stream.dfpwm(audio), speaker)
            playDoorClosingCue()
        end 
        shouldPlay = false
    elseif currValue == false then
        shouldPlay = true
        log("no redstone signal detected")
    end 
end