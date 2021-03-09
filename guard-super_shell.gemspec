# -*- encoding: utf-8 -*-
require File.expand_path("../lib/guard/super_shell/version", __FILE__)

Gem::Specification.new do |s|
  s.name         = "guard-super_shell"
  s.author       = "Robin Daugherty"
  s.email        = "robin@robindaugherty.net"
  s.summary      = "Guard plugin that simply runs a shell command"
  s.homepage     = "http://github.com/RobinDaugherty/guard-super_shell"
  s.license      = 'MIT'
  s.version      = Guard::SuperShellVersion::VERSION

  s.description  = <<-DESC
    Runs a shell command when specific files change. Shows the output
    and a notification based on the command's return status.
    Runs command once per _set_ of file changes.
  DESC

  s.add_dependency 'guard', '~> 2.0'
  s.add_dependency 'guard-compat', '~> 1.0'

  s.files        = %w(README.md LICENSE)
  s.files       += Dir["{lib}/**/*"]
end
