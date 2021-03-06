class { '::apache':
  default_vhost  => false,
  service_manage => false,
  use_systemd    => false,
}

apache::vhost { 'localhost':
  port    => '80',
  docroot => '/var/www/html',
}

file { '/var/www/html/index.html':
  ensure  => present,
  content => 'Apache running on Docker; built by Puppet!',
}

class { mysql::server:
  package_name => 'mariadb-server'
}
class { mysql::client:
    package_name => 'mariadb-client'
}