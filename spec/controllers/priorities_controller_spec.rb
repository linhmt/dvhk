require 'spec_helper'

describe PrioritiesController do

  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all priorities as @priorities" do
      priority = Priority.create! valid_attributes
      get :index
      assigns(:priorities).should eq([priority])
    end
  end

  describe "GET show" do
    it "assigns the requested priority as @priority" do
      priority = Priority.create! valid_attributes
      get :show, :id => priority.id
      assigns(:priority).should eq(priority)
    end
  end

  describe "GET new" do
    it "assigns a new priority as @priority" do
      get :new
      assigns(:priority).should be_a_new(Priority)
    end
  end

  describe "GET edit" do
    it "assigns the requested priority as @priority" do
      priority = Priority.create! valid_attributes
      get :edit, :id => priority.id
      assigns(:priority).should eq(priority)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Priority" do
        expect {
          post :create, :priority => valid_attributes
        }.to change(Priority, :count).by(1)
      end

      it "assigns a newly created priority as @priority" do
        post :create, :priority => valid_attributes
        assigns(:priority).should be_a(Priority)
        assigns(:priority).should be_persisted
      end

      it "redirects to the created priority" do
        post :create, :priority => valid_attributes
        response.should redirect_to(Priority.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved priority as @priority" do
        # Trigger the behavior that occurs when invalid params are submitted
        Priority.any_instance.stub(:save).and_return(false)
        post :create, :priority => {}
        assigns(:priority).should be_a_new(Priority)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Priority.any_instance.stub(:save).and_return(false)
        post :create, :priority => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested priority" do
        priority = Priority.create! valid_attributes
        # Assuming there are no other priorities in the database, this
        # specifies that the Priority created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Priority.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => priority.id, :priority => {'these' => 'params'}
      end

      it "assigns the requested priority as @priority" do
        priority = Priority.create! valid_attributes
        put :update, :id => priority.id, :priority => valid_attributes
        assigns(:priority).should eq(priority)
      end

      it "redirects to the priority" do
        priority = Priority.create! valid_attributes
        put :update, :id => priority.id, :priority => valid_attributes
        response.should redirect_to(priority)
      end
    end

    describe "with invalid params" do
      it "assigns the priority as @priority" do
        priority = Priority.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Priority.any_instance.stub(:save).and_return(false)
        put :update, :id => priority.id, :priority => {}
        assigns(:priority).should eq(priority)
      end

      it "re-renders the 'edit' template" do
        priority = Priority.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Priority.any_instance.stub(:save).and_return(false)
        put :update, :id => priority.id, :priority => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested priority" do
      priority = Priority.create! valid_attributes
      expect {
        delete :destroy, :id => priority.id
      }.to change(Priority, :count).by(-1)
    end

    it "redirects to the priorities list" do
      priority = Priority.create! valid_attributes
      delete :destroy, :id => priority.id
      response.should redirect_to(priorities_url)
    end
  end

end
