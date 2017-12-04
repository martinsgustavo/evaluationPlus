//:::
import UIKit
//:
class GradeController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    //:
    @IBOutlet weak var lbl_student_name: UILabel!
    //:
    @IBOutlet weak var assignment_field: UITextField!
    @IBOutlet weak var note_field: UITextField!
    @IBOutlet weak var saveAssignmentAndGrade: UIButton!
    //:
    @IBOutlet weak var assignment_note_tableview: UITableView!
    //:
    @IBOutlet weak var lbl_average: UILabel!
    @IBOutlet weak var lbl_r3: UILabel!
    //:
    typealias studentName = String
    typealias assignment = String
    typealias note = Double
    typealias sur = Double
    //:
    let userDefaultsObj = UserDefaultsManager()
    var studentNotes: [studentName: [assignment: note]]!
    var arrOfAssignments: [assignment]!
    var arrOfNotes: [note]!
    //:
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserDefaults()
        let name = userDefaultsObj.getValue(theKey: "name") as! String
        lbl_student_name.text = name
        fillUpArrays()
    }
    //:
    func calculateAverage(arrOfNotes: [Double], averageClosure: (_ sum: Double, _ numberOfGrades: Double   ) -> Double) -> Double {
        var sum: Double = 0
        for gr in arrOfNotes {
            sum += gr
        }
        return averageClosure(sum, Double(arrOfNotes.count))
    }
    //:
    func loadUserDefaults() {
        if userDefaultsObj.doesKeyExist(theKey: "notes") {
            studentNotes = userDefaultsObj.getValue(theKey: "notes") as! [studentName: [assignment: note]]
        } else {
            studentNotes = [studentName: [assignment: note]]()
        }
    }
//    //: PRA QUE SERVE ISSO?????
//    func loadAssignmentAndNote() {
//        let name = lbl_student_name.text
//        let assignment_and_note = studentNotes[name!]
//        let the_assignment = [assignment](assignment_and_note!.keys)[0]
//        let the_note = [note](assignment_and_note!.values)[0]
//        assignment_field.text = the_assignment
//        note_field.text = String(the_note)
//    }
    //:
    func fillUpArrays() {
        let name = lbl_student_name.text
        let assignments_and_notes = studentNotes[name!]
        arrOfAssignments = [assignment](assignments_and_notes!.keys)
        arrOfNotes = [note](assignments_and_notes!.values)
        let numberOfAssignments = 30 * (Double(arrOfNotes.count))
        
        lbl_average.text = String(format: "Average : %0.1f / 30.0", calculateAverage(arrOfNotes: arrOfNotes){$0 / $1})
        lbl_r3.text = produitCroise(arrNotes: arrOfNotes, notesSur: numberOfAssignments, convertionSur: 100, regle3: {$0 * $2 / $1})
    }
    //:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfAssignments.count
    }
    //:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = assignment_note_tableview.dequeueReusableCell(withIdentifier: "proto")!
        if let aCourse = cell.viewWithTag(100) as! UILabel! {
            aCourse.text = arrOfAssignments[indexPath.row]
        }
        if let aGrade = cell.viewWithTag(101) as! UILabel! {
            aGrade.text = String(arrOfNotes[indexPath.row])
        }
        return cell
    }
    //:
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let name = lbl_student_name.text!
            var course_grade = studentNotes[name]!
            let arrCourses = [assignment](course_grade.keys)
            let theCourse = arrCourses[indexPath.row]
            course_grade[theCourse] = nil
            studentNotes[name] = course_grade
            userDefaultsObj.setKey(theValue: studentNotes as AnyObject, theKey: "notes")
            fillUpArrays()
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    //:
    @IBAction func save_assignment_and_grade(_ sender: UIButton) {
        if sender.alpha == 0.5 {
            return
        }
        let name = lbl_student_name.text
        var student_courses = studentNotes[name!]
        student_courses![assignment_field.text!] = Double(note_field.text!)
        studentNotes[name!] = student_courses
        userDefaultsObj.setKey(theValue: studentNotes as AnyObject, theKey: "notes")
        fillUpArrays()
        assignment_note_tableview.reloadData()
        cleanerFields()
        assignment_field.resignFirstResponder()
    }
    //: Pour cacher le clavier
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //Fonction pour vider les champs
    func cleanerFields() {
        note_field.text = ""
        assignment_field.text = ""
        saveAssignmentAndGrade.alpha = 0.5
    }
    func produitCroise(arrNotes: [Double], notesSur: Double, convertionSur: Double, regle3: (_ note: Double, _ sur: Double, _ convertion: Double) -> Double) -> String {
        let somme = arrNotes.reduce(0, +)
        let conversion = regle3(somme, notesSur, convertionSur)
        return String(format: "Grade : %0.1f/%0.1f or %0.1f/%0.1f", somme, notesSur, conversion, convertionSur)
    }
    @IBAction func sldNotes(_ sender: UISlider) {
        note_field.text = String(format: "%0.1f", sender.value)
    }
    //:
    func textFieldDidBeginEditing(_ textField: UITextField) {
            saveAssignmentAndGrade.alpha = 1.0
    }
    //:
}
//:::

