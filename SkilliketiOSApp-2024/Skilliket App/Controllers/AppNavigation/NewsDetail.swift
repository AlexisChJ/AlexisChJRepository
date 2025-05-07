//
//  NewsDetail.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 06/10/24.
//

import UIKit

class NewsDetail: UIViewController {
    var news: News?
    
    @IBOutlet weak var titleNews: UILabel!
    @IBOutlet weak var content: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleNews.layer.shadowColor = UIColor.darkGray.cgColor
        titleNews.layer.shadowOpacity = 0.5
        titleNews.layer.shadowOffset.width = .zero
        titleNews.layer.shadowOffset.height = 4
        titleNews.addLine(position: .bottom, color: .darkGray, width: 0.75)
        
        if let news = news{
            titleNews.text = news.name
            content.text = news.description
        }
    }


}
