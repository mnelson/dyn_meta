require 'dyn_meta/version'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/string/inflections'

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
    def meta(name, *args)
      
      instance_name = "@meta_#{name}"
      
      options       = args.extract_options!
      value         = args.first
      current_val   = instance_variable_get(instance_name) || value

      return instance_variable_set(instance_name, current_val) if current_val.is_a?(String)

      alt_params      = options[:alt] || {}
      param_hash      = params.merge(alt_params)
      interpolations  = options.except(:alt)
          
      trans           = I18n.translate(meta_key)[name.to_s.pluralize.to_sym] || {}
      hash            = trans
      
      [:controller, :action, :id].each do |param|
        
        val = param_hash[param] && hash[param_hash[param].to_sym] || nil
        
        if val.nil?
          string = build_meta_string(hash[:default] || trans[:default], interpolations)
          return instance_variable_set(instance_name, string)
        elsif val.is_a?(Hash)
          hash = val
        else
          string = build_meta_string(val, interpolations)
          return instance_variable_set(instance_name, string)
        end
        
      end
    end
    
    protected
    
    def build_meta_string(string, interpolations = {})
      return nil if string.nil?
      I18n.backend.send(:interpolate, I18n.locale || I18n.default_locale, string, interpolations)
    end
    
    def meta_key
      'meta'
    end
    
  end
end