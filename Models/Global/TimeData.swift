//
//  Data.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine
import CoreData

final class TimeData: ObservableObject {
    
    init(projects: [Project]){
        self.projects = projects
        self.terms.projects = projects
    }
    
    /// the `Project`s the user is filtering for
    @Published var terms = SearchTerms()
    
    
    // MARK:- Projects
    /// List of the user's `Project`s
    @Published var projects: [Project]
    var projectsPipe: AnyCancellable? = nil
    
    /**
     Use Combine to make an async network request for all the User's `Project`s
     */
    func fetchProjects(user: User?, context: NSManagedObjectContext) -> Void {
        /// abort if user is not logged in
        guard let user = user else { return }
        
        /// API URL documentation:
        /// https://github.com/toggl/toggl_api_docs/blob/master/chapters/workspaces.md#get-workspace-projects
        let request = formRequest(
            url: URL(string: "\(API_URL)/workspaces/\(user.chosen.wid)/projects?user_agent=\(user_agent)")!,
            auth: auth(token: user.token)
        )
        
        projectsPipe = URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(
                type: [Project].self,
                /// pass `managedObjectContext` to decoder so that a CoreData object can be created
                decoder: JSONDecoder(context: context)
            )
            /// if there was an error, just assign self (leaving `projects` unchanged
            .replaceError(with: self.projects)
            .receive(on: DispatchQueue.main)
            .map {
                /// save newly created CoreData objects
                try! context.save()
                return $0
            }
            .assign(to: \.projects, on: self)
    }
}
