# == Class: boris::params
#
# The parameters for the boris class and corresponding definitions
#
# === Authors
#
# Thomas Ploch <profiploch@gmail.com>
# Andrew Johnstone <andrew@ajohnstone.com>
#
# === Copyright
#
# Copyright 2013 Thomas Ploch
#
class boris::params {
  case $::osfamily {
    'Debian': {
      $target_dir      = '/usr/local/bin'
      $boris_file      = 'boris'
      $download_method = 'wget'
      $logoutput       = false
      $tmp_path        = '/tmp'
      $php_package     = 'php5-cli'
    }
    'RedHat': {
      $target_dir      = '/usr/local/bin'
      $boris_file      = 'boris'
      $download_method = 'wget'
      $logoutput       = false
      $tmp_path        = '/tmp'
      $php_package     = 'php-cli'
    }
    default: {
      fail("Unsupported platform: ${::osfamily}")
    }
  }
}
