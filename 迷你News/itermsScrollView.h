//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
//#import "homeVC.h"
@interface itermsScrollView : UIScrollView

@property (nonatomic) NSInteger index;
@property (nonatomic)int currentIndex;
@property (nonatomic, strong)UIColor *selectedColor;
@property (nonatomic, strong)void (^changeIndexValue)(NSInteger);
//@property (nonatomic,strong)homeVC *home;
- (instancetype)initWithButtonsArr:(NSArray *)arr;

@end
