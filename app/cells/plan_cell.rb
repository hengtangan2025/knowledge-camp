class PlanCell < Cell::Rails
  include KnowledgeNetPlanStore
  
  def list
    @plans = Plan.all.order_by("updated_at DESC")
    render
  end

  def form(option)
    @plan = option[:plan]
    if @plan.new_record?
      @url = "/plans"
      @h2  = "新建教学计划 …"
    else
      @url = "/plans/#{@plan.id}"
      @h2  = "编辑教学计划 …"
    end

    render
  end
end