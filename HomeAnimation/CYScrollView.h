//
//  CYScrollView.h
//  HomeAnimation
//
//  Created by tikitikipoo on 11/09/01.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYCardView.h"

@interface CYScrollView : UIScrollView <CardDelegate>
{
    int                         _cardCount;
    NSMutableArray*             _cardFrame;         // 各tikitikipooの基準となるframe値を格納
    NSMutableArray*             _cardForFrame;      // 各tikitikipooの情報を格納
    NSMutableArray*             _cardDictionaries;  // カードキーワードの情報を格納　DBから重複な値を取得しないよう
    
    int                         _heldFrameIndex;    // 保持tikitikipooインデックス
    CGPoint                     touchStartLocation; // タッチ開始ポイント
    CGPoint                     heldStartLocation;  // 保持開始ポイント

}


@property (nonatomic, assign)   id              targetView;
@property (nonatomic)           int             cardCount;
@property (nonatomic, retain)   NSMutableArray* cardFrame;
@property (nonatomic, retain)   NSMutableArray* cardForFrame;
@property (nonatomic)           int             heldFrameIndex;

@end
