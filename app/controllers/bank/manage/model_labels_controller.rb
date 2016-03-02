class Bank::Manage::ModelLabelsController < Bank::Manage::ApplicationController
  def index
    @model_labels = ModelLabel::Label.all.page(params[:page]).per(16)

    if !params[:name].blank?
      model = ModelLabel.get_model_by_name(params[:name])
      @model_labels = @model_labels.with_model(model)
    end
  end

  def new
    model = ModelLabel.get_model_by_name(params[:name])
    if model.blank?
      return render :status => 422, :text => 422
    end
    @model_label = ModelLabel::Label.new(:model => model.to_s)
  end

  def edit
    @model_label = ModelLabel::Label.find params[:id]
  end

  def update
    @model_label = ModelLabel::Label.find params[:id]
    attrs = label_params
    attrs[:values] = attrs[:values].split(" ")
    if @model_label.save
      redirect_to bank_manage_model_labels_path
    else
      render :edit
    end
  end

  def create
    attrs = label_params
    attrs[:values] = attrs[:values].split(" ")

    @model_label = ModelLabel::Label.new(attrs)
    if @model_label.save
      redirect_to bank_manage_model_labels_path
    else
      render :new
    end
  end

  def destroy
    @model_label = ModelLabel::Label.find params[:id]
    @model_label.destroy
    redirect_to bank_manage_model_labels_path
  end


  def label_params
    params.require(:label).permit(:model, :name, :values)
  end
end
