# Guard::Shell

This little guard allows you to run shell commands when files are altered.


## Install

Make sure you have [guard](http://github.com/guard/guard) installed.

Install the gem with:

    gem install guard-shell

Or add it to your Gemfile:

    gem 'guard-shell'

And then add a basic setup to your Guardfile:

    guard init shell


## Usage

If you can do something in your shell, or in ruby, you can do it when files change
with guard-shell. It simply executes a block if one or more matching files change,
and if anything is returned from the block it will be printed. For example

``` ruby
guard :shell, run: proc { |files| `bin/rake graphql:schema:idl` } do
  watch %r{app/graphql.+}
end
```

will run a rake task and print the returned output from the rake task to the console.


``` ruby
guard :shell, run: proc { |files| "#{files.join} changed" }, run_at_start: true do
  watch %r{app/graphql.+}
end
```

There is also a shortcut for easily creating notifications:

``` ruby
guard :shell, run: proc { |files| n "GraphQL", `bin/rake graphql:schema:idl` } do
  watch %r{app/graphql.+}
end
```

`#n` takes up to three arguments; the first is the body of the message, here the path
of the changed file; the second is the title for the notification; and the third is
the image to use. There are three (four counting `nil` the default) different images
that can be specified `:success`, `:pending` and `:failed`.


### Examples

#### Saying the Name of the File You Changed and Displaying a Notification

``` ruby
guard :shell, run: proc { |files|
  n files.join, 'Changed'
  `say -v cello #{m[0]}`
  } do
  watch /(.*)/
end
```

#### Rebuilding LaTeX

``` ruby
guard :shell, :run_at_start => true do
  watch /^([^\/]*)\.tex/ do |m|
    `pdflatex -shell-escape #{m[0]}`
    `rm #{m[1]}.log`

    count = `texcount -inc -nc -1 #{m[0]}`.split('+').first
    msg = "Built #{m[1]}.pdf (#{count} words)"
    n msg, 'LaTeX'
    "-> #{msg}"
  end
end
```

#### Check Syntax of a Ruby File

``` ruby
guard :shell do
  watch /.*\.rb$/ do |m|
    if system("ruby -c #{m[0]}")
      n "#{m[0]} is correct", 'Ruby Syntax', :success
    else
      n "#{m[0]} is incorrect", 'Ruby Syntax', :failed
    end
  end
end
```