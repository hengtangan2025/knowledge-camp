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
        }
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
  end
end