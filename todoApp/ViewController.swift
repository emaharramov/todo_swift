import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [TodoItem] = []
    let coreDataHelper = CoreDataHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CustomTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchItems()
    }
    
    func fetchItems() {
        self.items = coreDataHelper.fetchItems()
        reloadTableView()
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Item", message: "What's your next plan?", preferredStyle: .alert)
        alert.addTextField()
        
        let submitButton = UIAlertAction(title: "Add", style: .default) { _ in
            if let text = alert.textFields?.first?.text, !text.isEmpty {
                self.coreDataHelper.addItem(title: text)
                self.fetchItems()
            }
        }
        
        alert.addAction(submitButton)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Search", message: "Enter text to search", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Search..." }
        
        let searchAction = UIAlertAction(title: "Search", style: .default) { _ in
            if let searchText = alert.textFields?.first?.text, !searchText.isEmpty {
                self.items = self.coreDataHelper.searchItems(searchText: searchText)
                self.reloadTableView()
            }
        }
        
        alert.addAction(searchAction)
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        let item = items[indexPath.row]
        cell.configure(with: item.title ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        let alert = UIAlertController(title: "Edit Item", message: "What's your new item?", preferredStyle: .alert)
        alert.addTextField { $0.text = item.title }
        
        let saveButton = UIAlertAction(title: "Save", style: .default) { _ in
            if let newText = alert.textFields?.first?.text {
                self.coreDataHelper.updateItem(item: item, newTitle: newText)
                self.fetchItems()
            }
        }
        
        alert.addAction(saveButton)
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
            let itemToRemove = self.items[indexPath.row]
            self.coreDataHelper.deleteItem(item: itemToRemove)
            self.fetchItems()
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    @IBAction func reloadPage(_ sender: Any) {
        fetchItems()
    }
}
