module SampleHelper
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

  def students_mock()
    @students = [
      OpenStruct.new({
        :id => 'ss1',
        :name => '张云杉',
        :learned => true
      }),
      OpenStruct.new({
        :id => 'ss2',
        :name => '李慎思'
      }),
      OpenStruct.new({
        :id => 'ss3',
        :name => '王今吾',
        :learned => true
      }),
      OpenStruct.new({
        :id => 'ss4',
        :name => '赵杨柳'
      }),
    ]
  end
end