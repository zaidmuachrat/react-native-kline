//
//  KLineStateManager.m
//  KLine-Chart-OC
//
//  Created by 何俊松 on 2020/3/10.
//  Copyright © 2020 hjs. All rights reserved.
//

#import "KLineStateManager.h"
#import "DataUtil.h"

static KLineStateManager *_manager = nil;
@implementation KLineStateManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mainState = MainStateMA;
        _secondaryState = SecondaryStateMacd;
        _isLine = false;
        _pricePrecision = @(2);
        _volumePrecision = @(2);
    }
    return self;
}

+(instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

- (void)setKlineChart:(KLineChartView *)klineChart {
    _klineChart = klineChart;
    _klineChart.mainState = _mainState;
    _klineChart.secondaryState = _secondaryState;
    _klineChart.isLine = _isLine;
    _klineChart.datas = _datas;
}

- (void)setDatas:(NSArray *)datas {
    _datas = datas;
    _klineChart.datas = datas;
}

- (void)setMainState:(MainState)mainState {
    _mainState = mainState;
    _klineChart.mainState = mainState;
}
-(void)setSecondaryState:(SecondaryState)secondaryState {
    _secondaryState = secondaryState;
    _klineChart.secondaryState = secondaryState;
}

-(void)setIsLine:(BOOL)isLine {
    _isLine = isLine;
    _klineChart.isLine = isLine;
}

- (void)setPricePrecision:(NSNumber *)pricePrecision {
    if (pricePrecision == nil) {
        pricePrecision = @(2);
    }
    _pricePrecision = pricePrecision;
}

- (void)setVolumePrecision:(NSNumber *)volumePrecision {
    if (volumePrecision == nil) {
        volumePrecision = @(2);
    }
    _volumePrecision = volumePrecision;
}

@end
