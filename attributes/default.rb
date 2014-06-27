node.default['sprout']['rvm'] = {
  'home' => "#{node['sprout']['home']}/.rvm",
  'command' => '/usr/local/bin/rvm',
  'rubies' => {
    '2.0.0-p481' => {},
    '2.1.2-p95' => {},
  },
  'default_ruby' => '2.0.0-p481'
}
node.default['rvm']['rvmrc'] = {
  'env_vars' => {
    :rvm_silence_path_mismatch_check_flag => 1,
    :rvm_user_install_flag => 1,
    :rvm_prefix => "#{node['sprout']['home']}",
    :rvm_path => '${rvm_prefix}/.rvm'
  }
}
node.default['versions']['rvm'] = 'latest'

