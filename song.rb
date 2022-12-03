require 'json'
require 'time'
require 'pry'
require 'http'

songs = []
Dir["endsong*.json"].each do |f|
  songs += JSON.parse(File.read(f))
end

songs = songs.map do |song|
  song["ts"] = Time.parse(song["ts"])
  song
end

findable_songs = songs.select { |s| !s["spotify_track_uri"].nil? }

findable_songs = findable_songs
  .sort_by { _1["ts"] }
  .chunk_while do |before, after|
    before["spotify_track_uri"] == after["spotify_track_uri"] &&
    after["ts"] < before["ts"] + 900
  end

binding.pry
