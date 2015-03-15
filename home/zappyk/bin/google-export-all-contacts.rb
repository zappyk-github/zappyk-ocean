#!/usr/bin/env ruby

require 'rubygems'
require 'mechanize'
require 'logger'

domain = 'gmail.com'

base_www    = 'https://www.google.com'
base_www    = 'https://accounts.google.com'
base_mail   = 'https://mail.google.com'
path_export = 'mail/contacts/data/export?groupToExport=%5EMine&exportType=ALL&out='
path_export = 'mail/c/data/export?exportType=ALL&out='
path_auth   = 'accounts/ServiceLoginBoxAuth'
path_auth   = 'ServiceLogin'

url_loginAuth   = "#{base_www}/#{path_auth}"
url_CSV_OUTLOOK = "#{base_mail}/#{path_export}OUTLOOK_CSV"
url_CSV_GMAIL   = "#{base_mail}/#{path_export}GMAIL_CSV"
url_VCARD       = "#{base_mail}/#{path_export}VCARD"

#CZ#print "Download ALL contacts for user? "
#CZ#user = STDIN.gets
#CZ#user = user.chomp
#CZ#account_user = "#{user}@#{domain}"
print "Download ALL contacts for user@domain? "
account_user = STDIN.gets
account_user = account_user.chomp
print "Password for #{account_user}? "
account_pswd = STDIN.gets
account_pswd = account_pswd.chomp

time = Time.new
date = time.strftime("%F")
date = format('%.4d%02d%02d', time.year, time.mon, time.mday)

flog = $0 + '.log'
flog = '/dev/null'
agent = Mechanize.new { |obj| obj.log = Logger.new(flog) }

print "Login ongoing... "
page = agent.get(url_loginAuth)

form = page.forms.first
form.Email = account_user 
form.Passwd = account_pswd

page = agent.submit(form)
print "done!"

file = "contacts-google-#{account_user}-#{date}-outlook.csv"
puts "Download '#{url_CSV_OUTLOOK}' ==> #{file}"
page = agent.get(url_CSV_OUTLOOK)
page.save_as(file)

file = "contacts-google-#{account_user}-#{date}.csv"
puts "Download '#{url_CSV_GMAIL}' ==> #{file}"
page = agent.get(url_CSV_GMAIL)
page.save_as(file)

file = "contacts-google-#{account_user}-#{date}.vcf"
puts "Download '#{url_VCARD}' ==> #{file}"
page = agent.get(url_VCARD)
page.save_as(file)

exit
