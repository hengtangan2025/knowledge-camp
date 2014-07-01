class Manage::DocumentVersionsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @document = DocumentsStore::Document.find params[:document_id]
  end

  def version
    @document = DocumentsStore::Document.find params[:document_id]
    version = params[:version]

    if version == @document.version.to_s
      @version = @document
    else
      @version = @document.versions.find_by(:version => version)
    end

    @last_editor = @version.last_editor
  end

  def restore
    @document = DocumentsStore::Document.find params[:document_id]
    version = params[:version]
    @version = @document.versions.find_by(:version => version)

    @document.restore_version(@version, current_user)
    redirect_to [:manage, @document]
  end
end