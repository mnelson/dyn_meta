require 'spec_helper'

describe DynMeta::Helper do

  class Controller
    include DynMeta::Helper

    attr_reader :params
    def initialize(params = {})
      @params = params
    end
  end

  let(:params){ {:controller => 'testing', :action => 'show'} }
  let(:c){ Controller.new(params) }

  it 'should integrate for testing properly' do
    c.params.should eql(params)
    c.should respond_to(:meta)
  end

  it 'should allow direct setting of the value' do
    c.meta(:title, 'Title of the page')
    c.meta(:title).should eql('Title of the page')
  end

  it 'should read values from I18n' do
    c.meta(:keywords).should eql('testing,show,dyn_meta')
  end

  it 'should interpolate values and memoize results' do
    params[:action] = 'index'
    c.meta(:keywords, :type => 'user').should eql('testing,index,dyn_meta,user')
    c.meta(:keywords).should eql('testing,index,dyn_meta,user')
  end

  it 'should allow substitutions to be provided' do
    c.meta(:keywords, :type => 'user', :alt => {:action => 'index'}).should eql('testing,index,dyn_meta,user')
  end

  it 'should work down to the id level' do
    params.merge!(:controller => 'pages', :action => 'show', :id => 'tos')
    c.meta(:keywords).should eql('pages,show,tos,dyn_meta')
  end

  it 'should use the default when provided' do
    params.merge!(:controller => 'pages', :action => 'show', :id => nil)
    c.meta(:keywords).should eql('pages,show,default,dyn_meta')
  end

  it 'should use the top level default when no matches are found' do
    params.merge!(:controller => 'users', :action => 'show', :id => 'doug')
    c.meta(:keywords).should eql('dyn_meta')
  end

end