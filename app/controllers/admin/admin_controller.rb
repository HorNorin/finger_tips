class Admin::AdminController < ApplicationController
  before_action :access_denied
  
  layout "layouts/admin/application"
end
