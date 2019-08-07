Mailgun.configure do |config|
    byebug
    config.api_key = Rails.application.credentials.dig(:mailgun, :mailgun_api)
end