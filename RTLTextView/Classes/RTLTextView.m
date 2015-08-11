//
//  RTLTextView.m
//  RTLTextView
//
//  Created by Tulakshana on 8/11/15.
//  Copyright (c) 2015 Tulakshana. All rights reserved.
//

#import "RTLTextView.h"

#import "RTLTextViewDelegate.h"

@interface RTLTextView ()

@property (nonatomic,strong)RTLTextViewDelegate *textViewDelegate;

@end

@implementation RTLTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self commonInit];
}

- (id)init{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    self.textViewDelegate = [[RTLTextViewDelegate alloc]init];
    self.delegate = self.textViewDelegate;
    
    [self setSpellCheckingType:UITextSpellCheckingTypeNo];
    [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self setTextAlignment:NSTextAlignmentRight];
}

@end
