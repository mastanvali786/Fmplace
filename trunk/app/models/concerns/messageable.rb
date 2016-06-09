module Messageable
  extend ActiveSupport::Concern
  included do
    include Wisper::Publisher
  end
end

