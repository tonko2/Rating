require 'fssm'

LINE = "--------------------------"

def run_system(base, file)
  file_names = file.split(".")
  input_file_name = file_names[0] + ".in"
  puts ""
  puts "RUN: #{file}"
  puts LINE
  if system("g++ #{file} -o #{file_names[0]}")
    if File.exist?("#{input_file_name}")
      IO.popen("./#{file_names[0]}", 'r+') do |io|
        File.open("./#{input_file_name}", "r") do |f|
          while line = f.gets do
            io.puts line
          end
        end
        io.close_write
        while result = io.gets
          puts result
        end
      end
      puts LINE
      puts "finished copying to the clipboard!" if system("cat #{file} | pbcopy")
    else
      system("./#{file_names[0]}")
    end
  end
end

FSSM.monitor('.', '*.cpp') do
  update do|base, file|
    run_system(base, file)
  end
  create do|base, file|
    run_system(base, file)
  end
end
