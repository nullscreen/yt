require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  # c.preserve_exact_body_bytes do |http_message, cassette|
  #   http_message.body.encoding.name == 'UTF-8' ||
  #   !http_message.body.valid_encoding?
  # end
  c.configure_rspec_metadata!
  c.filter_sensitive_data("<YT_TEST_API_KEY>") { ENV['YT_TEST_API_KEY'] }
  c.filter_sensitive_data("<YT_TEST_CLIENT_ID>") { ENV['YT_TEST_CLIENT_ID'] }
  c.filter_sensitive_data("<YT_TEST_CLIENT_SECRET>") { ENV['YT_TEST_CLIENT_SECRET'] }
  c.filter_sensitive_data("<YT_TEST_REFRESH_TOKEN>") { CGI.escape(ENV['YT_TEST_REFRESH_TOKEN']) }
  c.filter_sensitive_data("<YT_TEST_ACCESS_TOKEN>") do |interaction|
    begin
      body = JSON.parse(interaction.response.body)
      body['access_token']
    rescue
      # noop
    end
  end
  c.filter_sensitive_data("<YT_TEST_ID_TOKEN>") do |interaction|
    begin
      body = JSON.parse(interaction.response.body)
      body['id_token']
    rescue
      # noop
    end
  end

  c.filter_sensitive_data("<YT_AUTH_HEADER>") do |interaction|
    interaction.request.headers['Authorization'].first rescue nil
  end
end
