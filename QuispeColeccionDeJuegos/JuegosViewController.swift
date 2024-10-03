//
//  JuegosViewController.swift
//  QuispeColeccionDeJuegos
//
//  Created by Ribeyro Guzman on 2/10/24.
//

import UIKit

class JuegosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tituloTextField: UITextField!
    
    var imagePiker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePiker.delegate = self
    }
    
    @IBAction func agregarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let juego = Juego(context: context)
        juego.titulo = tituloTextField.text
        juego.imagen = imageView.image?.jpegData(compressionQuality: 0.50)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
        
    }
    @IBAction func fotosTapped(_ sender: Any) {
        imagePiker.sourceType = .photoLibrary
        present(imagePiker, animated: true, completion: nil)

    }
    @IBAction func camaraTapped(_ sender: Any) {
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagenSeleccionada = info[.originalImage]as? UIImage
        imageView.image = imagenSeleccionada
        imagePiker.dismiss(animated: true, completion: nil)
    }
}
