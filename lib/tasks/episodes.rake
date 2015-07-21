namespace :episodes do
  desc "Generate sample episodes"
  task create: :environment do
    50.times do |i|
      Episode.create title: "Episdoe ##{i+1}",
                     description: "Episode ##{i+1}'s description",
                     youtube_url: "https://www.youtube.com/embed/xLWJVnqgDGA?controls=1&amp;showinfo=0"
    end
  end
end
