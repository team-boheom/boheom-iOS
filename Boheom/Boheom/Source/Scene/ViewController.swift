//
//  ViewController.swift
//  Boheom
//
//  Created by 조병진 on 1/14/24.
//

import UIKit
import SnapKit
import Then

class ViewController: UIViewController {

    private let lable = UILabel().then {
        $0.text = "H1>>>!"
        $0.font = .headerH1Thin
        $0.textColor = .gray500
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .gray150
        view.addSubview(lable)
        lable.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

}

