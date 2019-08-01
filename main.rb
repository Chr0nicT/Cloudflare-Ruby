require_relative 'Cloudflare_Ruby.rb'

Cloudflare_Ruby.new("APIKEY", "CF_EMAIL")

id =  Cloudflare_Ruby.getZoneIDFromName("tw3lve.space")
puts Cloudflare_Ruby.getParsedDNSRecordsForZoneID(id)
puts Cloudflare_Ruby.parseDNSData("type", "name", "content")
