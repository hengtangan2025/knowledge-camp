class Bank::Manage::WaresController < Bank::Manage::ApplicationController
  before_action :set_chapter, only: [:new, :create]
  def show
    @ware = current_user.wares.find params[:id]
  end

  def new
    @ware = current_user.wares.new chapter: @chapter
  end

  def create
    @file_entity_kind = FilePartUpload::FileEntity.find(ware_params[:file_entity_id]).kind unless ware_params[:file_entity_id].blank?
    case @file_entity_kind
    when 'video'
      @ware = KcCourses::SimpleVideoWare.new ware_params.merge(chapter_id: @chapter.id, user_id: current_user.id)
    when 'audio'
      @ware = KcCourses::SimpleAudioWare.new ware_params.merge(chapter_id: @chapter.id, user_id: current_user.id)
    when 'pdf', 'office'
      @ware = KcCourses::SimpleDocumentWare.new ware_params.merge(chapter_id: @chapter.id, user_id: current_user.id)
    else
      @ware = current_user.wares.new ware_params.merge(chapter: @chapter)
    end
    return redirect_to [:bank, :manage, @chapter] if @ware.save
    render :action => :new
  end

  def edit
    @ware = current_user.wares.find(params[:id])
  end


  def update
    @ware = current_user.wares.find(params[:id])
    return redirect_to [:bank, :manage, @ware.chapter] if @ware.update_attributes ware_params
    render :action => :new
  end

  def destroy
    @ware = current_user.wares.find(params[:id])
    @chapter = @ware.chapter
    @ware.destroy
    redirect_to [:bank, :manage, @chapter]
  end

  def move_up
    @ware = current_user.wares.find(params[:id])
    @chapter = @ware.chapter
    @ware.move_up

    return redirect_to [:bank, :manage, @chapter]
  end

  def move_down
    @ware = current_user.wares.find(params[:id])
    @chapter = @ware.chapter
    @ware.move_down

    return redirect_to [:bank, :manage, @chapter]
  end

  protected
  def set_chapter
    @chapter = current_user.chapters.find params[:chapter_id]
  end

  def ware_params
    params.require(:ware).permit(:title, :desc, :file_entity_id)
  end
end
