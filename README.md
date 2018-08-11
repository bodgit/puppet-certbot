# certbot

Tested with Travis CI

[![Build Status](https://travis-ci.com/bodgit/puppet-certbot.svg?branch=master)](https://travis-ci.com/bodgit/puppet-certbot)
[![Coverage Status](https://coveralls.io/repos/bodgit/puppet-certbot/badge.svg?branch=master&service=github)](https://coveralls.io/github/bodgit/puppet-certbot?branch=master)
[![Puppet Forge](http://img.shields.io/puppetforge/v/bodgit/certbot.svg)](https://forge.puppetlabs.com/bodgit/certbot)

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with certbot](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with certbot](#beginning-with-certbot)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

This module installs and manages Certbot which is used to request certificates
from Let's Encrypt.

RHEL/CentOS is supported using Puppet 4.6.0 or later.

## Setup

### Setup Requirements

On RHEL/CentOS platforms you will need to have access to the EPEL repository by
using [stahnma/epel](https://forge.puppet.com/stahnma/epel) or by other means.

### Beginning with certbot

You will need to instantiate the class and create at least one certificate for
the module to be useful:

```puppet
class { '::certbot':
  email => 'user@example.com',
}

::certbot::cert::webroot { 'example':
  domains => {
    '/var/www/html' => [
      'example.com',
      'www.example.com',
    ],
  },
}
```

## Usage

If you want to have a post-renew hook script to restart the webserver:

```puppet
class { '::certbot':
  email => 'user@example.com',
}

::certbot::cert::webroot { 'example':
  domains => {
    '/var/www/html' => [
      'example.com',
      'www.example.com',
    ],
  },
}

::certbot::hook::deploy { 'restart':
  content => @(EOS/L),
    #!/bin/sh
    service nginx restart
    | EOS
}
```

You can also copy the certificates and get Puppet to restart the service when
they change:

```puppet
class { '::certbot':
  email => 'user@example.com',
}

::certbot::cert::webroot { 'example':
  domains => {
    '/var/www/html' => [
      'example.com',
      'www.example.com',
    ],
  },
}

file { '/etc/pki/tls/certs/example.crt':
  ensure => file,
  owner  => 0,
  group  => 0,
  mode   => '0644',
  source => '/etc/letsencrypt/live/example.com/cert.pem',
  notify => Service['httpd'],
}

file { '/etc/pki/tls/private/example.key':
  ensure => file,
  owner  => 0,
  group  => 0,
  mode   => '0600',
  source => '/etc/letsencrypt/live/example.com/privkey.pem',
  notify => Service['httpd'],
}
```

This relies on Puppet running periodically.

## Reference

The reference documentation is generated with
[puppet-strings](https://github.com/puppetlabs/puppet-strings) and the latest
version of the documentation is hosted at
[https://bodgit.github.io/puppet-certbot/](https://bodgit.github.io/puppet-certbot/).

## Limitations

This module has been built on and tested against Puppet 4.6.0 and higher.

The module has been tested on:

* CentOS/Red Hat Enterprise Linux 7

Currently only the `webroot` and `dns-rfc2136` authenticators are implemented.
The other `dns-01` plugins should be straightforward to add; I personally
don't have a use for them. I also don't feel like the `apache` and `nginx`
authenticators are a good fit as they directly edit the existing configuration
which is something that you are likely already managing with Puppet.

The module doesn't currently handle the scenario of changing the domains
associated with a certificate. To do this will likely require creating a
custom resource type that can parse the existing domains associated with a
certificate and trigger an immediate renew should they be changed.

## Development

The module has both [rspec-puppet](http://rspec-puppet.com) and
[beaker-rspec](https://github.com/puppetlabs/beaker-rspec) tests. Run them
with:

```
$ bundle exec rake test
$ PUPPET_INSTALL_TYPE=agent PUPPET_INSTALL_VERSION=x.y.z bundle exec rake beaker:<nodeset>
```

Please log issues or pull requests at
[github](https://github.com/bodgit/puppet-certbot).
