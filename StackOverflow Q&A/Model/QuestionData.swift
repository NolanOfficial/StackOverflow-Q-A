//
//  QuestionData.swift
//  StackOverflow Q&A
//
//  Created by Nolan Fuchs on 1/8/19.
//  Copyright © 2019 Nolan Fuchs. All rights reserved.
//

import Foundation
import UIKit


class QuestionsData: Decodable {
    let items: [Tags]?
}

struct Tags: Decodable {
//    let tags: [String]?
    let owner: Owner?
//    let is_answered: Bool?
//    let view_count: Int?
    let answer_count: Int?
//    let score: Int?
//    let last_activity_date: Int?
//    let creation_date: Int?
    let question_id: Int?
    let link: String?
    let title: String?
}

struct Owner: Decodable {
//    let reputation: Int?
//    let user_id: Int?
//    let user_type: String?
//    let accept_rate: Int?
    let profile_image: String?
    let display_name: String?
//    let link: String?
}



class AnswersData: Decodable {
    let items: [AnswersInfo]?
}

struct AnswersInfo: Decodable {
    
    let owner: AnswersOwner?
    let is_accepted: Bool?
    let score: Int?
    let last_activity_date: Int?
    let last_edit_date: Int?
    let creation_date: Int?
    let answer_id: Int?
    let question_id: Int?
    let body_markdown: String?
    
}

struct AnswersOwner: Decodable {
    //    let reputation: Int?
    //    let user_id: Int?
    //    let user_type: String?
    //    let accept_rate: Int?
    let profile_image: String?
    let display_name: String?
    //    let link: String?
}

class BodyQuestionData: Decodable {
    let items: [moreTags]?
}

struct moreTags: Decodable {
   
    let owner: OriginalOwner?
    let body_markdown : String?
}

struct OriginalOwner: Decodable {
    let body_markdown : String?

}

