require 'guard/compat/plugin'
require 'guard/super_shell/version'
require 'open3'

module Guard
  class SuperShell < Plugin
    def start
      if options[:run_at_start]
        Compat::UI.info "#{name} running at start"
        run_command
      end
    end

    def stop
    end

    def run_on_changes(files)
      Compat::UI.info "#{name}: #{files.join}"
      run_command(files)
    end

    def run_all
      run_command
    end

    def name
      options[:name] || "shell"
    end

    private

    def run_command(files = [])
      command = options[:command].call(files)
      (stdin, stdout_and_stderr, thread) = Open3.popen2e(command)
      output = stdout_and_stderr.read
      puts output

      if thread.value.success?
        Compat::UI.notify(output.lines.last, title: name, type: :success) if notify?
      else
        Compat::UI.notify(output.lines.last, title: name, type: :failed) if notify?
        throw :task_has_failed
      end
    rescue => e
      msg = "#{e.class.name}: #{e.message}"
      Compat::UI.error "#{name}: raised error #{msg}"
      Compat::UI.notify(msg, title: name, type: :failed) if notify?
      throw :task_has_failed
    end

    def notify?
      options.fetch(:notification, true)
    end

    def run_at_start?
      options.fetch(:run_at_start, false)
    end
  end
end
