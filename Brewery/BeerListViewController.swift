//
//  BeerListViewController.swift
//  Brewery
//
//  Created by 신새별 on 2022/03/22.
//

import UIKit


class BeerListViewController: UITableViewController {
  var beerList = [Beer]()
  var currentPage = 1
  var dataTasks = [URLSessionTask]()
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //UINavigationBar
    title = "별브루어리"
    navigationController?.navigationBar.prefersLargeTitles = true
    
    // UITableView 설정
    tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
    tableView.rowHeight = 150
    tableView.prefetchDataSource = self
    
    fetchBeer(of: currentPage)
  }
}


//UITableView DataSource, Delegate
extension BeerListViewController: UITableViewDataSourcePrefetching {

  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return beerList.count
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    print("cellForRowAt: \(indexPath.row)")
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListCell", for: indexPath) as? BeerListCell else { return UITableViewCell() }
  
    let beer = beerList[indexPath.row]
    cell.configure(with: beer)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedBeer = beerList[indexPath.row]
    let detailViewController = BeerDetailViewController()
    
    detailViewController.beer = selectedBeer
    self.show(detailViewController, sender: nil)
    
  }
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    guard currentPage != 1 else { return }
    
    indexPaths.forEach { ix in
      if (ix.row + 1)/25 + 1 == currentPage {
        self.fetchBeer(of: currentPage)
      }
    }
  }
}

// Data Feching
private extension BeerListViewController {
  func fetchBeer(of page: Int) {
    guard let url = URL(string: "https://api.punkapi.com/v2/beers/?page=\(page)"),
    dataTasks.firstIndex(where: { task in
      task.originalRequest?.url == nil
    }) == nil
    else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    let dataTask = URLSession.shared.dataTask(with: request) {[weak self] data, res, err in
      guard err == nil,
              let self = self,
              let res = res as? HTTPURLResponse,
              let data = data,
              let beer = try? JSONDecoder().decode([Beer].self, from: data) else {
                NSLog("ERROR: URLSession data task \(err?.localizedDescription ?? "")")
                return
      }
      switch res.statusCode {
      case (200...299): // 성공
        self.beerList += beer
        self.currentPage += 1
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      case (400...499): // 클라이언트 에러
        print("""
          ERROR: Client ERROR \(res.statusCode)
          Response: \(res)
       """)
      case (500...599): // 서버 에러
        print("""
          ERROR: Server ERROR \(res.statusCode)
          Response: \(res)
       """)
      default:
        print("""
          ERROR: \(res.statusCode)
          Response: \(res)
       """)
      }
    }
    dataTask.resume()
    dataTasks.append(dataTask)
  }
}

