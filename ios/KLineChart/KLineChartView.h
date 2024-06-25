// KLineChartView.h

#import <UIKit/UIKit.h>
#import "KLineModel.h"
#import "KLineState.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KLineDelegate <NSObject>

@required
- (void) onMoreKLineData;

@end

@interface KLineChartView : UIView

@property (nonatomic, weak) id<KLineDelegate> delegate;
@property(nonatomic,strong) NSArray<KLineModel *> *datas;
@property(nonatomic,assign) CGFloat scrollX;
@property(nonatomic,assign) CGFloat startX;
@property(nonatomic,assign) BOOL isLine;
@property(nonatomic,assign) CGFloat scaleX;
@property(nonatomic,assign) BOOL isLongPress;
@property(nonatomic,assign) CGFloat longPressX;
@property(nonatomic,assign) MainState mainState;
@property(nonatomic,assign) VolState volState;
@property(nonatomic,assign) SecondaryState secondaryState;
@property(nonatomic,assign) KLineDirection direction;
@property (nonatomic, copy) NSString *selectedDuration;//add by Zaid

- (void) setMainBackgroundColor:(NSString *)mainBackgroundColor;
- (instancetype)initWithFrame:(CGRect)frame selectedDuration:(NSString *)selectedDuration;

@end

NS_ASSUME_NONNULL_END
