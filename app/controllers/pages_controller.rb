# frozen_string_literal: true

# A basic controller from the template app
class PagesController < ApplicationController
  def home
    @script_packs = ["application"]
    @style_packs = ["application"]
  end
end
