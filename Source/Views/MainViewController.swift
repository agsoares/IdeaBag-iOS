//
//  MainViewController.swift
//  IdeaBag
//
//  Created by Adriano Soares on 18/02/17.
//  Copyright © 2017 Adriano Soares. All rights reserved.
//

import UIKit
import ReactiveReSwift
import Hero

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

        self.navigationController?.isHeroEnabled = true
        isHeroEnabled = true

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)

        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.backgroundView = refreshControl
        }

        self.floatingBottomBar.heroID = "newIdeaView"

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(newIdeaTouched(_:)))
        self.floatingBottomBar.addGestureRecognizer(tapRecognizer)

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

    @IBAction func newIdeaTouched(_ sender: Any) {
        self.performSegue(withIdentifier: "ideaSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ideaSegue" {
            if let heroID = sender as? String {
                let vc = segue.destination as? IdeaViewController
                vc?.view.heroID = heroID
            }
        }
    }

    func configureLayout() {
        self.floatingBottomBar.layer.masksToBounds = false

        self.floatingBottomBar.layer.shadowColor   = UIColor.black.cgColor
        self.floatingBottomBar.layer.shadowRadius  = 1
        self.floatingBottomBar.layer.shadowOpacity = 0.9
        self.floatingBottomBar.layer.shadowOffset  = CGSize(width: 0, height: 0.5)
        self.floatingBottomBar.layer.shouldRasterize = true

        self.tableView.separatorStyle  = .none
        self.tableView.backgroundColor = UIColor.backgroundColor

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ideaCell") {
            if let title = ideas[indexPath.row]["title"] as? String {
                let titleLabel = cell.viewWithTag(1) as? UILabel
                titleLabel?.text = title
            }
            if let id = ideas[indexPath.row]["id"] as? String, let bgView = cell.viewWithTag(99) {
                bgView.heroID = id
            }
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.masksToBounds = false

        cell.layer.shadowColor   = UIColor.black.cgColor
        cell.layer.shadowRadius  = 1.0
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowOffset  = CGSize(width: 0, height: 0.75)
        cell.layer.shouldRasterize = true
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self .tableView(tableView, cellForRowAt: indexPath)
        performSegue(withIdentifier: "ideaSegue", sender: cell.viewWithTag(99)?.heroID)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ideas.count
    }
}
