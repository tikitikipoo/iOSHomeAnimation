//
//  CYCardView.m
//  HomeAnimation
//
//  Created by tikitikipoo on 11/09/01.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CYCardView.h"

@interface CYCardView (protocol)
- (void)touchesBegancardView:(CYCardView*)view withTouches:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)touchesMovedcardView:(CYCardView*)view withTouches:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)touchesEndedcardView:(CYCardView*)view withTouches:(NSSet*)touches withEvent:(UIEvent*)event;
@end


@implementation CYCardView

//--------------------------------------------------------------
#pragma mark - プロバティ
//--------------------------------------------------------------

@synthesize delegate    = _delegate;
@synthesize cardIndex   = _cardIndex;

//--------------------------------------------------------------
#pragma mark - 初期化
//--------------------------------------------------------------

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//--------------------------------------------------------------//
#pragma mark - ジェスチャーハンドリング
//--------------------------------------------------------------//
// すべて親階層にジェスチャー処理をまかす

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    // 親のviewに処理を回す
    if ([_delegate respondsToSelector:@selector(touchesBegancardView:withTouches:withEvent:)])
        [_delegate touchesBegancardView:self withTouches:touches withEvent:event];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if ([_delegate respondsToSelector:@selector(touchesMovedcardView:withTouches:withEvent:)])
        [_delegate touchesMovedcardView:self withTouches:touches withEvent:event];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_delegate respondsToSelector:@selector(touchesEndedcardView:withTouches:withEvent:)]) {
        [_delegate touchesEndedcardView:self withTouches:touches withEvent:event];
    }
}


@end
