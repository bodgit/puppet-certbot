# @!visibility private
define certbot::cert (
  Array[String, 1]                $flags,
  Bodgitlib::Domain               $domain = $title,
  Enum['present', 'absent']       $ensure = 'present',
  Optional[Certbot::Type::Plugin] $plugin = undef,
) {

  assert_private()

  if ! defined(Class['::certbot']) {
    fail('You must include the certbot base class before using any certbot defined resources')
  }

  case $ensure {
    'present': {
      $command = join(['certbot certonly'] + $flags, ' ')

      exec { $command:
        path    => $::path,
        creates => "${::certbot::conf_dir}/live/${domain}/cert.pem",
      }

      if $plugin and has_key($::certbot::plugin_packages, $plugin) {
        $package = $::certbot::plugin_packages[$plugin]
        ensure_packages([$package])
        Package[$package] -> Exec[$command]
      }

      file { "${::certbot::conf_dir}/live/${domain}":
        ensure  => directory,
        owner   => 0,
        group   => 0,
        mode    => '0644',
        require => Exec[$command],
      }

      file { "${::certbot::conf_dir}/live/${domain}/cert.pem":
        ensure => link,
        owner  => 0,
        group  => 0,
      }

      file { "${::certbot::conf_dir}/live/${domain}/chain.pem":
        ensure => link,
        owner  => 0,
        group  => 0,
      }

      file { "${::certbot::conf_dir}/live/${domain}/fullchain.pem":
        ensure => link,
        owner  => 0,
        group  => 0,
      }

      file { "${::certbot::conf_dir}/live/${domain}/privkey.pem":
        ensure => link,
        owner  => 0,
        group  => 0,
      }
    }
    'absent': {
      exec { "certbot revoke --cert-path ${::certbot::conf_dir}/live/${domain}/cert.pem":
        path   => $::path,
        onlyif => "test -f ${::certbot::conf_dir}/live/${domain}/cert.pem",
        notify => Exec["certbot delete --cert-name ${domain}"],
      }

      exec { "certbot delete --cert-name ${domain}":
        path        => $::path,
        refreshonly => true,
      }
    }
    default: {
      # noop
    }
  }
}
