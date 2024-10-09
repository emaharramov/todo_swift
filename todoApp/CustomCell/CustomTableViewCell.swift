import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
