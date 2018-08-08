class shinken::server {

	$pkgdep = [ 'python-setuptools', 'python-pip', 'python-pycurl', 'python-cherrypy3' ]

	Package { $pkgdep: ensure => present }

	User { 'shinken':
		ensure 		=> present,
		shell 		=> '/bin/bash',
		home 		=> '/home/shinken',
		managehome	=> true
	}

    python::pip { 'shinken':
    	pkgname       => 'shinken',
	    ensure        => '2.4.3',
        require =>[ Package[$pkgdep],User["shinken"] ]
	}





}
