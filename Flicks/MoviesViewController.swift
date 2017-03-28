//
//  MoviesViewController.swift
//  Flicks
//
//  Created by alan_hamlett on 3/26/17.
//  Copyright © 2017 Alan Hamlett. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  @IBOutlet weak var tableView: UITableView!

  var movies: [NSDictionary]?
  var apiResource: String!
  var errorHeaderView: UIView?

  var apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"

  override func viewDidLoad() {
    super.viewDidLoad()

    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refreshControlAction), for: UIControlEvents.valueChanged)
    tableView.insertSubview(refreshControl, at: 0)

    tableView.dataSource = self
    tableView.delegate = self

    setupErrorView()

    fetchMovies()
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

  func showLoadingIndicator() {
    MBProgressHUD.showAdded(to: view, animated:true)
  }

  func hideLoadingIndicator() {
    MBProgressHUD.hide(for: view, animated: true)
  }

  func setupErrorView() {
    errorHeaderView = MainErrorView(frame: CGRect(x: 0, y: 60, width: 375, height: 60))
    errorHeaderView?.backgroundColor = UIColor.black
    errorHeaderView?.isHidden = true
    view.addSubview(errorHeaderView!)
    errorHeaderView?.setNeedsDisplay()
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: (errorHeaderView?.frame.size.width)!, height: (errorHeaderView?.frame.size.height)!))
    label.textAlignment = NSTextAlignment.center
    label.textColor = UIColor.white
    label.text = "Networking Error"
    errorHeaderView?.addSubview(label)
  }

  func showError() {
    errorHeaderView?.isHidden = false
  }

  func hideError() {
    errorHeaderView?.isHidden = true
  }

  func fetchMovies() {
    hideError()
    showLoadingIndicator()
    let urlString = "https://api.themoviedb.org/3/movie/\(apiResource!)?api_key=\(apiKey)"
    let url = URL(string: urlString)
    let request = NSURLRequest(
      url: url! as URL,
      cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
      timeoutInterval: 10)

    let session = URLSession(
      configuration: URLSessionConfiguration.default,
      delegate: nil,
      delegateQueue: OperationQueue.main)

    let task: URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: {
      (dataOrNil, response, error) in
        self.hideLoadingIndicator()
        if let data = dataOrNil {
          if let responseDictionary = try! JSONSerialization.jsonObject(
            with: data, options:[]) as? NSDictionary {
            //print("response: \(responseDictionary)")
            self.movies = responseDictionary["results"] as? [NSDictionary]
            self.tableView.reloadData()
          } else {
            self.showError()
          }
        } else {
          self.showError()
        }
    })
    task.resume()
  }

  func refreshControlAction(_ refreshControl: UIRefreshControl) {
    fetchMovies()
    refreshControl.endRefreshing()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let cell = sender as! UITableViewCell
    let indexPath = tableView.indexPath(for: cell)
    let movie = movies![(indexPath!.row)]

    let movieDetailsViewController = segue.destination as! MovieDetailViewController
    movieDetailsViewController.movie = movie
  }


}
