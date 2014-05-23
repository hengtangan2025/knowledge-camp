# coding: utf-8
module PlanStoreHelper
  def plan_store_form_for(model, url)
    locals = {
      :model => model,
      :url   => url
    }


    render :partial => "/plan_store_partials/form",
           :locals  => locals
  end

  def delete_link(text, href, klass: "")
    data = {:confirm => "确定删除?"}
    link_to text, href, :method => :delete, :data => data, :class => klass
  end
end
