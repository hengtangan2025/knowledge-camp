module Explore
  module ApplicationHelper
    def progress_circle(percent)
      # .page-progress-circle{:data => {:percent => percent}}
      #   %canvas{:width => 30, :height => 30}
      #   .percent
      #     %span.num>= percent
      #     %span.per> %

      if percent < 100
        capture_haml {
          haml_tag '.page-progress-circle', :data => {:percent => percent} do
            haml_tag 'canvas', :width => 30, :height => 30
            haml_tag '.percent' do
              haml_tag 'span.num', percent
              haml_tag 'span.per', '%'
            end
          end
        }
      else
        capture_haml {
          haml_tag 'div.page-progress-circle.done', :data => {:percent => percent} do
            haml_tag 'i.fa.fa-check'
          end
        }
      end
    end

    def tutorial_percent(tid)
      arr = [
        "sample-2",
        "sample-4",
        "sample-6",

        "sample-2-1",
        "sample-2-2",
        "sample-2-3",
        "sample-2-5",
        "sample-2-7"
      ]

      return 100 if arr.include? tid

      @_ts ||= Explore::Mock.tutorials
      t = @_ts.select {|x| x.id == tid}.first
      (100.0 / t.steps.count).round
    end
  end
end