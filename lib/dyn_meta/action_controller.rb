module DynMeta
  module ActionController
    
    def self.included(base)
      base.class_eval do
        helper_method :meta
      end
    end
    
    def meta(name, val = nil)
      
      in_name = "@meta_#{name}"
      return instance_variable_set(in_name, val) if val.present?
      return instance_variable_get(in_name) if instance_variable_get(in_name)
      
      trans = I18n.translate("meta.#{name.to_s.pluralize}") || {}
      hash = trans
      [:controller, :action, :id].each do |p|
        val = params[p] && hash[params[p].to_s.to_sym] || nil
        if val.nil?
          return instance_variable_set(in_name, hash[:default] || trans[:default] || nil)
        elsif val.is_a?(Hash)
          hash = val
        else
          return instance_variable_set(in_name, val)
        end
      end
    end
    
  end
end

::ActionController::Base.send(:include, ::DynMeta::ActionController)