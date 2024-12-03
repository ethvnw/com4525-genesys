# frozen_string_literal: true

# Factory bot spec following tutorial from https://thoughtbot.com/blog/testing-your-factories-first
# Should ensure that any changes to validation will be caught here, rather than in later tests

require "rails_helper"

RSpec.describe(FactoryBot) do
  FactoryBot.factories.map(&:name).each do |factory_name|
    describe "the #{factory_name} factory" do
      it "is valid" do
        expect(build(factory_name)).to(be_valid)
      end
    end
  end

  describe "the admin factory" do
    it "creates an admin user" do
      expect(build(:admin).admin?).to(be_truthy)
    end
  end

  describe "the reporter factory" do
    it "creates a reporter user" do
      expect(build(:reporter).reporter?).to(be_truthy)
    end
  end
end
