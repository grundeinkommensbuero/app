import 'package:mockito/mockito.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/shared/FileReader.dart';
import 'package:test/test.dart';

import '../shared/Mocks.dart';

void main() {
  FileReader fileReaderMock = FileReaderMock();
  StammdatenService service;

  var json =
      '[{"kiez":"Tiergarten Süd","bezirk":"Mitte","latitude":13.358192,"longitude":52.5104552,"polygon":[[13.3695276,52.4988695],[13.3703602,52.4995103],[13.3703573,52.4995166],[13.3703586,52.499531],[13.3705551,52.4996823],[13.370586,52.4996851],[13.3707796,52.4998338],[13.3708454,52.4998986],[13.3708658,52.4999283],[13.3708775,52.499949],[13.370895,52.4999976],[13.3709889,52.5003088],[13.3713168,52.5013924],[13.3713487,52.5014967],[13.371382,52.5015731],[13.3714361,52.5016443],[13.3715473,52.5017657],[13.3716088,52.5018315],[13.3729142,52.5032425],[13.3730284,52.5033641],[13.3733118,52.5037556],[13.3734433,52.5039356],[13.3736055,52.5041633],[13.373718,52.5040539],[13.3737906,52.5039723],[13.3737892,52.503966],[13.3738722,52.5038736],[13.3738782,52.5038754],[13.3739774,52.5037678],[13.3741507,52.5035849],[13.37425,52.5034934],[13.3744185,52.5033778],[13.3746814,52.5032346],[13.3747447,52.5032356],[13.3747873,52.5032636],[13.3749766,52.5033772],[13.3751574,52.5036886],[13.376225,52.5055223],[13.3763767,52.5057832],[13.3776194,52.5079157],[13.3776486,52.507967],[13.3773231,52.508234],[13.3772328,52.5083066],[13.3769398,52.5085451],[13.3767505,52.5086992],[13.376376,52.5090049],[13.3763802,52.5093158],[13.3763913,52.5102127],[13.3764386,52.5104312],[13.3764933,52.5106685],[13.376502,52.5107036],[13.3765262,52.510834],[13.3766684,52.5114795],[13.3768249,52.5121943],[13.3768056,52.5122194],[13.3767612,52.5122426],[13.3768072,52.5124566],[13.3767758,52.5125455],[13.3766964,52.5127682],[13.3767626,52.5130515],[13.3770948,52.5144549],[13.3771754,52.5147993],[13.3773207,52.5154151],[13.3773739,52.5156381],[13.3773382,52.5157019],[13.3772997,52.5157377],[13.3772376,52.5157798],[13.377155,52.5158048],[13.3770163,52.5158414],[13.3768952,52.5158969],[13.3768036,52.5159596],[13.3767635,52.5159936],[13.376728,52.5160304],[13.37667,52.5161103],[13.3766489,52.5162082],[13.3766292,52.5163061],[13.3766509,52.5163781],[13.3767078,52.5164742],[13.376759,52.5165328],[13.3769498,52.5166545],[13.3770748,52.5167078],[13.3771101,52.516716],[13.3771321,52.5167259],[13.3771468,52.5167412],[13.3771687,52.5167709],[13.3771818,52.5168033],[13.3771888,52.5168464],[13.3771811,52.5169174],[13.3771616,52.5169776],[13.3771304,52.5170368],[13.3771509,52.5170468],[13.3771788,52.5170747],[13.3771976,52.5171143],[13.377193,52.5171565],[13.376962,52.517626],[13.3768815,52.5177912],[13.3768451,52.5179753],[13.3768573,52.519202],[13.3768596,52.5193135],[13.376859,52.5194267],[13.3768602,52.519469],[13.3768622,52.5196369],[13.3767188,52.5197238],[13.3766345,52.5197803],[13.3765132,52.5198681],[13.3763786,52.5199783],[13.3762852,52.5200743],[13.3762228,52.5201604],[13.3761707,52.5202529],[13.3761244,52.5203732],[13.3760745,52.520587],[13.3760595,52.5206345],[13.3760231,52.5208133],[13.3759838,52.5209894],[13.3759371,52.5211798],[13.3759117,52.5212373],[13.3758819,52.5213136],[13.375569,52.52165],[13.3755674,52.5216751],[13.3753677,52.5218301],[13.3753218,52.5218615],[13.3751385,52.5219608],[13.3747647,52.5221595],[13.3744603,52.5223072],[13.3742092,52.5224172],[13.3739538,52.5225101],[13.3736779,52.5225967],[13.373427,52.5226609],[13.3731424,52.5227142],[13.3728593,52.5227503],[13.3725866,52.522774],[13.3723921,52.5227844],[13.3721888,52.5227884],[13.3720473,52.5227881],[13.3716923,52.5227811],[13.3713683,52.522757],[13.3710474,52.5227124],[13.3707353,52.5226506],[13.3704206,52.5225663],[13.3701471,52.5224714],[13.3700119,52.5224127],[13.3698767,52.522354],[13.3697064,52.5222673],[13.3695521,52.5221681],[13.369363,52.5220023],[13.3691859,52.5218222],[13.3691785,52.5218258],[13.3689425,52.521616],[13.3689469,52.5216133],[13.3687447,52.5214376],[13.3686349,52.5213268],[13.368569,52.5212503],[13.3684957,52.5211764],[13.3683741,52.5210701],[13.3681175,52.5208664],[13.3679562,52.5207456],[13.3678168,52.520651],[13.3677609,52.5206185],[13.3676274,52.520541],[13.3674305,52.5204417],[13.3672424,52.5203595],[13.3670881,52.5202989],[13.3665294,52.5200964],[13.3663134,52.5200222],[13.366159,52.5199734],[13.3659119,52.5198982],[13.3657457,52.5198511],[13.3654882,52.5197849],[13.365183,52.5196027],[13.3651359,52.5195847],[13.3645254,52.5194288],[13.3644843,52.5194206],[13.3644401,52.5194178],[13.3641411,52.5194127],[13.3640896,52.519409],[13.3640394,52.519399],[13.3635026,52.5192603],[13.3629393,52.5191134],[13.3626716,52.51904],[13.3624084,52.5189505],[13.3621483,52.5188429],[13.3619176,52.518731],[13.3616035,52.5185523],[13.3612836,52.5183477],[13.3610826,52.5182151],[13.3608155,52.5180357],[13.3606262,52.5179166],[13.3603648,52.517783],[13.3601416,52.5176873],[13.3599402,52.5176104],[13.3597079,52.5175335],[13.3595902,52.5174991],[13.3594079,52.517451],[13.3591298,52.5173885],[13.3588018,52.5173203],[13.358403,52.5172403],[13.3580351,52.5171793],[13.3577186,52.5171345],[13.3573741,52.5170969],[13.3571709,52.5170785],[13.3569973,52.5170682],[13.3568234,52.5170624],[13.3565922,52.5170628],[13.3563019,52.5170729],[13.3561162,52.5170869],[13.3556651,52.5171496],[13.3552787,52.5172027],[13.3551342,52.5172248],[13.3548996,52.5172899],[13.3545379,52.5174248],[13.3543162,52.5175257],[13.3538361,52.5177502],[13.353616,52.5178521],[13.3532524,52.51804],[13.3529108,52.5182397],[13.3523418,52.5185528],[13.3521128,52.5186664],[13.3514258,52.5189758],[13.3510252,52.5191878],[13.3508967,52.5192612],[13.3506482,52.5194152],[13.350481,52.5195316],[13.3504219,52.5195584],[13.3503005,52.5196525],[13.3500454,52.5196726],[13.3501478,52.5195776],[13.3482907,52.5197107],[13.3475285,52.5190925],[13.3473399,52.5190983],[13.3473262,52.5189329],[13.3472908,52.5184826],[13.3474072,52.5184784],[13.3473822,52.5182285],[13.34745,52.518226],[13.3474266,52.5179797],[13.3472379,52.5179864],[13.3472215,52.5178067],[13.3457151,52.5177006],[13.3453591,52.5176288],[13.3448611,52.5169447],[13.3446053,52.5166286],[13.3453572,52.5163096],[13.3456245,52.5161961],[13.3452444,52.5159642],[13.3442432,52.5159007],[13.3442278,52.5160023],[13.3440393,52.515991],[13.3440791,52.5157548],[13.3434799,52.5157174],[13.3434521,52.5156733],[13.3434097,52.5156345],[13.3433686,52.5156075],[13.3433304,52.5155894],[13.3432658,52.5155704],[13.3431023,52.5155574],[13.3422247,52.5155023],[13.3392504,52.5153135],[13.3388765,52.5154897],[13.3388456,52.515495],[13.3388161,52.5154859],[13.3385303,52.5152813],[13.3383837,52.5151722],[13.3383001,52.5150983],[13.3381714,52.5149722],[13.3380898,52.5148426],[13.3380259,52.5146941],[13.3379857,52.5145394],[13.3379779,52.5143821],[13.3379903,52.514277],[13.3380913,52.513926],[13.3377438,52.5139026],[13.3364158,52.5138104],[13.3362036,52.5133704],[13.33616,52.5132849],[13.3358449,52.5132698],[13.3358536,52.5132932],[13.3354988,52.5132698],[13.332345,52.5130617],[13.332211,52.5130524],[13.3318739,52.5130309],[13.3317652,52.5129812],[13.3316551,52.5129315],[13.3316688,52.5128605],[13.3316528,52.5128344],[13.3316425,52.5128263],[13.331625,52.5128136],[13.3316029,52.5128037],[13.3315706,52.5127955],[13.3315352,52.5127937],[13.3315013,52.5127963],[13.3314541,52.5128114],[13.3314318,52.5128275],[13.3314126,52.5128464],[13.3313992,52.5128796],[13.3313961,52.5128823],[13.3313932,52.512885],[13.3313873,52.5128859],[13.3312283,52.5128747],[13.331028,52.5128607],[13.3309794,52.5128579],[13.3307454,52.5128429],[13.3305584,52.5128299],[13.3305868,52.5127634],[13.3306183,52.5126907],[13.3306599,52.5126216],[13.330712,52.5125561],[13.3307815,52.512497],[13.3308348,52.512463],[13.3308658,52.5124442],[13.3309782,52.5123887],[13.3311185,52.5123334],[13.3311924,52.5123066],[13.3312705,52.5122834],[13.3313532,52.5122585],[13.3314507,52.5122308],[13.3337357,52.5117171],[13.3338108,52.511711],[13.3338476,52.5117147],[13.3338887,52.5117247],[13.3339167,52.5117311],[13.3339889,52.5117241],[13.3340273,52.5117161],[13.3340053,52.511698],[13.3338705,52.5115907],[13.3338368,52.5115619],[13.3337562,52.5114979],[13.3336022,52.511396],[13.3334072,52.5112786],[13.3332002,52.5111676],[13.3329829,52.5110647],[13.3327553,52.5109697],[13.3325172,52.5108829],[13.3322732,52.5108041],[13.3316574,52.510603],[13.3308491,52.5103386],[13.3300423,52.510075],[13.3306002,52.5098977],[13.3308526,52.5098174],[13.3316054,52.5095766],[13.3326444,52.5092449],[13.3329884,52.5091352],[13.3332954,52.5090371],[13.3333161,52.50903],[13.3333855,52.5090077],[13.3338991,52.5088437],[13.3339354,52.5089156],[13.3339644,52.5089759],[13.3339954,52.5089715],[13.3342283,52.5089334],[13.3344053,52.5089051],[13.3344614,52.5088801],[13.3345309,52.5088443],[13.3345753,52.5088175],[13.3346181,52.5087897],[13.3346936,52.5087306],[13.3347277,52.5086965],[13.3347589,52.5086633],[13.3347871,52.5086293],[13.3348109,52.5085943],[13.3348318,52.5085584],[13.3348557,52.5085099],[13.3348722,52.5084605],[13.3348774,52.5083509],[13.3348792,52.5083023],[13.3348749,52.5082664],[13.3348678,52.5082313],[13.3348578,52.5081962],[13.3348447,52.5081621],[13.3348272,52.5081279],[13.3348069,52.5080946],[13.3347777,52.5080549],[13.3347616,52.5080342],[13.3340256,52.5070772],[13.3337512,52.5067216],[13.3340673,52.5065785],[13.3340014,52.5065182],[13.3353043,52.5059192],[13.3353339,52.5059067],[13.3353901,52.5058844],[13.3354475,52.5058648],[13.3355066,52.505846],[13.335567,52.505831],[13.3356305,52.5058168],[13.3356806,52.505807],[13.3357617,52.5057955],[13.3358222,52.5057894],[13.3364632,52.5057289],[13.336528,52.5057237],[13.3365958,52.5057194],[13.3366606,52.5057168],[13.3367269,52.5057161],[13.3367931,52.5057172],[13.3368594,52.5057191],[13.3369109,52.5057219],[13.3369639,52.5057257],[13.3370154,52.5057303],[13.3371067,52.5057404],[13.3380131,52.5058468],[13.3383796,52.5058899],[13.3386386,52.5059202],[13.3388878,52.5054248],[13.3389206,52.5053611],[13.3389624,52.5052803],[13.3389758,52.5052534],[13.3390399,52.5051295],[13.3390668,52.5050738],[13.3392271,52.5051066],[13.3392963,52.5051184],[13.3393655,52.5051276],[13.3394345,52.5051367],[13.3395052,52.5051432],[13.3395744,52.5051497],[13.339645,52.5051534],[13.3397157,52.5051563],[13.3397879,52.5051574],[13.3398586,52.5051575],[13.3399293,52.5051559],[13.34,52.5051525],[13.3400707,52.5051482],[13.3401371,52.5051429],[13.3402048,52.5051359],[13.3402711,52.505128],[13.3403374,52.5051174],[13.3404038,52.5051067],[13.3404686,52.5050943],[13.3405336,52.505081],[13.3407195,52.5050365],[13.3407858,52.5050205],[13.34101,52.5049671],[13.3411457,52.5049342],[13.3411825,52.5049244],[13.3412755,52.504903],[13.34142,52.5048674],[13.3415006,52.5049404],[13.342595,52.5046762],[13.3438031,52.5043843],[13.3448768,52.5041253],[13.3457663,52.5039082],[13.3459859,52.5038575],[13.3471497,52.5035763],[13.3480066,52.503368],[13.3481541,52.5033333],[13.3492323,52.5030725],[13.3495523,52.5029951],[13.3498591,52.5029212],[13.3502027,52.5028375],[13.3513899,52.502551],[13.3513882,52.5025887],[13.3519354,52.5024561],[13.3522791,52.5023733],[13.353015,52.5021962],[13.3536816,52.5020341],[13.354099,52.5019335],[13.3542007,52.5019086],[13.355332,52.5016345],[13.3554868,52.5015971],[13.3565708,52.5013345],[13.357519,52.5011047],[13.3575353,52.5010976],[13.3575426,52.5010895],[13.357637,52.5010628],[13.3578745,52.500995],[13.3583023,52.5008737],[13.3586622,52.5007712],[13.3597981,52.5004467],[13.3600046,52.500387],[13.3603645,52.5002835],[13.3625373,52.499662],[13.3630445,52.4995617],[13.3644047,52.4993768],[13.3647202,52.4993344],[13.3654761,52.4992309],[13.3659889,52.499161],[13.3663058,52.4991195],[13.3687933,52.4987807],[13.3693561,52.4987361],[13.3695276,52.4988695]]},{"kiez":"Regierungsviertel","bezirk":"Mitte","latitude":13.3906416,"longitude":52.5141584,"polygon":[[13.3768622,52.5196369],[13.3768602,52.519469],[13.376859,52.5194267],[13.3768596,52.5193135],[13.3768573,52.519202],[13.3768451,52.5179753],[13.3768815,52.5177912],[13.376962,52.517626],[13.377193,52.5171565],[13.3771976,52.5171143],[13.3771788,52.5170747],[13.3771509,52.5170468],[13.3771304,52.5170368],[13.3771616,52.5169776],[13.3771811,52.5169174],[13.3771888,52.5168464],[13.3771818,52.5168033],[13.3771687,52.5167709],[13.3771468,52.5167412],[13.3771321,52.5167259],[13.3771101,52.516716],[13.3770748,52.5167078],[13.3769498,52.5166545],[13.376759,52.5165328],[13.3767078,52.5164742],[13.3766509,52.5163781],[13.3766292,52.5163061],[13.3766489,52.5162082],[13.37667,52.5161103],[13.376728,52.5160304],[13.3767635,52.5159936],[13.3768036,52.5159596],[13.3768952,52.5158969],[13.3770163,52.5158414],[13.377155,52.5158048],[13.3772376,52.5157798],[13.3772997,52.5157377],[13.3773382,52.5157019],[13.3773739,52.5156381],[13.3773207,52.5154151],[13.3771754,52.5147993],[13.3770948,52.5144549],[13.3767626,52.5130515],[13.3766964,52.5127682],[13.3767758,52.5125455],[13.3768072,52.5124566],[13.3767612,52.5122426],[13.3768056,52.5122194],[13.3768249,52.5121943],[13.3766684,52.5114795],[13.3765262,52.510834],[13.376502,52.5107036],[13.3764933,52.5106685],[13.3764386,52.5104312],[13.3763913,52.5102127],[13.3763802,52.5093158],[13.376376,52.5090049],[13.3767505,52.5086992],[13.3769398,52.5085451],[13.3772328,52.5083066],[13.3773231,52.508234],[13.3776486,52.507967],[13.3778483,52.5078074],[13.3789401,52.5069299],[13.3794453,52.506949],[13.3823839,52.5071185],[13.3854198,52.507309],[13.3857613,52.5073286],[13.3902062,52.5075865],[13.3904934,52.5076023],[13.3921232,52.5076972],[13.39245,52.5077195],[13.3940579,52.507817],[13.3943832,52.5078374],[13.3960572,52.5079404],[13.3970525,52.5080008],[13.3973632,52.5080221],[13.3985513,52.5080998],[13.3987706,52.5081128],[13.3987943,52.5080921],[13.3992304,52.5080769],[13.399602,52.5085745],[13.3999954,52.5091109],[13.4001884,52.5093754],[13.4002282,52.5093809],[13.4009084,52.5091404],[13.4012579,52.5090405],[13.4014099,52.5089842],[13.4020961,52.5087294],[13.4027525,52.5085356],[13.4032616,52.508328],[13.4036321,52.5081769],[13.4038195,52.5080927],[13.4039853,52.5082323],[13.4045805,52.5087898],[13.4047343,52.5089455],[13.4055214,52.5096947],[13.4059246,52.5100648],[13.4059568,52.5101197],[13.4059849,52.5103794],[13.4059857,52.5105205],[13.4059706,52.5108817],[13.4059147,52.5108807],[13.4059143,52.5109616],[13.4059672,52.5109653],[13.4059591,52.5111379],[13.4059916,52.5113841],[13.4059823,52.5114892],[13.4059602,52.5114883],[13.4059262,52.5115089],[13.4056643,52.5114688],[13.4056261,52.5114463],[13.4047191,52.5113673],[13.4044643,52.5113677],[13.4036718,52.5113932],[13.4032962,52.5114033],[13.4032866,52.5112622],[13.4027179,52.5112791],[13.4026307,52.511349],[13.4026363,52.5113868],[13.402573,52.5113884],[13.4023801,52.5113935],[13.4021812,52.5113922],[13.4025866,52.5116078],[13.4029639,52.5118538],[13.4030608,52.5119205],[13.4032853,52.5120818],[13.4034219,52.5121746],[13.4034484,52.5121774],[13.4038168,52.5124251],[13.4039211,52.5124856],[13.4058411,52.5138066],[13.4060612,52.5139634],[13.4060627,52.5139769],[13.4060596,52.5139966],[13.4068709,52.514655],[13.4068267,52.5146576],[13.4068589,52.5146928],[13.4063382,52.5148365],[13.4063059,52.5148157],[13.4062646,52.5148399],[13.4063086,52.5148715],[13.4057562,52.5151589],[13.4055803,52.5152647],[13.4054636,52.5153588],[13.4053096,52.5155238],[13.4052175,52.515653],[13.4050754,52.5157984],[13.4039038,52.5167694],[13.4038309,52.5169149],[13.4037462,52.5170747],[13.4036632,52.5171554],[13.4022465,52.5185214],[13.4022653,52.518587],[13.4020653,52.5188014],[13.402002,52.5188022],[13.4019548,52.5188254],[13.4018955,52.5188927],[13.4017813,52.5190354],[13.4017872,52.5190471],[13.4016848,52.5191727],[13.4015072,52.5193494],[13.4012304,52.5195943],[13.400871,52.5198676],[13.4006035,52.5200423],[13.4003524,52.5201821],[13.4000968,52.5203047],[13.4001748,52.5203408],[13.4001363,52.5203749],[13.4000283,52.520469],[13.3999291,52.5205578],[13.3997321,52.5204766],[13.3986716,52.5212941],[13.3977201,52.5215295],[13.3966316,52.5217556],[13.3969006,52.5218747],[13.3972609,52.5219896],[13.3969601,52.5220618],[13.396957,52.5220816],[13.396879,52.5220562],[13.3965982,52.5219559],[13.3963115,52.5218394],[13.3960756,52.5218947],[13.3956568,52.5219415],[13.3956494,52.5219613],[13.3956272,52.5219729],[13.3946145,52.5220869],[13.3946012,52.5220976],[13.3940793,52.5221613],[13.3938627,52.5221825],[13.393817,52.5221833],[13.3937831,52.5221733],[13.3937714,52.5221553],[13.3936917,52.5221803],[13.393646,52.5221856],[13.3936137,52.5221775],[13.3935917,52.5221622],[13.3935829,52.5221379],[13.3935977,52.5221163],[13.3936244,52.522102],[13.3936996,52.5220797],[13.3936776,52.5220581],[13.3936852,52.5220401],[13.3937088,52.5220213],[13.3936691,52.5220023],[13.3934311,52.5218751],[13.3933704,52.5219209],[13.3924691,52.5221303],[13.391778,52.522164],[13.3917323,52.5221738],[13.3915658,52.522177],[13.3914803,52.5221769],[13.3914568,52.5221696],[13.3911798,52.5221798],[13.3908616,52.5221792],[13.3899749,52.5221451],[13.3897024,52.5221356],[13.3892502,52.5221095],[13.388885,52.5220782],[13.3886184,52.5220498],[13.3884787,52.5220217],[13.3883625,52.5219864],[13.3882522,52.5219466],[13.3878025,52.5217417],[13.387704,52.5216949],[13.3872488,52.5214225],[13.3868053,52.5211565],[13.3860858,52.5207218],[13.3855425,52.5204036],[13.385143,52.5201736],[13.3850621,52.5201465],[13.3847828,52.5200533],[13.3841488,52.519857],[13.3830164,52.5195195],[13.3822118,52.5192842],[13.381794,52.5191827],[13.3815645,52.5191355],[13.3811642,52.5190672],[13.38078,52.5190179],[13.3804722,52.518993],[13.3804176,52.5189992],[13.3801245,52.5189842],[13.3801026,52.5189698],[13.3798684,52.5189621],[13.3796827,52.5189617],[13.3794986,52.5189676],[13.3792849,52.5189815],[13.379077,52.5190036],[13.3787335,52.5190451],[13.3784151,52.5190975],[13.3781201,52.5191598],[13.3779312,52.5192061],[13.377763,52.519257],[13.377484,52.5193489],[13.3772906,52.519424],[13.3771415,52.519492],[13.3770557,52.5195332],[13.3768622,52.5196369]]},{"kiez":"Alexanderplatz","bezirk":"Mitte","latitude":13.4022312,"longitude":52.5208536,"polygon":[[13.4038195,52.5080927],[13.4040365,52.5079944],[13.4043009,52.5078618],[13.4044397,52.5077713],[13.4045791,52.5078857],[13.404632,52.5079218],[13.4052845,52.5082105],[13.4061241,52.507592],[13.4064094,52.5073814],[13.4066001,52.5072325],[13.4073601,52.5066472],[13.4073937,52.5066634],[13.4078432,52.5063227],[13.4078389,52.5063047],[13.4080295,52.5061793],[13.4081618,52.5062298],[13.4087586,52.5064592],[13.4094539,52.5067265],[13.4099698,52.5069252],[13.4113987,52.5050558],[13.4115203,52.5048908],[13.4118094,52.5047915],[13.4133598,52.5042749],[13.4140721,52.5040371],[13.4141981,52.5041865],[13.4143269,52.5043404],[13.4145246,52.504578],[13.4146095,52.5046798],[13.4145928,52.5047921],[13.4149073,52.5049184],[13.4167949,52.5043943],[13.417078,52.5043148],[13.4173081,52.5042505],[13.4176014,52.5041692],[13.418213,52.5050177],[13.4184017,52.5049929],[13.4185181,52.5049868],[13.4185314,52.5049697],[13.4188079,52.5050295],[13.4189434,52.5050603],[13.4189241,52.5050801],[13.4189902,52.5051152],[13.4190475,52.5051558],[13.4191017,52.505199],[13.4191339,52.5052395],[13.419431,52.5056489],[13.4195342,52.5056222],[13.4196698,52.5055847],[13.4198512,52.5055346],[13.4203291,52.5053998],[13.4209027,52.5052426],[13.4211312,52.5051747],[13.4213893,52.5051149],[13.4215426,52.5050774],[13.4218107,52.505042],[13.4220907,52.5050263],[13.4222984,52.5050077],[13.4226666,52.5049868],[13.4229141,52.5049809],[13.4230392,52.5049803],[13.4232292,52.5049833],[13.4233588,52.5049871],[13.4236076,52.5050001],[13.4237328,52.5050084],[13.4239801,52.5050295],[13.4243481,52.5050751],[13.4244702,52.5050924],[13.4247115,52.5051323],[13.4249513,52.5051804],[13.4251367,52.5052274],[13.4253162,52.5052726],[13.4254971,52.5053215],[13.4258207,52.5054245],[13.426438,52.5056844],[13.4267085,52.505799],[13.4269797,52.5057284],[13.4271995,52.5056659],[13.4274394,52.5060087],[13.4282662,52.5071917],[13.4284287,52.5074239],[13.4288165,52.5079791],[13.4290283,52.508036],[13.4294014,52.5085713],[13.429239,52.5086708],[13.4292049,52.5087247],[13.4291868,52.508819],[13.4291749,52.5088361],[13.4291527,52.5088531],[13.4291218,52.5088656],[13.4291364,52.5088845],[13.4291335,52.5088944],[13.4291202,52.5089034],[13.4289196,52.5089659],[13.4289033,52.5089695],[13.4288871,52.5089668],[13.4288562,52.5089775],[13.4286662,52.5089907],[13.4283727,52.5090702],[13.4281628,52.5092261],[13.4280815,52.5092871],[13.4267067,52.5100936],[13.4260199,52.5104968],[13.4260141,52.5104923],[13.4257703,52.5106339],[13.4251103,52.5110183],[13.4248695,52.5111617],[13.4245018,52.5113812],[13.4236544,52.5118084],[13.4234166,52.5119455],[13.4233397,52.5119921],[13.4232482,52.5120432],[13.4231831,52.512088],[13.4230769,52.5121301],[13.4230504,52.5121273],[13.4230314,52.5121165],[13.4230107,52.5121264],[13.4227803,52.5122338],[13.4227936,52.5122491],[13.4230208,52.5124867],[13.4232187,52.5127],[13.4232451,52.5127279],[13.4232391,52.5127306],[13.4232977,52.5127936],[13.4233475,52.5128476],[13.4234179,52.5129233],[13.4236759,52.5131933],[13.423843,52.513368],[13.4239482,52.5135631],[13.4240111,52.5136809],[13.4240667,52.5137394],[13.4241018,52.5137862],[13.4242381,52.5139446],[13.4242982,52.5140211],[13.424389,52.5141372],[13.4248589,52.5147518],[13.425004,52.5149434],[13.425102,52.5150811],[13.4251385,52.5151414],[13.4255974,52.5159384],[13.4256719,52.5160697],[13.4258195,52.5163387],[13.4258692,52.5164322],[13.4262506,52.517096],[13.426388,52.5173416],[13.4264099,52.5173758],[13.4264757,52.5174757],[13.4267535,52.5179587],[13.4265057,52.5180104],[13.4263377,52.5180443],[13.4263303,52.5180317],[13.426149,52.5180709],[13.4261855,52.5181249],[13.4262398,52.5181969],[13.4263026,52.5182895],[13.4259266,52.5183914],[13.4261901,52.5187512],[13.4265678,52.5192686],[13.4268811,52.5196951],[13.4269162,52.5197436],[13.4273543,52.5196267],[13.4274104,52.5196143],[13.4274634,52.5196081],[13.4274973,52.5196063],[13.4284005,52.5195854],[13.428456,52.5196995],[13.4289055,52.5206224],[13.4289406,52.5206925],[13.4291887,52.5212033],[13.4291812,52.5212231],[13.4285643,52.5214863],[13.4277878,52.5218192],[13.4276226,52.5218944],[13.4267192,52.5222793],[13.4259427,52.5226178],[13.4259309,52.5226231],[13.425547,52.5227905],[13.4259078,52.5228306],[13.4260032,52.5229251],[13.4261533,52.522929],[13.4265202,52.5229386],[13.4265123,52.5230644],[13.4265088,52.5231677],[13.4265009,52.5232909],[13.4263344,52.5232987],[13.4262533,52.5233057],[13.4261737,52.5233137],[13.4260926,52.5233225],[13.4260116,52.5233323],[13.4258819,52.5233518],[13.4257535,52.5233804],[13.4254836,52.5234464],[13.4254335,52.52344],[13.4247785,52.5236303],[13.4242459,52.5237957],[13.4241116,52.5238404],[13.4239552,52.5238967],[13.4237029,52.5239906],[13.4233751,52.5241186],[13.421629,52.5248058],[13.4214755,52.5248657],[13.4211861,52.5249784],[13.4205013,52.5252495],[13.4197529,52.5255448],[13.4194886,52.5256567],[13.4182485,52.5261792],[13.4179636,52.5263064],[13.4168901,52.5267826],[13.4169048,52.5267952],[13.4167069,52.5268847],[13.4166848,52.5268757],[13.4163541,52.5270206],[13.4162214,52.5270608],[13.4161446,52.5270831],[13.415954,52.5271844],[13.4154311,52.5274629],[13.4144514,52.5277389],[13.4141828,52.5278148],[13.4132445,52.528079],[13.4121835,52.5283746],[13.4119357,52.5284443],[13.411313,52.5286211],[13.4108013,52.5287001],[13.4100906,52.5288103],[13.4093958,52.5289501],[13.4093045,52.5289715],[13.4087438,52.5290998],[13.4083942,52.5291791],[13.4081892,52.5292273],[13.4081567,52.5292326],[13.4075048,52.5293429],[13.4074135,52.529358],[13.4072069,52.5293935],[13.4066259,52.5294895],[13.4055848,52.5296646],[13.4053413,52.5297064],[13.4036321,52.5299998],[13.40172,52.529891],[13.4016623,52.5299439],[13.4012891,52.5300178],[13.401211,52.5300186],[13.4009226,52.52993],[13.4007557,52.5297346],[13.3976223,52.5295641],[13.3973573,52.5295268],[13.3957855,52.5291489],[13.3955103,52.5290783],[13.3938872,52.528687],[13.3934942,52.5285837],[13.3914277,52.528159],[13.3911452,52.5281082],[13.3892141,52.5277063],[13.3889315,52.52765],[13.3873772,52.5273314],[13.3870107,52.5275562],[13.3856255,52.5286615],[13.3854124,52.5288246],[13.3848706,52.529262],[13.3846679,52.5294215],[13.3833268,52.5305223],[13.3831713,52.5306613],[13.3830855,52.5307312],[13.3824223,52.53126],[13.3822507,52.5313981],[13.3808386,52.5325257],[13.3806491,52.5326852],[13.3802864,52.5329892],[13.3801827,52.533077],[13.3786876,52.5342781],[13.3784937,52.5344367],[13.3769864,52.5356647],[13.3764845,52.5360627],[13.3762788,52.5362276],[13.3758331,52.536595],[13.3749241,52.5373247],[13.3745513,52.5370309],[13.3737497,52.5375225],[13.3732053,52.5378853],[13.3729878,52.5380286],[13.3686093,52.5359909],[13.368045,52.5364794],[13.367882,52.5366211],[13.36766,52.5365163],[13.3667533,52.5360884],[13.3667019,52.5360641],[13.3665598,52.5359137],[13.3663848,52.5358495],[13.365901,52.5356749],[13.3658598,52.5356596],[13.3682877,52.5332969],[13.3684499,52.5332721],[13.368503,52.5332641],[13.3689832,52.5327943],[13.3691982,52.5325638],[13.3692857,52.5324742],[13.3696136,52.5321056],[13.3698375,52.5318472],[13.3700602,52.5315727],[13.3703394,52.5311976],[13.3704791,52.5309994],[13.3706856,52.5307051],[13.3708786,52.5304485],[13.3708993,52.5304548],[13.3709541,52.5303875],[13.3711143,52.5302099],[13.3711722,52.5301498],[13.3712078,52.530113],[13.3712374,52.5300808],[13.3712789,52.5300387],[13.371356,52.5299589],[13.3716701,52.529645],[13.3718925,52.5294235],[13.3721089,52.5292092],[13.3721534,52.5291652],[13.3721948,52.5291276],[13.372223,52.5291025],[13.3722511,52.52908],[13.3722319,52.5290719],[13.3723741,52.528951],[13.372873,52.528553],[13.3731157,52.5283549],[13.3732845,52.5282079],[13.3735753,52.5278842],[13.373668,52.5279113],[13.3738239,52.5276996],[13.3738358,52.5276834],[13.3738137,52.5276762],[13.373721,52.5276481],[13.373806,52.5274784],[13.3738347,52.5273509],[13.3738428,52.5272197],[13.3738332,52.527101],[13.3737957,52.5269625],[13.3737183,52.5268366],[13.3736217,52.5267232],[13.3735044,52.5266196],[13.3733664,52.5265258],[13.3710503,52.5265262],[13.3710033,52.5264983],[13.3709964,52.5256616],[13.3709935,52.5253812],[13.3709914,52.5252347],[13.3713389,52.5250243],[13.3716465,52.524829],[13.3717204,52.5247843],[13.3717197,52.5236529],[13.3717199,52.5236062],[13.3717715,52.5236018],[13.3717673,52.5235721],[13.3717364,52.5235469],[13.3717032,52.5234381],[13.371696,52.5233877],[13.3716923,52.5227811],[13.3720473,52.5227881],[13.3721888,52.5227884],[13.3723921,52.5227844],[13.3725866,52.522774],[13.3728593,52.5227503],[13.3731424,52.5227142],[13.373427,52.5226609],[13.3736779,52.5225967],[13.3739538,52.5225101],[13.3742092,52.5224172],[13.3744603,52.5223072],[13.3747647,52.5221595],[13.3751385,52.5219608],[13.3753218,52.5218615],[13.3753677,52.5218301],[13.3755674,52.5216751],[13.375569,52.52165],[13.3758819,52.5213136],[13.3759117,52.5212373],[13.3759371,52.5211798],[13.3759838,52.5209894],[13.3760231,52.5208133],[13.3760595,52.5206345],[13.3760745,52.520587],[13.3761244,52.5203732],[13.3761707,52.5202529],[13.3762228,52.5201604],[13.3762852,52.5200743],[13.3763786,52.5199783],[13.3765132,52.5198681],[13.3766345,52.5197803],[13.3767188,52.5197238],[13.3768622,52.5196369],[13.3770557,52.5195332],[13.3771415,52.519492],[13.3772906,52.519424],[13.377484,52.5193489],[13.377763,52.519257],[13.3779312,52.5192061],[13.3781201,52.5191598],[13.3784151,52.5190975],[13.3787335,52.5190451],[13.379077,52.5190036],[13.3792849,52.5189815],[13.3794986,52.5189676],[13.3796827,52.5189617],[13.3798684,52.5189621],[13.3801026,52.5189698],[13.3801245,52.5189842],[13.3804176,52.5189992],[13.3804722,52.518993],[13.38078,52.5190179],[13.3811642,52.5190672],[13.3815645,52.5191355],[13.381794,52.5191827],[13.3822118,52.5192842],[13.3830164,52.5195195],[13.3841488,52.519857],[13.3847828,52.5200533],[13.3850621,52.5201465],[13.385143,52.5201736],[13.3855425,52.5204036],[13.3860858,52.5207218],[13.3868053,52.5211565],[13.3872488,52.5214225],[13.387704,52.5216949],[13.3878025,52.5217417],[13.3882522,52.5219466],[13.3883625,52.5219864],[13.3884787,52.5220217],[13.3886184,52.5220498],[13.388885,52.5220782],[13.3892502,52.5221095],[13.3897024,52.5221356],[13.3899749,52.5221451],[13.3908616,52.5221792],[13.3911798,52.5221798],[13.3914568,52.5221696],[13.3914803,52.5221769],[13.3915658,52.522177],[13.3917323,52.5221738],[13.391778,52.522164],[13.3924691,52.5221303],[13.3933704,52.5219209],[13.3934311,52.5218751],[13.3936691,52.5220023],[13.3937088,52.5220213],[13.3936852,52.5220401],[13.3936776,52.5220581],[13.3936996,52.5220797],[13.3936244,52.522102],[13.3935977,52.5221163],[13.3935829,52.5221379],[13.3935917,52.5221622],[13.3936137,52.5221775],[13.393646,52.5221856],[13.3936917,52.5221803],[13.3937714,52.5221553],[13.3937831,52.5221733],[13.393817,52.5221833],[13.3938627,52.5221825],[13.3940793,52.5221613],[13.3946012,52.5220976],[13.3946145,52.5220869],[13.3956272,52.5219729],[13.3956494,52.5219613],[13.3956568,52.5219415],[13.3960756,52.5218947],[13.3963115,52.5218394],[13.3965982,52.5219559],[13.396879,52.5220562],[13.396957,52.5220816],[13.3969601,52.5220618],[13.3972609,52.5219896],[13.3969006,52.5218747],[13.3966316,52.5217556],[13.3977201,52.5215295],[13.3986716,52.5212941],[13.3997321,52.5204766],[13.3999291,52.5205578],[13.4000283,52.520469],[13.4001363,52.5203749],[13.4001748,52.5203408],[13.4000968,52.5203047],[13.4003524,52.5201821],[13.4006035,52.5200423],[13.400871,52.5198676],[13.4012304,52.5195943],[13.4015072,52.5193494],[13.4016848,52.5191727],[13.4017872,52.5190471],[13.4017813,52.5190354],[13.4018955,52.5188927],[13.4019548,52.5188254],[13.402002,52.5188022],[13.4020653,52.5188014],[13.4022653,52.518587],[13.4022465,52.5185214],[13.4036632,52.5171554],[13.4037462,52.5170747],[13.4038309,52.5169149],[13.4039038,52.5167694],[13.4050754,52.5157984],[13.4052175,52.515653],[13.4053096,52.5155238],[13.4054636,52.5153588],[13.4055803,52.5152647],[13.4057562,52.5151589],[13.4063086,52.5148715],[13.4062646,52.5148399],[13.4063059,52.5148157],[13.4063382,52.5148365],[13.4068589,52.5146928],[13.4068267,52.5146576],[13.4068709,52.514655],[13.4060596,52.5139966],[13.4060627,52.5139769],[13.4060612,52.5139634],[13.4058411,52.5138066],[13.4039211,52.5124856],[13.4038168,52.5124251],[13.4034484,52.5121774],[13.4034219,52.5121746],[13.4032853,52.5120818],[13.4030608,52.5119205],[13.4029639,52.5118538],[13.4025866,52.5116078],[13.4021812,52.5113922],[13.4023801,52.5113935],[13.402573,52.5113884],[13.4026363,52.5113868],[13.4026307,52.511349],[13.4027179,52.5112791],[13.4032866,52.5112622],[13.4032962,52.5114033],[13.4036718,52.5113932],[13.4044643,52.5113677],[13.4047191,52.5113673],[13.4056261,52.5114463],[13.4056643,52.5114688],[13.4059262,52.5115089],[13.4059602,52.5114883],[13.4059823,52.5114892],[13.4059916,52.5113841],[13.4059591,52.5111379],[13.4059672,52.5109653],[13.4059143,52.5109616],[13.4059147,52.5108807],[13.4059706,52.5108817],[13.4059857,52.5105205],[13.4059849,52.5103794],[13.4059568,52.5101197],[13.4059246,52.5100648],[13.4055214,52.5096947],[13.4047343,52.5089455],[13.4045805,52.5087898],[13.4039853,52.5082323],[13.4038195,52.5080927]]}]';

  setUp(() {
    reset(fileReaderMock);
    when(fileReaderMock.loadLor()).thenAnswer((_) async => json);
    StammdatenService.fileReader = fileReaderMock;
    service = StammdatenService();
  });

  test('reads Kiez main features from files', () async {
    var kieze = await service.kieze;

    expect(kieze.length, 3);

    expect(kieze[0].bezirk, 'Mitte');
    expect(kieze[0].kiez, 'Tiergarten Süd');
    expect(kieze[0].center.latitude, 13.358192);
    expect(kieze[0].center.longitude, 52.5104552);

    expect(kieze[1].bezirk, 'Mitte');
    expect(kieze[1].kiez, 'Regierungsviertel');
    expect(kieze[1].center.latitude, 13.3906416);
    expect(kieze[1].center.longitude, 52.5141584);

    expect(kieze[2].bezirk, 'Mitte');
    expect(kieze[2].kiez, 'Alexanderplatz');
    expect(kieze[2].center.latitude, 13.4022312);
    expect(kieze[2].center.longitude, 52.5208536);
  });
}
