//
//  CYScrollView.m
//  HomeAnimation
//
//  Created by tikitikipoo on 11/09/01.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CYScrollView.h"


@interface CYScrollView ()

// ドラッグしたカードを移動させる関数
- (void)moveHeldcardToPoint:(UIView*)view :(CGPoint)location;

// カードインデックスから頭から数えたら何番目かを取得
- (int)frameIndexForcardIndex:(int)cardIndex;

// ドラッグしたカードを離したとき、カードを自動移動する関数
- (void)moveUnheldcardsAwayFromPointOfView:(UIView*)view :(CGPoint)location;

// カードインデックスから頭から数えたら何番目かを取得
- (int)frameIndexForcardIndex:(int)cardIndex;

// ドラッグしたカードに一番近い位置にある並び順のインデックス値を取得
- (int)indexOfClosestFrameToPoint:(CGPoint)point;

// シングルタップ
- (void)handleSingleTap;

// ダブルタップ
- (void)handleDoubleTap;

@end



@implementation CYScrollView

@synthesize targetView      = _targetView;
@synthesize cardCount       = _cardCount;
@synthesize cardFrame       = _cardFrame;
@synthesize cardForFrame    = _cardForFrame; 
@synthesize heldFrameIndex  = _heldFrameIndex;


-(id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self setMaximumZoomScale:1.0];
    [self setMinimumZoomScale:1.0];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setCanCancelContentTouches:NO];
    [self setMultipleTouchEnabled:NO];
    
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//-----------------------------------------------------------
#pragma mark - CardDelegate プロトコル関数
//-----------------------------------------------------------

/**
 * Cardをタップしたときに発火される関数
 */
-(void)touchesBegancardView:(CYCardView*)view withTouches:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    // スクロールビューを基にタッチした座標を取得
    touchStartLocation = [[touches anyObject] locationInView:self];
    
    // 保持したカードの中心点を取得
    heldStartLocation = [view center];
    
    // 並び順からのインデックス値取得
    _heldFrameIndex = [self frameIndexForcardIndex:view.cardIndex];
    
    // ビューの最前面に移動
    [self bringSubviewToFront:[_cardForFrame objectAtIndex:_heldFrameIndex]];
}


/**
 * Cardの指を移動したときに発火される関数
 */
-(void)touchesMovedcardView:(CYCardView*)view withTouches:(NSSet *)touches withEvent:(UIEvent *)event
{    
    
    _heldFrameIndex = [self frameIndexForcardIndex:view.cardIndex];
    
    // タッチハンドラオブジェクト取得
    UITouch* touch = [touches anyObject];
    
    // 画面のサイズを想定したpointを取得する
    //    CGPoint location = [touch locationInView:self.view];
    
    // スクロールビューのサイズを想定したpointを取得する
    CGPoint location = [touch locationInView:self];
    
    // ドラッグしたカードを移動させる関数
    [self moveHeldcardToPoint:view :location];
    [self moveUnheldcardsAwayFromPointOfView:view :location];
    
}

//-----------------------------------------------------------
#pragma mark - タップジェスチャ
//-----------------------------------------------------------

- (void)handleSingleTap {
    
}

- (void)handleDoubleTap {
    
}

/**
 * Cardの指を話したときに発火される関数
 */
-(void)touchesEndedcardView:(CYCardView*)view withTouches:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    
    if ([touch tapCount] == 1) {
        
        // [self performSelector:@selector(handleSingleTap) withObject:nil afterDelay:DOUBLE_TAP_DELAY];
        
    } else if([touch tapCount] == 2) {
        
        [self handleDoubleTap];
        
    }
    
    [UIView transitionWithView:view 
                      duration:0.3
                       options:UIViewAnimationOptionAllowUserInteraction
                    animations:^(void){
                        
                        
                        _heldFrameIndex = [self frameIndexForcardIndex:view.cardIndex];
                        view.frame = [[_cardFrame objectAtIndex:_heldFrameIndex] CGRectValue];    
                    }
                    completion:^(BOOL finished){}];

}

//-----------------------------------------------------------
#pragma mark - カード判別関数
//-----------------------------------------------------------

/**
 * カードの順番が入れ替わっても、カードのcardIndex値からfor文で回すことによって、
 * 頭から検索しカードの並び順を取得する
 */
- (int)frameIndexForcardIndex:(int)cardIndex
{
    for (int i = 0; i < _cardCount; ++i) {
        
        CYCardView* tmp = [_cardForFrame objectAtIndex:i];
        if (tmp.cardIndex == cardIndex) {
            return i;
        }
        
    }
    return 0;
}

/**
 * 
 * point:画面のタッチした座標
 */
- (int)indexOfClosestFrameToPoint:(CGPoint)point
{
    int index = 0;
    float minDist = FLT_MAX;
    
    for (int i = 0; i < _cardCount; ++i) {
        
        // カードの現在座標位置取得
        CGRect frame = [[_cardFrame objectAtIndex:i] CGRectValue];
        
        float dx = point.x - CGRectGetMidX(frame);
        float dy = point.y - CGRectGetMidY(frame);
        
        float dist = (dx * dx) + (dy * dy);
        
        if (dist < minDist) {
            
            index = i;
            minDist = dist;
        }
        
    }
    return index;
}


//-----------------------------------------------------------
#pragma mark - カード移動関数
//-----------------------------------------------------------

/**
 * ドラッグしたカードを移動させる関数
 */
- (void)moveHeldcardToPoint:(CYCardView*)view :(CGPoint)location
{
    
    float dx = location.x - touchStartLocation.x;
    float dy = location.y - touchStartLocation.y;
    
    CGPoint newPosition = CGPointMake(heldStartLocation.x + dx, heldStartLocation.y + dy);
    
    // カードの地点を変更
    view.center = newPosition;
}

/**
 * ドラッグしたカードを離したとき、カードを自動移動する関数
 */
- (void)moveUnheldcardsAwayFromPointOfView:(CYCardView*)view :(CGPoint)location;
{
    // 移動した位置に一番近いカードのインデックス値を取得(各カードの中心点を想定)
    int frameIndex = [self indexOfClosestFrameToPoint:location];
    
    // 移動した位置に一番近いがカードが自分以外だったら(各カードの中心点を想定)
    if (frameIndex != _heldFrameIndex) {
        
        // アニメーション開始
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        
        if (frameIndex < _heldFrameIndex) {
            // 保持したカードより前のカードに移動するとき            
            
            // 保持したカードから移動するカードまでのカードを想定
            for (int i = _heldFrameIndex; i > frameIndex; --i) {
                
                // 保持したカードから移動するカードまでのカードを取得
                CYCardView* movingcard = [_cardForFrame objectAtIndex:i-1];
                
                // カードの位置を移動する
                movingcard.frame = [[_cardFrame objectAtIndex:i] CGRectValue];
                
                // カードの位置を設置する
                [_cardForFrame replaceObjectAtIndex:i withObject:movingcard];
            }
        }
        else if (_heldFrameIndex < frameIndex) {
            // 保持したカードより後のカードに移動するとき
            
            // 保持したカードから移動するカードまでのカードを想定
            for (int i = _heldFrameIndex; i < frameIndex; ++i) {
                
                // 保持したカードから移動するまでのカードを取得
                CYCardView* movingcard = [_cardForFrame objectAtIndex:i+1];
                
                // カードの位置を移動する
                movingcard.frame = [[_cardFrame objectAtIndex:i] CGRectValue];
                
                // カードの位置を設置する
                [_cardForFrame replaceObjectAtIndex:i withObject:movingcard];
            }
        }
        
        // 保持したカードに移動した場所のインデックス値を設定
        _heldFrameIndex = frameIndex;
        
        // 保持したカードの移動場所を設定する
        [_cardForFrame replaceObjectAtIndex:_heldFrameIndex withObject:view];
        
        // アニメーション適用
        [UIView commitAnimations];
    }
    
}



@end
