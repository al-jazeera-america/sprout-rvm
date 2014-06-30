rubies       = node['sprout']['rvm']['rubies']
default_ruby = node['sprout']['rvm']['default_ruby']

::RVM_HOME = "#{node['sprout']['home']}/.rvm"
::RVM_COMMAND = "#{::RVM_HOME}/bin/rvm"

# package 'ruby-build'

sprout_base_bash_it_enable_feature 'plugins/rvm'

run_unless_marker_file_exists("rvm") do
  recursive_directories [RVM_HOME, 'src', 'rvm'] do
    owner node['current_user']
    recursive true
  end

  [
    "\\curl -sSL https://get.rvm.io | bash -s stable --ruby",
    "#{RVM_COMMAND} --version | grep Wayne"
  ].each do |rvm_cmd|
    execute rvm_cmd do
      user node['current_user']
      environment( { 'HOME' => node['sprout']['home'] } )
    end
  end
  
  template "#{node['sprout']['home']}/.rvmrc" do
    source 'rvmrc.erb'
    owner node['current_user']
    group node['etc']['passwd'][node['current_user']]['gid']
    variables ( { :env_vars => node["rvm"]["rvmrc"]["env_vars"] } )
  end

  # Do we want these?
  # %w{readline autoconf openssl zlib}.each do |rvm_pkg|
  #   execute "install rvm pkg: #{rvm_pkg}" do
  #     command "#{::RVM_COMMAND} pkg install --verify-downloads 1 #{rvm_pkg}"
  #     user node['current_user']
  #   end
  # end
end

rubies.each do |version, options|
  ruby_install version do
    options options
  end
end

# execute "making #{node["rvm"]["default_ruby"]} with rvm the default" do
#   not_if { node["sprout"]["rvm"]["default_ruby"].nil? }
#   command "#{::RVM_COMMAND} alias create default #{node["sprout"]["rvm"]["default_ruby"]}"
#   user node['current_user']
# end
