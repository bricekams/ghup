require 'open3'
require 'tmpdir'

git_url = 'https://github.com/jotterkain/maerifaa'
tmp_dir = Dir.mktmpdir
`git clone #{git_url} #{tmp_dir}`

stdout, stderr, status = Open3.capture3("flutter pub get", :chdir => tmp_dir)
if status.success?
  puts "Dépendances installées avec succès"
else
  puts "Erreur lors de l'installation des dépendances : #{stderr}"
end

apk_path = File.join(tmp_dir, 'build', 'app', 'outputs', 'flutter-apk', 'app-release.apk')
stdout, stderr, status = Open3.capture3("flutter build apk", :chdir => tmp_dir)
if status.success?
  puts "APK construit avec succès"
else
  puts "Erreur lors de la construction de l'APK : #{stderr}"
end

emulator_name = 'Pixel_4_API_30'
stdout, stderr, status = Open3.capture3("emulator -avd #{emulator_name} &")
if status.success?
  puts "Émulateur lancé avec succès"
else
  puts "Erreur lors du lancement de l'émulateur : #{stderr}"
end

while true do
  stdout, stderr, status = Open3.capture3("adb shell getprop sys.boot_completed")
  if stdout.strip == "1"
    break
  end
  sleep(1)
end
puts "Émulateur prêt"

stdout, stderr, status = Open3.capture3("adb install -r #{apk_path}")
if status.success?
  puts "APK installé avec succès"
else
  puts "Erreur lors de l'installation de l'APK : #{stderr}"
end

FileUtils.remove_entry(tmp_dir)

