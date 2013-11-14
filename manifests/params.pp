# Class: varnish::params
#
# Defines all the variables used in the module.
#
class varnish::params {

  $package_name = $::osfamily ? {
    default => 'varnish',
  }

  $service = $::operatingsystem ? {
    default => 'varnish',
  }

  $process_args = $::operatingsystem ? {
    default => '',
  }

  $process_user = $::operatingsystem ? {
    default => 'varnish',
  }

  $config_file_path = $::osfamily ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/default/varnish',
    default => '/etc/sysconfig/varnish',
  }

  $config_file_mode = $::osfamily ? {
    default => '0644',
  }

  $config_file_owner = $::osfamily ? {
    default => 'root',
  }

  $config_file_group = $::osfamily ? {
    default => 'root',
  }

  $config_dir_path = $::osfamily ? {
    default => '/etc/varnish',
  }

  $log_dir = $::operatingsystem ? {
    default => '/var/log/varnish',
  }

  $log_file = $::operatingsystem ? {
    default => '/var/log/varnish/varnish.log',
  }

  case $::osfamily {
    'Debian','RedHat','Amazon': { }
    default: {
      fail("${::operatingsystem} not supported. Review params.pp for extending support.")
    }
  }

  $backendhost = '127.0.0.1'
  $backendport = '8008'
  $debian_start = true
  $instance = 'default'
  $nfiles = '131072'
  $memlock = '82000'
  $nprocs = 'unlimited'
  $reload_vcl = '1'
  $vcl_conf = '/etc/varnish/default.vcl'
  $listen_address = ''
  $port = '6081'
  $admin_listen_address = '127.0.0.1'
  $admin_listen_port = '6082'
  $min_threads = '1'
  $max_threads = '1000'
  $thread_timeout = '120'
  $secret = ''
  $secret_file = '/etc/varnish/secret'
  $ttl = '120'
  $storage_size = '1G'
  $storage_file = '/var/lib/varnish/$INSTANCE/varnish_storage.bin'
  $vcl_template = ''
  $vcl_source = ''
  $vcl_file = '/etc/varnish/default.vcl'

  $protocol = 'tcp'

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = ''
  $options = ''
  $service_autorestart = true
  $version = 'present'
  $absent = false
  $disable = false
  $disableboot = false

}
