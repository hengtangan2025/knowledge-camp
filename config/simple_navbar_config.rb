# -*- encoding : utf-8 -*-
SimpleNavbar::Base.config do

  rule :dashboard do
    nav :courses, :name => '我的课程', :url => '/bank/dashboard/courses' do
      controller :"bank/dashboard", :only => :courses

      nav :join_courses, :name => '参加的', :url => '/bank/dashboard/join_courses' do
        controller :"bank/dashboard", :only => :join_courses
      end

      nav :fav_courses, :name => '参加的', :url => '/bank/dashboard/fav_courses' do
        controller :"bank/dashboard", :only => :fav_courses
      end
    end

    nav :test_questions, :name => '我的题库', :url => '/bank/dashboard/test_questions' do
      controller :"bank/dashboard", :only => :test_questions

      nav :test_question_records, :name => '做题记录', :url => '/bank/dashboard/test_question_records' do
        controller :"bank/dashboard", :only => :test_question_records
      end

      nav :flaw_test_questions, :name => '错题本', :url => '/bank/dashboard/flaw_test_questions' do
        controller :"bank/dashboard", :only => :flaw_test_questions
      end

      nav :fav_test_questions, :name => '收藏的题目', :url => '/bank/dashboard/fav_test_questions' do
        controller :"bank/dashboard", :only => :fav_test_questions
      end
    end

    nav :questions, :name => '我的问题', :url => '/bank/dashboard/questions' do
      controller :"bank/dashboard", :only => :questions
    end

    nav :notes, :name => '我的笔记', :url => '/bank/dashboard/notes' do
      controller :"bank/dashboard", :only => :notes
    end

  end

  rule :bank_courses_index do
    nav :recent, :name => '最新', :url => '/bank/courses' do
      controller :"bank/courses", :only => :index
    end

    nav :hot, :name => '最热', :url => '/bank/courses/hot' do
      controller :"bank/courses", :only => :hot
    end
  end

  rule :bank_courses_mine do
    nav :studying, :name => '正在学习', :url => '/bank/courses/studying' do
      controller :"bank/courses", :only => %i[mine studying]
    end

    nav :fav, :name => '课程收藏', :url => '/bank/courses/fav' do
      controller :"bank/courses", :only => %i[fav]
    end

    nav :studied, :name => '已经学完', :url => '/bank/courses/studied' do
      controller :"bank/courses", :only => %i[studied]
    end
  end
end
