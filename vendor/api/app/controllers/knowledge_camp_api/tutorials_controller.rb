module KnowledgeCampApi
  class TutorialsController < ApplicationController
    def index
      display tutorial_collection.map {|tutorial| add_learned(tutorial)}
    end

    def show
      display add_learned(KnowledgeNetPlanStore::Tutorial.published.find(params[:id]))
    end

    private

    def add_learned(tutorial)
      learned = current_user.learn_records.where(:step_id.in => tutorial.step_ids).size
      all = tutorial.steps.size

      tutorial.attrs.merge(:step_count => all,
                           :learned_step_count => learned)
    end

    def tutorial_collection
      case query_key
      when :net_id
        net = KnowledgeNetStore::Net.find(params[:net_id])
        net.plans.map(&:topics).flatten.map(&:tutorials).flatten
      when :point_id
        KnowledgeNetStore::Point.find(params[:point_id]).tutorials
      when :topic_id
        KnowledgeNetPlanStore::Topic.find(params[:topic_id]).tutorials
      when :ancestor_id
        base.try :descendants
      when :parent_id
        base.try :children
      when :child_id
        base.try :parents
      when :descendant_id
        base.try :ancestors
      end || []
    end

    def base
      KnowledgeNetPlanStore::Tutorial.published.find(params[query_key])
    end

    def query_key
      first_key [
        :topic_id,
        :net_id,
        :point_id,
        :ancestor_id,
        :parent_id,
        :child_id,
        :descendant_id
      ]
    end
  end
end
