//
//  RTLTextViewDelegate.m
//  RTLTextView
//
//  Created by Tulakshana on 8/11/15.
//  Copyright (c) 2015 Tulakshana. All rights reserved.
//

#import "RTLTextViewDelegate.h"



@interface RTLTextViewDelegate()



@end

@implementation RTLTextViewDelegate

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([self shouldReverse:string]) {
        [self reverseTextField:textField range:range newText:string];
        return FALSE;
    }
    return TRUE;
}

#pragma mark - UITextView Delegate
-(BOOL) textView:(UITextView*) textView shouldChangeTextInRange:(NSRange) range replacementText:(NSString*) text {
    //    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.start];
    //    NSLog(@"shouldChangeTextInRange - Cursor: x %f, y %f",rect.origin.x,rect.origin.y);
    
    if ([self shouldReverse:text]) {
        [self reverseTextView:textView range:range newText:text];
        [self wrapTextView:textView];
        return FALSE;
    }
    return TRUE;
    
}


- (void)textViewDidChange:(UITextView *)textView{
    //if text is not reversed this gets called
    [self wrapTextView:textView];
    
    
}

#pragma mark -



- (void)wrapTextView:(UITextView *)textView{
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

- (void)reverseTextView:(UITextView *)textView range:(NSRange)range newText:(NSString *)text{
    //    NSLog(@"text: %@\nrange:%ld,%ld",text,(unsigned long)range.length,(unsigned long)range.location);
    NSString *before = [textView.text substringToIndex:range.location];
    //    NSLog(@"before: %@", before);
    NSString *after = [textView.text substringFromIndex:range.location];
    //    NSLog(@"after: %@", after);
    
    textView.text = [NSString stringWithFormat:@"%@%@%@",before,text,after];
    
    textView.selectedRange = range;
    [textView scrollRangeToVisible:range];
}

- (void)reverseTextField:(UITextField *)textfield range:(NSRange)range newText:(NSString *)text{
    //    NSLog(@"text: %@\nrange:%ld,%ld",text,(unsigned long)range.length,(unsigned long)range.location);
    NSString *before = [textfield.text substringToIndex:range.location];
    //    NSLog(@"before: %@", before);
    NSString *after = [textfield.text substringFromIndex:range.location];
    //    NSLog(@"after: %@", after);
    
    textfield.text = [NSString stringWithFormat:@"%@%@%@",before,text,after];
    
    textfield.selectedTextRange = [textfield textRangeFromPosition:textfield.beginningOfDocument toPosition:[textfield positionFromPosition:textfield.beginningOfDocument offset:0]];
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
