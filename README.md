# Puppet module to install Boris

## Description

Install Boris - from https://github.com/d11wtq/boris with puppet-boris module

## Installation

#### Installation via puppet forge (RECOMMENDED, automatically installs all dependencies)

    puppet module install --target-dir=/your/path/to/modules simpleweb-boris

#### Installation via git submodule

    git submodule add git://github.com/simpleweb/puppet-boris.git modules/boris

## Dependencies

This module requires the module ```puppetlabs/git```

## Usage

#### Simple include just installs with defaults

In your manifest.pp:

    include boris

#### Configuring the boris install

In your manifest.pp:

```puppet
    # configure boris install - not nessecary, comes with sane defaults
    class { 'boris':
        target_dir      => '/usr/local/bin',
        boris_file   => 'boris', # could also be 'boris.phar'
        download_method => 'curl', # or 'wget'
    }
```

## Contributors

- Steve Lacey ([@stevelacey](https://github.com/stevelacey))

Special thanks to Thomas Ploch ([@tPl0ch](https://github.com/tPl0ch)), for the excellent [puppet-composer](https://github.com/tPl0ch/puppet-composer) module, which I based this on.
