# Manage pre hook scripts.
#
# @example Define a pre hook
#   class { '::certbot':
#     email => 'user@example.com',
#   }
#
#   ::certbot::hook::pre { 'script':
#     content => @(EOS/L),
#       #!/bin/sh
#       service nginx stop
#       | EOS
#   }
#
# @param filename
# @param content
# @param source
#
# @see puppet_classes::certbot ::certbot
# @see puppet_defined_types::certbot::hook::deploy ::certbot::hook::deploy
# @see puppet_defined_types::certbot::hook::post ::certbot::hook::post
#
# @since 1.0.0
define certbot::hook::pre (
  String           $filename = $title,
  Optional[String] $content  = undef,
  Optional[String] $source   = undef,
) {

  if ! defined(Class['::certbot']) {
    fail('You must include the certbot base class before using any certbot defined resources')
  }

  ::certbot::hook { "pre ${filename}":
    type     => 'pre',
    filename => $filename,
    content  => $content,
    source   => $source,
  }
}
