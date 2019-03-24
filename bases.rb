require 'byebug'
require 'whois'
require 'whois-parser'

whois = Whois::Client.new
domain = 'cdninstagram'

@chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_~:[]@$()*+,;='".split("")

bytes = domain.bytes.map { |byte| byte.to_s(2).split("") }

first = bytes.first


def build_char(byte)
  byte.join("")
    .to_i(2)
    .chr
end

def find_shifts(byte_str)
  byte_str.map.with_index do |bit, idx|
    copy = byte_str.dup
    copy[idx] = bit === "0" ? "1" : "0"
    copy
  end
end


def build_domain(bytes)
  bytes.map do |byte| 
    build_char(byte)
  end
end


domains = bytes.map.with_index do |bits, idx|
  shifts = find_shifts(bits)
  shifts.map do |shift|
    copy = bytes.dup
    copy[idx] = shift
    begin
      build_domain(copy)
        .join()
        .downcase()
    rescue RangeError => boom
      p boom
    end
  end
end

def find_valid_domains(domains)
  domains.keep_if do |domain| 
    domain.chars.all? { |char| @chars.include? char }
  end
end

valid_domains = domains.map { |doms| find_valid_domains(doms) }

names = valid_domains.flatten.uniq

open('/Users/wagnerizing/urls.txt', 'a') do |f|
  valid_urls = names.each do |name|
    begin
    url = "#{name}.com"
    record = whois.lookup(url)
    p "checking #{url}"
    is_available = record.parser.available?
    p "#{url}: #{is_available} "
    #f.puts(url) if is_available
    rescue Exception => boom
      p "we had an oopsie: #{boom} #{name}"
    end
  end
end

