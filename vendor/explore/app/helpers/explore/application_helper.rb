module Explore
  module ApplicationHelper
    def get_tutorial_by_id(id)
      @tutorials.select{|x| x.id == id}[0]
    end

    def tutorials_mock()
      @tutorials = [
        OpenStruct.new({
          :net => KnowledgeNetStore::Net.first,
          :id => 'sample-1',
          :img => 'http://oss.aliyuncs.com/pie-documents/20140725/shao.jpg',
          :title => '勺工基本技法入门',
          :desc => '勺工是中式烹调特有的一项技术，是中式烹调用火和施艺的独特功夫。运用勺工技艺，调节和控制火候是每个厨师必备的基本功之一。',
          :steps => [
            {
              :title => "必要的准备工作",
              :desc => "每位学习者的必备工具：双耳锅一口，炒勺一把，手勺一把，用于盛菜的盘子一只，沙土 1 kg，配有灶台的桌子一张。（请依据实际学习者人数购置设备）",
              :imgs => [
                "http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/ynIYEAUv/adaptive_height_600_ynIYEAUv.png"
              ]
            },

            {
              :title => "先拿一口双耳锅来瞧瞧！",
              :desc => "这就是我们即将拿在手上的主要厨具：双耳锅（又称耳锅或边锅）",
              :imgs => [
                "http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/PHnVeD1r/adaptive_height_600_PHnVeD1r.png"
              ]
            },

            {
              :title => "再拿一把炒勺来瞧瞧",
              :desc => "炒锅分单柄式（炒勺）、双耳式（耳锅）平底式等。 由于炸、炒要求传热快、坚实耐用、重量轻巧， 所以，炸锅和炒锅大都用熟铁打制而成， 以锅面白亮平滑为佳。",
              :imgs => [
                "http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/I4zmIRd4/adaptive_height_600_I4zmIRd4.png"
              ]
            },

            {
              :title => "另一个重要厨具：手勺",
              :desc => "炒菜翻勺时，手勺将起到重要的配合作用。",
              :imgs => [
                "http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/CfbMACIL/adaptive_height_600_CfbMACIL.png"
              ]
            },

            {
              :title => "同一种厨具在不同地区有不同的说法",
              :desc => "山东一带称勺；西北一带称瓢； 中南地区称锅；广东沿海一带称镬。 东北一带多为单柄式；中南地区多为双耳式，还有一些地区为单柄平底式。",
            },

            {
              :title => "接下来讲一讲这些  厨具的手握方法",
              :desc => "双耳锅用左手抓握。左手拇指勾住锅耳左侧，其余四指端住边锅底部。正确抓握时竖起来也不会脱手。灶上操作时手握处要垫毛巾。  握炒勺也用左手抓握。翻勺时握紧，不翻勺时放松，做到牢而不死。  握手勺有用手，食指抵住勺柄。正确握勺时，如果手背朝上，则手勺的碗口是竖起来的。",
            },

            {
              :title => "请观摩各种手握方法的教学视频",
              :desc => "教学视频",
              :video => "http://oss.aliyuncs.com/pie-documents/20140725/01-how-to-handle-pots-h264_1.mp4"
            },

            {
              :title => "下面，请亲自手握一下各种厨具",
              :desc => " 充分了解厨具的分量、手感，形成直观的体验，有助于  理解灶台前操作的动作要求",
            },

            {
              :title => "讲解灶台前操作要求之前 先来看看操作现场",
              :desc => "",
              :imgs => ["http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/gz0Ac4Sk/adaptive_height_600_gz0Ac4Sk.png"]
            },

            {
              :title => "灶台前操作的体能要求",
              :desc => "灶台前操作是一项技术性很强的， 繁重的体力劳动。而且要在高温下进行。  这要求厨师有良好的身体素质，特别是有较强的臂力和腕力。操作姿势要正确，精神要集中，动作要敏捷，要注意安全。",
            },

            {
              :title => "灶台前操作的素质要求",
              :desc => "一名好的厨师，手上动作要利落。 各种原料用具摆放合理，讲究卫生，随时保持灶台和灶具的清洁。",
              :imgs => [
                "http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/diOLDx50/adaptive_height_600_diOLDx50.png", 
                "http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/wYBmaiqP/adaptive_height_600_wYBmaiqP.png"
              ]
            },

            {
              :title => "灶台前操作的基本动作要求",
              :desc => "灶台前操作的标准姿势是，两脚分开，自然站立  左转身加调料，在灶上翻炒； 右转身出菜时，两脚要随身体自然移动。",
            },

            {
              :title => "请观摩灶台前基本动作的教学视频",
              :desc => "这里播放一段教学视频 播放完毕后请尝试模仿一下",
              :video => "http://oss.aliyuncs.com/pie-documents/20140725/02-basic-rules-on-moving-h264_1.mp4"
            },

            {
              :title => "请观摩灶台前基本动作的教学视频（二）",
              :desc => "这是第二段视频",
              :video => "http://oss.aliyuncs.com/pie-documents/20140725/03-basic-rules-on-cooking.h264_1.mp4"
            },

            {
              :title => "接下来了解一下什么是翻勺",
              :desc => "播放一段专业的炒菜 + 翻勺视频",
              :video => "http://oss.aliyuncs.com/pie-documents/20140725/04-pot-turnover-demo-h264_1.mp4"
            },

            {
              :title => "同样是翻勺，不同地区也有不同的说法",
              :desc => "在本课中所讲的翻勺，有时候也被说成颠勺，掂勺。  前面讲到有些地方人们把勺称作锅，所以相应地又有翻锅，颠锅等说法。"
            },

            {
              :title => "勺工训练时使用什么食材？",
              :desc => " 在使用真正的食材炒菜之前我们需要练就过硬的勺工技能， 因此我们会用沙土代替真正的食材进行训练，也无需开火"
            },

            {
              :title => "了解翻勺的基本知识",
              :desc => "翻勺的主要目的是让菜均匀受热，避免粘锅，并且与调味汁充分混合。按照翻勺时菜离开锅底的幅度，可以大致分为小翻和大翻两种。  小翻的特点是，锅中的菜稍稍离开锅底一点不远；而大翻则需要用炒勺把菜扬起来，整个翻过来，再接住。"
            },
            {
              :title => "了解小翻勺中前翻和后翻的动作要领",
              :desc => "前翻勺使原料在锅中由前向后翻动，其动作要领是，靠手腕的力量前推后拉。后拉时翘起锅的前沿，翻动原料。  后翻勺使原料在炒勺里由后向前翻动，这种翻勺动作难度较大，但在加工调味汁较多的菜肴时，不容易烫手。"
            },
            {
              :title => "请观摩小翻勺相关的教学视频",
              :desc => "这里播放一段教学视频 ，播放完毕后请尝试模仿一下",
              :video => "http://oss.aliyuncs.com/pie-documents/20140725/05-small-pot-turnover-h264_1.mp4"
            },
            {
              :title => "再来了解大翻勺的技法",
              :desc => "烹饪某些菜肴时，需要用炒勺把菜扬起来，整个翻过来，再接住。这种翻勺动作，叫大翻勺。  大翻勺动作，要靠手臂手腕的力量做出推、拉、扬、接四种动作的各种配合，实现前翻，后翻，左翻，右翻等翻勺目的。",
              :video => "http://oss.aliyuncs.com/pie-documents/20140725/06-big-pot-turnover-h264_1.mp4"
            },
            {
              :title => "了解大翻勺的前后左右四种翻勺技法",
              :desc => "这里播放一段教学视频 播放完毕后请尝试模仿一下"
            },
            {
              :title => "接下来，自己反复练习各种翻勺技法",
              :desc => "自己操作，形成印象"
            },
            {
              :title => "前面看到的仅仅是教学视频",
              :desc => "为了加深理解，我们请专业大厨来做动作指导！"
            },
            {
              :title => "经过大厨的讲解和示范，你是否有了新的体会？",
              :desc => "在你亲自模仿之前，请观察这两位同学的动作"
            },
            {
              :title => "接下来，请看专业大厨如何手把手矫正两位学生的动作",
              :desc => "播放视频：专业大厨手把手矫正错误动作"
            },
            {
              :title => "看过了两位同学的动作 你能否指出他们对在哪里，错在哪里？",
              :desc => "请自己操作一番。"
            },
            {
              :title => "自己操作之后感觉如何？",
              :desc => "请与自己第一轮未经专业大厨指点的动作进行比较。",
            },
            {
              :title => "认真学完本教程后 ，你将熟悉基本的勺工操作",
              :desc => "1. 灶台前操作的各项要求以及安全说明 2. 双耳锅，炒勺和手勺的标准抓握姿势 3. 灶台前的标准站立姿势，转身动作及其配合动作 4. 小翻勺的标准动作，包括前翻和后翻 5. 大翻勺的标准动作，包括前翻和后翻 6. 用手勺辅助翻勺的标准动作：顶翻"
            }
          ]

        }),
        OpenStruct.new({
          :net => KnowledgeNetStore::Net.first,
          :id => 'sample-2',
          :img => 'http://oss.aliyuncs.com/pie-documents/20140725/dao.jpg',
          :title => '刀工基本技法入门',
          :desc => '刀工就是根据烹调与食用的需要，将各种原料加工成一定形状，使之成为组配菜肴所需要的基本形体的操作技术。'
        }),
      ]
    end

    def tutorials_mock2()
      @tutorials = [
        OpenStruct.new({
          :net => KnowledgeNetStore::Net.first,
          :id => 'sample-1',
          :img => 'http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/RRVMSwyI/adaptive_height_300_RRVMSwyI.png',
          :title => '灶台前操作的基本姿势',
          :desc => '学习灶台前操作的基本姿势，包括站立和移动等。',
          :steps => [
            {
             :title => '站立姿势', 
             :desc => '灶台前操作的正确姿势应该是，两脚分开，自然站立。',
             :imgs => ['http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/wN60Ly8I/adaptive_height_300_wN60Ly8I.png','http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/p3Pualvi/adaptive_height_300_p3Pualvi.png'],
             :video => ''
            },
            {
             :title => '转身和移动', 
             :desc => '左转身加调料，在灶上翻炒；右转身出菜时，两脚要随身体自然移动。',
             :imgs => [],
             :video => ''
            },
            {
             :title => '为何要遵循标准动作？', 
             :desc => '动作过于呆板，僵硬，长时间操作会出现疲劳，甚至损伤身体。所以要反复练习。',
             :imgs => [],
             :video => ''
            },
            {
             :title => '观看示范动作', 
             :desc => '请观看视频，了解基本站姿的示范动作：',
             :imgs => [],
             :video => 'http://oss.aliyuncs.com/pie-documents/20140729/1-灶台前操作的基本姿势.mp4'
            }
          ],
          :parents => [],
          :children => ['sample-2'],
          :learned => true,
          :related => %w{形成安全意识 锻炼身体}
        }),
        OpenStruct.new({
          :net => KnowledgeNetStore::Net.first,
          :id => 'sample-2',
          :img => 'http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/ZuDWIyFj/adaptive_height_300_ZuDWIyFj.png',
          :title => '基本的握勺动作',
          :desc => '接下来学习基本的握勺动作，包括炒勺，手勺和边锅的握法。',
          :steps => [
            {
             :title => '如何握炒勺', 
             :desc => '用左手握炒勺，握炒勺要牢而不死，翻勺时握紧，不翻勺时放松。',
             :imgs => ['http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/Qe2zwWiQ/adaptive_height_300_Qe2zwWiQ.png','http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/lRyHMzGQ/adaptive_height_300_lRyHMzGQ.png'],
             :video => ''
            },
            {
             :title => '如何握手勺', 
             :desc => '右手握手勺，用食指抵住勺柄。握勺姿势如果正确，那么手背朝上时，手勺口应该是竖起来的。',
             :imgs => ['http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/xRqkFhlL/adaptive_height_300_xRqkFhlL.png','http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/FCXIMvZx/adaptive_height_300_FCXIMvZx.png'],
             :video => ''
            },
            {
             :title => '如何握边锅', 
             :desc => '边锅的握法是，左手拇指勾住锅耳左侧，其余四指端住边锅底部。在灶上操作时，应该垫上毛巾。边锅握得正确，竖起来不能脱手。',
             :imgs => ['http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/kU7ckqJh/adaptive_height_300_kU7ckqJh.png','http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/vw414oPv/adaptive_height_300_vw414oPv.png'],
             :video => ''
            },
            {
             :title => '观看示范动作', 
             :desc => '请观看视频，了解各种握勺方法的示范动作：',
             :imgs => [],
             :video => 'http://oss.aliyuncs.com/pie-documents/20140729/2-基本的握勺动作.mp4'
            }
          ],
          :parents => ['sample-1'],
          :children => ['sample-3', 'sample-7'],
          :learned => true,
          :related => %w{熟悉炒勺 熟悉手勺 熟悉边锅 了解勺类厨具的不同说法}
        }),
        OpenStruct.new({
          :net => KnowledgeNetStore::Net.first,
          :id => 'sample-3',
          :img => 'http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/oEXj1sYs/adaptive_height_300_oEXj1sYs.png',
          :title => '小翻勺（前翻）',
          :desc => '接下来学习小翻勺动作，这一节主要讲前翻动作',
          :steps => [
            {
             :title => '前翻勺的动作要领', 
             :desc => '前翻的目的是使原料在锅中由前向后翻动。其动作要领是，靠手腕的力量前推后拉。后拉时翘起锅的前沿，翻动原料。',
             :imgs => ['http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/Uh8UwG2i/adaptive_height_300_Uh8UwG2i.png','http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/QuQoXC19/adaptive_height_300_QuQoXC19.png'],
             :video => ''
            },
            {
             :title => '观看示范动作', 
             :desc => '请观看视频，了解前翻勺的示范动作：',
             :imgs => [],
             :video => 'http://oss.aliyuncs.com/pie-documents/20140729/3-小翻勺-前翻.mp4'
            }
          ],
          :parents => ['sample-2'],
          :children => ['sample-4'],
          :related => %w{了解勺类厨具的不同说法 了解小翻勺}
        }),
        OpenStruct.new({
          :net => KnowledgeNetStore::Net.first,
          :id => 'sample-4',
          :img => 'http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/oEXj1sYs/adaptive_height_300_oEXj1sYs.png',
          :title => '小翻勺（后翻）',
          :desc => '接下来学习小翻勺动作，这一节主要讲后翻动作',
          :steps => [
            {
             :title => '后翻勺的动作要领', 
             :desc => '后翻勺的目的使原料在炒勺里由后向前翻动。这种翻勺动作难度较大，但是在加工调味汁较多的菜肴时，不容易烫手。',
             :imgs => ['http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/iKosAokx/adaptive_height_300_iKosAokx.png','http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/JFM8P19W/adaptive_height_300_JFM8P19W.png'],
             :video => ''
            },
            {
             :title => '观看示范动作', 
             :desc => '请观看视频，了解后翻勺的示范动作：',
             :imgs => [],
             :video => 'http://oss.aliyuncs.com/pie-documents/20140729/4-小翻勺-后翻.mp4'
            }
          ],
          :parents => ['sample-3'],
          :children => ['sample-5'],
          :related => %w{了解勺类厨具的不同说法 了解小翻勺}
        }),
        OpenStruct.new({
          :net => KnowledgeNetStore::Net.first,
          :id => 'sample-5',
          :img => 'http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/Z4Ajzq4s/adaptive_height_300_Z4Ajzq4s.png',
          :title => '大翻勺',
          :desc => '接下来学习大翻勺动作，大翻勺比起小翻勺的动作范围更大，对力量和技巧要求也更高',
          :steps => [
            {
             :title => '大翻勺的特点', 
             :desc => '烹饪某些菜肴时，需要用炒勺把菜扬起来，整个翻过来，再接住。这种翻勺动作，叫大翻勺。',
             :imgs => ['http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/KJF1eLqH/adaptive_height_300_KJF1eLqH.png','http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/BTYZE97x/adaptive_height_300_BTYZE97x.png'],
             :video => ''
            },
            {
             :title => '大翻勺的动作要领', 
             :desc => '大翻勺动作，要靠手臂手腕的力量，做出推、拉、扬、接四种动作的各种配合。可以做出前翻，后翻，左翻，右翻，不同的动作。',
             :imgs => [],
             :video => ''
            },
            {
             :title => '观看示范动作', 
             :desc => '请观看视频，了解大翻勺的示范动作：',
             :imgs => [],
             :video => 'http://oss.aliyuncs.com/pie-documents/20140729/5-大翻勺.mp4'
            }
          ],
          :parents => ['sample-4'],
          :children => ['sample-6'],
          :related => %w{了解勺类厨具的不同说法 了解大翻勺}
        }),
        OpenStruct.new({
          :net => KnowledgeNetStore::Net.first,
          :id => 'sample-6',
          :img => 'http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/zbn2jOBC/adaptive_height_300_zbn2jOBC.png',
          :title => '顶翻',
          :desc => '接下来学习顶翻动作，这种翻勺动作包含了手勺的推顶配合',
          :steps => [
            {
             :title => '顶翻的特点', 
             :desc => '在翻勺过程中，可以依靠手勺的帮助翻动菜肴，这种翻勺方式叫顶翻。',
             :imgs => [],
             :video => ''
            },
            {
             :title => '顶翻的动作要领', 
             :desc => '顶翻时，左手的动作和小翻一样。同时，右手用手勺顺着菜肴翻动的方向推顶，所以叫顶翻。有了手勺的配合，菜肴翻动充分，左手也比较省力。',
             :imgs => ['http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/a4yJuOZZ/adaptive_height_300_a4yJuOZZ.png','http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/OwiEAHeN/adaptive_height_300_OwiEAHeN.png'],
             :video => ''
            },
            {
             :title => '观看示范动作', 
             :desc => '请观看视频，了解顶翻的示范动作：',
             :imgs => [],
             :video => 'http://oss.aliyuncs.com/pie-documents/20140729/6-顶翻.mp4'
            }
          ],
          :parents => ['sample-5'],
          :children => ['sample-8'],
          :related => %w{了解勺类厨具的不同说法 了解小翻勺 了解大翻勺}
        }),
        OpenStruct.new({
          :net => KnowledgeNetStore::Net.first,
          :id => 'sample-7',
          :img => 'http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/G8U9RRCp/adaptive_height_300_G8U9RRCp.png',
          :title => '出菜和装盘',
          :desc => '菜炒好以后要装盘，接下来学习出菜和装盘的动作',
          :steps => [
            {
             :title => '装盘的基本要求', 
             :desc => '装盘要求装得周正，自然美观，盘子周围干净利落。',
             :imgs => [],
             :video => ''
            },
            {
             :title => '刮装法的动作要领', 
             :desc => '最常用的装盘方法是刮装法，出菜的时候用的是刮装，用手勺把菜刮到盘里。',
             :imgs => [],
             :video => ''
            },
            {
             :title => '观看示范动作', 
             :desc => '请观看视频，了解刮装法的示范动作：',
             :imgs => [],
             :video => 'http://oss.aliyuncs.com/pie-documents/20140729/7-出菜和装盘.mp4'
            }
          ],
          :parents => ['sample-2'],
          :children => ['sample-8'],
          :learned => true,
          :related => %w{了解勺类厨具的不同说法 了解装盘}
        }),
        OpenStruct.new({
          :net => KnowledgeNetStore::Net.first,
          :id => 'sample-8',
          :img => 'http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/n044MyKs/adaptive_height_300_n044MyKs.png',
          :title => '灶台用具的整理',
          :desc => '了解灶台用具的整理要求',
          :steps => [
            {
             :title => '灶台整理的要求', 
             :desc => '一名好的厨师，手底下要利落。各种原料用具摆放合理，讲究卫生，随时保持炉台和灶具的清洁。',
             :imgs => ['http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/gyTuLzNF/adaptive_height_300_gyTuLzNF.png','http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/z1fxOpp7/adaptive_height_300_z1fxOpp7.png'],
             :video => ''
            },
            {
             :title => '观看示范动作', 
             :desc => '请观看视频，了解灶台前操作时，用具摆放合理的好处。',
             :imgs => [],
             :video => 'http://oss.aliyuncs.com/pie-documents/20140729/8-整理灶台.mp4'
            },
            {
             :title => '观看示范性后厨照片', 
             :desc => '下面的后厨现场照片展示了各种原料用具的摆放都相对整齐的情况',
             :imgs => [],
             :video => ''
            }
          ],
          :parents => ['sample-6', 'sample-7'],
          :children => [],
          :related => %w{了解小翻勺 了解大翻勺 了解刮装法}
        })
      ]
    end
  end
end