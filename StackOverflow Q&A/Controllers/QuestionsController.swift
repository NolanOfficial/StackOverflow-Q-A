//
//  QuestionsController.swift
//  StackOverflow Q&A
//
//  Created by Nolan Fuchs on 1/8/19.
//  Copyright © 2019 Nolan Fuchs. All rights reserved.
//

import UIKit
import Kingfisher

class QuestionsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // UITableView
    @IBOutlet weak var questionsDataTable: UITableView!
    
    // Labels and constructor
    var allData = [QuestionsData]()
    let jsonURL = "https://api.stackexchange.com/2.2/search?order=desc&sort=activity&intitle=swift&site=stackoverflow"
    var arrayCount: Int? = 1
    var fetchingMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadURL()
        questionsDataTable.delegate = self
        questionsDataTable.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        questionsDataTable.reloadData()
    }
    
    // Downloads data from the given url and stores it within an Array
    fileprivate func downloadURL() {
        guard let url = URL(string: jsonURL) else { return }
        urlStartSession(url: url) { (data) in
            do {
                let myData = try JSONDecoder().decode(QuestionsData.self, from: data)
                
                self.allData = [myData]
                self.arrayCount = self.allData[0].items?.count
                
                // Waits for data to be stored before loading all data
                DispatchQueue.main.async {
                    self.questionsDataTable.reloadData()
                    
                }
            } catch let jsonErr {
                print(jsonErr)
                
            }
        }
    }
    
    // Converts the status bar into a lighter shade for better visuals
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = questionsDataTable.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionsDisplayCell
    
        if arrayCount ?? 1 < 2 {
            print("Loading...")
            return cell
        }
        else {
            let url = URL(string: (self.allData[0].items?[indexPath.row].owner?.profile_image) ?? "http://s3.amazonaws.com/37assets/svn/765-default-avatar.png")
            self.cacheImage(imageView: &cell.questionProfilePicture!, url: url!)
            cell.questionTitle?.text = (self.allData[0].items![indexPath.row].title)
            cell.questionOwnerName?.text = self.allData[0].items![indexPath.row].owner?.display_name
            cell.questionNumberOfAnswers?.text = "# of Answers: \(self.allData[0].items![indexPath.row].answer_count ?? -1)"
            return cell
            
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return arrayCount ?? 1
    }
    
    // This allows data to be easily transferable (could use UserDefaults but for a simple task this could be done as well)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        let pushedIndexPath: IndexPath = self.questionsDataTable.indexPathForSelectedRow!
        let destination: AnswersController = segue.destination as! AnswersController
        destination.continueData = allData
        destination.answers = allData[0].items?[pushedIndexPath.row].answer_count
        destination.currentQuestionTitle = (allData[0].items?[pushedIndexPath.row].title)!
        destination.currentOwner = (allData[0].items?[pushedIndexPath.row].owner?.display_name)!
        destination.link = (allData[0].items?[pushedIndexPath.row].link)!
        destination.questionID = (allData[0].items?[pushedIndexPath.row].question_id)!
        
        // Pulled a random defualt avatar picture from the internet as a default in case the optional fails
        let url = URL(string: (self.allData[0].items?[pushedIndexPath.row].owner?.profile_image ?? "http://s3.amazonaws.com/37assets/svn/765-default-avatar.png"))
        let data = try? Data(contentsOf: url!)
        if let imageData = data {
            destination.currentProfileImage = UIImage(data: imageData) ?? UIImage(named: "default.png")
        }
    }
    
    // UI Image Caching
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
     
    // Infinite Scrolling (Pagination)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height {
            if !fetchingMore {
                print("Fetching More Data")
                beginBatchFetch()
            }
        }
    }

    func beginBatchFetch() {
        fetchingMore = true
        DispatchQueue.main.async {
            // Where JSON call will implement
            self.fetchingMore = false
//          self.questionsDataTable.reloadData()
            
        }
    }

}

extension QuestionsController {
    
    func urlStartSession(url: URL, completion: @escaping (Data) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if err != nil {
                print(err ?? "Error with URL Session")
            } else {
                guard let data = data else { return }
                completion(data)
            }
        }.resume()
    }
}


