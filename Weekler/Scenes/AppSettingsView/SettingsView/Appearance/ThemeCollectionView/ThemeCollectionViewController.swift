//
//  ThemeCollectionViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 17.12.2024.
//

import UIKit


class ThemeCollectionViewController: UICollectionViewController {
    
    private enum ThemeReuseIdentifiers {
        static let darkModeIdentifier = "darkModeIdentifier"
        static let themeIdentifier = "themeIdentifier"
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView.register(
            ThemeCollectionViewCell.self,
            forCellWithReuseIdentifier: ThemeReuseIdentifiers.themeIdentifier
        )
        self.collectionView.register(
            DarkModeCollectionViewCell.self,
            forCellWithReuseIdentifier: ThemeReuseIdentifiers.darkModeIdentifier
        )

        // Do any additional setup after loading the view.
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThemeReuseIdentifiers.darkModeIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

}
