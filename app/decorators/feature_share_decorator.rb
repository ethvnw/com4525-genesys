# frozen_string_literal: true

# Decorator for review likes
class FeatureShareDecorator < ApplicationDecorator
  delegate_all

  def journey_title
    feature_obj = object.app_feature
    feature_obj.name
  end
end
