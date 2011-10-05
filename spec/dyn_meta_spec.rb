require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


describe "DynMeta" do
  
  it "should have translations loaded" do
    I18n.translate(:foo).should eql('bar')
  end
  
  it "should have dyn_meta methods included" do
    a = controller
    a.respond_to?(:meta).should be_true
  end
  
  it "should define instance variables when they don't exist" do
    a = controller
    a.instance_variable_get('@meta_title').should be_nil
    a.meta(:title, 'value')
    a.instance_variable_get('@meta_title').should eql('value')
  end
  
  it "should return nil when trans hash doesn't exist" do
    a = controller
    a.meta(:description).should be_nil
  end 
  
  it "should look at controller action and id for translations" do
    a = controller(:controller => 'users', :action => 'edit')
    a.meta(:title).should eql("Update your account")
    a.meta(:title).should eql("Update your account")
  end
  
  it "should fall back to default values" do
    controller.meta(:title).should eql("Users, this is for you")
    controller({:controller => 'organizations'}).meta(:title).should eql("My Great Startup Idea")
  end
  
  
  private
  
    def controller(params = {:controller => 'users'})
      a = ActionController::Base.new
      a.params = params
      a
    end
  
end
