require 'active_model'

# Character Serializer.
# Since I could not figure out how to ignore unknown fields,
# attributes method holds a begin/rescue block in case it crushes.
class Character
  include ActiveModel::Serializers::JSON

  attr_accessor :id, :name, :str, :hp, :luck

  def attributes=(hash)
    hash.each do |key, value|
      begin
        send("#{key}=", value)
      rescue
        next
      end
    end

    @str  = rand(1..100)
    @hp   = rand(1..400)
    @luck = rand(1..10)
  end

  def validate
    id.is_a?(Integer) && name.is_a?(string)
  end

  def to_json
    {
      'id' => id,
      'name' => name,
      'str' => @str,
      'hp' => @hp,
      'luck' => @luck
    }
  end

  def hit
    @str
  end

  def dice_roll
    @luck
  end

  def alive?
    @hp > 0
  end
end
