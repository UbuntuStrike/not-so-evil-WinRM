#!/usr/bin/env ruby

################## NO53LF ####################

require 'winrm'
require 'stringio'
require 'io/console'
require "highline/import"
require 'rubygems'

###### Set Connection Variables ############

$ssl = ask("Do you require SSL? y or n : ")
$method = 'http://'

  if $ssl=='y'
     $method='https://'
  end

$host = ask("Enter Hostname or IP: ")
$port = ask("Enter Port or leave blank for default 5985: ")

  if $port==''
     $port=':5985'
  end

$path = ask("Enter Path, example /other/path/to/wsman or leave blank for default /wsman: ")

if $path==''
     $path = '/wsman'
  end

$user = ask("Username: ")
$password = ask("Password: ") { |q| q.echo = false }
$scope = $method+$host+$port+$path

####### Connect to WinRM ####################

conn = WinRM::Connection.new(
  endpoint: $scope,
  user: $user,
  password: $password,
  :no_ssl_peer_verification => true,
  transport: :ssl
)

command=""


conn.shell(:powershell) do |shell|
    until command == "exit" do
        print "PS > "
        command = gets        
        output = shell.run(command) do |stdout, stderr|
            STDOUT.print stdout
            STDERR.print stderr
        end
    end    
    puts "Exiting with code #{output.exitcode}"
end
