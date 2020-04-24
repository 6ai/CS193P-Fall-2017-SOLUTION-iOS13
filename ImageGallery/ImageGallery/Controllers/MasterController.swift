//
//  ImageGalleryTableViewController.swift
//  ImageGallery
//
//  Created by ccoleridge on 14/04/2020.
//  Copyright © 2020 ccoleridge. All rights reserved.
//

import UIKit

class MasterController: UITableViewController {
    var imageGalleries: [ImageGallery] = []
    let cellId = "reuseIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        let addBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarItemPressed))
        navigationItem.rightBarButtonItem = addBarItem
        createImageGallery()
        segueToImageGallery(with: 0)


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @objc func addBarItemPressed() {
        createImageGallery()
    }

    private func createImageGallery() {
        let imageGalleriesExistNames = imageGalleries.map { $0.name }
        let uniqueGalleryName = "Untitled".madeUnique(withRespectTo: imageGalleriesExistNames)
        let imageGallery = ImageGallery(name: uniqueGalleryName)
        imageGalleries.append(imageGallery)
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return imageGalleries.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        segueToImageGallery(with: indexPath.row)
    }

    private func segueToImageGallery(with index: Int) {
        splitViewController?.showDetailViewController(imageGalleries[index].navigationVC, sender: nil)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = imageGalleries[indexPath.row].name
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            imageGalleries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
