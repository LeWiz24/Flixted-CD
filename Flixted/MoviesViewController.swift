//
//  ViewController.swift
//  Flixted
//
//  Created by Mario Olivares on 9/21/22.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        // An array with information on movie fields like title, description, etc.
        let movie = movies[indexPath.row]
        
        // Creates variable with information
        
        let title = movie["title"]
        
        let description = movie["overview"]
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        
        let posterPath = movie["poster_path"] as! String
        
        let posterUrl = URL(string: baseUrl + posterPath)
        
        
        // Prints title, overview and poster image
        
        cell.titleLabel.text = title as? String
        cell.descriptionLabel.text = description as? String
        cell.posterView.af.setImage(withURL: posterUrl!)
        
        
        return cell
    }
    
    
    // Properties variables available for lifetime of screen
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Hello World")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Network Request Snippet copied from CodePath
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    
                    
                 self.movies = dataDictionary["results"] as! [[String: Any]]
                 
                 self.tableView.reloadData()
                 print(dataDictionary)
                 
                 
                 
                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data

             }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("Loading the next page")
        
        // Find the selecte movie
        let cell = sender as! UITableViewCell
        
        let indexPath = tableView.indexPath(for: cell)
        
        let movie = movies[indexPath!.row]
        
        // Pass the selected movie to details view
        
        let detailsViewController = segue.destination as! MovieDetailsViewController
        
        detailsViewController.movie = movie
        
        // Clears the selection
        tableView.deselectRow(at: indexPath!, animated: true)
        
    }
            


}

