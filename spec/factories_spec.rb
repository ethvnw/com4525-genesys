# frozen_string_literal: true

# Factory bot spec following tutorial from https://thoughtbot.com/blog/testing-your-factories-first
# Should ensure that any changes to validation will be caught here, rather than in later tests

require "rails_helper"

FactoryBot.factories.map(&:name).each do |factory_name|
  describe "The #{factory_name} factory" do
    it "is valid" do
      expect(build(factory_name)).to(be_valid)
    end
  end
end
