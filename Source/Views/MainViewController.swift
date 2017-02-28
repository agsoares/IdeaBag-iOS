//
//  MainViewController.swift
//  IdeaBag
//
//  Created by Adriano Soares on 18/02/17.
//  Copyright © 2017 Adriano Soares. All rights reserved.
//

import UIKit
import ReactiveReSwift

class MainViewController: UIViewController {

    private let disposeBag = SubscriptionReferenceBag()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var floatingBottomBar: UIView!

    var ideas = [NSDictionary]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate   = self
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)

        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.backgroundView = refreshControl
        }

        configureLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        disposeBag += mainStore.observable.subscribe { [weak self] state in
            self?.ideas = state.ideas
            self?.tableView.reloadData()
        }

        mainStore.dispatch(LoadIdeas())
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disposeBag.dispose()
    }

    func refresh(_ refreshControl: UIRefreshControl) {
        mainStore.dispatch(LoadIdeas())
        refreshControl.endRefreshing()
    }

    @IBAction func addButtonTouched(_ sender: Any) {
        mainStore.dispatch(AddIdea(title: "Teste"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureLayout() {
        self.floatingBottomBar.layer.masksToBounds = false

        let shadowPath = UIBezierPath(rect: self.floatingBottomBar.bounds).cgPath
        self.floatingBottomBar.layer.shadowColor = UIColor.black.cgColor
        self.floatingBottomBar.layer.shadowOpacity = 0.7
        self.floatingBottomBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.floatingBottomBar.layer.shadowPath = shadowPath

    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let title = ideas[indexPath.row]["title"] as? String {
            cell.textLabel?.text = title
        }
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ideas.count
    }
}
