# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create email: "norin@example.com",
            username: "Norin",
            password: "secret",
            password_confirmation: "secret",
            account_activated: true

5.times do |i|
  lesson = Lesson.create name: "Lesson ##{i+1}"
  50.times do |i|
    Episode.create title: "Episode ##{i+1}", lesson: lesson,
                   description: "Episode ##{i+1}'s description",
                   youtube_url: "https://www.youtube.com/embed/xLWJVnqgDGA?controls=1&amp;showinfo=0"
  end
end
