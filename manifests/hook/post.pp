# Manage post hook scripts.
#
# @example Define a post hook
#   class { '::certbot':
#     email => 'user@example.com',
#   }
#
#   ::certbot::hook::post { 'script':
#     content => @(EOS/L),
#       #!/bin/sh
#       service nginx start
#       | EOS
#   }
#
# @param filename
# @param content
# @param source
#
# @see puppet_classes::certbot ::certbot
# @see puppet_defined_types::certbot::hook::deploy ::certbot::hook::deploy
# @see puppet_defined_types::certbot::hook::pre ::certbot::hook::pre
#
# @since 1.0.0
define certbot::hook::post (
  String           $filename = $title,
  Optional[String] $content  = undef,
  Optional[String] $source   = undef,
) {

  if ! defined(Class['::certbot']) {
    fail('You must include the certbot base class before using any certbot defined resources')
  }

  ::certbot::hook { "post ${filename}":
    type     => 'post',
    filename => $filename,
    content  => $content,
    source   => $source,
  }
}
