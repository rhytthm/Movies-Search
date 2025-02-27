//
//  ViewController.swift
//  MovieSearch
//
//  Created by RAJEEV MAHAJAN on 27/02/25.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let viewModel = SearchVM()
    let tableView = UITableView()
    let searchField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search Movie...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        textField.textColor = .white
        textField.backgroundColor = .gray
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    let searchFieldView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Search Movie"
        setupViews()
    }
    
    func setupViews() {
        setupSearchField()
        setupTableView()
    }
    
    func setupSearchField() {
        searchFieldView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 40)
        view.addSubview(searchFieldView)
        searchFieldView.addSubview(searchField)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchFieldView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchFieldView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            searchFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchField.leadingAnchor.constraint(equalTo: searchFieldView.leadingAnchor, constant: 18),
            searchField.trailingAnchor.constraint(equalTo: searchFieldView.trailingAnchor, constant: -18),
            searchField.topAnchor.constraint(equalTo: searchFieldView.topAnchor),
            searchField.bottomAnchor.constraint(equalTo: searchFieldView.bottomAnchor, constant: -18)
        ])
        view.addSubview(tableView)
        searchField.delegate = self
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchFieldView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.movies?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.movies?.results[indexPath.row].title
        if let imageUrl = URL(string: MovieSceneEndpoints.image(path: viewModel.movies?.results[indexPath.row].imagePath).imgUrl ?? "") {
            URLSession.shared.dataTask(with: imageUrl, completionHandler: { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async(execute: {
                        cell.imageView?.image = image
                        cell.setNeedsLayout()
                    })
                }
            }).resume()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty == false {
            viewModel.getMoviews(searchText: text, completion: {
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            })
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()  // This dismisses the keyboard and triggers the end of editing
        return true
    }
}
