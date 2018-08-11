# Request and renew a certificate using an existing webroot directory.
#
# @example Example usage
#   class { '::certbot':
#     email => 'user@example.com',
#   }
#
#   ::certbot::cert::webroot { 'example':
#     domains => {
#       '/var/www/html' => [
#         'example.com',
#         'www.example.com',
#       ],
#     },
#   }
#
# @param domains
# @param ensure
#
# @see puppet_classes::certbot ::certbot
#
# @since 1.0.0
define certbot::cert::webroot (
  Hash[Stdlib::Absolutepath, Array[Bodgitlib::Domain, 1], 1] $domains,
  Enum['present', 'absent']                                  $ensure  = 'present',
) {

  if ! defined(Class['::certbot']) {
    fail('You must include the certbot base class before using any certbot defined resources')
  }

  $flags = ['--webroot'] + $domains.reduce([]) |Array[String] $memo, Tuple[String, Array[String, 1]] $x| {
    $memo + "-w ${x[0]}" + $x[1].map |String $y| { "-d ${y}" }
  }

  ::certbot::cert { Array($domains)[0][1][0]:
    ensure => $ensure,
    flags  => $flags,
  }
}
