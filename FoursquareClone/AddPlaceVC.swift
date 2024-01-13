//ekranlar arası veri/data taşımak için 3 seçenek var
/*
 1.preferSegue ile aktarmak görsel olcağındnan dolayı pek önerilmedi
 2. global değişken oluşturup aktarmak tavsiye edilmez profesyonel hayatt olmaz
 3.Singletın yapısı kullanmak
 
 */

import UIKit

class AddPlaceVC: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var placenameText: UITextField!
    @IBOutlet weak var placetypeText: UITextField!
    @IBOutlet weak var placeatmosphereText: UITextField!
    @IBOutlet weak var placeimageview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //imageView tıklama özelliği getirme ve uygulama
        placeimageview.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        placeimageview.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        if placenameText.text != "" && placetypeText.text != "" && placeatmosphereText.text != "" {
            if let chosenImage = placeimageview.image {
                let addPlaceModel = AddPlaceModel.sharedInstance
                
                addPlaceModel.placeName = placenameText.text!
                addPlaceModel.placeType = placetypeText.text!
                addPlaceModel.placeAtmosphere = placeatmosphereText.text!
                addPlaceModel.placeImage = chosenImage
                
                
                performSegue(withIdentifier: "toMapVC", sender: nil)
            }
        }else{
         makeAlert(titleInput: "Error", messageInput: "Place Name / Type / Atmosphere???")
        }
        
        
       
    }
    
    //tıklandıktan sonra
    @objc func chooseImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
        
    }
    
    //seçildikten sonra
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeimageview.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    func makeAlert(titleInput : String , messageInput : String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
}
