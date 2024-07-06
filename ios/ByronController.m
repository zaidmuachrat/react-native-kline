#import "ByronController.h"
#import "DataUtil.h"
#import "KLineChartView.h"
#import "KLineStateManager.h"
#import "KLineModel.h"
#import "KLineChart/Style/ChartStyle.h"

@interface ByronController()
@property (nonatomic, assign) BOOL isThrottled;

@end

@implementation ByronController

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _selectedDuration = @"1D"; // default value
        _showKDJ = NO; // default value
        _showMACD = NO; // default value
        _showRSI = NO; // default value
        [self initChartView]; // Initialize chart view here
    }
    return self;
}

- (void)initChartView {
    // Initialize KLineChartView with selectedDuration and showKDJ
    _chartView = [[KLineChartView alloc] initWithFrame:self.bounds selectedDuration:_selectedDuration];
    _chartView.showKDJ = _showKDJ;
    _chartView.showMACD = _showMACD;
    _chartView.showRSI = _showRSI;
    
    // Set the delegate
    _chartView.delegate = self;
    
    // Set other properties and initial states
    [KLineStateManager manager].klineChart = _chartView;
    [self initKLineState];
    [self setDatas:_datas];
    [self setLocales:_locales];
    [self setIndicators:_indicators];
    [self setPricePrecision:_pricePrecision];
    [self setVolumePrecision:_volumePrecision];
    [self setIncreaseColor:_increaseColor];
    [self setDecreaseColor:_decreaseColor];
    [_chartView setMainBackgroundColor:_mainBackgroundColor];
    
    // Add the chart view to the view hierarchy
    [self addSubview:_chartView];
}

- (void)setSelectedDuration:(NSString *)selectedDuration {
    _selectedDuration = selectedDuration;
    _chartView.selectedDuration = selectedDuration;
}

- (void)setShowKDJ:(BOOL)showKDJ {
    _showKDJ = showKDJ;
    _chartView.showKDJ = showKDJ;
}
- (void)setShowMACD:(BOOL)showMACD {
    _showMACD = showMACD;
    _chartView.showMACD = showMACD;
}
- (void)setShowRSI:(BOOL)showRSI {
    _showRSI = showRSI;
    _chartView.showRSI = showRSI;
}
- (void)addHeaderData:(NSArray *)list {
    if (_chartView == nil) {
        return;
    }
    KLineModel * item = [[KLineModel alloc] initWithDict:list.firstObject];
    KLineModel *model = [KLineStateManager manager].datas.firstObject;
    if(model != nil && [KLineStateManager manager].datas.count > 1) {
        KLineModel *last1 = [KLineStateManager manager].datas.firstObject;
        KLineModel * last2 = [[KLineStateManager manager].datas objectAtIndex:1];
        int differ = last1.id - last2.id;
        int limit = item.id - last1.id;
        KLineModel *kLineEntity = [[KLineModel alloc] init];
        kLineEntity.open = item.open;
        kLineEntity.high = item.high;
        kLineEntity.low = item.low;
        kLineEntity.close = item.close;
        kLineEntity.vol = item.vol;
        kLineEntity.amount = item.amount;
        if (limit < differ) {
            kLineEntity.id = model.id;
            NSArray  *models = [KLineStateManager manager].datas;
            NSMutableArray *newDatas = [NSMutableArray arrayWithArray:models];
            [newDatas replaceObjectAtIndex:0 withObject:kLineEntity];
            if ([KLineStateManager manager].isLine) {
                [DataUtil addLastData:models data:kLineEntity];
            } else {
                [DataUtil calculate:newDatas];
            }
            [KLineStateManager manager].datas = [newDatas copy];
        } else {
            kLineEntity.id = item.id;
            NSArray  *models = [KLineStateManager manager].datas;
            NSMutableArray *newDatas = [NSMutableArray arrayWithArray:models];
            [newDatas insertObject:kLineEntity atIndex:0];
            if ([KLineStateManager manager].isLine) {
                [DataUtil addLastData:models data:kLineEntity];
            } else {
                [DataUtil calculate:newDatas];
            }
            [KLineStateManager manager].datas = [newDatas copy];
        }
    }
}

- (void)addFooterData:(NSArray *)list {
    if (_chartView == nil) {
        return;
    }
    NSArray  *models = [KLineStateManager manager].datas;
    NSMutableArray *newDatas = [NSMutableArray arrayWithArray:models];
    NSArray *newList = [[list reverseObjectEnumerator] allObjects];
    for (int i = 0; i < newList.count; i++) {
        NSDictionary *item = newList[i];
        [newDatas addObject:[[KLineModel alloc] initWithDict:item]];
    }
    [DataUtil calculate:newDatas];
    [KLineStateManager manager].datas = [newDatas copy];

}

- (void)setDatas:(NSArray *)datas {
    _datas = datas;
    if (_chartView == nil || _datas.count < 1) {
        return;
    }
    NSArray *newDatas = [[datas reverseObjectEnumerator] allObjects];
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:newDatas.count];
    for (int i = 0; i < newDatas.count; i++) {
      NSDictionary *item = newDatas[i];
      [list addObject:[[KLineModel alloc] initWithDict:item]];
    }
    [DataUtil calculate:list];
    [KLineStateManager manager].datas = list;
}

- (void)setLocales:(NSArray *)locales {
    _locales = locales;
    if (_chartView == nil || _locales.count < 1) {
        return;
    }
    [KLineStateManager manager].locales = locales;
}

- (void)setIndicators:(NSArray *)indicators {
    _indicators = indicators;
    if (_chartView == nil) {
        return;
    }
    if (indicators.count == 0) {
        [self initKLineState];
        return;
    }
    for (int i = 0; i < indicators.count; i++) {
      NSNumber *item = indicators[i];
      [self changeKLineState:item];
    }
}

- (void)setPricePrecision:(NSNumber *)pricePrecision {
    if (pricePrecision == nil) {
        return;
    }
    _pricePrecision = pricePrecision;
    if (_chartView == nil) {
        return;
    }
    [KLineStateManager manager].pricePrecision = pricePrecision;
}

- (void)setVolumePrecision:(NSNumber *)volumePrecision {
    if (volumePrecision == nil) {
        return;
    }
    _volumePrecision = volumePrecision;
    if (_chartView == nil) {
        return;
    }
    [KLineStateManager manager].volumePrecision = volumePrecision;
}

- (void)onMoreKLineData {
    if (self.onRNMoreKLineData == nil) {
       
        return;
    }
    if (_requestStatus == YES || self.isThrottled) {
       
        return;
    }
    _requestStatus = YES;
    self.isThrottled = YES;

    KLineModel *model = [KLineStateManager manager].datas.lastObject;
   
    self.onRNMoreKLineData(@{@"id": @(model.id)});

    // Reset _requestStatus after the data is fetched and merged
    [self performSelector:@selector(resetRequestStatus) withObject:nil afterDelay:0.1];
    [self performSelector:@selector(resetThrottle) withObject:nil afterDelay:2.0]; // Adjust the delay as needed
}

- (void)resetRequestStatus {
    _requestStatus = NO;
    
}

- (void)resetThrottle {
    self.isThrottled = NO;
   
}


- (void)initKLineState {
    if (_chartView == nil) {
      return;
    }
    [KLineStateManager manager].mainState = MainStateNONE;
    [KLineStateManager manager].secondaryState = SecondaryStateNONE;
    [KLineStateManager manager].isLine = NO;

}

- (void)changeKLineState:(NSNumber *)index {
  if (_chartView == nil) {
    return;
  }
  int state = [(index) intValue];
  switch (state) {
      // 显示MA
    case 0:
      [KLineStateManager manager].mainState = MainStateMA;
    break;
      // 显示BOLL
    case 1:
      [KLineStateManager manager].mainState = MainStateBOLL;
    break;
    // 隐藏主图指标
    case 2:
      [KLineStateManager manager].mainState = MainStateNONE;
    break;
    // 显示MACD
    case 3:
      [KLineStateManager manager].secondaryState = SecondaryStateMacd;
    break;
    // 显示KDJ
    case 4:
      [KLineStateManager manager].secondaryState = SecondaryStateKDJ;
    break;
    // 显示RSI
    case 5:
      [KLineStateManager manager].secondaryState = SecondaryStateRSI;
    break;
    // 显示WR
    case 6:
      [KLineStateManager manager].secondaryState = SecondaryStateWR;
    break;
    // 隐藏副图
    case 7:
      [KLineStateManager manager].secondaryState = SecondaryStateNONE;
    break;
    case 8:
      [KLineStateManager manager].isLine = YES;
    break;
    case 9:
      [KLineStateManager manager].isLine = NO;
    break;
    case 10: // 显示成交量
      _chartView.volState = VolStateVOL;
    break;
    case 11: // 隐藏成交量
      _chartView.volState = VolStateNONE;
    break;
    default:
    break;
  }
}

- (void)setMainBackgroundColor:(NSString *)mainBackgroundColor {
    _mainBackgroundColor = mainBackgroundColor;
    [_chartView setMainBackgroundColor:_mainBackgroundColor];
}

@end
