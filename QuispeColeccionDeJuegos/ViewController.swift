//
//  ViewController.swift
//  QuispeColeccionDeJuegos
//
//  Created by Ribeyro Guzman on 2/10/24.
//
import CoreData
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return juegos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let juego = juegos[indexPath.row]
        cell.textLabel?.text = juego.titulo
        cell.detailTextLabel?.text = "Categoría: \(juego.categoria ?? "Sin categoría")" // Mostrar la categoría
        cell.imageView?.image = UIImage(data: (juego.imagen!))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let juego = juegos[indexPath.row]
        performSegue(withIdentifier: "juegoSegue", sender: juego)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var juegos : [Juego] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isEditing = true
        
        navigationItem.rightBarButtonItem = editButtonItem
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Juego> = Juego.fetchRequest()
        
        // Ordenar los resultados por el atributo 'orden'
        let sortDescriptor = NSSortDescriptor(key: "orden", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            juegos = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Error al cargar los juegos: \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! JuegosViewController
        siguienteVC.juego = sender as? Juego
        siguienteVC.numeroDeJuegos = juegos.count
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Intercambiar los elementos en el array
            let movedJuego = juegos.remove(at: sourceIndexPath.row)
            juegos.insert(movedJuego, at: destinationIndexPath.row)
            
            // Actualizar el atributo 'orden' de todos los elementos
            for (index, juego) in juegos.enumerated() {
                juego.orden = Int64(index)
            }
            
            // Guardar los cambios en Core Data
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            do {
                try context.save()
            } catch {
                print("Error al guardar el nuevo orden: \(error)")
            }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let juegoToDelete = juegos[indexPath.row]
            
            // Eliminar el elemento de Core Data
            context.delete(juegoToDelete)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            // Eliminar el elemento del array
            juegos.remove(at: indexPath.row)
            
            // Actualizar la tabla
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
}

