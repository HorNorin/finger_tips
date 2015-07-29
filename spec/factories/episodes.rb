FactoryGirl.define do
  factory :episode do
    lesson
    duration 30
    title "Episode"
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', 'episode_image.png')) }
    description "Episode's description"
    youtube_url "https://www.youtube.com/embed/xLWJVnqgDGA?controls=1&amp;showinfo=0"
  end
end
