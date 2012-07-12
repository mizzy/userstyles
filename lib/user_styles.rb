require 'user_styles/client'

BASE_URL = 'http://userstyles.org/'

module UserStyles
  class << self
    def new(options={})
      UserStyles::Client.new(options)
    end
  end
end
