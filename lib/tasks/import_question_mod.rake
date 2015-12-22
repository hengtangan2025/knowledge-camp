namespace :import_question_mod do
  desc "导入开发用问答数据"
  task :create => [:environment] do
    course_manager = User.where(:name => "course_manager").first
    if course_manager.blank?
      course_manager = User.create(:name => "course_manager", :login => "course_manager", :password => "1234")
    end

    develop_user = User.where(:name => "develop_user").first
    if develop_user.blank?
      develop_user = User.create(:name => "develop_user", :login => "develop_user", :password => "1234")
    end

    user_han_yang = User.where(:name => "寒杨").first
    if user_han_yang.blank?
      user_han_yang = User.create(:name => "寒杨", :login => "han_yang", :password => "1234")
    end

    user_wang_qian = User.where(:name => "汪倩").first
    if user_wang_qian.blank?
      user_wang_qian = User.create(:name => "汪倩", :login => "wang_qian", :password => "1234")
    end

    user_qiao_wei = User.where(:name => "乔玮").first
    if user_qiao_wei.blank?
      user_qiao_wei = User.create(:name => "乔玮", :login => "qiao_wei", :password => "1234")
    end

    course = KcCourses::Course.create(
      :title => "宏观经济学",
      :user  => course_manager
    )

    chapter = course.chapters.create(
      :title => "第一章",
      :desc  => "desc",
      :user  => course_manager
    )

    ware = chapter.wares.create(
      :title => "经济周期",
      :user  => course_manager
    )

    QuestionMod::Question.create(
      :title   => "作为刚进银行的基层员工，该如何规划职业生涯呢？",
      :content => "作为刚进银行的基层员工，该如何规划职业生涯呢？",
      :creator => develop_user,
      :ware => ware
    )

    question = QuestionMod::Question.create(
      :title   => "宏观经济学中关于经济周期中金融摩擦有什么前沿论文？",
      :content => "宏观经济学中关于经济周期中金融摩擦有什么前沿论文？",
      :creator => develop_user,
      :ware => ware
    )

    question.answers.create(
      :content => "先说一点文献不在于读前沿，而是在于理解脉络，没有理解脉络读再多也没有用的。高手（当然不是我）可以很快理解文章的贡献，几十秒可以就可以总结下来；如果瞎读不但浪费时间也没法把握文章精髓。题主可以关注这么几个人",
      :creator => user_han_yang
    )

    question.answers.create(
      :content => "关于金融摩擦有几篇经典",
      :creator => user_wang_qian
    )

    question.answers.create(
      :content => "关于金融摩擦有几篇经典",
      :creator => user_qiao_wei
    )


    question_a = QuestionMod::Question.create(
      :title   => "生活中有哪些「人多未必力量大」的例子？原因分别是什么？",
      :content => "生活中有哪些「人多未必力量大」的例子？原因分别是什么？",
      :creator => user_qiao_wei,
      :ware => ware
    )

    question_a.answers.create(
      :content => "一个人吃饭十分钟，两个人吃饭半小时，一群人吃饭至少得一个半小时",
      :creator => develop_user
    )
  end

end
