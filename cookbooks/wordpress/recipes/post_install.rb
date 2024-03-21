# Variables de entorno
if node != nil && node['config'] != nil
  proxy_ip = node['config']['proxy_ip'] || "192.168.56.2"
  wp_title = node['config']['wp_title'] || "Trabajo Final, presentado por Elmer J. Cruz Arocutipa"
  wp_email = node['config']['wp_email'] || "elmerjc@gmail.com"
  wp_user = node['config']['wp_user'] || "elmerjc"
  wp_password = node['config']['wp_password'] || "Epnewman123@"
else
  proxy_ip = "127.0.0.1"
  wp_title = "EP Newman"
  wp_email = "webmaster@wordpress.org"
  wp_user = "admin"
  wp_password = "Password123@"
end

# Instalar WP CLI
remote_file '/tmp/wp' do
  source 'https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Mover WP CLI a /bin
execute 'Move WP CLI' do
  command 'mv /tmp/wp /bin/wp'
  not_if { ::File.exist?('/bin/wp') }
end

# Hacer WP CLI ejecutable
file '/bin/wp' do
  mode '0755'
end

# Instalar Wordpress y configurar
execute 'Finish Wordpress installation' do
  command "sudo -u vagrant -i -- wp core install --path=/opt/wordpress/ --locale=es_ES --url='#{proxy_ip}' --title='#{wp_title}' --admin_user='#{wp_user}' --admin_password='#{wp_password}' --admin_email='#{wp_email}'"
  not_if 'wp core is-installed', environment: { 'PATH' => '/bin:/usr/bin:/usr/local/bin' }
end