Q = require('q')
YouTube = require('youtube-node')

yt = new YouTube()
yt.setKey 'AIzaSyC8uRTf_hJCiI5Yy0t88Kds97gaa47q6TI'

module.exports = (query) ->

  deferred = Q.defer()

  yt.search query, 1, (data) ->
    if data?.items?[0]?.id?.videoId?
      videoData = data.items[0]
      videoData.url = "http://youtu.be/#{videoData.id.videoId}"
      deferred.resolve(videoData)
    else
      deferred.reject(new Error("YouTube Search error"))

  return deferred.promise
