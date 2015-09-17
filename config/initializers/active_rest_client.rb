ActiveRestClient::Base.base_url = Rails.application.secrets.prs_url
ActiveRestClient::Base.adapter = :net_http