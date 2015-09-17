ActiveRestClient::Base.base_url = Rails.application.secrets.prs_url || "https://prs.dev/"
ActiveRestClient::Base.adapter = :net_http