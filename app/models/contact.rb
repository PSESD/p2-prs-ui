class Contact < ActiveRestClient::Base

  ATTRIBUTES = %w[name title email phone mailingAddress webAddress]

  def errors
    @errors = {}
    ATTRIBUTES.each{|a| @errors[a] = []}
    @errors.symbolize_keys
  end

  def fullWebAddress
    if webAddress.blank?
      ""
    elsif webAddress.start_with?('http://', 'https://')
      webAddress
    else
      webAddress.prepend "https://"
    end
  end

end
