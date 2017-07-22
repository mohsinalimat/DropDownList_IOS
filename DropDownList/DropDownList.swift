//
//  DropDownList.swift
//  ShoppingCartApp
//
//  Created by Vikash Kumar on 22/07/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

//Class function
extension DropDownList {
    class func show(in view: UIView, listFrame senderFrame: CGRect, listData: ([String], String), actionHandler: @escaping (String)-> Void){
        let list = DropDownList(frame: view.bounds)
        list.listData = listData
        list.actionHandler = actionHandler
        
        list.alpha = 0
        //list.backgroundColor = UIColor.clear
        view.addSubview(list)
        
        list.setTableFrame(with: senderFrame)

        UIView.animate(withDuration: 0.2) {
            list.alpha = 1
        }
    }
}

//DropDown list
class DropDownList: UIView {
    var tableView = UITableView()
    var tblHeight: CGFloat = 120
    let cellHeight: CGFloat = 30
    
    let shadowLayer = CALayer()
    
    var listData: (items: [String], selectedItem: String) = ([], "") {
        didSet {
        }
    }
    
    var actionHandler: (String)-> Void = {_ in}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    deinit {
        print("list view removed")
    }
    
    
    private func setupViews() {
        
        //add background button for handle event for hide the dropdown
        let button = UIButton(frame: self.bounds)
        self.addSubview(button)

        tableView.frame = self.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.white
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 5
        self.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //add a shadow layer behide tableview
        shadowLayer.backgroundColor = UIColor.white.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        shadowLayer.cornerRadius = 3.0
        shadowLayer.shadowOpacity = 0.6
        shadowLayer.masksToBounds = false
        self.layer.insertSublayer(shadowLayer, at: 0)
        
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        
        button.addTarget(self, action: #selector(self.tapHandler(sender:)), for: .touchUpInside)
        
    }
    
    //handler for background button action for hide dropdownlist
    func tapHandler(sender: UIButton?) {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { (success) in
            self.removeFromSuperview()
        }
    }
    
    //Set table's frame at give position
    func setTableFrame(with senderFrame: CGRect) {
        if listData.items.count < 5 {
            tblHeight = cellHeight *  CGFloat(listData.items.count)
        }
        

        let y: CGFloat
        let showAtUpSide = (self.frame.height - senderFrame.origin.y) < (tblHeight + 10 )
        if showAtUpSide {
            y = senderFrame.origin.y - tblHeight - 10 - senderFrame.height
        } else {
            y = senderFrame.origin.y - 8
        }
        let listFrame = CGRect(x: senderFrame.origin.x, y: y, width: senderFrame.width, height: tblHeight)
        setDropDownFrame(rect: listFrame)
        

    }
    
    private func setDropDownFrame(rect: CGRect) {
        tableView.frame = rect
        shadowLayer.frame = tableView.frame
    }

}

extension DropDownList: UITableViewDataSource, UITableViewDelegate  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let item = listData.items[indexPath.row]
        cell.textLabel?.text = item
        cell.accessoryType = item == listData.selectedItem ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        actionHandler(listData.items[indexPath.row])
        self.tapHandler(sender: nil)
    }
    
}

