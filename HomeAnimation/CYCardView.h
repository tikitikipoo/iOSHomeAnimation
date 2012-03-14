//
//  CYCardView.h
//  HomeAnimation
//
//  Created by tikitikipoo on 11/09/01.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CardDelegate;

@interface CYCardView : UIView
{
    id <CardDelegate>   _delegate;
    int                 _cardIndex;         // 識別子
}

@property (nonatomic, assign) id <CardDelegate> delegate;
@property int cardIndex;


@end

//------------------------------------------------------------
#pragma mark - CardDelegate protocol
//------------------------------------------------------------

@protocol CardDelegate <NSObject>

- (void)touchesBegancardView:(CYCardView*)view withTouches:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)touchesMovedcardView:(CYCardView*)view withTouches:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)touchesEndedcardView:(CYCardView*)view withTouches:(NSSet*)touches withEvent:(UIEvent*)event;
@end
