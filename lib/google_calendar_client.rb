require 'google/api_client'

class GoogleCalendarClient
  attr_accessor :client

  class ClientNotPresent < StandardError; end

  def initialize(issuer, client_key, calendar_id)
    @calendar_id = calendar_id

    @client = Google::APIClient.new

    key = Google::APIClient::KeyUtils.load_from_pkcs12(Base64.decode64(client_key), 'notasecret')
    @client.authorization = Signet::OAuth2::Client.new(
      :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
      :audience => 'https://accounts.google.com/o/oauth2/token',
      :scope => 'https://www.googleapis.com/auth/calendar.readonly',
      :issuer => issuer,
      :signing_key => key
    )
    @client.authorization.fetch_access_token!
  rescue ArgumentError
    @client = nil
    logger.warn "GoogleCalendarClient: Could not initialize an API client."
  end

  def events
    raise ClientNotPresent unless @client.present?

    @client.execute(:api_method => service.events.list, :parameters => {
      'calendarId' => @calendar_id,
      'timeMin' => DateTime.now.to_s,
      'orderBy' => 'startTime',
      'singleEvents' => true
    }).data.items
  end

  private

  def service
    @client.discovered_api('calendar', 'v3')
  end

  def logger
    @logger ||= Logger.new(STDOUT)
  end
end
