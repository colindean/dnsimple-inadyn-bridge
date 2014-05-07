require 'bundler'
Bundler.require
require 'json'
require 'logger'

LOGGER = Logger.new(STDOUT)

get '/domains/:domain_id/records/:record_id' do
  #get the email from username and the api_token from password
  @auth ||=  Rack::Auth::Basic::Request.new(request.env)
  unless @auth.provided? && @auth.basic? && @auth.credentials
    halt 401, "You must supply an email and API token as username and password\n"
  end

  email, api_token = @auth.credentials
  domain_id = params[:domain_id]
  record_id = params[:record_id]
  #unused
  #hostname = params[:hostname]
  ip = params[:myip]

  url = "https://dnsimple.com/domains/#{domain_id}/records/#{record_id}"
  payload = {"record" => {"content" => ip}}.to_json
  headers = {accept: :json,
             content_type: :json,
             "X-DNSimple-Domain-Token" => "#{api_token}"}

  LOGGER.info "#{email} PUTTING #{ip} TO #{url}"

  res = RestClient.put url, payload, headers

  case res.code
  when 200
    "good #{ip}"
  else
    "nochg #{ip}" #could also be 'nohost' when the host doesn't exist? use if record_id doesn't exist
  end

end

get '/' do
  erb :index
end
