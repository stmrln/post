# Copyright (C) Thomas Chace 2010-2011 <ithomashc@gmail.com>
# Ruby Build System
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
# 
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above
#   copyright notice, this list of conditions and the following disclaimer
#   in the documentation and/or other materials provided with the
#   distribution.
# * Neither the name of the  nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 

require("rubygems")
require('rbconfig')

$ruby = RbConfig::CONFIG["bindir"] + "/" + RbConfig::CONFIG["ruby_install_name"]

puts("Using: #{$ruby}")

if $ruby =~ /rbx/
    $ruby = "#{$ruby} -Xcompiler.no_rbc"
end

begin
    unless (RUBY_ENGINE == "rbx") or (RUBY_ENGINE == "jruby")
        puts("Your ruby VM is not supported.")
    end
rescue NameError
    puts("Your ruby VM is not supported.")
end

begin
    require("optparse")
rescue
    puts("Could not load optparse.")
    puts("Testing: FAILED")
end

begin
    require("xmlsimple")
rescue
    puts("Could not load xmlsimple.")
    puts("Testing: FAILED")
end

unless (RbConfig::CONFIG["host_os"] =~ /linux/) or (RbConfig::CONFIG["host_os"] =~ /mac/)
    puts("Host operating system not supported.")
    puts("Testing: FAILED")
end

puts("Testing...")

begin
    load("src/lib/fetch.rb")
    load("src/lib/erase.rb")
    load("src/lib/refresh.rb")
    load("src/lib/tools.rb")
    load("src/lib/query.rb")
rescue
    puts("Testing: FAILED")
end