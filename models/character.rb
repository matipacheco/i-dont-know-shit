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

    @STR  = rand(1..100)
    @HP   = rand(1..400)
    @LUCK = rand(1..10)
  end

  def validate
    id.is_a?(Integer) && name.is_a?(String)
  end

  def to_json
    {
      'id'   => id,
      'name' => name,
      'STR'  => @STR,
      'HP'   => @HP,
      'LUCK' => @LUCK
    }
  end

  def hit
    @STR
  end

  def dice_roll
    @LUCK
  end

  def alive?
    @HP > 0
  end
end
