#
# = Define: varnish::conf
#
# With this define you can manage any varnish configuration file
#
# == Parameters
#
# [*template*]
#   String. Optional. Default: undef. Alternative to: source, content.
#   Sets the module path of a custom template to use as content of
#   the config file
#   When defined, config file has: content => content($template),
#   Example: template => 'site/varnish/my.conf.erb',
#
# [*content*]
#   String. Optional. Default: undef. Alternative to: template, source.
#   Sets directly the value of the file's content parameter
#   When defined, config file has: content => $content,
#   Example: content => "# File manage by Puppet \n",
#
# [*source*]
#   String. Optional. Default: undef. Alternative to: template, content.
#   Sets the value of the file's source parameter
#   When defined, config file has: source => $source,
#   Example: source => 'puppet:///site/varnish/my.conf',
#
# [*ensure*]
#   String. Default: present
#   Manages config file presence. Possible values:
#   * 'present' - Create and manages the file.
#   * 'absent' - Remove the file.
#
# [*path*]
#   String. Optional. Default: $config_dir/$title
#   The path of the created config file. If not defined a file
#   name like the  the name of the title a custom template to use as content of configfile
#   If defined, configfile file has: content => content("$template")
#
# [*mode*] [*owner*] [*group*] [*notify*] [*require*] [*replace*]
#   String. Optional. Default: undef
#   All these parameters map directly to the created file attributes.
#   If not defined the module's defaults are used.
#   If defined, config file file has, for example: mode => $mode
#
# [*options_hash*]
#   Hash. Default undef. Needs: 'template'.
#   An hash of custom options to be used in templates to manage any key pairs of
#   arbitrary settings.
#
define varnish::conf (

  $source       = undef,
  $template     = undef,
  $content      = undef,

  $path         = undef,
  $mode         = undef,
  $owner        = undef,
  $group        = undef,
  $notify       = undef,
  $require      = undef,
  $replace      = undef,

  $options_hash = undef,

  $ensure       = present ) {

  validate_re($ensure, ['present','absent'], 'Valid values are: present, absent. WARNING: If set to absent the conf file is removed.')

  include varnish

  $manage_path = $path ? {
    undef   => "${varnish::config_dir_path}/${name}",
    default => $path,
  }

  $manage_content = $content ? {
    undef   => $template ? {
      undef => undef,
      default => template($template),
    },
    default => $content,
  }

  $manage_mode = $mode ? {
    undef   => $varnish::config_file_mode,
    default => $mode,
  }

  $manage_owner = $owner ? {
    undef   => $varnish::config_file_owner,
    default => $owner,
  }

  $manage_group = $group ? {
    undef   => $varnish::config_file_group,
    default => $group,
  }

  $manage_require = $require ? {
    undef   => $varnish::config_file_require,
    default => $require,
  }

  $manage_replace = $replace ? {
    undef   => $varnish::config_file_replace,
    default => $replace,
  }

  file { "varnish_conf_${name}":
    ensure  => $ensure,
    source  => $source,
    content => $manage_content,
    path    => $manage_path,
    mode    => $manage_mode,
    owner   => $manage_owner,
    group   => $manage_group,
    require => $manage_require,
    notify  => $notify,
    replace => $manage_replace,
  }

}

