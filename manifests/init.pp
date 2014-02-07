# == Class: boris
#
# The parameters for the boris class and corresponding definitions
#
# === Parameters
#
# Document parameters here.
#
# [*target_dir*]
#   The target dir that boris should be installed to.
#   Defaults to ```/usr/local/bin```.
#
# [*boris_file*]
#   The name of the boris binary, which will reside in ```target_dir```.
#
# [*download_method*]
#   Only ```wget``` is supported at present.
#
# [*logoutput*]
#   If the output should be logged. Defaults to FALSE.
#
# [*tmp_path*]
#   Where the boris.phar file should be temporarily put.
#
# [*php_package*]
#   The Package name of tht PHP CLI package.
#
# === Authors
#
# Steve Lacey <steve@simpleweb.co.uk>
#
class boris (
  $target_dir      = $boris::params::target_dir,
  $boris_file      = $boris::params::boris_file,
  $download_method = $boris::params::download_method,
  $logoutput       = $boris::params::logoutput,
  $tmp_path        = $boris::params::tmp_path,
  $php_package     = $boris::params::php_package
) inherits boris::params {

  Exec { path => "/bin:/usr/bin/:/sbin:/usr/sbin:${target_dir}" }

  if defined(Package[$php_package]) == false {
    package { $php_package: ensure => present, }
  }

  # download boris
  if $download_method == 'wget' {

    if defined(Package['wget']) == false {
      package {'wget': ensure => present, }
    }

    exec { 'download_boris':
      command     => 'wget https://github.com/d11wtq/boris/releases/download/v1.0.8/boris.phar -O boris.phar',
      cwd         => $tmp_path,
      require     => [
        Package['wget'],
        Augeas['allow_url_fopen', 'whitelist_phar']
      ],
      creates     => "${tmp_path}/boris.phar",
      logoutput   => $logoutput,
    }
  }
  else {
    fail("The param download_method ${download_method} is not valid. Please set download_method to curl or wget.")
  }

  # check if directory exists
  if defined(File[$target_dir]) == false {
    file { $target_dir:
      ensure => directory,
    }
  }

  # move file to target_dir
  file { "${target_dir}/${boris_file}":
    ensure      => present,
    source      => "${tmp_path}/boris.phar",
    require     => [ Exec['download_boris'], File[$target_dir] ],
    mode        => '0755',
  }

  case $::osfamily {
    'Redhat','Centos': {
      # set /etc/php5/cli/php.ini/suhosin.executor.include.whitelist = phar
      if defined(augeas['whitelist_phar']) == false {
        augeas { 'whitelist_phar':
          context     => '/files/etc/suhosin.ini/suhosin',
          changes     => 'set suhosin.executor.include.whitelist phar',
          require     => Package[$php_package],
        }
      }

      # set /etc/cli/php.ini/PHP/allow_url_fopen = On
      if defined(augeas['allow_url_fopen']) == false {
        augeas { 'allow_url_fopen':
          context     => '/files/etc/php.ini/PHP',
          changes     => 'set allow_url_fopen On',
          require     => Package[$php_package],
        }
      }
    }
   'Debian': {
      # set /etc/php5/cli/php.ini/suhosin.executor.include.whitelist = phar
      if defined(augeas['whitelist_phar']) == false {
        augeas { 'whitelist_phar':
          context     => '/files/etc/php5/conf.d/suhosin.ini/suhosin',
          changes     => 'set suhosin.executor.include.whitelist phar',
          require     => Package[$php_package],
        }
      }

      # set /etc/php5/cli/php.ini/PHP/allow_url_fopen = On
      if defined(augeas['allow_url_fopen']) == false {
        augeas { 'allow_url_fopen':
          context     => '/files/etc/php5/cli/php.ini/PHP',
          changes     => 'set allow_url_fopen On',
          require     => Package[$php_package],
        }
      }
    }
  }
}
