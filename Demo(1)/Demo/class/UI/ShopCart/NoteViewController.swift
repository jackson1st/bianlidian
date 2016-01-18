//
//  NoteViewController.swift
//  Demo
//
//  Created by 黄人煌 on 15/12/28.
//  Copyright © 2015年 Fjnu. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    var delegate: OkDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
    }

}


extension NoteViewController: UITextViewDelegate{
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(range.location >= 50){
            return false
        }
        else {
            if(range.location == 0) {
                placeHolderLabel.hidden = false
            }
            else {
                placeHolderLabel.hidden = true
            }
             numLabel.text = "\(range.location + 1)/50"
            return true
        }
    }
    @IBAction func addNoteButtonAction(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject(textView.text, forKey: SD_OrderInfo_Note)
        delegate?.returnOk("true")
        self.navigationController?.popViewControllerAnimated(true)
    }
}