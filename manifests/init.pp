#
# = Class: varnish
#
# This class installs and manages varnish
#
#
# == Parameters
#
# Refer to https://github.com/stdmod for official documentation
# on the stdmod parameters used
#
class varnish (

  $ensure                    = 'present',
  $version                   = undef,

  $package_name              = $varnish::params::package_name,

  $config_file_path          = $varnish::params::config_file_path,
  $config_file_replace       = $varnish::params::config_file_replace,
  $config_file_require       = 'Package[varnish]',
  $config_file_source        = undef,
  $config_file_template      = undef,
  $config_file_content       = undef,
  $config_file_options_hash  = undef,

  $config_dir_path           = $varnish::params::config_dir_path,
  $config_dir_source         = undef,
  $config_dir_purge          = false,
  $config_dir_recurse        = true,

  $dependency_class          = undef,

  $scope_hash_filter         = '(uptime.*|timestamp)',

  ) inherits varnish::params {


  # Input parameters validation
  validate_re($ensure, ['present','absent'], 'Valid values: present, absent.')
  validate_bool($config_dir_recurse)
  validate_bool($config_dir_purge)
  if $config_file_options_hash { validate_hash($config_file_options_hash) }

  $config_file_owner          = $varnish::params::config_file_owner
  $config_file_group          = $varnish::params::config_file_group
  $config_file_mode           = $varnish::params::config_file_mode

  if $config_file_content {
    $manage_config_file_content = $config_file_content
  } else {
    if $config_file_template {
      $manage_config_file_content = template($config_file_template)
    } else {
      $manage_config_file_content = undef
    }
  }

  if $config_file_notify {
    $manage_config_file_notify = $config_file_notify
  } else {
    $manage_config_file_notify = undef
  }

  if $version {
    $manage_package_ensure = $version
  } else {
    $manage_package_ensure = $ensure
  }

  if $ensure == 'absent' {
    $config_dir_ensure = absent
    $config_file_ensure = absent
  } else {
    $config_dir_ensure = directory
    $config_file_ensure = present
  }


  # Resources managed

  if $varnish::package_name {
    package { $varnish::package_name:
      ensure   => $varnish::manage_package_ensure,
    }
  }

  if $varnish::config_file_path {
    file { 'varnish.conf':
      ensure  => $varnish::config_file_ensure,
      path    => $varnish::config_file_path,
      mode    => $varnish::config_file_mode,
      owner   => $varnish::config_file_owner,
      group   => $varnish::config_file_group,
      source  => $varnish::config_file_source,
      content => $varnish::manage_config_file_content,
      require => $varnish::config_file_require,
    }
  }

  if $varnish::config_dir_source {
    file { 'varnish.dir':
      ensure  => $varnish::config_dir_ensure,
      path    => $varnish::config_dir_path,
      source  => $varnish::config_dir_source,
      recurse => $varnish::config_dir_recurse,
      purge   => $varnish::config_dir_purge,
      force   => $varnish::config_dir_purge,
      require => $varnish::config_file_require,
    }
  }


  # Extra classes

  if $varnish::dependency_class {
    include $varnish::dependency_class
  }

}

