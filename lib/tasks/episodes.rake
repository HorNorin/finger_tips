namespace :episodes do
  desc "Generate sample episodes"
  task create: :environment do
    5.times do |i|
      lesson = Lesson.create name: "Lesson ##{i+1}"
      50.times do |i|
        Episode.create title: "Episode ##{i+1}",
                       description: "Episode ##{i+1}'s description",
                       youtube_url: "https://www.youtube.com/embed/xLWJVnqgDGA?controls=1&amp;showinfo=0"
      end
    end
  end
end
