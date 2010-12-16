require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


describe "DynMeta" do
  
  it "should have translations loaded" do
    I18n.translate(:foo).should eql('bar')
  end
  
  it "should have dyn_meta methods included" do
    a = controller
    a.respond_to?(:page_detail).should be_true
    a.respond_to?(:page_title).should be_true
  end
  
  it "should define instance variables when they don't exist" do
    a = controller
    a.page_detail(:page_title, 'value')
    a.instance_variable_get('@page_title').should eql('value')
  end
  
  it "should return nil when trans hash doesn't exist" do
    a = controller
    a.page_description.should be_nil
  end 
  
  it "should look at controller action and id for translations" do
    a = controller(:controller => 'users', :action => 'edit')
    a.page_title.should eql("Update your account")
  end
  
  it "should fall back to default values" do
    a = controller
    a.page_title.should eql("Users, this is for you")
    a.params = {:controller => 'organizations'}
    a.page_title.should eql("My Great Startup Idea")
  end
  
  
  private
  
    def controller(params = {:controller => 'users'})
      a = ActionController::Base.new
      a.params = params
      a
    end
  
end
