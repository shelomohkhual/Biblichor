Mailgun.configure do |config|
    config.api_key = Rails.application.credentials.dig(:mailgun, :mailgun_api)
end