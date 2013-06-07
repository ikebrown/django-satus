class requirements_file ($django_version){

    # create a requirements directory      
    file { "/vagrant/project/requirements":
        ensure => "directory",
    }

    # BASE requirements 
    exec { 'creates requirements file':
        creates => "/vagrant/project/requirements/base.txt",
        command => "touch /vagrant/project/requirements/base.txt ",
        path    => "/bin",
    }

    exec { 'django version':
        command => "echo Django==$django_version >> /vagrant/project/requirements/base.txt",
        path    => "/bin",
        subscribe   => Exec['creates requirements file'],
        refreshonly => true,
    }

    exec { 'Python adapter for PostgreSQL : psycopg2':
        command => "echo psycopg2 >> /vagrant/project/requirements/base.txt",
        path    => "/bin",
        subscribe   => Exec['creates requirements file'],
        refreshonly => true,
    }
}