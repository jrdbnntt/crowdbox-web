fs = require('fs')
path = require('path')
Q = require('q')
ytdl = require('ytdl-core')
Ffmpeg = require('fluent-ffmpeg')

module.exports = (url, folder) ->
  console.log "Processing #{url}"

  deferred = Q.defer()

  ytdl.getInfo url, (err, info) ->
    if err?
      console.log err
      deferred.reject(new Error(err))
      return

    pathToSong = path.join(folder, "#{info.video_id}.mp3")
    if not fs.existsSync(pathToSong)
      console.log "Streaming and converting to #{pathToSong}"
      stream = ytdl(url) 
      new Ffmpeg(source: stream)
        .setFfmpegPath('/bin/ffmpeg')
        .withAudioCodec('libmp3lame')
        .toFormat('mp3')
        .saveToFile pathToSong
        .on 'error', ->
          console.log("ffmpeg error with #{pathToSong}")
          deferred.reject(new Error('ffmpeg error'))
        .on 'end', ->
          console.log "Downloaded to #{pathToSong}"
          deferred.resolve(info: info, pathToSong: pathToSong)
    else
      console.log "Already downloaded at #{pathToSong}"
      deferred.resolve(info: info, pathToSong: pathToSong)

  return deferred.promise