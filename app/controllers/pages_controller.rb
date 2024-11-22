# frozen_string_literal: true

# A basic controller from the template app
class PagesController < ApplicationController
  def home
    @script_packs = %w['application']
    @style_packs = %w['application']
  end
end
