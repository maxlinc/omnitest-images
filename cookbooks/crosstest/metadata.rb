name              "crosstest"
maintainer        "Max Lincoln"
maintainer_email  "max@devopsy.com"
license           "MIT"
description       "Installs tools required for testing Rackspace SDKS."
version           "0.0.1"

depends 'apt'
depends 'python'
depends 'rbenv'
depends 'golang'
depends 'nodejs'
depends 'php'
depends 'java'
depends 'groovy'
depends 'maven'
depends 'dnsmasq'
depends 'ssh_known_hosts'
depends 'users'
depends 'sudo'
depends 'mono'

recipe "crosstest", "Install common programming langauges and tools"

%w{ ubuntu }.each do |os|
  supports os
end
