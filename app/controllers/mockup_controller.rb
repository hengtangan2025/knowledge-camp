class MockupController < ApplicationController
  layout -> {
    case params[:page]
    when 'sign_in'
      if params[:role]
        'mockup_manager_auth'
      else
        'mockup'
      end
    when 'manager_home'
      'mockup_manager'
    when 'ware_show'
      'mockup_course_ware'
    else
      'mockup'
    end
  }

  def page
    @page_name = params[:page]
    case @page_name

    when 'home'
      get_home_data

    when 'sign_in'
      get_sign_in_data
    when 'sign_up'
      get_sign_up_data

    when 'courses'
      get_courses_data
    when 'course_show'
      get_course_show_data
    when 'ware_show'
      get_ware_show_data
    end
  end

  def do_post
    data = 
      case params[:req]
      when 'do_sign_in'
        post_do_sign_in
      when 'do_sign_up'
        post_do_sign_up
      end
  end

  def do_delete
    render json: {}
  end

  def post_do_sign_in
    if params[:user][:email].blank?
      data = { error: "用户名/密码不对" }
      render status: 401, json: data

    else
      data = {
        _id: {
          "$oid" => "569316116675730f7d000000",
        },
        avatar: {
          url: "/assets/default_avatars/avatar_200.png",
          large:{ url: "/assets/default_avatars/large.png"},
          normal:{ url: "/assets/default_avatars/normal.png"},
          small:{ url: "/assets/default_avatars/small.png"}
        },
        created_at: "2016-01-11T10:40:17.647+08:00",
        email: "root@root.com",
        login: "root",
        name: "root",
        updated_at: "2016-03-11T13:07:32.765+08:00"
      }
      render json: data
    end
  end

  def post_do_sign_up
    if params[:user][:name].blank?
      data = { errors: {
        email: ['邮箱没填'],
        password: ['密码没填', '密码太短'],
        name: ['啥都没填'],
      } }
      render status: 422, json: data

    else
      data = {
        _id: {
          "$oid" => "569316116675730f7d000000",
        },
        avatar: {
          url: "/assets/default_avatars/avatar_200.png",
          large:{ url: "/assets/default_avatars/large.png"},
          normal:{ url: "/assets/default_avatars/normal.png"},
          small:{ url: "/assets/default_avatars/small.png"}
        },
        created_at: "2016-01-11T10:40:17.647+08:00",
        email: "root@root.com",
        login: "root",
        name: "root",
        updated_at: "2016-03-11T13:07:32.765+08:00"
      }
      render json: data
    end
  end

  def get_home_data
    @component_data = {
      manager_sign_in_url: mockup_url(page: 'sign_in', role: 'manager')
    }
  end

  def get_sign_in_data
    if params[:role] == 'manager'
      @component_name = 'ManagerSignInPage'
      @component_data = {
        submit_url: mockup_url(page: 'do_sign_in'),
        manager_home_url: mockup_url(page: 'manager_home'),
      }
    else
      @component_data = {
        sign_in_url: mockup_url(page: 'sign_in'),
        sign_up_url: mockup_url(page: 'sign_up'),
        submit_url: mockup_url(page: 'do_sign_in')
      }
    end
  end

  def get_sign_up_data
    @component_data = {
      sign_in_url: mockup_url(page: 'sign_in'),
      sign_up_url: mockup_url(page: 'sign_up'),
      submit_url: mockup_url(page: 'do_sign_up')
    }
  end

  def get_courses_data
    @component_data = {
      courses: SAMPLE_COURSES_DATA,
      paginate: SAMPLE_PAGINATE_DATA
    }
  end

  def get_course_show_data
    @component_data = SAMPLE_COURSE_DATA
  end

  def get_ware_show_data
    @component_data = {
      comments: [
        {
          author: {
            name: '若水之约',
            avatar: 'http://i.teamkn.com/i/mT5dd6tj.png',
          },
          content: '好，很细致',
          date: '2016-02-02',
        },
        {
          author: {
            name: 'ia0020028',
            avatar: 'http://i.teamkn.com/i/c0qMJWx9.png',
          },
          content: '讲得蛮好，课程再出多些就好了，期待后续',
          date: '2016-02-02',
        },
        {
          author: {
            name: '轩维诗',
            avatar: 'http://i.teamkn.com/i/ws2SUCrM.png',
          },
          content: '很详细，就是太累了',
          date: '2016-02-02',
        },
      ],
      course: SAMPLE_COURSE_DATA,
      ware: SAMPLE_WARES_DATA.select {|x| x[:id] == params[:id]}.first
    }
  end

  SAMPLE_PAGINATE_DATA = {
    total_pages: 12,
    current_page: 5,
    per_page: 25
  }  

  SAMPLE_COURSES_DATA = [
    {
      id: '1',
      url: "/mockup/course_show",
      img: 'http://i.teamkn.com/i/dHCg8ulr.png',
      name: '农业电商：找到合适的电商平台',
      desc: '农民朋友在做电商的时候如果选择电商平台，各个电商平台主要面对的市场是什么？本节课程帮助你理解电商平台，帮助你选择电商平台...',
      instructor: '美客商学院',
      published_at: '2015-03-17'
    },
    {
      id: '2',
      url: "/mockup/course_show",
      img: 'http://i.teamkn.com/i/RO62ePgE.png',
      name: '淘宝规则：淘宝信用评价那些事儿',
      desc: '信用评价是掌握店铺权重的核心技术，掌握信用评价掌握店铺权重...',
      instructor: '美客商学院',
      published_at: '2015-03-17'
    },
    {
      id: '3',
      url: "/mockup/course_show",
      img: 'http://i.teamkn.com/i/RsDd9YIG.png',
      name: '淘大讲师专场：淘宝规则',
      desc: '【淘大讲师与你有约】为你详解买家与卖家规则及处罚申诉流程，客服必看 新手必备！',
      instructor: '美客商学院',
      published_at: '2015-03-17'
    },
    {
      id: '4',
      url: "/mockup/course_show",
      img: 'http://i.teamkn.com/i/Vhqq2y4s.png',
      name: '淘大讲师专场：淘宝规则',
      desc: '【淘大讲师与你有约】为你详解买家与卖家规则及处罚申诉流程，客服必看 新手必备！本节课为您一一揭晓答案...',
      instructor: '美客商学院',
      published_at: '2015-03-17'
    },
    {
      id: '5',
      url: "/mockup/course_show",
      img: 'http://i.teamkn.com/i/rAWqREdl.png',
      name: '淘大讲师专场：淘宝规则',
      desc: '【淘大讲师与你有约】为你详解买家与卖家规则及处罚申诉流程，客服必看 新手必备！本节课为您一一揭晓答案...',
      instructor: '美客商学院',
      published_at: '2015-03-17'
    },
    {
      id: '6',
      url: "/mockup/course_show",
      img: 'http://i.teamkn.com/i/M8lbQ67z.png',
      name: '淘大讲师专场：淘宝规则',
      desc: '【淘大讲师与你有约】为你详解买家与卖家规则及处罚申诉流程，客服必看 新手必备！本节课为您一一揭晓答案...',
      instructor: '美客商学院',
      published_at: '2015-03-17'
    },
    {
      id: '7',
      url: "/mockup/course_show",
      img: 'http://i.teamkn.com/i/RYJ5MOCG.png',
      name: '淘大讲师专场：淘宝规则',
      desc: '【淘大讲师与你有约】为你详解买家与卖家规则及处罚申诉流程，客服必看 新手必备！本节课为您一一揭晓答案...',
      instructor: '美客商学院',
      published_at: '2015-03-17'
    },
    {
      id: '8',
      url: "/mockup/course_show",
      img: 'http://i.teamkn.com/i/NHZUvhjk.png',
      name: '淘大讲师专场：淘宝规则',
      desc: '【淘大讲师与你有约】为你详解买家与卖家规则及处罚申诉流程，客服必看 新手必备！本节课为您一一揭晓答案...',
      instructor: '美客商学院',
      published_at: '2015-03-17'
    },
    {
      id: '9',
      url: "/mockup/course_show",
      img: 'http://i.teamkn.com/i/MvoCifwZ.jpg',
      name: '淘大讲师专场：淘宝规则',
      desc: '【淘大讲师与你有约】为你详解买家与卖家规则及处罚申诉流程，客服必看 新手必备！本节课为您一一揭晓答案...',
      instructor: '美客商学院',
      published_at: '2015-03-17'
    },
    {
      id: '10',
      url: "/mockup/course_show",
      img: 'http://i.teamkn.com/i/R789g1D1.png',
      name: '淘大讲师专场：淘宝规则',
      desc: '【淘大讲师与你有约】为你详解买家与卖家规则及处罚申诉流程，客服必看 新手必备！本节课为您一一揭晓答案...',
      instructor: '美客商学院',
      published_at: '2015-03-17'
    }
  ]

  SAMPLE_WARES_DATA = [
    {
      id: '1', name:'农民朋友做农产品如何选择电商平台', kind: 'video', learned: 'done', time: '37′12″',
      url: "/mockup/ware_show?id=1",
      video_url: 'http://movie.ks.js.cn/flv/other/1_0.mp4'
    },
    {
      id: '2', name:'教做农产品的朋友认识天猫平台', kind: 'video', learned: 'half', time: '37′12″',
      url: "/mockup/ware_show?id=2",
      video_url: 'http://mediaelementjs.com/media/echo-hereweare.mp4'
    },
    {
      id: '3', name:'教做农产品的朋友认识淘宝平台', kind: 'video', learned: 'no', time: '37′12″',
      url: "/mockup/ware_show?id=3",
    },
    {
      id: '4', name:'电子商务和物流的基础概念', kind: 'document', learned: 'no',
      url: "/mockup/ware_show?id=4",
    },
  ]

  SAMPLE_COURSE_DATA = {
    id: '1',
    url: "/mockup/course_show",
    img: 'http://i.teamkn.com/i/dHCg8ulr.png',
    name: '农业电商：找到合适的电商平台',
    desc: '农民朋友在做电商的时候如果选择电商平台，各个电商平台主要面对的市场是什么？本节课程帮助你理解电商平台，帮助你选择电商平台...',
    instructor: '美客商学院',
    published_at: '2015-03-17',

    # subject: '电子商务',
    # 20160308 课程类型结构调整为数组
    subjects: [
      {name: '电子商务', url: '/mockup/courses?subject=1'},
      {name: '农产品销售', url: '/mockup/courses?subject=2'},
    ],

    price: '免费',
    # 20160308 这里目前先一律写免费

    # effort: '4 个视频，合计 120 分钟；有结课测验；',
    # 20160308 这里目前先只做时间统计
    effort: '4 个视频，合计 120 分钟；',

    chapters: [
      name: '电商基础',
      wares: SAMPLE_WARES_DATA
    ]
  }
end