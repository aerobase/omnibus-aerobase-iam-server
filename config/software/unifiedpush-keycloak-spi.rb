# Copyright:: Copyright (c) 2015.
# License:: Apache License, Version 2.0
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

name "unifiedpush-keycloak-spi"
default_version "master"
skip_transitive_dependency_licensing true

source git: "https://github.com/aerobase/unifiedpush-keycloak-spi.git"

relative_path "unifiedpush-keycloak-spi"
build_dir = "#{project_dir}"
keycloak_services_dir = "#{install_dir}/embedded/apps/keycloak-server/keycloak-overlay/modules/system/layers/keycloak/org/keycloak/keycloak-services/main/keycloak-services.jar"

build do
  command "mvn clean install -DskipTests"

  # Add aerobase service implementaion to keycloak-services
  command "cd #{build_dir}/target/classes/; jar -uf #{install_dir}/embedded/apps/keycloak-server/keycloak-overlay/modules/system/layers/keycloak/org/keycloak/keycloak-services/main/keycloak-services.jar org/keycloak/authentication/authenticators/resetcred/AerobaseResetCredentialEmail.class"

  # extract SPI file
  command "cd #{build_dir}; jar -xvf #{install_dir}/embedded/apps/keycloak-server/keycloak-overlay/modules/system/layers/keycloak/org/keycloak/keycloak-services/main/keycloak-services.jar META-INF/services/org.keycloak.authentication.AuthenticatorFactory"

  # Replace service class
  command "sed -i -e 's/ResetCredentialEmail/AerobaseResetCredentialEmail/g' META-INF/services/org.keycloak.authentication.AuthenticatorFactory"

  # Repack SPI file
  command "cd #{build_dir}; jar -uf #{install_dir}/embedded/apps/keycloak-server/keycloak-overlay/modules/system/layers/keycloak/org/keycloak/keycloak-services/main/keycloak-services.jar META-INF/services/org.keycloak.authentication.AuthenticatorFactory"

end
