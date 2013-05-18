$project_name = 'your project name'
$django_version = '1.5'

# Password for postgres user 
$postgres_password = 'projectdb'

$database_name = 'your database name'

# Set password for your database
$password = '123'


exec { 'apt-get update':
  command => '/usr/bin/apt-get update',
}

# Sets project_name
exec { 'rename projec_name':
  command => "mv /vagrant/project/project_name /vagrant/project/${project_name}",
  creates => "/vagrant/project/${project_name}",
  path    => '/bin',
}

#Adds what django version to install to requirement file
exec { 'django version':
  command => "echo Django==${django_version} >> /vagrant/project/requirements.txt",
  path    => '/bin',
}

# Installs Python development tools
$python_dev_tools = ["python-dev", "python-pip"]
package { $python_dev_tools:
  ensure => "installed",
}

# Installs nano editor 
package { 'nano':
  ensure => "installed",
}

#Installs vim editor
package { 'vim':
  ensure => "installed"
}

#Installs git 
package { 'git':
  ensure => "installed"
}

# Installs postgresql and required dependencies packages 
include stdlib
include firewall
include apt
include concat::setup
  
class { 'postgresql':
  version => '9.1',
  charset => 'UTF8',
  require => [Class['stdlib'], Class['firewall'], Class['apt'], Class['concat::setup']],
}

class { 'postgresql::server':
  config_hash => { 
    'listen_adresses'   => '*',
    'postgres_password' => postgresql_password('postgres', "${postgres_password}"),
    },
}

class { 'postgresql::client':
  require  => [Class['postgresql'], Class['postgresql::server']],
} 

class { 'postgresql::contrib':
  require  => [Class['postgresql'], Class['postgresql::server']],
} 

# Creates database and grant all permission to user
postgresql::db{ "${database_name}":
  user     => 'vagrant',
  password => postgresql_password('vagrant', "${password}"),
  require  => [Class['postgresql'], Class['postgresql::server']],
}


Exec['apt-get update'] -> Class['postgresql'] -> Class['postgresql::server']