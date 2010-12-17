module DynMeta
  module ActionController
    
    def self.included(base)
      base.class_eval do
        helper_method :page_detail
      end
    end
    
    def method_missing(method_name, *args)
      if method_name.to_s =~ /^page_/
        page_detail(method_name)
      else
        super
      end
    end
    
    def respond_to?(method_name)
      method_name.to_s =~ /^page_/ || super
    end
    
    def page_detail(name, val = nil)
      in_name = "@#{name}"
      return instance_variable_set(in_name, val) if val.present?
      return instance_variable_get(in_name) if instance_variable_get(in_name)
      trans = I18n.translate(name.to_s.pluralize)
      prms = [:controller, :action, :id]
      hash = trans
      prms.each do |p|
        val = params[p] && hash[params[p].to_s.to_sym] || nil
        if val.nil?
          return hash[:default] || trans[:default] || nil
        elsif val.is_a?(Hash)
          hash = val
        else
          return val
        end
      end
    end

  end
end

::ActionController::Base.send(:include, ::DynMeta::ActionController)