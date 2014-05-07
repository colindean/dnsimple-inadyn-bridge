require 'bundler'
Bundler.require
require 'json'
require 'logger'
require 'digest'

LOGGER = Logger.new(STDOUT)

business_url = '/domains/:domain_id/records/:record_id'

get business_url do
  #get the email from username and the api_token from password
  @auth ||=  Rack::Auth::Basic::Request.new(request.env)
  unless @auth.provided? && @auth.basic? && @auth.credentials
    halt 401,
         "You must supply an email and API token as username and password.\n"
  end

  email, api_token = @auth.credentials
  ehash = Digest::MD5.hexdigest(email).slice(0..7) #1st 8 chars of hashed email
  domain_id = params[:domain_id]
  record_id = params[:record_id]
  #unused
  #hostname = params[:hostname]
  ip = params[:myip] || request.ip

  url = "https://dnsimple.com/domains/#{domain_id}/records/#{record_id}"
  payload = {"record" => {"content" => ip}}.to_json
  headers = {accept: :json,
             content_type: :json,
             "X-DNSimple-Domain-Token" => "#{api_token}"}

  res = RestClient.put url, payload, headers

  case res.code
  when 200
    saved_ip = JSON.parse(res.body)["record"]["content"]
    "good #{saved_ip}"
    #"nochg #{ip}"
  when 400
    "dnserr"
  when 401
    "badauth"
  when 404
    "nohost"
  else
    "911"
  end

  LOGGER.info "#{ehash} updating #{domain_id}/#{record_id} to #{ip}"

end

get '/' do
  @host = request.host + (request.port == 80 ? "" : ":"+request.port.to_s)
  @url = '/domains/:domain_id/records/'
  erb :index, locals: {host: @host, url: @url}
end
