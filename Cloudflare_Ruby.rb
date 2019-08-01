require 'net/http'
require 'uri'
require 'json'

class Cloudflare_Ruby

    @@key = 0
    @@email = 0

    def initialize(key, email)
      @@key = key
      @@email = email
    end

    def self.zones()
      uri = URI.parse("https://api.cloudflare.com/client/v4/zones")
      request = Net::HTTP::Get.new(uri)
      request.content_type = "application/json"
      request["X-Auth-Key"] = @@key
      request["X-Auth-Email"] = @@email
      
      req_options = {
        use_ssl: uri.scheme == "https",
      }
      
      req = Net::HTTP.start(uri.hostname, uri.port, req_options)
      response = req.request(request)
      return response.body
    end

    def self.zonesParsed()
      uri = URI.parse("https://api.cloudflare.com/client/v4/zones/")
      request = Net::HTTP::Get.new(uri)
      request.content_type = "application/json"
      request["X-Auth-Key"] = @@key
      request["X-Auth-Email"] = @@email
      
      req_options = {
        use_ssl: uri.scheme == "https",
      }
      
      req = Net::HTTP.start(uri.hostname, uri.port, req_options)
      response = req.request(request)
      return JSON.parse(response.body)['result']
    end

    

    def self.getDNSRecordsForZoneID(id)
      uri = URI.parse("https://api.cloudflare.com/client/v4/zones/" + id + "/dns_records")
      request = Net::HTTP::Get.new(uri)
      request.content_type = "application/json"
      request["X-Auth-Key"] = @@key
      request["X-Auth-Email"] = @@email
      
      req_options = {
        use_ssl: uri.scheme == "https",
      }
      
      req = Net::HTTP.start(uri.hostname, uri.port, req_options)
      response = req.request(request)
      return response.body
    end


    def self.getParsedDNSRecordsForZoneID(id)
      uri = URI.parse("https://api.cloudflare.com/client/v4/zones/" + id + "/dns_records")
      request = Net::HTTP::Get.new(uri)
      request.content_type = "application/json"
      request["X-Auth-Key"] = @@key
      request["X-Auth-Email"] = @@email
      
      req_options = {
        use_ssl: uri.scheme == "https",
      }
      
      req = Net::HTTP.start(uri.hostname, uri.port, req_options)
      response = req.request(request)
      return JSON.parse(response.body)['result']
    end


    def self.getCleanDNSRecordsForID(id)
      puts '[ZONE ID] [RECORD TYPE] [RECORD NAME] [RECORD CONTENT]'
      puts ''
      Cloudflare_Ruby.getParsedDNSRecordsForZoneID('8782d70633682bfe9f791414fade6f55').each do |n|
        puts n['id'] + " " + n['type'] + " " + n['name'] + " " + n['content']
      end
      puts ''
    end

    def self.getCleanZones()
      puts '[ZONE NAME] [ZONE ID]'
      puts ''
      Cloudflare_Ruby.zonesParsed.each do |n|
        puts n['name'] + " " + n['id']
      end
      puts ''
    end


    def self.getZoneIDFromName(name)
      Cloudflare_Ruby.zonesParsed.each do |n|
        if n['name'] == name
          return n['id']
        else
          return "ERROR. Zone not found!"
        end
      end
    end

    def self.getZoneNameByID(id)
      Cloudflare_Ruby.zonesParsed.each do |n|
        if n['id'] == id
          return n['name']
        else
          return "ERROR. Zone not found!"
        end
      end
    end

    def self.deleteZoneDNSEntryByID(zoneID, dnsID)
      uri = URI.parse("https://api.cloudflare.com/client/v4/zones/" + zoneID + "/dns_records/" + dnsID)
      request = Net::HTTP::Delete.new(uri)
      request.content_type = "application/json"
      request["X-Auth-Email"] = @@email
      request["X-Auth-Key"] = @@key

      req_options = {
        use_ssl: uri.scheme == "https",
      }

      req = Net::HTTP.start(uri.hostname, uri.port, req_options)
      response = req.request(request)
    end
    

    def self.parseDNSData(type, name, content, priority = 0, ttl = 1, proxied = false)
        parsed = JSON.dump({
          "type" => type.chomp,
          "name" => name.chomp,
          "content" => content.chomp,
          "ttl" => ttl,
          "proxied" => proxied,
          "priority" => priority
        })
  
        return parsed
    end

    def self.updateZoneDNSEntryByID(zoneID, dnsID, jsonDumpData)
      uri = URI.parse("https://api.cloudflare.com/client/v4/zones/" + zoneID + "/dns_records/" + dnsID)
      request = Net::HTTP::Delete.new(uri)
      request.content_type = "application/json"
      request["X-Auth-Email"] = @@email
      request["X-Auth-Key"] = @@key
      request.body = jsonDumpData

      req_options = {
        use_ssl: uri.scheme == "https",
      }

      req = Net::HTTP.start(uri.hostname, uri.port, req_options)
      response = req.request(request)
    end

  end
