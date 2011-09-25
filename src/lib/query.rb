# Copyright (C) Thomas Chace 2011 <ithomashc@gmail.com>
#
# This file is part of Post.
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

require("rubygems")
require("fileutils")
require("xmlsimple")
require("net/http")

load(File.join(File.expand_path(File.dirname(__FILE__)), "tools.rb"))

module Query
    class << self
        def getCurrentChannel()
            return Tools.openXML("etc/post/channel.xml")
        end
        def getUrl(package)
            package = package.to_s()
            channel = getCurrentChannel()
            channelUrl = channel['url'][0]
            url = "#{channelUrl}/#{getFileName(package)}"
            return url
        end
        def getFiles(package)
            files = open(Tools.getRoot() + "var/lib/post/installed/#{package}/files", 'r')
            return files.readlines()
        end
        def getFileName(package)
            return "#{package}-#{getLatestVersion(package)}-#{getPackageArch(package)}.pst"
        end
        def getFileList(package)
            File.read(Tools.getRoot() + "var/lib/post/installed/" + package + "/files")
        end
        def getRemoveScript(package)
            File.read(Tools.getRoot() + "var/lib/post/installed/" + package + "/remove.rb")
        end
        def getInstallScript(package)
            File.read(Tools.getRoot() + "var/lib/post/installed/" + package + "/install.rb")
        end
        def addInstalledPackage(packageData, installFile, removeFile, installedFiles)
            data = Tools.openXML(packageData)
            Tools.mkdir("var/lib/post/installed/" + data['name'][0])
            Tools.installFile(packageData, "var/lib/post/installed/" + data['name'][0] + "/packageData.xml")
            Tools.installFile(installFile, "var/lib/post/installed/" + data['name'][0] + "/install.rb")
            Tools.installFile(removeFile, "var/lib/post/installed/" + data['name'][0] + "/remove.rb")
            File.open(Tools.getRoot() + "var/lib/post/installed/" + data['name'][0] + "/files", 'w') do |file|
                file.puts(installedFiles)
            end
        end
        def removeInstalledPackage(package)
            FileUtils.rm_r(Tools.getRoot() +"var/lib/post/installed/" + package)
        end
        def getAvailable(package)
            if File.exists?(Tools.getRoot() + "var/lib/post/available/" + package + ".xml")
                return true
            else
                return false
            end
        end
        def getInstalled(package)
            if File.exists?(Tools.getRoot() + "var/lib/post/installed/" + package + "/packageData.xml")
                return true
            else
                return false
            end
        end
        def getPackageArch(package)
            package = package.to_s()
            if (getAvailable(package))
                data = Tools.openXML("var/lib/post/available/" + package + ".xml")
                #architectureList = data['architecture']
                return data['architecture'][0].to_s()
            end
        end
        def getLatestVersion(package)
            package = package.to_s()
            if (getAvailable(package))
                data = Tools.openXML("var/lib/post/available/" + package + ".xml")
                return data['version'][0].to_s
            else
                return 0
            end
        end
        def getDependencies(package)
            package = package.to_s()
            if (getAvailable(package))
                data = Tools.openXML("var/lib/post/available/" + package + ".xml")
                if (data['dependencies'].to_s() == "")
                    return []
                else
                    return data['dependencies']
                end
            else
                return []
            end
        end
    end
end
