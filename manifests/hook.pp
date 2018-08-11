# @!visibility private
define certbot::hook (
  Certbot::Type::Hook $type,
  String              $filename,
  Optional[String]    $content  = undef,
  Optional[String]    $source   = undef,
) {

  assert_private()

  if ! defined(Class['::certbot']) {
    fail('You must include the certbot base class before using any certbot defined resources')
  }

  unless $content or $source {
    fail('At least one of $content or $source must be specified.')
  }

  if $content and $source {
    fail('Only one of $content or $source should be specified.')
  }

  file { "${::certbot::conf_dir}/renewal-hooks/${type}/${filename}":
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0755',
    content => $content,
    source  => $source,
  }
}
