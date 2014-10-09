module CourseEditor
  class StepsController < ApplicationController
    def create
      @tutorial = KnowledgeNetPlanStore::Tutorial.find params[:tutorial_id]
      step = @tutorial.steps.create

      render :json => {
        :id => step.id.to_s,
        :title => step.title,
        :total_count => @tutorial.steps.count
      }
    end

    def destroy
      step = KnowledgeCamp::Step.find params[:id]

      parent_changes = (params[:parent_ids] || []).map do |pid|
        parent = KnowledgeCamp::Step.find pid
        _clean_continue parent, step

        {:id => pid, :continue => parent.continue}
      end

      step.destroy
      render :json => {
        :id => step.id.to_s,
        :total_count => step.stepped.steps.count,
        :parent_changes => parent_changes
      }
    end


    def _clean_continue(parent, child)
      continue = parent.continue
      return if continue.blank?
      
      child_id = child.id.to_s

      puts
      p continue
      p continue['type']
      p continue['id']
      p child.id
      puts
      

      if continue['type'] == :step && continue['id'] == child_id
        parent.set_continue false
      end

      if continue['type'] == :select
        options = continue['options']
        options.each do |o|
          o.delete 'id' if o['id'] == child_id
        end

        parent.set_continue 'select', 
          :question => continue['question'], 
          :options => options
      end
    end


    def update_continue
      step = KnowledgeCamp::Step.find params[:id]
      data = params[:continue]

      if data['kind'] == 'step'
        step.set_continue 'step', data['step_id']
      end

      if data['kind'] == 'select'
        # Parameters: {"continue"=>{"kind"=>"select", "question"=>"12", "options"=>{"0"=>{"text"=>"1212", "id"=>"54083f4f6c696e4a42050000"}, "1"=>{"text"=>"1212", "id"=>"54083f506c696e4a42060000"}}}, "id"=>"54083f3e6c696e4a42040000"}

        step.set_continue 'select', :question => data['question'], :options => data['options'].values
      end

      if data == 'end'
        step.set_continue false
      end

      render :json => step.continue
    end

    def update_title
      step = KnowledgeCamp::Step.find params[:id]
      step.title = params[:title]
      step.save

      render :json => {
        :title => step.title
      }

    end

    def load_content
      step = KnowledgeCamp::Step.find params[:id]
      render :json => {
        :blocks => step.blocks.map {|b|
          h = {}
          h['id'] = b.id.to_s
          h['kind'] = b.kind
          h['content'] = b.content
          h
        }
      }
    end

    def add_content
      step = KnowledgeCamp::Step.find params[:id]
      if params[:kind] == 'text'
        step.add_content 'text', params[:data]
      end

      block = step.blocks.last

      render :json => {
        :block => {
          :id => block.id.to_s,
          :kind => block.kind,
          :content => block.content
        },
        :html => (
          render_cell 'course_editor/step', :blocks, [block]
        )
      }
    end

    def delete_content
      step = KnowledgeCamp::Step.find params[:id]
      step.remove_content params[:block_id]
      render :json => {
        :status => :ok
      }
    end

    def update_content
      block = KnowledgeCamp::Block.find params[:block_id]
      block.content = params[:content]
      block.save
      render :json => {
        :block => {
          :id => block.id.to_s,
          :kind => block.kind,
          :content => block.content
        }
      }
    end

    # -------------------

    # 在简单线性关联结构中删除 step 
    def simple_delete
      step = KnowledgeCamp::Step.find params[:id]

      prev_id = params[:prev_id]
      next_id = params[:next_id]

      # 如果有前后关联，处理关联关系
      if prev_id
        prev_step = KnowledgeCamp::Step.find prev_id
        _set_next prev_step, next_id
      end

      step.destroy

      render :json => {
        :id => step.id.to_s,
        :total_count => step.stepped.steps.count,
        :prev_id => prev_id,
        :next_id => next_id
      }
    end

    # 在简单线性关联结构中增加 step
    def simple_add
      prev_step = KnowledgeCamp::Step.find params[:id]
      tutorial = prev_step.stepped
      step = tutorial.steps.create

      prev_step.set_continue 'step', step.id

      next_id = params[:next_id]
      if next_id
        step.set_continue 'step', next_id
      end

      render :json => {
        :id => step.id.to_s,
        :total_count => step.stepped.steps.count,
        :step_id => params[:id],
        :next_id => next_id
      }
    end

    # 简单关联结构中上移
    def simple_up
      prev_prev_id = params[:prev_prev_id]
      prev_id      = params[:prev_id]
      next_id      = params[:next_id]

      step = _find params[:id]

      if prev_prev_id
        prev_prev_step = _find prev_prev_id
        prev_prev_step.set_continue 'step', step.id
      end

      step.set_continue 'step', prev_id

      prev_step = _find prev_id

      _set_next prev_step, next_id

      render :json => {
        :id => step.id.to_s
      }
    end


    def simple_down
      next_next_id = params[:next_next_id]
      next_id      = params[:next_id]
      prev_id      = params[:prev_id]

      step = _find params[:id]

      prev_step = _find prev_id
      next_step = _find next_id

      prev_step.set_continue 'step', next_id
      next_step.set_continue 'step', step.id
      _set_next step, next_next_id

      render :json => {
        :id => step.id.to_s
      }
    end


    def simple_load_content_html
      step = KnowledgeCamp::Step.find params[:id]
      render :json => {
        :html => (
          render_cell 'course_editor/step', :blocks, step.blocks
        )
      }
    end


    private
      def _find(id)
        KnowledgeCamp::Step.find id
      end

      def _set_next(step, id)
        if id
          step.set_continue 'step', id
          return
        end

        step.set_continue false
      end
  end
end