#
# Cookbook Name:: aptstd
# Recipe:: default
#
# Copyright 2012, Alexander Smirnov
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "apt"

if node['platform_version'] == "jessie/sid"
  platform_version_major = 8
  node.default['aptstd']['use_updates'] = false
  node.default['aptstd']['use_backports'] = false
else
  platform_version_major = node['platform_version'].to_i
end

case platform_version_major
when 5
  codename = "lenny"
when 6
  codename = "squeeze"
when 7
  codename = "wheezy"
when 8
  codename = "jessie"
end

if platform_version_major < 6
  mirror_main = node['aptstd']['mirror_archive']
  mirror_security = mirror_main + "-security"
  mirror_updates = mirror_main + "-volatile"
  mirror_backports = mirror_main + "-backports"
  distribution_updates = codename + "/volatile"
else
  mirror_main = node['aptstd']['mirror_main']
  mirror_security = node['aptstd']['mirror_security']
  mirror_updates = mirror_main
  if platform_version_major == 6
    mirror_main = node['aptstd']['mirror_archive']
    mirror_backports = mirror_main + "-backports"
    mirror_security = mirror_main + "-security"
    distribution_lts = codename + "-lts"
    mirror_lts = mirror_main
    node.default['aptstd']['use_lts'] = true
    node.default['aptstd']['use_updates'] = false
  else
    mirror_backports = mirror_main
  end
  distribution_updates = codename + "-updates"
end

template "/etc/apt/sources.list" do
  source "sources.list.erb"
  mode "0644"
  variables({
    :use_src => node['aptstd']['use_src'],
    :mirror => mirror_main,
    :distribution => codename,
    :components => node['aptstd']['components'].join(' ')
  })
  notifies :run, resources(:execute => "apt-get update"), :immediately
end

if node['aptstd']['use_security']
  apt_repository "debian-security" do
    uri mirror_security
    distribution "#{codename}/updates"
    components node['aptstd']['components']
    if node['aptstd']['use_src']
      deb_src true
    end
  end
end

if node['aptstd']['use_updates']
  apt_repository "debian-updates" do
    uri mirror_updates
    distribution distribution_updates
    components node['aptstd']['components']
    if node['aptstd']['use_src']
      deb_src true
    end
  end
end

if node['aptstd']['use_lts'] and platform_version_major == 6
  apt_repository "debian-lts" do
    uri mirror_lts
    distribution distribution_lts
    components node['aptstd']['components']
    if node['aptstd']['use_src']
      deb_src true
    end
  end
end

if node['aptstd']['use_backports']
  apt_repository "debian-backports" do
    uri mirror_backports
    distribution "#{codename}-backports"
    components node['aptstd']['components']
    if node['aptstd']['use_src']
      deb_src true
    end
  end
end