class Manage::DocumentsController < BaseGenericController
  before_filter :authenticate_user!
  
  set_model DocumentsStore::Document,
            :allow_attrs => [:title, :content, :creator_id, :last_editor_id]

  before_action :_get_net, :only => [:index, :create, :new]
  def _get_net
    @net = KnowledgeNetStore::Net.find params[:net_id]
  end

  def index
    @documents = @net.documents
  end

  def create
    criteria = @net.documents.where(:creator => current_user)
    document = criteria.new(model_params)

    if document.save
      url = url_for([:manage, document])
      return redirect_to url if !request.xhr?
      return render :json => {:url => url}
    end
    
    url = url_for([:new, :manage, @net, :documents])
    return redirect_to url if !request.xhr?
    return render :json => {:error => '创建失败'}, :status => 400
  end

  show_with do
    # 最后编辑者
    @last_editor = User.find(@document.last_editor_id)
  end

  # TODO: 等 kaid 修改了 generic_controller 后
  # 替换回 update_with
  def update
    @document = model_instance
    @document.attributes = model_params

    if @document.changed?
      @document.last_editor = current_user
      @document.save
    end

    if @document.valid?
      url = url_for([:manage, @document])
      return redirect_to url if !request.xhr?
      return render :json => {:url => url}
    end

    url = url_for([:edit, :manage, @document])
    return redirect_to url if !request.xhr?
    return render :json => {:error => '修改失败'}, :status => 400
  end

  destroy_with do
    redirect_to "/manage/nets/#{@document.net.id}/documents"
  end

  def versions
    find_model_instance
  end

  def version
    find_model_instance
    @version = @document.versions.find_by(:version => params[:version])
    @editor = User.find(@version.last_editor_id)
  end
end
