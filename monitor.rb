require 'net/https'
require 'open-uri'
require 'net/smtp'
require 'yaml'

def send_warning_email( sitename, w_data, error )
  message = <<MESSAGE_END
From: <#{w_data['sender']}>
To: <#{w_data['dest']}>
Subject: Site failure

#{sitename} n'est plus accessible.

#{error.to_s}

MESSAGE_END

  Net::SMTP.start('127.0.0.1') do |smtp|
    smtp.send_message message, w_data['sender'], w_data['dest']
  end
end

# send_warning_email( 'test' )

w_data = YAML.load_file( 'watcher.yaml' )

# CAUTION : sites addresses should not be https
File.open( 'sites.txt' ).readlines.each do |site|
  url, login, password = site.strip.split

  read_params = {}
  if login && password
    read_params = { http_basic_authentication: [ login, password ] }
  end

  begin
    @data = URI.parse(url ).read( read_params )
  rescue => e
    send_warning_email( url, w_data, e )
  end

end
