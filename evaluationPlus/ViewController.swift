//:::
import UIKit
//:
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    //:
    @IBOutlet weak var txt_student_name: UITextField!
    @IBOutlet weak var tbv_student_name: UITableView!
    @IBOutlet weak var btnAddStudent: UIButton!
    //:
    typealias studentName = String
    typealias assignment = String
    typealias note = Double
    //:
    let userDefaultsObj = UserDefaultsManager()
    var studentNotes: [studentName: [assignment: note]]!
    //:
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserDefaults()
    }
    //:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentNotes.count
    }
    //:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        cell.textLabel?.text = [studentName](studentNotes.keys)[indexPath.row]
        cell.textLabel?.text = studentNotes.sorted(by: {$0.key < $1.key})[indexPath.row].key
        cell.textLabel?.font = UIFont(name:"Champagne & Limousines", size:20)
        return cell
    }
    //:
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = tableView.cellForRow(at: indexPath)?.textLabel?.text
        userDefaultsObj.setKey(theValue: name as AnyObject, theKey: "name")
        performSegue(withIdentifier: "seg", sender: nil)
    }
    //:
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let name = [studentName](studentNotes.keys)[indexPath.row]
            studentNotes[name] = nil
            userDefaultsObj.setKey(theValue: studentNotes as AnyObject, theKey: "notes")
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    //: Pour cacher le clavier
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //:
    func loadUserDefaults() {
        if userDefaultsObj.doesKeyExist(theKey: "notes") {
            studentNotes = userDefaultsObj.getValue(theKey: "notes") as! [studentName: [assignment: note]]
        } else {
            studentNotes = [studentName: [assignment: note]]()
        }
    }
    //:
    @IBAction func addStudents(_ sender: UIButton) {
        if sender.alpha == 0.5 {
            return
        }
        if txt_student_name.text != "" {
            studentNotes[txt_student_name.text!] = [assignment: note]()
            txt_student_name.text = ""
            userDefaultsObj.setKey(theValue: studentNotes as AnyObject, theKey: "notes")
            tbv_student_name.reloadData()
            txt_student_name.resignFirstResponder()
        }
    }
    //:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        btnAddStudent.alpha = 1.0
    }
    //:
}
//:::
