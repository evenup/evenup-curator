require 'spec_helper'

describe 'curator', :type => :class do
  it { should create_class('curator') }

  it { should contain_package('elasticsearch-curator').with(:ensure => 'latest') }

  context 'set package version and use default provider' do
    let(:params) { { :ensure => '3.0.0' } }
    it { should contain_package('elasticsearch-curator').with(:ensure => '3.0.0') }
  end

  context 'set package version and package name and use default provider' do
    let(:params) do
      {
        :ensure       => '3.0.0',
        :package_name => 'python-elasticsearch-curator',
      }
    end
    it { should contain_package('python-elasticsearch-curator').with(:ensure => '3.0.0') }
  end

  context 'require version >= 1.1.0' do
    let(:prams) { { :ensure => '1.0.0' } }
    it { expect { should raise_error(Puppet::Error) } }
  end

  # Credit: Used some code from GitHub user 'electrical'
  # Source: https://github.com/elastic/puppet-elasticsearch/commit/fdb7de33ea3252607e02861b9ce83426a3f8a08c
  context 'when not supplying a repo_version' do
    let(:params) { { :manage_repo => true, } }
    it { expect { should raise_error(Puppet::Error, 'Please fill in a repository version at $repo_version') } }
  end

  context 'empty jobs' do
    let(:params) { { :jobs => {} } }
    it { should_not contain_curator__job() }
  end

  context 'add a job using globals' do
    let(:params) do
      {
        :http_auth            => true,
        :jobs                 => {
          'delete_job' => {
            'command'     => 'close',
            'cron_hour'   => 6,
            'master_only' => true,
            'older_than'  => 7
          }
        },
        :password             => 'password',
        :ssl_certificate_path => '/path/to/cert.pem',
        :use_ssl              => true,
        :user                 => 'user',
      }
    end

    it do
      should contain_curator__job('delete_job').with( {
        :command              => 'close',
        :cron_hour            => 6,
        :http_auth            => true,
        :master_only          => true,
        :older_than           => 7,
        :password             => 'password',
        :ssl_certificate_path => '/path/to/cert.pem',
        :use_ssl              => true,
        :user                 => 'user',
      } )
    end
  end

  context 'add a job' do
    let(:params) do
      {
        :jobs => {
          'delete_job' => {
            'command'              => 'close',
            'cron_hour'            => 6,
            'http_auth'            => true,
            'master_only'          => true,
            'older_than'           => 7,
            'password'             => 'password',
            'ssl_certificate_path' => '/path/to/cert.pem',
            'use_ssl'              => true,
            'user'                 => 'user',
          }
        }
      }
    end

    it do
      should contain_curator__job('delete_job').with({
        :command              => 'close',
        :cron_hour            => 6,
        :http_auth            => true,
        :master_only          => true,
        :older_than           => 7,
        :password             => 'password',
        :ssl_certificate_path => '/path/to/cert.pem',
        :use_ssl              => true,
        :user                 => 'user',
      })
    end
  end
end
