#
# Cookbook Name:: aptstd
# Attributes:: aptstd
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

default['aptstd']['mirror_main'] = "http://cdn.debian.net/debian"
default['aptstd']['mirror_archive'] = "http://archive.debian.org/debian"
default['aptstd']['mirror_security'] = "http://security.debian.org/"
default['aptstd']['components'] = ['main', 'contrib', 'non-free']
default['aptstd']['use_security'] = true
default['aptstd']['use_updates'] = true
default['aptstd']['use_src'] = true
