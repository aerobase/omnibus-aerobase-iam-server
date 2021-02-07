#
# Copyright:: Copyright (c) 2013, 2014
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name "aerobase-iam"
maintainer "Yaniv Marom-Nachumi"
homepage "https://github.com/aerobase/omnibus-aerobase-iam-server"

# Defaults to C:/aerobase on Windows
# and /opt/aerobase on all other platforms
install_dir "#{default_root}/aerobase"

build_version IO.read(File.expand_path("../../../VERSION", __FILE__)).strip
build_iteration 1

# In order to prevent unecessary cache expiration,
# package and package version overrides are kept in <project-root>/omnibus_overrides.rb
overrides_path = File.expand_path("../../../omnibus_overrides.rb", __FILE__)
instance_eval(IO.read(overrides_path), overrides_path)

# Creates required build directories
dependency "preparation"

# keycloak-server is the most expensive runtime build, therefore keep it first in order.
dependency "keycloak-server"

exclude "**/.git"
exclude "**/bundler/git"

# Our package scripts are generated from .erb files,
# so we will grab them from an excluded folder
package_scripts_path "#{install_dir}/.package_util/package-scripts"
exclude '.package_util'
exclude 'LICENSE'
exclude 'version-manifest.*'

package_user 'root'
package_group 'root'
