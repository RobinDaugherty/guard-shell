require 'guard/compat/plugin'
require 'guard/shell/version'

module Guard
  class Shell < Plugin

    # Calls #run_all if the :run_at_start option is present.
    def start
      $stdout.puts run if options[:run_at_start]
    end

    # Defined only to make callback(:stop_begin) and callback(:stop_end) working
    def stop
    end

    def run_on_changes(files)
      $stdout.puts run(files)
    end

    private

    def run(files = [])
      options[:run].call(files)
    end

  end

  class Dsl
    # Easy method to display a notification
    def n(msg, title='', image=nil)
      Compat::UI.notify(msg, :title => title, :image => image)
    end

    # Eager prints the result for stdout and stderr as it would be written when
    # running the command from the terminal. This is useful for long running
    # tasks.
    def eager(command)
      require 'pty'

      begin
        PTY.spawn command do |r, w, pid|
          begin
            $stdout.puts
            r.each {|line| print line }
          rescue Errno::EIO
            # the process has finished
          end
        end
      rescue PTY::ChildExited
        $stdout.puts "The child process exited!"
      end
    end
  end
end
