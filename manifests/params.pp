# @!visibility private
class certbot::params {

  case $::facts['os']['family'] {
    'RedHat': {
      $conf_dir        = '/etc/letsencrypt'
      $package_name    = 'certbot'
      $plugin_packages = {
        'apache'       => 'python2-certbot-apache',
        'cloudflare'   => 'python2-certbot-dns-cloudflare',
        'cloudxns'     => 'python2-certbot-dns-cloudxns',
        'digitalocean' => 'python2-certbot-dns-digitalocean',
        'dnsimple'     => 'python2-certbot-dns-dnsimple',
        'dnsmadeeasy'  => 'python2-certbot-dns-dnsmadeeasy',
        'gehirn'       => 'python2-certbot-dns-gehirn',
        'google'       => 'python2-certbot-dns-google',
        'linode'       => 'python2-certbot-dns-linode',
        'luadns'       => 'python2-certbot-dns-luadns',
        'nsone'        => 'python2-certbot-dns-nsone',
        'ovh'          => 'python2-certbot-dns-ovh',
        'dns-rfc2136'  => 'python2-certbot-dns-rfc2136',
        'route53'      => 'python2-certbot-dns-route53',
        'sakuracloud'  => 'python2-certbot-dns-sakuracloud',
        'nginx'        => 'python2-certbot-nginx',
      }
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::facts['os']['family']} based system.")
    }
  }
}
