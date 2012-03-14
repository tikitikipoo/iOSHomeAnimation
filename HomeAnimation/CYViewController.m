//
//  CYViewController.m
//  HomeAnimation
//
//  Created by tikitikipoo on 11/09/01.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CYViewController.h"
#import "CYScrollView.h"
#import "CYCardView.h"

@interface CYViewController ()

// カードを作成
-(void) createCards:(UIScrollView*)toView;

@end

@implementation CYViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // スクロールビュー生成
    _scrollView = [[CYScrollView alloc] init];
    
    // 生成元ビューコントローラーを設定
    [_scrollView setTargetView:self];
    
    // スクロール認識領域を設定。ナビゲーションバーとツールバーの高さを考慮 
    // 64.0ナビゲーションバーの高さ 44.0ツールバーの高さ
    [_scrollView setContentInset:UIEdgeInsetsMake(0.0, 0.0, 5.0, 0.0)];
    
    // カード作成
    [self createCards:_scrollView];
    
    // スクロール領域設定 
    CGSize size = CGSizeMake(CARD_WIDTH * CARD_COLUMNS + (CARD_MARGIN * (CARD_COLUMNS + 1) ), 
                             CARD_ROWS * CARD_HEIGHT + ((CARD_ROWS + 2) * CARD_MARGIN));
    [_scrollView setFrame:CGRectMake(0, 0, size.width, size.height)];
    [_scrollView setContentSize:CGSizeMake( size.width, size.height)];
    [_scrollView autorelease];
    
    [self.view addSubview:_scrollView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

//----------------------------------------------------------------------------//
#pragma mark - カード関連の処理
//----------------------------------------------------------------------------//

- (void) createCards:(CYScrollView*)toView;
{  
    UIColor *cardColors[] = {
        [UIColor blueColor],
        [UIColor brownColor],
        [UIColor grayColor],
        [UIColor greenColor],
        [UIColor orangeColor],
        [UIColor purpleColor],
        [UIColor redColor],
        [UIColor magentaColor],
        [UIColor yellowColor],
    };
    
    toView.cardCount    = CARD_COLUMNS * CARD_ROWS;
    toView.cardFrame    = [[NSMutableArray alloc] init];
    toView.cardForFrame = [[NSMutableArray alloc] init];
    
    [toView.cardFrame release];
    [toView.cardForFrame release];
    
    // カラー数
    int cardColorCount = sizeof(cardColors) / sizeof(cardColors[0]);
    
    // カードキー
    int cardIndex = 0;
    
    for (int row = 0; row < CARD_ROWS; ++row) {
        
        for (int col = 0; col < CARD_COLUMNS; ++col) {
            
            // tikitikipooのindexを算出
            cardIndex = (row * CARD_COLUMNS) + col;
            
            CGRect frame = CGRectMake(CARD_MARGIN + col * (CARD_MARGIN + CARD_WIDTH),
                                      CARD_MARGIN + row * (CARD_MARGIN + CARD_HEIGHT),
                                      CARD_WIDTH, CARD_HEIGHT);
            
            
            // tikitikipooの初期表示時の位置情報を保持していおく
            // 各tikitikipooの位置が変更しても、この値を基にtikitikipooの位置を決定していく
            [toView.cardFrame addObject:[NSValue valueWithCGRect:frame]];
            
            // カード作成
            CYCardView* card = [[CYCardView alloc] initWithFrame:frame];
            [card setCardIndex: cardIndex];
            [card setDelegate: toView];
            [card setBackgroundColor:cardColors[cardIndex % cardColorCount]];
            [card autorelease];
                        
            // tikitikipooの判別をするためにcardIndexと同様の値を添字でtikitikipooの情報を格納
            // tikitikipooがどこにあるかを判別する
            [toView.cardForFrame addObject:card];
            
            [toView addSubview: card];
        }
    }
}


@end
