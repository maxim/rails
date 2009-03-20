# encoding: utf-8
require 'cases/helper'
require 'cases/test_database'

require 'models/topic'

class PresenceValidationTest < ActiveModel::TestCase
  include ActiveModel::TestDatabase
  include ActiveModel::ValidationsRepairHelper

  repair_validations(Topic)

  def test_validate_presences
    Topic.validates_presence_of(:title, :content)

    t = Topic.create
    assert !t.save
    assert_equal ["can't be blank"], t.errors[:title]
    assert_equal ["can't be blank"], t.errors[:content]

    t.title = "something"
    t.content  = "   "

    assert !t.save
    assert_equal ["can't be blank"], t.errors[:content]

    t.content = "like stuff"

    assert t.save
  end

  def test_validates_presence_of_with_custom_message_using_quotes
    repair_validations(Developer) do
      Developer.validates_presence_of :non_existent, :message=> "This string contains 'single' and \"double\" quotes"
      d = Developer.new
      d.name = "Joe"
      assert !d.valid?
      assert_equal ["This string contains 'single' and \"double\" quotes"], d.errors[:non_existent]
    end
  end
end