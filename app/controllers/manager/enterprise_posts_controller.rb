class Manager::EnterprisePostsController < Manager::ApplicationController
  def index
    @page_name = "manager_enterprise_posts"

    posts = EnterprisePositionLevel::Post.all.map do |post|
      DataFormer.new(post)
        .url(:delete_url)
        .url(:update_url)
        .data
    end

    @component_data = {
      posts: posts,
      create_url: manager_enterprise_posts_path
    }

    render "/mockup/page"
  end

  def create
    post = EnterprisePositionLevel::Post.new post_params
    save_model(post,"post") do |_post|
      DataFormer.new(_post)
        .url(:update_url)
        .url(:delete_url)
        .data
    end
  end

  def update
    post = EnterprisePositionLevel::Post.find params[:id]

    update_model(post, post_params, "post") do |_post|
      DataFormer.new(_post)
        .url(:update_url)
        .url(:delete_url)
        .data
    end
  end

  def destroy
    post = EnterprisePositionLevel::Post.find params[:id]
    post.destroy
    render :status => 200, :json => {:status => 'success'}
  end

  private
  def post_params
    params.require(:post).permit(:name, :number)
  end
end
