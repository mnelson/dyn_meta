require 'dyn_meta/version'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/object/blank'

module DynMeta

  module Helper


    # allow setting, getting, and configuration of meta content.
    # utilizes i18n and the current request to build meta content
    #
    # Usage:
    #   Request 1:
    #     meta(:page_title, "Some String") => "Some String"
    #     meta(:page_title) => "Some String"
    #   Request 2:
    #     assuming t('meta.page_titles.[controller].[action].default') == "Some Page Title"
    #     meta(:page_title) => "Some Page Title"
    #   Request 3:
    #     assuming t('meta.page_titles.[controller].[action].default') == "%{geo_name} Title"
    #     meta(:page_title, :geo_name => "Atlantis")
    #     meta(:page_title) => "Atlantis Title"
    #   Request 4:
    #     assuming t('meta.page_titles.[controller].custom_action.default') == "Special Title"
    #     meta(:page_title, :alt => {:action => 'custom_action'}) => "Special Title"
    #     meta(:page_title) => "Special Title"
    def meta(name, interpolations = nil)

      instance_name = "@dyn_meta_#{name}"

      return instance_variable_get(instance_name)                 if interpolations.nil? && instance_variable_get(instance_name)
      return instance_variable_set(instance_name, interpolations) if interpolations.is_a?(String)

      interpolations  ||= {}
      alt_params        = interpolations[:alt] || {}
      param_hash        = params.merge(alt_params)

      interpolations.except!(:alt)

      keys = ["#{meta_key}.#{name.to_s.pluralize}", "#{meta_key}.#{name.to_s.pluralize}.default"]

      [:controller, :action, :id].each do |param|
        key = param_hash[param]
        break if key.blank?
        prev = keys.first
        keys.unshift("#{prev}.#{key}.default")
        keys.unshift("#{prev}.#{key}")
      end

      val = meta_lookup(keys, interpolations)

      instance_variable_set(instance_name, val)
    end

    protected

    def meta_lookup(keys, interpolations)
      keys.each do |key|
        val = begin
          I18n.t(key, interpolations.merge(raise: true))
        rescue I18n::MissingTranslationData
          nil
        end

        next        if val.is_a?(Hash)
        return val  if val
      end

      nil
    end

    def meta_key
      'meta'
    end
  end
end
