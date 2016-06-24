require 'headless'
require 'fileutils'

Capybara.default_max_wait_time = 10
Capybara.default_driver = :selenium
headless = Headless.new(display: 98, video: { frame_rate: 12, codec: 'libx264' })
headless.start

Before do
  headless.video.start_capture
end

After do |scenario|
  # scenario.failed?
  feature_name  = scenario.feature.name
  scenario_name = scenario.name

  video_path      = Rails.root.join("selenium/video/#{feature_name}/#{scenario_name}.mp4")
  screenshot_path = Rails.root.join("selenium/screenshot/#{feature_name}/#{scenario_name}.png")

  FileUtils.mkdir_p(File.dirname(video_path))
  FileUtils.mkdir_p(File.dirname(screenshot_path))

  headless.video.stop_and_save(video_path)
  headless.take_screenshot(screenshot_path)
end
