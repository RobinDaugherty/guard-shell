# guard-super_shell

Shell commands triggered by files changing.

- [ ] TODO: Update specs

## Differences from [guard-shell](https://github.com/guard/guard-shell)

- Runs the shell command on a set of changes instead of once per file (like all other guards)
- `run_on_start` option runs the command once, not once per file that will be watched
- Shows notifications based on the command status, no additions to the DSL
- Last line of command output is shown in the notification
- `name` option provides a meaningful name for each instance which is displayed in console and notifications
- Runs on all file changes, not just modifications of existing files.

## Install

Make sure you have [guard](http://github.com/guard/guard) installed.

Install the gem with:

    gem install guard-super_shell

Or add it to your Gemfile:

    gem 'guard-super_shell'

And then add a basic setup to your Guardfile:

    guard init shell


## Usage

If you can do something in your shell, or in ruby, you can do it when files change
with guard-super_shell. It executes a shell command built by the `command` block you provide,
if one or more matching files change.
The output of the command is shown in the console.
It shows a notification based on the return status of that shell command.

``` ruby
guard(
  :shell,
  name: "GraphQL Schema",
  command: proc { |files| "bin/rake graphql:schema:idl" },
) do
  watch %r{app/graphql.+}
end
```

will run a rake task and print the returned output from the rake task to the console.

You can also return an array of command components. To have it run at startup:

``` ruby
guard(
  :shell,
  name: "GraphQL Schema",
  run_at_start: true,
  command: proc { |files| ["bin/rake", "graphql:schema:idl"] },
) do
  watch %r{app/graphql.+}
end
```

### Examples

#### Saying the Name of the File(s) You Changed

``` ruby
guard(
  :shell,
  name: "Speak Changes",
  command: proc { |files| "say -v cello #{files.join(" ")}" },
) do
  watch /(.*)/
end
```

#### Check Syntax of a Ruby File

``` ruby
guard(
  :shell ,
  name: "Check Ruby Syntax",
  command: proc { |files| "ruby -c #{files.join(' ')}" },
) do
  watch /.*\.rb$/
end
```

#### Run tests on corresponding file

``` ruby
guard(
  :shell ,
  name: "Run Corresponding Test",
  command: proc { |files| "bin/test #{files.join(' ')}" },
) do
  # Translate the matching changed file path to get the path of the corresponding test file.
  watch %r{app/stuff/(.*)\.rb$} { |m| "spec/stuff/#{m[1]}_test.rb" }
end
```
