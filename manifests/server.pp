class shinken::server {

	$pkgdep = [ 'nagios-plugins', 'python-setuptools', 'python-pip', 'python-pycurl', 'python-cherrypy3' ]

	Package { $pkgdep: ensure => present }

	User { 'shinken':
		ensure 		=> present,
		shell 		=> '/bin/bash',
		home 		=> '/home/shinken',
		managehome	=> true
	}

    python::pip { 'shinken':
    	pkgname		=> 'shinken',
	    ensure		=> '2.4.3',
        require		=>[ Package[$pkgdep],User["shinken"] ],
		# needed for bug https://github.com/naparuba/shinken/issues/1902
		install_args	=> '--install-option="--prefix=/" ',
	}
	
	# Same thing, workaround for issue 1902
    file_line { 'shinken_pythonpath':
        ensure => present,
        path => '/home/shinken/.bashrc',
        line => 'PYTHONPATH=$PYTHONPATH:/lib/python2.7/site-packages/shinken',
        append_on_no_match => true,
    }


    Exec { "shinken_init":
    	command		=> '/usr/bin/shinken --init',
        user 		=> 'shinken',
        creates 	=> '/home/shinken/.shinken.ini',
        require 	=> Python::Pip['shinken']
	}

    Exec { "shinken_module_webui":
    	command 	=> '/usr/bin/shinken install webui',
        user 		=> 'shinken',
        creates 	=> '/var/lib/shinken/modules/webui',
        require 	=> Exec["shinken_init"]
    }

    Exec { "shinken_module_authcfgpassword":
        command     => '/usr/bin/shinken install auth-cfg-password',
        user        => 'shinken',
        creates     => '/var/lib/shinken/modules/webui',
        require     => Exec["shinken_init"]
    }



	Service { "shinken":
		ensure	=> running,
	}








}
