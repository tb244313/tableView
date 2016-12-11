

#import "BigScrollView.h"
#import "Header.h"

@interface BigScrollView()

@end
@implementation BigScrollView
- (instancetype)initBigScroll
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 40, kScreenWidth, kScreenHeight);
        self.contentSize = CGSizeMake(kScreenWidth*3, 0);
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
    }
    return self;
    
}

@end
