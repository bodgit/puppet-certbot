# Manage deploy hook scripts.
#
# @example Define a deploy hook
#   class { '::certbot':
#     email => 'user@example.com',
#   }
#
#   ::certbot::hook::deploy { 'script':
#     content => @(EOS/L),
#       #!/bin/sh
#       for domain in $RENEWED_DOMAINS; do
#         ...
#       done
#       | EOS
#   }
#
# @param filename
# @param content
# @param source
#
# @see puppet_classes::certbot ::certbot
# @see puppet_defined_types::certbot::hook::post ::certbot::hook::post
# @see puppet_defined_types::certbot::hook::pre ::certbot::hook::pre
#
# @since 1.0.0
define certbot::hook::deploy (
  String           $filename = $title,
  Optional[String] $content  = undef,
  Optional[String] $source   = undef,
) {

  if ! defined(Class['::certbot']) {
    fail('You must include the certbot base class before using any certbot defined resources')
  }

  ::certbot::hook { "deploy ${filename}":
    type     => 'deploy',
    filename => $filename,
    content  => $content,
    source   => $source,
  }
}
