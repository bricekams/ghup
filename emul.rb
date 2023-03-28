system('emulator -avd Pixel_4_API_30 &')

sleep(30)

output = `adb devices -l`
lines = output.split("\n")
lines.each do |line|
  if line.include?('emulator')
    device_id = line.split(' ')[0]
    puts "Emulator device ID: #{device_id}"
    break
  end
end

system("adb -s #{device_id} wait-for-device")
system("adb -s #{device_id} shell 'while [[ \"$(getprop sys.boot_completed)\" != \"1\" ]]; do sleep 1; done;'")
puts 'Emulator is ready!'

