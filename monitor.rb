require 'net/https'
require 'uri'
require 'net/smtp'
require 'yaml'

def send_warning_email( sitename, w_data )
  message = <<MESSAGE_END
From: <#{w_data['sender']}>
To: <#{w_data['dest']}>
Subject: Site failure

#{sitename} n'est plus accessible.
MESSAGE_END

p w_data, message

  Net::SMTP.start('127.0.0.1') do |smtp|
    smtp.send_message message, w_data['sender'], w_data['dest']
  end
end

# send_warning_email( 'test' )

w_data = YAML.load_file( 'watcher.yaml' )

# CAUTION : sites addresses should not be https
File.open( 'sites.txt' ).readlines.each do |site|
  uri = URI.parse(site + '/monitoring/show' )
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  request = Net::HTTP::Get.new(uri.request_uri)
  res = http.request(request)

  puts "#{site} : #{res.code}"

  unless [ '200', '401' ].include?( res.code )
    send_warning_email( site, w_data )
  end

end
