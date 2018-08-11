# Request and renew a certificate using DNS and RFC 2136 updates.
#
# @example Example usage
#   class { '::certbot':
#     email => 'user@example.com',
#   }
#
#   ::certbot::cert::dns::rfc2136 { 'example':
#     algorithm   => 'HMAC-SHA512',
#     credentials => '/path/to/secrets.ini',
#     domains     => [
#       'example.com',
#       'www.example.com',
#     ],
#     key         => 'tsig.example.com.',
#     secret      => 'deadbeef==',
#     server      => '192.0.2.1',
#   }
#
# @param algorithm
# @param credentials
# @param domains
# @param key
# @param secret
# @param server
# @param ensure
#
# @see puppet_classes::certbot ::certbot
#
# @since 1.0.0
define certbot::cert::dns::rfc2136 (
  Enum['HMAC-MD5', 'HMAC-SHA1', 'HMAC-SHA224', 'HMAC-SHA256', 'HMAC-SHA384', 'HMAC-SHA512'] $algorithm,
  Stdlib::Absolutepath                                                                      $credentials,
  Array[Bodgitlib::Domain, 1]                                                               $domains,
  Bodgitlib::Zone::NonRoot                                                                  $key,
  String                                                                                    $secret,
  Bodgitlib::Host                                                                           $server,
  Enum['present', 'absent']                                                                 $ensure      = 'present',
) {

  if ! defined(Class['::certbot']) {
    fail('You must include the certbot base class before using any certbot defined resources')
  }

  file { $credentials:
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0600',
    content => template("${module_name}/dns-rfc2136.ini.erb"),
  }

  $flags = ['--dns-rfc2136', '--dns-rfc2136-credentials', $credentials] + $domains.map |String $x| { "-d ${x}" }

  ::certbot::cert { $domains[0]:
    ensure  => $ensure,
    flags   => $flags,
    plugin  => 'dns-rfc2136',
    require => File[$credentials],
  }
}
