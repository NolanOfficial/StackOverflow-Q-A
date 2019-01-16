//
//  AnswersController.swift
//  StackOverflow Q&A
//
//  Created by Nolan Fuchs on 1/9/19.
//  Copyright © 2019 Nolan Fuchs. All rights reserved.
//

import UIKit
import Kingfisher

class AnswersController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Data and classes
    var continueData = [QuestionsData]()
    var answerData = [AnswersData]()
    var bodyData = [BodyQuestionData]()
    let network = Network()
   
    // Destination Variables
    var answers: Int? = 0
    var currentQuestionTitle: String = ""
    var currentOwner: String = ""
    var currentProfileImage: UIImage?
    var link: String = ""
    var questionID: Int = 0
    var answerBody: String = ""
    var jsonCount: Int? = 0
    
    // Json Link Variables
    var answerJsonLink = ""
    var bodyQuestion = ""
    
    // UITableView
    @IBOutlet weak var answersDataTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answersDataTable.delegate = self
        answersDataTable.dataSource = self
        
        // links for the body question API and answers API
        answerJsonLink = "https://api.stackexchange.com/2.2/questions/\(questionID)/answers?order=desc&sort=activity&site=stackoverflow&filter=!9Z(-wzftf"

        bodyQuestion = "https://api.stackexchange.com/2.2/questions/\(questionID)?order=desc&sort=activity&site=stackoverflow&filter=!9Z(-wwK4f"
        
        // JSON Call Methods
        jsonAnswersDownload()
        jsonBodyQuestionDownload()
        
        
    }
    
    // Deriving data for the paticular question
    fileprivate func jsonBodyQuestionDownload() {
        // Deriving Data for the Body of the Question
        guard let urlBodyQuestion = URL(string: bodyQuestion) else { return }
        network.urlStartSession(url: urlBodyQuestion) { (data) in
            do {
                let myData = try JSONDecoder().decode(BodyQuestionData.self, from: data)
                self.bodyData = [myData]
                self.jsonCount = self.bodyData[0].items?.count
                // Waits for data to be stored before loading all data
                DispatchQueue.main.async {
                    self.answersDataTable.reloadData()
                }
            } catch let jsonErr {
                print(jsonErr)
            }
        }
    }
    
      // Deriving data for the answers of the corresponding question
    fileprivate func jsonAnswersDownload() {
        guard let url = URL(string: answerJsonLink) else { return }
        network.urlStartSession(url: url) { (data) in
            do {
                let myData = try JSONDecoder().decode(AnswersData.self, from: data)
                self.answerData = [myData]
                // Waits for data to be stored before loading all data
                DispatchQueue.main.async {
                    self.answersDataTable.reloadData()
                }
            } catch let jsonErr {
                print(jsonErr)
            }
        }
    }

    
    func openUrl() {
        if let url = URL(string: link) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // All answers + question + previous display
       return answers! + 3
    }
    
    
    // Individiual Cells for the Table View
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Previous Question Cell
        if indexPath.row == 0 {
        let cell = answersDataTable.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionsDisplayCell
        
        cell.questionOwnerName?.text = currentOwner
        cell.questionTitle?.text = currentQuestionTitle
        cell.questionNumberOfAnswers?.text = "# of Answers: \(answers!)"
        cell.questionProfilePicture?.layer.cornerRadius = 20
        cell.questionProfilePicture?.clipsToBounds = true
        cell.questionProfilePicture?.image = currentProfileImage
        
        return cell
        }
            
        // Clickable Full Question Cell
        else if indexPath.row == 1 {
             let cell1 = answersDataTable.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath) as! AnswersDisplayCell
            if jsonCount ?? 0 < 1 {
            return cell1
            } else {
                cell1.answerBody.text = self.bodyData[0].items?[0].body_markdown
                return cell1
            }
        }
        // Answer Label Cell
        else if indexPath.row == 2 {
            let defaultCell = answersDataTable.dequeueReusableCell(withIdentifier: "answerTitle")
            defaultCell?.textLabel?.text = "Answers:"
            return defaultCell!
        }
          
        // Answers to corresponding question cell(s)
        else {
            let cell2 = answersDataTable.dequeueReusableCell(withIdentifier: "otherAnswers", for: indexPath) as! OtherAnswersCell
            if jsonCount ?? 0 < 1 {
            return cell2
            }
            else {
                cell2.answerName?.text = self.answerData[0].items?[indexPath.row - 3].owner?.display_name
                cell2.answerText?.text = self.answerData[0].items?[indexPath.row - 3].body_markdown
                
                // Downloading picture data from the API + optional default picture calls
                let url = URL(string: (self.answerData[0].items?[indexPath.row-3].owner?.profile_image ?? "http://s3.amazonaws.com/37assets/svn/765-default-avatar.png"))
                self.cacheImage(imageView: &cell2.answerProfilePicture!, url: url!)
                return cell2
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            openUrl()
        } 
    }
    
    func cacheImage(imageView: inout UIImageView, url: URL) {
        let processor = DownsamplingImageProcessor(size: (imageView.frame.size))
            >> RoundCornerImageProcessor(cornerRadius: 20)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "default.png"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
}

