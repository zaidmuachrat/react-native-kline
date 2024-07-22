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
@property (nonatomic, copy) NSString *selectedDuration;//added by Zaid
@property (nonatomic, assign) BOOL showKDJ; // //added by Zaid
@property (nonatomic, assign) BOOL showMACD; // //added by Zaid
@property (nonatomic, assign) BOOL showRSI; // //added by Zaid
@property (nonatomic, assign) BOOL showVMA;
@property (nonatomic, assign) BOOL showBOLL;
@property (nonatomic, assign) BOOL showWR;
@property (nonatomic, assign) BOOL showBOLLText;

- (void) setMainBackgroundColor:(NSString *)mainBackgroundColor;
- (instancetype)initWithFrame:(CGRect)frame selectedDuration:(NSString *)selectedDuration scale:(CGFloat)scale; // Update method signature


@end

NS_ASSUME_NONNULL_END
