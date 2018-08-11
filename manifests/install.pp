# @!visibility private
class certbot::install {

  package { $::certbot::package_name:
    ensure => present,
  }
}
