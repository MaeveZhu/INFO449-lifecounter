import UIKit

class HistoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    // Array to store history entries
    var historyEntries: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create and set up table view if not connected in storyboard
        if tableView == nil {
            tableView = UITableView(frame: view.bounds, style: .plain)
            tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(tableView)
        }
        
        // Set up table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
        
        // Set title
        title = "Game History"
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        cell.textLabel?.text = historyEntries[indexPath.row]
        return cell
    }
} 
