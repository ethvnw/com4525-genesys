# frozen_string_literal: true

# Module containing global helper functions
module ApplicationHelper
  ##
  # Converts a list of script pack names into a list of paths
  # Will return an empty list if `script_packs` is nil
  # @param script_packs [Array<String>] an array of script pack names
  # @return [Array<String>] an array of script pack paths
  def get_script_paths(script_packs)
    if script_packs.present?
      script_packs.map { |script_pack| "scriptpacks/#{script_pack}" }
    else
      []
    end
  end

  ##
  # Converts a list of style pack names into a list of paths
  # Will return an empty list if `style_packs` is nil
  # @param style_packs [Array<String>] an array of style pack names
  # @return [Array<String>] an array of style pack paths
  def get_style_paths(style_packs)
    if style_packs.present?
      style_packs.map { |style_pack| "stylepacks/#{style_pack}" }
    else
      []
    end
  end
end
