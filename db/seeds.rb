# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
ApplicationRecord.connection.reset_pk_sequence!('users')
Band.destroy_all
ApplicationRecord.connection.reset_pk_sequence!('bands')
Album.destroy_all
ApplicationRecord.connection.reset_pk_sequence!('albums')
Track.destroy_all
ApplicationRecord.connection.reset_pk_sequence!('tracks')
Note.destroy_all
ApplicationRecord.connection.reset_pk_sequence!('notes')
Tag.destroy_all
ApplicationRecord.connection.reset_pk_sequence!('tags')
Tagging.destroy_all
ApplicationRecord.connection.reset_pk_sequence!('taggings')

u1 = User.create!(email: "admin@musicapp.com", password: "password", activated: true, admin: true)
u2 = User.create!(email: Faker::Internet.email, password: "password", activated: true)
u3 = User.create!(email: Faker::Internet.email, password: "password", activated: true)
u4 = User.create!(email: Faker::Internet.email, password: "password", activated: true)

Tag.create!(tag: "Sick Music")
Tag.create!(tag: "Good Vibes")
Tag.create!(tag: "Fire")
Tag.create!(tag: "Chill")
Tag.create!(tag: "Mind Melting")

10.times do |i|
  Band.create!(name: Faker::Music.band)
  nums = (1..5).to_a
  first_num = nums.sample
  nums.delete(first_num)
  second_num = nums.sample
  Tagging.create!(taggable_type: "Band", taggable_id: i + 1, tag_id: first_num)
  Tagging.create!(taggable_type: "Band", taggable_id: i + 1, tag_id: second_num)
end

10.times do |i|
  4.times do 
    Album.create!(
      title: Faker::Music.album, 
      year: Faker::Date.between(from: '1970-01-01', to: '2019-12-31').year, 
      band_id: i + 1
    )
  end
end

40.times do |i|
  12.times do |o|
    lyrics = Faker::Lorem.sentences(number: 15).join("").split(".").join("\r\n")
    Track.create!(
      title: Faker::Music::RockBand.song,
      ord: o + 1,
      album_id: i + 1,
      lyrics: lyrics
    )
  end
  nums = (1..5).to_a
  first_num = nums.sample
  nums.delete(first_num)
  second_num = nums.sample
  Tagging.create!(taggable_type: "Album", taggable_id: i + 1, tag_id: first_num)
  Tagging.create!(taggable_type: "Album", taggable_id: i + 1, tag_id: second_num)
end

480.times do |i|
  3.times do |o|
    Note.create!(
      content: Faker::Lorem.sentence,
      user_id: o + 2,
      track_id: i + 1
    )
  end
  nums = (1..5).to_a
  first_num = nums.sample
  nums.delete(first_num)
  second_num = nums.sample
  Tagging.create!(taggable_type: "Track", taggable_id: i + 1, tag_id: first_num)
  Tagging.create!(taggable_type: "Track", taggable_id: i + 1, tag_id: second_num)
end