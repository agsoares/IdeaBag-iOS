//
//  IdeaViewController.swift
//  IdeaBag
//
//  Created by Adriano Soares on 28/02/17.
//  Copyright © 2017 Adriano Soares. All rights reserved.
//

import UIKit
import ReactiveReSwift
import Hero

class IdeaViewController: UIViewController {

    private let disposeBag = SubscriptionReferenceBag()

    @IBOutlet weak var titleTextField: UITextField!

    var selectedIdea: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.heroID = "newIdeaView"
        isHeroEnabled = true

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        disposeBag += mainStore.observable.subscribe { [weak self] state in
            self?.selectedIdea = state.selectedIdea
            if let selectedIdea = state.selectedIdea {
                self?.titleTextField.text = state.ideas[selectedIdea]["title"] as? String
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        if let selectedIdea = self.selectedIdea {
            print("\(selectedIdea)")
            return
        }
        if let title = self.titleTextField.text {
            if !title.isEmpty {
                APIManager.shared.AddIdea(title: title).then { action in
                    mainStore.dispatch(action)
                }.catch { error in
                    print(error.localizedDescription)
                }
            }
        }
        
        disposeBag.dispose()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
