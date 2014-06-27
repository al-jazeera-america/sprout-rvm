define :ruby_install do
  ruby_version = params[:version] || params[:name]
  options = params[:options] || {}

  include_recipe "sprout-rvm"

  rvm_cmd = node['sprout']['rvm']['command']
  install_cmd = "#{rvm_cmd} install #{ruby_version} #{options[:command_line_options]}"

  execute "installing #{ruby_version} with rvm: #{install_cmd}" do
    command install_cmd
    user params[:user] || node['current_user']
    only_if params[:only_if] if params[:only_if]
    not_if params[:not_if] || "#{rvm_cmd} list | grep #{ruby_version}"
    env options[:env]
  end

  execute "check #{ruby_version}" do
    command "#{rvm_cmd} list | grep #{ruby_version}"
    user params[:user] || node['current_user']
  end
end
