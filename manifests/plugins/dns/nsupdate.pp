# Copyright 2013 Mojo Lingo LLC.
# Modifications by Red Hat, Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
class openshift_origin::plugins::dns::nsupdate {
  if $::openshift_origin::bind_key == '' and $::openshift_origin::bind_krb_principal == '' {
    $default_key_size = $::openshift_origin::bind_key_algorithm ? {
      'HMAC-MD5'    => '512',
      'HMAC-SHA1'   => '160',
      'HMAC-SHA224' => '224',
      'HMAC-SHA256' => '256',
      'HMAC-SHA384' => '384',
      'HMAC-SHA512' => '512',
      default       => '128',
    }

    warning "Generate the Key file with '/usr/sbin/dnssec-keygen -a ${::openshift_origin::bind_key_algorithm} -b ${default_key_size} -n USER -r /dev/urandom -K /var/named ${::openshift_origin::domain}'"
    warning "Use the last field in the generated key file /var/named/K${openshift_origin::domain}*.key"
    fail 'bind_key is required.'
  }
  if $::openshift_origin::bind_krb_principal != '' and $::openshift_origin::bind_krb_keytab == '' {
    warning "Kerberos keytab for the DNS service was not set. Please generate a keytab for DNS/${::openshift_origin::nameserver_fqdn} and provide a path for the keytab."
    fail 'bind_krb_keytab is required.'
  }

  package { 'rubygem-openshift-origin-dns-nsupdate':
    require => [
      Class['openshift_origin::install_method'],
      Package['openshift-origin-broker'],
    ],
  }

  if $::openshift_origin::bind_krb_principal != '' {
    file { 'broker-dns-keytab':
      ensure  => present,
      path    => $::openshift_origin::bind_krb_keytab,
      owner   => 'apache',
      group   => 'apache',
      mode    => '0664',
      notify  => Service['openshift-broker'],
      require => Package['rubygem-openshift-origin-dns-nsupdate','httpd'],
    }
    $nsupdate_config = template('openshift_origin/broker/plugins/dns/nsupdate/nsupdate-kerb.conf.erb')
    $nsupdate_requirements = [ Package['rubygem-openshift-origin-dns-nsupdate'], File['broker-dns-keytab'] ]
  } else {
    $nsupdate_config = template('openshift_origin/broker/plugins/dns/nsupdate/nsupdate.conf.erb')
    $nsupdate_requirements = Package['rubygem-openshift-origin-dns-nsupdate']
  }
  file { 'plugin openshift-origin-dns-nsupdate.conf':
      path    => '/etc/openshift/plugins.d/openshift-origin-dns-nsupdate.conf',
      content => $nsupdate_config,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      notify  => Service['openshift-broker'],
      require => $nsupdate_requirements
  }
}
