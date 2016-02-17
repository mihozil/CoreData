//
//  RateView.h
//  CoreData
//
//  Created by Apple on 2/16/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RateView : UIView <UIGestureRecognizerDelegate>
@property (nonatomic, assign) int maxStars;
@property (nonatomic, strong) NSMutableArray* imgViews;
@property (nonatomic, assign) int rateNo;


@end
