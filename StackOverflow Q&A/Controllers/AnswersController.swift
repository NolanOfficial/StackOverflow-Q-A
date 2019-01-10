//
//  AnswersController.swift
//  StackOverflow Q&A
//
//  Created by Nolan Fuchs on 1/9/19.
//  Copyright © 2019 Nolan Fuchs. All rights reserved.
//

import UIKit

class AnswersController: UIViewController, UITableViewDataSource, UITableViewDelegate {
     
    // Data from the previous segued destination
    var continueData = [QuestionsData]()
    var answerData = [AnswersData]()
    var bodyData = [BodyQuestionData]()
    var answers: Int? = 0
    var currentQuestionTitle: String = ""
    var currentOwner: String = ""
    var currentProfileImage: UIImage?
    var link: String = ""
    var questionID: Int = 0
    var answerBody: String = ""
    
    
    @IBOutlet weak var answersDataTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answersDataTable.delegate = self
        answersDataTable.dataSource = self
        
        // links for the body question API and answers API
        let answerJsonLink = "https://api.stackexchange.com/2.2/questions/\(questionID)/answers?order=desc&sort=activity&site=stackoverflow&filter=!9Z(-wzftf"
        let bodyQuestion = "https://api.stackexchange.com/2.2/questions/\(questionID)?order=desc&sort=activity&site=stackoverflow&filter=!9Z(-wwK4f"
        
        // turning the links into URL's
        guard let url = URL(string: answerJsonLink) else { return }
        guard let urlBodyQuestion = URL(string: bodyQuestion) else { return }
        
        // Deriving data for the answers of the corresponding question
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if err != nil {
                print(err ?? "Error with URL Session")
            } else {
                guard let data = data else { return }
                
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
            }.resume()
        
        // Deriving Data for the Body of the Question
        URLSession.shared.dataTask(with: urlBodyQuestion) { (data, response, err) in
            if err != nil {
                print(err ?? "Error with URL Session")
            } else {
                guard let data = data else { return }
                
                do {
                    
                    let myData = try JSONDecoder().decode(BodyQuestionData.self, from: data)
                    self.bodyData = [myData]
                    // Waits for data to be stored before loading all data
                    DispatchQueue.main.async {
                        self.answersDataTable.reloadData()
                    }
                } catch let jsonErr {
                    print(jsonErr)
                }
            }
            }.resume()
        
    }
  
    
    func openUrl() {
        if let url = URL(string: link) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // All answers + question + previous display
       return answers! + 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
        let cell = answersDataTable.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionsDisplayCell
        
        cell.questionOwnerName?.text = currentOwner
        cell.questionTitle?.text = currentQuestionTitle
        cell.questionNumberOfAnswers?.text = "# of Answers: \(answers!)"
        cell.questionProfilePicture?.image = currentProfileImage
        return cell
        }
            
        else if indexPath.row == 1 {
            let cell1 = answersDataTable.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath) as! AnswersDisplayCell
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            cell1.answerBody.text = self.bodyData[0].items?[0].body_markdown                
        }
            return cell1
        }
        
        else {
            let cell2 = answersDataTable.dequeueReusableCell(withIdentifier: "otherAnswers", for: indexPath) as! OtherAnswersCell
           
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                
            cell2.answerName?.text = self.answerData[0].items?[indexPath.row - 2].owner?.display_name
            cell2.answerText?.text = self.answerData[0].items?[indexPath.row - 2].body_markdown
                    
            let url = URL(string: (self.answerData[0].items?[indexPath.row-2].owner?.profile_image ?? "http://s3.amazonaws.com/37assets/svn/765-default-avatar.png"))
            let data = try? Data(contentsOf: url!)
            if let imageData = data {
            cell2.answerProfilePicture?.image = UIImage(data: imageData) ?? UIImage(named: "765-default-avatar.png")
                    }
            }
            
            return cell2
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            openUrl()
        } 
    }
    
    
}
