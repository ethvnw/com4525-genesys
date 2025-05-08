# frozen_string_literal: true

##
# Concern for controllers which require the ability to enforce presence of query parameters
module ParamPresenceEnforceable
  extend ActiveSupport::Concern

  included do
    ##
    # Enforces the presence/case of a parameter, by adding its enforced value to the @enforced_params hash
    #
    # @param param_key [Symbol] the key of the params hash that must be present
    # @param valid_values [Array<String>] a list of the possible values that this key should take
    # @param param_session_key [Symbol] the key of the session hash that stores the user's preference for this parameter
    #
    # @example enforce_required_parameter(:view, ["list", "map"], :trip_index_view)
    def enforce_required_parameter(param_key, valid_values, param_session_key)
      current_value = params[param_key]
      unless valid_values.include?(params[param_key])
        flash.keep(:notifications) # Persist notifications across redirect

        # Set default parameter value to downcase version of current one if that would be valid.
        # Otherwise get the user's preference from the session hash, falling back to the first valid value if
        # key is not present in session hash.
        default_value = if valid_values.include?(current_value&.downcase)
          current_value&.downcase
        else
          session.fetch(param_session_key, valid_values[0])
        end

        @enforced_params ||= {}
        @enforced_params[param_key] = default_value
      end
    end

    ##
    # @return true if any parameters have been enforced, otherwise false
    def any_params_enforced?
      @enforced_params.present?
    end

    ##
    # @return whether param_key is value, either in the original params hash or the @enforced_params hash
    def param_enforced_as?(param_key, value)
      params[param_key] == value || (@enforced_params.present? && @enforced_params[param_key] == value)
    end

    ##
    # @return a new query parameters hash, with @enforced_params merged in
    def enforced_query_params
      request.query_parameters.merge(@enforced_params)
    end
  end
end
