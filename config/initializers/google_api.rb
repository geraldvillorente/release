require 'google_calendar_client'

ReleaseApp.google_calendar_client = GoogleCalendarClient.new(
  ENV["google_api_issuer"] || "issuer",
  ENV["google_api_client_key"] || "client key",
  ENV["google_api_calendar_id"] || "calendar id",
)
