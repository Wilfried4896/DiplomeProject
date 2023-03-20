
import UIKit

struct SettingSection {
    var title: String
    var cell: [DetailItem]
}

struct DetailItem {
    var createdCell: () -> UITableViewCell
    var action: ((DetailItem) -> Void)?
}

protocol DetailViewModelDelegate: AnyObject {
    func personelData()
    func signOut()
    func carrer()
    func eduction()
    func interests()
    func changeImage()
}

class DetailViewModel: NSObject {
    static let identifier = "SettingCell"
    
    private var tableSections = [SettingSection]()
    private var delegate: DetailViewModelDelegate?
    private var account: User?
    
    init(delegate: DetailViewModelDelegate, account: User?) {
        super.init()
        self.delegate = delegate
        self.account = account
        configuration()
    }
    
    private func configuration() {
        let account = SettingSection(
            title: "Account",
            cell: [
                DetailItem(
                    createdCell: {
                        let cell = AccountInfoViewCell(style: .subtitle, reuseIdentifier: Self.identifier)
                        if let account = self.account, let image = account.profileImage, let name = account.name {
                            cell.imageSfSymbole.image = UIImage(data: image)
                            cell.nameAccount.text = name
                            cell.accessoryType = .disclosureIndicator
                        }
                        
                        return cell
                    },
                    action: { [weak self] _ in  self?.delegate?.personelData()}
                ),
                DetailItem(
                    createdCell: {
                        let cell = ParametersViewCell(style: .subtitle, reuseIdentifier: Self.identifier)
                        cell.imageSfSymbole.image = UIImage(named: "icamera")
                        cell.accessoryType = .disclosureIndicator
                        cell.nameAccount.text = "Change image profile"
                        return cell
                    },
                    action: { [weak self] _ in self?.delegate?.changeImage()}
                )
            ])
        
        let parameters = SettingSection(
            title: "Parameters",
            cell: [
                DetailItem(
                    createdCell: {
                        let cell = ParametersViewCell(style: .subtitle, reuseIdentifier: Self.identifier)
                        cell.imageSfSymbole.image = UIImage(named: "career-ladder")
                        cell.accessoryType = .disclosureIndicator
                        cell.nameAccount.text = "Career"
                        return cell
                    },
                    action: { [weak self] _ in self?.delegate?.carrer()}
                ),
                DetailItem(
                    createdCell: {
                        let cell = ParametersViewCell(style: .subtitle, reuseIdentifier: Self.identifier)
                        cell.imageSfSymbole.image = UIImage(named: "student")
                        cell.accessoryType = .disclosureIndicator
                        cell.nameAccount.text = "Eduction"
                        return cell
                    },
                    action: { [weak self] _ in self?.delegate?.eduction()}
                ),
                DetailItem(
                    createdCell: {
                        let cell = ParametersViewCell(style: .subtitle, reuseIdentifier: Self.identifier)
                        cell.imageSfSymbole.image = UIImage(named: "interests")
                        cell.accessoryType = .disclosureIndicator
                        cell.nameAccount.text = "Interests"
                        return cell
                    },
                    action: { [weak self] _ in self?.delegate?.interests()}
                )
            ])
        
        let signOut = SettingSection(
            title: "sign Out",
            cell: [
                DetailItem(
                    createdCell: {
                        let cell = ParametersViewCell(style: .subtitle, reuseIdentifier: Self.identifier)
                        cell.imageSfSymbole.image = UIImage(named: "icons")
                        cell.nameAccount.text = "Sign Out"
                        cell.nameAccount.tintColor = .systemRed
                        return cell
                    },
                    action: { [weak self] _ in  self?.delegate?.signOut()}
                )
            ])
        
        tableSections = [account, parameters, signOut]
    }
}

extension DetailViewModel: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        tableSections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableSections[section].cell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableSections[indexPath.section].cell[indexPath.row]
        return cell.createdCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableSections[indexPath.section].cell[indexPath.row]
        cell.action?(cell)
    }
  
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return tableSections[section].title
        }
}
