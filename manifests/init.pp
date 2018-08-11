# Manage Certbot.
#
# @example Declaring the class
#   class { '::certbot':
#     email => 'user@example.com',
#   }
#
# @param email
# @param conf_dir
# @param package_name
# @param plugin_packages
# @param hooks
#
# @see puppet_defined_types::certbot::cert::webroot ::certbot::cert::webroot
# @see puppet_defined_types::certbot::cert::dns::rfc2136 ::certbot::cert::dns::rfc2136
# @see puppet_defined_types::certbot::hook::deploy ::certbot::hook::deploy
# @see puppet_defined_types::certbot::hook::post ::certbot::hook::post
# @see puppet_defined_types::certbot::hook::pre ::certbot::hook::pre
#
# @since 1.0.0
class certbot (
  String                                                     $email,
  Stdlib::Absolutepath                                       $conf_dir        = $::certbot::params::conf_dir,
  String                                                     $package_name    = $::certbot::params::package_name,
  Hash[Certbot::Type::Plugin, String]                        $plugin_packages = $::certbot::params::plugin_packages,
  Hash[Certbot::Type::Hook, Hash[String, Hash[String, Any]]] $hooks           = {},
) inherits ::certbot::params {

  contain ::certbot::install
  contain ::certbot::config

  Class['::certbot::install'] -> Class['::certbot::config']
}
