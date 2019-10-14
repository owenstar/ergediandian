//
//  TBSlider.m
//  ergediandian
//
//  Created by peanut on 2019/10/14.
//  Copyright © 2019 小白王. All rights reserved.
//

#import "TBSlider.h"

@implementation TBSlider
- (CGRect)trackRectForBounds:(CGRect)bounds {
    return CGRectMake(0, (self.bounds.size.height - 4)/2.0, self.bounds.size.width, 4);
}
@end
