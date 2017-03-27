//
//  MoviesViewController.swift
//  Flicks
//
//  Created by alan_hamlett on 3/26/17.
//  Copyright © 2017 Alan Hamlett. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  @IBOutlet weak var tableView: UITableView!

  var movies: [NSDictionary]?

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.dataSource = self
    tableView.delegate = self

    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
    let request = NSURLRequest(
      url: url! as URL,
      cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
      timeoutInterval: 10)

    let session = URLSession(
      configuration: URLSessionConfiguration.default,
      delegate: nil,
      delegateQueue: OperationQueue.main)

    let task: URLSessionDataTask = session.dataTask(with: request as URLRequest,
      completionHandler: { (dataOrNil, response, error) in
        if let data = dataOrNil {
          if let responseDictionary = try! JSONSerialization.jsonObject(
            with: data, options:[]) as? NSDictionary {
            print("response: \(responseDictionary)")
            self.movies = responseDictionary["results"] as? [NSDictionary]
            self.tableView.reloadData()
          }
        }
    })
    task.resume()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let movies = movies {
      return movies.count
    } else {
      return 0
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    print("tableView")
    let movie = movies![indexPath.row]
    let title = movie["title"] as! String
    let overview = movie["overview"] as! String
    let posterBaseUrl = "https://image.tmdb.org/t/p/w500"
    let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieViewCell
    cell.titleLabel.text = title
    cell.overviewLabel.text = overview
    if let posterPath = movie["poster_path"] as? String {
      let posterUrl = NSURL(string:posterBaseUrl + posterPath)
      cell.moviePosterView.setImageWith(posterUrl as! URL)
    }

    return cell
  }

  func didRefresh() {
    print("didRefresh")
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    print("prepare called")
    let cell = sender as! UITableViewCell
    let indexPath = tableView.indexPath(for: cell)
    let movie = movies![(indexPath!.row)]

    let movieDetailsViewController = segue.destination as! MovieDetailViewController
    movieDetailsViewController.movie = movie
  }


}
