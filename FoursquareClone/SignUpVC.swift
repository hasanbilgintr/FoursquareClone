/*https://parseplatform.org

Parse açık kaynaklıdır firebaseye göre kullanmak için back4app.com kullanıyoruz yada amazonun var biz back4app kullanıcaz

-Parseyi spm ile sdk indirmek için https://github.com/parse-community/Parse-SDK-iOS-OSX  bakabiliriz anlatmak gerekirse proje olup en üst çubuktan File-> add package dependencies.. tıklanır bu aratılır https://github.com/parse-community/Parse-SDK-iOS-OSX çıkan şey (Parse-SDK-iOS-OSX) add package diyip indirme işlemlerini yapar ardından listesini götsteriir onaylanır indirilen dış kütüphaneler ana klasörde build Phaseste  targets seçili olup -> link binary with librariestedir istenilen çıkartılabilir yada eklenebilir. Hata veren kütüphaneleri inceleyip çıkartabiliriz

-back4app gelerek kayıt ve giriş yapıldıktan sonra Build new App tıklanırsa  isim verilir nosql database seçtik create dedik a.ılan dashboarda databasemizi vardır hatta direk User sınıflarımız yer alır, üstte docs-> guideste dökümanlar yer alır incelenebilir öncelikle projeye parse entegrasyonu yapalım AppDelegatede yazdık 3 değer için dashboarddan App Settings->  Server Setting -> Core Settings-> settings tıklanır ordan App Id ,Client Key ve Parse Api Adres leri alıyoruz
*/

import UIKit
//eklendi
import ParseCore


class SignUpVC: UIViewController {
    
    @IBOutlet weak var usernnameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /*
         //ekleme
         //sınıf ekleme
         let parseObject = PFObject(className: "Fruits")
         //sınıfa kayıt ekleme
         parseObject["name"] = "Banana"
         parseObject["calories"] = 150
         
         //ekleme kontrolü
         parseObject.saveInBackground { success, error in
         if error != nil {
         print(error?.localizedDescription as Any)
         }else{
         print("uploaded")
         }
         }
         */
        
        
        
        /*
        //veri çekme
        //sınıfı bulduk
        let query = PFQuery(className : "Fruits")
        //sorguya şart ekleme
        //buna eşitse name kolonun "Apple" olanı yada olanları getir
        //query.whereKey("name", equalTo: "Apple")
        
        //calorisi 120den büyük olanları getirelim
        query.whereKey("calories", greaterThan: 120)
        
        //az olanı getir
        //query.whereKey("calories", lessThan: 100)
        
        //buna eşit olmayanı yada olmayanları getir
        //query.whereKey("name", notEqualTo:  "Apple")
        
        //çekerken kontrol
        query.findObjectsInBackground { objects, error in
            if error != nil {
                print(error?.localizedDescription)
            }else {
                print(objects)
            }
        }
        */
        
        
        
        
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        if usernnameText.text != "" && passwordText.text != "" {
            //user name ve password bölede alınabilir
            PFUser.logInWithUsername(inBackground: usernnameText.text!, password: passwordText.text!) { user, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }else{
                    
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                    //print("giriş yapıldı")
                    //print(user?.username)
                }
            }
        }else{
            makeAlert(titleInput: "Error", messageInput: "Username / Password")
        }
    }
    @IBAction func signUpClicked(_ sender: Any) {
        if usernnameText.text != "" && passwordText.text != "" {
            
        //Kullanıcı oluşturma
            //şifreyi 2 hane kabul etti
            let user = PFUser()
            user.username = usernnameText.text!
            user.password = passwordText.text!
            
            user.signUpInBackground { succes, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }else{
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                    //self.makeAlert(titleInput: "Succes", messageInput: "OK")
                }
            }

        }else{
            makeAlert(titleInput: "Error", messageInput: "Username / Password")
        }
    }
    
    func makeAlert(titleInput : String , messageInput : String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    //bir mesela ViewController.swift dosyasının heryerden adını değiştirmek istersek olan dosyasının için girip class ViewController daki ViewController seçip sağ tıklayıp Refactor-> Rename diyip ismini heryerden değiştirmiş oluruz
    
}

