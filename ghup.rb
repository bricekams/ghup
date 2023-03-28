require 'open3'
require 'tmpdir'

git_url = 'https://github.com/jotterkain/maerifaa'
tmp_dir = Dir.mktmpdir
`git clone #{git_url} #{tmp_dir}`

stdout, stderr, status = Open3.capture3("flutter pub get", :chdir => tmp_dir)
if status.success?
  puts "Dependencies successfully installed"
else
  puts "Error while installing dependencies : #{stderr}"
end

apk_path = File.join(tmp_dir, 'build', 'app', 'outputs', 'flutter-apk', 'app-release.apk')
stdout, stderr, status = Open3.capture3("flutter build apk", :chdir => tmp_dir)
if status.success?
  puts "APK build done"
else
  puts "Error while building the apk : #{stderr}"
end

emulator_name = 'Pixel_4_API_30'
stdout, stderr, status = Open3.capture3("emulator -avd #{emulator_name} &")
if status.success?
  puts "Emulator started"
else
  puts "Error while starting emulator : #{stderr}"
end

while true do
  stdout, stderr, status = Open3.capture3("adb shell getprop sys.boot_completed")
  if stdout.strip == "1"
    break
  end
  sleep(1)
end
puts "Emulator ready"

stdout, stderr, status = Open3.capture3("adb install -r #{apk_path}")
if status.success?
  puts "APK successfully installed"
else
  puts "Error while installing the apk : #{stderr}"
end

FileUtils.remove_entry(tmp_dir)

