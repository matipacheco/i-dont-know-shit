require 'active_model'

# Character Serializer.
# Since I could not figure out how to ignore unknown fields,
# attributes method holds a begin/rescue block in case it crushes.
class Character
  include ActiveModel::Serializers::JSON

  attr_accessor :id, :name, :STR, :HP, :LUCK

  def attributes=(hash)
    hash.each do |key, value|
      begin
        send("#{key}=", value)
      rescue
        next
      end
    end

    self.STR  = rand(1..100)
    self.HP   = rand(1..400)
    self.LUCK = rand(1..10)
  end

  def validate
    id.is_a?(Integer) && name.is_a?(String)
  end
end
