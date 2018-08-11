# @!visibility private
class certbot::config {

  $conf_dir = $::certbot::conf_dir

  file { $conf_dir:
    ensure => directory,
    owner  => 0,
    group  => 0,
    mode   => '0644',
  }

  file { "${conf_dir}/accounts":
    ensure => directory,
    owner  => 0,
    group  => 0,
    mode   => '0644',
  }

  file { "${conf_dir}/renewal-hooks":
    ensure => directory,
    owner  => 0,
    group  => 0,
    mode   => '0644',
  }

  ['pre', 'post', 'deploy'].each |Certbot::Type::Hook $x| {
    file { "${conf_dir}/renewal-hooks/${x}":
      ensure       => directory,
      owner        => 0,
      group        => 0,
      mode         => '0644',
      purge        => true,
      recurse      => true,
      recurselimit => 1,
    }
  }

  # Smells a bit hacky
  exec { "certbot register --agree-tos -m ${::certbot::email}":
    path    => $::path,
    unless  => "find ${conf_dir}/accounts -name regr.json -print0 | grep -qz .",
    require => File["${conf_dir}/accounts"],
  }

  case $::service_provider {
    'systemd': {
      service { 'certbot-renew.timer':
        enable => true,
      }
    }
    default: {
      # noop
    }
  }

  $::certbot::hooks.each |$type, $resources| {
    $resources.each |$resource, $attributes| {
      Resource["::${module_name}::hook::${type}"] {
        $resource: * => $attributes;
      }
    }
  }
}
