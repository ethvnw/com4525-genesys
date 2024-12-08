# frozen_string_literal: true

# Decorator for feature share
class FeatureShareDecorator < ApplicationDecorator
  delegate_all

  def initialize(*args)
    super
    @feature_obj = object.app_feature
  end

  def journey_title
    @feature_obj.name
  end

  def journey_header
    "Shared using #{object.share_method.titleize}"
  end

  def journey_icon
    "bi bi-share"
  end
end
