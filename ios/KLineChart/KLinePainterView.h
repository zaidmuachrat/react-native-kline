#import <UIKit/UIKit.h>
#import "KLineModel.h"
#import "KLineState.h"

NS_ASSUME_NONNULL_BEGIN

@interface KLinePainterView : UIView

@property(nonatomic,strong) NSArray<KLineModel *> *datas;
@property(nonatomic,assign) CGFloat scrollX;
@property(nonatomic,assign) CGFloat startX;
@property(nonatomic,assign) BOOL isLine;
@property(nonatomic,assign) CGFloat scaleX;
@property(nonatomic,assign) BOOL isLongPress;
@property(nonatomic,assign) CGFloat longPressX;
@property(nonatomic,assign) MainState mainState;
@property(nonatomic,assign) VolState volState;
@property(nonatomic,assign) NSString *mainBackgroundColor;
@property(nonatomic,assign) SecondaryState secondaryState;
@property(nonatomic,assign) KLineDirection direction;
@property(nonatomic,copy) NSString *selectedDuration;
@property(nonatomic,assign) BOOL showKDJ;
@property(nonatomic,assign) BOOL showMACD;
@property(nonatomic,assign) BOOL showRSI;
@property(nonatomic,copy) void(^showInfoBlock)(KLineModel *model, BOOL isLeft);
@property (nonatomic, assign) BOOL showVMA; // Add this line

- (instancetype)initWithFrame:(CGRect)frame
                        datas:(NSArray<KLineModel *> *)datas
                      scrollX:(CGFloat)scrollX
                       isLine:(BOOL)isLine
                       scaleX:(CGFloat)scaleX
                  isLongPress:(BOOL)isLongPress
                    mainState:(MainState)mainState
               secondaryState:(SecondaryState)secondaryState
             selectedDuration:(NSString *)selectedDuration;


@end

NS_ASSUME_NONNULL_END
