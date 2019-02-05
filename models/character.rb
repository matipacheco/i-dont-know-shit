require 'active_model'

class Character
  include ActiveModel::Serializers::JSON

  attr_accessor :id, :name, :description

  def attributes=(hash)
    hash.each do |key, value|
      begin
        send("#{key}=", value)
      rescue
        next
      end
    end
  end
end
