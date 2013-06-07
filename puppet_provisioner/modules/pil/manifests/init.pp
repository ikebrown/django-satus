class pil{

    #Installs python-imaging for PIL to work correctly
    package { 'python-imaging':
      ensure => "installed"
    }

    #symbolic link to libjpeg
    file {'/usr/lib/libjpeg.so':
      ensure => link,
      target => '/usr/lib/`uname -i`-linux-gnu/libjpeg.so',
      require => Package['python-imaging'],
    }

    #symbolic link to libz
    file {'/usr/lib/libz.so':
      ensure => link,
      target => '/usr/lib/`uname -i`-linux-gnu/libz.so',
      require => Package['python-imaging'],
    }

}

