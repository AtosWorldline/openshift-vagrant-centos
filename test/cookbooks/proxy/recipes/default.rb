if node['proxy']['http_proxy']
  template "/etc/profile.d/proxy.sh" do
    source "systemproxy.erb"
    owner "root"
    group "root"
    mode 0755
  end

  script "proxy yum" do
    interpreter "bash"
    user  "root"
	not_if "grep proxy= /etc/yum.conf"
    code <<-EOF
    echo "proxy=#{node['proxy']['http_proxy']}" >> /etc/yum.conf
    EOF
  end
end