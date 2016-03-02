class MockupController < ApplicationController
  layout -> {
    case params[:page]
    when 'ware_show'
      'mockup_course_ware'
    else
      'mockup'
    end
  }

  def page
    @page_name = params[:page]
    case @page_name
    when 'courses'
      get_courses_data
    when 'course_show'
      get_course_show_data
    when 'ware_show'
      get_ware_show_data
    end
  end

  def get_courses_data
    @component_data = [
      {
        id: '1',
        link: "/mockup/course_show",
        img: 'http://i.teamkn.com/i/dHCg8ulr.png',
        name: '农业电商：找到合适的电商平台',
        desc: '农民朋友在做电商的时候如果选择电商平台，各个电商平台主要面对的市场是什么？本节课程帮助你理解电商平台，帮助你选择电商平台...',
        instructor: '美客商学院',
        published_at: '2015-03-17'
      },
      {
        id: '2',
        link: "/mockup/course_show",
        img: 'http://i.teamkn.com/i/RO62ePgE.png',
        name: '淘宝规则：淘宝信用评价那些事儿',
        desc: '信用评价是掌握店铺权重的核心技术，掌握信用评价掌握店铺权重...',
        instructor: '美客商学院',
        published_at: '2015-03-17'
      },
      {
        id: '3',
        link: "/mockup/course_show",
        img: 'http://i.teamkn.com/i/RsDd9YIG.png',
        name: '淘大讲师专场：淘宝规则',
        desc: '【淘大讲师与你有约】为你详解买家与卖家规则及处罚申诉流程，客服必看 新手必备！',
        instructor: '美客商学院',
        published_at: '2015-03-17'
      },
      {
        id: '4',
        link: "/mockup/course_show",
        img: 'http://i.teamkn.com/i/Vhqq2y4s.png',
        name: '淘大讲师专场：淘宝规则',
        desc: '【淘大讲师与你有约】为你详解买家与卖家规则及处罚申诉流程，客服必看 新手必备！本节课为您一一揭晓答案...',
        instructor: '美客商学院',
        published_at: '2015-03-17'
      },
      {
        id: '5',
        link: "/mockup/course_show",
        img: 'http://i.teamkn.com/i/rAWqREdl.png',
        name: '淘大讲师专场：淘宝规则',
        desc: '【淘大讲师与你有约】为你详解买家与卖家规则及处罚申诉流程，客服必看 新手必备！本节课为您一一揭晓答案...',
        instructor: '美客商学院',
        published_at: '2015-03-17'
      },
      {
        id: '6',
        link: "/mockup/course_show",
        img: 'http://i.teamkn.com/i/M8lbQ67z.png',
        name: '淘大讲师专场：淘宝规则',
        desc: '【淘大讲师与你有约】为你详解买家与卖家规则及处罚申诉流程，客服必看 新手必备！本节课为您一一揭晓答案...',
        instructor: '美客商学院',
        published_at: '2015-03-17'
      },
      {
        id: '7',
        link: "/mockup/course_show",
        img: 'http://i.teamkn.com/i/RYJ5MOCG.png',
        name: '淘大讲师专场：淘宝规则',
        desc: '【淘大讲师与你有约】为你详解买家与卖家规则及处罚申诉流程，客服必看 新手必备！本节课为您一一揭晓答案...',
        instructor: '美客商学院',
        published_at: '2015-03-17'
      },
      {
        id: '8',
        link: "/mockup/course_show",
        img: 'http://i.teamkn.com/i/NHZUvhjk.png',
        name: '淘大讲师专场：淘宝规则',
        desc: '【淘大讲师与你有约】为你详解买家与卖家规则及处罚申诉流程，客服必看 新手必备！本节课为您一一揭晓答案...',
        instructor: '美客商学院',
        published_at: '2015-03-17'
      },
      {
        id: '9',
        link: "/mockup/course_show",
        img: 'http://i.teamkn.com/i/MvoCifwZ.jpg',
        name: '淘大讲师专场：淘宝规则',
        desc: '【淘大讲师与你有约】为你详解买家与卖家规则及处罚申诉流程，客服必看 新手必备！本节课为您一一揭晓答案...',
        instructor: '美客商学院',
        published_at: '2015-03-17'
      },
      {
        id: '10',
        link: "/mockup/course_show",
        img: 'http://i.teamkn.com/i/R789g1D1.png',
        name: '淘大讲师专场：淘宝规则',
        desc: '【淘大讲师与你有约】为你详解买家与卖家规则及处罚申诉流程，客服必看 新手必备！本节课为您一一揭晓答案...',
        instructor: '美客商学院',
        published_at: '2015-03-17'
      }
    ]
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

  SAMPLE_WARES_DATA = [
    {
      id: '1', name:'农民朋友做农产品如何选择电商平台', kind: 'video', learned: 'done', time: '37′12″',
      video_url: 'http://movie.ks.js.cn/flv/other/1_0.mp4'
    },
    {
      id: '2', name:'教做农产品的朋友认识天猫平台', kind: 'video', learned: 'half', time: '37′12″',
      video_url: 'http://mediaelementjs.com/media/echo-hereweare.mp4'
    },
    {id: '3', name:'教做农产品的朋友认识淘宝平台', kind: 'video', learned: 'no', time: '37′12″'},
    {id: '4', name:'电子商务和物流的基础概念', kind: 'document', learned: 'no'},
  ]

  SAMPLE_COURSE_DATA = {
    id: '1',
    link: "/mockup/course_show",
    img: 'http://i.teamkn.com/i/dHCg8ulr.png',
    name: '农业电商：找到合适的电商平台',
    desc: '农民朋友在做电商的时候如果选择电商平台，各个电商平台主要面对的市场是什么？本节课程帮助你理解电商平台，帮助你选择电商平台...',
    instructor: '美客商学院',
    published_at: '2015-03-17',

    subject: '电子商务',
    price: '免费',
    effort: '4 个视频，合计 120 分钟；有结课测验；',

    chapters: [
      name: '电商基础',
      wares: SAMPLE_WARES_DATA
    ]
  }
end