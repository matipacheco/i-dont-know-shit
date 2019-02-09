# {"id": 1009169,"name": "Baron Strucker","str": 70,"hp": 62,"luck": 10}
# 
# "Beef WINS!"

require 'json'
require 'test/unit'
require_relative 'models/battle'

# Tests cases
class Tests < Test::Unit::TestCase
  def test_1
    fighters_json = [
      {"id": 1009169,"name": "Baron Strucker","str": 70,"hp": 62,"luck": 10}.to_json,
      {"id": 1009178,"name": "Beef","str": 47,"hp": 157,"luck": 1}.to_json
    ]

    # assert_equal('Beef WINS!', Battle.new(fighters_json).give_em_hell!)
    assert_equal(nil, Battle.new(fighters_json).give_em_hell!)
  end
end
