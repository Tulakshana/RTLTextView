//
//  ViewController.m
//  RTLTextView
//
//  Created by Tulakshana on 5/29/15.
//  Copyright (c) 2015 Tulakshana. All rights reserved.
//

#import "ViewController.h"

#define FONT_USED @"A_Faseyha"
#define FONT_SIZE 25

@interface ViewController ()<UITextViewDelegate>{
    IBOutlet UITextView *tView;
    CGRect previousRect;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    tView.font = [UIFont fontWithName:FONT_USED size:FONT_SIZE];
    [tView setSpellCheckingType:UITextSpellCheckingTypeNo];
    [tView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [tView setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    previousRect = CGRectZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextView Delegate
-(BOOL) textView:(UITextView*) textView shouldChangeTextInRange:(NSRange) range replacementText:(NSString*) text {
//    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.start];
//    NSLog(@"shouldChangeTextInRange - Cursor: x %f, y %f",rect.origin.x,rect.origin.y);
    
    if ([self shouldReverse:text]) {
        [self reverseText:textView range:range newText:text];
        [self wrapText:textView];
        return FALSE;
    }
    return TRUE;

}


- (void)textViewDidChange:(UITextView *)textView{
    
    [self wrapText:textView];

    
}

#pragma mark -

- (void)wrapText:(UITextView *)textView{
    NSMutableArray *linesArray = [NSMutableArray arrayWithArray:[textView.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]];
    NSInteger length = 0;
    for (int i = 0; i < [linesArray count]; i++) {
        NSString *line = [linesArray objectAtIndex:i];
        length += [line length]+1;
        CGSize sz = [line sizeWithAttributes:[NSDictionary dictionaryWithObject:textView.font forKey:NSFontAttributeName]];
        if( sz.width >= textView.bounds.size.width-15 ) {
            NSMutableArray* words = [NSMutableArray arrayWithArray: [line componentsSeparatedByString: @" "]];
            NSString* first_word = words[0];
            [words removeObjectAtIndex: 0];
            [linesArray replaceObjectAtIndex:i withObject:[words componentsJoinedByString: @" "]];
            if ((i+1)>=[linesArray count]) {
                [linesArray addObject:first_word];
            }else {
                [linesArray insertObject:first_word atIndex:i+1];
            }

            textView.text = [linesArray componentsJoinedByString:@"\n"];
            
            length -= [first_word length]+1;
            textView.selectedRange = NSMakeRange(length, 0);
            [textView scrollRangeToVisible:NSMakeRange(length, 0)];
            break;
        }
    }
    
}

- (void)reverseText:(UITextView *)textView range:(NSRange)range newText:(NSString *)text{
//    NSLog(@"text: %@\nrange:%ld,%ld",text,(unsigned long)range.length,(unsigned long)range.location);
    NSString *before = [textView.text substringToIndex:range.location];
//    NSLog(@"before: %@", before);
    NSString *after = [textView.text substringFromIndex:range.location];
//    NSLog(@"after: %@", after);
    
    textView.text = [NSString stringWithFormat:@"%@%@%@",before,text,after];

    textView.selectedRange = range;
    [textView scrollRangeToVisible:range];
}

- (BOOL)shouldReverse:(NSString *)text{
    NSRange numberRange = [text rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    NSRange symbolRange = [text rangeOfCharacterFromSet:[NSCharacterSet symbolCharacterSet]];
    
    
    return (numberRange.location == NSNotFound) && (symbolRange.location == NSNotFound) && ![self isNewLine:text] && ([text length]>0);
    
}

- (BOOL)isNewLine:(NSString *)text{
    NSRange newlineRange = [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]];
    return (newlineRange.location != NSNotFound);
}

@end
