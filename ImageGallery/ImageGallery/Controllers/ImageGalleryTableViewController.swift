//
//  ImageGalleryTableViewController.swift
//  ImageGallery
//
//  Created by 6ai on 14/04/2020.
//  Copyright © 2020 6ai. All rights reserved.
//

import UIKit

class ImageGalleryTableViewController: UITableViewController {
    private var imageGalleries: [Gallery] = []
    private var recentlyDeletedGalleries: [Gallery] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        createImageGallery()
        segueToImageGallery(with: 0)
    }

    private func segueToImageGallery(with index: Int) {
        splitViewController?.showDetailViewController(imageGalleries[index].navigationVC, sender: nil)
    }

    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        let addBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createImageGallery))
        navigationItem.rightBarButtonItem = addBarItem
    }

    @objc private func createImageGallery() {
        let imageGalleriesExistNames = imageGalleries.map { $0.name }
        let uniqueGalleryName = "Untitled".madeUnique(withRespectTo: imageGalleriesExistNames)
        let imageGallery = Gallery(name: uniqueGalleryName)
        imageGalleries.append(imageGallery)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension ImageGalleryTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        segueToImageGallery(with: indexPath.row)
    }
}

// MARK: - UITableViewDataSource

extension ImageGalleryTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? imageGalleries.count : recentlyDeletedGalleries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = indexPath.section == 0 ?
                imageGalleries[indexPath.row].name : recentlyDeletedGalleries[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            recentlyDeletedGalleries.append(imageGalleries[indexPath.row])
            imageGalleries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}