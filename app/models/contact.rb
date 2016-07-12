class Contact < ActiveRestClient::Base
  
  ATTRIBUTES = %w[name title email phone mailingAddress webAddress]
  
  def errors
    @errors = {}
    ATTRIBUTES.each{|a| @errors[a] = []}
    @errors.symbolize_keys
  end
  
  def fullWebAddress
    return "" if webAddress.blank?
    webAddress.prepend "http://" unless webAddress.start_with?('http://', 'https://')
  end
  
end
