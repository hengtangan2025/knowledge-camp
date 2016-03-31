module Mockup::SampleData
  SAMPLE_COMMENTS_DATA = [
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
  ]

  SAMPLE_USER_DATA = {
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
      video_url: 'http://7xie1v.com1.z0.glb.clouddn.com/static_filesACU_Trailer_480.mp4'
    },
    {
      id: '4', name:'神奇的视频', kind: 'video', learned: 'no', time: '37′12″',
      url: "/mockup/ware_show?id=3",
      video_url: 'http://mockups.mindpin.com/TaobaoEdu_teaching.mp4'
    },
    {
      id: '5', name:'电子商务和物流的基础概念', kind: 'document', learned: 'no',
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
      id: 'c1',
      name: '电商基础',
      wares: SAMPLE_WARES_DATA
    ]
  }

  SAMPLE_CHAPTER_DATA = {
    id: 'ch1',
    name: '未命名章节'
  }

  SAMPLE_COURSES_DATA = [
    {
      id: '1',
      url: "/mockup/course_show",
      img: 'http://i.teamkn.com/i/dHCg8ulr.png',
      name: '农业电商：找到合适的电商平台',
      desc: '农民朋友在做电商的时候如果选择电商平台，各个电商平台主要面对的市场是什么？本节课程帮助你理解电商平台，帮助你选择电商平台...',
      instructor: '美客商学院',
      updated_at: '2015-03-17',
      published_at: '2015-03-17'
    },
    {
      id: '2',
      url: "/mockup/course_show",
      img: 'http://i.teamkn.com/i/RO62ePgE.png',
      name: '淘宝规则：淘宝信用评价那些事儿',
      desc: '信用评价是掌握店铺权重的核心技术，掌握信用评价掌握店铺权重...',
      instructor: '美客商学院',
      updated_at: '2015-03-17',
      published_at: '2015-03-17'
    },
    {
      id: '3',
      url: "/mockup/course_show",
      img: 'http://i.teamkn.com/i/RsDd9YIG.png',
      name: '淘大讲师专场：淘宝规则',
      desc: '【淘大讲师与你有约】为你详解买家与卖家规则及处罚申诉流程，客服必看 新手必备！',
      instructor: '美客商学院',
      updated_at: '2015-03-17',
      published_at: '2015-03-17'
    },
    {
      id: '4',
      url: "/mockup/course_show",
      img: 'http://i.teamkn.com/i/Vhqq2y4s.png',
      name: '淘大讲师专场：淘宝规则',
      desc: '【淘大讲师与你有约】为你详解买家与卖家规则及处罚申诉流程，客服必看 新手必备！本节课为您一一揭晓答案...',
      instructor: '美客商学院',
      updated_at: '2015-03-17',
      published_at: '2015-03-17'
    },
    {
      id: '5',
      url: "/mockup/course_show",
      img: 'http://i.teamkn.com/i/rAWqREdl.png',
      name: '淘大讲师专场：淘宝规则',
      desc: '【淘大讲师与你有约】为你详解买家与卖家规则及处罚申诉流程，客服必看 新手必备！本节课为您一一揭晓答案...',
      instructor: '美客商学院',
      updated_at: '2015-03-17',
      published_at: '2015-03-17'
    },
    {
      id: '6',
      url: "/mockup/course_show",
      img: 'http://i.teamkn.com/i/M8lbQ67z.png',
      name: '淘大讲师专场：淘宝规则',
      desc: '【淘大讲师与你有约】为你详解买家与卖家规则及处罚申诉流程，客服必看 新手必备！本节课为您一一揭晓答案...',
      instructor: '美客商学院',
      updated_at: '2015-03-17',
      published_at: '2015-03-17'
    },
    {
      id: '7',
      url: "/mockup/course_show",
      img: 'http://i.teamkn.com/i/RYJ5MOCG.png',
      name: '淘大讲师专场：淘宝规则',
      desc: '【淘大讲师与你有约】为你详解买家与卖家规则及处罚申诉流程，客服必看 新手必备！本节课为您一一揭晓答案...',
      instructor: '美客商学院',
      updated_at: '2015-03-17',
      published_at: '2015-03-17'
    },
    {
      id: '8',
      url: "/mockup/course_show",
      img: 'http://i.teamkn.com/i/NHZUvhjk.png',
      name: '淘大讲师专场：淘宝规则',
      desc: '【淘大讲师与你有约】为你详解买家与卖家规则及处罚申诉流程，客服必看 新手必备！本节课为您一一揭晓答案...',
      instructor: '美客商学院',
      updated_at: '2015-03-17',
      published_at: '2015-03-17'
    },
    {
      id: '9',
      url: "/mockup/course_show",
      img: 'http://i.teamkn.com/i/MvoCifwZ.jpg',
      name: '淘大讲师专场：淘宝规则',
      desc: '【淘大讲师与你有约】为你详解买家与卖家规则及处罚申诉流程，客服必看 新手必备！本节课为您一一揭晓答案...',
      instructor: '美客商学院',
      updated_at: '2015-03-17',
      published_at: '2015-03-17'
    },
    {
      id: '10',
      url: "/mockup/course_show",
      img: 'http://i.teamkn.com/i/R789g1D1.png',
      name: '淘大讲师专场：淘宝规则',
      desc: '【淘大讲师与你有约】为你详解买家与卖家规则及处罚申诉流程，客服必看 新手必备！本节课为您一一揭晓答案...',
      instructor: '美客商学院',
      updated_at: '2015-03-17',
      published_at: '2015-03-17'
    }
  ]

  SAMPLE_CSUBJECTS_DATA = {
    items: [
      { 
        id: '1', 
        name: '个人电商', slug: 'ge-ren-dian-shang', courses_count: 3,
      },

      {
        id: '11',
        name: '农业电商', slug: 'nong-ye-dian-shang', courses_count: 1,
      },

      {
        id: 'c1',
        name: 'FENLEI1', slug: 'fen-lei-1', courses_count: 2,
      },

      {
        id: 'c111',
        name: 'FENLEI111', slug: 'fen-lei-111', courses_count: 2,
      },

      {
        id: 'c11',
        name: 'FENLEI11', slug: 'fen-lei-11', courses_count: 3,
      },

      {
        id: 'c2',
        name: 'FENLEI2', slug: 'fen-lei-2', courses_count: 2,
      },

      {
        id: 'c3',
        name: 'FENLEI3', slug: 'fen-lei-3', courses_count: 2,
      },

      {
        id: '12',
        name: '淘宝规则', slug: 'tao-bao-gui-ze', courses_count: 2,
      },

      {
        id: '2',
        name: '企业电商', slug: 'qi-ye-dian-shang', courses_count: 5,
      },

      {
        id: '3',
        name: '虚拟服务电商', slug: 'xu-ni-fu-wu', courses_count: 5,
      }
    ],

    relations: [
      ['1', '11'], ['1', '12'],
      ['11', 'c1'], ['11', 'c2'], ['11', 'c3'],
      ['c1', 'c11'],
      ['c11', 'c111']
    ]
  }

  SAMPLE_PAGINATE_DATA = {
    total_pages: 12,
    current_page: 5,
    per_page: 25,
    total_count: 291
  }
end