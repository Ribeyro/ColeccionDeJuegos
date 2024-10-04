//
//  JuegosViewController.swift
//  QuispeColeccionDeJuegos
//
//  Created by Ribeyro Guzman on 2/10/24.
//

import UIKit

class JuegosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categorias.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return categorias[row]
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tituloTextField: UITextField!
    @IBOutlet weak var agregarActualizarBoton: UIButton!
    @IBOutlet weak var categoriaPickerView: UIPickerView!
    
    
    var imagePiker = UIImagePickerController()
    var juego:Juego? = nil
    var numeroDeJuegos: Int = 0
    var categorias = ["Acción", "Aventura", "Puzzle", "Deportes"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePiker.delegate = self
        categoriaPickerView.delegate = self
        categoriaPickerView.dataSource = self
        if juego != nil {
            imageView.image = UIImage(data: (juego!.imagen!) as Data)
            tituloTextField.text = juego!.titulo
            agregarActualizarBoton.setTitle("Actualizar", for: .normal)
            
            if  let categoria = juego?.categoria {
                if let index = categorias.firstIndex(of: categoria) {
                    categoriaPickerView.selectRow(index, inComponent: 0, animated: true)
                }
            }
        }
    }

    
    @IBAction func agregarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let selectedCategoria = categorias[categoriaPickerView.selectedRow(inComponent: 0)]
        
                    
            if juego != nil {
                // Actualizar un juego existente
                juego!.titulo = tituloTextField.text!
                juego!.imagen = imageView.image?.jpegData(compressionQuality: 0.50)
                juego!.categoria = selectedCategoria
            } else {
                // Agregar un nuevo juego
                let nuevoJuego = Juego(context: context)
                nuevoJuego.titulo = tituloTextField.text!
                nuevoJuego.imagen = imageView.image?.jpegData(compressionQuality: 0.50)
                nuevoJuego.categoria = selectedCategoria
                nuevoJuego.orden = Int64(numeroDeJuegos)  // Usar el número de juegos como valor de orden
                
            }
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
